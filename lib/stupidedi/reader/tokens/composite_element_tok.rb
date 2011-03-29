module Stupidedi
  module Reader

    class CompositeElementTok
      include Inspect

      # @return [Array<ComponentElementTok>]
      attr_reader :component_toks

      # @return [Position]
      attr_reader :start

      # @return [Position]
      attr_reader :remainder

      def initialize(component_toks, start, remainder)
        @component_toks, @start, @remainder =
          component_toks, start, remainder
      end

      def pretty_print(q)
        q.pp(:composite.cons(@component_toks))
      end

      def repeated
        RepeatedElementTok.new(self.cons)
      end

      def repeated?
        false
      end

      def blank?
        @component_toks.all?(&:blank?)
      end

      def simple?
        false
      end
    end

    class << CompositeElementTok
      # @group Constructors
      #########################################################################

      # @return [CompositeElementTok]
      def build(component_toks, start, remainder)
        new(component_toks, start, remainder)
      end

      # @endgroup
      #########################################################################
    end

  end
end
