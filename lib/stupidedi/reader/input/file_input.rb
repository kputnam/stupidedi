module Stupidedi
  module Reader

    #
    # @note This class is not thread-safe. If more than one `Thread` has access
    #   to the same instance, and they simultaneously call methods on that
    #   instance, the methods may produce incorrect results and the object might
    #   be left in an inconsistent state.
    #
    class FileInput < AbstractInput

      # @return [IO]
      attr_reader :io

      def initialize(io, offset = 0, line = 1, column = 1, size = io.stat.size)
        @io, @offset, @line, @column, @size =
          io, offset, line, column, size
      end

      # @group Querying the Position
      ########################################################################

      # (see AbstractInput#offset)
      attr_reader :offset

      # @return [Integer]
      # (see AbstractInput#line)
      attr_reader :line

      # (see AbstractInput#column)
      attr_reader :column

      # (see AbstractInput#path)
      attr_reader :path

      # (see AbstractInput#position)
      def position
        Position.new(@offset, @line, @column, @io.path)
      end

      # @group Reading the Input
      ########################################################################

      # (see AbstractInput#take)
      # @return [String]
      def take(n)
        @io.seek(@offset)

        # Calling @io.read with more than the number of available bytes will
        # return nil, so we have to calculate how many bytes remain
        m = @size - @offset

        @io.read((n <= m) ? n : m)
      end

      # (see AbstractInput#at)
      # @return [String]
      def at(n)
        raise ArgumentError, "n must be positive" unless n >= 0

        @io.seek(@offset + n)
        @io.read(1)
      end

      # (see AbstractInput#index)
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

      # @group Advancing the Cursor
      ########################################################################

      # (see AbstractInput#drop)
      def drop(n)
        raise ArgumentError, "n must be positive" unless n >= 0

        @io.seek(@offset)
        prefix = @io.read(n)
        suffix = @io

        length = prefix.length
        count  = prefix.count("\n")

        column = unless count.zero?
                   length - prefix.rindex("\n")
                 else
                   @column + length
                 end

        copy(:offset => @offset + length,
             :line   => @line + count,
             :column => column,
             :size   => @size - length)
      end

      # @group Testing the Input
      ########################################################################

      # (see AbstractInput#defined_at?)
      def defined_at?(n)
        n < @size
      end

      # (see AbstractInput#empty?)
      def empty?
        @io.eof?
      end

      # @endgroup
      ########################################################################

      # @return [void]
      def pretty_print(q)
        q.text("FileInput")
        q.group(2, "(", ")") do
          preview = take(4)
          preview = if preview.empty?
                      "EOF"
                    elsif preview.length <= 3
                      preview.inspect
                    else
                      (preview.take(3) << "...").inspect
                    end

          q.text preview
          q.text " at line #{@line}, column #{@column}, offset #{@offset}, file #{File.basename(@io.path)}"
        end
      end

    private

      # @return [FileInput]
      def copy(changes = {})
        FileInput.new \
          changes.fetch(:io, @io),
          changes.fetch(:offset, @offset),
          changes.fetch(:line, @line),
          changes.fetch(:column, @column),
          changes.fetch(:size, @size)
      end
    end

  end
end
