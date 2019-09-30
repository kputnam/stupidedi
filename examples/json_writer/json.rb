# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Writer
    class Json
      def initialize(node)
        @node = node
      end

      # @return [Hash]
      def write(out = Hash.new { |k, v| self[k] = v })
        build(@node, out)
        out
      end

      private

      def resolve_traverser(node)
        case
        when node.transmission?
          Transmission
        when node.interchange?
          Interchange
        when node.segment?
          Segment
        when node.loop?
          Loop
        when node.element?
          Element
        when node.functional_group?
          FunctionalGroup
        when node.transaction_set?
          TransactionSet
        when node.table?
          Table
        else
          NullNode
        end.new(node)
      end

      def build(node, out)
        traverser = resolve_traverser(node)

        traverser.reduce(out) do |children, memo = {}|
          build(children, memo)
        end

        out
      end
    end
  end
end
