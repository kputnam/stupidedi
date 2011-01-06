module Stupidedi
  module Reader

    module TokenReader
      def default
        DefaultReader.new(input, interchange_header)
      end

      def input
        raise NoMethodError, "Method input must be implemented in subclass"
      end

      def interchange_header
        raise NoMethodError, "Method interchange_header must be implemented in subclass"
      end

      def empty?
        input.empty?
      end

      # Consume s if it is directly in front of the cursor
      def consume_prefix(s)
        return success(self) if s.empty?

        position = 0
        buffer   = ""

        while input.defined_at?(position)
          character = input.at(position)
          position += 1

          unless is_control?(character)
            buffer << character

            if s.length == buffer.length
              # Written without ternary to track code coverage more granularly... gnulryngnuu
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

      # Consume input, including s, from here to the next occurrence of s
      def consume(s)
        position = 0
        buffer   = " " * s.length

        while input.defined_at?(position)
          character = input.at(position)

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

      def read_delimiter
        position = 0

        while input.defined_at?(position)
          character = input.at(position)
          position += 1

          next if is_control?(character)

          return is_delimiter?(character) ?
            result(character, advance(position)) :
            failure("Found #{character.inspect} instead of a delimiter")
        end

        failure("Reached end of input without finding a delimiter")
      end

      # If a simple element definition is given, this returns an Either[Result[SimpleElementVal]].
      # If a composite element definition is given, this returns an Either[Result[CompositeElementVal]].
      # Otherwise, this returns an "unparsed" Either[Result[String]]. In any case, the delimeter
      # immediately following the element is present in the remaining input.
      def read_element(element_def = nil)
        if element_def.try(&:simple?)
          read_simple_element(element_def)
        else
          read_composite_element(element_def)
        end
      end

      # When no argument is given, this returns an "unparsed" Either[Result[String]]. If a
      # simple element definition is given, this returns an Either[Result[SimpleElementVal]].
      # In both cases, the delimeter immediately following the element is present in the
      # remaining input.
      def read_simple_element(simple_element_def = nil)
        position = 0
        buffer   = ""

        while input.defined_at?(position)
          character = input.at(position)

          if is_delimiter?(character)
            break
          end

          unless is_control?(character)
            buffer << character
          end

          position += 1
        end

        remainder = if input.defined_at?(position)
                      success(advance(position))
                    else
                      failure("Reached end of input without finding a delimiter")
                    end

        # Just return a plain unparsed string
        return remainder.flatmap{|r| result(buffer, r) } if simple_element_def.nil?

        # Let the element definition attempt to parse the string
        remainder.flatmap do |r|
          simple_element_def.parse(buffer).flatmap do |value|
            # Wrap this in a result
            result(value, r)
          end.or do |message|
            # Roundabout way to report the offset from self.input, where self who
            # received the read_simple_element message.
            failure(message)
          end
        end
      end

      # When no argument is given, this returns an "unparsed" Either[Result[String]]. If a
      # composite element definition is given, this returns an Either[Result[CompositeElementVal]].
      # In both cases, the delimeter immediately following the element is present in the
      # remaining input.
      def read_composite_element(composite_element_def = nil)
        if composite_element_def.nil?
          position = 0
          buffer   = ""

          while input.defined_at?(position)
            character = input.at(position)

            case character
            when interchange_header.segment_terminator,
                 interchange_header.element_separator,
                 interchange_header.repetition_separator
              # These all effectively terminate the composite element. In fact, they are
              # terminals for simple elements too.
              break
            when interchange_header.component_separator
              # This terminates a component element, but we don't have any component element
              # definitions to actually parse this. So we don't bother splitting up the
              # component elements at all.
              buffer << character
            else
              buffer << character unless is_control?
            end

            position += 1
          end

          if input.defined_at?(position)
            result(buffer, advance(position))
          else
            failure("Reached end of input before finding a segment terminator, element separator, or repetition separator")
          end
        else
          composite_element_def.reader(input, interchange_header).read
        end
      end

      # Read the next segment id and don't consume the delimiter
      def read_segment_id
        position = 0
        buffer   = ""

        while input.defined_at?(position) and buffer.length <= 3
          character = input.at(position)

          if is_delimiter?(character)
            break
          end

          unless is_control?(character)
            buffer << character
          end

          position += 1
        end

        if input.defined_at?(position)
          # Not sure if this is in the X12 specs, but it seems reasonable for now
          if buffer =~ /\A[A-Z][A-Z0-9]{1,2}\Z/
            allowed = [interchange_header.segment_terminator,
                       interchange_header.element_separator]

            # We're cheating a bit, but we know that segment IDs must be directly
            # followed by the segment_terminator or element_separator
            if allowed.include?(input.at(position))
              result(buffer, advance(position))
            else
              failure("Found #{input.at(position).inspect} instead of #{allowed.map(&:inspect).join(' or ')}")
            end
          else
            failure("Found #{buffer.inspect} instead of a segment identifier")
          end
        else
          failure("Reached end of input before finding a segment identifier")
        end
      end

      def read_segment(segment_def = nil)
        if segment_def.nil?
          # TODO.. read_segment_id, then read up to and including segment_terminator
        else
          segment_def.reader(input, interchange_header).read
        end
      end

      # Consume, up to and including, the next iea's segment terminator
      # @todo Optimize if this is in tail call form
      def consume_interchange
        read_segment_id.flatmap do |result|
          id, rest = *result

          rest.consume(interchange_header.segment_terminator).flatmap do |rest|
            if id == "IEA"
              success(StreamReader.new(rest.input))
            else
              rest.consume_interchange
            end
          end
        end
      end

      def ==(other)
        if TokenReader === other
          input == other.input and interchange_header == other.interchange_header
        else
          input == other
        end
      end

    private

      # Returns a new TokenReader with n characters consumed from input
      # @abstract
      def advance(n)
        raise NoMethodError, "Method advance(n) must be implemented in subclass"
      end

      def failure(message)
        Either.failure(Reader::Failure.new(message, input))
      end

      def success(value)
        Either.success(value)
      end

      def result(value, remainder)
        Either.success(Reader::Success.new(value, remainder))
      end

      def is_delimiter?(character)
        character == interchange_header.segment_terminator  or
        character == interchange_header.element_separator   or
        character == interchange_header.component_separator or
        character == interchange_header.repetition_separator
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
    end

  end
end
