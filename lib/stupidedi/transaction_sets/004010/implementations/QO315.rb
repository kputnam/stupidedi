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

        QO315 = b.build("QO", "315", "Container Status Updates",
          d::TableDef.header("Heading",
            b::Segment(10, s::ST, "Transaction Set Header", r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Transaction Set Identifier Code", b::Values("315")),
              b::Element(e::Required,    "Transaction Set Control Number")),
            b::Segment(20, s::B4, "Beginning Segment for Inquiry or Reply", r::Required, d::RepeatCount.bounded(1),
              b::Element(e::NotUsed,     "Special Handling Code"),
              b::Element(e::NotUsed,     "Inquiry Request Number"),
              b::Element(e::Situational, "Shipment Status Code"),
              b::Element(e::Situational, "Status Date"),
              b::Element(e::Situational, "Status Time"),
              b::Element(e::Situational, "Status Location"),
              b::Element(e::Situational, "Equipment Initial"),
              b::Element(e::Situational, "Equipment Number"),
              b::Element(e::Situational, "Equipment Status Code", b::Values("E","L")),
              b::Element(e::Situational, "Equipment Type"),
              b::Element(e::Situational, "Location Identifier"),
              b::Element(e::Situational, "Location Qualifier", b::Values("UN", "CI")),
              b::Element(e::Situational, "Equipment Number Check Digit"))
            b::Segment(30, s::N9, "Reference Identification", r::Required, d::RepeatCount.bounded(30),
              b::Element(e::Required,    "Reference Identification Qualifier"),
              b::Element(e::Situational, "Reference Identification"),
              b::Element(e::Situational, "Free-form Description")
            )
          b::Segment(40, s::Q2, "Status Details (Ocean)", r::Situational, d::RepeatCount.bounded(1),
              b::Element(e::Situational, "Vessel Code"),
              b::Element(e::Situational, "Country Code"),
              b::Element(e::Situational, "Date"),
              b::Element(e::Situational, "Date"),
              b::Element(e::Situational, "Date"),
              b::Element(e::Situational, "Lading Quantity"),
              b::Element(e::Situational, "Weight"),
              b::Element(e::Situational, "Weight Qualifier"),
              b::Element(e::Situational, "Flight/Voyage Number"),
              b::Element(e::Situational, "Reference Identification Qualifier", b::Values("SCA")),
              b::Element(e::Situational, "Reference Identification"),
              b::Element(e::Situational, "Vessel Code Qualifier"),
              b::Element(e::Situational, "Vessel Name"),
              b::Element(e::Situational, "Volume"),
              b::Element(e::Situational, "Volume Unit Qualifier"),
              b::Element(e::Situational, "Weight Unit Code"))

          d::LoopDef.build("R4", RepeatCount.unbounded,
            b::Segment(60, s::R4, "Port or Terminal", r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required, "Port or Terminal Function Code"),
                b::Element(e::Situational, "Location Qualifier"),
                b::Element(e::Situational, "Location Identifier"),
                b::Element(e::Situational, "Port Name"),
                b::Element(e::Situational, "Country Code"))
            b::Segment(70, s::DTM, "Date/Time Reference", r::Required, d::RepeatCount.bounded(15),
                b::Element(e::Required, "Date/Time Qualifier"),
                b::Element(e::Situational, "Date"),
                b::Element(e::Situational, "Time"),
                b::Element(e::Situational, "Time Code")))
      end
    end
  end
end
