module Stupidedi
  module Reader

    class StreamReader
      attr_reader :input

      def initialize(input)
        @input = input
      end

      # Returns true if there is no remaining input
      def empty?
        @input.empty?
      end

      # Read a single character
      def read_character
        unless @input.empty?
          result(@input.at(0), advance(1))
        else
          failure("Less than one character available")
        end
      end

      def read_interchange_header
        consume_isa.flatmap{|rest|
        rest.read_character.flatmap{|r|      element_separator, rest = *r
        rest.read_element(element_separator).flatmap{|r| isa01, rest = *r
        rest.read_element(element_separator).flatmap{|r| isa02, rest = *r
        rest.read_element(element_separator).flatmap{|r| isa03, rest = *r
        rest.read_element(element_separator).flatmap{|r| isa04, rest = *r
        rest.read_element(element_separator).flatmap{|r| isa05, rest = *r
        rest.read_element(element_separator).flatmap{|r| isa06, rest = *r
        rest.read_element(element_separator).flatmap{|r| isa07, rest = *r
        rest.read_element(element_separator).flatmap{|r| isa08, rest = *r
        rest.read_element(element_separator).flatmap{|r| isa09, rest = *r
        rest.read_element(element_separator).flatmap{|r| isa10, rest = *r
        rest.read_element(element_separator).flatmap{|r| isa11, rest = *r
        rest.read_element(element_separator).flatmap{|r| isa12, rest = *r
        rest.read_element(element_separator).flatmap{|r| isa13, rest = *r
        rest.read_element(element_separator).flatmap{|r| isa14, rest = *r
        rest.read_element(element_separator).flatmap{|r| isa15, rest = *r
        rest.read_character.flatmap{|r| isa16, rest                  = *r
        rest.read_character.flatmap{|r| segment_terminator, rest     = *r
          case isa12
          when "00501" then success(Interchange::FiveOhOne)
          when "00401" then success(Interchange::FourOhOne)
          else              failure("Unrecognized value in ISA12 #{isa12.inspect}")
          end.map do |version|
            header = version.interchange_header(element_separator, segment_terminator,
                                                isa01, isa02, isa03, isa04, isa05, isa06, isa07, isa08,
                                                isa09, isa10, isa11, isa12, isa13, isa14, isa15, isa16)
            Success.new(header, header.reader(rest.input))
          end
        }}}}}}}}}}}}}}}}}}}
      end

      alias read read_interchange_header

    protected

      # Consume the next occurence of "ISA"
      def consume_isa
        position = 0
        buffer   = "   "

        while @input.defined_at?(position)
          character = @input.at(position)
          position += 1

          if Reader.is_basic_character?(character) or Reader.is_extended_character?(character)
            buffer.slice!(0)
            buffer << character.upcase
          end

          if buffer == "ISA"
            return success(advance(position))
          end
        end

        return failure("Reached end of input before finding ISA segment id")
      end

      # Read up to the next occurrence of element_separator and consume the separator
      def read_element(element_separator)
        if position = @input.index(element_separator)
          result(@input.take(position), advance(position + 1))
        else
          failure("Reached end of input before finding an element separator")
        end
      end

    private

      def advance(n)
        unless @input.defined_at?(n-1)
          raise IndexError, "Less than #{n} characters available"
        else
          self.class.new(@input.drop(n))
        end
      end

      def failure(message, remainder = input)
        Either.failure(Reader::Failure.new(message, remainder))
      end

      def success(value)
        Either.success(value)
      end

      def result(value, remainder)
        Either.success(Reader::Success.new(value, remainder))
      end

    end
  end
end
