module Stupidedi
  module Contrib
    module TwoThousandOne
      module Guides

        b = GuideBuilder
        d = Schema
        r = SegmentReqs
        e = ElementReqs
        s = Versions::FunctionalGroups::FortyTen::SegmentDefs
        # t = Contrib::TwoThousandOne::TransactionSetDefs
        t = Contrib::FortyTen::TransactionSetDefs
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
              r::Situational, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Reference Number Qualifier", b::Values("R2")),
              b::Element(e::Required,    "Reference Number"), b::Values("CPICS","ERS","NLC")),
            b::Segment(60, s::DTM, "Date/Time/Period",
              r::Situational, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Date/Time Qualifier", b::Values("195")),
              b::Element(e::Required,    "Date"),
            d::LoopDef.build("N1", d::RepeatCount.bounded(1),              
              b::Segment(70, s:: N1, "Name",
                r::Situational, d::RepeatCount.unbounded,
                b::Element(e::Required,    "Entity Identifier Code", b::Values("SU")),
                b::Element(e::Situational, "Name - Supplier Contact")),



          d::TableDef.detail("Detail",            
            d::LoopDef.build("LS", d::RepeatCount.bounded(1),              
              b::Segment(10, s:: LS, "Loop Header",
                r::Situational, d::RepeatCount.unbounded,
                b::Element(e::Required,    "Loop Identifier Code", b::Values("A"))),

              d::LoopDef.build("N1", d::RepeatCount.bounded(200),
                b::Segment( 20, s:: N1, "Name - Invoice Number/Check Number/Bill of Lading Number - Header",
                  r::Situational, d::RepeatCount.bounded(1),
                  b::Element(e::Required,    "Entity Identifier Code", b::Values("HH")),
                  b::Element(e::Conditional, "Name - Header Reference Number")),

                d::LoopDef.build("RMT", d::RepeatCount.bounded(200),   
                  b::Segment( 50, s::RMT, "Remittance Advice",
                    r::Situational, d::RepeatCount.bounded(1),
                    b::Element(e::Required,    "Reference Number Qualifier"),
                    b::Element(e::Situational, "Reference Number"),
                    b::Element(e::Situational, "Monetary Amount - Total Gross Amount"),
                    b::Element(e::Situational, "Total Invoice Amount - Total Net Amount"),
                    b::Element(e::Situational, "Amount of Discount Taken - Discount Amount Due")),

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
                    r::Situational, d::RepeatCount.bounded(1),
                    b::Element(e::Required,    "Reference Number Qualifier", b::Values("CU")),
                    b::Element(e::Situational, "Description - Debit/Credit Memo Description")),

                  b::Segment( 60, s::DTM, "Date/Time/Period",
                    r::Situational, d::RepeatCount.bounded(1),
                    b::Element(e::Required,    "Date/Time Qualifier", b::Values("011","193")),
                    b::Element(e::Situational, "Date - Invoice Date"))),


            d::LoopDef.build("N1", d::RepeatCount.bounded(200),
              b::Segment( 21, s:: N1, "Name - DM/CM Supplier Authorizer",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Entity Identifier Code", b::Values("AA")),
                b::Element(e::Situational, "Name - Supplier Authorizer"))),

            d::LoopDef.build("N1", d::RepeatCount.bounded(200),
              b::Segment( 22, s:: N1, "Name - DM/CM Nissan Contact",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Entity Identifier Code", b::Values("PJ")),
                b::Element(e::Situational, "Name - Nissan Contact"))),

            d::LoopDef.build("N1", d::RepeatCount.bounded(200),
              b::Segment( 22, s:: N1, "Name - Invoice Number/Check Number/Bill of Lading Number - Line Item",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Entity Identifier Code", b::Values("LI")),
                b::Element(e::Situational, "Name - Invoice Number/Check Number/Bill of Lading"))),

              d::LoopDef.build("RMT", d::RepeatCount.bounded(200),
                b::Segment( 30, s::RMT, "Remittance Advice",
                  r::Situational, d::RepeatCount.bounded(1),
                  b::Element(e::Required,    "Reference Number Qualifier", b::Values("IX")),
                  b::Element(e::Situational, "Reference Number - Item/Part Number"),
                  b::Element(e::Situational, "Monetary Amount - Unit Price"),
                  b::Element(e::Situational, "Total Invoice Amount - Extended Price"),
                  b::Element(e::Situational, "Adjustment Reason Code - Reprice Indicator", b::Values("NO","YS")),
                  b::Element(e::Situational, "Description - Original Invoice Number")),





              b::Segment( 60, s::LIN, "Item Identification",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Product/Service ID Qualifier", b::Values("BP")),
                b::Element(e::Situational, "Product/Service ID - Nissan Part Number"),
                b::Element(e::Situational, "Product/Service ID Qualifier", b::Values("ON")),
                b::Element(e::Situational, "Product/Service ID - Receipt Authorization Number (RAN)"),
                b::Element(e::Situational, "Product/Service ID Qualifier", b::Values("SN")),
                b::Element(e::Situational, "Product/Service ID - Coil Number")),
              b::Segment( 80, s::SN1, "Item Detail (Shipment)",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Number of Units Shipped"),
                b::Element(e::Situational, "Unit or Basis for Measurement Code")),
              b::Segment(110, s::PO4, "Item Physical Details",
                r::Situational, d::RepeatCount.unbounded,
                b::Element(e::Situational, "Pack"),
                b::Element(e::Situational, "Size"),
                b::Element(e::Situational, "Unit or Basis for Measurement Code")),
              b::Segment(200, s::REF, "Reference Identification",
                r::Situational, d::RepeatCount.bounded(12),
                b::Element(e::Required,    "Reference Identification Qualifier", b::Values("DP")),
                b::Element(e::Situational, "Reference Identification")))),


            d::LoopDef.build("HL", d::RepeatCount.bounded(200),
              b::Segment( 50, s:: HL, "Hierarchical Level -Pack Level",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Hierarchical ID Number"),
                b::Element(e::Situational, "Hierarchical Parent ID Number"),
                b::Element(e::Situational, "Hierarchical Level Code", b::Values("P")),
                b::Element(e::Situational, "Hierarchical Child Code", b::Values("0")),
              b::Segment( 80, s::SN1, "Item Detail (Shipment)",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required, "Number of Units Shipped"),
                b::Element(e::Required, "Unit or Basis for Measurement Code"),
              b::Segment(200, s::REF, "Reference Numbers",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Reference Number Qualifier", b::Values("LS")),
                b::Element(e::Situational, "Reference Number - Label Serial Number."),             

          d::TableDef.header("Summary",
            d::LoopDef.build("CTT", d::RepeatCount.bounded(1),
              b::Segment(380, s::CTT, "Transaction Totals",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Number of Line Items"),
                b::Element(e::Situational, "Hash Total"))),
            b::Segment(390, s:: SE, "Transaction Set Trailer",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Number of Included Segments"),
              b::Element(e::Required,    "Transaction Set Control Number")))))

      end
    end
  end
end
