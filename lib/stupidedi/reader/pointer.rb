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

      # @return [Pointer<S, E>]
      def reset
        self.class.new(@storage.freeze, 0, @storage.length)
      end

      # @return [self]
      def reset!
        @offset = 0
        @length = @storage.length
        self
      end

      # @return [Boolean]
      def empty?
        @length <= 0
      end

      def blank?
        empty?
      end

      def present?
        not blank?
      end

      # Return the first element. If {empty?}, `nil` will be returned.
      #
      # @return [E]
      def head
        @storage[@offset] if @length > 0
      end

      # Return a new pointer with the first item removed.
      #
      # @return [Pointer<S, 0E>]
      def tail
        drop(1)
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
        n <= @length
      end

      # Return the nth element.
      #
      # @return [E]
      def at(n)
        raise ArgumentError, "argument must be non-negative" if 0 > n
        @storage[@offset + n] if @length > n
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
      # @return [Pointer<S, E>]
      def drop(n)
        raise ArgumentError, "argument must be non-negative" if n < 0
        n = @length if n > @length
        return self if n.zero?
        self.class.new(@storage.freeze, @offset + n, @length - n)
      end

      # Return a new pointer, skipping the first n items, and destructively
      # update this pointer to end at the nth element.
      #
      #   x = Pointer.new("eyeball")
      #   x.drop!(5)  == "ll"
      #   x           == "eyeba"
      #
      # @return [Pointer<S, E>]
      def drop!(n)
        raise ArgumentError, "argument must be non-negative" if n < 0
        n = @length if n > @length
        offset = @offset + n
        length = @length - n
        suffix  = self.class.new(@storage.freeze, offset, length)

        # We become the prefix that ends where suffix starts
        @length = n

        suffix
      end

      # Return a new pointer spanning only the first n items.
      #
      # @return [Pointer<S, E>]
      def take(n)
        raise ArgumentError, "argument must be non-negative" if n < 0
        n = @length if n > @length
        self.class.new(@storage.freeze, @offset, n)
      end

      # Return a new pointer spanning only the first n items, and destructively
      # update this pointer to start at the (n+1)th element.
      #
      #   x = Pointer.new("eyeball")
      #   x.take!(5)  == "eyeba"
      #   x           == "ll"
      #
      # @return [Pointer<S, E>]
      def take!(n)
        raise ArgumentError, "argument must be non-negative" if n < 0
        n = @length if n > @length
        prefix = self.class.new(@storage.freeze, @offset, n)

        # We become the suffix starts where prefix ends
        @offset += n
        @length -= n

        prefix
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
    end

    class << Pointer
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
    end

    class StringPtr < Pointer

      # TODO: More of these
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
        offset = @offset + offset

        # Unfortunately we can't use pattern.match?, which doesn't allocate
        # a MatchData object, because we need to check bounds on the match
        m = pattern.match(@storage, offset)

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
      # it doesn't change which part of the string anchors match like ^ $ \A
      # \Z and \z. For example, match(/^/, n) with n > 0, will never succeed
      # because ^ is at offset 0 of the substring. This behavior is the same
      # as String#match.
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

      # Optimized to only allocate one string, when two pointers don't share
      # the same storage. Otherwise zero allocations are performed.
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
            strncmp(@storage, @offset, other.storage, other.offset, other.length)
        elsif other.is_a?(String)
          length == other.length and \
            strncmp(@storage, @offset, other, 0, other.length)
        end
      end

      def start_with?(other)
        case other
        when String
          if other.length > @length
            false
          else
            strncmp(@storage, @offset, other, 0, other.length)
          end
        when Regexp
          reify.start_with?(other)
        else
          raise TypeError, "expected String or Regexp"
        end
      end

      if String.respond_to?(:strncmp)
        def strncmp(s1, n1, s2, n2, len)
          String.strncmp(s1, n1, s2, n2, len)
        end
      else
        def strncmp(s1, n1, s2, n2, len)
          if s1.length <= n1 + len or s2.length <= n2 + len
            false
          else
            s1 = s1[n1, len] unless n1.zero? and n1.length == len
            s2 = s2[n2, len] unless n2.zero? and n2.length == len
            s1 == s2
          end
        end
      end
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
