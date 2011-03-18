module Stupidedi
  module Reader

    class SimpleElementTok

      # @todo
      attr_reader :value

      # @todo
      attr_reader :start

      # @todo
      attr_reader :remainder

      def initialize(value, start, remainder)
        @value, @start, @remainder =
          value, start, remainder
      end

      def pretty_print(q)
        q.pp(:simple.cons(@value.cons))
      end

      def repeat(element)
        RepeatedElementTok.new([element, self])
      end

      def repeated?
        false
      end

      def blank?
        @value.blank?
      end

      def simple?
        true
      end
    end

    class << SimpleElementTok
      def build(value, start, remainder)
        new(value, start, remainder)
      end
    end

  end
end
