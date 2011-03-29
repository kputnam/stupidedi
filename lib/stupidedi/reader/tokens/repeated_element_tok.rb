module Stupidedi
  module Reader

    class RepeatedElementTok
      include Inspect

      # @return [Array<CompositeElementTok>]
      # @return [Array<SimpleElementTok>]
      attr_reader :element_toks

      def initialize(element_toks)
        @element_toks = element_toks
      end

      def repeated(element_tok)
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
        @element_toks.all?(&:blank?)
      end
    end

    class << RepeatedElementTok
      # @group Constructors
      #########################################################################

      # @return [RepeatedElementTok]
      def build(element_toks)
        new(element_toks)
      end

      # @endgroup
      #########################################################################
    end

  end
end
