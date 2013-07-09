module Stupidedi
  module Contrib
    module TwoThousandOne
      module Guides

        b = GuideBuilder
        d = Schema
        r = SegmentReqs
        e = ElementReqs
        s = Versions::FunctionalGroups::TwoThousandOne::SegmentDefs
        t = Contrib::TwoThousandOne::TransactionSetDefs

        #
        # Ship Notice/Manifest
        #
        SH856 = b.build(t::SH856,
          d::TableDef.header("Heading",
            b::Segment(10, s:: ST, "Transaction Set Header",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Transaction Set Identifier Code", b::Values("856")),
              b::Element(e::Required,    "Transaction Set Control Number")),

            b::Segment(20, s::BSN, "Beginning Segment for Ship Notice",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Transaction Set Purpose Code", b::Values("00")),
              b::Element(e::Required,    "Shipment Identification"),
              b::Element(e::Required,    "Category - Ship Notice Date"),
              b::Element(e::Situational, "Subcategory - Ship Notice Time")),
            b::Segment(40, s::DTM, "Date/Time/Period",
              r::Situational, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Entity Identifier Code", b::Values("BT","BY","CN","SH","SF","ST"),
              b::Element(e::Required,    "Currency Code")),
            
            d::LoopDef.build("HL", d::RepeatCount.bounded(1),              
              b::Segment(50, s:: HL, "Hierarchical Level - Shipment Level",
                r::Situational, d::RepeatCount.unbounded,
                b::Element(e::Required,    "Reference Identification Qualifier", b::Values("ZZ", "OS")),
                b::Element(e::Situational, "Reference Identification")),
              b::Segment(130, s::MEA, "Measurements",
                r::Situational, d::RepeatCount.bounded(3),
                b::Element(e::Required,    "Contact Function Code", b::Values("BD")),
                b::Element(e::Situational, "Name"),
                b::Element(e::Situational, "Communication Number Qualifier", b::Values("TE")),
                b::Element(e::Situational, "Communication Number")),
              b::Segment(150, s::TD1, "Carrier Details (Quantity and Weight)",
                r::Situational, d::RepeatCount.bounded(10),
                b::Element(e::Required,    "Date/Time Qualifier", b::Values("002")),
                b::Element(e::Situational, "Date")),
              b::Segment(180, s::TD3, "Carrier Details (Equipment)",
                r::Situational, d::RepeatCount.bounded(10),
                b::Element(e::Required,    "Date/Time Qualifier", b::Values("002")),
                b::Element(e::Situational, "Date")),
              b::Segment(200, s::REF, "Reference Numbers",
                r::Situational, d::RepeatCount.bounded(10),
                b::Element(e::Required,    "Date/Time Qualifier", b::Values("002")),
                b::Element(e::Situational, "Date")),

            d::LoopDef.build("N1", d::RepeatCount.bounded(200),
              b::Segment(270, s:: N1, "Name -Supplier",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Entity Identifier Code", b::Values("SU")),
                b::Element(e::Conditional, "Name - Supplier Name"),
                b::Element(e::Conditional, "Identification Code Qualifier", b::Values("92")),
                b::Element(e::Conditional, "Identification Code - Supplier Code")),

            d::LoopDef.build("HL", d::RepeatCount.bounded(200),
              b::Segment( 50, s:: HL, "Hierarchical Level - Tare Level",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Hierarchical ID Number"),
                b::Element(e::Situational, "Hierarchical Parent ID Number"),
                b::Element(e::Situational, "Hierarchical Level Code", b::Values("T")),
                b::Element(e::Situational, "Hierarchical Child Code", b::Values("0","1"))),

            d::LoopDef.build("HL", d::RepeatCount.bounded(200),
              b::Segment( 200, s::REF, "Reference Numbers",
                r::Situational, d::RepeatCount.bounded(200),
                b::Element(e::Required,    "Reference Number Qualifier"),
                b::Element(e::Situational, "Reference Number - Mixed or Master Label Serial Number", b::Values("4S","5S","M","G","S"))),

            d::LoopDef.build("HL", d::RepeatCount.bounded(200),
              b::Segment( 50, s:: HL, "Hierarchical Level - Item Level",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Hierarchical ID Number"),
                b::Element(e::Situational, "Hierarchical Parent ID Number"),
                b::Element(e::Situational, "Hierarchical Level Code", b::Values("T")),
                b::Element(e::Situational, "Hierarchical Child Code", b::Values("0","1"))),

            d::LoopDef.build("HL", d::RepeatCount.bounded(200),
              b::Segment( 60, s::LIN, "Item Identification",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Product/Service ID Qualifier"),
                b::Element(e::Situational, "Product/Service ID - Nissan Part Number"),
                b::Element(e::Situational, "Product/Service ID Qualifier", b::Values("ON")),
                b::Element(e::Situational, "Product/Service ID - Receipt Authorization Number (RAN)"),
                b::Element(e::Situational, "Product/Service ID Qualifier"),
                b::Element(e::Situational, "Product/Service ID - Coil Number")),

              b::Segment(330, s:: N3, "Address Information",
                r::Situational, d::RepeatCount.bounded(2),
                b::Element(e::Required,    "Address Information"),
                b::Element(e::Situational, "Address Information")),
              b::Segment(340, s:: N4, "Geographic Location",
                r::Situational, d::RepeatCount.unbounded,
                b::Element(e::Situational, "City Name"),
                b::Element(e::Situational, "State or Province Code"),
                b::Element(e::Situational, "Postal Code"),
                b::Element(e::Situational, "Country Code")),
              b::Segment(350, s::REF, "Reference Identification",
                r::Situational, d::RepeatCount.bounded(12),
                b::Element(e::Required,    "Reference Identification Qualifier", b::Values("DP")),
                b::Element(e::Situational, "Reference Identification")))),

          d::TableDef.header("Detail",
            d::LoopDef.build("PO1", d::RepeatCount.bounded(100000),
              b::Segment(10, s::PO1, "Baseline Item Data",
                r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Situational, "Assigned Identification"),
                b::Element(e::Situational, "Quantity Ordered"),
                b::Element(e::Situational, "Unit or Basis for Measurement Code", b::Values("CA", "EA", "LB")),
                b::Element(e::Situational, "Unit Price"),
                b::Element(e::Situational, "Basis of Unit Price Code", b::values("PE","PP","UM")),
                b::Element(e::Situational, "Product/Service ID Qualifier", b::Values("VN", "VC")),
                b::Element(e::Situational, "Product/Service ID"))),
            d::LoopDef.build("PID", d::RepeatCount.bounded(1000),
              b::Segment(50, s::PID, "Product/Item Description",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Item Description Type", b::Values("F")),
                b::Element(e::Situational, "Product/Process Characteristic Code"),
                b::Element(e::Situational, "Agency Qualifier Code"),
                b::Element(e::Situational, "Product Description Code"),
                b::Element(e::Situational, "Description")))),

          d::TableDef.header("Summary",
            d::LoopDef.build("CTT", d::RepeatCount.bounded(1),
              b::Segment(10, s::CTT, "Transaction Totals",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Number of Line Items"),
                b::Element(e::Situational, "Hash Total"))),
            b::Segment(30, s:: SE, "Transaction Set Trailer",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Number of Included Segments"),
              b::Element(e::Required,    "Transaction Set Control Number")))))

      end
    end
  end
end
