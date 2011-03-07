module Stupidedi
  module Reader

    #
    # The StreamReader is intended to scan the input for a valid ISA segment, after
    # which the TokenReader class can be used to tokenize the remaining input.
    #
    # Because X12 specifications have no bearing on what happens outside the interchange
    # envelope (from ISA to ISE), out-of-band data like blank lines, human readable text,
    # etc can occur between interchanges. This reader is built to deal with that problem.
    #
    class StreamReader
      attr_reader :input

      def initialize(input)
        @input = input
      end

      def copy(changes = {})
        self.class.new \
          changes.fetch(:input, @input)
      end

      # Returns true if there is no remaining input
      def empty?
        @input.empty?
      end

      # Read a single character
      #
      # @return [Either<Result<String, StreamReader>>]
      def read_character
        unless @input.empty?
          result(@input.at(0), advance(1))
        else
          failure("Less than one character available")
        end
      end

      # Skip a single character
      #
      # @return [Either<StreamReader>]
      def consume_character
        unless @input.empty?
          success(advance(1))
        else
          failure("Less than one character available")
        end
      end

      # This method is unaware of subtle differences between interchange versions,
      # so it really only tokenizes 16 elements, plus the element terminator and
      # segment separators. It does not presume to understand the meaning of the
      # elements, like the repetition separator or the component separator, because
      # these are interchange version-dependent.
      #
      # @return [Either<Result<Array(:segment, :ISA, [:simple, "..."], [...], ...), TokenReader>>]
      def read_isa_segment
        consume_isa.flatmap do |rest|
          # The character after "ISA" is defined to be the element separator
          rest.read_character.flatmap do |a|
            segment = :segment.cons(:ISA.cons)
            delims  = OpenStruct.new
            last    = Either.success(TokenReader.new(a.remainder.input, delims))

            # The TokenReader maintains a reference to {delims}, so when we
            # mutate {delims}, we are passing information to the TokenReader.
            delims.element_separator = a.value

            # Read 15 simple elements into an array. Consume/discard the element
            # separator that follows each one.
            15.times do
              last =
                last.flatmap(&:read_simple_element).flatmap do |x|
                  segment << :simple.cons(x.value.cons)

                  # Throw away the following element separator
                  x.remainder.consume_prefix(delims.element_separator)
                end
            end

            # We have to assume the last (16th) element is fixed-length because
            # it is not terminated by an element delimiter. The {read_character}
            # method here skips past control characters.
            last.flatmap(&:read_character).flatmap do |x|
              segment << :simple.cons(x.value.cons)

              # The character after the last element is defined to be the segment
              # terminator. The {read_character} method here does *not* skip past
              # control character, so the delimiter could be a control character.
              x.remainder.stream.read_character.flatmap do |y|
                delims.segment_terminator = y.value
                result(segment, TokenReader.new(y.remainder.input, delims))
              end
            end
          end.or do
            # We read "ISA" but failed to tokenize the input that followed. This was
            # probably a random occurrence of the sequence "ISA", so we'll skip past
            # it and try again.
            #
            # @todo: We should log this as a warning, because we could otherwise be
            # silently discarding an entire interchange if the ISA segment was bogus
            rest.read_isa_segment
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

        failure("Reached end of input before finding ISA segment identifier")
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
