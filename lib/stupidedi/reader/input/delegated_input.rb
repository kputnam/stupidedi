module Stupidedi
  module Reader

    class DelegatedInput < Input
      attr_reader :delegate, :offset, :line, :column

      delegate :defined_at?, :empty?, :take, :at, :index, :to => :@delegate

      def initialize(delegate, offset = 0, line = 1, column = 1)
        @delegate, @offset, @line, @column = delegate, offset, line, column
      end

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

        self.class.new(suffix,
                       @offset + length,
                       @line   + count,
                       column)
      end

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

      def ==(other)
        if other.is_a?(DelegatedInput)
          @delegate == other.delegate
        else
          @delegate == other
        end
      end
    end

  end
end
