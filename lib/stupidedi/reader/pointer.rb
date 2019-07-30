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
          raise ArgumentError, "offset must be non-negative" if 0 > offset
          return nil if offset >= @length or offset < -@length

          length  = @length - offset  if length > @length - offset
          self.class.new(@storage.freeze, @offset + offset, length)

        elsif offset.kind_of?(Range)
          a = offset.begin
          b = offset.end

          a += @length if a < 0
          b += @length if b and b < 0

          return nil if a < 0 or a >= @length

          # This doesn't match Array or String #[] implementation
          # return nil if b and (b < 0 or b >= @length)

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
        return self if n == @length
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
          reify(true).concat(other.reify)
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
  end
end
