module Stupidedi
  module FiftyTen
    module TR3s

      module X230
        class TransactionSetHeaderReader < Interchange::TransactionSetHeaderReader
          attr_reader :input, :interchange_header

          def initialize(input, interchange_header)
            @input, @interchange_header = input, interchange_header
          end
        end

        TransactionSetHeaderReader.eigenclass.send(:public, :new)
      end

      class << X230
        def transaction_set_header_reader(input, interchange_header)
          X230::TransactionSetHeaderReader.new(input, interchange_header)
        end
      end

    end
  end
end
