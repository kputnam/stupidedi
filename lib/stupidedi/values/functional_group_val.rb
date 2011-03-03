module Stupidedi
  module Values

    class FunctionalGroupVal
      include SegmentValGroup

      # @return [FunctionalGroupDef]
      attr_reader :definition

      # @return [Array<SegmentVal>]
      attr_reader :segment_vals

      # @return [Array<TransactionSetVal>]
      attr_reader :transaction_set_vals

      # @return [InterchangeVal]
      attr_reader :parent

      def initialize(definition, segment_vals, transaction_set_vals, parent)
        @definition, @segment_vals, @transaction_set_vals, @parent =
          definition, segment_vals, transaction_set_vals, parent
      end

      # @return [FunctionalGroupVal]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:segment_vals, @segment_vals),
          changes.fetch(:transaction_set_vals, @transaction_set_vals),
          changes.fetch(:parent, @parent)
      end

      def empty?
        @segment_vals.all(&:empty?) and @transaction_set_vals.all(&:empty?)
      end

      def append(val)
        if val.is_a?(TransactionSetVal)
          copy(:transaction_set_vals => val.snoc(@transaction_set_vals))
        else
          copy(:segment_vals => val.snoc(@segment_vals))
        end
      end

      def prepend(val)
        if val.is_a?(TransactionSetVal)
          copy(:transaction_set_vals => val.cons(@transaction_set_vals))
        else
          copy(:segment_vals => val.cons(@segment_vals))
        end
      end
    end

  end
end
