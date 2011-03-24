module Stupidedi
  module Dictionaries
    module Interchanges
      module FiveOhOne

        class InterchangeVal < Envelope::InterchangeVal

          def initialize(definition, children)
            super(definition, children)
          end

          # @return [InterchangeVal]
          def copy(changes = {})
            InterchangeVal.new \
              changes.fetch(:definition, definition),
              changes.fetch(:children, children)
          end

          # @return [Module]
          def segment_dict
            definition.segment_dict
          end
        end

      end
    end
  end
end
