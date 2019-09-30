# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Reader
    # 
    # 
    #
    class Slice
      # @return [S]
      attr_reader :storage

      # @return [Integer]
      attr_reader :offset

      # @return [Integer]
      attr_reader :length

      def initialize(storage, offset, length)
        raise ArgumentError, "offset must be non-negative" if offset < 0
        raise ArgumentError, "length must be non-negative" if length < 0
        raise ArgumentError, "offset must be less than storage length"   if offset > storage.length
        raise ArgumentError, "given length cannot exceed storage length" if length > storage.length

        @storage = storage
        @offset  = offset
        @length  = length
      end

      # @group Querying
      #########################################################################

      # @return [Boolean]
      def empty?
        @length <= 0
      end

      # @return [Boolean]
      def blank?
        @length <= 0
      end

      # @return [Boolean]
      def present?
        @length >= 1
      end

      # @return [Boolean]
      def defined_at?(index)
        index = Integer(index)
        raise ArgumentError, "argument must be non-negative" if index < 0
        index < @length
      end

      # Returns true if the slice begins with the given prefix.
      #
      # @return [Boolean]
      def start_with?(prefix, offset=0)
        case prefix
        when self.class
          subseq_eq?(@storage, @offset + offset, prefix.storage, prefix.offset, prefix.length)
        when @storage.class
          subseq_eq?(@storage, @offset + offset, prefix,         0,             prefix.length)
        else
          raise TypeError, "expected %s or %s, got %s" % [
            self.class, @storage.class, prefix.class]
        end
      end

      # Returns true if this slice has the same contents as another slice
      # or a value with the same type as storage <S>.
      #
      # @return [Boolean]
      def ==(other)
        if self.class == other.class
          if @storage.equal?(other.storage)
            @offset == other.offset and @length == other.length
          end || subseq_eq?(@storage, @offset, other.storage, other.offset, @length)
        elsif @storage.equal?(other)
          @length == other.length
        else
          subseq_eq?(@storage, @offset, other, 0, @length)
        end
      end

      # @group Single Element Selection
      #########################################################################

      # Returns the first element
      #
      # @return [E]
      def head
        @storage[@offset] if @length > 0
      end

      # Returns the first element, or the first `count` elements, of the
      # slice. If the array is empty, the first form returns `nil`, and the
      # second form returns an empty slice. See also `#last` for the opposite
      # effect.
      #
      #   first     -> element
      #   first(n)  -> slice
      #
      # @return [E or Slice<S, E>]
      def first(count = nil)
        if count.nil?
          head
        else
          take(count)
        end
      end

      # Returns the last `count` element(s). If the slice is empty, the first
      # form returns `nil`. If a negative number is given, raises an
      # `ArgumentError`.
      #
      #   last      -> element
      #   last(n)   -> slice
      #
      # @return [E or Slice<S, E>]
      def last(count = nil)
        if count.nil?
          @storage[@offset + @length - 1] if @length > 0
        else
          count = Integer(count)
          raise ArgumentError, "count must be non-negative" if count < 0
          @storage[@offset + @length - count, count]
        end
      end

      # Returns the element at `index`. Returns `nil` if the index is out
      # of range. If a negative number is given, raises an `ArgumentError`.
      #
      # @return [E]
      def at(index)
        index = Integer(index)
        raise ArgumentError, "argument must be non-negative" if index < 0
        @storage[@offset + index] if @length > index
      end

      # @group Subsequence
      #########################################################################

      # Drops the first element and returns the remaining elements in a slice.
      #
      # @return [Slice<S, E>]
      def tail
        drop(1)
      end

      # Returns the element at `offset` or returns a slice starting at the
      # `offset` index and continuing for `length` elements, or returns a
      # slice specified by a `Range` of indices.
      #
      #   slice[offset]           -> element
      #   slice[offset, length]   -> slice
      #   slice[a..b]             -> slice
      #   slice[a...b]            -> slice
      #
      # Negative indices count backward from the end of the slice (-1 is the
      # last element). For `start` and `Range` cases, the starting index is just
      # before the element. Additionally, an empty slice is returned when the
      # starting index for an element range is at the end of the slice.
      #
      # Returns `nil` if the index or starting index are out of range.
      #
      # @return [E or Slice<S, E>]
      def [](offset, length=nil)
        if length.present?
          length  = Integer(length)
          offset += @length if offset < 0

          raise ArgumentError, "length must be non-negative" if length < 0
          raise ArgumentError, "offset must be non-negative" if offset < 0
          return nil if offset < -@length or @length <= offset

          length = @length - offset if length > @length - offset
          self.class.new(@storage.freeze, @offset + offset, length)

        elsif offset.kind_of?(Range)
          a = Integer(offset.begin)
          b = Integer(offset.end) if offset.end

          a += @length if a < 0
          b += @length if b and b < 0
          return nil if a.nil? or a < 0 or a >= @length

          if b.nil?
            length = @length - a
          else
            b       = @length - 1 if b >= @length
            length  = b - a
            length += 1 unless offset.exclude_end?
          end

          self[a, length]

        else
          offset  = Integer(offset)
          offset += @length if offset < 0
          @storage[@offset + offset] if offset < @length and offset >= 0
        end
      end

      # @return [Slice<S, E>]
      alias_method :slice, :[]

      # Drops the first `n` elements from the slice and returns the rest of
      # the elements in a slice. If a negative number is given, raises an
      # `ArgumentError`.
      #
      # @return [Slice<S, E>]
      def drop(n)
        n = Integer(n)
        raise ArgumentError, "argument must be non-negative" if n < 0
        n = @length if n > @length

        return self if n.zero?
        self.class.new(@storage.freeze, @offset + n, @length - n)
      end

      # Returns first `n` elements from the slice. If a negative number is
      # given, raises an `ArgumentError`.
      #
      # @return [Slice<S, E>]
      def take(n)
        n = Integer(n)
        raise ArgumentError, "argument must be non-negative" if n < 0
        n = @length if n > @length

        return self if n == @length
        self.class.new(@storage.freeze, @offset, n)
      end

      # Drops the first `n` elements, then selects `m` elements from the
      # remaining elements. If a negative number is given for either argument,
      # raises an `ArgumentError`.
      #
      # NOTE: This is equivalent to `slice.drop(n).take(m)` but requires one
      # less object allocation.
      #
      # @return [Slice<S, E>]
      def drop_take(n, m)
        n = Integer(n)
        m = Integer(m)

        raise ArgumentError, "n must be non-negative" if n < 0
        raise ArgumentError, "m must be non-negative" if m < 0

        n      = @length if @length < n
        offset = @offset + n
        length = @length - n

        m = length if length < m
        self.class.new(@storage.freeze, offset, m)
      end

      # Convenience method to `take(n)` and `drop(n)` in one method call.
      #
      # @return [(Slice<S, E>, Slice<S, E>)]
      def split_at(n)
        [take(n), drop(n)]
      end

      # @group Concatenation
      #########################################################################

      # Concatenates this slice and the argument (either another slice or
      # value of type S). Depending on what is being concatenated, this will
      # return either a new slice or a new value of type S.
      #
      # @return [S or Slice<S, E>]
      def +(other)
        if other.is_a?(self.class)
          o_storage = other.storage
          o_length  = other.length
          o_offset  = other.offset
        elsif other.is_a?(@storage.class)
          o_storage = other
          o_length  = other.length
          o_offset  = 0
        else
          raise TypeError, "expected %s or %s but got %s" % [
            self.class, @storage.class, other.class]
        end

        if (@storage.equal?(o_storage) and @offset + @length == o_offset) \
          or subseq_eq?(@storage, @offset + @length, o_storage, o_offset, o_length)
          self.class.new(@storage.freeze, @offset, @length + o_length)
        else
          if other.is_a?(self.class)
            reify(true).concat(other.reify)
          else
            reify(true).concat(other)
          end
        end
      end

      # @group Destructive methods
      #########################################################################

      # Drops the first `n` elements from the slice. If a negative number is
      # given, raises an `ArgumentError`.
      #
      # @return self
      def drop!(n)
        n = Integer(n)
        raise ArgumentError, "argument must be non-negative" if n < 0
        n = @length if @length < n

        @offset += n
        @length -= n
        self
      end

      # Removes all except the first `n` elements from the slice. If a
      # negative number is given, raises an `ArgumentError`.
      #
      # @return self
      def take!(n)
        n = Integer(n)
        raise ArgumentError, "argument must be non-negative" if n < 0
        n = @length if @length < n

        @length = n
        self
      end

      # @endgroup
      #########################################################################

      # @return [String]
      def inspect
        "#<%s %s@storage=0x%s @offset=%d @length=%d>" %
          [self.class.name.split("::").last,
           @storage.frozen? ? "-" : "+",
           (@storage.object_id << 1).to_s(16), @offset, @length]
      end

      # This operation typically allocates memory and copies part of @storage,
      # so this is avoided as much as possible.
      #
      # Unless the optional parameter `always_allocate` is `true`, then the
      # return value may be `#frozen?` in some cases.
      #
      # @return [S]
      def reify(always_allocate = false)
        if @storage.frozen? \
        and @offset == 0 \
        and @length == @storage.length \
        and not always_allocate
          @storage
        else
          # $stderr.puts "reify: allocate[#@offset, #@length]"
          @storage[@offset, @length]
        end
      end

      private

      # Return true if two subsequences s1[o1,length] and s2[o2,length] of type
      # S are equal. This is a generic implementation that should be overridden
      # for concrete types S to be more efficient.
      #
      # @return [Boolean]
      def subseq_eq?(s1, o1, s2, o2, length)
        return false if s1.length < o1 + length
        return false if s2.length < o2 + length
        return true  if s1.equal?(s2) and o1 == o2

        # s1 = s1[o1, length] if 0 < o1 or length < s1.length
        # s2 = s2[o2, length] if 0 < o2 or length < s2.length
        # s1 == s2

        # TODO: Not sure this is an improvement over allocating the subsequences
        # above. But when @storage is an Array, this won't allocate any objects.
        (0 .. length-1).all?{|n| s1[o1 + n] == s2[o2 + n] }
      end
    end

    class << Slice
      # @group Constructors
      #########################################################################

      # Constructs a new Slice depending on what type of object is given.
      #
      # NOTE: Slice operations can potentially destrucively modify the given
      # object, but if it is `#frozen?`, a copy will be made before the update.
      # If you are accessing or modifying the object outside of the Slice API,
      # unexpected results might occur. To avoid this, either provide a copy
      # with `#dup` or freeze the object first with `#freeze`.
      #
      # @return [Slice]
      def build(object)
        case object
        when String
          Substring.new(object, 0, object.length)
        when Slice
          object
        else
          raise TypeError, "object must respond to []" \
            unless object.respond_to?(:[])

          raise TypeError, "object must respond to length" \
            unless object.respond_to?(:length)

          Slice.new(object, 0, object.length)
        end
      end

      # @endgroup
      #########################################################################
    end
  end
end
