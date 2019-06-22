# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Reader

    #
    #
    #
    class Tokenizer
      SEGMENT_ID = /\A[A-Z][A-Z0-9]{1,2}\Z/

      def initialize(input)
        @input = input
      end

      def each
        if block_given?
          Tokenizer.each(@input){|t| yield t }
        else
          Tokenizer.each(@input)
        end
      end

      def each_isa
        if block_given?
          Tokenizer.each_isa(@input){|t| yield t }
        else
          Tokenizer.each_isa(@input)
        end
      end
    end

    class Tokenizer
      #
      # Track the configuration info, which controls how the tokenizer reads
      # input. The `separators` field is straightforward, but `segment_dict`
      # is used by `read_element` to determine which kind of elements should
      # be parsed, according to the segment definition.
      #
      class State
        include Inspect

        # @return [Separators]
        attr_accessor :separators

        # @return [SegmentDict]
        attr_accessor :segment_dict

        def initialize(separators, segment_dict)
          @separators, @segment_dict =
            separators, segment_dict
        end

        def self.todo
          new(Separators.new(":", "^", "*", "~"), Hash.new)
        end
      end

      #
      # Tokenizer operations return three bits of info: an error value,
      # a success value, and the remaining unconsumed input
      #
      class Result
        # @return [Input]
        attr_reader :input

        def initialize(value, input)
          @value, @input =
            value, input
        end

        def pass?
          not fail?
        end

        class Fail < Result
          def error
            @value
          end

          def fail?
            true
          end
        end

        class Pass < Result
          def value
            @value
          end

          def fail?
            false
          end
        end
      end
    end

    class << Tokenizer
      # @yield [SegmentTok | IgnoredTok | ErrorTok]
      def each(input)
        return enum_for(:each, input) unless block_given?
        state = Tokenizer::State.new(nil, nil)

        until input.empty?
          next_segment(input, state) do |token|
            # Ordinarily there's only one SegmentTok returned, but in other
            # cases there could be a IgnoreTok at the beginning, with non-X12
            # header text. Or there could be an ErrorTok and IgnoreTok because
            # the first ISA was malformed and the text after was ignored.
            #
            # Usually read_segment will only return a single SegmentTok, but
            # there could also be unparseable text in an ErrorTok
            yield token
          end
        end
      end

      # @yield [SegmentTok | IgnoredTok | ErrorTok]
      def each_isa(input)
        return enum_for(:each, input) unless block_given?
        state = Tokenizer::State.new(nil, nil)

        until input.empty?
          next_isa_segment(input, state).each do |token|
            yield token
          end
        end
      end

      # Consume next occurrence of "ISA" and any control characters that
      # immediately follow. Validation is done to skip over "ISA" where
      # it is less likely to be X12 than part of a word.
      #
      # Returns the input that was consumed as an IgnoredTok. If no "ISA"
      # was found, then the entire input will be consumed.
      #
      # @return [Result<IgnoredTok>]
      def next_isa_segment_id(input)
        offset = 0

        while input.defined_at?(offset)
          # Skip ahead until we find next occurrence of characters ISA, not
          # case sensitive. Control characters are ignored between I, S, A
          i = input.index("I", offset)

          # In the next iteration, search for "I" begins right after this one
          offset = i + 1

          # There's no I in the rest of the input, so it's all ignored
          return pass(IgnoredTok.new(input, :position), input.end) if i.nil?

          s = input.index("S", i + 1)

          # There's no S in the rest of the input, so it's all ignored
          return pass(IgnoredTok.new(input, :position), input.end) if s.nil?

          # There's something between I..S but it's not a control character
          next if s > i + 1 and input[i+1, s-i-1].match?(Reader::R_EITHER)

          a = input.index("A", offset)

          # There's no A in the rest of the input, so it's all ignored
          return pass(IgnoredTok.new(input, :position), input.end) if a.nil?

          # There's something between S..A but it's not a control character
          next if a > s + 1 and input[s+1, a-s-1].match?(Reader::R_EITHER)

          # Needed to perform the extra validation below
          a = skip_control_characters(input, a)

          # The next character determines the element separator. If it's an
          # alphanumeric or space, we assume this is not the start of an ISA
          # segment. Perhaps a word like "L[ISA] " or "D[ISA]RRAY"
          next if input[a+1].match?(/[a-zA-Z0-9 ]/)

          # Success
          return pass(IgnoredTok.new(input.take(i), :position), input.drop(a+1))
        end

        # Give up at end of input
        return pass(IgnoredTok.new(input, :position), input.end)
      end

      # This should be called when `input.head` is pointing at the first
      # element separator (commonly "*"). There is no validation done here
      # so take care, the results can be really strange otherwise.
      #
      # @return [Result<Array<AbstractElementTok>>]
      def read_isa_elements(input, state)
        # The next character is a declaration of the element separator
        state.separators = Separators.new(nil, nil, input.head, nil)

        # Read the first 15 simple elements into an array
        element_toks = 15.times.map do |n|
          result = read_simple_element(input, state.separators, false)
          return result if result.fail?
          input  = result.input
          result.value
        end

        # We have to assume the last (16th) element is fixed-length because
        # it is not terminated by an element separator. First we will skip
        # past control characters, then read the following character.
        offset = skip_control_characters(input, 1)
        return fail("reached eof before ISA16", input) \
          unless input.defined_at?(offset)
        element_toks << SimpleElementTok.build(input[offset], :position)

        # The character after the last element is defined to be the
        # segment terminator. Here we do not skip past control characters,
        # so the separator could be a control character
        return fail("reached eof before segment terminator for ISA", input) \
          unless input.defined_at?(offset + 1)
        state.separators.segment = input[offset + 1]

        pass(element_toks, input.drop(offset + 2))
      end

      # @yield  [IgnoreTok]
      # @return [Result<SegmentTok>]
      def next_isa_segment(input, state)
        result = next_isa_segment_id(input)
        return result if result.fail?

        unless result.value.value.empty?
          # It's not unusual for IgnoreTok to have no content, because "ISA"
          # was found at the first character of the input.
          yield result.value if block_given?
        end

        result = read_isa_elements(result.input, state)
        return result if result.fail?

        pass(SegmentTok.build(:ISA, result.value, :position), result.input)
      end

      # Works similarly to `next_isa_segment_id`, except the result is the
      # segment identifier. The remaining input begins where an element or
      # segment separator should be.
      #
      # This consumes any control characters following the segment identifier
      # and the remaining input is guaranteed not to be EOF. However, there is
      # no validation done on the next character, even though it should be a
      # segment or element separator.
      #
      # @return [Symbol]
      def next_segment_id(input, state)
        offset = skip_control_characters(input)
        buffer = input.drop(offset).take(0)

        while true
          return fail("reached eof before segment identifier", input) \
            unless input.defined_at?(offset)

          char = input[offset]
          break if state.separators.element == char
          break if state.separators.segment == char

          offset += 1
          next if Reader.is_control_character?(char)

          buffer += char
          break if buffer.length >= 3
        end

        return fail("found '#{buffer}' instead of segment identifier", input) \
          unless buffer.match?(Tokenizer::SEGMENT_ID)

        offset = skip_control_characters(input, offset)
        return pass(buffer.to_sym, input.drop(offset))
      end

      # @return [SegmentTok]
      def next_segment(input, state)
        if state.separators.nil?
          return next_isa_segment(input, state){|t| yield t }
        end

        result = next_segment_id(input, state)
        return result if result.fail? # TODO yield

        segment_id = result.value

        unless result.input.head == state.separators.element \
            or result.input.head == state.separators.segment
          # This is a redundant check, because we have to check in read_elements
          # but here we can provide a better error location
          return fail("invalid %s after segment identifier for %s" % [
            result.input.head, segment_id], input) # TODO yield
        end

        if segment_id == :ISA
          # We encountered a new ISA segment without having seen the previous
          # ISA's matching IEA segment.
          return read_isa_elements(result.input, state){|t| yield t }
        end

        if state.segment_dict.defined_at?(segment_id)
          element_uses = state.segment_dict.at(segment_id).element_uses
        else
          element_uses = []
        end

        # Note, next_segment_id guarantees result.input isn't EOF
        result = read_elements(segment_id, result.input, state.separators, element_uses)
        return result if result.fail? # TODO yield

        if segment_id == :IEA
          # Stop parsing X12 and search for the next ISA before resuming
          state.separators = nil
        end

        pass(SegmentTok.build(segment_id, result.value, :position), result.input)
      end

      # Input should be positioned on an element separator: "NM1[*]..*..*..~"
      #
      # @return [Array<ElementTok>]
      def read_elements(segment_id, input, separators, element_uses=[])
        elements  = []

        # We are placed on an element separator at the start of each iteration
        until input.empty? or input.head != separators.element
          result =
            if element_uses.defined_at?(elements.length)
              element_use = element_uses[elements.length]
              repeatable  = element_use.repeatable?

              if element_use.composite?
                read_composite_element(input.tail, separatorse, repeatable)
              else
                read_simple_element(input, separators, repeatable)
              end
            else
              # We either don't have a corresponding SegmentDef or it has
              # fewer elements than are present in the input. We'll make
              # the assumption that it's a simple non-repeatable element.
              #
              # If the input contains a component or repetition separator,
              # they will be interpreted as ordinary characters.
              read_simple_element(input, separators, repeatable)
            end

          return result if result.fail?
          elements << result.value
          input = result.input
        end

        if input.empty?
          fail("reached eof before segment terminator for %s" % segment_id, input)
        elsif input.head != separators.segment
          fail("expected segment terminator for %s but saw '%s'" % [segment_id, input.head], input)
        else
          # Skip past the segment separator
          pass(elements, input.tail)
        end
      end

      # @return [CompositeElementTok]
      def read_composite_element(input, separators, repeatable, descriptor="a composite element")
        return fail("reached eof while expecting #{descriptor}", input) \
          if input.empty?

        return fail("expected an element separator before #{descriptor}", input) \
          unless input.head == separators.element

        builder        = ElementTokBuilder.build(repeatable, :position)
        component_toks = []

        until input.empty?
          result = read_component_element(input, separators, false)
          return result if result.fail?
          input = result.input
          component_toks << result.value

          if repeatable and input.head == separators.repetition
            builder.add(CompositeElementTok.build(component_toks, :position))
            component_toks.clear

          elsif input.head == separators.element \
             or input.head == separators.segment
            builder.add(CompositeElementTok.build(component_toks, :position))
            return pass(builder.build, input)
          end
        end

        fail("reached eof while reading #{descriptor}", input)
      end

      # @return [ComponentElementTok]
      def read_component_element(input, separators, repeatable, descriptor="a component element")
        return fail("reached eof while expecting #{descriptor}", input) \
          if input.empty?

        return fail("expected an element or component separator before #{descriptor}", input) \
          unless input.head == separators.element or input.head == separators.component

        offset  = skip_control_characters(input, 1)
        buffer  = input.drop(offset).take(0)
        builder = ElementTokBuilder.build(repeatable, :position)

        while input.defined_at?(offset)
          char = input[offset]

          if repeatable and char == separators.repetition
            builder.add(SimpleElementTok.build(buffer, :position))
            offset += 1

          elsif char == separators.segment \
             or char == separators.element \
             or char == separators.component \
             or char == separators.repetition
            builder.add(ComponentElementTok.build(buffer, :position))
            return pass(builder.token, input.drop(offset))

          else
            buffer << char unless Reader.is_control_character?(char)
            offset += 1
          end
        end

        return fail("reached eof while reading #{descriptor}", input)
      end

      # Input should be positioned on an element separator: "NM1[*]..*..*..~"
      #
      # @return [SimpleElementTok]
      def read_simple_element(input, separators, repeatable, descriptor="an element")
        return fail("reached eof while expecting #{descriptor}", input) \
          if input.empty?

        return fail("expected an element separator before #{descriptor}", input) \
          unless input.head == separators.element

        offset  = skip_control_characters(input, 1)
        buffer  = input.drop(offset).take(0)
        builder = ElementTokBuilder.build(repeatable, :position)

        while input.defined_at?(offset)
          char = input[offset]

          if char == separators.element \
          or char == separators.segment
            builder.add(SimpleElementTok.build(buffer, :position))
            return pass(builder.build, input.drop(offset))

          elsif repeatable and char == separators.repetition
            builder.add(SimpleElementTok.build(buffer, :position))
            offset += 1

          else
            buffer << char unless Reader.is_control_character?(char)
            offset += 1
          end
        end

        return fail("reached eof while reading #{descriptor}", input)
      end

      # @return [Integer]
      def skip_control_characters(input, offset=0)
        while input.defined_at?(offset) \
          and Reader.is_control_character?(input[offset])
          offset += 1
        end

        offset
      end

      # @param value [Object] Result
      # @param input [Input]  Remaining unconsumed input
      def pass(value, input)
        Tokenizer::Result::Pass.new(value, input)
      end

      # @param value [Object] Error message
      # @param input [Input]  Input beginning where the error occurred
      def fail(value, input)
        Tokenizer::Result::Fail.new(value, input)
      end

      class ElementTokBuilder
        def self.build(repeatable, position)
          if repeatable
            Repeatable.new(position)
          else
            NonRepeatable.new(position)
          end
        end

        class Repeatable
          def initialize(position)
            @position, @element_toks = position, []
          end

          def add(element_tok)
            @element_toks.push(element_tok)
          end

          def build
            RepeatedElementTok.build(@element_toks, @element_toks.head.position)
          end
        end

        class NonRepeatable
          def initialize(position)
            @position = position
          end

          def add(element_tok)
            @element_tok = element_tok
          end

          def build
            @element_tok
          end
        end
      end
    end
  end
end
