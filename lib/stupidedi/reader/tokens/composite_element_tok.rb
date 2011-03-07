module Stupidedi
  module Reader
    
    class CompositeElementTok

      # @return [String]
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
        q.pp(:composite.cons(@value))
      end

      def repeat(element)
        RepeatedElementTok.new([element, self])
      end
    end

    class << CompositeElementTok
      def build(value, start, remainder)
        new(value, start, remainder)
      end
    end

  end
end
