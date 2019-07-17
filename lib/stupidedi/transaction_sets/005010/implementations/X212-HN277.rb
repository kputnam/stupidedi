# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module FiftyTen
      module Implementations
        module X212
          b = Builder
          d = Schema
          r = SegmentReqs
          e = ElementReqs
          s = SegmentDefs

          HN277 = Builder::Dsl.build("HN", "277", "Health Care Information Status Notification") do
            table_header("1 - Header") do
              segment(100, s::ST, "Transaction Set Header", r::Required, d::RepeatCount.bounded(1)) do
                element(e::Required,    "Transaction Set Identifier Code", b::Values("277"))
                element(e::Required,    "Transaction Set Control Number")
                element(e::Required,    "Version, Release, or Industry Identifier", b::Values("005010X212"))
              end
              segment(200, s::BHT, "Beginning of Hierarchical Transaction", r::Required, d::RepeatCount.bounded(1)) do
                element(e::Required,    "Hierarchical Structure Code", b::Values("0010"))
                element(e::Required,    "Transaction Set Purpose Code", b::Values("08"))
                element(e::Required,    "Originator Application Transaction Identifier", b::MaxLength(30))
                element(e::Required,    "Transaction Set Creation Date")
                element(e::Required,    "Transaction Set Creation Time")
                element(e::Required,    "Transaction Type Code", b::Values("DG"))
              end
            end

            table_detail("2 - Information Source Detail") do
              loop_("2000A INFORMATION SOURCE LEVEL", d::RepeatCount.unbounded) do
                segment(100, s::HL, "Information Source Level", r::Required, d::RepeatCount.bounded(1)) do
                  element(e::Required,    "Hierarchical ID Number")
                  element(e::NotUsed,     "Hierarchical Parent ID Number")
                  element(e::Required,    "Hierarchical Level Code", values("20"))
                  element(e::Required,    "Hierachical Child Code", values("1"))
                end
                # positions on page 100
                loop_("2100A INFORMATION SOURCE NAME", d::RepeatCount.bounded(1)) do
                  segment(500, s::NM1, "Information Source Name", r::Required, d::RepeatCount.bounded(1)) do
                    element(e::Required,    "Entity Identifier Code", values("PR"))
                    element(e::Required,    "Entity Type Qualifier", values("2"))
                    element(e::Required,    "Information Source Name")
                    element(e::NotUsed,     "Name First")
                    element(e::NotUsed,     "Name Middle")
                    element(e::NotUsed,     "Name Prefix")
                    element(e::NotUsed,     "Name Suffix")
                    element(e::Required,    "Identification Code Qualifier", values("PI", "XV"))
                    element(e::Required,    "Information Source Identifier")
                    element(e::NotUsed,     "Entity Relationship Code")
                    element(e::NotUsed,     "Entity Identifier Code")
                    element(e::NotUsed,     "Name Last or Organization Name")
                  end
                  segment(800, s::PER, "Administrative Communications Contact", r::Situational, d::RepeatCount.bounded(1)) do
                    element(e::Required,    "Concat Function Code", values("IC"))
                    element(e::Situational, "Payer Contact Name")
                    element(e::Required,    "Communication Number Qualifier", values("ED", "EM", "FX", "TE"))
                    element(e::Required,    "Payer Contact Communication Number")
                    element(e::Required,    "Communication Number Qualifier", values("ED", "EM", "FX", "TE"))
                    element(e::Required,    "Payer Contact Communication Number")
                    element(e::Required,    "Communication Number Qualifier", values("ED", "EM", "FX", "TE"))
                    element(e::Required,    "Payer Contact Communication Number")
                    element(e::NotUsed,     "Contact Inquiry Reference")
                  end
                end
              end
            end
            table_detail("2 - Information Receiver Detail") do
              loop_("2000B INFORMATION RECEIVER LEVEL", d::RepeatCount.bounded(1)) do
                segment(100, s::HL, "Information Receiver Level", r::Required, d::RepeatCount.bounded(1)) do
                  element(e::Required,    "Hierarchical ID Number")
                  element(e::Required,    "Hierarchical Parent ID Number")
                  element(e::Required,    "Hierarchical Level Code", b::Values("21"))
                  element(e::Required,    "Hierachical Child Code", b::Values("0", "1"))
                end # segment Information Receiver Level

                loop_("2100B INFORMATION RECEIVER NAME", d::RepeatCount.bounded(1)) do
                  segment(500, s::NM1, "Information Receiver Name", r::Required, d::RepeatCount.bounded(1)) do
                    element(e::Required,    "Entity Identifier Code", b::Values("41"))
                    element(e::Required,    "Entity Type Qualifier", b::Values("1", "2"))
                    element(e::Required,    "Information Receiver Last or Organizational Name")
                    element(e::Situational, "Information Receiver First Name")
                    element(e::Situational, "Information Receiver Middle Name or Initial")
                    element(e::NotUsed,     "Name Prefix")
                    element(e::NotUsed,     "Name Suffix")
                    element(e::Required,    "Identification Code Qualifier", b::Values("46"))
                    element(e::Required,    "Information Receiver Primary Identifier")
                    element(e::NotUsed,     "Entity Relationship Code")
                    element(e::NotUsed,     "Entity Identifier Code")
                    element(e::NotUsed,     "Name Last or Organization Name")
                  end # Segment Information Receiver Name
                end # Loop information Receiver Name
                loop_("2200B INFORMATION RECEIVER TRACE IDENTIFIER", d::RepeatCount.bounded(1)) do
                  segment(900, s::TRN, "Information Receiver Application Trace Identifier", r::Required, d::RepeatCount.bounded(1)) do
                    element(e::Required,    "Trace Type Code", b::Values("2"))
                    element(e::Required,    "Claim Transaction Batch Number")
                    element(e::NotUsed,     "Originating Company Identifier")
                    element(e::NotUsed,     "Reference Identification")
                  end # Segment Information Receiever Application Trace Ident
                  segment(1000, s::STC, "Information Receiver Status Information", r::Required, d::RepeatCount.unbounded) do
                    composite(e::Required,    "HEALTH CARE CLAIM STATUS") do
                      element(e::Required,    "Health Care Claim Status Category Code")
                      element(e::Required,    "Health Care Claim Status Code")
                      element(e::Situational, "Entity Identifier Qualifier", b::Values("36", "40", "41", "AY", "PR"))
                      element(e::NotUsed,     "Code List Qualifier Code")
                    end # composite value
                    element(e::Required,    "Status Information Effective Date")
                    element(e::Required,    "Action Code", b::Values("U", "WQ"))
                    element(e::Required,    "Total Submitted Charges for Unit Work")
                    element(e::NotUsed,     "Monetary Amount")
                    element(e::NotUsed,     "Date")
                    element(e::NotUsed,     "Payment Method Code")
                    element(e::NotUsed,     "Date")
                    element(e::NotUsed,     "Check Number")
                    composite(e::Situational, "HEALTH CARE CLAIM STATUS") do
                      element(e::Required,    "Health Care Claim Status Category Code") # @todo: CodeSource.external("507")
                      element(e::Required,    "Health Care Claim Status Code")          # @todo: CodeSource.external("508")
                      element(e::Situational, "Entity Identifier Qualifier", b::Values("36", "40", "41", "AY", "PR"))
                      element(e::NotUsed,     "Code List Qualifier Code")
                    end # composite value
                    composite(e::Situational, "HEALTH CARE CLAIM STATUS") do
                      element(e::Required,    "Health Care Claim Status Category Code") # @todo: CodeSource.external("507")
                      element(e::Required,    "Health Care Claim Status Code")          # @todo: CodeSource.external("508")
                      element(e::Situational, "Entity Identifier Qualifier", b::Values("36", "40", "41", "AY", "PR"))
                      element(e::NotUsed,     "Code List Qualifier Code")
                    end # composite value
                    element(e::NotUsed,     "Free-form Message Text")
                  end # Segment  information receiver status information
                end # loop Information Receiver Trace Identifier
              end # loop Information Receiver Level
            end # Table 2 - Information Receiver Detail
            table_detail("2 - Service Provider Detail") do
              loop_("2000C Service Provider Level", d::RepeatCount.unbounded) do
                segment(100, s::HL, "Service Provider Level", r::Situational, d::RepeatCount.bounded(1)) do
                  element(e::Required,    "Hierarchical ID Number")
                  element(e::Required,    "Hierarchical Parent ID Number")
                  element(e::Required,    "Hierarchical Level Code", b::Values("19"))
                  element(e::Required,    "Hierachical Child Code", b::Values("0", "1"))
                end # Segment 100 Service Provider Level
              end # Loop 2000C Service Provider Level
              loop_("2100C PROVIDER NAME", d::RepeatCount.bounded(2)) do
                segment(500, s::NM1, "Provider Name", r::Required, d::RepeatCount.bounded(1)) do
                  element(e::Required,    "Entity Identifier Code", b::Values("1P"))
                  element(e::Required,    "Entity Type Qualifier", b::Values("1", "2"))
                  element(e::Required,    "Information Receiver Last or Organizational Name")
                  element(e::Situational, "Information Receiver First Name")
                  element(e::Situational, "Information Receiver Middle Name or Initial")
                  element(e::NotUsed,     "Name Prefix")
                  element(e::NotUsed,     "Name Suffix")
                  element(
                    e::Required, "Identification Code Qualifier",
                    b::Values("FI", "SV", "XX")
                  )
                  element(e::Required,    "Information Receiver Primary Identifier")
                  element(e::NotUsed,     "Entity Relationship Code")
                  element(e::NotUsed,     "Entity Identifier Code")
                  element(e::NotUsed,     "Name Last or Organization Name")
                end # Segment/NM1 - Provider Name
              end # Loop/2100C - Provider Name
              loop_("2200C PROVIDER OF SERVICE TRACE IDENTIFIER", d::RepeatCount.bounded(1)) do
                segment(900, s::TRN, "Provider of Service Trace Identifier", r::Situational, d::RepeatCount.bounded(1)) do
                  element(e::Required, "Trace Type Code", values("1"))
                  element(e::Required, "Reference Identification")
                  element(e::NotUsed, "Originating Company Identifier")
                  element(e::NotUsed, "Reference Identification")
                end # Segment/TRN - Provider of Service Trance Information
                segment(1000, s::STC, "Provider Status Information", r::Required, d::RepeatCount.unbounded) do
                  composite(e::Required,    "HEALTH CARE CLAIM STATUS") do
                    element(e::Required,    "Health Care Claim Status Category Code")
                    element(e::Required,    "Health Care Claim Status Code")
                    element(e::Situational, "Entity Identifier Qualifier", b::Values("36", "40", "41", "AY", "PR"))
                    element(e::NotUsed,     "Code List Qualifier Code")
                  end # composite value
                  element(e::Required,    "Status Information Effective Date")
                  element(e::Required,    "Action Code", b::Values("U", "WQ"))
                  element(e::Required,    "Total Submitted Charges for Unit Work")
                  element(e::NotUsed,     "Monetary Amount")
                  element(e::NotUsed,     "Date")
                  element(e::NotUsed,     "Payment Method Code")
                  element(e::NotUsed,     "Date")
                  element(e::NotUsed,     "Check Number")
                  composite(e::Situational, "HEALTH CARE CLAIM STATUS") do
                    element(e::Required,    "Health Care Claim Status Category Code") # @todo: CodeSource.external("507")
                    element(e::Required,    "Health Care Claim Status Code")          # @todo: CodeSource.external("508")
                    element(e::Situational, "Entity Identifier Qualifier", b::Values("36", "40", "41", "AY", "PR"))
                    element(e::NotUsed,     "Code List Qualifier Code")
                  end # composite value
                  composite(e::Situational, "HEALTH CARE CLAIM STATUS") do
                    element(e::Required,    "Health Care Claim Status Category Code") # @todo: CodeSource.external("507")
                    element(e::Required,    "Health Care Claim Status Code")          # @todo: CodeSource.external("508")
                    element(e::Situational, "Entity Identifier Qualifier", b::Values("36", "40", "41", "AY", "PR"))
                    element(e::NotUsed,     "Code List Qualifier Code")
                  end # composite value
                  element(e::NotUsed,     "Free-form Message Text")
                end # Segment/STC - Provider Status Information
              end # Loop/2200C - Provider of Service Trace Identifier
            end # Table/2 - Service Provider Detail
            table_detail("2 - Subscriber Detail") do
              loop_("2000D SUBSCRIBER LEVEL", d::RepeatCount.unbounded) do
                segment(100, s::HL, "Subscriber Level", r::Situational, d::RepeatCount.bounded(1)) do
                  element(e::Required,    "Hierarchical ID Number")
                  element(e::Required,    "Hierarchical Parent ID Number")
                  element(e::Required,    "Hierarchical Level Code", values("22"))
                  element(e::NotUsed,     "Hierachical Child Code")
                end # Segment/HL - Subscriber Level

                loop_("2100D SUBSCRIBER NAME", d::RepeatCount.bounded(1)) do
                  segment(500, s::NM1, "Subscriber Name", r::Required, d::RepeatCount.bounded(1)) do
                    element(e::Required,    "Entity Identifier Code", values("IL"))
                    element(e::Required,    "Entity Type Qualifier", values("1"))
                    element(e::Required,    "Subscriber Last or Organizational Name")
                    element(e::Situational, "Subscriber First Name")
                    element(e::Situational, "Subscriber Middle Name or Initial")
                    element(e::NotUsed,     "Name Prefix")
                    element(e::Situational, "Subscriber Name Suffix")
                    element(e::Required,    "Identification Code Qualifier", values("II", "MI"))
                    element(e::Required,    "Subscriber Identification Number")
                    element(e::NotUsed,     "Entity Relationship Code")
                    element(e::NotUsed,     "Entity Identifier Code")
                    element(e::NotUsed,     "Name Last or Organization Name")
                  end # Segment/NM1 - Subscriber Name
                end # Loop/2100D - Subscriber name
                loop_("2200D CLAIM STATUS TRACKING NUMBER", d::RepeatCount.unbounded) do
                  segment(900, s::TRN, "Claim Status Tracking Number", r::Required, d::RepeatCount.bounded(1)) do
                    element(e::Required,    "Trace Type Code", values("2"))
                    element(e::Required,    "Subscriber Control Number")
                    element(e::NotUsed,     "Originating Company Identifier")
                    element(e::NotUsed,     "Reference Identification")
                  end # Segment/TRN - Claim Status Tracking Number
                  segment(1000, s::STC, "Claim Level Status Information", r::Required, d::RepeatCount.unbounded) do
                    composite(e::Required,    "HEALTH CARE CLAIM STATUS") do
                      element(e::Required,    "Health Care Claim Status Category Code")
                      element(e::Required,    "Health Care Claim Status Code")
                      element(e::Situational, "Entity Identifier Qualifier", values("03", "1P", "1Z", "40", "41", "71", "72", "73", "77", "82", "85", "87", "DK", "DN", "DQ", "FA", "GB", "HK", "IL", "LI", "MSC", "PR", "PRP", "QB", "QC", "QD", "SEP", "TL", "TTP", "TU"))
                      element(e::NotUsed,     "Code List Qualifier Code")
                    end # Composite/Health care claim status
                    element(e::Required,    "Status Information Effective Date")
                    element(e::Required,    "Action Code", values("U", "WQ"))
                    element(e::Required,    "Total Claim Charge Amount")
                    element(e::NotUsed,     "Monetary Amount")
                    element(e::NotUsed,     "Date")
                    element(e::NotUsed,     "Payment Method Code")
                    element(e::NotUsed,     "Date")
                    element(e::NotUsed,     "Check Number")
                    composite(e::Situational, "HEALTH CARE CLAIM STATUS") do
                      element(e::Required,    "Health Care Claim Status Category Code")
                      element(e::Required,    "Health Care Claim Status Code")
                      element(e::Situational, "Entity Identifier Qualifier", values("36", "40", "41", "AY", "PR"))
                      element(e::NotUsed,     "Code List Qualifier Code")
                    end # Composite/Health Care Claim Status
                    composite(e::Situational, "HEALTH CARE CLAIM STATUS") do
                      element(e::Required,    "Health Care Claim Status Category Code")
                      element(e::Required,    "Health Care Claim Status Code")
                      element(e::Situational, "Entity Identifier Qualifier", values("36", "40", "41", "AY", "PR"))
                      element(e::NotUsed,     "Code List Qualifier Code")
                    end # Composite/Health Care Claim Status
                    element(e::Situational, "Free Form Message Text")
                  end # Segment/STC - Claim Level Status Information
                  segment(1100, s::REF, "Payer Claim Control Number", r::Situational, d::RepeatCount.bounded(1)) do
                    element(e::Required,    "Reference Identification Qualifier", values("1K"))
                    element(e::Required,    "Payer Claim Control Number")
                    element(e::NotUsed,     "Description")
                    element(e::NotUsed,     "REFERENCE IDENTIFIER")
                  end # Segment/REF - Payer Claim Control Number
                  segment(1100, s::REF, "Institutional Bill Type Identification", r::Situational, d::RepeatCount.bounded(1)) do
                    element(e::Required,    "Reference Identification Qualifier", values("BLT"))
                    element(e::Required,    "Institutional Bill Type Identification")
                    element(e::NotUsed,     "Description")
                    element(e::NotUsed,     "REFERENCE IDENTIFIER")
                  end # Segment/REF - Institutional Bill Type Identification
                  segment(1100, s::REF, "Patient Control Number", r::Situational, d::RepeatCount.bounded(1)) do
                    element(e::Required,    "Reference Identification Qualifier", values("EJ"))
                    element(e::Required,    "Patient Control Number")
                    element(e::NotUsed,     "Description")
                    element(e::NotUsed,     "REFERENCE IDENTIFIER")
                  end # Segment/REF - Patient Control Number
                  segment(1100, s::REF, "Pharmacy Prescription Number", r::Situational, d::RepeatCount.bounded(1)) do
                    element(e::Required,    "Reference Identification Qualifier", values("XZ"))
                    element(e::Required,    "Pharmacy Prescription Number")
                    element(e::NotUsed,     "Description")
                    element(e::NotUsed,     "REFERENCE IDENTIFIER")
                  end # Segment/REF - Pharmacy Prescription Number
                  segment(1100, s::REF, "Voucher Identifier", r::Situational, d::RepeatCount.bounded(1)) do
                    element(e::Required,    "Reference Identification Qualifier", values("VV"))
                    element(e::Required,    "Pharmacy Prescription Number")
                    element(e::NotUsed,     "Description")
                    element(e::NotUsed,     "REFERENCE IDENTIFIER")
                  end # Segment/REF - Voucher Identifier
                  segment(1100, s::REF, "Claim Identifier Number for Clearinghous and Other Transmission Intermediaries", r::Situational, d::RepeatCount.bounded(3)) do
                    element(e::Required,    "Reference Identification Qualifier", values("D9"))
                    element(e::Required,    "Clearinghouse Trace Number")
                    element(e::NotUsed,     "Description")
                    element(e::NotUsed,     "REFERENCE IDENTIFIER")
                  end # Segment/REF - Claim Identifier Number for Clearinghouses and...
                  segment(1200, s::DTP, "Claim Level Service Date", r::Required, d::RepeatCount.bounded(1)) do
                    element(e::Required,    "Date Time Qualifier", values("472"))
                    element(e::Required,    "Date Time Period Format Qualifier", values("D8", "RD8"))
                    element(e::Required,    "Claim Service Period")
                  end # Segment/DTP - Claim Level Service Date

                  loop_("2220D SERVICE LINE INFORMATION", d::RepeatCount.unbounded) do
                    segment(1800, s::SVC, "Service Line Information", r::Situational, d::RepeatCount.bounded(1)) do
                      composite(e::Required,    "COMPOSITE MEDICAL PROCEDURE IDENTIFIER") do
                        element(e::Required,    "Procedure Code", values("AD", "ER", "HC", "HP", "IV", "NU", "WK"))
                        element(e::Required,    "Procedure Code")
                        element(e::Situational, "Procedure Modifier")
                        element(e::Situational, "Procedure Modifier")
                        element(e::Situational, "Procedure Modifier")
                        element(e::Situational, "Procedure Modifier")
                        element(e::NotUsed,     "Description")
                        element(e::NotUsed,     "Product/Service ID")
                      end # composite/medical procedure identifier
                      element(e::Required,    "Line Item Charge Amount")
                      element(e::NotUsed,     "Monetary Amount")
                      element(e::Situational, "Revenue Code")
                      element(e::NotUsed,     "Quantity")
                      element(e::NotUsed,     "COMPOSITE MEDICAL PROCEDURE IDENTIFIER")
                      element(e::Situational, "Original Units of Service Count")

                    end # Segment/SVC - Service Line Information

                    segment(1900, s::STC, "Service Line Level Status Information", r::Required, d::RepeatCount.unbounded) do
                      composite(e::Required,    "HEALTH CARE CLAIM STATUS") do
                        element(e::Required,    "Health Care Claim Status Category Code") # @todo: CodeSource.external("507")
                        element(e::Required,    "Health Care Claim Status Code")          # @todo: CodeSource.external("508")
                        element(e::Situational, "Entity Identifier Qualifier", values("03", "1P", "1Z", "40", "41", "71", "72", "73", "77", "82", "85", "87", "DK", "DN", "DQ", "FA", "GB", "HK", "IL", "LI", "MSC", "PR", "PRP", "QB", "QC", "QD", "SEP", "TL", "TTP", "TU"))
                        element(e::NotUsed,     "Code List Qualifier Code")
                      end # composite/ health care claim status
                      element(e::NotUsed,     "Date")
                      element(e::Required,    "Action Code", values("U"))
                      element(e::NotUsed,     "Monetary Amount")
                      element(e::NotUsed,     "Monetary Amount")
                      element(e::NotUsed,     "Date")
                      element(e::NotUsed,     "Payment Method Code")
                      element(e::NotUsed,     "Date")
                      element(e::NotUsed,     "Check Number")
                      composite(e::Situational, "HEALTH CARE CLAIM STATUS") do
                        element(e::Required,    "Health Care Claim Status Category Code") # @todo: CodeSource.external("507")
                        element(e::Required,    "Health Care Claim Status Code")          # @todo: CodeSource.external("508")
                        element(e::Situational, "Entity Identifier Qualifier", values("03", "1P", "1Z", "40", "41", "71", "72", "73", "77", "82", "85", "87", "DK", "DN", "DQ", "FA", "GB", "HK", "IL", "LI", "MSC", "PR", "PRP", "QB", "QC", "QD", "SEP", "TL", "TTP", "TU"))
                        element(e::NotUsed,     "Code List Qualifier Code")
                      end # composite/Health care claims
                      composite(e::Situational, "HEALTH CARE CLAIM STATUS") do
                        element(e::Required,    "Health Care Claim Status Category Code")
                        element(e::Required,    "Health Care Claim Status Code")
                        element(e::Situational, "Entity Identifier Qualifier", values("03", "1P", "1Z", "40", "41", "71", "72", "73", "77", "82", "85", "87", "DK", "DN", "DQ", "FA", "GB", "HK", "IL", "LI", "MSC", "PR", "PRP", "QB", "QC", "QD", "SEP", "TL", "TTP", "TU"))
                        element(e::NotUsed,     "Code List Qualifier Code")
                      end # composite/Health care claim status
                      element(e::Situational, "Free Form Message Text")
                    end # Segment/STC - Service Line Level Information
                    segment(2000, s::REF, "Service Line Item Identification", r::Required, d::RepeatCount.bounded(1)) do
                      element(e::Required,    "Reference Identification Qualifier", values("FJ"))
                      element(e::Required,    "Line Item Control Number")
                      element(e::NotUsed,     "Description")
                      element(e::NotUsed,     "REFERENCE IDENTIFIER")
                    end # Segment/REF - Service Line item Identification
                    segment(2000, s::REF, "Pharmacy Prescription Number", r::Situational, d::RepeatCount.bounded(1)) do
                      element(e::Required,    "Reference Identification Qualifier", values("XZ"))
                      element(e::Required,    "Pharmacy Prescription Number")
                      element(e::NotUsed,     "Description")
                      element(e::NotUsed,     "REFERENCE IDENTIFIER")
                    end # Segment/REF - Pharmacy Prescription Number
                    segment(2100, s::DTP, "Service Line Date", r::Situational, d::RepeatCount.bounded(1)) do
                      element(e::Required,    "Date Time Qualifier", values("472"))
                      element(e::Required,    "Date Time Period Format Qualifier", values("D8", "RD8"))
                      element(e::Required,    "Service Line Date")
                    end # Segment/DTP - Service Line Date
                  end # Loop/2220D - Service Line Information
                end # Loop/2200D - Claim Status Tracking Number
              end # Loop/2000D - Subscriber Level
            end # Table/2 - Subscriber Detail
            table_detail("2 - Dependent Detail") do
              loop_("2000E DEPENDENT LEVEL", d::RepeatCount.unbounded) do
                segment(100, s::HL, "Dependent Level", r::Situational, d::RepeatCount.bounded(1)) do
                  element(e::Required,    "Hierarchical ID Number")
                  element(e::Required,    "Hierarchical Parent ID Number")
                  element(e::Required,    "Hierarchical Level Code", values("23"))
                  element(e::NotUsed,     "Hierachical Child Code")
                end # Segment/HL - Dependent Level

                loop_("2100E DEPENDENT NAME", d::RepeatCount.bounded(1)) do
                  segment(500, s::NM1, "Dependent Name", r::Required, d::RepeatCount.bounded(1)) do
                    element(e::Required,    "Entity Identifier Code", values("QC"))
                    element(e::Required,    "Entity Type Qualifier", values("1"))
                    element(e::Required,    "Subscriber Last or Organizational Name")
                    element(e::Situational, "Subscriber First Name")
                    element(e::Situational, "Subscriber Middle Name or Initial")
                    element(e::NotUsed,     "Name Prefix")
                    element(e::Situational, "Subscriber Name Suffix")
                    element(e::Required,    "Identification Code Qualifier", values("II", "MI"))
                    element(e::Required,    "Subscriber Identification Number")
                    element(e::NotUsed,     "Entity Relationship Code")
                    element(e::NotUsed,     "Entity Identifier Code")
                    element(e::NotUsed,     "Name Last or Organization Name")
                  end # Segment/NM1 - Dependent Name
                end # Loop/2100D - Subscriber name
                loop_("2200E CLAIM STATUS TRACKING NUMBER", d::RepeatCount.unbounded) do
                  segment(900, s::TRN, "Claim Status Tracking Number", r::Required, d::RepeatCount.bounded(1)) do
                    element(e::Required,    "Trace Type Code", values("2"))
                    element(e::Required,    "Subscriber Control Number")
                    element(e::NotUsed,     "Originating Company Identifier")
                    element(e::NotUsed,     "Reference Identification")
                  end # Segment/TRN - Claim Status Tracking Number
                  segment(1000, s::STC, "Claim Level Status Information", r::Required, d::RepeatCount.unbounded) do
                    composite(e::Required,    "HEALTH CARE CLAIM STATUS") do
                      element(e::Required,    "Health Care Claim Status Category Code")
                      element(e::Required,    "Health Care Claim Status Code")
                      element(e::Situational, "Entity Identifier Qualifier", values("03", "1P", "1Z", "40", "41", "71", "72", "73", "77", "82", "85", "87", "DK", "DN", "DQ", "FA", "GB", "HK", "IL", "LI", "MSC", "PR", "PRP", "QB", "QC", "QD", "SEP", "TL", "TTP", "TU"))
                      element(e::NotUsed,     "Code List Qualifier Code")
                    end # Composite/Health care claim status
                    element(e::Required,    "Status Information Effective Date")
                    element(e::Required,    "Action Code", values("U", "WQ"))
                    element(e::Required,    "Total Claim Charge Amount")
                    element(e::NotUsed,     "Monetary Amount")
                    element(e::NotUsed,     "Date")
                    element(e::NotUsed,     "Payment Method Code")
                    element(e::NotUsed,     "Date")
                    element(e::NotUsed,     "Check Number")
                    composite(e::Situational, "HEALTH CARE CLAIM STATUS") do
                      element(e::Required,    "Health Care Claim Status Category Code")
                      element(e::Required,    "Health Care Claim Status Code")
                      element(e::Situational, "Entity Identifier Qualifier", values("36", "40", "41", "AY", "PR"))
                      element(e::NotUsed,     "Code List Qualifier Code")
                    end # Composite/Health Care Claim Status
                    composite(e::Situational, "HEALTH CARE CLAIM STATUS") do
                      element(e::Required,    "Health Care Claim Status Category Code")
                      element(e::Required,    "Health Care Claim Status Code")
                      element(e::Situational, "Entity Identifier Qualifier", values("36", "40", "41", "AY", "PR"))
                      element(e::NotUsed,     "Code List Qualifier Code")
                    end # Composite/Health Care Claim Status
                    element(e::Situational, "Free Form Message Text")
                  end # Segment/STC - Claim Level Status Information
                  segment(1100, s::REF, "Payer Claim Control Number", r::Situational, d::RepeatCount.bounded(1)) do
                    element(e::Required,    "Reference Identification Qualifier", values("1K"))
                    element(e::Required,    "Payer Claim Control Number")
                    element(e::NotUsed,     "Description")
                    element(e::NotUsed,     "REFERENCE IDENTIFIER")
                  end # Segment/REF - Payer Claim Control Number
                  segment(1100, s::REF, "Institutional Bill Type Identification", r::Situational, d::RepeatCount.bounded(1)) do
                    element(e::Required,    "Reference Identification Qualifier", values("BLT"))
                    element(e::Required,    "Institutional Bill Type Identification")
                    element(e::NotUsed,     "Description")
                    element(e::NotUsed,     "REFERENCE IDENTIFIER")
                  end # Segment/REF - Institutional Bill Type Identification
                  segment(1100, s::REF, "Patient Control Number", r::Situational, d::RepeatCount.bounded(1)) do
                    element(e::Required,    "Reference Identification Qualifier", values("EJ"))
                    element(e::Required,    "Patient Control Number")
                    element(e::NotUsed,     "Description")
                    element(e::NotUsed,     "REFERENCE IDENTIFIER")
                  end # Segment/REF - Patient Control Number
                  segment(1100, s::REF, "Pharmacy Prescription Number", r::Situational, d::RepeatCount.bounded(1)) do
                    element(e::Required,    "Reference Identification Qualifier", values("XZ"))
                    element(e::Required,    "Pharmacy Prescription Number")
                    element(e::NotUsed,     "Description")
                    element(e::NotUsed,     "REFERENCE IDENTIFIER")
                  end # Segment/REF - Pharmacy Prescription Number
                  segment(1100, s::REF, "Voucher Identifier", r::Situational, d::RepeatCount.bounded(1)) do
                    element(e::Required,    "Reference Identification Qualifier", values("VV"))
                    element(e::Required,    "Pharmacy Prescription Number")
                    element(e::NotUsed,     "Description")
                    element(e::NotUsed,     "REFERENCE IDENTIFIER")
                  end # Segment/REF - Voucher Identifier
                  segment(1100, s::REF, "Claim Identifier Number for Clearinghous and Other Transmission Intermediaries", r::Situational, d::RepeatCount.bounded(3)) do
                    element(e::Required,    "Reference Identification Qualifier", values("D9"))
                    element(e::Required,    "Clearinghouse Trace Number")
                    element(e::NotUsed,     "Description")
                    element(e::NotUsed,     "REFERENCE IDENTIFIER")
                  end # Segment/REF - Claim Identifier Number for Clearinghouses and...
                  segment(1200, s::DTP, "Claim Level Service Date", r::Required, d::RepeatCount.bounded(1)) do
                    element(e::Required,    "Date Time Qualifier", values("472"))
                    element(e::Required,    "Date Time Period Format Qualifier", values("D8", "RD8"))
                    element(e::Required,    "Claim Service Period")
                  end # Segment/DTP - Claim Level Service Date

                  loop_("2220E SERVICE LINE INFORMATION", d::RepeatCount.unbounded) do
                    segment(1800, s::SVC, "Service Line Information", r::Situational, d::RepeatCount.bounded(1)) do
                      composite(e::Required,    "COMPOSITE MEDICAL PROCEDURE IDENTIFIER") do
                        element(e::Required,    "Procedure Code", values("AD", "ER", "HC", "HP", "IV", "NU", "WK"))
                        element(e::Required,    "Procedure Code")
                        element(e::Situational, "Procedure Modifier")
                        element(e::Situational, "Procedure Modifier")
                        element(e::Situational, "Procedure Modifier")
                        element(e::Situational, "Procedure Modifier")
                        element(e::NotUsed,     "Description")
                        element(e::NotUsed,     "Product/Service ID")
                      end # composite/medical procedure identifier
                      element(e::Required,    "Line Item Charge Amount")
                      element(e::NotUsed,     "Monetary Amount")
                      element(e::Situational, "Revenue Code")
                      element(e::NotUsed,     "Quantity")
                      element(e::NotUsed,     "COMPOSITE MEDICAL PROCEDURE IDENTIFIER")
                      element(e::Situational, "Original Units of Service Count")

                    end # Segment/SVC - Service Line Information

                    segment(1900, s::STC, "Service Line Level Status Information", r::Required, d::RepeatCount.unbounded) do
                      composite(e::Required,    "HEALTH CARE CLAIM STATUS") do
                        element(e::Required,    "Health Care Claim Status Category Code") # @todo: CodeSource.external("507")
                        element(e::Required,    "Health Care Claim Status Code")          # @todo: CodeSource.external("508")
                        element(e::Situational, "Entity Identifier Qualifier", values("03", "1P", "1Z", "40", "41", "71", "72", "73", "77", "82", "85", "87", "DK", "DN", "DQ", "FA", "GB", "HK", "IL", "LI", "MSC", "PR", "PRP", "QB", "QC", "QD", "SEP", "TL", "TTP", "TU"))
                        element(e::NotUsed,     "Code List Qualifier Code")
                      end # composite/ health care claim status
                      element(e::NotUsed,     "Date")
                      element(e::Required,    "Action Code", values("U"))
                      element(e::NotUsed,     "Monetary Amount")
                      element(e::NotUsed,     "Monetary Amount")
                      element(e::NotUsed,     "Date")
                      element(e::NotUsed,     "Payment Method Code")
                      element(e::NotUsed,     "Date")
                      element(e::NotUsed,     "Check Number")
                      composite(e::Situational, "HEALTH CARE CLAIM STATUS") do
                        element(e::Required,    "Health Care Claim Status Category Code") # @todo: CodeSource.external("507")
                        element(e::Required,    "Health Care Claim Status Code")          # @todo: CodeSource.external("508")
                        element(e::Situational, "Entity Identifier Qualifier", values("03", "1P", "1Z", "40", "41", "71", "72", "73", "77", "82", "85", "87", "DK", "DN", "DQ", "FA", "GB", "HK", "IL", "LI", "MSC", "PR", "PRP", "QB", "QC", "QD", "SEP", "TL", "TTP", "TU"))
                        element(e::NotUsed,     "Code List Qualifier Code")
                      end # composite/Health care claims
                      composite(e::Situational, "HEALTH CARE CLAIM STATUS") do
                        element(e::Required,    "Health Care Claim Status Category Code")
                        element(e::Required,    "Health Care Claim Status Code")
                        element(e::Situational, "Entity Identifier Qualifier", values("03", "1P", "1Z", "40", "41", "71", "72", "73", "77", "82", "85", "87", "DK", "DN", "DQ", "FA", "GB", "HK", "IL", "LI", "MSC", "PR", "PRP", "QB", "QC", "QD", "SEP", "TL", "TTP", "TU"))
                        element(e::NotUsed,     "Code List Qualifier Code")
                      end # composite/Health care claim status
                      element(e::Situational, "Free Form Message Text")
                    end # Segment/STC - Service Line Level Information
                    segment(2000, s::REF, "Service Line Item Identification", r::Required, d::RepeatCount.bounded(1)) do
                      element(e::Required,    "Reference Identification Qualifier", values("FJ"))
                      element(e::Required,    "Line Item Control Number")
                      element(e::NotUsed,     "Description")
                      element(e::NotUsed,     "REFERENCE IDENTIFIER")
                    end # Segment/REF - Service Line item Identification
                    segment(2100, s::DTP, "Service Line Date", r::Situational, d::RepeatCount.bounded(1)) do
                      element(e::Required,    "Date Time Qualifier", values("472"))
                      element(e::Required,    "Date Time Period Format Qualifier", values("D8", "RD8"))
                      element(e::Required,    "Service Line Date")
                    end # Segment/DTP - Service Line Date
                  end # Loop/2220D - Service Line Information
                end # Loop/2200D - Claim Status Tracking Number
              end # Loop/2000E - Subscriber Level
              segment(2700, s::SE, "Transaction Set Trailer", r::Required, d::RepeatCount.bounded(1)) do
                element(e::Required, "Transaction Segment Count")
                element(e::Required, "Transaction Set Control Number")
              end
            end # Table/2 - Dependent Detail
          end
        end
      end
    end
  end
end