# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Reader

    class RepeatedElementTok
      include Inspect

      # @return [Array<CompositeElementTok>]
      # @return [Array<SimpleElementTok>]
      attr_reader :element_toks

      attr_reader :position

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

      def blank?
        @element_toks.all?(&:blank?)
      end

      def present?
        not blank?
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
