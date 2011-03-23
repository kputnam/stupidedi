module Stupidedi
  module Envelope

    class TransactionSetVal < Values::AbstractVal
      include Inspect

      # @return [TransactionSetDef]
      attr_reader :definition

      # @return [Array<TableVal>]
      attr_reader :children

      def initialize(definition, children)
        @definition, @children =
          definition, children
      end

      # @return [TransactionSetVal]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:children, @children)
      end

      # @return false
      def leaf?
        false
      end

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
        "Transaction(#{@children.map(&:inspect).join(', ')})"
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
