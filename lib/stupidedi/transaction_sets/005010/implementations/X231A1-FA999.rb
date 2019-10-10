# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module FiftyTen
      module Implementations
        module X231A1
          b = Builder
          d = Schema
          r = SegmentReqs
          e = ElementReqs
          s = SegmentDefs

          FA999 = b.build("FA", "999", "",
            d::TableDef.header("1 - Header",
              b::Segment(100, s::ST, "Transaction Set Header", r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Transaction Set Identifier Code", b::Values("999")),
                b::Element(e::Required,    "Transaction Set Control Number"),
                b::Element(e::Required,    "Implementation Guide Version Name", b::Values("005010X231A1"))),
              b::Segment(200, s::AK1, "Functional Group Response Header", r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Functional Identifier Code"),
                b::Element(e::Required,    "Group Control Number"),
                b::Element(e::Required,    "Version, Release, or Industry Identifier Code")),

              d::LoopDef.build("2000 TRANSACTION SET RESPONSE HEADER", d::RepeatCount.unbounded,
                b::Segment(300, s::AK2, "Transaction Set Response Header", r::Situational, d::RepeatCount.bounded(1),
                  b::Element(e::Required,    "Transaction Set Identifier Code"),
                  b::Element(e::Required,    "Transaction Set Control Number"),
                  b::Element(e::Situational, "Implementation Convention Reference")),

                d::LoopDef.build("2100 ERROR IDENTIFICATION", d::RepeatCount.unbounded,
                  b::Segment(400, s::IK3, "Error Identification", r::Situational, d::RepeatCount.bounded(1),
                    b::Element(e::Required,    "Segment ID Code"),
                    b::Element(e::Required,    "Segment Position in Transaction Set"),
                    b::Element(e::Situational, "Loop Identifier Code"),
                    b::Element(e::Required,    "Implementation Segment Syntax Error Code", b::Values("1", "2", "3", "4", "5", "6", "7", "8", "I4", "I6", "I7", "I8", "I9"))),
                  b::Segment(500, s::CTX, "Segment Context", r::Situational, d::RepeatCount.bounded(9),
                    b::Element(e::Required,    "CONTEXT IDENTIFICATION",
                      b::Element(e::Required,    "Context Name", b::Values("SITUATIONAL TRIGGER")),
                      b::Element(e::NotUsed,     "Context Reference")),
                    b::Element(e::Required,    "Segment ID Code"),
                    b::Element(e::Required,    "Segment Position in Transaction Set"),
                    b::Element(e::Situational, "Loop Identifier Code"),
                    b::Element(e::Situational, "POSITION IN SEGMENT",
                      b::Element(e::Required,    "Element Position in Segment"),
                      b::Element(e::Situational, "Component Data Element Position in Composite"),
                      b::Element(e::Situational, "Repeating Data Element Position")),
                    b::Element(e::NotUsed,     "REFERENCE IN SEGMENT")),
                  b::Segment(500, s::CTX, "Business Unit Identifier", r::Situational, d::RepeatCount.bounded(1),
                    b::Element(e::Required,    "CONTEXT IDENTIFICATION",
                      b::Element(e::Required,    "Context Name", b::Values("TRN02", "NM109", "PATIENT NAME NM109", "SUBSCRIBER NAME NM109", "ENT01", "SUBSCRIBER NUMBER REF02", "CLM01")),
                      b::Element(e::Required,    "Context Reference")),
                    b::Element(e::NotUsed,     "Segment ID Code"),
                    b::Element(e::NotUsed,     "Segment Position in Transaction Set"),
                    b::Element(e::NotUsed,     "Loop Identifier Code"),
                    b::Element(e::NotUsed,     "POSITION IN SEGMENT"),
                    b::Element(e::NotUsed,     "REFERENCE IN SEGMENT")),

                  d::LoopDef.build("2110 IMPLEMENTATION DATA ELEMENT NOTE", d::RepeatCount.unbounded,
                    b::Segment(600, s::IK4, "Implementation Data Element Note", r::Situational, d::RepeatCount.bounded(1),
                      b::Element(e::Required,    "POSITION IN SEGMENT",
                        b::Element(e::Required,    "Element Position in Segment"),
                        b::Element(e::Situational, "Component Data Element Position in Composite"),
                        b::Element(e::Situational, "Repeating Data Element Position")),
                      b::Element(e::Situational, "Data Element Reference Number"),
                      b::Element(e::Required,    "Implementation Data Element Syntax Error Code", b::Values("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "12", "13", "I10", "I11", "I12", "I13", "I6", "I9")),
                      b::Element(e::Situational, "Copy of Bad Data Element")),
                    b::Segment(700, s::CTX, "Element Context", r::Situational, d::RepeatCount.bounded(10),
                      b::Element(e::Required,    "CONTEXT IDENTIFICATION",
                        b::Element(e::Required,    "Context Name", b::Values("SITUATIONAL TRIGGER")),
                        b::Element(e::NotUsed,     "Context Reference")),
                      b::Element(e::Required,    "Segment ID Code"),
                      b::Element(e::Required,    "Segment Position in Transaction Set"),
                      b::Element(e::Situational, "Loop Identifier Code"),
                      b::Element(e::Situational, "POSITION IN SEGMENT",
                        b::Element(e::Required,    "Element Position in Segment"),
                        b::Element(e::Situational, "Component Data Element Position in Composite"),
                        b::Element(e::Situational, "Repeating Data Element Position")),
                      b::Element(e::NotUsed,     "REFERENCE IN SEGMENT")))),

                b::Segment(800, s::IK5, "Implementation Transaction Set Response Trailer", r::Required, d::RepeatCount.bounded(1),
                  b::Element(e::Required,    "Transaction Set Acknowledgement Code", b::Values("A", "E", "M", "R", "W", "X")),
                  b::Element(e::Situational, "Implementation Transaction Set Syntax Error Code", b::Values("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "15", "16", "17", "18", "19", "23", "24", "25", "26", "27", "I5", "I6")),
                  b::Element(e::Situational, "Implementation Transaction Set Syntax Error Code", b::Values("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "15", "16", "17", "18", "19", "23", "24", "25", "26", "27", "I5", "I6")),
                  b::Element(e::Situational, "Implementation Transaction Set Syntax Error Code", b::Values("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "15", "16", "17", "18", "19", "23", "24", "25", "26", "27", "I5", "I6")),
                  b::Element(e::Situational, "Implementation Transaction Set Syntax Error Code", b::Values("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "15", "16", "17", "18", "19", "23", "24", "25", "26", "27", "I5", "I6")),
                  b::Element(e::Situational, "Implementation Transaction Set Syntax Error Code", b::Values("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "15", "16", "17", "18", "19", "23", "24", "25", "26", "27", "I5", "I6")))),

              b::Segment( 900, s::AK9, "Functional Group Response Trailer", r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Functional Group Acknowledgement Code", b::Values("A", "E", "M", "P", "R", "W", "X")),
                b::Element(e::Required,    "Number of Transaction Sets Included"),
                b::Element(e::Required,    "Number of Received Transaction Sets"),
                b::Element(e::Required,    "Number of Accepted Transaction Sets"),
                b::Element(e::Situational, "Functional Group Syntax Error Code", b::Values("1", "2", "3", "4", "5", "6", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "23", "24", "25", "26")),
                b::Element(e::Situational, "Functional Group Syntax Error Code", b::Values("1", "2", "3", "4", "5", "6", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "23", "24", "25", "26")),
                b::Element(e::Situational, "Functional Group Syntax Error Code", b::Values("1", "2", "3", "4", "5", "6", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "23", "24", "25", "26")),
                b::Element(e::Situational, "Functional Group Syntax Error Code", b::Values("1", "2", "3", "4", "5", "6", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "23", "24", "25", "26")),
                b::Element(e::Situational, "Functional Group Syntax Error Code", b::Values("1", "2", "3", "4", "5", "6", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "23", "24", "25", "26"))),
              b::Segment(200, s::SE, "Transaction Set Trailer", r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Transaction Segment Count"),
                b::Element(e::Required,    "Transaction Set Control Number"))))

        end
      end
    end
  end
end
