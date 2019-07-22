# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Reader
    #
    # Provides a pointer into a continuous substring of a larger string, without
    # allocating a new string (or whatever the type of the whole is). This saves
    # memory when many substrings are needed, or long substrings are needed. It
    # also makes #take, #drop, #[a,b], #[a..b] and #split_at run in constant time
    # and space rather than O(n).
    #
    # Each instance requires 40 bytes (in YARV), compared to making an actual
    # substring, which consumes 40 bytes plus the number of bytes above 20
    # which will be copied to the result. It also takes some CPU time to copy
    # from one string to the other.
    #
    # Some string operations (examples listed above) can be performed directly
    # on the pointer to delay the need to allocate new strings. Allocations
    # will happen automatically as needed, but you can also create a String by
    # calling `#reify`.
    #
    # NOTE: Pointer<S, E> is the type which represents storage of type S
    # that has items of type E. For example,
    #
    #   Pointer<Array, Integer>     # represents an array of integers
    #   Pointer<String, String>     # represents a string
    #
    class Pointer

      # When this object is not `#frozen?`, only one pointer references it.
      # In that case, certain operations can be optimized by destructively
      # updating `@storage` in place. However, when another pointer shares
      # with us, `@storage` will be frozen.
      #
      # NOTE: We can't know if there are references to `@storage` apart from
      # the ones created by this class. If there are outside references to
      # `@storage`, destructive updates to it may cause unexpected behavior.
      #
      # @return [S]
      attr_reader :storage

      # @return [Integer]
      attr_reader :offset

      # @return [Integer]
      attr_reader :length

      def initialize(storage, offset=0, length=storage.length)
        raise ArgumentError, "offset must be non-negative" if offset < 0
        raise ArgumentError, "length must be non-negative" if length < 0
        raise ArgumentError, "given length cannot exceed storage length" if length > storage.length

        @storage, @offset, @length =
          storage, offset, length
      end

      # @return [String]
      def inspect
        "#<%s %s@storage=0x%s @offset=%d @length=%d>" %
          [self.class.name.split("::").last,
           @storage.frozen? ? "-" : "+",
           (@storage.object_id << 1).to_s(16), @offset, @length]
      end

      # Convert this pointer back into a String (or whatever the underlying
      # type is).
      #
      # If this points to the entire length of the underlying object, then that
      # object may be returned without any allocations. Otherwise, the `#[a, b]`
      # method is called on the object. For most types, this will allocate a
      # new object and copy items into it.
      #
      # @return [S]
      def reify(always_allocate = false)
        if @storage.frozen? \
        and @offset == 0 \
        and @length == @storage.length \
        and not always_allocate
          #stderr.puts "reify: no allocation"
          @storage
        else
          # $stderr.puts "reify: allocate[#@offset, #@length]"
          @storage[@offset, @length]
        end
      end

      # @group Querying
      #########################################################################

      # @return [Boolean]
      def empty?
        @length <= 0
      end

      # @return [Boolean]
      def blank?
        empty?
      end

      # @return [Boolean]
      def present?
        not blank?
      end

      # @return [Boolean]
      def ==(other)
        if self.class == other.class
          if @storage.eql?(other.storage)
            @offset == other.offset and @length == other.length
          else
            length == other.length and reify == other.reify
          end
        else
          length == other.length and reify == other
        end
      end

      # @group Single Element Selection
      #########################################################################

      # Return the first element. If {empty?}, `nil` will be returned.
      #
      # @return [E]
      def head
        @storage[@offset] if @length > 0
      end

      # Return the last element. If {empty?}, `nil` will be returned.
      #
      # @return [E]
      def last
        @storage[@offset + @length - 1] if @length > 0
      end

      # True if `#at(n)` is defined.
      #
      # @return [Boolean]
      def defined_at?(n)
        raise ArgumentError, "argument must be non-negative" if 0 > n
        n < @length
      end

      # Return the nth element.
      #
      # @return [E]
      def at(n)
        raise ArgumentError, "argument must be non-negative" if 0 > n
        @storage[@offset + n] if @length > n
      end

      # @group Slicing
      #########################################################################

      # Return a new pointer with the first item removed.
      #
      # @return [Pointer<S, E>]
      def tail
        drop(1)
      end

      # When given a range or a start index and length, returns a new pointer
      # that spans the given indices. When given a single index, returns the
      # single element at that index.
      #
      #   cursor[n]     == cursor.at(n)
      #   cursor[a, b]  == cursor.drop(a).take(b)
      #   cursor[a...b] == cursor.drop(a).take(b)
      #   cursor[a..b]  == cursor.drop(a).take(b+1)
      #
      # @return [Pointer<S, E> | E]
      def [](offset, length=nil)
        if length.present?
          raise ArgumentError, "length must be non-negative" if 0 > length
          return nil if offset >= @length or offset < -@length

          offset += @length           if offset < 0
          length  = @length - offset  if length > @length - offset

          self.class.new(@storage.freeze, @offset + offset, length)

        elsif offset.kind_of?(Range)
          a = offset.begin
          b = offset.end

          a += @length if a < 0
          b += @length if b and b < 0

          return nil if a < 0 or a >= @length
          return nil if b and (b < 0 or b >= @length)

          if b.nil?
            length = @length - a
          else
            length  = b - a
            length += 1 unless offset.exclude_end?
          end

          self[a, length]

        else
          offset += @length if offset < 0
          @storage[@offset + offset] if @length > offset and offset >= 0
        end
      end

      alias_method :slice, :[]

      # Return a new pointer, skipping the first n items.
      #
      #   x = Pointer.new("eyeball")
      #   x.drop(5)   #=> "ll"
      #   x           #=> "eyeball"
      #
      # @return [Pointer<S, E>]
      def drop(n)
        raise ArgumentError, "argument must be non-negative" if n < 0
        n = @length if n > @length
        return self if n.zero?
        self.class.new(@storage.freeze, @offset + n, @length - n)
      end

      # Destructively update this pointer to start at the (n+1)th element.
      #
      #   x = Pointer.new("eyeball")
      #   x.drop!(5)  #=> "eyeba"
      #   x           #=> "ll"
      #
      # @return [Pointer<S, E>]
      def drop!(n)
        raise ArgumentError, "argument must be non-negative" if n < 0
        n        = @length if n > @length
        @offset += n
        @length -= n
        self
      end

      # Return a new pointer spanning only the first n items.
      #
      #   x = Pointer.new("eyeball")
      #   x.take(5)   #=> "eyeba"
      #   x           #=> "eyeball"
      #
      # @return [Pointer<S, E>]
      def take(n)
        raise ArgumentError, "argument must be non-negative" if n < 0
        n = @length if n > @length
        self.class.new(@storage.freeze, @offset, n)
      end

      # Destructively update this pointer to end at the nth element.
      #
      #   x = Pointer.new("eyeball")
      #   x.take!(5)  #=> "eyeba"
      #   x           #=> "eyeba"
      #
      # @return [Pointer<S, E>]
      def take!(n)
        raise ArgumentError, "argument must be non-negative" if n < 0
        n       = @length if n > @length
        @length = n
        self
      end

      # This method is equivalent to x.drop(n).take(m), but it allocates
      # one less object because the intermediate Pointer value isn't needed
      #
      # @return [Pointer<S, E>]
      def drop_take(drop, take)
        raise ArgumentError, "drop must be non-negative" if drop < 0
        raise ArgumentError, "take must be non-negative" if take < 0

        drop   = @length if drop > @length
        offset = @offset + drop
        length = @length - drop

        take = length if take > length
        self.class.new(@storage.freeze, offset, take)
      end

      # Split the Pointer in two at the given position by creating two new
      # Flyweights.
      #
      # @param [Integer] n number of items at which to split (`n > 0`)
      #
      # @return [Array(Pointer<S, E>, Pointer<S, E>)]
      def split_at(n)
        [take(n), drop(n)]
      end

      # @group Concatenation
      #########################################################################

      # Concatenate two flyweights to form a third.
      #
      # When the two flyweights are backed by the same storage object, and the
      # first pointer ends where the second begins, no allocation is needed
      # (only extending `@length`). Otherwise, at least partial copies of each's
      # `@storage` are made to create a third `@storage`.
      #
      # @return [Pointer<S, E>]
      def +(other)
        if @storage.eql?(other.storage) and @offset + @length == other.offset
          # allocations: 0 strings, 1 pointer
          self.class.new(@storage.freeze, @offset, @length + other.length)
        else
          # It doesn't make much sense to allocate two new operands and then
          # use `+` to allocate a third for the result.
          #
          # TODO: Should this be a new Pointer? Depends on how the result
          # will be used. If more concatenation is done, then it's a waste,
          # and slightly worse than plain String + String.
          #
          # allocations: 2 string, 0 pointers
          reify(true) << other.reify
        end
      end

      # @endgroup
      #########################################################################
    end

    class << Pointer

      # @group Constructors
      #########################################################################

      def build(object)
        case object
        when String
          StringPtr.new(object)
        when Array
          ArrayPtr.new(object)
        when Pointer
          object
        else
          raise TypeError, "object must respond to []" \
            unless object.respond_to?(:[])

          raise TypeError, "object must respond to length" \
            unless object.respond_to?(:length)

          Pointer.new(object)
        end
      end

      # @endgroup
      #########################################################################
    end

    class StringPtr < Pointer

      # @group Conversion Methods
      #########################################################################

      def_delegators :reify, :to_sym, :intern, :to_i, :to_d

      # This is called implicitly when we are used in String interpolation,
      # eg `"abc #{pointer} xyz"` or `"abc %s xyz" % pointer`.
      def to_s
        reify
      end

      # Used by String methods to coerce us into a compatible type.
      def to_str
        reify
      end

      # @group Matching
      #########################################################################

      # Match an unescaped anchor \A, \a, or ^, \Z, \z, $
      #
      # NOTE: These will match character class [^$], which aren't anchors, but
      # the regexp to exclude those is very gnarly and very noticeably slow.
      ANCHORS_A = /(?<!\\)(?:\\\\)*(?:\\[Aa]|[\^])/
      ANCHORS_Z = /(?<!\\)(?:\\\\)*(?:\\[Zz]|[\$])/

      # An implementation of `String#match?` optimized for string pointers. In
      # some cases, the substring needs to be allocated, but often no string
      # allocation is performed.
      #
      # NOTE: See `match_` below for code comments.
      #
      # @return [Boolean]
      def match?(pattern, offset=0, anchorless=false)
        if @length < 1024 and @storage.length - @offset > 1024
          # TODO: Run some experiments to test when reify is faster than not
          return reify.match?(pattern, offset)
        end

        if not anchorless and @offset != 0 \
          and ANCHORS_A.match?(pattern.inspect)
          return reify.match?(pattern)
        end

        if anchorless and @offset + @length != @storage.length \
          and ANCHORS_Z.match?(pattern.inspect)
          return reify.match?(pattern)
        end

        offset = @length if offset > length

        # Unfortunately we can't use pattern.match?, which doesn't allocate
        # a MatchData object, because we need to check bounds on the match
        m = pattern.match(@storage, offset + @offset)

        if m and m.begin(0) <= @offset + @length
          if m.end(0) <= @offset + @length
            true
          else
            @storage[m.begin(0), @offset + @length - m.begin(0)].match?(pattern)
          end
        else
          false
        end
      end

      # We can't correctly implement `String#match` here, because it returns
      # a {MatchData} that includes offsets and indexes relative to the whole
      # @storage, not the start of this pointer string.
      #
      # We can't update the MatchData to have adjusted offsets, but we return
      # the offset to let the caller make adjustments when needed.
      #
      # NOTE: The offset argument controls where the regex engine begins, but
      # it doesn't change which part anchors will match, like ^ $ \A \Z and
      # \z. For example, match(/^/, n) with n > 0, will never succeed because
      # ^ is at offset 0 of the substring. This behavior is the same as
      # String#match.
      #
      # NOTE: Some of the optimizations in this method require knowing whether
      # or not the given Regexp contains an anchor like ^ $ \A \Z and \z. Only
      # a quick test is performed, which can falsely detect an anchor; when an
      # anchor is detected, the substring must be allocated. If you know from
      # the call site that your Regexp does not have an anchor, call with
      # `anchorless = true` to skip the detection, thus avoiding an extra String
      # allocation.
      #
      # @return [MatchData, Integer]
      def match_(pattern, offset, anchorless=false)
        if @length < 1024 and @storage.length - @offset > 1024
          # TODO: Run some experiments to test when reify is faster than not
          #
          # We are pointing to a short segment, but there is still a very
          # long string that follows in @storage. There's no way to tell
          # the regexp engine to stop after a given offset, so it will start
          # at @offset and continue searching well past @offset + @length.
          #
          # It's faster at this point to allocate the relatively shorter
          # string, so the regexp engine has less work.
          return [reify.match(pattern), 0]
        end

        if not anchorless and @offset != 0 \
          and ANCHORS_A.match?(pattern.inspect)
          # We can't match on @storage.directly unless our @offset is 0,
          # because String#match(/^./, n) never matches unless n is 0.
          return [reify.match(pattern), 0]
        end

        if not anchorless and @offset + @length != @storage.length \
          and ANCHORS_Z.match?(pattern.inspect)
          # Because the pattern is anchored to the end, we can't match on
          # @storage directly, unless our end is also the end of @storage.
          return [reify.match(pattern), 0]
        end

        offset = @length if offset > length
        offset = @offset + offset
        m = pattern.match(@storage, offset)

        if m and m.begin(0) <= @offset + @length
          if m.end(0) <= @offset + @length
            # The entire match is inside the bounds
            [m, -@offset]
          else
            # The match starts within bounds but ends outside, so we need to
            # to allocate a copy. We minimize the cost by not copying all of
            # @storage[@offset, @length] when the match started after @offset
            tail = @storage[m.begin(0), @offset + @length - m.begin(0)]
            n    = tail.match(pattern, offset - m.begin(0))
            [n, m.begin(0)]
          end
        end
      end

      # Optimized to only allocate one string when two pointers don't share
      # the same storage. Otherwise no allocations are performed.
      #
      # @return [Boolean]
      def ==(other)
        if self.class == other.class
          if @storage.eql?(other.storage) \
              and @offset == other.offset \
              and @length == other.length
            return true
          end

          @length == other.length and \
            Reader.substr_eql?(@storage, @offset, other.storage, other.offset, other.length)
        elsif other.is_a?(String)
          length == other.length and \
            Reader.substr_eql?(@storage, @offset, other, 0, other.length)
        end
      end

      # Returns true if this StringPtr begins with the given prefix. No
      # allocations are performed.
      #
      # @return [Boolean]
      def start_with?(other)
        substr_eql?(0, other, 0)
      end

      # Returns true if this StringPtr, starting at the given offset, starts
      # with the other string (starting at it's respective offset). This is
      # essentially `self[offset, length] == other[offset_, length]`, but no
      # Strings are allocated.
      #
      #   Pointer.build("abcdef").substr_at?(0, "abc", 0) #=> true
      #   Pointer.build("abcdef").substr_at?(0, "abc", 1) #=> false
      #   Pointer.build("abcdef").substr_at?(0, "xab", 1) #=> true
      #   Pointer.build("abcdef").substr_at?(1, "abc", 0) #=> false
      #   Pointer.build("abcdef").substr_at?(1, "bcd", 0) #=> true
      #
      # @return [Boolean]
      def substr_eql?(offset, other, offset_=0, length = other.length)
        raise ArgumentError "offset must be be non-negative" if offset < 0
        raise ArgumentError "offset must be be non-negative" if offset_ < 0
        raise ArgumentError "length must be be non-negative" if length < 0

        case other
        when String
          if offset + length <= @length and length <= other.length
            Reader.substr_eql?(@storage, @offset + offset, other, offset_, length)
          end
        when StringPtr
          if offset + length <= @length and other.offset + length <= other.length
            if @storage.eql?(other.storage) and @offset + offset == other.offset + offset_
              # Other pointer starts at the same index and points to the same storage
              @length >= length
            else
              Reader.substr_eql?(@storage, @offset + offset, other.storage, other.offset + offset_, length)
            end
          end
        else
          raise TypeError, "expected String or StringPtr, got #{other.inspect}"
        end
      end

      # @group Indexing
      #########################################################################

      # Return offset of the first match, or `nil` if no match occurs.
      #
      # @return [Integer]
      def =~(pattern)
        m, offset = match_(pattern, 0)
        m and m.begin(0) + offset
      end

      # Return offset of first occurence of `other` that starts at or after
      # the given `offset`. If not found, then `nil` is returned.
      #
      # @return [Integer]
      def index(other, offset=0, anchorless=false)
        raise ArgumentError, "offset must be non-negative" if offset < 0
        return nil if offset > @length

        if other.is_a?(Regexp)
          m, offset = match_(other, offset)
          m and m.begin(0) + offset
        else
          n = @storage.index(other, @offset + offset)
          n - @offset if n and n + other.length <= @offset + @length
        end
      end

      # Return offset of last occurence of `other` that starts at or before
      # the given `offset`. If not found, then `nil` is returned.
      #
      # @return [Integer]
      def rindex(other, offset=@length-1)
        raise ArgumentError, "offset must be non-negative" if offset < 0
        offset = @length - 1 if offset >= @length

        if other.is_a?(Regexp)
          if n = @storage.rindex(other, @offset + offset)
            if n + other.length <= @offset + @length
              n - @offset
            else
              # The match starts within bounds but ends outside, so we need to
              # to allocate a new String of the correct length and try again
              reify.rindex(other, offset)
            end
          else
            # Pattern wasn't found anywhere before the offset, so that's that!
          end
        else
          n = @storage.rindex(other, @offset + offset)
          n - @offset if n and n >= @offset and n + other.length <= @offset + @length
        end
      end

      # @group Search
      #########################################################################

      # Return number of occurrences of given character.
      #
      # NOTE: This only supports a subset of functionality of String#count.
      # Namely, it only works for a single character.
      #
      # @return [Integer]
      def count(char)
        count, offset = 0, @offset

        while true
          offset = @storage.index(char, offset)
          offset and offset < @offset + @length or break
          offset += 1
          count  += 1
        end

        count
      end

      # @group Concatenation
      #########################################################################

      # If two flyweights share the same storage and are contiguous (one ends
      # where the other starts), then string concatenation can be optimized.
      #
      # In the case where the operand is a string and happens to be a prefix
      # of @storage[@offset+@length..], then we can also simply extend the
      # length without allocating another string.
      #
      # For example:
      #   x = Pointer.build("abc xyz")
      #   y = x.drop(0)
      #
      #   y << x.take(2)    # no allocation, returns self
      #   y << "c x"        # no allocation, returns self
      #   y << "mno"        # allocates a new String for @storage, returns self
      #
      # @return [self]
      def <<(other)
        if other.is_a?(self.class)
          if @storage.eql?(other.storage) and @offset + @length == other.offset
            # allocations: 0 strings, 0 pointers
            @length += other.length
          elsif not @storage.frozen?
            # Surely no one will notice if we destructively update @storage
            #   allocations: 1 string, 0 pointers
            @storage << other.reify
            @length  += other.length
          else
            # Other flyweights are sharing our storage. We need to make our
            # own copy now. Be sure `reify` gives back a copy, not the original.
            #   allocations: 2 strings, 0 pointers
            @storage  = reify(true)
            @storage << other.reify
            @length  += other.length
            @offset   = 0
          end

        # NOTE: There doesn't seem to be a string comparison function in Ruby
        # that allows the comparison to start a given offset. That means we'd
        # have to allocate and copy from @storage a length of `other.length`.
        #
        #   @storage[@offset + @length, other.length] == other
        #
        # @storage.index(other, @offset + @length) == n doesn't allocate
        # memory, but there is no way to abort the search early.
        #
        elsif @storage.length - @offset - @length >= other.length \
          and @storage.index(other, @offset + @length) == @offset + @length
          # allocations: 0 strings, 0 pointers
          @length += other.length
        elsif not @storage.frozen?
          # Surely no one will notice if we destructively update @storage
          #
          # allocations: 0 strings, 0 pointers
          @storage << other
          @length  += other.length
        else
          # Other flyweights are sharing our storage. We need to make our
          # own copy now. Be sure `reify` gives back a copy, not the original.
          #
          # allocations: 1 string, 0 pointers
          @storage  = reify(true)
          @storage << other
          @length  += other.length
          @offset   = 0
        end

        self
      end

      # If two flyweights share the same storage and are contiguous (one ends
      # where the other starts), then string concatenation can be optimized.
      #
      # In the case where the operand is a string and happens to be a prefix
      # what follows @offset + @length, then we can also simply extend the
      # length without allocating more strings.
      #
      # For example:
      #   x     = Pointer.build("abc xyz")
      #   a, b  = x.split_at(2)
      #
      #   a + b            # no String allocation, returns new Pointer
      #   a + "c x"        # no String allocation, returns new Pointer
      #   a + "mno"        # returns a new String
      #
      # NOTE: In the case where a string must be allocated, this method
      # does NOT return a pointer; it returns a plain String. This is
      # because the likely operation on the result is more concatenation,
      # or things besides creating substrings. For example,
      #
      #   ((x + "a") + "b") + "c"
      #
      # is more efficient when `x + "a"` returns a String. Otherwise the
      # pointer wrapper is created only to immediately unwrap @storage
      # for the next concatenation.
      #
      # @return [Pointer<String, String> | String]
      def +(other)
        if other.is_a?(self.class)
          if @storage.eql?(other.storage) and @offset + @length == other.offset
            # allocations: 0 strings, 1 pointer
            self.class.new(@storage.freeze, @offset, @length + other.length)
          else
            # allocations: 2 strings, 0 pointers
            reify(true) << other.reify
          end

        # NOTE: There doesn't seem to be a string comparison function in Ruby
        # that allows the comparison to start a given offset. That means we
        # have to allocate and copy from @storage a length of `other.length`.
        #   @storage[@offset + @length, other.length] == other
        #
        # @storage.index(other, @offset + @length) == n doesn't allocate
        # memory, but there is no way to abort the search early.
        #
        elsif @storage.length - @offset - @length >= other.length \
          and @storage.index(other, @offset + @length) == @offset + @length
          # allocations: 0 strings, 1 pointer
          self.class.new(@storage.freeze, @offset, @length + other.length)
        else
          # allocations: 2 strings, 0 pointers
          reify(true) << other
        end
      end

      # @group Formatting
      #########################################################################

      # Returns a new StringPtr with trailing spaces removed; "\000", "\t",
      # "\n", "\v", "\f", "\r", " "
      #
      # @return [StringPtr]
      def rstrip(offset = @length - 1)
        raise ArgumentError, "offset must be non-negative" if offset < 0
        offset  = @length if offset_ > @length
        offset_ = Reader.rstrip_offset(@storage, @offset + offset)

        if offset_ < @offset
          self
        else
          take(offset_ - @offset)
        end
      end

      # Returns a new StringPtr with leading spaces removed; "\000", "\t",
      # "\n", "\v", "\f", "\r", " "
      #
      # @return [StringPtr]
      def lstrip(offset = 0)
        raise ArgumentError, "offset must be non-negative" if offset < 0
        offset  = @length if offset > @length
        offset_ = Reader.lstrip_offset(@storage, @offset + offset)

        if offset_ > @offset + @length
          self
        else
          drop(offset_ - @offset)
        end
      end

      # @group Miscellaneous
      #########################################################################

      # Returns the offset of the next non-control character at or after offset
      #
      # @return [Integer]
      def lstrip_control_characters_offset(offset = 0)
        raise ArgumentError, "offset must be non-negative" if offset < 0
        offset = @length if offset > @length

        n = Reader.lstrip_control_characters_offset(@storage, @offset + offset)
        n = @offset + @length if n > @offset + @length
        n - @offset
      end

      # Returns true if the character at the given offset is a control
      # character (defined by X222.pdf B.1.1.2.4 Control Characters)
      def is_control_character_at?(offset)
        raise ArgumentError "offset must be be non-negative" if offset < 0
        Reader.is_control_character_at?(@storage, @offset + offset)
      end

      # @endgroup
      #########################################################################
    end

    class ArrayPtr < Pointer
      # Used by Array methods to coerce us into a compatible type.
      def to_ary
        reify
      end

      # all?
      # any?
      # assoc
      # bsearch
      # bsearch_index
      # count
      # dig
      # drop_while
      # each
      # each_index
      # fetch
      # find_index
      # include?
      # index
      # max
      # min
      # none?
      # one?
      # rassoc
      # rindex
      # sum
      # take_while
      # values_at
    end

  end
end
