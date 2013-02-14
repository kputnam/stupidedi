module Stupidedi
  module Guides
    module FortyTen
      module X12

        b = GuideBuilder
        d = Schema
        r = SegmentReqs
        e = ElementReqs
        s = Versions::FunctionalGroups::FortyTen::SegmentDefs
        t = Versions::FunctionalGroups::FortyTen::TransactionSetDefs

        #
        # Warehouse Ship Order
        #
        OW940 = b.build(t::OW940,
          d::TableDef("Header",
            b::Segment(10, s:: ST, "Transaction Set Header", r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required, "Transaction Set Identifier Code", b::Values("940")),
              b::Element(e::Required, "Transaction Set Control Number")),

            b::Segment(20, s:: W05, "Shipping Order Identification", r::Required, d::RepeadCount.bounded(1),
              b::Element(e::Required, "Order Status Code", b::Values("F", "N", "R")),
              b::Element(e::Required, "Depositor Order Number"),
              b::Element(e::Optional, "Purchase Order Number"),
              b::Element(e::Situational, "Link Sequence Number"),
              b::Element(e::Situational, "Master Reference Number")),

            d::LoopDef.build("N1", d::RepeatCount.bounded(10),
              b::Segment(40, s:: N1, "Name", r::Situational, d::RepeatCount.bounded(3),
                b::Element(e::Required,    "Entity Identifier Code", b::Values("ST", "DE", "VN", "WH", "SF")),
                b::Element(e::Required,    "Name"),
                b::Element(e::Required, "Identification Code Qualifier", b::Values("91", "9", "ZZ")),
                b::Element(e::Required, "Identification Code")),

              b::Segment(50, s:: N2, "Additional Name Information", r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required, "Additional Name Information"),
                b::Element(e::Optional, "Additional Name Information")),

              b::Segment(60, s:: N3, "Address Information", r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required, "Address Information"),
                b::Element(e::Optional, "Address Information")),

              b::Segment(70, s:: N4, "Geographic Location", r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required, "City Name"),
                b::Element(e::Required, "State Code"),
                b::Element(e::Optional, "Postal Code")),

            ),

            b::Segment(90, s:: N9, "Reference Number", r::Situational, d::RepeatCount.bounded(10),
              b::Element(e::Required, "Reference Identification Qualifier", b::Values("BR", "CO")),
              b::Element(e::Required, "Reference Identification")),

            b::Segment(110, s:: G62, "Date/Time", r::Required, d::RepeatCount.bounded(10),
              b::Element(e::Required, "Date Qualifier", b::Values("02", "10")),
              b::Element(e::Required, "Date")),

            b::Segment(120, s:: NTE, "Note/Special Instruction", r::Optional, d::RepeatCount.bounded(9999),
              b::Element(e::Optional, "Note Reference Code", b::Values("WHI", "DEL")),
              b::Element(e::Required, "Description")),

            b::Segment(140, s:: W66, "Warehouse Carrier Information", r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required, "Ship Method of Payment", b::Values("CC", "PB", "PP")),
              b::Element(e::Required, "Transport Type Code", b::Values("A", "H", "M", "R")),
              b::Element(e::Optional, "Pallet Exchange Code"),
              b::Element(e::Optional, "Routing"),
              b::Element(e::Optional, "SCAC"))

          ),

          d::TableDef.header("Detail",
            d::LoopDef.build("LX", d::RepeatCount.bounded(9999),
              b::Segment(5, s:: LX, "Assigned Number", r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required, "Assigned Number")
              )
            ),

            d::LoopDef.build("W01", d::RepeatCount.bounded(9999),
              b::Segment(20, s:: W01, "Line Item Detail", r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required, "Quantity Ordered"),
                b::Element(e::Required, "Unit/Basis Measurement Code", b::Values("CA")),
                b::Element(e::Situational, "UPC Case Code"),
                b::Element(e::Situational, "Product/Service ID Qualifier", b::Values("VN", "VI")),
                b::Element(e::Situational, "Product/Service ID"),
                b::Element(e::Situational, "Product/Service ID Qualifier", b::Values("UC")),
                b::Element(e::Situational, "Product/Service ID"),
                b::Element(e::Optional, "Warehouse Lot Number")
              ),
              b::Segment(40, s:: N9 ,"Reference Number", r::Optional, d::RepeatCount.bounded(200),
                b::Element(e::Required, "Reference Identifier Qualifier", b::Values("LI", "PC", "PJ", "PK")),
                b::Element(e::Required, "Reference Identifier")
              ),
              b::Segment(50, s:: W20, "Pack Detail", r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required, "Case Inner Pack"),
                b::Element(e::Required, "Outer Pack")
              )
            )
            

          ),

          d::TableDef.header("Summary",
            b::Segment(10, s::W03, "Total Shipment Information", r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Quantity Ordered"),
              b::Element(e::Situational, "Weight"),
              b::Element(e::Situational, "Unit or Basis for Measurement Code", b::Values("LB")),
              b::Element(e::Situational, "Volume"),
              b::Element(e::Situational, "Unit/Basis Measurement Code", b::Values("CF"))
            ),
            b::Segment(30, s::SE, "Transaction Set Trailer", r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Number of Included Segments"),
              b::Element(e::Required,    "Transaction Set Control Number")
            )
          )

        )
      end
    end
  end
end

