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
            entity_values = %w[
              03 13 17 1e 1g 1h 1i 1o 1p 1q 1r 1s 1t 1u 1v 1w 1x 1y 1z 28 2a 2b
              2d 2e 2i 2k 2p 2q 2s 2z 30 36 3a 3c 3d 3e 3f 3g 3h 3i 3j 3k 3l 3m 3n 3o 3p 3q
              3r 3s 3t 3u 3v 3w 3x 3y 3z 40 43 44 4a 4b 4c 4d 4e 4f 4g 4h 4i 4j 4l 4m 4n 4o
              4p 4q 4r 4s 4u 4v 4w 4x 4y 4z 5a 5b 5c 5d 5e 5f 5g 5h 5i 5j 5k 5l
              5m 5n 5o 5p 5q 5r 5s 5t 5u 5v 5w 5x 5y 5z 61 6a 6b 6c 6d 6e 6f 6g 6h 6i 6j 6k
              6l 6n 6o 6p 6q 6r 6s 6u 6v 6w 6x 6y 71 72 73 74 77 7c 80 82 84 85 87 95 ck cz
              d2 dd dj dk dn do dq e1 e2 e7 e9 fa fd fe g0 g3 gb gb gi gj gk gm gy hf hh i3
              ij il in li lr mr msc ob od ox p0 p2 p3 p4 p5 p7 prp pt pv pw qa qb qc qd qe qh qk
              ql qn qo qs qv qy rc rw s4 sep sj su t4 tl tq tt ttp tu uh x3 x4 x5 zz
            ].map(&:upcase)
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
                    element(e::Required,    "Payer Name")
                    element(e::NotUsed,     "Name First")
                    element(e::NotUsed,     "Name Middle")
                    element(e::NotUsed,     "Name Prefix")
                    element(e::NotUsed,     "Name Suffix")
                    element(e::Required,    "Identification Code Qualifier", values("PI", "XV"))
                    element(e::Required,    "Payer Identifier")
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
              loop_("2000B INFORMATION RECEIVER LEVEL", d::RepeatCount.unbounded) do
                segment(100, s::HL, "Information Receiver Level", r::Required, d::RepeatCount.bounded(1)) do
                  element(e::Required,    "Hierarchical ID Number")
                  element(e::Required,    "Hierarchical Parent ID Number")
                  element(e::Required,    "Hierarchical Level Code", b::Values("21"))
                  element(e::Required,    "Hierachical Child Code", b::Values("0", "1"))
                end # segment Information Receiver Level

                loop_("2100B INFORMATION RECEIVER NAME", d::RepeatCount.bounded(2)) do
                  segment(500, s::NM1, "Information Receiver Name", r::Required, d::RepeatCount.bounded(1)) do
                    element(e::Required,    "Entity Identifier Code", b::Values("41"))
                    element(e::Required,    "Entity Type Qualifier", b::Values("1", "2"))
                    element(e::Situational, "Information Receiver Last or Organizational Name")
                    element(e::Situational, "Information Receiver First Name")
                    element(e::Situational, "Information Receiver Middle Name")
                    element(e::NotUsed,     "Name Prefix")
                    element(e::NotUsed,     "Name Suffix")
                    element(e::Required,    "Identification Code Qualifier", b::Values("46"))
                    element(e::Required,    "Information Receiver Identification Number")
                    element(e::NotUsed,     "Entity Relationship Code")
                    element(e::NotUsed,     "Entity Identifier Code")
                    element(e::NotUsed,     "Name Last or Organization Name")
                  end # Segment Information Receiver Name
                end # Loop information Receiver Name
                loop_("2200B INFORMATION RECEIVER TRACE IDENTIFIER", d::RepeatCount.bounded(1)) do
                  segment(900, s::TRN, "Information Receiver Trace Identifier", r::Situational, d::RepeatCount.bounded(1)) do
                    element(e::Required,    "Trace Type Code", b::Values("2"))
                    element(e::Required,    "Claim Transaction Batch Number")
                    element(e::NotUsed,     "Originating Company Identifier")
                    element(e::NotUsed,     "Reference Identification")
                  end # Segment Information Receiever Application Trace Ident
                  segment(1000, s::STC, "Information Receiver Status Information", r::Required, d::RepeatCount.unbounded) do
                    composite(e::Required,    "HEALTH CARE CLAIM STATUS") do
                      element(e::Required,    "Status Code")
                      element(e::Required,    "Health Care Claim Status Code")
                      element(e::Situational, "Entity Identifier Code", b::Values("41", "AY", "PR"))
                      element(e::NotUsed,     "Code List Qualifier Code")
                    end # composite value
                    element(e::Required,    "Status Information Effective Date")
                    element(e::NotUsed,     "Action Code")
                    element(e::NotUsed,     "Monetary Amount")
                    element(e::NotUsed,     "Monetary Amount")
                    element(e::NotUsed,     "Date")
                    element(e::NotUsed,     "Payment Method Code")
                    element(e::NotUsed,     "Date")
                    element(e::NotUsed,     "Check Number")
                    composite(e::Situational, "HEALTH CARE CLAIM STATUS") do
                      element(e::Required,    "Health Care Claim Status Category Code") # @todo: CodeSource.external("507")
                      element(e::Required,    "Status Code")          # @todo: CodeSource.external("508")
                      element(e::Situational, "Entity Identifier Qualifier", b::Values("41", "AY", "PR"))
                      element(e::NotUsed,     "Code List Qualifier Code")
                    end # composite value
                    composite(e::Situational, "HEALTH CARE CLAIM STATUS") do
                      element(e::Required,    "Health Care Claim Status Category Code") # @todo: CodeSource.external("507")
                      element(e::Required,    "Status Code")          # @todo: CodeSource.external("508")
                      element(e::Situational, "Entity Identifier Qualifier", b::Values("41", "AY", "PR"))
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
                loop_("2100C PROVIDER NAME", d::RepeatCount.bounded(2)) do
                  segment(500, s::NM1, "Provider Name", r::Required, d::RepeatCount.bounded(1)) do
                    element(e::Required,    "Entity Identifier Code", b::Values("1P"))
                    element(e::Required,    "Entity Type Qualifier", b::Values("1", "2"))
                    element(e::Situational, "Provider Last or Organization Name")
                    element(e::Situational, "Provider First Name")
                    element(e::Situational, "Provider Middle Name")
                    element(e::NotUsed,     "Name Prefix")
                    element(e::Situational, "Provider Name Suffix")
                    element(
                      e::Required, "Identification Code Qualifier",
                      b::Values("FI", "SV", "XX")
                    )
                    element(e::Required,    "Provider Identifier")
                    element(e::NotUsed,     "Entity Relationship Code")
                    element(e::NotUsed,     "Entity Identifier Code")
                    element(e::NotUsed,     "Name Last or Organization Name")
                  end # Segment/NM1 - Provider Name
                end # Loop/2100C - Provider Name
                loop_("2200C PROVIDER OF SERVICE TRACE IDENTIFIER", d::RepeatCount.bounded(1)) do
                  segment(900, s::TRN, "Provider of Service Trace Identifier", r::Situational, d::RepeatCount.bounded(1)) do
                    element(e::Required, "Trace Type Code", values("1"))
                    element(e::Required, "Provider of Service INformation Trace Identifier")
                    element(e::NotUsed, "Originating Company Identifier")
                    element(e::NotUsed, "Reference Identification")
                  end # Segment/TRN - Provider of Service Trance Information
                  segment(1000, s::STC, "Provider Status Information", r::Required, d::RepeatCount.unbounded) do
                    composite(e::Required,    "HEALTH CARE CLAIM STATUS") do
                      element(e::Required,    "Health Care Claim Status Category Code")
                      element(e::Required,    "Status Code")
                      element(e::Situational, "Entity Identifier Code", b::Values("1P"))
                      element(e::NotUsed,     "Code List Qualifier Code")
                    end # composite value
                    element(e::Required,    "Status Information Effective Date")
                    element(e::NotUsed,     "Action Code")
                    element(e::NotUsed,     "Monetary Amount")
                    element(e::NotUsed,     "Monetary Amount")
                    element(e::NotUsed,     "Date")
                    element(e::NotUsed,     "Payment Method Code")
                    element(e::NotUsed,     "Date")
                    element(e::NotUsed,     "Check Number")
                    composite(e::Situational, "HEALTH CARE CLAIM STATUS") do
                      element(e::Required,    "Health Care Claim Status Category Code") # @todo: CodeSource.external("507")
                      element(e::Required,    "Health Care Claim Status Code")          # @todo: CodeSource.external("508")
                      element(e::Situational, "Entity Identifier Qualifier", b::Values("1P"))
                      element(e::NotUsed,     "Code List Qualifier Code")
                    end # composite value
                    composite(e::Situational, "HEALTH CARE CLAIM STATUS") do
                      element(e::Required,    "Health Care Claim Status Category Code") # @todo: CodeSource.external("507")
                      element(e::Required,    "Health Care Claim Status Code")          # @todo: CodeSource.external("508")
                      element(e::Situational, "Entity Identifier Qualifier", b::Values("1P"))
                      element(e::NotUsed,     "Code List Qualifier Code")
                    end # composite value
                    element(e::NotUsed,     "Free-form Message Text")
                  end # Segment/STC - Provider Status Information
                end # Loop/2200C - Provider of Service Trace Identifier
              end # Loop/2000C Service Provider Level
            end # Table/2 - Service Provider Detail
            table_detail("2 - Subscriber Detail") do
              loop_("2000D SUBSCRIBER LEVEL", d::RepeatCount.unbounded) do
                segment(100, s::HL, "Subscriber Level", r::Situational, d::RepeatCount.bounded(1)) do
                  element(e::Required,    "Hierarchical ID Number")
                  element(e::Required,    "Hierarchical Parent ID Number")
                  element(e::Required,    "Hierarchical Level Code", values("22"))
                  element(e::Required,    "Hierachical Child Code", values("0", "1"))
                end # Segment/HL - Subscriber Level

                loop_("2100D SUBSCRIBER NAME", d::RepeatCount.bounded(1)) do
                  segment(500, s::NM1, "Subscriber Name", r::Required, d::RepeatCount.bounded(1)) do
                    element(e::Required,    "Entity Identifier Code", values("IL"))
                    element(e::Required,    "Entity Type Qualifier", values("1", "2"))
                    element(e::Required,    "Subscriber Last Name")
                    element(e::Situational, "Subscriber First Name")
                    element(e::Situational, "Subscriber Middle Name or Initial")
                    element(e::NotUsed,     "Name Prefix")
                    element(e::Situational, "Subscriber Name Suffix")
                    element(e::Required,    "Identification Code Qualifier", values("24", "II", "MI"))
                    element(e::Required,    "Subscriber Identifier")
                    element(e::NotUsed,     "Entity Relationship Code")
                    element(e::NotUsed,     "Entity Identifier Code")
                    element(e::NotUsed,     "Name Last or Organization Name")
                  end # Segment/NM1 - Subscriber Name
                end # Loop/2100D - Subscriber name
                loop_("2200D CLAIM STATUS TRACKING NUMBER", d::RepeatCount.unbounded) do
                  segment(900, s::TRN, "Claim Status Tracking Number", r::Situational, d::RepeatCount.bounded(1)) do
                    element(e::Required,    "Trace Type Code", values("2"))
                    element(e::Required,    "Referenced Transaction Trace Number")
                    element(e::NotUsed,     "Originating Company Identifier")
                    element(e::NotUsed,     "Reference Identification")
                  end # Segment/TRN - Claim Status Tracking Number
                  segment(1000, s::STC, "Claim Level Status Information", r::Required, d::RepeatCount.unbounded) do
                    composite(e::Required,    "HEALTH CARE CLAIM STATUS") do
                      element(e::Required,    "Health Care Claim Status Category Code")
                      element(e::Required,    "Health Care Claim Status Code")
                      element(e::Situational, "Entity Identifier Code", values(*entity_values))
                      element(e::Situational, "Code List Qualifier Code", values("RX"))
                    end # Composite/Health care claim status
                    element(e::Required,    "Status Information Effective Date")
                    element(e::NotUsed,     "Action Code")
                    element(e::Situational, "Total Claim Charge Amount")
                    element(e::Situational, "Claim Payment Amount")
                    element(e::Situational, "Adjudication Finalized Date")
                    element(e::NotUsed,     "Payment Method Code")
                    element(e::Situational, "Remittance Date")
                    element(e::Situational, "Remittance Trace Number")
                    composite(e::Situational, "HEALTH CARE CLAIM STATUS") do
                      element(e::Required,    "Health Care Claim Status Category Code")
                      element(e::Required,    "Health Care Claim Status Code")
                      element(e::Situational, "Entity Identifier Code", values(*entity_values))
                      element(e::Situational, "Code List Qualifier Code", values("RX"))
                    end # Composite/Health Care Claim Status
                    composite(e::Situational, "HEALTH CARE CLAIM STATUS") do
                      element(e::Required,    "Health Care Claim Status Category Code")
                      element(e::Required,    "Health Care Claim Status Code")
                      element(e::Situational, "Entity Identifier Code", values(*entity_values))
                      element(e::Situational, "Code List Qualifier Code", values("RX"))
                    end # Composite/Health Care Claim Status
                    element(e::NotUsed, "Free Form Message Text")
                  end # Segment/STC - Claim Level Status Information
                  segment(1100, s::REF, "Payer Claim Control Number", r::Situational, d::RepeatCount.bounded(1)) do
                    element(e::Required,    "Reference Identification Qualifier", values("1K"))
                    element(e::Required,    "Payer Claim Control Number")
                    element(e::NotUsed,     "Description")
                    element(e::NotUsed,     "REFERENCE IDENTIFIER")
                  end # Segment/REF - Payer Claim Control Number
                  segment(1100, s::REF, "Institutional Bill Type Identification", r::Situational, d::RepeatCount.bounded(1)) do
                    element(e::Required,    "Reference Identification Qualifier", values("BLT"))
                    element(e::Required,    "Bill Type Identifier")
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
                    element(e::Required,    "Voucher Identifier")
                    element(e::NotUsed,     "Description")
                    element(e::NotUsed,     "REFERENCE IDENTIFIER")
                  end # Segment/REF - Voucher Identifier
                  segment(1100, s::REF, "Claim Identifier Number for Clearinghous and Other Transmission Intermediaries", r::Situational, d::RepeatCount.bounded(1)) do
                    element(e::Required,    "Reference Identification Qualifier", values("D9"))
                    element(e::Required,    "Clearinghouse Trace Number")
                    element(e::NotUsed,     "Description")
                    element(e::NotUsed,     "REFERENCE IDENTIFIER")
                  end # Segment/REF - Claim Identifier Number for Clearinghouses and...
                  segment(1200, s::DTP, "Claim Level Service Date", r::Situational, d::RepeatCount.bounded(1)) do
                    element(e::Required,    "Date Time Qualifier", values("472"))
                    element(e::Required,    "Date Time Period Format Qualifier", values("D8", "RD8"))
                    element(e::Required,    "Claim Service Period")
                  end # Segment/DTP - Claim Level Service Date

                  loop_("2220D SERVICE LINE INFORMATION", d::RepeatCount.unbounded) do
                    segment(1800, s::SVC, "Service Line Information", r::Situational, d::RepeatCount.bounded(1)) do
                      composite(e::Required,    "COMPOSITE MEDICAL PROCEDURE IDENTIFIER") do
                        element(e::Required,    "Product or Service ID Qualifier", values("AD", "ER", "HC", "HP", "IV", "NU", "WK"))
                        element(e::Required,    "Procedure Code")
                        element(e::Situational, "Procedure Modifier")
                        element(e::Situational, "Procedure Modifier")
                        element(e::Situational, "Procedure Modifier")
                        element(e::Situational, "Procedure Modifier")
                        element(e::NotUsed,     "Description")
                        element(e::NotUsed,     "Product/Service ID")
                      end # composite/medical procedure identifier
                      element(e::Required,    "Line Item Charge Amount")
                      element(e::Required,    "Line Item Payment Amount")
                      element(e::Situational, "Revenue Code")
                      element(e::NotUsed,     "Quantity")
                      element(e::NotUsed,     "COMPOSITE MEDICAL PROCEDURE IDENTIFIER")
                      element(e::Required, "Units of Service Count")
                    end # Segment/SVC - Service Line Information

                    segment(1900, s::STC, "Service Line Level Status Information", r::Required, d::RepeatCount.unbounded) do
                      composite(e::Required, "HEALTH CARE CLAIM STATUS") do
                        element(e::Required,    "Health Care Claim Status Category Code") # @todo: CodeSource.external("507")
                        element(e::Required,    "Health Care Claim Status Code")          # @todo: CodeSource.external("508")
                        element(e::Situational, "Entity Identifier Code", values(*entity_values))
                        element(e::Situational, "Code List Qualifier Code", values("RX"))
                      end # composite/ health care claim status
                      element(e::Required,    "Statue Information Effective Date")
                      element(e::NotUsed,     "Action Code")
                      element(e::NotUsed,     "Monetary Amount")
                      element(e::NotUsed,     "Monetary Amount")
                      element(e::NotUsed,     "Date")
                      element(e::NotUsed,     "Payment Method Code")
                      element(e::NotUsed,     "Date")
                      element(e::NotUsed,     "Check Number")
                      composite(e::Situational, "HEALTH CARE CLAIM STATUS") do
                        element(e::Required,    "Health Care Claim Status Category Code") # @todo: CodeSource.external("507")
                        element(e::Required,    "Health Care Claim Status Code")          # @todo: CodeSource.external("508")
                        element(e::Situational, "Entity Identifier Code", values(*entity_values))
                        element(e::Situational, "Code List Qualifier Code", values("RX"))
                      end # composite/Health care claims
                      composite(e::Situational, "HEALTH CARE CLAIM STATUS") do
                        element(e::Required,    "Health Care Claim Status Category Code")
                        element(e::Required,    "Health Care Claim Status Code")
                        element(e::Situational, "Entity Identifier Code", values(*entity_values))
                        element(e::Situational, "Code List Qualifier Code", values("RX"))
                      end # composite/Health care claim status
                      element(e::NotUsed, "Free Form Message Text")
                    end # Segment/STC - Service Line Level Information
                    segment(2000, s::REF, "Service Line Item Identification", r::Situational, d::RepeatCount.bounded(1)) do
                      element(e::Required,    "Reference Identification Qualifier", values("FJ"))
                      element(e::Required,    "Line Item Control Number")
                      element(e::NotUsed,     "Description")
                      element(e::NotUsed,     "REFERENCE IDENTIFIER")
                    end # Segment/REF - Service Line item Identification
                    segment(2100, s::DTP, "Service Line Date", r::Required, d::RepeatCount.bounded(1)) do
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
                    element(e::Required,    "Patient Last Name")
                    element(e::Situational, "Patient First Name")
                    element(e::Situational, "Patient Last Name")
                    element(e::NotUsed,     "Name Prefix")
                    element(e::Situational, "Patient Name Suffix")
                    element(e::NotUsed,     "Identification Code Qualifier")
                    element(e::NotUsed,     "Subscriber Identification Number")
                    element(e::NotUsed,     "Entity Relationship Code")
                    element(e::NotUsed,     "Entity Identifier Code")
                    element(e::NotUsed,     "Name Last or Organization Name")
                  end # Segment/NM1 - Dependent Name
                end # Loop/2100D - Subscriber name
                loop_("2200E CLAIM STATUS TRACKING NUMBER", d::RepeatCount.unbounded) do
                  segment(900, s::TRN, "Claim Status Tracking Number", r::Required, d::RepeatCount.bounded(1)) do
                    element(e::Required,    "Trace Type Code", values("2"))
                    element(e::Required,    "Reference Transaction Trace Number")
                    element(e::NotUsed,     "Originating Company Identifier")
                    element(e::NotUsed,     "Reference Identification")
                  end # Segment/TRN - Claim Status Tracking Number
                  segment(1000, s::STC, "Claim Level Status Information", r::Required, d::RepeatCount.unbounded) do
                    composite(e::Required,  "HEALTH CARE CLAIM STATUS") do
                      element(e::Required,    "Health Care Claim Status Category Code")
                      element(e::Required,    "Status Code")
                      element(e::Situational, "Entity Identifier Code", values(*entity_values))
                      element(e::Situational, "Code List Qualifier Code", values("RX"))
                    end # Composite/Health care claim status
                    element(e::Required,    "Status Information Effective Date")
                    element(e::NotUsed,     "Action Code")
                    element(e::Situational, "Total Claim Charge Amount")
                    element(e::Situational, "Claim Payment Amount")
                    element(e::Situational, "Adjudication Finalized Date")
                    element(e::NotUsed,     "Payment Method Code")
                    element(e::Situational, "Remittance Date")
                    element(e::Situational, "Remittance Trace Number")
                    composite(e::Situational, "HEALTH CARE CLAIM STATUS") do
                      element(e::Required,    "Health Care Claim Status Category Code")
                      element(e::Required,    "Health Care Claim Status Code")
                      element(e::Situational, "Entity Identifier Code", values(*entity_values))
                      element(e::Situational, "Code List Qualifier Code", values("RX"))
                    end # Composite/Health Care Claim Status
                    composite(e::Situational, "HEALTH CARE CLAIM STATUS") do
                      element(e::Required,    "Health Care Claim Status Category Code")
                      element(e::Required,    "Health Care Claim Status Code")
                      element(e::Situational, "Entity Identifier Code", values(*entity_values))
                      element(e::Situational, "Code List Qualifier Code", values("RX"))
                    end # Composite/Health Care Claim Status
                    element(e::NotUsed,     "Free Form Message Text")
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
                  segment(1200, s::DTP, "Claim Level Service Date", r::Situational, d::RepeatCount.bounded(1)) do
                    element(e::Required,    "Date Time Qualifier", values("472"))
                    element(e::Required,    "Date Time Period Format Qualifier", values("D8", "RD8"))
                    element(e::Required,    "Claim Service Period")
                  end # Segment/DTP - Claim Level Service Date

                  loop_("2220E SERVICE LINE INFORMATION", d::RepeatCount.unbounded) do
                    segment(1800, s::SVC, "Service Line Information", r::Situational, d::RepeatCount.bounded(1)) do
                      composite(e::Required,    "COMPOSITE MEDICAL PROCEDURE IDENTIFIER") do
                        element(e::Required,    "Product or Service ID Qualifier", values("AD", "ER", "HC", "HP", "IV", "NU", "WK"))
                        element(e::Required,    "Procedure Code")
                        element(e::Situational, "Procedure Modifier")
                        element(e::Situational, "Procedure Modifier")
                        element(e::Situational, "Procedure Modifier")
                        element(e::Situational, "Procedure Modifier")
                        element(e::NotUsed,     "Description")
                        element(e::NotUsed,     "Product/Service ID")
                      end # composite/medical procedure identifier
                      element(e::Required,    "Line Item Charge Amount")
                      element(e::Required,    "Line Item Payment Amount")
                      element(e::Situational, "Revenue Code")
                      element(e::NotUsed,     "Quantity")
                      element(e::NotUsed,     "COMPOSITE MEDICAL PROCEDURE IDENTIFIER")
                      element(e::Required,    "Units of Service Count")
                    end # Segment/SVC - Service Line Information
                    segment(1900, s::STC, "Service Line Level Status Information", r::Required, d::RepeatCount.unbounded) do
                      composite(e::Required,    "HEALTH CARE CLAIM STATUS") do
                        element(e::Required,    "Health Care Claim Status Category Code") # @todo: CodeSource.external("507")
                        element(e::Required,    "Status Code")          # @todo: CodeSource.external("508")
                        element(e::Situational, "Entity Identifier Code", values(*entity_values))
                        element(e::Situational, "Code List Qualifier Code", values("RX"))
                      end # composite/ health care claim status
                      element(e::Required,    "Status Information Effective Date")
                      element(e::NotUsed,     "Action Code")
                      element(e::NotUsed,     "Monetary Amount")
                      element(e::NotUsed,     "Monetary Amount")
                      element(e::NotUsed,     "Date")
                      element(e::NotUsed,     "Payment Method Code")
                      element(e::NotUsed,     "Date")
                      element(e::NotUsed,     "Check Number")
                      composite(e::Situational, "HEALTH CARE CLAIM STATUS") do
                        element(e::Required,    "Health Care Claim Status Category Code") # @todo: CodeSource.external("507")
                        element(e::Required,    "Status Code")          # @todo: CodeSource.external("508")

                        element(e::Situational, "Entity Identifier Code", values(*entity_values))
                        element(e::Situational, "Code List Qualifier Code", values("RX"))
                      end # composite/Health care claims
                      composite(e::Situational, "HEALTH CARE CLAIM STATUS") do
                        element(e::Required,    "Health Care Claim Status Category Code")
                        element(e::Required,    "Health Care Claim Status Code")
                        element(e::Situational, "Entity Identifier Code", values(*entity_values))
                        element(e::Situational, "Code List Qualifier Code", values("RX"))
                      end # composite/Health care claim status
                      element(e::NotUsed,     "Free Form Message Text")
                    end # Segment/STC - Service Line Level Information
                    segment(2000, s::REF, "Service Line Item Identification", r::Situational, d::RepeatCount.bounded(1)) do
                      element(e::Required,    "Reference Identification Qualifier", values("FJ"))
                      element(e::Required,    "Line Item Control Number")
                      element(e::NotUsed,     "Description")
                      element(e::NotUsed,     "REFERENCE IDENTIFIER")
                    end # Segment/REF - Service Line item Identification
                    segment(2100, s::DTP, "Service Line Date", r::Required, d::RepeatCount.bounded(1)) do
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
