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
        # current segment definitions (s::SEG); elements the 4010 943 does not
        # exercise are marked NotUsed. W27's equipment elements were realigned to
        # their real positions (E40 Equipment Description Code had been skipped,
        # shifting Equipment Initial/Number one slot early). Segment and element
        # requirements are set to match the Standards 943 (an implementation may be
        # more restrictive than the standard, never less). See spec/fixtures/004010/AR943/.
        AR943 = b.build("AR", "943", "Warehouse Stock Transfer Shipment Advice",
          d::TableDef.header("Header",
            b::Segment(10, s:: ST, "Transaction Set Header", r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Transaction Set Identifier Code", b::Values("943")),
              b::Element(e::Required,    "Transaction Set Control Number")),
            b::Segment(20, s::W06, "Warehouse Shipment Identification", r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Reporting Code", b::Values("F", "U")),
              b::Element(e::Required,    "Depositor Order Number"),
              b::Element(e::Required,    "Date"),
              b::Element(e::Situational, "Shipment Identification Number"),
              b::Element(e::NotUsed,     "Agent Shipment ID Number"),
              b::Element(e::Situational, "Purchase Order Number"),
              b::Element(e::NotUsed,     "Master Reference Number"),
              b::Element(e::NotUsed,     "Link Sequence Number"),
              b::Element(e::NotUsed,     "Special Handling Code"),
              b::Element(e::NotUsed,     "Shipping Date Change Reason Code"),
              b::Element(e::NotUsed,     "Transaction Type Code"),
              b::Element(e::NotUsed,     "Action Code")),

            d::LoopDef.build("N1", d::RepeatCount.bounded(200),
              b::Segment(140, s:: N1, "Name", r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Entity Identifier Code", b::Values("WH")),
                b::Element(e::Required,    "Name"),
                b::Element(e::Required,    "Identification Code Qualifier", b::Values("91")),
                b::Element(e::Required,    "Identification Code"),
                b::Element(e::NotUsed,     "Entity Relationship Code"),
                b::Element(e::NotUsed,     "Entity Identifier Code"))),

            b::Segment(110, s::G62, "Date/Time Reference", r::Situational, d::RepeatCount.bounded(2),
              b::Element(e::Situational,    "Date Qualifier"),
              b::Element(e::Situational,    "Date"),
              b::Element(e::Situational, "Time Qualifier"),
              b::Element(e::Situational, "Time"),
              b::Element(e::Situational, "Time Code")),
            b::Segment(130, s::W27, "Carrier Detail", r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Transportation Method/Type Code", b::Values("M", "R")),
              b::Element(e::Situational, "Standard Carrier Alpha Code"),
              b::Element(e::Situational, "Routing"),
              b::Element(e::Situational, "Shipment Method of Payment", b::Values("CC", "PP")),
              b::Element(e::NotUsed,     "Equipment Description Code"),
              b::Element(e::Situational, "Equipment Initial"),
              b::Element(e::Situational, "Equipment Number"),
              b::Element(e::NotUsed,     "Shipment/Order Status Code"),
              b::Element(e::NotUsed,     "Special Handling Code"),
              b::Element(e::NotUsed,     "Carrier/Route Change Reason Code"))),

          d::TableDef.header("Detail",
            d::LoopDef.build("W04", d::RepeatCount.bounded(100000),
              b::Segment(10, s::W04, "Baseline Item Data", r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Item Detail Total"),
                b::Element(e::Required,    "Unit or Basis for Measurement Code", b::Values("CS", "EA", "IP", "PL")),
                b::Element(e::Situational, "U.P.C. Case Code"),
                b::Element(e::Situational, "Product/Service ID Qualifier", b::Values("VN")),
                b::Element(e::Situational, "Product/Service ID"),
                b::Element(e::NotUsed,     "Product/Service ID Qualifier"),
                b::Element(e::NotUsed,     "Product/Service ID"),
                b::Element(e::NotUsed,     "Freight Class Code"),
                b::Element(e::NotUsed,     "Rate Class Code"),
                b::Element(e::NotUsed,     "Commodity Code Qualifier"),
                b::Element(e::NotUsed,     "Commodity Code"),
                b::Element(e::NotUsed,     "Pallet Block and Tiers"),
                b::Element(e::NotUsed,     "Inbound Condition Hold Code"),
                b::Element(e::NotUsed,     "Product/Service ID Qualifier"),
                b::Element(e::NotUsed,     "Product/Service ID"))),

            d::LoopDef.build("N9", d::RepeatCount.bounded(1000),
              b::Segment(50, s::N9, "Reference Identification", r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required, "Reference Identification Qualifier", b::Values("LI")),
                b::Element(e::Required, "Reference Identification"),
                b::Element(e::NotUsed,  "Free-form Description"),
                b::Element(e::NotUsed,  "Date"),
                b::Element(e::NotUsed,  "Time"),
                b::Element(e::NotUsed,  "Time Code"),
                b::Element(e::NotUsed,  "Reference Identifier")))),

          d::TableDef.header("Summary",
            b::Segment(10, s::W03, "Total Shipment Information", r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Number of Units Shipped"),
              b::Element(e::Situational, "Weight"),
              b::Element(e::Situational, "Unit or Basis for Measurement Code"),
              b::Element(e::NotUsed,     "Volume"),
              b::Element(e::NotUsed,     "Unit or Basis for Measurement Code"),
              b::Element(e::NotUsed,     "Lading Quantity"),
              b::Element(e::NotUsed,     "Unit or Basis for Measurement Code")),
            b::Segment(30, s::SE, "Transaction Set Trailer", r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Number of Included Segments"),
              b::Element(e::Required,    "Transaction Set Control Number"))))

      end
    end
  end
end
