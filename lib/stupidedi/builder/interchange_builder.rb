module Stupidedi
  module Builder

    class InterchangeBuilder
      def initialize(transmission_builder, interchange_val)
        @transmission_builder, @interchange_val =
          transmission_builder, interchange_val
      end
    end

  end
end
