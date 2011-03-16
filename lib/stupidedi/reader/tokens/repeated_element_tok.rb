module Stupidedi
  module Reader
    
    class RepeatedElementTok

      # @return [Array<CompositeElementTok>]
      # @return [Array<SimpleElementTok>]
      attr_reader :element_toks

      def initialize(element_toks)
        @element_toks = element_toks
      end

      def repeat(element_tok)
        @element_toks.unshift(element_tok)
        self
      end

      def pretty_print(q)
        q.pp(:repeated.cons(@element_toks))
      end

      def repeated?
        true
      end

      def blank?
        false
      end
    end

    class << RepeatedElementTok

      # @return [RepeatedElementTok]
      def build(element_toks)
        RepeatedElementTok.new(element_toks)
      end
    end

  end
end
