module Stupidedi
  module FiftyTen
    module Readers

      class TableReader
        include Reader::TokenReader

        attr_reader :input, :interchange_header

        attr_reader :table_def

        def initialize(input, interchange_header, loop_def)
          @input, @interchange_header, @table_def =
            input, interchange_header, table_def
        end

        def read_table
          #
        end
      end

    end
  end
end
