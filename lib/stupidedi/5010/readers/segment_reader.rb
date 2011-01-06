module Stupidedi
  module FiftyTen
    module Readers

      class SegmentReader
        include Reader::TokenReader

        attr_reader :input, :interchange_header

        attr_reader :segment_def

        def initialize(input, interchange_header, segment_def)
          @input, @interchange_header, @segment_def =
            input, interchange_header, segment_def
        end

        def read_segment
          # Read the segment ID, eg "REF"
          consume_prefix(@segment_def.id).flatmap do |rest|

            # Must be followed by a delimiter
            rest.read_delimiter.flatmap do |r|
              case r.value
              when @interchange_header.element_separator
                # Start parsing each element
                r.remainder.read_elements.map do |result|
                  result.map{|es| Values::SegmentVal.new(@segment_def, es) }
                end

              when @interchange_header.segment_terminator
                # No elements present
                result(Values::SegmentVal.empty(@segment_def), r.remainder)

              when @interchange_header.component_separator
                failure("Found a component separator #{@interchange_header.component_separator} immediately following a segment identifier")

              when @interchange_header.repetition_separator
                failure("Found a repetition separator #{@interchange_header.repetition_separator} immediately following a segment identifier")
              end
            end
          end
        end

        alias read read_segment

      protected

        # Returns a Result with a list of (Simple|Composite|Repeated)ElementVals
        def read_elements
          head, *tail = @segment_def.element_uses

          head.element_def.reader(input, @interchange_header).read.flatmap do |r|
            # Parsed element is in r.value

            r.remainder.read_delimiter.flatmap do |d|
              case d.value
              when @interchange_header.repetition_separator
                if head.repetition_count.once?
                  failure("Found a repetition separator following a non-repeatable element")
                else
                  # Read the same element def again, and append it onto the RepeatedElementVal
                  rest = self.class.from_reader(d.remainder, @segment_def)
                  rest.read_elements.map do |result|
                    result.map{|es| es.head.prepend(r.value).cons(es.tail) }
                  end
                end

              when @interchange_header.element_separator
                if tail.empty?
                  # No more element defs to parse
                  failure("Found an element separator #{@interchange_header.element_separator.inspect} instead of a segment terminator")
                else
                  # Parse next element
                  rest = self.class.from_reader(d.remainder, @segment_def.tail)

                  # Prepend the parsed element onto the next elements
                  if head.repetition_count.once?
                    rest.read_elements.map{|x| x.map{|es| r.value.cons(es) }}
                  else
                    # Convert the SimpleElementVal to a RepeatedElementVal
                    rest.read_elements.map{|x| x.map{|es| r.value.repeated.cons(es) }}
                  end
                end

              when @interchange_header.segment_terminator
                if head.repetition_count.once?
                  empties = tail.map{|x| x.element_def.empty }
                  result(r.value.cons(empties), d.remainder)
                else
                  empties = tail.map{|x| x.element_def.empty }
                  result(r.value.repeated.cons(empties), d.remainder)
                end

              when @interchange_header.component_separator
                # This separator may only follow component elements
                failure("Found a component separator #{@interchange_header.component_separator.inspect} following an element")
              end
            end
          end
        end

      private

        def advance(n)
          unless @input.defined_at?(n-1)
            raise IndexError, "Less than #{n} characters available"
          else
            self.class.new(@input.drop(n), @interchange_header, @segment_def)
          end
        end

      end

      class << SegmentReader
        def from_reader(reader, segment_def)
          SegmentReader.new(reader.input, reader.interchange_header, segment_def)
        end
      end

    end
  end
end
