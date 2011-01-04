module Stupidedi
  module FiftyTen
    module Base

      class ElementReader
        include Reader::TokenReader
      end

      class SimpleElementReader < ElementReader
        attr_reader \
          :input,
          :interchange_header

        def initialize(input, interchange_header, simple_element_def)
          @input, @interchange_header, @simple_element_def = input, interchange_header, simple_element_def
        end

        def read_simple_element
          super(@simple_element_def)
        end

        alias read read_simple_element

      private

        def advance(n)
          unless @input.defined_at?(n-1)
            raise IndexError, "Less than #{n} characters available"
          else
            self.class.new(@input.drop(n), @interchange_header, @simple_element_def)
          end
        end
      end

      class CompositeElementReader < ElementReader
        attr_reader \
          :input,
          :interchange_header

        def initialize(input, interchange_header, composite_element_def)
          @input, @interchange_header, @composite_element_def = input, interchange_header, composite_element_def
        end

        def read_composite_element
          read_components.map{|result| result.map{|cs| Values::CompositeElementVal.new(@composite_element_def, cs) }}
        end

        def read_components
          head, *tail = @composite_element_def.component_element_uses

          read_simple_element(head.element_def).flatmap do |r|
            r.remainder.read_delimiter.flatmap do |d|
              case d.value
              when @interchange_header.component_separator
                if tail.empty?
                  # No more component element defs to parse
                  failure("Found a component separator #{@interchange_header.component_separator.inspect} instead of an element separator, segment terminator, or repetition separator")
                else
                  # Parse the next component
                  rest = self.class.from_reader(d.remainder, @composite_element_def.tail)
                  rest.read_components.map{|x| x.map{|cs| r.value.cons(cs) }}
                end
              when @interchange_header.element_separator,
                   @interchange_header.segment_terminator,
                   @interchange_header.repetition_separator
                # Remaining components are blank
                result(r.value.cons(tail.map{|x| x.element_def.empty }), r.remainder)
              end
            end
          end
        end

        alias read read_composite_element

      private

        def advance(n)
          unless @input.defined_at?(n-1)
            raise IndexError, "Less than #{n} characters available"
          else
            self.class.new(@input.drop(n), @interchange_header, @composite_element_def)
          end
        end
      end

      class << CompositeElementReader
        def from_reader(reader, composite_element_def)
          new(reader.input, reader.interchange_header, composite_element_def)
        end
      end

    end
  end
end
