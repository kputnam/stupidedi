module Stupidedi
  module Reader
    
    class CompositeElementTok

      # @return [Array<ComponentElementTok>]
      attr_reader :component_toks

      # @todo
      attr_reader :start

      # @todo
      attr_reader :remainder

      def initialize(component_toks, start, remainder)
        @component_toks, @start, @remainder =
          component_toks, start, remainder
      end

      def pretty_print(q)
        q.pp(:composite.cons(@component_toks))
      end

      def repeat(composite_tok)
        RepeatedElementTok.new([composite_tok, self])
      end

      def repeated?
        false
      end

      def blank?
        @component_toks.blank?
      end

      def simple?
        false
      end
    end

    class << CompositeElementTok
      def build(component_toks, start, remainder)
        new(component_toks, start, remainder)
      end
    end

  end
end
