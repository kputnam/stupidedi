module Stupidedi
  module Reader

    class TokenReader

      # @private
      SEGMENT_ID =  /\A[A-Z][A-Z0-9]{1,2}\Z/

      include Inspect

      # @return [String, Input]
      attr_reader :input

      # @return [Separators]
      attr_reader :separators

      # @return [SegmentDict]
      attr_accessor :segment_dict

      def initialize(input, separators, segment_dict = SegmentDict.empty)
        @input, @separators, @segment_dict =
          input, separators, segment_dict
      end

      # @return [TokenReader]
      def copy(changes = {})
        TokenReader.new \
          changes.fetch(:input, @input),
          changes.fetch(:separators, @separators),
          changes.fetch(:segment_dict, @segment_dict)
      end

      # @return false
      def stream?
        false
      end

      # @return [StreamReader]
      def stream
        StreamReader.new(@input)
      end

      def empty?
        @input.empty?
      end

      # If `s` is a prefix of {#input}, then `s` is skipped and the remaining
      # input is returned as a new `TokenReader` wrapped by `Either.success`.
      # Otherwise, an {Either::Failure} is returned.
      #
      # @return [Either<TokenReader>]
      def consume_prefix(s)
        return success(self) if s.empty?

        position = 0
        buffer   = ""

        while @input.defined_at?(position)
          character = @input.at(position)
          position += 1

          unless is_control?(character)
            buffer << character

            if s.length == buffer.length
              if s == buffer
                return success(advance(position))
              else
                return failure("found #{buffer.inspect} instead of #{s.inspect}")
              end
            end
          end
        end

        failure("reached end of input without finding #{s.inspect}")
      end

      # If `s` occurs within {#input}, then the input up to and including `s`
      # is skipped and the remaining input is returned as a new `TokenReader`
      # wrapped by `Either.success`. Otherwise, {Either::Failure} is returned.
      #
      # @return [Either<TokenReader>]
      def consume(s)
        return success(self) if s.empty?

        position = 0
        buffer   = " " * s.length

        while @input.defined_at?(position)
          character = @input.at(position)

          unless is_control?(character)
            # Slide the "window" forward one character
            buffer = buffer.slice(1..-1) << character
          end

          position += 1

          if s == buffer
            return success(advance(position))
          end
        end

        failure("reached end of input without finding #{s.inspect}")
      end

      # Returns a single character and the remaining input as a {Result} with
      # a `value` of the character and a `remainder` of the reamining input as
      # a new instance of {TokenReader}. If {#input} has less than a single
      # character, returns an {Either::Failure}
      #
      # @return [Either<Result<String>>]
      def read_character
        position = 0
        buffer   = ""

        while @input.defined_at?(position)
          character = @input.at(position)
          position += 1

          if is_control?(character)
            next
          end

          return result(character, advance(position))
        end

        failure("less than one character available")
      end

      # @return [Either<Result<SegmentTok, TokenReader>>]
      def read_segment
        read_segment_id.flatmap do |a|
          if @segment_dict.defined_at?(a.value)
            element_uses = @segment_dict.at(a.value).element_uses
          else
            element_uses = []
          end

          a.remainder.read_delimiter.flatmap do |b|
            case b.value
            when @separators.element
              rest = b.remainder.read_elements(a.value, element_uses)
              rest.map{|c| c.map{|es| segment(a.value, @input, c.remainder.input, es) }}
            when @separators.segment
              remainder =
                if a.value == :IEA
                  b.remainder.stream
                else
                  b.remainder
                end

              # Consume the segment terminator
              result(segment(a.value, @input, b.remainder.input), remainder)
            end
          end
        end
      end

      # @return [Either<Result<Array<SimpleElementTok, CompositeElementTok>, TokenReader>>]
      def read_elements(segment_id, element_uses)
        if element_uses.empty?
          read_simple_element
        else
          element_use = element_uses.head
          repeatable  = element_use.repeatable?

          if element_use.composite?
            read_composite_element(repeatable)
          else
            read_simple_element(repeatable)
          end
        end.flatmap do |a|
          a.remainder.read_delimiter.flatmap do |b|
            case b.value
            when @separators.segment
              remainder =
                if segment_id == :IEA
                  b.remainder.stream
                else
                  b.remainder
                end

              # This is the last element before the segment terminator, make
              # it into a singleton list and _do_ consume the delimiter
              result(a.value.cons, remainder)
            when @separators.element
              # There is another element following the delimiter
              rest = b.remainder.read_elements(segment_id, element_uses.tail)
              rest.map{|c| c.map{|es| a.value.cons(es) }}
            end
          end
        end
      end

      # @return [Either<Result<Array<ComponentElementTok, TokenReader>>>]
      def read_component_elements(repeatable = false)
        read_component_element(repeatable).flatmap do |a|
          a.remainder.read_delimiter.flatmap do |b|
            case b.value
            when @separators.segment,
                 @separators.element,
                 @separators.repetition
              # This is the last component element within the composite element,
              # so make it into a singleton list and don't consume the delimiter
              result(a.value.cons, a.remainder)
            when @separators.component
              rest = b.remainder.read_component_elements(repeatable)
              rest.map{|c| c.map{|es| a.value.cons(es) }}
            end
          end
        end
      end

      # @return [Either<Result<Symbol, TokenReader>>]
      def read_segment_id
        position = 0
        buffer   = ""

        while true
          unless @input.defined_at?(position)
            return failure("reached end of input without finding a segment identifier")
          end

          character = @input.at(position)
          position += 1

          if is_delimiter?(character)
            break
          end

          unless is_control?(character)
            if buffer.length == 3
              break
            end

            buffer << character
          end
        end

        # We only arrive here if {character} is a delimiter, or if we read
        # three characters into {buffer} and an additional into {character}
        if buffer =~ SEGMENT_ID
          remainder = advance(position - 1)

          case character
          when @separators.segment,
               @separators.element
            # Don't consume the delimiter
            result(buffer.upcase.to_sym, remainder)
          else
            failure("found #{character.inspect} following segment identifier")
          end
        else
          failure("found #{(buffer + character).inspect} instead of segment identifier")
        end
      end

      # @return [Either<Result<Character, TokenReader>>]
      def read_delimiter
        position = 0

        while @input.defined_at?(position)
          character = @input.at(position)
          position += 1

          if is_control?(character)
            next
          end

          if is_delimiter?(character)
            return result(character, advance(position))
          else
            return failure("found #{character.inspect} instead of a delimiter")
          end
        end

        failure("reached end of input without finding a delimiter")
      end

      # @return [Either<Result<SimpleElementToken, TokenReader>>]
      def read_simple_element(repeatable = false)
        position = 0
        buffer   = ""

        while @input.defined_at?(position)
          character = @input.at(position)
          position += 1

          if is_control?(character)
            next
          end

          case character
          when @separators.segment,
               @separators.element
            # These delimiters mark the end of the element. We don't consume
            # the delimiter because the next reader can use the delimiter to
            # know which token to next expect.
            token = simple(buffer, @input, @input.drop(position))
            token = token.repeated if repeatable
            return result(token, advance(position - 1))
          when @separators.repetition
            if repeatable
              token = simple(buffer, @input, @input.drop(position))
              rest  = advance(position).read_simple_element(repeatable)
              return rest.map{|r| r.map{|e| e.repeated(token) }}
          # else
          #   # @todo: Read this as data but sound the alarms
            end
        # when @separators.component
        #   # @todo: Read this as data but sound the alarms
          end

          buffer << character
        end

        failure("reached end of input without finding a simple data element")
      end

      # @return [Either<Result<ComponentElementTok, TokenReader>>]
      def read_component_element(repeatable = false)
        position = 0
        buffer   = ""

        while @input.defined_at?(position)
          character = @input.at(position)
          position += 1

          if is_control?(character)
            next
          end

          case character
          when @separators.element,
               @separators.segment,
               @separators.component
            # Don't consume the separator/terminator
            token = component(buffer, @input, @input.drop(position))
            return result(token, advance(position - 1))
          when @separators.repetition
            if repeatable
              # Don't consume the repetition separator
              token = component(buffer, @input, @input.drop(position))
              return result(token, advance(position - 1))
          # else
          #   # @todo: Read this as data but sound the alarms
            end
          end

          buffer << character
        end

        failure("reached end of input without finding a component data element")
      end

      # @return [Either<Result<CompositeElementTok, TokenReader>>]
      def read_composite_element(repeatable = false)
        read_component_elements(repeatable).flatmap do |a|
          token = composite(a.value, @input, a.remainder.input)

          a.remainder.read_delimiter.flatmap do |b|
            case b.value
            when @separators.segment,
                 @separators.element
              token = token.repeated if repeatable
              result(token, a.remainder)
            when @separators.repetition
              b.remainder.read_composite_element(repeatable).map do |r|
                r.map{|e| e.repeated(token) }
              end
            end
          end
        end
      end

      # @return [void]
      def pretty_print(q)
        q.text("TokenReader")
        q.group(2, "(", ")") do
          q.breakable ""

          q.pp @input
          q.text ","
          q.breakable

          q.pp @separators
        end
      end

    private

      # @return [TokenReader]
      def advance(n)
        unless @input.defined_at?(n-1)
          raise IndexError, "less than #{n} characters available"
        else
          TokenReader.new(@input.drop(n), @separators, @segment_dict)
        end
      end

      def is_delimiter?(character)
        character == @separators.segment   or
        character == @separators.element   or
        character == @separators.component or
        character == @separators.repetition
      end

      def is_control?(character)
        Reader.is_control_character?(character) and not is_delimiter?(character)
      end

      def failure(message, remainder = @input)
        Either.failure(Result.failure(message, remainder))
      end

      def success(value)
        Either.success(value)
      end

      def result(value, remainder)
        Either.success(Result.success(value, remainder))
      end

      def segment(segment_id, start, remainder, elements = [])
        SegmentTok.build(segment_id, elements, start, remainder)
      end

      def simple(value, start, remainder)
        SimpleElementTok.build(value, start, remainder)
      end

      def component(value, start, remainder)
        ComponentElementTok.build(value, start, remainder)
      end

      def composite(value, start, remainder)
        CompositeElementTok.build(value, start, remainder)
      end
    end

  end
end
