# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module FortyTen
      module Implementations
        b = Builder
        d = Schema
        r = SegmentReqs
        e = ElementReqs
        s = SegmentDefs

        GF990 = b.build("GF", "990", "Response to a Load Tender",
          d::TableDef.header("Heading",
            b::Segment(10, s::ST, "Transaction Set Header", r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Transaction Set Identifier Code", b::Values("990")),
              b::Element(e::Required,    "Transaction Set Control Number")),
            b::Segment(20, s::B1, "Beginning Segment for Booking or Pick-up/Delivery", r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Situational, "Standard Carrier Alpha Code"),
              b::Element(e::Required,    "Shipment Identification Number"),
              b::Element(e::Situational, "Date"),
              b::Element(e::Situational, "Reservation Action Code")),
            b::Segment(30, s::N9, "Reference Identification", r::Situational, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Reference Identification Qualifier"),
              b::Element(e::Situational, "Reference Identification"),
              b::Element(e::NotUsed, "Free-form Description"),
              b::Element(e::NotUsed, "Date"),
              b::Element(e::NotUsed, "Time"),
              b::Element(e::NotUsed, "Time Code"),
              b::Element(e::NotUsed, "Reference Identifier")),
            b::Segment(60, s::K1, "Remarks", r::Situational, d::RepeatCount.bounded(10),
              b::Element(e::Required,    "Free-Form Message"),
              b::Element(e::Situational, "Free-Form Message")),
            b::Segment(70, s::SE, "Transaction Set Trailer", r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Number of Included Segments"),
              b::Element(e::Required,    "Transaction Set Control Number"))))

      end
    end
  end
end
