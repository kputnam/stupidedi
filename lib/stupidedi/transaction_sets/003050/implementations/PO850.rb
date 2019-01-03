# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module ThirtyFifty
      module Implementations
        b = Builder
        d = Schema
        r = SegmentReqs
        e = ElementReqs
        s = SegmentDefs

        PO850 = b.build("PO", "850", "Ship Notice/Manifest",
          d::TableDef.header("Heading",
            b::Segment(10, s:: ST, "Transaction Set Header",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Transaction Set Identifier Code", b::Values("850")),
              b::Element(e::Required,    "Transaction Set Control Number")),
            b::Segment(20, s::BEG, "Beginning Segment for Purchase Order",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Transaction Set Purpose Code", b::Values("00","01","06")),
              b::Element(e::Required,    "Purchase Order Type Code", b::Values("RL","SA")),
              b::Element(e::Required,    "Purchase Order Number"),
              b::Element(e::Situational, "Release Number"),
              b::Element(e::Situational, "Date")),
            b::Segment(30, s::NTE, "Note/Special Instruction",
              r::Situational, d::RepeatCount.bounded(100),
              b::Element(e::Situational, "Note Reference Code", b::Values("ADD")),
              b::Element(e::Required,    "Description - Free form comments")),
            b::Segment(60, s::PER, "Administrative Communications Contact",
              r::Situational, d::RepeatCount.bounded(3),
              b::Element(e::Required,    "Contact Function Code", b::Values("BD")),
              b::Element(e::Situational, "Name - Buyer Name")),

            d::LoopDef.build("N1", d::RepeatCount.bounded(200),
              b::Segment(310, s:: N1, "Name",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required, "Entity Identifier Code", b::Values("ST")),
                b::Element(e::Required, "Name - Plant Code", b::Values("CP","DP","SP"))))),

          d::TableDef.detail("Detail",
            d::LoopDef.build("PO1", d::RepeatCount.bounded(100000),
              b::Segment(10, s::PO1, "Baseline Item Data",
                r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Situational, "Assigned Identification"),
                b::Element(e::Situational, "Quantity Ordered"),
                b::Element(e::Situational, "Unit or Basis for Measurement Code"),
                b::Element(e::Situational, "Unit Price"),
                b::Element(e::NotUsed,     "Unknown"),
                b::Element(e::Situational, "Product/Service ID Qualifier",b::Values("BP")),
                b::Element(e::Situational, "Product/Service ID - Nissan Part Number")),

              d::LoopDef.build("PID", d::RepeatCount.bounded(1000),
                b::Segment( 50, s::PID, "Product/Item Description",
                  r::Situational, d::RepeatCount.bounded(1),
                  b::Element(e::Required,    "Item Description Type", b::Values("F")),
                  b::Element(e::NotUsed,     "Unknown"),
                  b::Element(e::NotUsed,     "Unknown"),
                  b::Element(e::NotUsed,     "Unknown"),
                  b::Element(e::Situational, "Description") )),

              d::LoopDef.build("DTM", d::RepeatCount.bounded(10),
                b::Segment(210, s::DTM, "Date/Time Reference",
                  r::Situational, d::RepeatCount.bounded(1),
                  b::Element(e::Required,    "Date/Time Qualifier", b::Values("002")),
                  b::Element(e::Situational, "Date"),
                  b::Element(e::NotUsed,     "Unknown"),
                  b::Element(e::NotUsed,     "Unknown"),
                  b::Element(e::Situational, "Century"))),

              d::LoopDef.build("N9", d::RepeatCount.unbounded,
                b::Segment(330, s::N9, "Reference Number",
                  r::Situational, d::RepeatCount.bounded(1),
                  b::Element(e::Required,    "Reference Number Qualifier", b::Values("BO")),
                  b::Element(e::Situational, "Reference Number - Nissan Delivery"))))),

          d::TableDef.header("Summary",
            b::Segment(10, s::CTT, "Transaction Totals",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Number of Line Items")),
            b::Segment(30, s::SE, "Transaction Set Trailer",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Number of Included Segments"),
              b::Element(e::Required,    "Transaction Set Control Number"))))

      end
    end
  end
end
