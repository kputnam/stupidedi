module Stupidedi
  module Contrib
    module ThirtyTen
      module Guides

        b = GuideBuilder
        d = Schema
        r = SegmentReqs
        e = ElementReqs
        s = Versions::FunctionalGroups::ThirtyTen::SegmentDefs
        t = Contrib::ThirtyTen::TransactionSetDefs

        #
        # Ship Notice/Manifest
        #
        PC860 = b.build(t::PC860,
          d::TableDef.header("Heading",
            b::Segment(10, s:: ST, "Transaction Set Header",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Transaction Set Identifier Code", b::Values("850")),
              b::Element(e::Required,    "Transaction Set Control Number")),

            b::Segment(20, s::BCH, "Beginning Segment for Purchase Order Change",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Transaction Set Purpose Code", b::Values("00","05","18")),
              b::Element(e::Required,    "Purchase Order Type Code", b::Values("BE","BK","SP")),
              b::Element(e::Required,    "Purchase Order Number"),
              b::Element(e::NotUsed,     "Unknown"),
              b::Element(e::Situational, "Change Order Sequence Number"),
              b::Element(e::Situational, "Purchase Order Date")),

            b::Segment(40, s::CUR, "Currency",
              r::Situational, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Entity Identifier Code", b::Values("BY")),
              b::Element(e::Required,    "Currency Code", b::Values("USD")),
              b::Element(e::Situational, "Exchange Rate")),

            b::Segment(80, s::FOB, "F.O.B. Related Instructions",
              r::Situational, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Shipment Method of Payment", b::Values("DE")),
              b::Element(e::Situational, "Location Qualifier", b::Values("AC")),
              b::Element(e::Situational, "Description"),
              b::Element(e::Situational, "Location Qualifier"),
              b::Element(e::Situational, "Description - Postal Code")),

            b::Segment(130, s::ITD, "Terms of Sale/Deferred Terms of Sale",
              r::Situational, d::RepeatCount.bounded(5),
              b::Element(e::Situational, "Terms Type Code", b::Values("09","10","30")),
              b::Element(e::Situational, "Terms Basis Date Code", b::Values("AA","AB","AE","NS","OR","TB","TD","TP")),
              b::Element(e::Situational, "Terms Discount Percent"),
              b::Element(e::Situational, "Terms Discount Due Date"),
              b::Element(e::Situational, "Terms Discount Days Due"),
              b::Element(e::Situational, "Terms Net Due Date"),
              b::Element(e::Situational, "Terms Net Days"),
              b::Element(e::Situational, "Terms Discount Amount"),
              b::Element(e::Situational, "Terms Deferred Due Date"),
              b::Element(e::Situational, "Deferred Amount Due"),
              b::Element(e::Situational, "Percent of Invoice Payable"),
              b::Element(e::Situational, "Description - Freight FOB Terms"),
              b::Element(e::Situational, "Day of Month")),

            b::Segment(150, s::DTM, "Date/Time/Period",
              r::Situational, d::RepeatCount.bounded(2),
              b::Element(e::Required,    "Date/Time Qualifier", b::Values("007","036")),
              b::Element(e::Required,    "Date")),

            b::Segment(240, s::TD5, "Carrier Details (Routing Sequence/Transit Time)",
              r::Situational, d::RepeatCount.bounded(2),
              b::Element(e::Required,    "Transportation Method/Type Code", b::Values("A","AE","M","PG","R","RR","SE","SS")),
              b::Element(e::Required,    "Routing - Carrier's Name")),

            d::LoopDef.build("N9", d::RepeatCount.bounded(1),
              b::Segment(280, s:: N9, "Reference Number - Design Note Number",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Reference Number Qualifier", b::Values("C4")),
                b::Element(e::Situational, "Reference Number - Design Note Number"))),

            d::LoopDef.build("N9", d::RepeatCount.bounded(1),
              b::Segment(281, s:: N9, "Reference Number - Supplier Code",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Reference Number Qualifier", b::Values("VR")),
                b::Element(e::Situational, "Reference Number"))),

            d::LoopDef.build("N9", d::RepeatCount.bounded(1),
              b::Segment(282, s:: N9, "Reference Number - Business Type",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Reference Number Qualifier", b::Values("PG")),
                b::Element(e::Situational, "Reference Number - Business Type", b::Values("AC","AE","AS","BS","ER","ES","ET",
                                           "GW","IS","MP","MT","ND","NS","NT","PR","RB","RC","RP","SD","SN","SP","ST","UK","VP")))),

            d::LoopDef.build("N9", d::RepeatCount.bounded(1),
              b::Segment(283, s:: N9, "Reference Number",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Reference Number Qualifier", b::Values("CU")),
                b::Element(e::Situational, "Reference Number")),

              b::Segment(290, s::MSG, "Message Text",
                r::Situational, d::RepeatCount.bounded(1000),
                b::Element(e::Required,    "Free-Form Message Text"))),

            d::LoopDef.build("N1", d::RepeatCount.bounded(200),
              b::Segment(300, s::N1, "Name",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Entity Identifier Code", b::Values("BT","MP")),
                b::Element(e::Situational, "Name")),

              b::Segment(310, s::N2, "Additional Name Information",
                r::Situational, d::RepeatCount.bounded(2),
                b::Element(e::Required,    "Name"),
                b::Element(e::Situational, "Name")),

              b::Segment(320, s::N3, "Address Information",
                r::Situational, d::RepeatCount.bounded(2),
                b::Element(e::Required,    "Address Information"),
                b::Element(e::Situational, "Address Information")),

              b::Segment(330, s::N4, "Geographic Location",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "City Name"),
                b::Element(e::Situational, "State or Province Code"),
                b::Element(e::Situational, "Postal Code"),
                b::Element(e::NotUsed,     "Unknown")))),

          d::TableDef.detail("Detail",
            d::LoopDef.build("POC", d::RepeatCount.bounded(100000),
              b::Segment(10, s::POC, "Line Item Change",
                r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Situational, "Assigned Identification - Purchase Order Line Number"),
                b::Element(e::Required,    "Change or Response Type Code",b::Values("AI","CA","CB","CC","CD","NC","PC","QD","QI")),
                b::Element(e::Situational, "Quantity Ordered"),
                b::Element(e::Situational, "Quantity Left to Receive"),
                b::Element(e::Situational, "Unit or Basis for Measurement Code",b::Values("EA")),
                b::Element(e::Situational, "Unit Price"),
                b::Element(e::NotUsed,     "Unknown"),
                b::Element(e::Situational, "Product/Service ID Qualifier",b::Values("BP")),
                b::Element(e::Situational, "Product/Service ID - Nissan Part Number"),
                b::Element(e::Situational, "Product/Service ID Qualifier",b::Values("C4")),
                b::Element(e::Situational, "Product/Service ID - Design Note Number")),

              d::LoopDef.build("PID", d::RepeatCount.bounded(1),
                b::Segment( 50, s::PID, "Product/Item Description",
                  r::Situational, d::RepeatCount.bounded(1),
                  b::Element(e::Required,    "Item Description Type", b::Values("F")),
                  b::Element(e::NotUsed,     "Unknown"),
                  b::Element(e::NotUsed,     "Unknown"),
                  b::Element(e::NotUsed,     "Unknown"),
                  b::Element(e::Situational, "Description"))),

              d::LoopDef.build("N9", d::RepeatCount.bounded(1),
                b::Segment(320, s:: N9, "Reference Number - Clear Text Clause",
                  r::Situational, d::RepeatCount.bounded(1),
                  b::Element(e::Required,    "Reference Number Qualifier", b::Values("CU")),
                  b::Element(e::NotUsed,     "Unknown")),

                b::Segment(330, s::MSG, "Message Text",
                  r::Situational, d::RepeatCount.bounded(1000),
                  b::Element(e::Required,    "Free-Form Message Text"))))),

          d::TableDef.header("Summary",
            b::Segment(10, s::CTT, "Transaction Totals",
              r::Situational, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Number of Line Items")),
            b::Segment(30, s::SE, "Transaction Set Trailer",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Number of Included Segments"),
              b::Element(e::Required,    "Transaction Set Control Number"))))
      end
    end
  end
end
