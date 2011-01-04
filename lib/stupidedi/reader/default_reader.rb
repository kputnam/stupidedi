module Stupidedi
  module Reader

    class DefaultReader
      include TokenReader

      attr_reader \
        :input,
        :interchange_header

      def initialize(input, interchange_header)
        @input, @interchange_header = input, interchange_header
      end

      def default
        self
      end

    private

      def advance(n)
        unless @input.defined_at?(n-1)
          raise indexerror, "Less than #{n} characters available"
        else
          self.class.new(@input.drop(n), @interchange_header)
        end
      end
    end

    class << DefaultReader
      def from_reader(reader)
        DefaultReader.new(reader.input, reader.interchange_header)
      end
    end

  end
end
