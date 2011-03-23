module Stupidedi
  module Envelope

    class TransactionSetVal < Values::AbstractVal
      include Inspect

      # @return [TransactionSetDef]
      attr_reader :definition

      # @return [Array<TableVal>]
      attr_reader :children

      # @return [FunctionalGroupVal]
      attr_reader :parent

      def initialize(definition, children, parent)
        @definition, @children, @parent =
          definition, children, parent
      end

      # @return [TransactionSetVal]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:children, @children),
          changes.fetch(:parent, @parent)
      end

      # @return false
      def leaf?
        false
      end

      # @return [TransactionSetVal]
      def append(child_val)
        copy(:children => child_val.snoc(@children))
      end
      alias append_table append

      # @return [TransactionSetVal]
      def append!(child_val)
        @children = child_val.snoc(@children)
        self
      end
      alias append_table! append!

      # @return [void]
      def pretty_print(q)
        id = @definition.try{|d| "[#{d.functional_group}#{d.id}]" }
        q.text("TransactionSetVal#{id}")
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
        "TransactionSetVal(#{@children.map(&:inspect).join(', ')})"
      end

      # @return [Boolean]
      def ==(other)
        other.definition == @definition and
        other.children == @children
      end
    end

  end
end
