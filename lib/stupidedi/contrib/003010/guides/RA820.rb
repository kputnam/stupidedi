module Stupidedi
  module Contrib
    module ThirtyTen
      module Guides

        b = GuideBuilder
        d = Schema
        r = SegmentReqs
        e = ElementReqs
        s = Versions::FunctionalGroups::ThirtyTen::SegmentDefs
        # t = Contrib::TwoThousandOne::TransactionSetDefs
        t = Contrib::ThirtyTen::TransactionSetDefs
        #
        # Ship Notice/Manifest
        #
        RA820 = b.build(t::RA820,
          d::TableDef.header("Heading",
            b::Segment(10, s:: ST, "Transaction Set Header",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Transaction Set Identifier Code", b::Values("820")),
              b::Element(e::Required,    "Transaction Set Control Number")),
            b::Segment(20, s::BPS, "Beginning Segment for Payment Order/Remittance Advice",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Payment Method Code", b::Values("PBC")),
              b::Element(e::Required,    "Monetary Amount"),
              b::Element(e::Required,    "Transaction Handling Code", b::Values("I")),
              b::Element(e::Situational, "Account Number - Supplier Number"),
              b::Element(e::Situational, "Effective Entry Date - Issue Date")),
            b::Segment(50, s::REF, "Reference Numbers",
              r::Situational, d::RepeatCount.bounded(5),
              b::Element(e::Required,    "Reference Number Qualifier", b::Values("R2")),
              b::Element(e::Situational, "Reference Number", b::Values("CPICS","ERS","NLC"))),
            b::Segment(60, s::DTM, "Date/Time/Period",
              r::Situational, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Date/Time Qualifier", b::Values("195")),
              b::Element(e::Required,    "Date")),
            d::LoopDef.build("N1", d::RepeatCount.bounded(1),              
              b::Segment(70, s:: N1, "Name",
                r::Situational, d::RepeatCount.unbounded,
                b::Element(e::Required,    "Entity Identifier Code", b::Values("SU")),
                b::Element(e::Situational, "Name - Supplier Contact")))),


          d::TableDef.detail("Detail",            
            d::LoopDef.build("LS", d::RepeatCount.bounded(1),              
              b::Segment(10, s:: LS, "Loop Header",
                r::Required, d::RepeatCount.unbounded,
                b::Element(e::Required,    "Loop Identifier Code", b::Values("A"))),

              d::LoopDef.build("N1", d::RepeatCount.bounded(10000),
                b::Segment( 20, s:: N1, "Name - Invoice Number/Check Number/Bill of Lading Number - Header",
                  r::Required, d::RepeatCount.bounded(1),
                  b::Element(e::Required,    "Entity Identifier Code", b::Values("HH")),
                  b::Element(e::Situational, "Name - Header Reference Number")),

                d::LoopDef.build("RMT", d::RepeatCount.bounded(999999),   
                  b::Segment( 30, s::RMT, "Remittance Advice",
                    r::Situational, d::RepeatCount.bounded(1),
                    b::Element(e::Required,    "Reference Number Qualifier"),
                    b::Element(e::Required,    "Reference Number"),
                    b::Element(e::Situational, "Monetary Amount - Total Gross Amount"),
                    b::Element(e::Situational, "Total Invoice Amount - Total Net Amount"),
                    b::Element(e::NotUsed, "Unknown"),
                    b::Element(e::NotUsed, "Unknown"),
                    b::Element(e::Situational, "Amount of Discount Taken - Discount Amount Due"),
                    b::Element(e::NotUsed, "Unknown"),
                    b::Element(e::NotUsed, "Unknown"),
                    b::Element(e::NotUsed, "Unknown")),

                  b::Segment( 50, s::REF, "Reference Numbers - AETC Number",
                    r::Situational, d::RepeatCount.bounded(1),
                    b::Element(e::Required,    "Reference Number Qualifier", b::Values("AE")),
                    b::Element(e::Situational, "Reference Number - AETC Number")),

                  b::Segment( 51, s::REF, "Reference Numbers - Purchase Order Number",
                    r::Situational, d::RepeatCount.bounded(1),
                    b::Element(e::Required,    "Reference Number Qualifier", b::Values("PO")),
                    b::Element(e::Situational, "Reference Number - Purchase Order Number")),

                  b::Segment( 52, s::REF, "Reference Numbers - Shipper Number",
                    r::Situational, d::RepeatCount.bounded(1),
                    b::Element(e::Required,    "Reference Number Qualifier", b::Values("SI")),
                    b::Element(e::Situational, "Reference Number - Shipper Number")),

                  b::Segment( 53, s::REF, "Reference Numbers - Debit/Credit Memo Description",
                    r::Situational, d::RepeatCount.bounded(12),
                    b::Element(e::Required,    "Reference Number Qualifier", b::Values("CU")),
                    b::Element(e::Situational, "Description - Debit/Credit Memo Description")),

                  b::Segment( 60, s::DTM, "Date/Time/Period",
                    r::Situational, d::RepeatCount.bounded(10),
                    b::Element(e::Required,    "Date/Time Qualifier", b::Values("011","193")),
                    b::Element(e::Situational, "Date - Invoice Date"))))),


            d::LoopDef.build("N1", d::RepeatCount.bounded(10000),
              b::Segment( 21, s:: N1, "Name - DM/CM Supplier Authorizer",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Entity Identifier Code", b::Values("AA")),
                b::Element(e::Situational, "Name - Supplier Authorizer"))),

            d::LoopDef.build("N1", d::RepeatCount.bounded(10000),
              b::Segment( 22, s:: N1, "Name - DM/CM Nissan Contact",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Entity Identifier Code", b::Values("PJ")),
                b::Element(e::Situational, "Name - Nissan Contact"))),

            d::LoopDef.build("N1", d::RepeatCount.bounded(10000),
              b::Segment( 22, s:: N1, "Name - Invoice Number/Check Number/Bill of Lading Number - Line Item",
                r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Entity Identifier Code", b::Values("LI")),
                b::Element(e::Situational, "Name - Invoice Number/Check Number/Bill of Lading")),

              d::LoopDef.build("RMT", d::RepeatCount.bounded(999999),
                b::Segment( 30, s::RMT, "Remittance Advice",
                  r::Situational, d::RepeatCount.bounded(1),
                  b::Element(e::Required,    "Reference Number Qualifier", b::Values("IX")),
                  b::Element(e::Required,    "Reference Number - Item/Part Number"),
                  b::Element(e::Situational, "Monetary Amount - Unit Price"),
                  b::Element(e::Situational, "Total Invoice Amount - Extended Price"),
                  b::Element(e::NotUsed, "Unknown"),
                  b::Element(e::NotUsed, "Unknown"),
                  b::Element(e::NotUsed, "Unknown"),
                  b::Element(e::NotUsed, "Unknown"),                 
                  b::Element(e::Situational, "Adjustment Reason Code - Reprice Indicator", b::Values("NO","YS")),
                  b::Element(e::Situational, "Description - Original Invoice Number")),
                b::Segment( 50, s::REF, "Reference Numbers - Quantity of Item",
                  r::Situational, d::RepeatCount.bounded(1),
                  b::Element(e::Required,    "Reference Number Qualifier", b::Values("QI")),
                  b::Element(e::Situational, "Reference Number - Quantity of Item")),
                b::Segment( 50, s::REF, "Reference Numbers - Purchase Order Number",
                  r::Situational, d::RepeatCount.bounded(1),
                  b::Element(e::Required,    "Reference Number Qualifier", b::Values("PO")),
                  b::Element(e::Situational, "Reference Number - Purchase Order Number")),
                b::Segment( 50, s::REF, "Reference Numbers - Release Number (RAN)",
                  r::Situational, d::RepeatCount.bounded(15),
                  b::Element(e::Required,    "Reference Number Qualifier", b::Values("RE")),
                  b::Element(e::Situational, "Reference Number - Release Number (RAN)")),
                b::Segment( 50, s::REF, "Reference Numbers - Coil ID/PDSN",
                  r::Situational, d::RepeatCount.bounded(15),
                  b::Element(e::Required,    "Reference Number Qualifier", b::Values("PM")),
                  b::Element(e::Situational, "Reference Number - Coil ID/PDSN")),
                b::Segment( 50, s::REF, "Reference Numbers - Supplier Unit of Measurement",
                  r::Situational, d::RepeatCount.bounded(15),
                  b::Element(e::Required,    "Reference Number Qualifier", b::Values("UM")),
                  b::Element(e::Situational, "Reference Number - Supplier Unit of Measurement")),
                b::Segment( 70, s:: LE, "Loop Trailer",
                  r::Situational, d::RepeatCount.bounded(1),
                  b::Element(e::Required,    "Loop Identifier Code", b::Values("A")))),

              b::Segment(200, s::REF, "Reference Numbers",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Reference Number Qualifier", b::Values("LS")),
                b::Element(e::Situational, "Reference Number - Label Serial Number.")))),             

          d::TableDef.header("Summary",
            d::LoopDef.build(" SE", d::RepeatCount.bounded(1),
            b::Segment( 10, s:: SE, "Transaction Set Trailer",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Number of Included Segments"),
              b::Element(e::Required,    "Transaction Set Control Number")))))

      end
    end
  end
end
