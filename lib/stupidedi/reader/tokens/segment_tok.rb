module Stupidedi
  module Reader
    
    class SegmentTok

      # @return [Symbol]
      attr_reader :id

      # @return [Array<CompositeElementVal, SimpleElementVal>]
      attr_reader :elements

      # @todo
      attr_reader :start

      # @todo
      attr_reader :remainder

      def initialize(id, elements, start, remainder)
        @id, @elements, @start, @remainder =
          id, elements, start, remainder
      end

      def pretty_print(q)
        q.pp(:segment.cons(@id.cons(@elements)))
      end
    end

    class << SegmentTok
      def build(id, elements, start, remainder)
        new(id, elements, start, remainder)
      end
    end

  end
end
