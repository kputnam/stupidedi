module Stupidedi
  module Dictionaries
    module Interchanges
      module FiveOhOne

        class InterchangeVal < Envelope::InterchangeVal
          class Separators
            attr_reader :component  # :
            attr_reader :repetition # ^
            attr_reader :element    # *
            attr_reader :segment    # ~

            def initialize(component, repetition, element, segment, parent)
              @component, @repetition, @element, @segment, @parent =
                component, repetition, element, segment, parent
            end

            # @return [Separators]
            def copy(changes = {})
              self.class.new \
                changes.fetch(:component, @component),
                changes.fetch(:repetition, @repetition),
                changes.fetch(:element, @element),
                changes.fetch(:segment, @segment),
                changes.fetch(:parent, @parent)
            end

            def inspect
              "Separators(#{@component.inspect}, #{@repetition.inspect}, #{@element.inspect}, #{@segment.inspect})"
            end
          end

          # @return [Separators]
          attr_reader :separators

          def initialize(definition, header_segment_vals, functional_group_vals, trailer_segment_vals, separators = nil)
            super(definition, header_segment_vals, functional_group_vals, trailer_segment_vals)

            @separators =
              if separators.nil?
                component  = nil
                repetition = nil

                if isa = at(:ISA).first
                  component  = isa.at(15).to_s
                  repetition = isa.at(10).to_s
                end

                Separators.new(component, repetition, nil, nil, self)
              else
                separators.copy(:parent => self)
              end
          end

          # @return [InterchangeVal]
          def copy(changes = {})
            self.class.new \
              changes.fetch(:definition, definition),
              changes.fetch(:header_segment_vals, header_segment_vals),
              changes.fetch(:functional_group_vals, functional_group_vals),
              changes.fetch(:trailer_segment_vals, trailer_segment_vals),
              changes.fetch(:separators, @separators)
          end
        end

      end
    end
  end
end
