module Stupidedi
  module Reader

    class CompositeElementTok
      include Inspect

      # @return [Array<ComponentElementTok>]
      attr_reader :component_toks

      # @return [Position]
      attr_reader :position

      # @return [Position]
      attr_reader :remainder

      def initialize(component_toks, position, remainder)
        @component_toks, @position, @remainder =
          component_toks, position, remainder
      end

      def pretty_print(q)
        q.pp(:composite.cons(@component_toks))
      end

      def repeated
        RepeatedElementTok.new(self.cons, @position)
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

      def composite?
        true
      end
    end

    class << CompositeElementTok
      # @group Constructors
      #########################################################################

      # @return [CompositeElementTok]
      def build(component_toks, position, remainder)
        new(component_toks, position, remainder)
      end

      # @endgroup
      #########################################################################
    end

  end
end
