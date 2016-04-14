# frozen_string_literal: true

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
        # Response to a Load Tender
        #
        FA997 = b.build(t::FA997,
          d::TableDef.header("Heading",
            b::Segment(10, s::ST, "Transaction Set Header",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Transaction Set Identifier Code"),
              b::Element(e::Required,    "Transaction Set Control Number")),

            b::Segment(20, s::AK1, "Functional Group Response Header",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Situational, "Functional Identifier Code"),
              b::Element(e::Required,    "Group Control Number")),

            d::LoopDef.build("AK2", d::RepeatCount.bounded(999999),
              b::Segment(30, s::AK2, "Transaction Set Response Header",
                r::Situational, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Transaction Set Identifier Code"),
                b::Element(e::Required,    "Transaction Set Control Number")),

              d::LoopDef.build("AK3", d::RepeatCount.bounded(999999),
                b::Segment( 40, s::AK3, "Data Segment Note",
                  r::Situational, d::RepeatCount.bounded(1),
                  b::Element(e::Required,    "Segment ID Code"),
                  b::Element(e::Required,    "Segment Position in Transaction Set"),
                  b::Element(e::Situational, "Loop Identifier Code"),
                  b::Element(e::Situational, "Segment Syntax Error Code")),

                b::Segment( 50, s::AK4, "Data Element Note",
                  r::Situational, d::RepeatCount.bounded(99),
                  b::Element(e::Required,    "Position in Segment",
                      b::Element(e::Required,    "Element Position in Segment"),
                      b::Element(e::Situational, "Component Data Element Position in Composite")),
                  b::Element(e::Situational, "Data Element Reference Number"),
                  b::Element(e::Required,    "Data Element Syntax Error Code"),
                  b::Element(e::Situational, "Copy of Bad Data Element"))),

              b::Segment( 60, s::AK5, "Transaction Set Response Trailer",
                r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Transaction Set Acknowledgment Code"),
                b::Element(e::Situational, "Transaction Set Syntax Error Code"),
                b::Element(e::Situational, "Transaction Set Syntax Error Code"),
                b::Element(e::Situational, "Transaction Set Syntax Error Code"),
                b::Element(e::Situational, "Transaction Set Syntax Error Code"),
                b::Element(e::Situational, "Transaction Set Syntax Error Code"))),

            b::Segment( 70, s::AK9, "Functional Group Response Trailer",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Functional Group Acknowledge Code"),
              b::Element(e::Required,    "Number of Transaction Sets Included"),
              b::Element(e::Required,    "Number of Received Transaction Sets"),
              b::Element(e::Required,    "Number of Accepted Transaction Sets"),
              b::Element(e::Situational, "Functional Group Syntax Error Code"),
              b::Element(e::Situational, "Functional Group Syntax Error Code"),
              b::Element(e::Situational, "Functional Group Syntax Error Code"),
              b::Element(e::Situational, "Functional Group Syntax Error Code"),
              b::Element(e::Situational, "Functional Group Syntax Error Code")),

            b::Segment( 80, s::SE, "Transaction Set Trailer",
              r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Number of Included Segments"),
              b::Element(e::Required,    "Transaction Set Control Number"))))

      end
    end
  end
end
