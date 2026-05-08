# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module FiftyTen
      module Standards
        b = Builder
        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        # 317 Delivery/Pickup Order
        #
        # This transaction set demonstrates interleaved segments and loops:
        # Loop N1 is followed by segments G62, N9, TD5, then Loop L0.
        #
        SO317 = b.build("SO", "317", "Delivery/Pickup Order",
          d::TableDef.header("Heading",
            s::ST .use(100, r::Mandatory, d::RepeatCount.bounded(1)),
            d::LoopDef.build("N1", d::RepeatCount.bounded(10),
              s::N1 .use(200, r::Mandatory, d::RepeatCount.bounded(1)),
              s::N2 .use(300, r::Optional,  d::RepeatCount.bounded(1)),
              s::N3 .use(400, r::Optional,  d::RepeatCount.bounded(1)),
              s::N4 .use(500, r::Optional,  d::RepeatCount.bounded(1)),
              s::G61.use(600, r::Optional,  d::RepeatCount.bounded(1))),
            # These segments appear AFTER Loop N1 but BEFORE Loop L0
            # This is the interleaved pattern that was previously unsupported
            s::G62.use(800,  r::Mandatory, d::RepeatCount.bounded(1)),
            s::N9 .use(900,  r::Mandatory, d::RepeatCount.bounded(1)),
            s::TD5.use(1000, r::Mandatory, d::RepeatCount.bounded(1)),
            d::LoopDef.build("L0", d::RepeatCount.bounded(9999),
              s::L0.use(1100, r::Mandatory, d::RepeatCount.bounded(1)),
              s::L5.use(1200, r::Optional,  d::RepeatCount.bounded(1)),
              s::H1.use(1300, r::Optional,  d::RepeatCount.bounded(1))),
            s::SE .use(1400, r::Mandatory, d::RepeatCount.bounded(1))))

      end
    end
  end
end
