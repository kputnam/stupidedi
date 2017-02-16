# frozen_string_literal: true

module Stupidedi
  module Contrib
    module FortyTen
      module Guides

        b = GuideBuilder
        d = Schema
        r = SegmentReqs
        e = ElementReqs
        s = Versions::FunctionalGroups::FortyTen::SegmentDefs
        t = Contrib::FortyTen::TransactionSetDefs

        #
        # Response to a Load Tender
        #
        GF990 = b.build(t::GF990,
          d::TableDef.header("Heading",
            b::Segment(10, s::ST, "Transaction Set Header",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Transaction Set Identifier Code", b::Values("990")),
              b::Element(e::Required,    "Transaction Set Control Number")),

            b::Segment(20, s::B1, "Beginning Segment for Booking or Pick-up/Delivery",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Situational, "Standard Carrier Alpha Code"),
              b::Element(e::Required,    "Shipment Identification Number"),
              b::Element(e::Situational, "Date"),
              b::Element(e::Situational, "Reservation Action Code")),

            b::Segment(30, s::N9, "Reference Identification",
              r::Situational, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Reference Identification Qualifier"),
              b::Element(e::Situational, "Reference Identification"),
              b::Element(e::Situational, "Free-form Description"),
              b::Element(e::Situational, "Date"),
              b::Element(e::Situational, "Time"),
              b::Element(e::Situational, "Time Code"),
              b::Element(e::Situational, "Reference Identifier")),

            b::Segment(60, s::K1, "Remarks",
              r::Situational, d::RepeatCount.bounded(10),
              b::Element(e::Required,    "Free-Form Message"),
              b::Element(e::Situational, "Free-Form Message")),

            b::Segment(70, s::SE, "Transaction Set Trailer",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Number of Included Segments"),
              b::Element(e::Required,    "Transaction Set Control Number"))))

      end
    end
  end
end
