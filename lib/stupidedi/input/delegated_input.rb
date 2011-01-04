module Stupidedi
  module Input

    class DelegatedInput < AbstractInput
      attr_reader :delegate, :offset, :line, :column

      def initialize(delegate, offset, line, column)
        @delegate, @offset, @line, @column = delegate, offset, line, column
      end

      def defined_at?(n)
        delegate.defined_at?(n)
      end

      def empty?
        delegate.empty?
      end

      def drop(n)
        raise ArgumentError, "n (#{n}) must be positive" unless n >= 0

        suffix = delegate.drop(n)
        prefix = delegate.take(n)

        self.class.new(suffix, @offset + prefix.length, @line + prefix.count("\n"), 0)
      end

      def take(n)
        raise ArgumentError, "n (#{n}) must be positive" unless n >= 0
        delegate.take(n)
      end

      def at(n)
        raise ArgumentError, "n (#{n}) must be positive" unless n >= 0
        delegate.at(n)
      end

      def index(value)
        delegate.index(value)
      end

      def ==(other)
        if self.class === other
          @delegate == other.delegate
        else
          @delegate == other
        end
      end
    end

  end
end
