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

        SH856 = b.build("SH", "856", "Ship Notice/Manifest",
          d::TableDef.header("Heading",
            b::Segment(100, s:: ST, "Transaction Set Header", r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Transaction Set Identifier Code", b::Values("856")),
              b::Element(e::Required,    "Transaction Set Control Number")),
            b::Segment(200, s::BSN, "Beginning Segment for Ship Notice", r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Transaction Set Purpose Code", b::Values("00")),
              b::Element(e::Required,    "Shipment Identification"),
              b::Element(e::Required,    "Date - BSN03"),
              b::Element(e::Required,    "Time - BSN04"),
              b::Element(e::Situational, "Hierarchical Structure Code",b::Values("0004"))),
            b::Segment(300, s::DTM, "Date/Time Reference", r::Required, d::RepeatCount.bounded(10),
              b::Element(e::Required,    "Date/Time Qualifier", b::Values("011","017")),
              b::Element(e::Required,    "Date - DTM02"),
              b::Element(e::Situational, "Time - DTM03"),
              b::Element(e::NotUsed,     "Time Code"),
              b::Element(e::NotUsed,     "Century"),
              b::Element(e::NotUsed,     "DTM06"))),

          d::TableDef.detail("Detail",
            d::LoopDef.build("HL", d::RepeatCount.bounded(200000),
              b::Segment(200, s:: HL, "Hierarchical Level", r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Hierarchical ID Number"),
                b::Element(e::Situational, "Hierarchical Parent ID Number"),
                b::Element(e::Required,    "Hierarchical Level Code", b::Values("S")),
                b::Element(e::Situational, "Hierarchical Child Code")),
              b::Segment(1000, s::TD1, "Carrier Details (Quantity and Weight)", r::Required, d::RepeatCount.bounded(20),
                b::Element(e::Required,    "Packaging Code"),
               #b::Element(e::Required,    "Packaging Form", b::Values("CNT","CRT","CTN","PCS","PLT")),
               #b::Element(e::NotUsed,     "Packaging Material", b::Values("25","71","90","94"))),
                b::Element(e::Required,    "Lading Quantity")),
              b::Segment(1100, s::TD5, "Carrier Details (Routing Sequence/Transit Time)", r::Required, d::RepeatCount.bounded(12),
                b::Element(e::Situational, "Routing Sequence Code", b::Values("B")),
                b::Element(e::Required,    "Identification Code Qualifier", b::Values("2")),
                b::Element(e::Required,    "Identification Code"),
                b::Element(e::Situational, "Transportation Method/Type Code")),
              b::Segment(1200, s::TD3, "Carrier Details (Equipment)", r::Situational, d::RepeatCount.bounded(12),
                b::Element(e::NotUsed,     "TD301"),
                b::Element(e::NotUsed,     "TD302"),
                b::Element(e::NotUsed,     "TD303"),
                b::Element(e::Situational,  "Weight Qualifier", b::Values("G")),
                b::Element(e::Situational, "Weight"),
                b::Element(e::Situational, "Unit or Basis for Measurement Code", b::Values("LB"))),
             b::Segment(1500, s::REF, "Reference Identification", r::Required, d::RepeatCount.unbounded,
                b::Element(e::Required,    "Reference Identification Qualifier", b::Values("BM","OI","PK","SI")),
                b::Element(e::Situational, "Reference Identification")),

              d::LoopDef.build("N1", d::RepeatCount.bounded(200),
                b::Segment(3700, s:: N1, "Name SEGMENT #1", r::Required, d::RepeatCount.bounded(1),
                  b::Element(e::Required,    "Entity Identifier Code", b::Values("SF")),
                  b::Element(e::Situational, "Name"),
                  b::Element(e::Required,    "Identification Code Qualifier", b::Values("92")),
                  b::Element(e::Required,    "Identification Code"),
                  b::Element(e::NotUsed,     "N105"),
                  b::Element(e::NotUsed,     "N106")),
                b::Segment(3800, s:: N1, "Name SEGMENT #2", r::Required, d::RepeatCount.bounded(1),
                  b::Element(e::Required,    "Entity Identifier Code", b::Values("ST")),
                  b::Element(e::Situational, "Name"),
                  b::Element(e::Required,    "Identification Code Qualifier", b::Values("92")),
                  b::Element(e::Required,    "Identification Code"),
                  b::Element(e::NotUsed,     "N105"),
                  b::Element(e::NotUsed,     "N106")),
                b::Segment(3900, s:: N1, "Name SEGMENT #3", r::Situational, d::RepeatCount.bounded(1),
                  b::Element(e::Situational, "Entity Identifier Code", b::Values("RC")),
                  b::Element(e::Situational, "Name"),
                  b::Element(e::Situational, "Identification Code Qualifier", b::Values("92")),
                  b::Element(e::Situational, "Identification Code"),
                  b::Element(e::NotUsed,     "N105"),
                  b::Element(e::NotUsed,     "N106")))),

            d::LoopDef.build("HL", d::RepeatCount.bounded(200000),
              b::Segment(6200, s:: HL, "Hierarchical Level", r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Hierarchical ID Number"),
                b::Element(e::Situational, "Hierarchical Parent ID Number"),
                b::Element(e::Required,    "Hierarchical Level Code", b::Values("T")),
                b::Element(e::Situational, "Hierarchical Child Code")),
              b::Segment(6300, s::REF, "Reference Identification", r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Reference Identification Qualifier", b::Values("LS")),
                b::Element(e::Required,    "Reference Identification")),

            d::LoopDef.build("HL", d::RepeatCount.bounded(200000),
              b::Segment(6500, s:: HL, "Hierarchical Level", r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Hierarchical ID Number"),
                b::Element(e::Situational, "Hierarchical Parent ID Number"),
                b::Element(e::Required,    "Hierarchical Level Code", b::Values("I")),
                b::Element(e::Situational, "Hierarchical Child Code")),
              b::Segment(6600, s::LIN, "Item Identification", r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Situational, "Assigned Identification"),
                b::Element(e::Required,    "Product/Service ID Qualifier", b::Values("BP")),
                b::Element(e::Required,    "Product/Service ID"),
                b::Element(e::Required,    "Product/Service ID Qualifier", b::Values("ON")),
                b::Element(e::Required,    "Product/Service ID"),
                b::Element(e::NotUsed,     "Product/Service ID - Coil Number"),
                b::Element(e::NotUsed,     "Product/Service ID Qualifier"),
                b::Element(e::NotUsed,     "Product/Service ID"),
                b::Element(e::NotUsed,     "Product/Service ID Qualifier"),
                b::Element(e::NotUsed,     "Product/Service ID"),
                b::Element(e::NotUsed,     "Product/Service ID Qualifier"),
                b::Element(e::NotUsed,     "Product/Service ID"),
                b::Element(e::NotUsed,     "Product/Service ID Qualifier"),
                b::Element(e::NotUsed,     "Product/Service ID"),
                b::Element(e::NotUsed,     "Product/Service ID Qualifier"),
                b::Element(e::NotUsed,     "Product/Service ID"),
                b::Element(e::NotUsed,     "Product/Service ID Qualifier"),
                b::Element(e::NotUsed,     "Product/Service ID"),
                b::Element(e::NotUsed,     "Product/Service ID Qualifier"),
                b::Element(e::NotUsed,     "Product/Service ID"),
                b::Element(e::NotUsed,     "Product/Service ID Qualifier"),
                b::Element(e::NotUsed,     "Product/Service ID"),
                b::Element(e::NotUsed,     "Product/Service ID Qualifier"),
                b::Element(e::NotUsed,     "Product/Service ID"),
                b::Element(e::NotUsed,     "Product/Service ID Qualifier"),
                b::Element(e::NotUsed,     "Product/Service ID"),
                b::Element(e::NotUsed,     "Product/Service ID Qualifier"),
                b::Element(e::NotUsed,     "Product/Service ID"),
                b::Element(e::NotUsed,     "Product/Service ID Qualifier"),
                b::Element(e::NotUsed,     "Product/Service ID"),
                b::Element(e::NotUsed,     "Product/Service ID Qualifier")),
              b::Segment(6700, s::SN1, "Item Detail (Shipment)", r::Required, d::RepeatCount.bounded(1),
                b::Element(e::NotUsed,     "Assigned Identification"),
                b::Element(e::Required,    "Number of Units Shipped"),
                b::Element(e::Required,    "Unit or Basis for Measurement Code", b::Values("EA","PC")),
                b::Element(e::NotUsed,     "Quantity Shipped to Date"),
                b::Element(e::NotUsed,     "Quantity Ordered"),
                b::Element(e::NotUsed,     "Unit or Basis for Measurement Code"),
                b::Element(e::NotUsed,     "Returnable Container Load Make-Up Code"),
                b::Element(e::NotUsed,     "Line Item Status Code"))))),

          d::TableDef.header("Summary",
            b::Segment(100, s::CTT, "Transaction Totals", r::Situational, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Number of Line Items"),
              b::Element(e::NotUsed,     "Hash Total"),
              b::Element(e::NotUsed,     "Weight"),
              b::Element(e::NotUsed,     "Unit or Basis for Measurement Code"),
              b::Element(e::NotUsed,     "Volume"),
              b::Element(e::NotUsed,     "Unit or Basis for Measurement Code"),
              b::Element(e::NotUsed,     "Description")),
            b::Segment(200, s:: SE, "Transaction Set Trailer", r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Number of Included Segments"),
              b::Element(e::Required,    "Transaction Set Control Number"))))

      end
    end
  end
end
