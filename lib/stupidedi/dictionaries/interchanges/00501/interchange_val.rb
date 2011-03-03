module Stupidedi
  module Dictionaries
    module Interchanges
      module FiveOhOne

        class InterchangeVal < Values::InterchangeVal
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
          end

          def initialize(segment_vals, functional_group_vals, definition, separators = nil)
            super(definition, segment_vals, functional_group_vals)

            @separators =
              if separators.nil?
                if isa = at(:isa).first
                  Separators.new(isa.at(16).to_s, isa.at(11).to_s, nil, nil, self)
                else
                  Separators.new(nil, nil, nil, nil, self)
                end
              else
                separators.copy(:parent => self)
              end
          end

          # @return [InterchangeVal]
          def copy(changes = {})
            self.class.new \
              changes.fetch(:segment_vals, segment_vals),
              changes.fetch(:functional_group_vals, functional_group_vals),
              changes.fetch(:definition, definition),
              changes.fetch(:separators, @separators)
          end
        end

      end
    end
  end
end
