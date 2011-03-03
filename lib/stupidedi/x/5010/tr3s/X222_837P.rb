module Stupidedi
  module FiftyTen
    module TR3s

      module X222
        class TransactionSetHeaderReader < Interchange::TransactionSetHeaderReader
          attr_reader :input, :interchange_header

          def initialize(input, interchange_header)
            @input, @interchange_header = input, interchange_header
          end
        end

        class << TransactionSetHeaderReader
          def versions
            /^005010X222(A\d*)?$/
          end
        end
      end

    end
  end
end
