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

        # Re-enabled per issue #175. The element lists were completed to match the
        # current segment definitions (s::SEG); elements the 4010 944 does not
        # exercise are marked NotUsed. W07's Warehouse Lot Number was realigned to
        # its real position (a second Product/Service ID pair had been skipped), and
        # e::Mandatory (not a defined ElementReq) was corrected to e::Required.
        # Segment and element requirements are set to match the Standards 944 (an
        # implementation may be more restrictive than the standard, never less).
        # See spec/fixtures/004010/RE944/.
        RE944 = b.build("RE", "944", "Warehouse Stock Transfer Receipt Advice",
          d::TableDef.header("Header",
            b::Segment(10, s:: ST, "Transaction Set Header", r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Transaction Set Identifier Code", b::Values("944")),
              b::Element(e::Required,    "Transaction Set Control Number")),
            b::Segment(20, s::W17, "Warehouse Receipt Identification", r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Reporting Code", b::Values("F")),
              b::Element(e::Required,    "Date"),
              b::Element(e::Required,    "Warehouse Receipt Number"),
              b::Element(e::Required,    "Depositor Order Number"),
              b::Element(e::Situational, "Shipment Identification Number"),
              b::Element(e::NotUsed,     "Time Qualifier"),
              b::Element(e::NotUsed,     "Time"),
              b::Element(e::NotUsed,     "Master Reference Number"),
              b::Element(e::NotUsed,     "Link Sequence Number")),

            d::LoopDef.build("N1", d::RepeatCount.bounded(10),
              b::Segment(40, s:: N1, "Name", r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Entity Identifier Code"),
                b::Element(e::Situational, "Name"),
                b::Element(e::Required,    "Identification Code Qualifier", b::Values("9")),
                b::Element(e::Required,    "Identification Code"),
                b::Element(e::NotUsed,     "Entity Relationship Code"),
                b::Element(e::NotUsed,     "Entity Identifier Code"))),

            b::Segment(140, s::G62, "Date/Time Reference", r::Situational, d::RepeatCount.bounded(2),
              b::Element(e::Situational, "Date Qualifier"),
              b::Element(e::Situational, "Date"),
              b::Element(e::Situational, "Time Qualifier"),
              b::Element(e::Situational, "Time"),
              b::Element(e::Situational, "Time Code"))),

          d::TableDef.header("Detail",
            d::LoopDef.build("W07", d::RepeatCount.bounded(9999),
              b::Segment(20, s::W07, "Item Detail For Stock Receipt", r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required,     "Quantity Received"),
                b::Element(e::Required,     "Unit or Basis for Measurement Code", b::Values("EA", "CA", "LB")),
                b::Element(e::Situational, "U.P.C. Case Code"),
                b::Element(e::Situational, "Product/Service ID Qualifier", b::Values("UK")),
                b::Element(e::Situational, "Product/Service ID"),
                b::Element(e::NotUsed,     "Product/Service ID Qualifier"),
                b::Element(e::NotUsed,     "Product/Service ID"),
                b::Element(e::Situational, "Warehouse Lot Number"),
                b::Element(e::NotUsed,     "Warehouse Detail Adjustment Identifier Code"),
                b::Element(e::NotUsed,     "Product/Service ID Qualifier"),
                b::Element(e::NotUsed,     "Product/Service ID")),
              b::Segment(30, s::G69, "Line Item Detail - Description", r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,     "Free-form descriptive text")),
              b::Segment(40, s::N9, "Reference Identification", r::Required, d::RepeatCount.bounded(200),
                b::Element(e::Required,     "Reference Identification Qualifier"),
                b::Element(e::Situational, "Reference Identification"),
                b::Element(e::NotUsed,     "Free-form Description"),
                b::Element(e::NotUsed,     "Date"),
                b::Element(e::NotUsed,     "Time"),
                b::Element(e::NotUsed,     "Time Code"),
                b::Element(e::NotUsed,     "Reference Identifier")))),

          d::TableDef.header("Summary",
            b::Segment(10, s::W14, "Total Receipt Information", r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Quantity Received"),
              b::Element(e::NotUsed,     "Quantity"),
              b::Element(e::NotUsed,     "Quantity"),
              b::Element(e::NotUsed,     "Quantity"),
              b::Element(e::NotUsed,     "Quantity")),
            b::Segment(20, s::SE, "Transaction Set Trailer", r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Number of Included Segments"),
              b::Element(e::Required,    "Transaction Set Control Number"))))

      end
    end
  end
end
