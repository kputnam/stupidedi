module Stupidedi
  module Editor

    class TransactionSetEd < AbstractEd

      def initialize(config)
        @config = config
      end

      def validate(st, received = Time.now.utc)
      end

    end

  end
end
