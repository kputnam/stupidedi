module Stupidedi
  module Reader

    #
    # The {StreamReader} is intended to scan the input for a valid ISA segment,
    # after which the {TokenReader} class can be used to tokenize the remaining
    # input.
    #
    # Because X12 specifications have no bearing on what happens outside the
    # interchange envelope (from `IEA` to `ISA`), out-of-band data like blank
    # lines, human readable text, etc can occur between interchanges. This
    # reader is designed to deal with that problem.
    #
    class StreamReader
      include Inspect

      attr_reader :input

      def initialize(input)
        @input = input
      end

      # @return true
      def stream?
        true
      end

      # True if there is no remaining input
      def empty?
        @input.empty?
      end

      # Read a single character
      #
      # @return [Either<Result<Character, StreamReader>>]
      def read_character
        unless @input.empty?
          result(@input.at(0), advance(1))
        else
          failure("less than one character available")
        end
      end

      # Skip a single character
      #
      # @return [Either<StreamReader>]
      def consume_character
        unless @input.empty?
          success(advance(1))
        else
          failure("less than one character available")
        end
      end

      # This method is unaware of subtle differences between interchange
      # versions, so it really only tokenizes 16 elements, plus the element
      # terminator and segment separators. It does not presume to understand
      # the meaning of the elements, like the repetition separator or the
      # component separator, because these are interchange version-dependent.
      #
      # @return [Either<Result<SegmentTok TokenReader>>]
      def read_segment
        consume_isa.flatmap do |rest|
          # The character after "ISA" is defined to be the element separator
          rest.read_character.flatmap do |a|
            separators = Separators.new(nil, nil, a.value, nil)
            remaining  = success(TokenReader.new(a.remainder.input, separators))
            elements   = []

            # Read 15 simple elements into an array. Consume/discard the element
            # separator that follows each one.
            15.times do
              remaining =
                remaining.flatmap(&:read_simple_element).flatmap do |x|
                  elements << x.value

                  # Throw away the following element separator
                  x.remainder.consume_prefix(separators.element)
                end
            end

            # We have to assume the last (16th) element is fixed-length because
            # it is not terminated by an element separator. The {read_character}
            # method defined by TokenReader skips past control characters.
            remaining.flatmap do |w|
              w.read_character.flatmap do |x|
                elements << SimpleElementTok.build(x.value, w.input, x.remainder.input)

                # The character after the last element is defined to be the
                # segment terminator. The {read_character} method here, defined
                # by StreamReader, does not skip past control character, so the
                # separator could be a control character.
                x.remainder.stream.read_character.flatmap do |y|
                  if y.value == separators.element
                    failure("element separator and segment terminator must be distinct", x.remainder.input)
                  else
                    separators.segment = y.value

                    token = SegmentTok.build(:ISA, elements,
                      rest.input.position, y.remainder.input.position)

                    result(token, TokenReader.new(y.remainder.input, separators))
                  end
                end
              end
            end
          end.or do |x|
            # We read "ISA" but failed to tokenize the input that followed. This
            # was probably a random occurrence of the sequence "ISA", so we'll
            # skip past it and try again.
            #
            # @todo: We should log this as a warning, because we could otherwise
            # be silently discarding an entire interchange if the ISA segment
            # was bogus
            rest.read_segment
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

        # @todo: This would probably more optimal if it was written like
        # consume("I") >>= consume_prefix("S") >>= consume_prefix("A")
        while @input.defined_at?(position)
          character = @input.at(position)
          position += 1

          unless Reader.is_control_character?(character)
            # Slide the "window" forward one character
            buffer = buffer.slice!(1..-1) << character.upcase

            if buffer == "ISA"
              return success(advance(position))
            end
          end
        end

        failure("reached end of input before finding ISA segment identifier")
      end

    private

      def advance(n)
        unless @input.defined_at?(n-1)
          raise IndexError, "less than #{n} characters available"
        else
          StreamReader.new(@input.drop(n))
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
