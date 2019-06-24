# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Reader

    # TODO:
    # - fix shared builder from caller to callee
    # - review/improve errors
    # - determine what is yield'd, what is return'd
    # - determine error recovery
    # - mark correct positions
    # - switch char-by-char concat with regexps that grab whole elements

    class Tokenizer
      SEGMENT_ID     = /\A[A-Z][A-Z0-9]{1,2}\Z/
      NOT_SEGMENT_ID = /[^A-Z0-9]/

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

        # @return [ElementTokSwitch]
        attr_accessor :builder

        def initialize(separators, segment_dict, builder)
          @separators, @segment_dict, @builder =
            separators, segment_dict, builder
        end

        def self.todo
          new(Separators.new(":", "^", "*", "~"), SegmentDict.empty, ElementTokSwitch.new)
        end
      end

      #
      # Tokenizer operations return three pieces of information: either an
      # error value or a success value (one piece is which one, the other
      # piece is the value), and the remaining unconsumed input.
      #
      class Result
        def done?
          not fail?
        end
      end

      class Fail < Result
        # @return [String]
        attr_reader :error

        # @return [Position]
        attr_reader :position

        def initialize(error, position)
          @error, @position = error, position
        end

        def fail?
          true
        end
      end

      class Done < Result
        # @return [Object]
        attr_reader :value

        # @return [StringPtr]
        attr_reader :rest

        def initialize(value, rest)
          @value, @rest = value, rest
        end

        def fail?
          false
        end
      end

      module ElementTokBuilder
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

          def reset!(position)
            @position     = position
            @element_toks = element_toks
            self
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

          def reset!(position)
            @position    = position
            @element_tok = nil
            self
          end
        end
      end

      #
      # This is a bit clunky, but we can save quite a lot of memory allocation
      # by reusing our ElementTokBuilders. This is done by keeping a pair and
      # reseting them before giving to a caller. We thread this switch through
      # various parts of the Tokenizer storing it in State.
      #
      # Otherwise, one of these would be allocated for every time a simple or
      # composite is tokenized.
      #
      class ElementTokSwitch
        def_delegators :@active, :add, :build, :reset!

        def initialize
          @repeatable    = ElementTokBuilder::Repeatable.new(nil)
          @nonrepeatable = ElementTokBuilder::NonRepeatable.new(nil)
        end

        def switch(repeatable, position)
          @active = repeatable ? @repeatable : @nonrepeatable
          @active.reset!(position)
        end
      end
    end

    class << Tokenizer
      # @yield [SegmentTok | IgnoredTok | ErrorTok]
      def each(input)
        return enum_for(:each, input) unless block_given?
        state = Tokenizer::State.new(nil, SegmentDict.empty, Tokenizer::ElementTokSwitch.new)

        while true
          result = next_segment(input, state) do |token|
            yield token
          end

          break if result.fail?
          yield result.value
          input = result.rest
        end

        result
      end

      # This method will skip over without tokenizing input, until an ISA
      # segment is found.
      #
      # @yield [SegmentTok | IgnoredTok | ErrorTok]
      def each_isa(input)
        return enum_for(:each, input) unless block_given?
        state = Tokenizer::State.new(nil, SegmentDict.empty, Tokenizer::ElementTokSwitch.new)

        while true
          result = next_isa_segment(input, state) do |token|
            yield token # IgnoreTok
          end

          break if result.fail?
          yield result.value
          input = result.rest
        end

        result
      end

      BAD_SEPARATOR = /[a-zA-Z0-9 ]/

      # Consume next occurrence of "ISA" and any control characters that
      # immediately follow. Validation is done to skip over "ISA" where
      # it is less likely to be X12 than part of a word.
      #
      # Returns the input that was consumed as an IgnoredTok. If no "ISA"
      # was found, then the entire input will be consumed.
      #
      # @yield  [IgnoreTok]
      # @return [Result<Position>]
      def _next_isa_segment_id(input)
        offset = 0

        while input.defined_at?(offset)
          # Skip ahead until we find next occurrence of characters ISA, not
          # case sensitive. Control characters are ignored between I, S, A
          i = input.index("I", offset)

          # There's no I in the rest of the input, so it's all ignored
          return eof("ISA", :position) if i.nil?

          # In the next iteration, search for "I" begins right after this one
          offset = i + 1

          s = input.index("S", i + 1)

          # There's no S in the rest of the input, so it's all ignored
          return eof("ISA", :position) if s.nil?

          # There's something between I..S but it's not a control character
          next if s > i + 1 and input[i+1, s-i-1].match?(Reader::R_EITHER, 0, true)

          a = input.index("A", offset)

          # There's no A in the rest of the input, so it's all ignored
          return eof("ISA", :position) if a.nil?

          # There's something between S..A but it's not a control character
          next if a > s + 1 and input[s+1, a-s-1].match?(Reader::R_EITHER, 0, true)

          # Needed to perform the extra validation below
          a = _skip_control_characters(input, a)

          # The next character determines the element separator. If it's an
          # alphanumeric or space, we assume this is not the start of an ISA
          # segment. Perhaps a word like "L[ISA] " or "D[ISA]RRAY"
          next if not input.defined_at?(a+1) or input[a+1].match?(BAD_SEPARATOR)

          # Success, ignore everything before "I", resume parsing after "A".
          yield IgnoredTok.new(input.take(i), :position)
          return done(:position, input.drop(a+1))
        end

        return eof("ISA", :position)
      end

      # Read ISA segment and update element and segment separators in `state`.
      #
      # This should be called when `input.head` is pointing at the first
      # element separator (commonly "*"). There is no validation done here
      # so take care, the results can be really strange otherwise.
      #
      # @return [Result<Array<AbstractElementTok>>]
      def _read_isa_elements(input, state)
        # The next character is a declaration of the element separator
        separators = Separators.new(nil, nil, input.head, nil)

        # NOTE: Doing this destructive update here would complicate backtracking
        state.separators = separators

        # Read the first 15 simple elements into an array
        element_toks = 15.times.map do |element_idx|
          result = _read_simple_element(input, state, false, :ISA, element_idx+1)
          return result if result.fail?

          input = result.rest
          result.value
        end

        # We have to assume the last (16th) element is fixed-length because
        # it is not terminated by an element separator. First we will skip
        # past control characters, then read the next character.
        offset = _skip_control_characters(input, 1)
        return eof("ISA16", :position) unless input.defined_at?(offset)

        element_toks << SimpleElementTok.build(input[offset], :position)

        # The character immediately after ISA16 is defined to be the
        # segment terminator. Here we do not skip past control characters,
        # so the separator could be a control character
        return eof("segment terminator for ISA", :position) \
          unless input.defined_at?(offset + 1)

        state.separators.segment = input[offset + 1]
        done(element_toks, input.drop(offset + 2))
      end

      # @yield  [IgnoreTok]
      # @return [Result<SegmentTok>]
      def next_isa_segment(input, state)
        position = _next_isa_segment_id(input) do |t|
          # It's not unusual for IgnoreTok to have no content, because "ISA"
          # was found at the first character of the input.
          yield t if block_given? and not t.value.blank?
        end
        return position if position.fail?

        result = _read_isa_elements(position.rest, state)
        return result if result.fail?

        done(SegmentTok.build(:ISA, result.value, position.value), result.rest)
      end

      # Works similarly to `_next_isa_segment_id`, except the result is the
      # segment identifier. The remaining input begins where an element or
      # segment separator should be.
      #
      # This consumes any control characters following the segment identifier
      # and the remaining input is guaranteed not to be EOF. However, there is
      # no validation done on the next character, even though it should be a
      # segment or element separator.
      #
      # @return [Array(Symbol, Position)]
      def _next_segment_id(input, state)
        offset     = _skip_control_characters(input)
        buffer     = input.drop(offset).take(0)
        separators = state.separators

        while true
          return eof("segment identifier", :position) \
            unless input.defined_at?(offset)

          char = input[offset]
          break if separators.element == char
          break if separators.segment == char

          offset += 1
          next if Reader.is_control_character?(char)

          # Zero-copy as long as we've not skipped over any characters yet
          buffer << char
          break if buffer.length >= 3
        end

        # This is the only String allocation we cannot get around. The `match?`
        # call either has a pattern with \A..\z, or the length of segment_id
        # is very small compared to the `@storage` after it, so `match?` will
        # allocate the short substring. Next, we need to convert segment_id to
        # a symbol, and this also requires reifying the string to call `to_sym`
        #
        # So it's better to make one copy here instead of them being created
        # implicitly twice below.
        segment_id = buffer #.to_s

        # return expected("segment identifier, found %s" % segment_id.inspect, :position) \
        #   if segment_id.match?(Tokenizer::NOT_SEGMENT_ID, 0, true)

        offset = _skip_control_characters(input, offset)
        return done([segment_id, :position], input.drop(offset))
      end

      # @return [SegmentTok]
      def next_segment(input, state)
        separators = state.separators

        if separators.nil?
          # We haven't yet found an ISA segment, which requires a different
          # method than `next_segment`.
          return next_isa_segment(input, state){|t| yield t if block_given? }
        end

        result = _next_segment_id(input, state)
        return result if result.fail?
        segment_id, position = result.value

        # Note, _next_segment_id does not guarantee result.rest isn't eof
        return unexpected("eof after %s" % segment_id, :position) \
          if result.rest.empty?

        # This is the only String allocation we cannot get around. The `match?`
        # call either has a pattern with \A..\z, or the length of segment_id
        # is very small compared to the `@storage` after it, so `match?` will
        # allocate the short substring. Next, we need to convert segment_id to
        # a symbol, and this also requires reifying the string to call `to_sym`
        #
        # So it's better to make one copy here instead of them being created
        # implicitly twice below.
        # segment_id = segment_id.to_sym

        if segment_id == "ISA" # :ISA
          # We encountered a new ISA segment without having seen the previous
          # ISA's matching IEA segment.
          result = _read_isa_elements(result.rest, state){|t| yield t if block_given? }
          return result if result.fail?

          return done(SegmentTok.build(:ISA, result.value, position), result.rest)
        end

        unless result.rest.head == separators.element \
            or result.rest.head == separators.segment
          return unexpected("%s after segment identifier %s" % [
            result.rest.head.inspect, segment_id], :position)
        end

        # if state.segment_dict.defined_at?(segment_id)
        #   element_uses = state.segment_dict.at(segment_id).element_uses
        # else
            element_uses = []
        # end

        result = _read_elements(result.rest, state, segment_id, element_uses)
        return result if result.fail?

        # We've parsed an IEA segment, so reset and look for an ISA next time
        state.separators = nil if segment_id == "IEA" # :IEA

        done(SegmentTok.build(segment_id, result.value, :position), result.rest)
      end

      # @params element_uses  Indicates which elements are composite and/or
      #   repeatable
      #
      # @return [Array<ElementTok>]
      #
      # @note Input should be positioned on an element separator: "NM1[*]..*..*..~"
      def _read_elements(input, state, segment_id, element_uses=[])
        element_toks = []
        element_idx  = 1
        separators   = state.separators

        # We are placed on an element separator at the start of each iteration
        while not input.empty? and input.head == separators.element
          result =
            if element_uses.defined_at?(element_toks.length)
              element_use = element_uses[element_toks.length]
              repeatable  = element_use.repeatable?

              if element_use.composite?
                _read_composite_element(input, state, repeatable, segment_id, element_idx)
              else
                _read_simple_element(input, state, repeatable, segment_id, element_idx)
              end
            else
              # We either don't have a corresponding SegmentDef or it has
              # fewer elements than are present in the input. We'll make
              # the assumption that it's a simple non-repeatable element.
              #
              # If the input contains a component or repetition separator,
              # they will be interpreted as ordinary characters.
              _read_simple_element(input, state, repeatable, segment_id, element_idx)
            end

          return result if result.fail?
          element_toks << result.value
          input = result.rest
          element_idx += 1
        end

        return eof("segment terminator for %s" % segment_id, :position) \
          if input.empty?

        return expected("segment terminator for %s, found %s" %
          [segment_id, input.head.inspect], :position) \
          if input.head != separators.segment

        # Skip past the segment separator
        done(element_toks, input.tail)
      end

      # @param  repeatable  When false, repetition separator is treated as data
      #
      # @return [CompositeElementTok]
      def _read_composite_element(input, state, repeatable, segment_id, element_idx)
        separators = state.separators

        return eof("element separator before %s%02d" % [segment_id, element_idx], :position) \
          if input.empty?

        return expected("element separator before %s%02d, found %s" %
          [segment_id, element_idx, input.head.inspect], :position) \
          unless input.head == separators.element

        builder        = state.builder.switch(repeatable, :position)
        component_toks = []
        component_idx  = 1

        until input.empty?
          result = _read_component_element(input, state, false, segment_id, element_idx, component_idx)
          return result if result.fail?

          input           = result.rest
          component_toks << result.value

          if repeatable and input.head == separators.repetition
            # TODO: We could return unexpected("repetition separator for ...")
            builder.add(CompositeElementTok.build(component_toks, :position))
            component_toks.clear

          elsif input.head == separators.element \
             or input.head == separators.segment
            builder.add(CompositeElementTok.build(component_toks, :position))
            return done(builder.build, input)
          end

          descriptor_.succ!
        end

        eof("element or segment separator after %s%02d" % [segment_id, element_idx], input)
      end

      # @param  repeatable  So far, X12 does not allow components to repeat
      #
      # @return [ComponentElementTok]
      def _read_component_element(input, state, repeatable, segment_id, element_idx, component_idx)
        separators = state.separators

        return eof("element or component separator before %s%02d-%02d" % [
          segment_id, element_idx, component_idx], :position) if input.empty?

        return expected("element or component separator before %s%02d-%02d, found %s" %
          [segment_id, element_idx, component_idx, input.head.inspect], :position) \
          unless input.head == separators.element \
              or input.head == separators.component

        offset  = _skip_control_characters(input, 1)
        buffer  = input.drop(offset).take(0)
        builder = state.builder.switch(repeatable, :position)

        while input.defined_at?(offset)
          char = input[offset]

          if repeatable and char == separators.repetition
            # TODO: We could return unexpected("repetition separator for ...")
            builder.add(SimpleElementTok.build(buffer, :position))
            offset += 1

          elsif char == separators.segment \
             or char == separators.element \
             or char == separators.component
            builder.add(ComponentElementTok.build(buffer, :position))
            return done(builder.build, input.drop(offset))

          else
            # This is zero-copy as long as we haven't skipped any characters
            buffer << char unless Reader.is_control_character?(char)
            offset += 1
          end
        end

        if repeatable
          eof("segment, element, component or repetition separator after %s%02d-%02d" % [
            segment_id, element_idx, component_idx], :position)
        else
          eof("segment, element or repetition separator after %s%02d-%02d" % [
            segment_id, element_idx, component_idx], :position)
        end
      end

      # Input should be positioned on an element separator: "NM1[*]..*..*..~"
      #
      # @return [SimpleElementTok]
      def _read_simple_element(input, state, repeatable, segment_id, element_idx)
        separators = state.separators

        return eof("element separator before %s%02d" % [segment_id, element_idx],
          :position) if input.empty?

        return expected("element separator before %s%02d, found %s" % [
          segment_id, element_idx, input.head.inspect], :position) \
          unless input.head == separators.element

        offset  = _skip_control_characters(input, 1)
        buffer  = input.drop(offset).take(0)
        builder = state.builder.switch(repeatable, :position)

        while input.defined_at?(offset)
          char = input[offset]

          if char == separators.element \
          or char == separators.segment
            builder.add(SimpleElementTok.build(buffer, :position))
            return done(builder.build, input.drop(offset))

          elsif repeatable and char == separators.repetition
            # TODO: We could return unexpected("repetition separator for ...")
            builder.add(SimpleElementTok.build(buffer, :position))
            offset += 1

          else
            # This is zero-copy as long as we haven't skipped any characters
            buffer << char unless Reader.is_control_character?(char)
            offset += 1
          end
        end

        eof("segment or element separator after %s%02d" % [
          segment_id, element_idx], :position)
      end

      # @return [Integer]
      def _skip_control_characters(input, offset=0)
        while input.defined_at?(offset) \
          and Reader.is_control_character?(input[offset])
          offset += 1
        end

        offset
      end

      def done(value, rest)
        Tokenizer::Done.new(value, rest)
      end

      def fail(error, position)
        Tokenizer::Fail.new(error, position)
      end

      def expected(error, position)
        Tokenizer::Fail.new("expected #{error}", position)
      end

      def unexpected(error, positiion)
        Tokenizer::Fail.new("unexpected #{error}", position)
      end

      def eof(error, position)
        expected("expected #{error}, found eof", position)
      end
    end
  end
end
