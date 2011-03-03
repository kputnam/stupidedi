module Stupidedi
  module Dictionaries
    module Interchanges
      module FiveOhOne
        module ElementDefs

          # Import definitions of B, DT, R, ID, Nn, AN, TM, and SimpleElementDef
          t = FunctionalGroups::FiftyTen::ElementTypes

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

          I01 = t::ID.new(:I01, "Authorization Information Qualifier",    2,  2)
          I02 = t::AN.new(:I02, "Authorization Information",             10, 10)
          I03 = t::ID.new(:I03, "Security Information Qualifier",         2,  2)
          I04 = t::AN.new(:I04, "Security Information",                  10, 10)
          I05 = t::ID.new(:I05, "Interchange ID Qualifier",               2,  2)
          I06 = t::AN.new(:I06, "Interchange Sender ID",                 15, 15)
          I07 = t::AN.new(:I07, "Interchange Receiver ID",               15, 15)
          I08 = t::DT.new(:I08, "Interchange Date",                       6,  6)
          I09 = t::TM.new(:I09, "Interchange Time",                       4,  4)

          I11 = t::ID.new(:I11, "Interchange Control Version Number",     5,  5)
          I12 = t::Nn.new(:I12, "Interchange Control Number",             9,  9, 0)
          I13 = t::ID.new(:I13, "Acknowledgment Requested",               1,  1)
          I14 = t::ID.new(:I14, "Interchange Usage Indicator",            1,  1)

          I15 = Class.new(t::SimpleElementDef) do
            def companion
              SeparatorElementVal
            end
          end.new(:I15, "Component Element Separator",                    1,  1)

          I16 = t::Nn.new(:I16, "Number of Included Functional Groups",   1,  5, 0)
          I17 = t::ID.new(:I17, "Interchange Acknowledgement Code",       1,  1)
          I18 = t::ID.new(:I18, "Interchange Note Code",                  3,  3)

          I65 = Class.new(t::SimpleElementDef) do
            def companion
              SeparatorElementVal
            end
          end.new(:I65, "Repetition Separator",                           1,  1)

        end
      end
    end
  end
end
