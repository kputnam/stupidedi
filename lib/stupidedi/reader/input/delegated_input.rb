module Stupidedi
  module Reader

    class DelegatedInput < AbstractInput

      # @return [Integer]
      attr_reader :offset

      # @return [Integer]
      attr_reader :line

      # @return [Integer]
      attr_reader :column

      delegate :defined_at?, :empty?, :take, :at, :index, :to => :@delegate

      def initialize(delegate, offset = 0, line = 1, column = 1)
        @delegate, @offset, @line, @column = delegate, offset, line, column
      end

      # @return [DelegatedInput]
      def drop(n)
        raise ArgumentError, "n (#{n}) must be positive" unless n >= 0

        suffix = delegate.drop(n)
        prefix = delegate.take(n)

        length = prefix.length
        count  = prefix.count("\n")

        column = unless count.zero?
                   length - prefix.rindex("\n")
                 else
                   @column + length
                 end

        copy(:delegate => suffix,
             :offset   => @offset + length,
             :line     => @line + count,
             :column   => column)
      end

      # @return [DelegatedInput]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:delegate, @delegate),
          changes.fetch(:offset, @offset),
          changes.fetch(:line, @line),
          changes.fetch(:column, @column)
      end

      def position
        Position.new(@offset, @line, @column, nil)
      end

      # @return [void]
      def pretty_print(q)
        q.text("DelegateInput")
        q.group(2, "(", ")") do
          preview = @delegate.take(4)
          preview = if preview.empty?
                      "EOF"
                    elsif preview.length <= 3
                      preview.inspect
                    else
                      (preview.take(3) << "...").inspect
                    end

          q.text preview
          q.text " at line #{@line}, column #{@column}, offset #{@offset}"
        end
      end
    end

  end
end
