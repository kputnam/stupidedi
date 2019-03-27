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

        QM214 = b.build("QM", "214", "Transportation Carrier Shipment Status Message",
          d::TableDef.header("Heading",
            b::Segment(10, s::ST, "Transaction Set Header", r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Transaction Set Identifier Code", b::Values("214")),
              b::Element(e::Required,    "Transaction Set Control Number")),
            b::Segment(20, s::B10, "Beginning Segment for Transportation Carrier Shipment Status Message", r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Reference Identification"),
              b::Element(e::Required,    "Shipment Identification Number"),
              b::Element(e::Required,    "Standard Carrier Alpha Code"),
              b::Element(e::NotUsed,     "Inquiry Request Number"),
              b::Element(e::NotUsed,     "Reference Identification Qualifier"),
              b::Element(e::NotUsed,     "Reference Identification"),
              b::Element(e::NotUsed,     "Yes/No Condition or Response Code")),
            b::Segment(30, s::L11, "Business Instruction and Reference Number", r::Situational, d::RepeatCount.bounded(300),
              b::Element(e::Situational, "Reference Identification"),
              b::Element(e::Situational, "Reference Identification Qualifier"),
              b::Element(e::Situational, "Description")),

            d::LoopDef.build("0100", d::RepeatCount.bounded(10),
              b::Segment(50, s::N1, "Name", r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Entity Identifier Code"),
                b::Element(e::Required,    "Name"),
                b::Element(e::Situational, "Identification Code Qualifier"),
                b::Element(e::Situational, "Identification Code"),
                b::Element(e::Situational, "Entity Relation Code"),
                b::Element(e::Situational, "Entity Identifier Code")),
              b::Segment(70, s::N3, "Address Information", r::Situational, d::RepeatCount.bounded(2),
                b::Element(e::Situational, "Address Information"),
                b::Element(e::Situational, "Address Information")),
              b::Segment(80, s::N4, "Geographic Information", r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Situational, "City Name"),
                b::Element(e::Situational, "State or Province Code"),
                b::Element(e::Situational, "Postal Code"),
                b::Element(e::Situational, "Country Code"),
                b::Element(e::Situational, "Location Qualifier"),
                b::Element(e::Situational, "Location Identifier"))),


            d::LoopDef.build("0150", d::RepeatCount.bounded(12),
              b::Segment(120, s::MS3, "Interline Information", r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Standard Carrier Alpha Code"),
                b::Element(e::Situational, "Routing Sequence Code"),
                b::Element(e::NotUsed,     "City Name"),
                b::Element(e::Required,    "Transportation Method/Type Code"),
                b::Element(e::NotUsed,     "State or Province Code"))),

            d::LoopDef.build("0200", d::RepeatCount.bounded(999999),
              b::Segment(130, s::LX, "Assigned Number", r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Assigned Number")),

              d::LoopDef.build("0205", d::RepeatCount.bounded(10),
                b::Segment(140, s::AT7, "Shipment Status Details", r::Required, d::RepeatCount.bounded(1),
                  b::Element(e::Situational, "Shipment Status Code"),
                  b::Element(e::Situational, "Shipment Status or Appointment Reason Code"),
                  b::Element(e::Situational, "Shipment Appointment Status Code"),
                  b::Element(e::Situational, "Shipment Status or Appointment Reason Code"),
                  b::Element(e::Situational, "Date"),
                  b::Element(e::Situational, "Time"),
                  b::Element(e::Situational, "Time Code")),
                b::Segment(143, s::MS1, "Equipment, Shipment or Real Property Location", r::Situational, d::RepeatCount.bounded(1),
                  b::Element(e::Situational, "City Name"),
                  b::Element(e::Situational, "State or Province Code"),
                  b::Element(e::Situational, "Country Code"),
                  b::Element(e::Situational, "Longitude Code"),
                  b::Element(e::Situational, "Latitude Code"),
                  b::Element(e::Situational, "Direction Identifier Code"),
                  b::Element(e::Situational, "Direction Identifier Code"),
                  b::Element(e::Situational, "Postal Code")),
                b::Segment(146, s::MS2, "Equipment or Container Owner and Type", r::Situational, d::RepeatCount.bounded(1),
                  b::Element(e::Situational, "Standard Carrier Alpha Code"),
                  b::Element(e::Situational, "Equipment Number"),
                  b::Element(e::Situational, "Equipment Description Code"),
                  b::Element(e::Situational, "Equipment Number Check Digit"))),

              b::Segment(150, s::L11, "Business Instructions and Reference Number", r::Situational, d::RepeatCount.bounded(10),
                b::Element(e::Situational, "Reference Identification"),
                b::Element(e::Required,    "Reference Identification Qualifier"),
                b::Element(e::Situational, "Description")),
              b::Segment(200, s::AT8, "Shipment Weight, Packaging and Quantity Data", r::Situational, d::RepeatCount.bounded(10),
                b::Element(e::Required,    "Weight Qualifier"),
                b::Element(e::Required,    "Weight Unit Code"),
                b::Element(e::Required,    "Weight"),
                b::Element(e::Required,    "Lading Quantity"),
                b::Element(e::Situational, "Lading Quantity"),
                b::Element(e::Situational, "Volume Unit Qualifier"),
                b::Element(e::Situational, "Volume"))),

            b::Segment(610, s::SE, "Transaction Set Trailer", r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Situational, "Number of Included Segments"),
              b::Element(e::Situational, "Transaction Set Control Number"))))

      end
    end
  end
end
