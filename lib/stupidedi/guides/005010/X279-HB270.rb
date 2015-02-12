module Stupidedi
  module Guides
    module FiftyTen
      module X279
        b = GuideBuilder
        d = Schema
        r = SegmentReqs
        e = ElementReqs
        s = Versions::FunctionalGroups::FiftyTen::SegmentDefs
        t = Versions::FunctionalGroups::FiftyTen::TransactionSetDefs

        HB270 = b.build(t::HB270,
          d::TableDef.header("Table 1 - Header",
            b::Segment(100, s::ST,  "Transaction Set Header",
            r::Required, d::RepeatCount.bounded(1),
            b::Element
      end
    end
  end
end
