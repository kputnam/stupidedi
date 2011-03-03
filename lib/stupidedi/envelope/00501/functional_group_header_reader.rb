module Stupidedi
  module Interchange
    module FiveOhOne

      class FunctionalGroupHeaderReader
        include Reader::TokenReader

        attr_reader :input, :interchange_header

        def initialize(input, interchange_header)
          @input, @interchange_header = input, interchange_header
        end

        # Parses the GS segment
        #   TODO: Replace nested flatmaps with read_segment(FiftyTen::Dictionaries::SegmenDict::GS)
        def read_functional_group_header
          consume_prefix("GS").flatmap{|rest|      rest.consume_prefix(interchange_header.element_separator).flatmap{|rest|
          rest.read_simple_element.flatmap{|r| gs01, c = *r; c.consume_prefix(interchange_header.element_separator).flatmap{|rest|
          rest.read_simple_element.flatmap{|r| gs02, c = *r; c.consume_prefix(interchange_header.element_separator).flatmap{|rest|
          rest.read_simple_element.flatmap{|r| gs03, c = *r; c.consume_prefix(interchange_header.element_separator).flatmap{|rest|
          rest.read_simple_element.flatmap{|r| gs04, c = *r; c.consume_prefix(interchange_header.element_separator).flatmap{|rest|
          rest.read_simple_element.flatmap{|r| gs05, c = *r; c.consume_prefix(interchange_header.element_separator).flatmap{|rest|
          rest.read_simple_element.flatmap{|r| gs06, c = *r; c.consume_prefix(interchange_header.element_separator).flatmap{|rest|
          rest.read_simple_element.flatmap{|r| gs07, c = *r; c.consume_prefix(interchange_header.element_separator).flatmap{|rest|
          rest.read_simple_element.flatmap{|r| gs08, c = *r; c.consume_prefix(interchange_header.segment_terminator).map{|rest|
            header = FunctionalGroupHeader.new(gs01, gs02, gs03, gs04, gs05, gs06, gs07, gs08)
            Reader::Success.new(header, header.reader(rest.input, interchange_header))
          }}}}}}}}}}}}}}}}}}
        end

        alias read read_functional_group_header

      private

        def advance(n)
          unless @input.defined_at?(n-1)
            raise IndexError, "Less than #{n} characters available"
          else
            self.class.new(@input.drop(n), @interchange_header)
          end
        end
      end

    end
  end
end
