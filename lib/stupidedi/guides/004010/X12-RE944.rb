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

        RE944 = b.build(t::RE944,
          d::TableDef.header("Header",
            b::Segment(10, s:: ST, "Transaction Set Header", r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Transaction Set Identifier Code", b::Values("944")),
              b::Element(e::Required,    "Transaction Set Control Number")),

            b::Segment(20, s::W17, "Warehouse Receipt Identification", r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required, "Reporting Code", b::Values("F")),
              b::Element(e::Required, "Date"),
              b::Element(e::Required, "Warehouse Receipt Number"),
              b::Element(e::Required, "Depositor Order Number"),
              b::Element(e::Optional, "Shipment Identification Number")
            ),

            d::LoopDef.build("N1", d::RepeatCount.bounded(10),
              b::Segment(40, s:: N1, "Name", r::Situational, d::RepeatCount.bounded(2),
                b::Element(e::Required,    "Entity Identifier Code", b::Values("WH", "DE")),
                b::Element(e::Situational,    "Name"),
                b::Element(e::Situational, "Identification Code Qualifier", b::Values("9")),
                b::Element(e::Situational, "Identification Code")),

            ),

            b::Segment(140, s::G62, "Date/Time Reference", r::Situational, d::RepeatCount.bounded(2),
              b::Element(e::Situational,    "Date Qualifier"),
              b::Element(e::Situational,    "Date"),
              b::Element(e::Situational, "Time Qualifier"),
              b::Element(e::Situational, "Time"),
              b::Element(e::Situational, "Time Code")

            )


          ),
          
          d::TableDef.header("Detail",
            d::LoopDef.build("W07", d::RepeatCount.bounded(9999),
              b::Segment(20, s::W07, "Item Detail For Stock Receipt", r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Mandatory,      "Quantity Received"),
                b::Element(e::Mandatory,      "Unit or Basis for Measurement Code", b::Values("EA", "CA", "LB")),
                b::Element(e::Situational,    "U.P.C. Case Code"),
                b::Element(e::Situational,    "Product/Service ID Qualifier", b::Values("UK")),
                b::Element(e::Situational,    "Product/Service ID"),
                b::Element(e::Optional,       "Warehouse Lot Number")
              ),
              b::Segment(30, s::G69, "Line Item Detail - Description", r::Optional, d::RepeatCount.bounded(1),
                b::Element(e::Mandatory,      "Free-form descriptive text")
              ),
              b::Segment(40, s::N9, "Reference Identification", r::Optional, d::RepeatCount.bounded(200),
                b::Element(e::Mandatory,      "Reference Identification Qualifier"),
                b::Element(e::Situational,    "Reference Identification")
              )
            )

          ),


          d::TableDef.header("Summary",
            b::Segment(10, s::W14, "Total Receipt Information", r::Optional, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Quantity Received")
            ),
            b::Segment(20, s::SE, "Transaction Set Trailer", r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Number of Included Segments"),
              b::Element(e::Required,    "Transaction Set Control Number")
            )
          )
        )
      end
    end
  end
end
