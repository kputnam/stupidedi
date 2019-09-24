# frozen_string_literal: true
# encoding: utf-8
module Stupidedi
  using Refinements

  module Reader

    # NOTE abbrevations used in variable names:
    #   tr: separators.segment    ~
    #   gs: separators.element    *
    #   us: separators.component  :
    #   rs: separators.repetition ^

    class Tokenizer
      include Inspect

      autoload :Result,           "stupidedi/reader/tokenizer/result"
      autoload :ElementTokSwitch, "stupidedi/reader/tokenizer/element_tok_switch"

      # @return [Separators]
      attr_accessor :separators

      # @return [SegmentDict]
      attr_accessor :segment_dict

      VALID_SEPARATOR   = /[^[:alnum:] ]/u
      VALID_SEGMENT_ID  = /\A[A-Z][A-Z0-9]{1,2}\Z/u

      # @param input [Input]
      def initialize(input, config, separators, segment_dict, switcher, switcher_, strict)
        # Make a separate switch for _read_component_element so building a
        # composite element won't interfere with building its components.
        @input, @config, @separators, @segment_dict, @switcher, @switcher_, @strict =
          input, config, separators, segment_dict, switcher, switcher_, strict

        @i = "I".encode(@input.encoding).freeze
        @s = "S".encode(@input.encoding).freeze
        @a = "A".encode(@input.encoding).freeze
      end

      # Tokenizes the input and yields each segment as a SegmentTok. The data
      # between interchanges (ISA..IEA envelope) is yielded as an IgnoredTok.
      #
      # Return value indicates why tokenization terminated; usually it's due
      # to EOF. If no segments were read, or tokenization halts within an
      # interchange, or tokenizations halts in the middle of a segment, then
      # the result will be `#fatal?`.
      #
      # @yield  [Tokens::SegmentTok | Tokens::IgnoredTok]
      # @return [Result::Fail]
      def each
        return enum_for(:each) unless block_given?
        count = 0
        input = @input

        while true
          result = next_segment(input) do |token|
            yield token # IgnoredTok
          end
          break if result.fail?

          # Update @separators and @segment_dict as needed
          _update_state(result.value, @config) if @config
          yield result.value

          input  = result.rest
          count += 1
        end

        # The loop always terminates on failure, but we always expect an EOF
        # at some point; however, it's not expected to happen before reading
        # an ISA or while tokenizing things inside ISA..IEA
        result.fatal = count.zero? || @separators.present?
        result
      end

      # Tokenizes and yields only ISA segments as SegmentToks. Data between ISA
      # tokens is yielded as IgnoredToks. This is more efficient than `#each`
      # because it skips past most of the input.
      #
      # Return value indicates why tokenization terminated; usually it's due
      # to EOF. If no segments were read, or tokenizations halts in the middle
      # of a segment, then the result will be `#fatal?`.
      #
      # @yield  [Tokens::SegmentTok | Tokens::IgnoredTok]
      # @return [Result::Fail]
      def each_isa
        return enum_for(:each_isa) unless block_given?
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

        result.fatal = count.zero? #|| @separators.present?
        result
      end

    private

      # Skips over any text, X12 or not, until an interchange segment is
      # found. Then @separators are reset. This is more efficient than
      # repeatedly calling `next_segment` and checking if the segment_id
      # is :ISA.
      #
      # @yield  [Tokens::IgnoredTok]          the input that was ignored before "ISA"
      # @return [Result<Tokens::SegmentTok>]  the ISA segment
      def next_isa_segment(input)
        segment_id = _next_isa_segment_id(input) do |t|
          # It's not unusual for IgnoredTok to have no content, because "ISA"
          # was found at the first character of the input.
          yield t if block_given? and t.value.present?
        end
        return segment_id if segment_id.fail?

        elements = _read_isa_elements(segment_id.rest)
        return elements if elements.fail?

        done(Tokens::SegmentTok.build(:ISA, elements.value, segment_id.position),
             segment_id.position, elements.rest)
      end

      # Returns the next segment.
      #
      # @return [Result<Tokens::SegmentTok>]
      def next_segment(input)
        if @separators.blank?
          # We haven't yet found an ISA segment, which requires a different
          # method than `next_segment`.
          return next_isa_segment(input){|t| yield t if block_given? }
        end

        segment_id = _next_segment_id(input)
        return segment_id if segment_id.fail?

        if segment_id.value == :ISA
          # We encountered a new ISA segment without having seen the previous
          # ISA's matching IEA segment. This is definitely a syntax error, but
          # we can still continue tokenizing and let the caller decide how to
          # handle it.
          elements = _read_isa_elements(segment_id.rest)
          return elements if elements.fail?

          segment_tok = Tokens::SegmentTok.build(:ISA, elements.value, segment_id.position)
          return done(segment_tok, segment_id.position, elements.rest.lstrip_nongraphic!)
        end

        if @segment_dict.defined_at?(segment_id.value)
          element_uses = @segment_dict.at(segment_id.value).element_uses
        else
          element_uses = nil
        end

        elements = _read_elements(segment_id.rest, segment_id.value, element_uses)
        return elements if elements.fail?

        # We've parsed an IEA segment, so reset and look for an ISA next time
        @separators = Separators.blank if segment_id.value == :IEA

        done(Tokens::SegmentTok.build(segment_id.value, elements.value, segment_id.position),
             segment_id.position, elements.rest)
      end

      # Preconditions:  none
      # Postconditions: result.rest.head is '*'
      def _next_isa_segment_id(input)
        offset = 0

        while input.defined_at?(offset)
          # Skip ahead until we find next occurrence of characters ISA, not
          # case sensitive. Control characters are ignored between I, S, A
          i = input.index(@i, offset)

          # There's no I in the rest of the input, so it's all ignored
          return eof("ISA", input.position) if i.nil?

          # In the next iteration, search for "I" begins right after this one
          offset = i+1

          # Skip to the next character
          s = input.min_graphic_index(i+1)

          return eof("ISA", input.position) unless input.defined_at?(s)

          # The character after this "I" is not "S"
          next unless input.start_with?(@s, s)

          a = input.min_graphic_index(s+1)

          return eof("ISA", input.position) unless input.defined_at?(a)

          # The character after this "S" is not "A"
          next unless input.start_with?(@a, a)

          # The next character determines the element separator. If it's an
          # alphanumeric or space, we assume this is not the start of an ISA
          # segment. Perhaps a word like "L[ISA] " or "D[ISA]RRAY"
          next unless input.defined_at?(a+1) and input[a+1].match?(VALID_SEPARATOR)

          # Success, ignore everything before "I", resume parsing after "A".
          if block_given? and ignored = input.take(i) and ignored.present?
            yield Tokens::IgnoredTok.new(ignored, input.position)
          end

          # First character of input will be the element separator
          return done(:ISA, input.position_at(i), input.drop!(a+1))
        end

        return eof("ISA", input.position)
      end

      # Preconditions:  input.head is '*'
      # Postconditions: result.rest.head is first graphic character after '~'
      def _read_isa_elements(input)
        # The next character is a declaration of the element separator
        @separators         = Separators.blank
        @separators.element = input.head

        # Read the first 15 simple elements into an array
        element_toks = 15.times.map do |element_idx|
          element = _read_simple_element(input, false, :ISA, element_idx+1)
          return element if element.fail?

          input = element.rest
          element.value
        end

        # The next two characters define ISA16 (this is the component separator,
        # at least as early as version 00304) and the segment terminator. Both
        # can have control characters as values, so we don't skip ahead here.
        us = input.at(1)
        unless us and us.match?(VALID_SEPARATOR)
          return expected("component separator, found %s" %
            describe(us.inspect), input.position_at(1))
        end

        element_toks << Tokens::SimpleElementTok.build(input.at(1), input.position)

        tr = input.at(2) # Segment terminator
        unless tr and tr.match?(VALID_SEPARATOR)
          return expected("segment terminator after ISA16, found %s" %
            describe(tr.inspect), input.position_at(2))
        end

        return fail("segment terminator and element seprator are both %s" %
          tr.inspect) if tr == @separators.element

        return fail("segment terminator and component separator are both %s" %
          tr.inspect) if us == tr

        @separators.segment = tr
        done(element_toks, nil, input.drop!(3))
      end

      # Preconditions:  input begins on graphic character
      # Postconditions: result.rest.head is '*' or '~'
      def _next_segment_id(input)
        offset     = input.min_graphic_index
        start_pos  = input.position_at(offset)

        # Whichever occurs first
        gs = input.index(@separators.element, offset)
        tr = input.index(@separators.segment, offset)
        xx = if gs and tr and gs < tr; then gs end || tr || gs
        return eof("segment identifier", input.position) unless xx

        length = xx - offset
        buffer = input[offset, length]

        # We cannot avoid this String allocation. The `match?` call either has a
        # pattern with \A..\z, or the length of segment_id is very small
        # compared to the `@storage` after it, and either will cause `match?` to
        # allocate the short substring.
        #
        # Later, the segment_id will be subject to many equality checks, so it
        # is faster overall to make the substring copy here.
        segment_id = buffer.clean.to_s

        return expected("segment identifier, found %s" % segment_id.inspect,
          start_pos) unless segment_id.match?(VALID_SEGMENT_ID)

        # TODO: DEBUG
        # raise unless input.start_with?(@separators.segment, xx) \
        #           or input.start_with?(@separators.element, xx)

        return done(segment_id.to_sym, start_pos, input.drop!(xx))
      end

      # Preconditions:  input starts with '*' or '~'
      # Postconditions: result.rest.head is first graphic character after '~'
      def _read_elements(input, segment_id, element_uses)
        element_toks = []
        element_idx  = 1

        # We are placed on an element separator at the start of each iteration
        while input.start_with?(@separators.element)
          result =
            if element_uses and element_uses.defined_at?(element_idx - 1)
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
          input         = result.rest
          element_idx  += 1
        end

        # TODO: DEBUG
        # raise unless input.start_with?(@separators.segment)

        # Skip past the segment separator
        done(element_toks, nil, input.lstrip_nongraphic!(1))
      end

      # Preconditions:  input.head is '*'
      # Postconditions: result.rest.head is '*' or '~'
      def _read_composite_element(input, repeatable, segment_id, element_idx)
        builder        = @switcher.switch(repeatable, input.position)
        repeat_pos     = builder.position
        component_idx  = 1
        component_toks = []

        until input.empty?
          result = _read_component_element(input, false, repeatable, segment_id, element_idx, component_idx)
          return result if result.fail?

          input = result.rest
          char  = input.head
          component_toks << result.value

          if char == @separators.element or char == @separators.segment
            builder.add(Tokens::CompositeElementTok.build(component_toks, repeat_pos))
            return done(builder.build, builder.position, input)

          elsif repeatable and char == @separators.repetition
            builder.add(Tokens::CompositeElementTok.build(component_toks, repeat_pos))
            repeat_pos = input.position_at(1)
            component_toks = []

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

      # Preconditions:  input.head is '*', ':', or '^'
      # Postconditions: result.rest.head is next '~', '*', or ':'
      def _read_component_element(input, repeatable, parent_repeatable, segment_id, element_idx, component_idx)
        offset     = input.min_graphic_index(1)
        repeat_pos = input.position
        builder    = @switcher_.switch(repeatable, input.position)

        while input.defined_at?(offset)
          # Whichever occurs first
          tr = input.index(@separators.segment, offset)   if @separators.segment
          gs = input.index(@separators.element, offset)   if @separators.element
          xx = if gs and tr and gs < tr; then gs end || tr || gs

          us = input.index(@separators.component, offset) if @separators.component
          xx = if xx and us and xx < us; then xx end || us || xx

          # Because repetition separators are unlikely to occur at all, it could
          # become costly to repeatedly linearly search the remaining input when
          # reading every component element.
          #
          # However, so far X12 has said no component are repeatable, and it is
          # also rare for the parent composite to be repeatable. So we will only
          # search for it in those rare cases. When it occurs otherwise, we will
          # read it as plain data instead of halting tokenization with an error.
          rs = input.index(@separators.repetition, offset) \
            if @separators.repetition and (repeatable or parent_repeatable)

          if rs and rs < xx
            length = rs - offset
            buffer = input[offset, length]

            if repeatable
              builder.add(Tokens::SimpleElementTok.build(buffer.clean, repeat_pos))
              offset     = rs + 1
              repeat_pos = input.position_at(offset)
            else # parent_repeatable
              builder.add(Tokens::ComponentElementTok.build(buffer.clean, repeat_pos))
              return done(builder.build, builder.position, input.drop!(rs))
            end
          elsif xx
            length = xx - offset
            buffer = input[offset, length]

            builder.add(Tokens::ComponentElementTok.build(buffer.clean, repeat_pos))
            return done(builder.build, builder.position, input.drop!(xx))
          else
            break
          end
        end

        eof("separator (one of %s) after %s%02d-%02d" % [
          @separators.characters.map(&:inspect).join(", "), segment_id,
          element_idx, component_idx], builder.position)
      end

      # Preconditions:  input.head is '*'
      # Postconditions: result.rest.head is next '*' or '~'
      def _read_simple_element(input, repeatable, segment_id, element_idx)
        offset     = input.min_graphic_index(1)
        start_pos  = input.position
        repeat_pos = input.position
        builder    = @switcher.switch(repeatable, input.position)

        while input.defined_at?(offset)
          # Whichever occurs first
          tr = input.index(@separators.segment, offset) if @separators.segment
          gs = input.index(@separators.element, offset) if @separators.element
          xx = if gs and tr and gs < tr; then gs end || tr || gs
          break unless xx

          # Because repetition separators are unlikely to occur at all, it could
          # become costly to repeatedly linearly search the remaining input when
          # reading every simple element. However only few elements are allowed
          # to repeat, so we will only search in those cases.
          rs = input.index(@separators.repetition, offset) \
            if @separators.repetition and repeatable

          if rs and rs < xx
            # @sepatarors.repetition
            length = rs - offset
            buffer = input[offset, length]

            builder.add(Tokens::SimpleElementTok.build(buffer.clean, repeat_pos))
            offset     = rs + 1
            repeat_pos = input.position_at(offset)
          elsif xx
            # @separators.element
            # @separators.segment
            length = xx - offset
            buffer = input[offset, length]

            builder.add(Tokens::SimpleElementTok.build(buffer.clean, repeat_pos))
            return done(builder.build, start_pos, input.drop!(xx))
          else
            break
          end
        end

        eof("segment %s or element separator %s after %s%02d" % [
          @separators.segment.inspect, @separators.element.inspect, segment_id,
          element_idx], start_pos)
      end

      def describe(char)
        char.nil? && "eof" || char.inspect
      end

      def done(value, position, rest)
        Tokenizer::Result::Done.new(value, position, rest)
      end

      def fail(error, position)
        Tokenizer::Result::Fail.new(fail, position)
      end

      def expected(error, position)
        Tokenizer::Result::Fail.new("expected #{error}", position)
      end

      def unexpected(error, position)
        Tokenizer::Result::Fail.new("unexpected #{error}", position)
      end

      def eof(error, position)
        expected("#{error}, found eof", position)
      end

      def _update_state(segment_tok, config)
        case segment_tok.id
        when :ISA
          version = segment_tok.element_toks.at(11)
          version = version.value.to_s if version

          if config.interchange.defined_at?(version)
            # Configure separators that depend on the ISA version (ISA11)
            envelope_def   = config.interchange.at(version)
            ver_separators = envelope_def.separators(segment_tok)
            @separators    = @separators.merge(ver_separators)
          end
        when :GS
          # GS08: Version / Release / Industry Identifier Code
          version = segment_tok.element_toks.at(7).try(:value).try(:to_s)
          gscode  = version.try(:slice, 0, 6)

          # GS01: Functional Identifier Code
          fgcode = segment_tok.element_toks.at(0).try(:value)

          if config.functional_group.defined_at?(gscode)
            envelope_def  = config.functional_group.at(gscode)
            envelope_val  = envelope_def.empty
            @segment_dict = @segment_dict.push(envelope_val.segment_dict)
          end
        when :GE
          unless @segment_dict.empty?
            @segment_dict = @segment_dict.pop
          end
        end
      end
    end

    class << Tokenizer
      def build(input, config: nil, strict: false)
        new(input, config, Separators.blank, SegmentDict.empty,
          Tokenizer::ElementTokSwitch.new, Tokenizer::ElementTokSwitch.new, strict)
      end
    end
  end
end
