module Stupidedi
  module Dictionaries
    module Interchanges
      module FiveOhOne

        class InterchangeVal < Envelope::InterchangeVal

          # @return [Reader::Separators]
          attr_reader :separators

          def initialize(definition, children, separators = nil)
            super(definition, children)

            @separators =
              if separators.nil?
                component  = nil
                repetition = nil

                if isa = at(:ISA).first
                  component  = isa.at(15).to_s
                  repetition = isa.at(10).to_s
                end

                Reader::Separators.new(component, repetition, nil, nil)
              else
                separators.copy(:parent => self)
              end
          end

          # @return [InterchangeVal]
          def copy(changes = {})
            self.class.new \
              changes.fetch(:definition, definition),
              changes.fetch(:children, children),
              changes.fetch(:separators, @separators)
          end

          def segment_dict
            definition.segment_dict
          end
        end

      end
    end
  end
end
