module Stupiedi
  module Dictionaries
    module Interchange
      module FourOhOne
        module ElementDictionary

          I01 = ID.new("Authorization Information Qualifier",     2,  2)
          I02 = AN.new("Authorization Information",              10, 10)
          I03 = ID.new("Security Information Qualifier",          2,  2)
          I04 = AN.new("Security Information",                   10, 10)
          I05 = ID.new("Interchange ID Qualifier",                2,  2)
          I06 = AN.new("Interchange Sender ID",                  15, 15)
          I07 = AN.new("Interchange Receiver ID",                15, 15)
          I08 = DT.new("Interchange Date",                        6,  6)
          I09 = TM.new("Interchange Time",                        4,  4)
          I10 = ID.new("Interchange Control Standards Identifier", 1, 1)
          I11 = ID.new("Interchange Control Version Number",      5,  5)
          I12 = N0.new("Interchange Control Number",              9,  9)
          I13 = ID.new("Acknowledgment Requested",                1,  1)
          I14 = ID.new("Interchange Usage Indicator",             1,  1)
          I15 = Class.new(SimpleElementDef) do
            # @todo
          end.new("Component Element Separator",                  1,  1)
          I16 = N0.new("Number of Included Functional Groups",    1,  5)
          I17 = ID.new("Interchange Acknowledgement Code",        1,  1)
          I18 = ID.new("Interchange Note Code",                   3,  3)

        end
      end
    end
  end
end
