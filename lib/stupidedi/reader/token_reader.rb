module Stupidedi
  module Reader

    class TokenReader

      # @return [String, Input]
      attr_reader :input

      # @return [Separators]
      attr_reader :separators

      def initialize(input, separators, segment_defs = {})
        @input, @separators, @segment_defs =
          input, separators, segment_defs
      end

      # @return [TokenReader]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:input, @input),
          changes.fetch(:separators, @separators),
          changes.fetch(:segment_defs, @segment_defs)
      end

      # @return [StreamReader]
      def stream
        StreamReader.new(@input)
      end

      def empty?
        @input.empty?
      end

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
                return failure("Found #{buffer.inspect} instead of #{s.inspect}")
              end
            end
          end
        end

        failure("Reached end of input without finding #{s.inspect}")
      end

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

        failure("Reached end of input without finding #{s.inspect}")
      end

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

        failure("Less than one character available")
      end

      # @return [Either<Result<SegmentTok, TokenReader>>]
      def read_segment
        # Consume ~
        read_segment_id.flatmap do |a|
          if segment_def = @segment_defs[a.value]
            element_uses = segment_def.element_uses
          else
            element_uses = []
          end

          a.remainder.read_delimiter.flatmap do |b|
            case b.value
            when @separators.element_separator
              b.remainder.read_elements(element_uses).map do |c|
                c.map{|es| segment(a.value, @input, c.remainder.input, es) }
              end
            when @separators.segment_terminator
              # @todo: Segment with no elements
              result(segment(a.value, @input, b.remainder.input), b.remainder)
            end
          end
        end
      end

      # @return [Either<Result<Array<SimpleElementTok, CompositeElementTok>, TokenReader>>]
      def read_elements(element_uses)
        if element_uses.empty?
          read_simple_element
        else
          element_use = element_uses.head
          repeatable  = element_use.repeat_count.include?(2)

          if element_uses.head.composite?
            read_composite_element(repeatable)
          else
            read_simple_element(repeatable)
          end
        end.flatmap do |a|
          a.remainder.read_delimiter.flatmap do |b|
            case b.value
            when @separators.segment_terminator
              # This is the last element before the segment terminator, make
              # it into a singleton list and _do_ consume the delimiter
              result(a.value.cons, b.remainder)
            when @separators.element_separator
              # There is another element following the delimiter
              b.remainder.read_elements(element_uses.tail).map do |r|
                r.map{|es| a.value.cons(es) }
              end
            end
          end
        end
      end

      # @return [Either<Result<Array<ComponentElementTok, TokenReader>>>]
      def read_component_elements(repeatable = false)
        read_component_element(repeatable).flatmap do |a|
          a.remainder.read_delimiter.flatmap do |b|
            case b.value
            when @separators.segment_terminator,
                 @separators.element_separator,
                 @separators.repetition_separator
              # This is the last component element within the composite element,
              # so make it into a singleton list and don't consume the delimiter
              result(a.value.cons, a.remainder)
            when @separators.component_separator
              b.remainder.read_component_elements(repeatable).map do |c|
                c.map{|es| a.value.cons(es) }
              end
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
            return failure("Reached end of input without finding a segment identifier")
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
        if buffer =~ /\A[A-Z][A-Z0-9]{1,2}\Z/
          remainder = advance(position - 1)

          case character
          when @separators.segment_terminator,
               @separators.element_separator
            # Don't consume the delimiter
            result(buffer.upcase.to_sym, remainder)
          when @separators.repetition_separator
            failure("Found repetition separator following segment identifier", remainder)
          when @separators.component_separator
            failure("Found component separator following segment identifier", remainder)
          else
            failure("Found #{character.inspect} following segment identifier", remainder)
          end
        else
          failure("Found #{buffer.inspect} instead of segment identifier")
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
            return failure("Found #{character.inspect} instead of a delimiter")
          end
        end

        failure("Reached end of input without finding a delimiter")
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
          when @separators.segment_terminator,
               @separators.element_separator
            # These delimiters mark the end of the element. We don't consume
            # the delimiter because the next reader can use the delimiter to
            # know which token to next expect.
            token = simple(buffer, @input, @input.drop(position))
            return result(token, advance(position - 1))
          when @separators.repetition_separator
            if repeatable
              token = simple(buffer, @input, @input.drop(position))
              return advance(position).read_simple_element(repeatable).map do |r|
                r.map{|e| e.repeat(token) }
              end
            else
              # @todo: Read this as data but sound the alarms
            end
          when @separators.component_separator
            # @todo: Read this as data but sound the alarms
          end

          buffer << character
        end

        failure("Reached end of input without finding a simple data element")
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
          when @separators.element_separator,
               @separators.segment_terminator,
               @separators.component_separator
            # Don't consume the delimiter
            token = component(buffer, @input, @input.drop(position))
            return result(token, advance(position - 1))
          when @separators.repetition_separator
            if repeatable
              # Don't consume the delimiter
              token = component(buffer, @input, @input.drop(position))
              return result(token, advance(position - 1))
            else
              # @todo: Read this as data but sound the alarms
            end
          end

          buffer << character
        end

        failure("Reached end of input without finding a component data element")
      end

      # @return [Either<Result<CompositeElementTok, TokenReader>>]
      def read_composite_element(repeatable = false)
        read_component_elements(repeatable).flatmap do |a|
          token = composite(a.value, @input, a.remainder.input)

          a.remainder.read_delimiter.flatmap do |b|
            case b.value
            when @separators.segment_terminator,
                 @separators.element_separator
              result(token, a.remainder)
            when @separators.repetition_separator
              b.remainder.read_composite_element.map do |r|
                r.map{|e| e.repeat(token) }
              end
            end
          end
        end
      end

      # @private
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
          raise IndexError, "Less than #{n} characters available"
        else
          copy(:input => @input.drop(n))
        end
      end

      def is_delimiter?(character)
        character == @separators.segment_terminator  or
        character == @separators.element_separator   or
        character == @separators.component_separator or
        character == @separators.repetition_separator
      end

      def is_basic?(character)
        Reader.is_basic_character?(character)
      end

      def is_extended?(character)
        Reader.is_extended_character?(character)
      end

      def is_control?(character)
        Reader.is_control_character?(character) and not is_delimiter?(character)
      end

      def failure(message, remainder = @input)
        Either.failure(Reader::Failure.new(message, remainder))
      end

      def success(value)
        Either.success(value)
      end

      def result(value, remainder)
        Either.success(Reader::Success.new(value, remainder))
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
