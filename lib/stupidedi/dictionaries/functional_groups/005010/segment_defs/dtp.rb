module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          DTP = SegmentDef.build :DTP, "Date or Time Period",
            "To specify any or all of a date, or a time period",
            E::E374 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E1250.simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E1251.simple_use(Mandatory,  RepeatCount.bounded(1))

        end
      end
    end
  end
end
