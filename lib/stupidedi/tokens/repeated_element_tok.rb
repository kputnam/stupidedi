# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Tokens
    class RepeatedElementTok
      include Inspect

      # @return [Array<CompositeElementTok>]
      # @return [Array<SimpleElementTok>]
      attr_reader :element_toks

      attr_reader :position

      def initialize(element_toks, position)
        @element_toks = element_toks
        @position     = position
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

      def to_x12(separators)
        if blank?
          ""
        else
          rs = @element_toks.map{|x| x.to_x12(separators) }
          rs.join(separators.repetition || "^")
        end
      end
    end

    class << RepeatedElementTok
      #########################################################################
      # @group Constructors

      # @return [RepeatedElementTok]
      def build(element_toks, position)
        new(element_toks, position)
      end

      # @endgroup
      #########################################################################
    end
  end
end
