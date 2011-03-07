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

      def read_isa_segment
        consume_isa.flatmap do |rest|
          separators = OpenStruct.new

          rest.read_character.flatmap do |a|
            separators.element_separator = a.value

          end
        end
      end

    protected

      # Consume the next occurence of "ISA"
      #
      # @return [Either<StreamReader>]
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

        failure("Reached end of input before finding ISA segment id")
      end

      # Read up to the next occurrence of element_separator and consume the separator
      def read_simple_element(element_separator)
        if position = @input.index(element_separator)
          result(@input.take(position), advance(position + 1))
        else
          failure("Reached end of input before finding an element separator")
        end
      end

      def read_nth_element(element_separator, n, value = nil)
        if n.zero?
          result(value, self)
        else
          read_simple_element(element_separator).flatmap do |value, rest|
            read_nth_element(element_separator, n - 1, value)
          end
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
