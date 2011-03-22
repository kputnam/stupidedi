module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module ElementTypes

          #
          # @see X222.pdf B.1.1.3.1.7 Binary
          #
          class BinaryVal < Values::SimpleElementVal
            # @todo
          end

          class << BinaryVal
            def empty(definition, parent)
              raise NoMethodError, "@todo"
            end

            def value(object, definition, parent)
              raise NoMethodError, "@todo"
            end
          end

        end
      end
    end
  end
end
