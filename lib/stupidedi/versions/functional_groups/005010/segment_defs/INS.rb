# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs


# 1 Primary Or Depedent (Y/N)
# 2 Relationship Code (self)
# 3 Audit or Compare (Full file)
# 4 Maintenance Reason Code (Dissatisfaction with Medical Care/Services Rendered)
# 5 Benefit Status Code(Active)
# 6 BLANK
# 7 BLANK
# 8 Employment Status Code (Full Time)
# 9 BLANK
# 10 Yes/No Condition or Response Code(No)
# 11 BLANK
# 12 BLANK
# 13 BLANK
# 14 BLANK
# 15 BLANK
# 16 BLANK
# 17 A generic number(0)

          INS = s::SegmentDef.build(:INS, "Covered Information",
            "Information about the insured",
            e::E1073 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E61 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E61 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E61 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E61 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E61 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E61 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E61 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E61 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E1073 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E61 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E61 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E61 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E61 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E61 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E61 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E61 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))
        end
      end
    end
  end
end

