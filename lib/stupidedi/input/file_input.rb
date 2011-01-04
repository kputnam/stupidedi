module Stupidedi
  module Input

    #
    # This class isn't thread safe, meaning if more than one thread has access
    # to the same instance and they simultaneously call methods on that instance,
    # the methods may produce incorrect results and the object might be left in
    # an inconsistent state.
    #
    class FileInput < AbstractInput
      attr_reader :io, :offset, :line, :column

      def initialize(io, offset, line, column, size = io.stat.size)
        @io, @offset, @line, @column, @size = io, offset, line, column, size
      end

      def defined_at?(n)
        @offset + n < @size
      end

      def empty?
        @io.eof?
      end

      def drop(n)
        raise ArgumentError, "n (#{n}) must be positive" unless n >= 0

        @io.seek(@offset)
        prefix = @io.read(n)
        suffix = @io

        self.class.new(suffix, @offset + prefix.length, line + prefix.count("\n"), 0, @size)
      end

      def take(n)
        @io.seek(@offset)
        @io.read(n)
      end

      def at(n)
        raise ArgumentError, "n (#{n}) must be positive" unless n >= 0

        @io.seek(@offset + n)
        @io.read(1)
      end

      def index(value)
        @io.seek(@offset)
        length = value.length
        buffer = "\377" * length

        until @io.eof?
          buffer.slice!(0)
          buffer << @io.read(1)

          if buffer == value
            return @io.tell - @offset - length
          end
        end
      end

      def ==(other)
        case other
        when self.class
          @io.path == other.io.path and @offset == other.offset
        when File
          @io.path == other.path
        else
          @io == other
        end
      end
    end

  end
end
