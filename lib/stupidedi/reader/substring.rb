# frozen_string_literal: true
# encoding: utf-8
module Stupidedi
  using Refinements

  module Reader
    class Substring < Pointer
      # @group Conversion Methods
      #########################################################################

      def_delegators :reify, :to_d
      def_delegators :reify, :to_sym, :intern, :to_i, :split, type: String
      def_delegators :@storage, :encoding, :valid_encoding?, type: String

      alias_method :to_s,   :reify
      alias_method :to_str, :reify

      # @endgroup
      #########################################################################

      # A substring is blank if it's empty or only whitespace.
      #
      # @override
      # @return [Boolean]
      def blank?
        empty? or NativeExt.min_nonspace_index(@storage, @offset) >= @offset + @length
      end

      # @group Matching
      #########################################################################

      # @private
      # Match an unescaped anchor \A, \a, or ^, \Z, \z, $; this is fast but
      # can give false positives on stuff like [^...] and [...$]. For those
      # cases, `match?` and `index` can be given `anchorless: true`. When
      # a Regexp is not anchored, we can usually avoid calling `reify`.
      ANCHORS_A = /(?<!\\)(?:\\\\)*(?:\\[Aa]|[\^])/
      ANCHORS_Z = /(?<!\\)(?:\\\\)*(?:\\[Zz]|[\$])/

      # Indicates whether the regexp matches this substring or not. See specs
      # for performance characteristics.
      #
      # @return [Boolean]
      def match?(pattern, offset=0, anchorless: false)
        pattern = _convert(Regexp, pattern)

        if @length < 1024 and @storage.length - @offset > 1024
          # TODO: Run some experiments to evalaute performance here
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

        # Unfortunately we can't use pattern.match?, which doesn't allocate a
        # MatchData object (Ruby 2.4+), because we need to check bounds on the
        # match.
        m = pattern.match(@storage, offset + @offset)

        if m and m.begin(0) <= @offset + @length
          if m.end(0) <= @offset + @length
            true
          else
            @storage[m.begin(0), @offset + @length - m.begin(0)].match?(pattern)
          end
        end || false
      end

      # If the pattern matches this substring, returns the index where the match
      # begins.
      #
      # @return [Integer]
      def =~(pattern)
        if result = _match(pattern, 0)
          m      = result[0]
          offset = result[1]
          m and m.begin(0) + offset
        end
      end

      # @group Search
      #########################################################################

      def [](offset, length=nil)
        case offset
        when Regexp
          length ||= 0
          m = match(offset)
          m and m[length]
        else
          super(offset, length)
        end
      end

      # Returns the index of the first occurrence of the given string or pattern
      # within this substring. Returns `nil` if not found. The optional second
      # parameter specifies the position to begin the search.
      #
      # @return [Integer]
      def index(other, offset=0, anchorless: false)
        raise ArgumentError, "offset must be non-negative" if offset < 0
        return nil if offset > @length

        if other_ = Regexp.try_convert(other)
          if result = _match(other_, offset, anchorless)
            m      = result[0]
            offset = result[1]
            m and m.begin(0) + offset
          end
        elsif other_ = String.try_convert(other)
          n = @storage.index(other_, @offset + offset)
          n - @offset if n and n + other_.length <= @offset + @length
        else
          raise TypeError, "expected Regexp or String, got %s" % other.class
        end
      end

      # Return index of the last occurence of the given string or pattern within
      # this substring. Returns `nil` if not found. The optional second
      # parameter specifies the position to begin the search.
      #
      # @return [Integer]
      def rindex(other, offset=@length-1)
        raise ArgumentError, "offset must be non-negative" if offset < 0
        offset = @length - 1 if offset >= @length

        if other_ = Regexp.try_convert(other)
          if n = @storage.rindex(other_, @offset + offset)
            if n + other_.length <= @offset + @length
              n - @offset
            else
              # The match starts within bounds but ends outside, so we need to
              # to allocate a new String of the correct length and try again
              reify.rindex(other_, offset)
            end
          else
            # Pattern wasn't found anywhere before the offset, so I would say
            # that's that, mattress man.
          end
        elsif other_ = String.try_convert(other)
          n = @storage.rindex(other_, @offset + offset)
          n - @offset if n and n >= @offset and n + other_.length <= @offset + @length
        else
          raise TypeError, "expected Regexp or String, got %s" % other.class
        end
      end

      def count(other)
        other  = _convert(String, other)
        length = other.length
        count  = 0
        offset = @offset

        while true
          offset = @storage.index(other, offset)
          offset and offset + length <= @offset + @length or break
          offset += 1
          count  += 1
        end

        count
      end

      # @group Concatenation
      #########################################################################

      # Destructively updates this substring by appending the given string or
      # substring pointer.
      #
      # @return [self]
      def <<(other)
        case other
        when self.class
          if (@storage.equal?(other.storage) and @offset + @length == other.offset) \
          or NativeExt.substr_eq?(@storage, @offset + @length, other.storage, other.offset, other.length)
            @length += other.length
          elsif not @storage.frozen?
            # Surely no one will notice if we destructively update @storage
            @storage[@offset + @length, @storage.length - @offset - @length] = other
            @length  += other.length
          else
            # Other pointers are sharing our storage. We need to make our own
            # copy now. Be sure `reify` gives back a copy, not the original.
            @storage  = reify(true)
            @storage << other.reify
            @length  += other.length
            @offset   = 0
          end

          return self
        end

        if other_ = String.try_convert(other)
          if @storage.length - @offset - @length >= other_.length \
          and NativeExt.substr_eq?(@storage, @offset + @length, other_, 0, other_.length)
            @length += other_.length
          elsif not @storage.frozen?
            # Surely no one will notice if we destructively update @storage
            @storage[@offset + @length, @storage.length - @offset - @length] = other_
            @length  += other_.length
          else
            # Other pointers are sharing our storage. We need to make our own
            # copy now. Be sure `reify` gives back a copy, not the original.
            @storage  = reify(true)
            @storage << other_
            @length  += other_.length
            @offset   = 0
          end

          self
        else
          raise TypeError, "expected String or Substring, got #{other.class}"
        end
      end

      # @group Formatting
      #########################################################################

      # Returns a new substring with leading whitespace removed.
      #
      # @return [Substring]
      def lstrip(start_at = 0)
        return self if @length.zero?
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

      # Destructively updates this substring by removing leading whitespace.
      #
      # @return self
      def lstrip!(start_at = 0)
        # TODO
      end

      # Returns a new substring with trailing whitespace removed.
      #
      # @return [Substring]
      def rstrip(start_at = @length - 1)
        return self if @length.zero?
        raise ArgumentError, "start_at must be non-negative" if start_at < 0

        start_at = @length - 1 if start_at >= @length
        index    = NativeExt.max_nonspace_index(@storage, @offset + start_at)

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

      # Destructively updates this substring by removing trailing whitespace.
      #
      # @return self
      def rstrip!(start_at = @length - 1)
        # TODO
      end

      # Returns a new substring with leading and trailing whitespace removed.
      #
      # @return [Substring]
      def strip
        lstrip.rstrip!
      end

      # Destructively updates this substring by removing leading and trailing
      # whitespace.
      #
      # @return self
      def strip!
        lstrip!.rstrip!
      end

      # @group Miscellaneous
      #########################################################################

      # Returns the index of the next non-control character at or after the
      # given offset.
      #
      # @return [Integer]
      def min_graphic_index(offset = 0)
        raise ArgumentError, "offset must be non-negative" if offset < 0
        offset = @length if offset > @length

        n = NativeExt.min_graphic_index(@storage, @offset + offset)
        n = @offset + @length if n > @offset + @length
        n - @offset
      end

      def min_nongraphic_index(offset = 0)
        raise ArgumentError, "offset must be non-negative" if offset < 0
        offset = @length if offset > @length

        n = NativeExt.min_nongraphic_index(@storage, @offset + offset)
        n = @offset + @length if n > @offset + @length
        n - @offset
      end

      # Returns true if the character at the given offset is a control
      # character (defined by X222.pdf B.1.1.2.4 Control Characters)
      #
      # @return [Boolean]
      def graphic?(offset)
        raise ArgumentError "offset must be be non-negative" if offset < 0
        NativeExt.graphic?(@storage, @offset + offset)
      end

      # @private
      # @return [String]
      def clean
        from = 0
        upto = min_nongraphic_index
        return self unless upto < @length

        # We know Substring#<< cannot be zero-copy at this point
        buffer = @storage[@offset + from, upto - from] unless from == upto

        while from < @length and upto < @length
          from = min_graphic_index(upto)
          upto = min_nongraphic_index(from)

          if buffer.nil?
            buffer = @storage[@offset + from, upto - from]
          else
            buffer << @storage[@offset + from, upto - from]
          end unless from == upto
        end

        buffer || ""
      end

      # @endgroup
      #########################################################################

      private

      # @return [MatchData, Integer]
      def _match(pattern, offset, anchorless=false)
        pattern = _convert(Regexp, pattern)

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

        pattern_inspect = nil

        if not anchorless and @offset > 0 \
          and ANCHORS_A.match?(pattern_inspect ||= pattern.inspect)
          # We can't match on @storage.directly unless our @offset is 0,
          # because String#match(/^./, n) never matches unless n is 0.
          return [reify.match(pattern), 0]
        end

        if not anchorless and @offset + @length < @storage.length \
          and ANCHORS_Z.match?(pattern_inspect ||= pattern.inspect)
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

      # @override
      def subseq_eq?(s1, o1, s2, o2, length)
        return false unless s1.is_a?(String)
        return false unless s2.is_a?(String)
        NativeExt.substr_eq?(s1, o1, s2, o2, length)
      end

      def _convert(klass, other)
        klass.try_convert(other) or raise TypeError,
          "no implicit conversion of %s into %s" % [other.class, klass]
      end
    end
  end
end
