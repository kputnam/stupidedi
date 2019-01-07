# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Values
    class TransactionSetVal < AbstractVal
      include SegmentValGroup

      # @return [TransactionSetDef]
      attr_reader :definition

      # @return [Array<TableVal>]
      attr_reader :children

      def_delegators "@children.head", :position

      def initialize(definition, children)
        @definition, @children =
          definition, children
      end

      # @return [TransactionSetVal]
      def copy(changes = {})
        TransactionSetVal.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:children, @children)
      end

      # (see AbstractSet#transaction_set?)
      # @return true
      def transaction_set?
        true
      end

      # @return [void]
      def pretty_print(q)
        id = @definition.try do |d|
          ansi.bold("[#{d.functional_group}#{d.id}]")
        end

        q.text(ansi.envelope("TransactionSetVal#{id}"))
        q.group(2, "(", ")") do
          q.breakable ""
          @children.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end
        end
      end

      # @return [String]
      def inspect
        ansi.envelope("Transaction") + "(#{@children.map(&:inspect).join(", ")})"
      end

      # @return [Boolean]
      def ==(other)
        eql?(other) or
         (other.definition == @definition and
          other.children   == @children)
      end
    end
  end
end
