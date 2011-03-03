module Stupiedi
  module Dictionaries
    module Interchange
      module FiveOhOne
        module ElementDictionary

          # Import definitions of B, DT, R, ID, Nn, AN, TM, and SimpleElementDef
          include FunctionalGroups::FiftyTen::ElementTypes

          class SeparatorElementVal < Values::SimpleElementVal
            delegate :to_s, :to => :@value

            def initialize(value, definition, parent)
              @value = value
              super(definition, parent)
            end

            def copy(changes = {})
              self.class.new \
                changes.fetch(:value, @value),
                changes.fetch(:definition, definition),
                changes.fetch(:parent, parent)
            end
          end

          class << SeparatorElementVal
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

          I01 = ID.new(:I01, "Authorization Information Qualifier",    2,  2)
          I02 = AN.new(:I02, "Authorization Information",             10, 10)
          I03 = ID.new(:I03, "Security Information Qualifier",         2,  2)
          I04 = AN.new(:I04, "Security Information",                  10, 10)
          I05 = ID.new(:I05, "Interchange ID Qualifier",               2,  2)
          I06 = AN.new(:I06, "Interchange Sender ID",                 15, 15)
          I07 = AN.new(:I07, "Interchange Receiver ID",               15, 15)
          I08 = DT.new(:I08, "Interchange Date",                       6,  6)
          I09 = TM.new(:I09, "Interchange Time",                       4,  4)

          I11 = ID.new(:I11, "Interchange Control Version Number",     5,  5)
          I12 = N0.new(:I12, "Interchange Control Number",             9,  9)
          I13 = ID.new(:I13, "Acknowledgment Requested",               1,  1)
          I14 = ID.new(:I14, "Interchange Usage Indicator",            1,  1)

          I15 = Class.new(SimpleElementDef) do
            def companion
              SeparatorElementVal
            end
          end.new(:I15, "Component Element Separator",                 1,  1)

          I16 = N0.new(:I16, "Number of Included Functional Groups",   1,  5)
          I17 = ID.new(:I17, "Interchange Acknowledgement Code",       1,  1)
          I18 = ID.new(:I18, "Interchange Note Code",                  3,  3)

          I65 = Class.new(SimpleElementDef) do
            def companion
              SeparatorElementVal
            end
          end.new(:I65 "Repetition Separator",                        1,  1)

        end
      end
    end
  end
end
