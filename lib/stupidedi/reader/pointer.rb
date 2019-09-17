# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Reader
    class Pointer

      # @return [S]
      attr_reader :storage

      # @return [Integer]
      attr_reader :offset

      # @return [Integer]
      attr_reader :length

      def initialize(storage, offset, length)
        raise ArgumentError, "offset must be non-negative" if offset < 0
        raise ArgumentError, "length must be non-negative" if length < 0
        raise ArgumentError, "offset must be less than storage length" if offset > storage.length
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
        1 <= @length
      end

      # @return [Boolean]
      def defined_at?(n)
        raise ArgumentError, "argument must be non-negative" if n < 0
        n < @length
      end

      # Returns true if the pointer begins with the given prefix.
      #
      # @return [Boolean]
      def start_with?(prefix, offset=0)
        case prefix
        when self.class
          subseq_eq?(@storage, @offset, prefix.storage, prefix.offset + offset, prefix.length)
        when @storage.class
          subseq_eq?(@storage, @offset, prefix, offset, prefix.length)
        else
          raise TypeError, "expected %s or %s, got %s" % [
            self.class, @storage.class, prefix.class]
        end
      end

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

      # @return [E]
      def head
        @storage[@offset] if @length > 0
      end

      # @return [Pointer<S, E>]
      def last
        @storage[@offset + @length - 1] if @length > 0
      end

      # @return [E]
      def at(n)
        raise ArgumentError, "argument must be non-negative" if 0 > n
        @storage[@offset + n] if @length > n
      end

      # @group Subsequence
      #########################################################################

      def tail
        drop(1)
      end

      def [](offset, length=nil)
        if length.present?
          raise ArgumentError, "length must be non-negative" if 0 > length
          raise ArgumentError, "offset must be non-negative" if 0 > offset
          return nil if offset >= @length or offset < -@length

          length = @length - offset if length > @length - offset
          self.class.new(@storage.freeze, @offset + offset, length)

        elsif offset.kind_of?(Range)
          a = offset.begin
          b = offset.end

          a += @length if a < 0
          b += @length if b and b < 0
          return nil if a < 0 or a >= @length

          if b.nil?
            length = @length - a
          else
            b       = @length - 1 if b >= @length
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

      def drop(n)
        raise ArgumentError, "argument must be non-negative" if n < 0
        n = @length if n > @length
        return self if n.zero?
        self.class.new(@storage.freeze, @offset + n, @length - n)
      end

      def take(n)
        raise ArgumentError, "argument must be non-negative" if n < 0
        n = @length if n > @length
        return self if n == @length
        self.class.new(@storage.freeze, @offset, n)
      end

      def drop_take(drop, take)
        raise ArgumentError, "drop must be non-negative" if drop < 0
        raise ArgumentError, "take must be non-negative" if take < 0

        drop   = @length if drop > @length
        offset = @offset + drop
        length = @length - drop

        take = length if take > length
        self.class.new(@storage.freeze, offset, take)
      end

      def split_at(n)
        [take(n), drop(n)]
      end

      # @group Concatenation
      #########################################################################

      def +(other)
        if other.is_a?(self.class)
          o_storage = other.storage
          o_length  = other.length
          o_offset  = other.offset
        else
          o_storage = other
          o_length  = other.length
          o_offset  = 0
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

      # @return self
      def drop!(n)
        raise ArgumentError, "argument must be non-negative" if n < 0
        n        = @length if n > @length
        @offset += n
        @length -= n
        self
      end

      # @return self
      def take!(n)
        raise ArgumentError, "argument must be non-negative" if n < 0
        n       = @length if n > @length
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

      # @return [Boolean]
      def subseq_eq?(s1, o1, s2, o2, length)
        return false if s1.length < o1 + length
        return false if s2.length < o2 + length
        return true  if s1.equal?(s2) and o1 == o2

        # s1 = s1[o1, length] if 0 >= 0 or length != s1.length
        # s2 = s2[o2, length] if 0 >= 0 or length != s2.length
        # s1 == s2

        # TODO: Not sure this is an improvement over allocating the subsequences
        # above. But when @storage is an Array, this won't allocate any objects.
        (0 .. length-1).all?{|n| s1[o1 + n] == s2[o2 + n] }
      end
    end

    class << Pointer
      # @group Constructors
      #########################################################################

      # Constructs a new Pointer depending on what type of object is passed.
      # 
      # NOTE: Pointer operations can potentially destrucively modify the given
      # object, but if it is `#frozen?`, a copy will be made before the update.
      # If you are accessing or modifying the object outside of the Pointer API,
      # unexpected results might occur. To avoid this, either provide a copy
      # with `#dup` or freeze the object first with `#freeze`.
      # 
      # @return [Pointer]
      def build(object)
        case object
        when String
          Substring.new(object, 0, object.length)
        when Pointer
          object
        else
          raise TypeError, "object must respond to []" \
            unless object.respond_to?(:[])

          raise TypeError, "object must respond to length" \
            unless object.respond_to?(:length)

          Pointer.new(object, 0, object.length)
        end
      end

      # @endgroup
      #########################################################################
    end
  end
end
