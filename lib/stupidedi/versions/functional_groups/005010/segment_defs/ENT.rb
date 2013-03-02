module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          # @todo: Copied from 4010 implementation guide
          ENT = s::SegmentDef.build(:ENT, "Entity",
            "To designate the entities which are parties to a transaction and specify a reference meaningful to those entities",
            e::E554.simple_use(r::Mandatory, s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end
