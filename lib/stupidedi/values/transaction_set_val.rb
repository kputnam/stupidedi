module Stupidedi
  module Values

    class TransactionSetVal
      attr_reader :definition

      # @return [FunctionalGroupVal]
      attr_reader :parent

      def initialize(definition, parent)
        @definition, @parent = definition, parent
      end

      # @return [TransactionSetVal]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:definiton, @definiton),
          changes.fetch(:parent, @parent)
      end
    end

  end
end
