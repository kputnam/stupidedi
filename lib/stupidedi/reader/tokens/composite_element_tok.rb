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

      def initialize(component_toks, position)
        @component_toks, @position =
          component_toks, position
      end

      # @return [CompositeElementTok]
      def copy(changes = {})
        CompositeElementTok.new \
          changes.fetch(:component_toks, @component_toks),
          changes.fetch(:position, @position)
      end

      # :nocov:
      def pretty_print(q)
        q.pp(:composite.cons(@component_toks))
      end
      # :nocov:

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

      def to_x12(separators)
        if blank?
          ""
        else
          cs  = @component_toks.map{|x| x.to_x12(separators) }
          sep = separators.component || ":"
          cs.join(sep).gsub(/#{Regexp.escape(sep)}+$/, "")
        end
      end
    end

    class << CompositeElementTok
      # @group Constructors
      #########################################################################

      # @return [CompositeElementTok]
      def build(component_toks, position)
        new(component_toks, position)
      end

      # @endgroup
      #########################################################################
    end
  end
end
