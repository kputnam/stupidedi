module Stupidedi
  module Reader

    #
    # @note This class is not thread-safe. If more than one +Thread+ has access
    #   to the same instance, and they simultaneously call methods on that
    #   instance, the methods may produce incorrect results and the object might
    #   be left in an inconsistent state.
    #
    class FileInput < Input
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

        if start = prefix.rindex("\n")
          column = prefix.length - start
        else
          column = @column + prefix.length
        end

        self.class.new(suffix,
                       @offset + prefix.length,
                       @line   + prefix.count("\n"),
                       column,
                       @size)
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

        # We need to start with value != buffer, and this is a reasonable guess
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
        if other.is_a?(FileInput)
          @io.path == other.io.path and @offset == other.offset
        end
      end
    end

  end
end
