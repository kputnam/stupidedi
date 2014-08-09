module Stupidedi
  module Contrib
    module ThirtyTen
      module Guides

        b = GuideBuilder
        d = Schema
        r = SegmentReqs
        e = ElementReqs
        s = Versions::FunctionalGroups::ThirtyTen::SegmentDefs
        # s = Versions::FunctionalGroups::FortyTen::SegmentDefs
        t = Contrib::ThirtyTen::TransactionSetDefs
        #t = Contrib::FortyTen::TransactionSetDefs
        #
        # 830 Planning Schedule with Release Capability
        #
        PS830 = b.build(t::PS830,
          d::TableDef.header("Header",
            b::Segment(10, s:: ST, "Transaction Set Header",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Transaction Set Identifier Code", b::Values("830")),
              b::Element(e::Required,    "Transaction Set Control Number")),
            b::Segment(20, s::BFR, "Beginning Segment for Planning Schedule",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Transaction Set Purpose Code", b::Values("00")),
              b::Element(e::Situational,  "Reference Number NNA Release Period"),
              b::Element(e::Situational,    "Release Number"),
              b::Element(e::Required,    "Schedule Type Qualifier", b::Values("DL")),
              b::Element(e::Required,    "Schedule Quantity Qualifier", b::Values("A")),
              b::Element(e::Required,    "Date - Beginning Date"),
              b::Element(e::Required,    "Date - Ending Date"),
              b::Element(e::Required,    "Date - Release Create Date"))),

          d::TableDef.header("Detail",
            d::LoopDef.build("N1 - LOOP1", d::RepeatCount.bounded(200),
              b::Segment(90, s:: N1, "Name - Nissan Analyst",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Entity Identifier Code", b::Values("MI")),
                b::Element(e::Situational, "Identification Code Qualifier", b::Values("Nissan")),
                b::Element(e::Situational, "Identification Code Qualifier"),
                b::Element(e::Situational,  "Identification Code - Supplier Code")),
              b::Segment( 140, s::PER, "Administrative Communications Contact - Nissan Release Sr Analyst",
                r::Situational, d::RepeatCount.bounded(3),
                b::Element(e::Required,    "Contact Function Code", b::Values("OD")),
                b::Element(e::Situational, "Name - PER02"),
                b::Element(e::Situational, "Communication Number Qualifier", b::Values("TE")),
                b::Element(e::Situational, "Communication Number"),
                b::Element(e::NotUsed,     "PER05"),
                b::Element(e::NotUsed,     "PER06"),
                b::Element(e::NotUsed,     "PER07"),
                b::Element(e::NotUsed,     "PER08"),
                b::Element(e::NotUsed,     "PER09"))),

            d::LoopDef.build("LIN", d::RepeatCount.bounded(10000),
              b::Segment( 010, s::LIN, "Item Identification",
                r::Required, d::RepeatCount.bounded(1),
                b::Element(e::NotUsed,     "LIN01"),
                b::Element(e::Required,    "Product/Service ID Qualifier - LIN02", b::Values("VP")),
                b::Element(e::Required,    "Product/Service ID - NNA Part Number"),
                b::Element(e::Situational, "Product/Service ID Qualifier - LIN04", b::Values("PO")),
                b::Element(e::Situational, "Product/Service ID - NNA PO Number"),
                b::Element(e::NotUsed,     "LIN06"),
                b::Element(e::NotUsed,     "LIN07"),
                b::Element(e::NotUsed,     "LIN08"),
                b::Element(e::NotUsed,     "LIN09"),
                b::Element(e::NotUsed,     "LIN10"),
                b::Element(e::NotUsed,     "LIN11"),
                b::Element(e::NotUsed,     "LIN12"),
                b::Element(e::NotUsed,     "LIN13"),
                b::Element(e::NotUsed,     "LIN14"),
                b::Element(e::NotUsed,     "LIN15"),
                b::Element(e::NotUsed,     "LIN16"),
                b::Element(e::NotUsed,     "LIN17"),
                b::Element(e::NotUsed,     "LIN18"),
                b::Element(e::NotUsed,     "LIN19"),
                b::Element(e::NotUsed,     "LIN20"),
                b::Element(e::NotUsed,     "LIN21"),
                b::Element(e::NotUsed,     "LIN22"),
                b::Element(e::NotUsed,     "LIN23"),
                b::Element(e::NotUsed,     "LIN24"),
                b::Element(e::NotUsed,     "LIN25"),
                b::Element(e::NotUsed,     "LIN26"),
                b::Element(e::NotUsed,     "LIN27"),
                b::Element(e::NotUsed,     "LIN28"),
                b::Element(e::NotUsed,     "LIN29"),
                b::Element(e::NotUsed,     "LIN30"),
                b::Element(e::NotUsed,     "LIN31")),
              b::Segment( 020, s::UIT, "Unit of Measure",
                r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Unit or Basis for Measurement Code", b::Values("LB"))),
              b::Segment( 080, s::PID, "Product/Item Description",
                r::Situational, d::RepeatCount.bounded(1000),
                b::Element(e::Required,     "Item Description Type",  b::Values("F")),
                b::Element(e::Situational, "Product/Process Characteristic Code", b::Values("9B")),
                b::Element(e::NotUsed,     "PID03"),
                b::Element(e::NotUsed,     "PID04"),
                b::Element(e::Situational, "Description - Part Description")),

              d::LoopDef.build("SDP", d::RepeatCount.bounded(260),
                b::Segment( 290, s::SDP, "Ship/Delivery Pattern",
                  r::Required, d::RepeatCount.bounded(1),
                  b::Element(e::Required,    "Ship/Delivery or Calendar Pattern Code", b::Values("Y")),
                  b::Element(e::Required,    "Ship/Delivery Pattern Time Code", b::Values("Y"))),
                b::Segment( 300, s::FST, "Forecast Schedule",
                  r::Required, d::RepeatCount.bounded(260),
                  b::Element(e::Required,    "Quantity"),
                  b::Element(e::Required,    "Forecast Qualifier", b::Values("C","D")),
                  b::Element(e::Required,    "Forecast Timing Qualifier", b::Values("D")),
                  b::Element(e::Required,    "Date - Scheduled Usage Date"),
                  b::Element(e::NotUsed,  "FST05"),
                  b::Element(e::Situational, "Date/Time Qualifier", b::Values("002")),
                  b::Element(e::Situational, "Time - Delivery Requested Time"),
                  b::Element(e::Situational, "Reference Number Qualifier", b::Values("DO")),
                  b::Element(e::Situational, "Reference Number - Customer Assigned Order Number"))),

              b::Segment(390, s::MAN, "Marks and Numbers",
                r::Situational, d::RepeatCount.bounded(10),
                b::Element(e::Required, "Marks and Numbers Qualifier", b::Values("PB")),
                b::Element(e::Required, "Marks and Numbers")))),

          d::TableDef.header("Summary",
            b::Segment(010, s::CTT, "Transaction Totals",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required, "Number of Line Items"),
              b::Element(e::Situational,  "Hash Total"),
              b::Element(e::NotUsed,  "CTT03"),
              b::Element(e::NotUsed,  "CTT04"),
              b::Element(e::NotUsed,  "CTT05"),
              b::Element(e::NotUsed,  "CTT06"),
              b::Element(e::NotUsed,  "CTT07")),
            b::Segment(020, s:: SE, "Transaction Set Trailer",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required, "Number of Included Segments"),
              b::Element(e::Required, "Transaction Set Control Number"))))

      end
    end
  end
end
