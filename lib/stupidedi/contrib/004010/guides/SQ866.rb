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

        SQ866 = b.build(t::SQ866,
          d::TableDef.header("Header",
            b::Segment(10, s:: ST, "Transaction Set Header",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Transaction Set Identifier Code", b::Values("866")),
              b::Element(e::Required,    "Transaction Set Control Number")),

            b::Segment(20, s::BSS, "Beginning Segment for Shipping Schedule/Production Sequence",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Transaction Set Purpose Code", b::Values("05")),
              b::Element(e::Required,    "Reference Identification - Nissan Transaction Number", b::Values("SP","CP")),
              b::Element(e::Required,    "Date"),
              b::Element(e::Required,    "Schedule Type Qualifier", b::Values("JS")),
              b::Element(e::Required,    "Date - Today's Date (CCYYMMDD)"),
              b::Element(e::Required,    "Date - Today's Date (CCYYMMDD)"),
              b::Element(e::Situational, "Release Number"),
              b::Element(e::Situational, "Reference Identification"),
              b::Element(e::NotUsed, ""),
              b::Element(e::NotUsed, ""),
              b::Element(e::NotUsed, ""))),

          d::TableDef.header("Detail",
            d::LoopDef.build("DTM", d::RepeatCount.bounded(100),
              b::Segment(110, s::DTM, "Date/Time Reference",
                r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Date/Time Qualifier", b::Values("097")),
                b::Element(e::Situational, "Date - Create Date (CCYYMMDD)"),
                b::Element(e::Situational, "Time - Create Time (HHMMSS)"),
                b::Element(e::NotUsed, ""),
                b::Element(e::NotUsed, ""),
                b::Element(e::NotUsed, "")),

              d::LoopDef.build("LIN", d::RepeatCount.unbounded,
                b::Segment(150, s::LIN, "Item Identification",
                  r::Situational, d::RepeatCount.bounded(1),
                  b::Element(e::NotUsed, ""),
                  b::Element(e::Required,    "Product/Service ID Qualifier", b::Values("BP")),
                  b::Element(e::Required,    "Product/Service ID - Nissan Part Number"),
                  b::Element(e::Situational,    "Product/Service ID Qualifier", b::Values("JS")),
                  b::Element(e::Situational,    "Product/Service ID - Parts Delivery Sequence Number (PDSN)"),
                  b::Element(e::Situational,    "Product/Service ID Qualifier - Vehicle ID", b::Values("VV")),
                  b::Element(e::Situational,    "Product/Service ID - Vehicle Identification Number (VIN)"),
                  b::Element(e::NotUsed, ""),
                  b::Element(e::NotUsed, ""),
                  b::Element(e::NotUsed, ""),
                  b::Element(e::NotUsed, ""),
                  b::Element(e::NotUsed, ""),
                  b::Element(e::NotUsed, ""),
                  b::Element(e::NotUsed, ""),
                  b::Element(e::NotUsed, ""),
                  b::Element(e::NotUsed, ""),
                  b::Element(e::NotUsed, ""),
                  b::Element(e::NotUsed, ""),
                  b::Element(e::NotUsed, ""),
                  b::Element(e::NotUsed, ""),
                  b::Element(e::NotUsed, ""),
                  b::Element(e::NotUsed, ""),
                  b::Element(e::NotUsed, ""),
                  b::Element(e::NotUsed, ""),
                  b::Element(e::NotUsed, ""),
                  b::Element(e::NotUsed, ""),
                  b::Element(e::NotUsed, ""),
                  b::Element(e::NotUsed, ""),
                  b::Element(e::NotUsed, ""),
                  b::Element(e::NotUsed, ""),
                  b::Element(e::NotUsed, "")),

                b::Segment(160, s::REF, "Reference Identification - Dock Number",
                  r::Situational, d::RepeatCount.unbounded,
                  b::Element(e::Required,    "Reference Identification Qualifier", b::Values("DK")),
                  b::Element(e::Situational, "Reference Identification - Dock Number"),
                  b::Element(e::NotUsed, ""),
                  b::Element(e::NotUsed, "")),

                b::Segment(160, s::REF, "Reference Identification - Line Feed Location",
                  r::Situational, d::RepeatCount.unbounded,
                  b::Element(e::Required,    "Reference Identification Qualifier", b::Values("LF")),
                  b::Element(e::Required,    "Reference Identification"),
                  b::Element(e::NotUsed, ""),
                  b::Element(e::NotUsed, "")),

                b::Segment(170, s::QTY, "Quantity",
                  r::Situational, d::RepeatCount.bounded(1),
                  b::Element(e::Required, "Quantity Qualifier", b::Values("01")),
                  b::Element(e::Situational, "Quantity"))))),


          d::TableDef.header("Summary",
            b::Segment(195, s::CTT, "Transaction Totals",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Number of Line Items"),
              b::Element(e::NotUsed, ""),
              b::Element(e::NotUsed, ""),
              b::Element(e::NotUsed, ""),
              b::Element(e::NotUsed, ""),
              b::Element(e::NotUsed, ""),
              b::Element(e::NotUsed, "")),
            b::Segment(200, s::SE, "Transaction Set Trailer",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Number of Included Segments"),
              b::Element(e::Required,    "Transaction Set Control Number"))))

      end
    end
  end
end

