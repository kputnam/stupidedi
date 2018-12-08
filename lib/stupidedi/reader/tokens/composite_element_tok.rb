# frozen_string_literal: true
module Stupidedi
  using Refinements

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

      # @return [CompositeElementTok]
      def copy(changes = {})
        CompositeElementTok.new \
          changes.fetch(:component_toks, @component_toks),
          changes.fetch(:position, @position),
          changes.fetch(:remainder, @remainder)
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

      def present?
        not blank?
      end

      def simple?
        false
      end

      def composite?
        true
      end

      def to_s(separators)
        if blank?
          ""
        else
          cs = @component_toks.map{|x| x.to_s(separators) }
          cs.join(separators.component)
        end
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
