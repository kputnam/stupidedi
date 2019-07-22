# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Reader

    # TODO: One of the top garbage producers is reading a single character like
    # input.at(offset). It might be more efficient to replace char-at-a-time reads
    # with Regexps that consume multiple characters at once.

    class Tokenizer
      include Inspect

      SEGMENT_ID    = /\A[A-Z][A-Z0-9]{1,2}\Z/.freeze
      BAD_SEPARATOR = /[a-zA-Z0-9 ]/.freeze

      # @return [Separators]
      attr_accessor :separators

      # @return [SegmentDict]
      attr_accessor :segment_dict

      # @param input [Input]
      def initialize(input, separators, segment_dict, switcher, switcher_)
        # Make a separate switch for _read_component_element so building a
        # composite element won't interfere with building its components.
        @input, @separators, @segment_dict, @switcher, @switcher_ =
          input, separators, segment_dict, switcher, switcher_
      end

      # @yield  [SegmentTok | IgnoredTok]
      # @return [Result]
      def each
        return enum_for(:each) unless block_given?
        count = 0
        input = @input

        while true
          result = next_segment(input) do |token|
            yield token # IgnoredTok
          end

          break if result.fail?
          yield result.value
          input  = result.rest
          count += 1
        end

        result.fatal = count.zero? || @separators.present?
        result
      end

      # @yield  [SegmentTok | IgnoredTok]
      # @return [Result]
      def each_isa
        return enum_for(:each) unless block_given?
        count = 0
        input = @input

        while true
          result = next_isa_segment(input) do |token|
            yield token # IgnoredTok
          end

          break if result.fail?
          yield result.value
          input  = result.rest
          count += 1
        end

        # The loop always terminates on failure, but we normall expect an EOF
        # at some point; however, it's not expected to happen before reading
        # an ISA or while tokenizing things inside ISA..IEA
        result.fatal = count.zero? || @separators.present?
        result
      end

      class Result
        include Inspect

        # @return [Boolean]
        abstract :fail?

        # @return [Position]
        abstract :position

        class Fail < Result
          # @return [String]
          attr_reader :error

          # @return [Position]
          attr_reader :position

          # @return [Boolean]
          attr_accessor :fatal

          def initialize(error, position, fatal = false)
            @error, @position, @fatal =
              error, position, fatal
          end

          def fail?
            true
          end

          def fatal?
            @fatal
          end

          # @yield [String]
          def explain
            yield @error
          end
        end

        class Done < Result
          # @return [Object]
          attr_reader :value

          # The remaining, unconsumed input
          #
          # @return [Input]
          attr_reader :rest

          # The position within the input attributed to `value`. In many cases
          # in the tokenizer, the `value` itself also carries a position, but
          # this is useful for cases where the value does not (_read_segment_id)
          #
          # @return [Position]
          attr_reader :position

          def initialize(value, position, rest)
            @value, @position, @rest =
              value, position, rest
          end

          def fail?
            false
          end

          # @return self
          def explain
            self
          end
        end
      end

      #
      # This is a bit clunky, but we can save quite a lot of memory allocation
      # by reusing our ElementTokBuilders. This is done by keeping a pair and
      # reseting them before giving to a caller. Otherwise, one of these would
      # be allocated each time a simple or composite is tokenized, then thrown
      # out once it's finished.
      #
      class ElementTokSwitch
        include Inspect

        def initialize
          @repeatable    = ElementTokBuilder::Repeatable.new(nil)
          @nonrepeatable = ElementTokBuilder::NonRepeatable.new(nil)
        end

        # Toggles the behavior of `#add`. When repeatable, it accumulates an
        # array of elements; otherwise it only stores the most recent.
        def switch(repeatable, position)
          @active = repeatable ? @repeatable : @nonrepeatable
          @active.reset!(position)
          @active
        end

        # @return self
        def add(element_tok)
          @active.add(element_tok)
          self
        end

        # @return [SimpleElementTok | CompositeElementTok | ComponentElementTok]
        def build
          @active.build
        end

        # @private
        class ElementTokBuilder
          include Inspect

          # @return self
          abstract :add

          # @return [ElementTok]
          abstract :build

          # @return self
          abstract :reset!

          # @return [Position]
          abstract :position

          # @private
          class Repeatable < ElementTokBuilder
            # @return [Position]
            attr_reader :position

            def initialize(position)
              @position, @element_toks =
                position, []
            end

            def add(element_tok)
              @element_toks.push(element_tok)
            end

            def build
              RepeatedElementTok.build(@element_toks, @position)
            end

            def reset!(position)
              @position     = position
              @element_toks = []
            end
          end

          # @private
          class NonRepeatable < ElementTokBuilder
            # @return [Position]
            attr_reader :position

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
            end
          end
        end
      end

      # Skips over any text, X12 or not, until an interchange segment is
      # found. Then @separators are reset. This is more efficient than
      # repeatedly calling `next_segment` and checking if the segment_id
      # is :ISA.
      #
      # @yield  [IgnoredTok]          the input that was ignored before "ISA"
      # @return [Result<SegmentTok>]  the ISA segment
      def next_isa_segment(input)
        segment_id = _next_isa_segment_id(input) do |t|
          # It's not unusual for IgnoredTok to have no content, because "ISA"
          # was found at the first character of the input.
          yield t if block_given? and not t.value.blank?
        end
        return segment_id if segment_id.fail?

        elements = _read_isa_elements(segment_id.rest)
        return elements if elements.fail?

        done(SegmentTok.build(:ISA, elements.value, segment_id.position),
             segment_id.position, elements.rest)
      end

      # Returns the next segment.
      #
      # @return [Result<SegmentTok>]
      def next_segment(input)
        if @separators.blank?
          # We haven't yet found an ISA segment, which requires a different
          # method than `next_segment`.
          return next_isa_segment(input){|t| yield t if block_given? }
        end

        segment_id = _next_segment_id(input)
        return segment_id if segment_id.fail?

        # _next_segment_id does not guarantee result.rest isn't eof
        return unexpected("eof after %s" % segment_id.value, input.position) \
          if segment_id.rest.empty?

        if segment_id.value == :ISA
          # We encountered a new ISA segment without having seen the previous
          # ISA's matching IEA segment. This is definitely a syntax error, but
          # we can still continue tokenizing and let the caller decide how to
          # handle it.
          elements = _read_isa_elements(segment_id.rest)
          return elements if elements.fail?

          segment_tok = SegmentTok.build(:ISA, elements.value, segment_id.position)
          return done(segment_tok, segment_id.position, elements.rest.lstrip_control_characters)
        end

        # _next_segment_id will skip any trailing control characters
        unless segment_id.rest.start_with?(@separators.element) \
            or segment_id.rest.start_with?(@separators.segment)
          return unexpected("%s after segment identifier %s" % [
            segment_id.rest.head.inspect, segment_id.value], segment_id.rest.position)
        end

        if @segment_dict.defined_at?(segment_id.value)
          element_uses = @segment_dict.at(segment_id.value).element_uses
        else
          element_uses = []
        end

        elements = _read_elements(segment_id.rest, segment_id.value, element_uses)
        return elements if elements.fail?

        # We've parsed an IEA segment, so reset and look for an ISA next time
        @separators = Separators.blank if segment_id.value == :IEA

        done(SegmentTok.build(segment_id.value, elements.value, segment_id.position),
             segment_id.position, elements.rest)
      end

    private

      # Consume next occurrence of "ISA" and any control characters that
      # immediately follow. Some validation is done to skip over cases
      # where it is more likely to be part of a word (eg, LISA) than X12.
      #
      # Yields the input that was consumed as an IgnoredTok. If no "ISA"
      # was found, nothing will be yielded.
      #
      # @yield  [IgnoredTok]        the input that was consumed before "ISA"
      # @return [Result<Symbol>]    :ISA
      def _next_isa_segment_id(input)
        offset = 0

        while input.defined_at?(offset)
          # Skip ahead until we find next occurrence of characters ISA, not
          # case sensitive. Control characters are ignored between I, S, A
          i = input.index("I", offset)

          # There's no I in the rest of the input, so it's all ignored
          return eof("ISA", input.position_at(offset)) if i.nil?

          # In the next iteration, search for "I" begins right after this one
          offset = i + 1

          s = input.index("S", i + 1)

          # There's no S in the rest of the input, so it's all ignored
          return eof("ISA", input.position_at(i)) if s.nil?

          # There's something between I..S but it's not a control character
          next if s > i + 1 and input[i+1, s-i-1].match?(Reader::R_EITHER, 0, true)

          a = input.index("A", s + 1)

          # There's no A in the rest of the input, so it's all ignored
          return eof("ISA", input.position_at(i)) if a.nil?

          # There's something between S..A but it's not a control character
          next if a > s + 1 and input[s+1, a-s-1].match?(Reader::R_EITHER, 0, true)

          # Needed to perform the extra validation below
          a = input.lstrip_control_characters_offset(a)

          # The next character determines the element separator. If it's an
          # alphanumeric or space, we assume this is not the start of an ISA
          # segment. Perhaps a word like "L[ISA] " or "D[ISA]RRAY"
          next if not input.defined_at?(a+1) or input.at(a+1).match?(BAD_SEPARATOR)

          # Success, ignore everything before "I", resume parsing after "A".
          yield IgnoredTok.new(input.take(i), input.position) if block_given?

          return done(:ISA, input.position_at(i), input.drop!(a + 1))
        end

        return eof("ISA", input.position)
      end

      # Read ISA elements and update @separators accordingly.
      #
      # @return [Result<Array<AbstractElementTok>>]
      def _read_isa_elements(input)
        # The next character is a declaration of the element separator
        @separators.element = input.head

        # Read the first 15 simple elements into an array
        element_toks = 15.times.map do |element_idx|
          element = _read_simple_element(input, false, :ISA, element_idx+1)
          return element if element.fail?

          input = element.rest
          element.value
        end

        # We have to assume the last (16th) element is fixed-length because
        # it is not terminated by an element separator. First we will skip
        # past control characters, then read the next character.
        offset = input.lstrip_control_characters_offset(1)
        return eof("ISA16", input.position) unless input.defined_at?(offset)
        element_toks << SimpleElementTok.build(input.at(offset), input.position_at(offset))

        # The character immediately after ISA16 is defined to be the
        # segment terminator. The separator could be a control character,
        # e.g. \n, because we do not skip past them here.
        return eof("segment terminator for ISA", input.position_at(offset)) \
          unless input.defined_at?(offset + 1)

        @separators.segment = input.at(offset + 1)
        done(element_toks, nil, input.drop!(offset + 2))
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
      # @return Symbol
      def _next_segment_id(input)
        offset     = input.lstrip_control_characters_offset
        buffer     = input.pointer.drop_take(offset, 0)
        start_pos  = input.position_at(offset)

        while true
          return eof("segment identifier", input.position) \
            unless input.defined_at?(offset)

          char = input.at(offset)
          break if char == @separators.element
          break if char == @separators.segment

          # Zero-copy as long as we've not skipped over any characters yet
          buffer << char unless input.is_control_character_at?(offset)
          offset += 1

          break if buffer.length >= 3
        end

        # This is the only String allocation we cannot get around. The `match?`
        # call either has a pattern with \A..\z, or the length of segment_id
        # is very small compared to the `@storage` after it, so `match?` will
        # allocate the short substring.
        #
        # Later, the segment_id will be subject to many equality checks, so it
        # is faster overall to make the substring copy here.
        segment_id = buffer.to_s

        return expected("segment identifier, found %s" % segment_id.inspect,
          start_pos) unless segment_id.match?(Tokenizer::SEGMENT_ID)

        return done(segment_id.to_sym, start_pos, input.lstrip_control_characters(offset))
      end

      # @param input          should be positioned on an element separator: "NM1[*].."
      # @param segment_id     used to report errors
      # @param element_uses   determines which elements are composite or repeatable
      #
      # @return [Array<ElementTok>]
      def _read_elements(input, segment_id, element_uses=[])
        element_toks = []
        element_idx  = 1

        # We are placed on an element separator at the start of each iteration
        while not input.empty? and input.start_with?(@separators.element)
          result =
            if element_uses.defined_at?(element_idx - 1)
              element_use = element_uses[element_idx - 1]
              repeatable  = element_use.repeatable?

              if element_use.composite?
                _read_composite_element(input, repeatable, segment_id, element_idx)
              else
                _read_simple_element(input, repeatable, segment_id, element_idx)
              end
            else
              # WARNING: We either don't have a corresponding SegmentDef or it
              # has fewer elements than are present in the input. We'll make the
              # assumption that it's a simple non-repeatable element.
              #
              # If the input contains a component or repetition separator, they
              # will be interpreted as ordinary characters.
              _read_simple_element(input, false, segment_id, element_idx)
            end

          return result if result.fail?
          element_toks << result.value
          input = result.rest
          element_idx += 1
        end

        return eof("segment terminator %s for %s" % [@separators.segment.inspect,
          segment_id], input.position) if input.empty?

        return expected("segment terminator %s for %s, found %s" % [
          @separators.segment.inspect, segment_id, input.head.inspect],
          input.position) if input.head != @separators.segment

        # Skip past the segment separator
        done(element_toks, nil, input.drop!(1))
      end

      # @param input          should be positioned at an element separator,
      #                         "NM1*X[*]:A:B.."
      # @param repeatable     whether repetition separators is data or syntax
      # @param segment_id     used to report errors
      # @param element_idx    used to report errors
      #
      # @return [CompositeElementTok | RepeatedElementTok]
      def _read_composite_element(input, repeatable, segment_id, element_idx)
        return eof("element separator %s before %s%02d" % [
          @separators.element.inspect, segment_id, element_idx],
          input.position) if input.empty?

        return expected("element separator %s before %s%02d, found %s" % [
          @separators.element.inspect, segment_id, element_idx, input.head.inspect],
          input.position) unless input.start_with?(@separators.element)

        builder        = @switcher.switch(repeatable, input.position_at(1))
        repeat_pos     = builder.position
        component_idx  = 1
        component_toks = []

        until input.empty?
          result = _read_component_element(input, false, segment_id, element_idx, component_idx)
          return result if result.fail?

          input           = result.rest
          char            = input.head
          component_toks << result.value

          if char == @separators.element \
          or char == @separators.segment
            builder.add(CompositeElementTok.build(component_toks, repeat_pos))
            return done(builder.build, builder.position, input)

          elsif repeatable and char == @separators.repetition
            builder.add(CompositeElementTok.build(component_toks, repeat_pos))
            repeat_pos = input.position_at(1)
            component_toks.clear

          elsif char == @separators.repetition
            # We aren't repetable and neither was the component element we just
            # read, or it would have consumed the repetition separator. We can
            # either pretend we didn't see it and carry on, or abort.
            #
            # Whether or not the sender inadvertently wrote the separator (e.g.
            # from not cleaning user input before spitting it out as X12), the
            # next character is probably ordinary data and we have nowhere to
            # put it, because ordinary data wouldn't have occured here anyway.
            #
            # So there's not much we can do but bail.
            return unexpected("repetition separator %s after %s%02d" % [
              @separators.repetition.inspect, segment_id, element_idx], input.head)
          end

          component_idx += 1
        end

        eof("element %s or segment separator %s after %s%02d" % [
          @separator.element.inspect, @separator.segment.inspect, segment_id,
          element_idx], builder.position)
      end

      # @param input          should be positioned at an element separator,
      #                         "NM1[*]..", or component separator "FOO*A[:]B.."
      # @param repeatable     currently X12 does not allow components to repeat
      # @param segment_id     used to report errors
      # @param element_idx    used to report errors
      # @param composite_idx  used to report errors
      #
      # @return [ComponentElementTok | RepeatedElementTok]
      def _read_component_element(input, repeatable, segment_id, element_idx, component_idx)
        return eof("element %s or component separator %s before %s%02d-%02d" % [
          @separators.element.inspect, @separators.component.inspect, segment_id,
          element_idx, component_idx], input.position) if input.empty?

        return expected("element %s or component separator %s before %s%02d-%02d, found %s" % [
          @separators.element.inspect, @separators.component.inspect, segment_id,
          element_idx, component_idx, input.head.inspect], input.position) \
          unless input.start_with?(@separators.element) \
              or input.start_with?(@separators.component)

        offset     = input.lstrip_control_characters_offset(1)
        buffer     = input.pointer.drop_take(offset, 0)
        repeat_pos = input.position
        builder    = @switcher_.switch(repeatable, input.position)

        while input.defined_at?(offset)
          char = input.at(offset)

          if repeatable and char == @separators.repetition
            builder.add(SimpleElementTok.build(buffer, repeat_pos))
            repeat_pos = input.position_at(offset + 1)
            offset    += 1

          elsif char == @separators.segment \
             or char == @separators.element \
             or char == @separators.component \
             or char == @separators.repetition
            # Because we're not repeatable, a repetition seperator could
            # belong to the parent/composite element. If it's not repeatable
            # either, an error can be returned.
            builder.add(ComponentElementTok.build(buffer, repeat_pos))
            return done(builder.build, builder.position, input.drop!(offset))

          else
            # This is zero-copy as long as we haven't skipped any characters
            buffer << char unless input.is_control_character_at?(offset)
            offset += 1
          end
        end

        if repeatable
          eof("segment %s, element %s, component %s or repetition separator %s after %s%02d-%02d" % [
            @separators.segment.inspect, @separators.element.inspect,
            @separators.component.inspect, @separators.repetition.inspect,
            segment_id, element_idx, component_idx], builder.position)
        else
          eof("segment %s, element %s or component separator %s after %s%02d-%02d" % [
            @separators.segment.inspect, @separators.element.inspect,
            @separators.component.inspect, segment_id, element_idx,
            component_idx], builder.position)
        end
      end

      # @param input        should be positioned at an element separator: "NM1[*].."
      # @param repeatable   whether repetition separators is data or syntax
      # @param segment_id   used to report errors
      # @param element_idx  used to report errors
      #
      # @return [SimpleElementTok | RepeatedElementTok]
      def _read_simple_element(input, repeatable, segment_id, element_idx)
        return eof("element separator %s before %s%02d" % [
          @separators.element.inspect, segment_id, element_idx],
          input.position) if input.empty?

        return expected("element separator %s before %s%02d, found %s" % [
          @separators.element.inspect, segment_id, element_idx, input.head.inspect],
          input.position) unless input.start_with?(@separators.element)

        offset     = input.lstrip_control_characters_offset(1)
        buffer     = input.pointer.drop_take(offset, 0)
        start_pos  = input.position
        repeat_pos = input.position
        builder    = @switcher.switch(repeatable, input.position)

        while input.defined_at?(offset)
          char = input.at(offset)

          if char == @separators.element \
          or char == @separators.segment
            builder.add(SimpleElementTok.build(buffer, repeat_pos))
            return done(builder.build, start_pos, input.drop!(offset))

          elsif repeatable and char == @separators.repetition
            builder.add(SimpleElementTok.build(buffer, repeat_pos))
            offset    += 1
            buffer     = input.pointer.drop_take(offset, 0)
            repeat_pos = input.position_at(offset)

          else
            # This is zero-copy as long as we haven't skipped any characters
            buffer << char unless input.is_control_character_at?(offset)
            offset += 1
          end
        end

        eof("segment %s or element separator %s after %s%02d" % [
          @separators.segment.inspect, @separators.element.inspect, segment_id,
          element_idx], start_pos)
      end

      # @param value [Object]
      # @param rest  [Input]
      def done(value, position, rest)
        Tokenizer::Result::Done.new(value, position, rest)
      end

      # @param value    [String]
      # @param position [Position]
      def expected(error, position)
        Tokenizer::Result::Fail.new("expected #{error}", position)
      end

      # @param value    [String]
      # @param position [Position]
      def unexpected(error, positiion)
        Tokenizer::Result::Fail.new("unexpected #{error}", position)
      end

      # @param value    [String]
      # @param position [Position]
      def eof(error, position)
        expected("#{error}, found eof", position)
      end
    end

    class << Tokenizer
      def build(input)
        new(input, Separators.blank, SegmentDict.empty,
          Tokenizer::ElementTokSwitch.new, Tokenizer::ElementTokSwitch.new)
      end
    end
  end
end
