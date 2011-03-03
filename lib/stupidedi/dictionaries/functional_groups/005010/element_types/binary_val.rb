module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module ElementTypes

          class BinaryVal < Values::SimpleElementVal
          end

          class << BinaryVal
            def empty(definition, parent)
              raise NoMethodError, "@todo"
            end

            def value(object, definition, parent)
              raise NoMethodError, "@todo"
            end

            def reader(input, context)
              raise NoMethodError, "@todo"
            end
          end

        end
      end
    end
  end
end
