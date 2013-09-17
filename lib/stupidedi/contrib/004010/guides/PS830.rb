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

        PS830 = b.build(t::PS830,
          d::TableDef.header("Header",
            b::Segment(10, s:: ST, "Transaction Set Header",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Transaction Set Identifier Code", b::Values("944")),
              b::Element(e::Required,    "Transaction Set Control Number")),

            b::Segment(20, s::W06, "Warehouse Shipment Identification",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Reporting Code", b::Values("F")),
              b::Element(e::Required,    "Depositor Order Number"),
              b::Element(e::Situational, "Date"),
              b::Element(e::Required,    "Shipment Identification Number"),
              b::Element(e::Situational, "Agent Shipment ID Number")),

            d::LoopDef.build("N1", d::RepeatCount.bounded(10),
              b::Segment(40, s:: N1, "Name",
                r::Situational, d::RepeatCount.bounded(2),
                b::Element(e::Required,    "Entity Identifier Code", b::Values("ST", "SF")),
                b::Element(e::Situational, "Name"),
                b::Element(e::Situational, "Identification Code Qualifier", b::Values("91")),
                b::Element(e::Situational, "Identification Code")),

              b::Segment(60, s:: N3, "Address Information",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Address Information"),
                b::Element(e::Situational, "Address Information")),

              b::Segment(70, s:: N4, "Geographic Location",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "City Name"),
                b::Element(e::Required,    "State Code"),
                b::Element(e::Situational, "Postal Code"))),

            b::Segment(90, s:: N9, "Reference Number",
              r::Situational, d::RepeatCount.bounded(10),
              b::Element(e::Required,    "Reference Identification Qualifier", b::Values("BR", "CO")),
              b::Element(e::Required,    "Reference Identification")),

            b::Segment(110, s::G62, "Date/Time Reference",
              r::Situational, d::RepeatCount.bounded(2),
              b::Element(e::Situational, "Date Qualifier"),
              b::Element(e::Situational, "Date"),
              b::Element(e::Situational, "Time Qualifier"),
              b::Element(e::Situational, "Time"),
              b::Element(e::Situational, "Time Code")),

            b::Segment(130, s::W27, "Carrier Detail",
              r::Situational, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Transportation Method/Type Code", b::Values("M", "R", "H", "LT")),
              b::Element(e::Situational, "Standard Carrier Alpha Code"),
              b::Element(e::Situational, "Routing"),
              b::Element(e::Situational, "Shipment Method of Payment", b::Values("CC", "PC", "PP", "PU", "TP")),
              b::Element(e::Situational, "Equipment Initial"),
              b::Element(e::Situational, "Equipment Number"))),

          d::TableDef.header("Detail",
            d::LoopDef.build("LX", d::RepeatCount.bounded(9999),
              b::Segment(5, s::LX, "Assigned Number",
                r::Required, d::RepeatCount.bounded(1))),
            d::LoopDef.build("W12", d::RepeatCount.bounded(9999),
              b::Segment(20, s::W12, "Item Detail For Stock Receipt",
                r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Mandatory,   "Shipment/Order Status Code"),
                b::Element(e::Situational, "Quantity Ordered"),
                b::Element(e::Situational, "Number of Units Shipped"),
                b::Element(e::Situational, "Quantity Difference"),
                b::Element(e::Situational, "Unit or Basis for Measurement Code", b::Values("CA", "LB", "EA")),
                b::Element(e::Situational, "UPC Case Code"),
                b::Element(e::Situational, "Product/Service ID Qualifier", b::Values("CB", "BP")),
                b::Element(e::Situational, "Product/Service ID"),
                b::Element(e::Situational, "Warehouse Lot Number"),
                b::Element(e::Situational, "Weight"),
                b::Element(e::Situational, "Weight Qualifier", b::Values("G")),
                b::Element(e::Situational, "Weight Unit Code", b::Values("K", "L")),
                b::Element(e::Situational, "Weight"),
                b::Element(e::Situational, "Weight Qualifier", b::Values("G")),
                b::Element(e::Situational, "Weight Unit Code", b::Values("K", "L")),
                b::Element(e::Situational, "Unused"),
                b::Element(e::Situational, "Product/Service ID Qualifier", b::Values("VN", "JP")),
                b::Element(e::Situational, "Product/Service ID"),
                b::Element(e::Situational, "Line Item Change Reason Code", b::Values("01", "02")),
                b::Element(e::Situational, "Unused"),
                b::Element(e::Situational, "Product/Service ID Qualifier", b::Values("ZZ", "UP")),
                b::Element(e::Situational, "Product/Service ID")),
              b::Segment(30, s::G69, "Line Item Detail - Description",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Mandatory,    "Free-form descriptive text")),
              b::Segment(40, s::N9, "Reference Identification",
                r::Situational, d::RepeatCount.bounded(200),
                b::Element(e::Mandatory,    "Reference Identification Qualifier"),
                b::Element(e::Situational,  "Reference Identification")))),

          d::TableDef.header("Summary",
            b::Segment(10, s::W03, "Total Shipment Information",
              r::Situational, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Number of Units Shipped")),
            b::Segment(30, s::SE, "Transaction Set Trailer",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Number of Included Segments"),
              b::Element(e::Required,    "Transaction Set Control Number"))))

      end
    end
  end
end

