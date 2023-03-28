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

        LB823 = b.build("LB", "823", "Lockbox",
          d::TableDef("Header",
            b::Segment(10, s::ST, "Transaction Set Header", r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Transaction Set Identifier Code", b::Values("823")),
              b::Element(e::Required,    "Transaction Set Control Number")),
            b::Segment(20, s::N1, "Party Identification", r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Entity Identifier Code", b::Values("BV")),
              b::Element(e::Required,    "Name")),
            b::Segment(30, s::N1, "Party Identification", r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Entity Identifier Code", b::Values("BE")),
              b::Element(e::Required,    "Name")),
            b::Segment(40, s::DEP, "To Indicate the Lockbox Params", r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Reference Identification"),
              b::Element(e::Required,    "Date"),
              b::Element(e::Required,    "(DFI)ID Number Qualifier"),
              b::Element(e::Required,    "(DFI) Identification"),
              b::Element(e::Required,    "Account Number Qualifier"),
              b::Element(e::Required,    "Account Number")),
            b::Segment(50, s::AMT, "Party Identification", r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Amount Qualifier Code", b::Values("3")),
              b::Element(e::Required,    "Monetary Amount")),
            b::Segment(60, s::QTY, "To specify quantity information", r::Required, d::RepeatCount.bounded(2),
              b::Element(e::Required,    "Quantity Qualifier", b::Values("41", "42")),
              b::Element(e::Required,    "Quantity")),

          d::TableDef.header("Detail",
            d::LoopDef.build("BAT", d::RepeatCount.bounded(100),
              b::Segment(10, s::BAT, "Batch Identifying Information", r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Date"),
                b::Element(e::Required,    "Reference Identification")),
              b::Segment(20, s::AMT, "Monetary Amount Information", r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Amount Qualifier Code", b::Values("2")),
                b::Element(e::Required, "Monetary Amount	")),

            d::LoopDef.build("BPR", d::RepeatCount.bounded(100),
              b::Segment(30, s::BPR, "Beginning segment for Payment Order/Remittance Advice", r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Transaction Handling Code", b::Values("I")),
                b::Element(e::Required,    "Monetary Amount	"),
                b::Element(e::Required,    "Credit Flag Code", b::Values("C")),
                b::Element(e::Required,    "Payment Method Code", b::Values("CHK", "CCC", "ACH", "CDA")),
                b::Element(e::Required,    "DFI ID Number Qualifier", b::Values("01")),
                b::Element(e::Required,    "DFI ID Number"),
                b::Element(e::Required,    "Account Number qualifier", b::Values("DA")),
                b::Element(e::Required,    "Account Number")),
              b::Segment(40, s::REF ,"Check Number", r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Reference Qualifier", b::Values("CK")),
                b::Element(e::Required,    "Reference Number")),
              b::Segment(50, s::REF, "Check Number. Eol", r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Reference Qualifier", b::Values("ZZ")),
                b::Element(e::Situational,    "Reference Number")),
              b::Segment(60, s::DTM, "Date the remittance was created", r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Date/Time Qualifier", b::Values("107", "108", "109", "020")),
                b::Element(e::Required,    "Date")),
              b::Segment(70, s::N1, "Party Identifier", r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Entity Identifier Code", b::Values("RM")),
                b::Element(e::Required,    "Name")),

            d::LoopDef.build("RMR", d::RepeatCount.bounded(100),
              b::Segment(80, s::RMR, "Remittance Advice Account Receivable Open Item Reference", r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Reference ID qualifier", b::Values("IV")),
                b::Element(e::Required,    "Reference Identification"),
                b::Element(e::Required,    "Monetary Amount (Total Amount)"),
                b::Element(e::Required,    "Monetary Amount (Net Amount)"),
                b::Element(e::Required,    "Monetary Amount (Discount)")),
              b::Segment(90, s::REF, "Purchase Order Number", r::Required, d::RepeatCount.bounded(1),
                b::Element(e::Required,    "Reference Qualifier", b::Values("ZZ")),
                b::Element(e::Required,    "Reference Number")))),

          d::TableDef.header("Summary",
            b::Segment(30, s::SE, "Transaction Set Trailer", r::Required, d::RepeatCount.bounded(1),
              b::Element(e::Required,    "Number of Included Segments"),
              b::Element(e::Required,    "Transaction Set Control Number"))))

      end
    end
  end
end
