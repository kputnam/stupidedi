# frozen_string_literal: true
# encoding: utf-8
module Stupidedi
  using Refinements

  module Reader
    class StringPtr < Pointer
      # @group Conversion Methods
      #########################################################################

      def_delegators :@storage, :encoding, :valid_encoding?, type: String
      def_delegators :reify, :to_sym, :intern, :to_i, type: String
      def_delegators :reify, :to_d

      # This is called implicitly when we are used in String interpolation,
      # eg `"abc #{pointer} xyz"` or `"abc %s xyz" % pointer`.
      alias_method :to_s, :reify

      # Used by String methods to coerce us into a compatible type.
      alias_method :to_str, :reify

      def blank?
        empty? or NativeExt.min_nonspace_index(@storage, @offset) >= @offset + @length
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

        if not anchorless and @offset + @length != @storage.length \
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
      # a `MatchData` that includes offsets and indexes relative to the whole
      # @storage, not the start of this pointer string.
      #
      # We can't update the `MatchData` to have adjusted offsets, but we return
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
            [n, m.begin(0) - @offset]
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
            NativeExt.substr_eq?(@storage, @offset, other.storage, other.offset, other.length)
        elsif other.is_a?(String)
          length == other.length and \
            NativeExt.substr_eq?(@storage, @offset, other, 0, other.length)
        end
      end

      # Returns true if this StringPtr begins with the given prefix. No
      # allocations are performed.
      #
      # @return [Boolean]
      def start_with?(other)
        substr_eq?(0, other, 0)
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
      def substr_eq?(offset, other, offset_=0, length = other.length)
        raise ArgumentError "offset must be be non-negative" if offset < 0
        raise ArgumentError "offset must be be non-negative" if offset_ < 0
        raise ArgumentError "length must be be non-negative" if length < 0

        case other
        when String
          if offset + length <= @length and length <= other.length
            NativeExt.substr_eq?(@storage, @offset + offset, other, offset_, length)
          end
        when StringPtr
          if length <= @length and length <= other.length
            if @storage.eql?(other.storage) and @offset + offset == other.offset + offset_
              # Other pointer starts at the same index and points to the same storage
              @length >= length
            else
              NativeExt.substr_eq?(@storage, @offset + offset, other.storage, other.offset + offset_, length)
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
          m, offset = match_(other, offset, anchorless)
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
            storage << other.reify
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

      # Returns a new StringPtr with leading whitespace removed.
      #
      # @return [StringPtr]
      def lstrip(start_at = 0)
        raise ArgumentError, "start_at must be non-negative" if start_at < 0
        start_at  = @length - 1 if start_at >= @length
        index     = NativeExt.min_nonspace_index(@storage, @offset + start_at)

        if index <= @offset
          self
        else
          #      01234o--> 
          # ----[xxxxx  ]--------
          #
          # In this picture, min_nonspace_index(o=5) would return an index
          # that's past the end of this substring, but `drop` will prevent
          # any problem because it does a boundary check.
          drop(index  - @offset)
        end
      end

      # Returns a new StringPtr with trailing whitespace removed.
      #
      # @return [StringPtr]
      def rstrip(start_at = @length - 1)
        raise ArgumentError, "start_at must be non-negative" if start_at < 0
        start_at  = @length - 1 if start_at >= @length
        index     = NativeExt.max_nonspace_index(@storage, @offset + start_at)

        if index >= @offset + @length - 1
          self
        else
          #    <---o3456
          # ----[   xxxx]--------
          #
          # In this picture, max_nonspace_index(o=2) would return an index
          # that's before the start of this substring, which would result
          # in take(n < 0) which throws an exception. This prevents that:
          index = @offset - 1 if index < @offset
          take(index + 1 - @offset)
        end
      end

      def strip
        lstrip.rstrip
      end

      # @group Miscellaneous
      #########################################################################

      # Returns the offset of the next non-control character at or after offset
      #
      # @return [Integer]
      def min_graphic_index(offset = 0)
        raise ArgumentError, "offset must be non-negative" if offset < 0
        offset = @length if offset > @length

        n = NativeExt.min_graphic_index(@storage, @offset + offset)
        n = @offset + @length if n > @offset + @length
        n - @offset
      end

      # Returns true if the character at the given offset is a control
      # character (defined by X222.pdf B.1.1.2.4 Control Characters)
      def graphic?(offset)
        raise ArgumentError "offset must be be non-negative" if offset < 0
        NativeExt.graphic?(@storage, @offset + offset)
      end

      # @endgroup
      #########################################################################
    end
  end
end
