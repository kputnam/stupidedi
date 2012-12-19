module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          MS1 = s::SegmentDef.build(:MS1, "Equipment, Shipment, or Real Property Location",
            "To specify the location of a piece of equipment, a shipment, or real property in terms of city and state for the stop location that relates to the AT7 shipment status details.",
            e:: E19.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E156.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e:: E26.simple_use(r::Relational, s::RepeatCount.bounded(1)),

            SyntaxNotes::L.build(1, 2, 3))

        end
      end
    end
  end
end
