module Stupidedi
  module Envelope

    class TransactionSetVal < Values::AbstractVal
      include Inspect

      # @return [TransactionSetDef]
      attr_reader :definition

      # @return [Array<TableVal>]
      attr_reader :child_vals

      # @return [FunctionalGroupVal]
      attr_reader :parent

      def initialize(definition, child_vals, parent)
        @definition, @child_vals, @parent =
          definition, child_vals, parent
      end

      # @return [TransactionSetVal]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:child_vals, @child_vals),
          changes.fetch(:parent, @parent)
      end

      # @return [TransactionSetVal]
      def append(child_val)
        copy(:child_vals => child_val.snoc(@child_vals))
      end
      alias append_table append

      # @return [TransactionSetVal]
      def append!(child_val)
        @child_vals = child_val.snoc(@child_vals)
        self
      end
      alias append_table! append!

      # @return [void]
      def pretty_print(q)
        id = @definition.try{|d| "[#{d.functional_group}#{d.id}]" }
        q.text("TransactionSetVal#{id}")
        q.group(2, "(", ")") do
          q.breakable ""
          @child_vals.each do |e|
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
        "InterchangeVal(#{@child_vals.map(&:inspect).join(', ')})"
      end

      # @return [Boolean]
      def ==(other)
        other.definition == @definition and
        other.child_vals == @child_vals
      end
    end

  end
end
