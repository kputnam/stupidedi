module Stupidedi
  module Reader

    class SegmentTok
      include Inspect

      # @return [Symbol]
      attr_reader :id

      # @return [Array<CompositeElementTok, SimpleElementTok>]
      attr_reader :element_toks

      # @todo
      attr_reader :start

      # @todo
      attr_reader :remainder

      def initialize(id, element_toks, start, remainder)
        @id, @element_toks, @start, @remainder =
          id, element_toks, start, remainder
      end

      def pretty_print(q)
        q.pp(:segment.cons(@id.cons(@element_toks)))
      end

      def blank?
        @element_toks.all(&:blank?)
      end
    end

    class << SegmentTok
      def build(id, element_toks, start, remainder)
        new(id, element_toks, start, remainder)
      end
    end

  end
end
