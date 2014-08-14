module Stupidedi
  module Reader

    class RepeatedElementTok
      include Inspect

      # @return [Array<CompositeElementTok>]
      # @return [Array<SimpleElementTok>]
      attr_reader :element_toks

      attr_reader :position

      extend Forwardable
      def_delegators "element_toks.last", :remainder
  
      def initialize(element_toks, position)
        @element_toks, @position =
          element_toks, position
      end

      def repeated(element_tok)
        @element_toks.unshift(element_tok)
        self
      end

      def pretty_print(q)
        q.pp(:repeated.cons(@element_toks))
      end

      def simple?
        false
      end

      def repeated?
        true
      end

      def blankness?
        @element_toks.all?(&:blankness?)
      end

      def is_present?
        not blankness?
      end

      def composite?
        false
      end
    end

    class << RepeatedElementTok
      # @group Constructors
      #########################################################################

      # @return [RepeatedElementTok]
      def build(element_toks, position)
        new(element_toks, position)
      end

      # @endgroup
      #########################################################################
    end

  end
end
