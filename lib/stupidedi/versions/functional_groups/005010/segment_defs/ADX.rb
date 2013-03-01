module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          ADX = s::SegmentDef.build(:ADX, "Adjustment",
            "To designate the entities which are parties to a transaction and specify a reference meaningful to those entities",
            e::E782.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)), 
            e::E426 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E128 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E127.simple_use(r::Relational, s::RepeatCount.bounded(1))
          )

        end
      end
    end
  end
end
