module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module ElementDefs

          t = ElementTypes
          r = ElementReqs
          s = Schema

          E2    = t::Nn.new(:E2   , "Number of Accepted Transaction Sets"  , 1, 6, 0)
          E19   = t::AN.new(:E19  , "City Name"                            , 2, 30)
          E26   = t::ID.new(:E26  , "Country Code"                         , 2, 3,
            s::CodeList.external("5"))

          E28   = t::Nn.new(:E28  , "Group Control Number"                 , 1, 9, 0)
          E61   = t::AN.new(:E61  , "Free-form Information"                , 1, 30)
          E66   = t::ID.new(:E66  , "Identification Code Qualifier"        , 1, 2,
            s::CodeList.build(
              "1"  => s::CodeList.external("16"),
              "9"  => s::CodeList.external("16"),
              "21" => s::CodeList.external("121"),
              "34" => "Social Security Number",
              "38" => s::CodeList.external("5"),
              "46" => "Electronic Transmitter Identification Number (ETIN)",
              "51" => s::CodeList.external("51"),
              "AC" => "Attachment Control Number",
              "AD" => "Blue Cross Blue Shield Associtation Plan Code",
              "BD" => "Blue Cross Provider Number",
              "BS" => "Blue Shield Provider Number",
              "C"  => "Insured's Changed Unique Identification Number",
              "CF" => s::CodeList.external("91"),
              "FI" => "Fediral Taxpayer's Identification Number",
              "HN" => "Health Insurance Claim (HIC) Number",
              "II" => "Standard Unique Health Identifier for each Individual in the United States",
              "LD" => s::CodeList.external("457"),
              "LE" => s::CodeList.external("102"),
              "NI" => "National Association of Insurance Commisioners (NAIC) Identification",
              "MI" => "Member Identification Number",
              "MC" => "Medicaid Provider",
              "MR" => "Medicaid Recipient Identification Number",
              "PC" => "Provider Commercial Number",
              "PI" => "Payor Identification",
              "PP" => "Pharmacy Processor Number",
              "SJ" => s::CodeList.external("22"),
              "SL" => "State License Number",
              "UP" => "Unique Physician Identification Number (UPIN)",
              "XV" => s::CodeList.external("540"),
              "XX" => s::CodeList.external("537")))

          E67   = t::AN.new(:E67  , "Identification Code"                  , 2, 80)
          E81   = t:: R.new(:E81  , "Weight"                               , 1, 10)
          E93   = t::AN.new(:E93  , "Name"                                 , 1, 60)
          E96   = t::Nn.new(:E96  , "Number of Included Segments"          , 1, 10, 0)
          E97   = t::Nn.new(:E97  , "Number of Transaction Sets Included"  , 1, 6, 0)
          E98   = t::ID.new(:E98  , "Entity Identifier Code"               , 2, 3,
            s::CodeList.build(
              "03"  => "Dependent",
              "1P"  => "Provider",
              "1Z"  => "Home Health Care",
              "36"  => "Employer",
              "40"  => "Receiver",
              "41"  => "Submitter",
              "45"  => "Drop-off Location",
              "71"  => "Attending Physician",
              "72"  => "Operating Physician",
              "73"  => "Other Physician",
              "74"  => "Corrected Insured",
              "77"  => "Service Location",
              "82"  => "Rendering Provider",
              "85"  => "Billing Provider",
              "87"  => "Pay-to Provider",
              "98"  => "Receiver",
              "AY"  => "Clearinghouse",
              "DK"  => "Ordering Physician",
              "DN"  => "Referring Provider",
              "DQ"  => "Supervising Physician",
              "FA"  => "Facility",
              "GB"  => "Other Insured",
              "HK"  => "Subscriber",
              "IL"  => "Insured or Subscriber",
              "LI"  => "Independent Lab",
              "MSC" => "Mammography Screening Center",
              "P3"  => "Primary Care Provider",
              "PE"  => "Payee",
              "PR"  => "Payer",
              "PRP" => "Primary Payer",
              "PW"  => "Pickup Address",
              "TT"  => "Transfer To",
              "QB"  => "Purchase Service Provider",
              "QC"  => "Patient",
              "QD"  => "Responsible Party",
              "SEP" => "Secondary Payer",
              "TL"  => "Testing Laboratory",
              "TTP" => "Tertiary Payer",
              "TU"  => "Third Party Repricing Organization (TPO)"))

          E100  = t::ID.new(:E100 , "Currency Code"                        , 3, 3,
            s::CodeList.external("5"))

          E116  = t::ID.new(:E116 , "Postal Code"                          , 3, 15,
            s::CodeList.external("51"),
            s::CodeList.external("166"))

          E118  = t:: R.new(:E118 , "Rate"                                 , 1, 9)
          E123  = t::Nn.new(:E123 , "Number of Received Transaction Sets"  , 1, 6, 0)
          E124  = t::AN.new(:E124 , "Application Receiver's Code"          , 2, 15)
          E127  = t::AN.new(:E127 , "Reference Identification"             , 1, 50)
          E128  = t::ID.new(:E128 , "Reference Identification Qualifier"   , 2, 3,
            s::CodeList.build(
              "04"  => s::CodeList.external("91"),
              "0B"  => "State License Number",
              "0K"  => "Policy Form Identifying Number",
              "1A"  => "Blue Cross Provider Number",
              "1B"  => "Blue Shield Provider Number",
              "1C"  => "Medicare Provider Number",
              "1D"  => "Medicaid Provider Number",
              "1G"  => "Provider UPIN Number",
              "1H"  => "CHAMPUS Identification Number",
              "1J"  => "Facility ID Number",
              "1K"  => "Payor's Claim Number",
              "1L"  => "Group or Policy Number",
              "1S"  => "Ambulatory Patient Group (APG) Number",
              "1W"  => "Member Identification Number",
              "28"  => "Employee Identification Number",
              "2U"  => "Payer Identification Number",
              "4N"  => "Special Payment Reference Number",
              "6P"  => "Group Number",
              "6R"  => "Provider Control Number",
              "9A"  => "Repriced Claim Reference Number",
              "9B"  => "Repriced Line Item Reference Number",
              "9C"  => "Adjusted Repriced Claim Reference Number",
              "9D"  => "Adjusted Repriced Line Item Reference Number",
              "9F"  => "Referral Number",
              "ABY" => s::CodeList.external("540"),
              "AP"  => "Ambulatory Payment Classification",
              "APC" => s::CodeList.external("468"),
              "BB"  => "Authorization Number",
              "BLT" => "Billing Type",
              "BT"  => "Batch Number",
              "CE"  => "Class of Contract Code",
              "CPT" => s::CodeList.external("133"),
              "D3"  => s::CodeList.external("307"),
              "D9"  => "Claim Number",
              "DNS" => s::CodeList.external("16"),
              "DUN" => s::CodeList.external("16"),
              "E9"  => "Attachment Code",
              "EA"  => "Medical Record Identification Number",
              "EI"  => "Employer's Identification Number",
              "EO"  => "Submitter Identification Number",
              "EV"  => "Receiver Identification Number",
              "EW"  => "Mammography Certification Number",
              "F2"  => "Version Code - Local",
              "F4"  => "Facility Certification Number",
              "F5"  => "Medicare Version Code",
              "F8"  => "Original Reference Number",
              "FJ"  => "Line Item Control Number",
              "FY"  => "Claim Office Number",
              "G1"  => "Prior Authorization Number",
              "G2"  => "Provider Commercial Number",
              "G3"  => "Predetermination of Benefits Identification Number",
              "HI"  => s::CodeList.external("121"),
              "HPI" => s::CodeList.external("537"),
              "ICD" => s::CodeList.external("131"),
              "IG"  => "Insurance Policy Number",
              "LOI" => s::CodeList.external("663"),
              "LU"  => "Location Number",
              "LX"  => "Qualified Products List",
              "MRC" => s::CodeList.external("844"),
              "NF"  => s::CodeList.external("245"),
              "P4"  => "Project Code",
              "PQ"  => "Payee Indentification",
              "PXC" => s::CodeList.external("682"),
              "RB"  => "Rate code number",
              "SY"  => "Social Security Number",
              "T4"  => "Signal Code",
              "TJ"  => "Federal Taxpayer's Identification Number",
              "VY"  => "Link Sequence Number",
              "Y4"  => "Agency Claim Number",
              "X4"  => "Clinical Laboratory Improvement Amendment Number",
              "XZ"  => "Pharmacy Prescription Number"))

          E142  = t::AN.new(:E142 , "Application's Sender Code"            , 2, 3)
          E143  = t::ID.new(:E143 , "Transaction Set Identifier Number"    , 3, 3,
            s::CodeList.build(
              "277" => "Health Care Information Status Notification",
              "835" => "Health Care Claim Payment/Advice",
              "837" => "Health Care Claim",
              "999" => "Implementation Acknowledgement"))

          E156  = t::ID.new(:E156 , "State or Province Code"               , 2, 2,
            s::CodeList.external("22"))

          E166  = t::AN.new(:E166 , "Address Information"                  , 1, 55)
          E212  = t:: R.new(:E212 , "Unit Price"                           , 1, 17)
          E234  = t::AN.new(:E234 , "Product/Service ID"                   , 1, 48)
          E235  = t::ID.new(:E235 , "Product/Service ID Qualifier"         , 2, 2,
            s::CodeList.build(
              "AD" => s::CodeList.external("135"),
              "A5" => s::CodeList.external("22"),
              "CH" => s::CodeList.external("5"),
              "CJ" => s::CodeList.external("135"),
              "DC" => s::CodeList.external("897"),
              "DX" => s::CodeList.external("131"),
              "EN" => "EAN/UCC - 13",
              "EO" => "EAN/UCC - 8",
              "ER" => s::CodeList.external("576"),
              "HC" => s::CodeList.external("130"),
              "HP" => s::CodeList.external("716"),
              "ID" => s::CodeList.external("131"),
              "IP" => s::CodeList.external("896"),
              "IV" => s::CodeList.external("513"),
              "HI" => "HIBC (Health Care Industry Bar Code) Supplier Labeling Standard Primary Data Message",
              "LB" => s::CodeList.external("663"),
              "N1" => s::CodeList.external("240"),
              "N2" => s::CodeList.external("240"),
              "N3" => s::CodeList.external("240"),
              "N4" => s::CodeList.external("240"),
              "N5" => s::CodeList.external("240"),
              "N6" => s::CodeList.external("240"),
              "NU" => s::CodeList.external("132"),
              "ON" => "Customer Order Number",
              "TD" => s::CodeList.external("359"),
              "UI" => "U.P.C. Consumer Package (1-5-5)",
              "UK" => "GTIN 14-digit Data Structure",
              "UP" => "UCC - 12",
              "RB" => s::CodeList.external("132"),
              "WK" => s::CodeList.external("843")))

          E236  = t::ID.new(:E236 , "Price Identifier Code"                , 3, 3)
          E280  = t:: R.new(:E280 , "Exchange Rate"                        , 4, 10)
          E289  = t::Nn.new(:E289 , "Multiple Price Quantity"              , 1, 2, 0)
          E305  = t::ID.new(:E305 , "Transaction Handling Code"            , 1, 2,
            s::CodeList.build(
              "C" => "Payment Accompanies Remittance Advice",
              "D" => "Make Payment Only",
              "H" => "Notification Only",
              "I" => "Remittance Information Only",
              "P" => "Prenotification of Future Transfers",
              "U" => "Split Payment and Remittance",
              "X" => "Handling Party's Option to Split Payment and Remittance"))

          E306  = t::ID.new(:E306 , "Action Code"                          , 1, 2,
            s::CodeList.build(
              "U"  => "Reject",
              "WQ" => "Accept"))

          E309  = t::ID.new(:E309 , "Location Qualifier"                   , 1, 2,
            s::CodeList.build(
              "PQ" => s::CodeList.external("51"),
              "PR" => s::CodeList.external("51"),
              "PS" => s::CodeList.external("51"),
              "RJ" => s::CodeList.external("DOD1")))

          E310  = t::ID.new(:E310 , "Location Identifier"                  , 1, 30)
          E329  = t::ID.new(:E329 , "Transaction Set Control Number"       , 4, 9)
          E332  = t:: R.new(:E332 , "Percent, Decimal Format"              , 1, 6)
          E337  = t::TM.new(:E337 , "Time"                                 , 4, 8)
          E338  = t:: R.new(:E338 , "Terms Discount Percent"               , 1, 6)
          E350  = t::AN.new(:E350 , "Assigned Identification"              , 1, 20)
          E352  = t::AN.new(:E352 , "Description"                          , 1, 80)
          E353  = t::ID.new(:E353 , "Transaction Set Purpose Code"         , 2, 2,
            s::CodeList.build(
              "00" => "Original",
              "08" => "Status",
              "18" => "Reissue"))

          E355  = t::ID.new(:E355 , "Unit or Basis for Measurement Code"   , 2, 2,
            s::CodeList.build(
              "01" => "Actual Pounds",
              "DA" => "Days",
              "DH" => "Miles",
              "F2" => "International Unit",
              "GR" => "Gram",
              "LB" => "Pound",
              "ME" => "Milligram",
              "MJ" => "Minutes",
              "ML" => "Milliliter",
              "MO" => "Months",
              "UN" => "Units"))

          E363  = t::ID.new(:E363 , "Note Reference Code"                  , 3, 3,
            s::CodeList.build(
              "ADD" => "Additional Information",
              "CER" => "Certification Narrative",
              "DCP" => "Goals, Rehabilitation Potential, or Discharge Plans",
              "DGN" => "Diagnosis Description",
              "TPO" => "Third Party Organization Notes"))

          E364  = t::AN.new(:E364 , "Communication Number"                 , 1, 256)
          E365  = t::ID.new(:E365 , "Communication Number Qualifier"       , 2, 2,
            s::CodeList.build(
              "EM" => "Electronic Mail",
              "EX" => "Telephone Extension",
              "FX" => "Facsimile",
              "TE" => "Telephone",
              "UR" => "Uniform Resource Locator (URL)"))

          E366  = t::ID.new(:E366 , "Contract Function Code"               , 2, 2,
            s::CodeList.build(
              "BL" => "Technical Department",
              "CX" => "Payers Claim Office",
              "IC" => "Information Contact"))

          E373  = t::DT.new(:E373 , "Date"                                 , 8, 8)
          E374  = t::ID.new(:E374 , "Date/Time Qualifier"                  , 3, 3,
            s::CodeList.build(
              "009" => "Process",
              "011" => "Shipped",
              "036" => "Expiration",
              "050" => "Received",
              "090" => "Report Start",
              "091" => "Report End",
              "096" => "Discharge",
              "150" => "Service Period Start",
              "151" => "Service Period End",
              "232" => "Claim Statement Period Start",
              "233" => "Claim Statement Period End",
              "296" => "Initial Disability Period Return To Work",
              "297" => "Initial Disability Period Last Day Worked",
              "304" => "Latest Visit or Consultation",
              "314" => "Disability",
              "360" => "Initial Disability Period Start",
              "361" => "Initial Disability Period End",
              "405" => "Production",
              "431" => "Onset of Current Symptoms or Illness",
              "435" => "Admission",
              "439" => "Accident",
              "444" => "First Visit or Consultation",
              "453" => "Acute Manifestation of a Chronic Condition",
              "454" => "Initial Treatment",
              "455" => "Last X-Ray",
              "461" => "Last Certification",
              "463" => "Begin Therapy",
              "471" => "Prescription",
              "472" => "Service",
              "484" => "Last Menstrual Period",
              "573" => "Date Claim Paid",
              "607" => "Certification Revision",
              "738" => "Most Recent Hemoglobin or Hematocrit or Both",
              "739" => "Most Recent Serum Creatine"))

          E380  = t:: R.new(:E380 , "Quantity"                             , 1, 15)
          E426  = t::ID.new(:E426 , "Adjustment Reason Code"               , 2, 2,
            s::CodeList.build(
              "50" => "Late Charge",
              "51" => "Interest Penalty Charge",
              "72" => "Authorized Return",
              "90" => "Early Payment Allowance",
              "AH" => "Origination Fee",
              "AM" => "Applied to Borrower's Account",
              "AP" => "Acceleration of Benefits",
              "B2" => "Rebate",
              "B3" => "Recovery Allowance",
              "BD" => "Bad Debt Adjustment",
              "BN" => "Bonus",
              "C5" => "Temporary Allowance",
              "CR" => "Capitation Interest",
              "CS" => "Adjustment",
              "CT" => "Capitation Payment",
              "CV" => "Capital Passthru",
              "CW" => "Certified Registered Nurse Anesthetist Passthru",
              "DM" => "Direct Medical Education Passthru",
              "E3" => "Withholding",
              "FB" => "Forwarding Balance",
              "FC" => "Fund Allocation",
              "GO" => "Graduate Medicale Education Passthru",
              "HM" => "Hemophelia Clotting Factor Supplement",
              "IP" => "Incentive Premium Payment",
              "IR" => "Internal Revenue Service Withholding",
              "IS" => "Interim Settlement",
              "J1" => "Nonreimbursable",
              "L3" => "Penalty",
              "L6" => "Interest Owed",
              "LE" => "Levy",
              "LS" => "Lump Sum",
              "OA" => "Organ Acquisition Passthru",
              "OB" => "Offset for Affiliated Providers",
              "PI" => "Periodic Interim Payment",
              "PL" => "Payment Final",
              "RA" => "Retro-activity Adjustment",
              "RE" => "Return on Equity",
              "SL" => "Student Loan Repayment",
              "TL" => "Third Party Liability",
              "WO" => "Overpayment Recovery",
              "WU" => "Unspecified Recovery"))

          E429  = t::AN.new(:E429 , "Check Number"                         , 1, 16)
          E443  = t::AN.new(:E443 , "Contract Inquiry Reference"           , 1, 20)
          E447  = t::AN.new(:E447 , "Loop Identifier Code"                 , 1, 4)
          E449  = t::AN.new(:E449 , "Fixed Format Information"             , 1, 80)
          E478  = t::ID.new(:E478 , "Credit/Debit Flag Code"               , 1, 1,
            s::CodeList.build(
              "C"   => "Credit",
              "D"   => "Debit",
              "ACH" => "Automated Clearing House (ACH)",
              "BOP" => "Financial Institution Option",
              "CHK" => "Check",
              "FWT" => "Federal Reserve Funds/Wire Transfer - Nonrepetitive",
              "NON" => "Non-Payment Data"))

          E479  = t::ID.new(:E479 , "Functional Identifier Code"           , 2, 2,
            s::CodeList.build(
              "FA" => "Functional or Implementation Acknowledgment Transaction Sets (997, 999)",
              "HC" => "Health Care Claim (837)",
              "HP" => "Health Care Claim Payment/Advice (835)"))

          E455  = t::ID.new(:E455 , "Responsible Agency Code"              , 1, 2,
            s::CodeList.build(
              "X" => "Accredited Standards Committee X12"))

          E480  = t::AN.new(:E480 , "Version / Release / Identifier Code"  , 1, 12,
            s::CodeList.external("881"))

          E481  = t::ID.new(:E481 , "Trace Type Code"                      , 1, 2,
            s::CodeList.build(
              "1" => "Current Transaction Trace Numbers",
              "2" => "Referenced Transaction Trace Numbers"))

          E499  = t::AN.new(:E499 , "Condition Value"                      , 1, 10)
          E506  = t::ID.new(:E506 , "DFI Identification Number Qualifier"  , 2, 2,
            s::CodeList.build(
              "01" => s::CodeList.external("4"),
              "04" => s::CodeList.external("91")))

          E507  = t::AN.new(:E507 , "DFI Identification Number"            , 3, 12,
            s::CodeList.external("60"))

          E508  = t::AN.new(:E508 , "Account Number"                       , 1, 35)
          E509  = t::AN.new(:E509 , "Originating Company Identifier"       , 10,10)
          E510  = t::AN.new(:E510 , "Originating Company Supplemental Code", 9, 9)
          E522  = t::ID.new(:E522 , "Amount Qualifier Code"                , 1, 3,
            s::CodeList.build(
              "A8"  => "Noncovered Charges - Actual",
              "AU"  => "Coverage Amount",
              "B6"  => "Allowed Amount",
              "D"   => "Payor Amount Paid",
              "D8"  => "Discount Amount",
              "DY"  => "Per Day Limit",
              "EAF" => "Amount Owed",
              "F4"  => "Postage Claimed",
              "F5"  => "Patient Amount Paid",
              "I"   => "Interest",
              "KH"  => "Deduction Amount",
              "NL"  => "Negative Ledger Balance",
              "T"   => "Tax",
              "T2"  => "Total Claim Before Taxes",
              "YU"  => "In Process",
              "YY"  => "Returned",
              "ZK"  => "Federal Medicare or Medicaid Payment Mandate Category 1",
              "ZL"  => "Federal Medicare or Medicaid Payment Mandate Category 2",
              "ZM"  => "Federal Medicare or Medicaid Payment Mandate Category 3",
              "ZN"  => "Federal Medicare or Medicaid Payment Mandate Category 4",
              "ZO"  => "Federal Medicare or Medicaid Payment Mandate Category 5"))

          E554  = t::Nn.new(:E554 , "Assigned Number"                      , 1, 6, 0)
          E559  = t::ID.new(:E559 , "Agency Qualifier Code"                , 2, 2,
            s::CodeList.build(
              "LB" => s::CodeList.external("407")))

          E569  = t::ID.new(:E569 , "Account Number Qualifier"             , 1, 3,
            s::CodeList.build(
              "DA" => "Demand Deposit",
              "SG" => "Savings"))

          E584  = t::ID.new(:E584 , "Employment Status Code"               , 2, 2)
          E591  = t::ID.new(:E591 , "Payment Method Code"                  , 3, 3)
          E594  = t::ID.new(:E594 , "Frequency Code"                       , 1, 1,
            s::CodeList.build(
              "1" => "Weekly",
              "4" => "Monthly",
              "6" => "Daily"))

          E609  = t::Nn.new(:E609 , "Count"                                , 1, 9, 0)
          E618  = t::ID.new(:E618 , "Implementation Transaction Set Syntax Error Code", 1, 3,
            s::CodeList.build(
              "1"  => "Transaction Set Not Supported",
              "2"  => "Transaction Set Trailer Missing",
              "3"  => "Transaction Set Control Number in Header and Trailer Do Not Match",
              "4"  => "Number of Included Segments Does Not Match Actual Content",
              "5"  => "One or More Segments in Error",
              "6"  => "Missing or Invalid Transaction Set Identifier",
              "7"  => "Missing or Invalid Transaction Set Control Number",
              "8"  => "Authentication Key Name Unknown",
              "9"  => "Encryption Key Name Unknown",
              "10" => "Requested Service (Authentication or Encrypted) Not Available",
              "11" => "Unknown Security Recipient",
              "12" => "Incorrect Message Length (Encryption Only)",
              "13" => "Message Authentication Code Failed",
              "15" => "Unknown Security Originator",
              "16" => "Syntax Error in Decrypted Text",
              "17" => "Security Not Supported",
              "18" => "Transaction Set not in Functional Group",
              "19" => "Invalid Transaction Set Implementation Convention Reference",
              "23" => "Transaction Set Control Number Not Unique within the Functional Group",
              "24" => "S3E Security End Segment Missing for S3S Security Start Segment",
              "25" => "S3S Security Start Segment Missing for S3E Security End Segment",
              "26" => "S4E Security End Segment Missing for S4S Security Start Segment",
              "27" => "S4S Security Start Segment Missing for S4E Security End Segment",
              "I5" => "Implementation One or More Segments In Error",
              "I6" => "Implementation Convention Not Supported"))


          E620  = t::ID.new(:E620 , "Implementation Segment Syntax Error Code", 1, 3,
            s::CodeList.build(
              "1"  => "Unrecognized segment ID",
              "2"  => "Unexpected segment",
              "3"  => "Required Segment Missing",
              "4"  => "Loop Occurs Over Maximum Times",
              "5"  => "Segment Exceeds Maximum Use",
              "6"  => "Segment Not in Defined Transaction Set",
              "7"  => "Segment Not in Proper Sequence",
              "8"  => "Segment Has Data Element Errors",
              "I4" => "Implementation 'Not Used' Segment Present",
              "I6" => "Implementation Dependent Segment Missing",
              "I7" => "Implementation Loop Occurs Under Minimum Times",
              "I8" => "Implementation Segment Below Minimum Use",
              "I9" => "Implementation Dependent 'Not Used' Segment Present"))

          E621  = t::ID.new(:E621 , "Implementation Data Element Syntax Error Code", 1, 3,
            s::CodeList.build(
              "1"   => "Required Data Element Missing",
              "2"   => "Conditional Required Data Element Missing",
              "3"   => "Too Many Data Elements",
              "4"   => "Data Element Too Short",
              "5"   => "Data Element Too Long",
              "6"   => "Invalid Character In Data Element",
              "7"   => "Invalid Code Value",
              "8"   => "Invalid Date",
              "9"   => "Invalid Time",
              "10"  => "Exclusion Conditional Violated",
              "12"  => "Too Many Repetitions",
              "13"  => "Too Many Components",
              "I6"  => "Code Value Not Used in Implementation",
              "I9"  => "Implementation Dependent Data Element Missing",
              "I10" => "Implementation 'Not Used' Data Element Present",
              "I11" => "Implementation Too Few Repetitions",
              "I12" => "Implementation Pattern Match Failure",
              "I13" => "Implementation Dependent 'Not Used' Data Element Present"))

          E623  = t::ID.new(:E623 , "Time Code"                            , 2, 2,
            s::CodeList.external("94"))

          E628  = t::AN.new(:E628 , "Hierachical ID Number"                , 1, 12)
          E639  = t::ID.new(:E639 , "Basis of Unit Price Code"             , 2, 2)
          E640  = t::ID.new(:E640 , "Transaction Type Code"                , 2, 2,
            s::CodeList.build(
              "31" => "Subrogation Demand",
              "CH" => "Chargeable",
              "DG" => "Response",
              "NO" => "Notice",
              "RP" => "Reporting",
              "RQ" => "Request",
              "TH" => "Receipt Acknowledgement Advice"))

          E648  = t::ID.new(:E648 , "Price Multiplier Qualifier"           , 3, 3)
          E649  = t:: R.new(:E649 , "Multiplier"                           , 1, 10)
          E659  = t::ID.new(:E659 , "Basis of Verification Code"           , 1, 2)
          E669  = t::ID.new(:E669 , "Currency Market/Exchnage Code"        , 3, 3)
          E673  = t::ID.new(:E673 , "Quantity Qualifier"                   , 2, 2,
            s::CodeList.build(
              "90" => "Acknowledged Quantity",
              "AA" => "Unacknowledged Quantity",
              "CA" => "Covered - Actual",
              "CD" => "Co-insured - Actual",
              "FL" => "Units",
              "LA" => "Life-time Reserve - Actual",
              "LE" => "Life-time Reserve - Estimated",
              "NE" => "Non-Covered Amount - Estimated",
              "NR" => "Not Replaced Blood Units",
              "OU" => "Outlier Days",
              "PS" => "Prescription",
              "PT" => "Patients",
              "QA" => "Quantity Approved",
              "QC" => "Quantity Disapproved",
              "VS" => "Visits",
              "ZK" => "Federal Medicare or Medicaid Payment Mandate Category 1",
              "ZL" => "Federal Medicare or Medicaid Payment Mandate Category 2",
              "ZM" => "Federal Medicare or Medicaid Payment Mandate Category 3",
              "ZN" => "Federal Medicare or Medicaid Payment Mandate Category 4",
              "ZO" => "Federal Medicare or Medicaid Payment Mandate Category 5"))

          E687  = t::ID.new(:E687 , "Class of Trade Code"                  , 2, 2)
          E704  = t::ID.new(:E704 , "Paperwork/Report Action Code"         , 1, 2)
            # @note Copied from an unverified 4010 internet source

          E706  = t::ID.new(:E706 , "Entity Relation Code"                 , 2, 2)
          E715  = t::ID.new(:E715 , "Functional Group Acknowledgment Code" , 1, 1,
            s::CodeList.build(
              "A" => "Accepted",
              "E" => "Accepted, But Errors Were Noted",
              "M" => "Rejected, Message Authentication Code (MAC) Failed",
              "P" => "Partially Accepted, At Least One Transaction Set Was Rejected",
              "R" => "Rejected",
              "W" => "Rejected, Assurance Failed Validity Tests",
              "X" => "Rejected, Content After Decryption Could Not Be Analyzed"))

          E716  = t::ID.new(:E716 , "Functional Group Syntax Error Code"   , 1, 3,
            s::CodeList.build(
              "1"  => "Functional Group Not Supported",
              "2"  => "Functional Group Version Not Supported",
              "3"  => "Functional Group Trailer Missing",
              "4"  => "Group Control Number in the Functional Group Header and Trailer Do Not Agree",
              "5"  => "Number of Included Transaction Sets Does Not Match Actual Count",
              "6"  => "Group Control Number Violates Syntax",
              "10" => "Authentication Key Name Unknown",
              "11" => "Encryption Key Name Unknown",
              "12" => "Requested Service (Authentication or Encryption) Not Available",
              "13" => "Unknown Security Recipient",
              "14" => "Unknown Security Originator",
              "15" => "Syntax Error in Decrypted Text",
              "16" => "Security Not Supported",
              "17" => "Incorrect Message Length (Encryption Only)",
              "18" => "Message Authentication Code Failed",
              "19" => "Functional Group Control Number not Unique within Interchange",
              "23" => "S3E Security End Segment Missing for S3S Security Start Segment",
              "24" => "S3S Security Start Segment Missing for S3E Security End Segment",
              "25" => "S4E Security End Segment Missing for S4S Security Start Segment",
              "26" => "S4S Security Start Segment Missing for S4E Security End Segment"))

          E717  = t::ID.new(:E717 , "Transaction Set Acknowledgment Code"  , 1, 1,
            s::CodeList.build(
              "A" => "Accepted",
              "E" => "Accepted But Errors Were Reported",
              "M" => "Rejected, Message Authentication Code (MAC) Failed",
              "R" => "Rejected",
              "W" => "Rejected, Assurance Failed Validity Tests",
              "X" => "Rejected, Content After Decryption Could Not Be Analyzed"))

          E719  = t::Nn.new(:E719 , "Segment Position in Transaction Set"  , 1, 10, 0)
          E721  = t::ID.new(:E721 , "Segment ID Code"                      , 2, 3)
            # S77

          E722  = t::Nn.new(:E722 , "Element Position in Segment"          , 1, 2, 0)
          E724  = t::AN.new(:E724 , "Copy of Bad Data Element"             , 1, 99)
          E725  = t::Nn.new(:E725 , "Data Element Reference Number"        , 1, 4, 0)
            # S77

          E734  = t::AN.new(:E734 , "Hierarchical Parent ID Number"        , 1, 12)
          E735  = t::ID.new(:E735 , "Hierarchical Level Code"              , 1, 2,
            s::CodeList.build(
              "19" => "Provider of Service",
              "20" => "Information Source",
              "21" => "Information Receiver",
              "22" => "Subscriber",
              "23" => "Dependent",
              "PT" => "Patient"))

          E736  = t::ID.new(:E736 , "Hierarchical Child Code"              , 1, 1,
            s::CodeList.build(
              "0" => "No Subordinate HL Segment in This Hierarchical Structure",
              "1" => "Additional Subordinate HL Data Segment in This Hierarchical Structure"))

          E737  = t::ID.new(:E737 , "Measurement Reference ID Code"        , 2, 2,
            s::CodeList.build(
              "OG" => "Original",
              "TR" => "Test Results"))

          E738  = t::ID.new(:E738 , "Measurement Qualifier"                , 2, 2,
            s::CodeList.build(
              "HT" => "Height",
              "R1" => "Hemoglobin",
              "R2" => "Hematocrit",
              "R3" => "Epoetin Starting Dosage",
              "R4" => "Creatinine"))

          E739  = t:: R.new(:E739 , "Measurement Value"                    , 1, 20)
          E740  = t:: R.new(:E740 , "Range Minimum"                        , 1, 20)
          E741  = t:: R.new(:E741 , "Range Maximum"                        , 1, 20)
          E752  = t::ID.new(:E752 , "Surface/Layer/Position Code"          , 2, 2)
          E753  = t::ID.new(:E753 , "Measurement Method or Device"         , 2, 4)
          E755  = t::ID.new(:E755 , "Report Type Code"                     , 2, 2,
            s::CodeList.build(
              "03" => "Report Justifying Treatment Beyond Utilization Guidelines",
              "04" => "Drugs Administered",
              "05" => "Treatment Diagnosis",
              "06" => "Initial Assesment",
              "07" => "Functional Goals",
              "08" => "Plan of Treatment",
              "09" => "Progress Report",
              "10" => "Continued Treatment",
              "11" => "Chemical Analysis",
              "13" => "Certified Test Report",
              "15" => "Justification for Admission",
              "21" => "Recovery Plan",
              "A3" => "Allergies/Sensitivies Document",
              "A4" => "Autopsy Report",
              "AM" => "Ambulance Certification",
              "AS" => "Admission Summary",
              "B2" => "Prescription",
              "B3" => "Physician Order",
              "B4" => "Referral Form",
              "BR" => "Benchmark Testing Results",
              "BS" => "Baseline",
              "BT" => "Blanket Test Results",
              "CB" => "Chiropractic Justification",
              "CK" => "Conset Form(s)",
              "CT" => "Certification",
              "D2" => "Drug Profile Document",
              "DA" => "Dental Models",
              "DB" => "Durable Medical Equipment Prescription",
              "DG" => "Diagnostic Report",
              "DJ" => "Discharge Monitoring Report",
              "DS" => "Discharge Summary",
              "EB" => "Explanation of Benefits (Coordination of Benefits or Medicare Secondary Payer)",
              "HC" => "Health Cerification",
              "HR" => "Health Clinic Records",
              "I5" => "Immunization Record",
              "IR" => "State School Immunization Records",
              "LA" => "Laboratory Results",
              "M1" => "Medical Record Attachment",
              "MT" => "Models",
              "NN" => "Nursing Notes",
              "OB" => "Operative Note",
              "OC" => "Oxygen Content Averaging Report",
              "OD" => "Orders and Treatments Document",
              "OE" => "Objective Physical Examination (including vital signs) Document",
              "OX" => "Oxygen Therapy Certification",
              "OZ" => "Support Data for Claim",
              "P4" => "Pathology Report",
              "P5" => "Patient Medical History Document",
              "PE" => "Parenteral or Enteral Certification",
              "PN" => "Physical Therapy Notes",
              "PO" => "Prosthetics or Orthotic Certification",
              "PQ" => "Paramedical Results",
              "PY" => "Physician's Report",
              "PZ" => "Physical Therapy Certification",
              "RB" => "Radiology Films",
              "RR" => "Radiology Reports",
              "RT" => "Report of Tests and Analysis Report",
              "RX" => "Renewable Oxygen Content Averaging Report",
              "SG" => "Symptoms Document",
              "V5" => "Death Notification",
              "XP" => "Photographs"))

          E756  = t::ID.new(:E756 , "Report Transmission Code"             , 1, 2,
            s::CodeList.build(
              "AA" => "Available on Request at Provider Site",
              "AB" => "Previously Submitted to Payer",
              "AD" => "Certification Included in this Claim",
              "AF" => "Narrative Segment Included in this Claim",
              "AG" => "No Documentation is Required",
              "BM" => "By Mail",
              "EL" => "Electronically Only",
              "EM" => "E-Mail",
              "FT" => "File Transfer",
              "FX" => "By Fax",
              "NS" => "Not Specified",
              "OL" => "On-Line"))

          E757  = t::Nn.new(:E757 , "Report Copies Needed"                 , 1, 2, 0)
          E782  = t:: R.new(:E782 , "Monetary Amount"                      , 1, 18)
          E799  = t::AN.new(:E799 , "Version Identifier"                   , 1, 30)
          E812  = t::ID.new(:E812 , "Payment Format Code"                  , 3, 3,
            s::CodeList.build(
              "CCP" => "Cash Concentration/Disbursement plus Addenda (CCD+)(ACH)",
              "CTX" => "Corporate Trade Exchange (CTX) (ACH)"))

          E901  = t::ID.new(:E901 , "Reject Reason Code"                   , 2, 2,
            s::CodeList.build(
              "T1" => "Cannot Identify Provider as TPO (Third Party Organization) Participant",
              "T2" => "Cannot Identify Payer as TPO (Third Party Organization) Participant",
              "T3" => "Cannot Identify Insured as TPO (Third Party Organization) Participant",
              "T4" => "Payer Name or Identifier Missing",
              "T5" => "Certification Information Missing",
              "T6" => "Claim does not contain enough information for re-pricing"))

          E923  = t::ID.new(:E923 , "Prognosis Code"                       , 1, 1)

          E933  = t::AN.new(:E933 , "Free-form Message Text"               , 1, 264)
          E935  = t::ID.new(:E935 , "Measurement Significance Code"        , 2, 2)
          E936  = t::ID.new(:E936 , "Measurement Attribute Code"           , 2, 2)
          E954  = t:: R.new(:E954 , "Percentage as Decimal"                , 1,  10)
          E1005 = t::ID.new(:E1005, "Hierarchical Structure Code"          , 4, 4,
            s::CodeList.build(
              "0019" => "Information Source, Subscriber, Dependent",
              "0085" => "Information Source, Information Receiver, Provider of Service, Patient"))

          E1018 = t:: R.new(:E1018, "Exponent"                             , 1, 15)
          E1028 = t::AN.new(:E1028, "Claim Submitter's Identifier"         , 1, 38)
          E1029 = t::ID.new(:E1029, "Claim Status Code"                    , 1, 2,
            s::CodeList.build(
              "1"  => "Processed as Primary",
              "2"  => "Processed as Secondary",
              "3"  => "Processed as Tertiary",
              "4"  => "Denied",
              "19" => "Processed as Primary, Forwarded to Additional Payer(s)",
              "20" => "Processed as Secondary, Forwarded to Additional Payer(s)",
              "21" => "Processed as Tertiary, Forwarded to Additional Payer(s)",
              "22" => "Reversal of Previous Payment",
              "23" => "Not Our Claim, Forwarded to Additional Payer(s)",
              "25" => "Predetermination Pricing Only - No Payment"))

          E1032 = t::ID.new(:E1032, "Claim Filing Indicator Code"          , 1, 2,
            s::CodeList.build(
              "11" => "Other Non-Federal Programs",
              "12" => "Preferred Provider Organization (PPO)",
              "13" => "Point of Service (POS)",
              "14" => "Exclusive Provider Organization (EPO)",
              "15" => "Indemnity Insurance",
              "16" => "Health Maintenance Organization (HMO) Medicare Risk",
              "17" => "Dentail Maintenance Organization",
              "AM" => "Automobile Medical",
              "BL" => "Blue Cross/Blue Shield",
              "CH" => "Champus",
              "CI" => "Commercial Insurance Co.",
              "DS" => "Disability",
              "FI" => "Federal Employees Program",
              "HM" => "Health Maintenance Organization",
              "LM" => "Liability Medical",
              "MA" => "Medicare Part A",
              "MB" => "Medicare Part B",
              "MC" => "Medicaid",
              "OF" => "Other Federal Program",
              "TV" => "Title V",
              "VA" => "Veterans Affairs Plan",
              "WC" => "Worker's Compensation Health Claim",
              "ZZ" => "Mutually Defined"))

          E1033 = t::ID.new(:E1033, "Claim Adjustment Group Code"          , 1, 12,
            s::CodeList.build(
              "CO" => "Contractual Obligations",
              "CR" => "Corrections and Reversals",
              "OA" => "Other adjustments",
              "PI" => "Payor Initiated Reductions",
              "PR" => "Patient Responsibility"))

          E1034 = t::ID.new(:E1034, "Claim Adjustment Reason Code"         , 1, 5,
            s::CodeList.external("139"))

          E1035 = t::AN.new(:E1035, "Name Last or Organization Code"       , 1, 60)
          E1036 = t::AN.new(:E1036, "Name First"                           , 1, 35)
          E1037 = t::AN.new(:E1037, "Name Middle"                          , 1, 25)
          E1038 = t::AN.new(:E1038, "Name Prefix"                          , 1, 10)
          E1039 = t::AN.new(:E1039, "Name Suffix"                          , 1, 10)
          E1048 = t::ID.new(:E1048, "Business Function Code"               , 1, 3)
          E1065 = t::ID.new(:E1065, "Entity Type Qualifier"                , 1, 1,
            s::CodeList.build(
              "1" => "Person",
              "2" => "Non-Person Entity"))

          E1066 = t::ID.new(:E1066, "Citizenship Status Code"              , 1, 2)
          E1067 = t::ID.new(:E1067, "Marital Status Code"                  , 1, 1)
          E1068 = t::ID.new(:E1068, "Gender Code"                          , 1, 1,
            s::CodeList.build(
              "F" => "Female",
              "M" => "Male",
              "U" => "Unknown"))

          E1069 = t::ID.new(:E1069, "Individual Relationship Code"         , 2, 2,
            s::CodeList.build(
              "01" => "Spouse",
              "18" => "Self",
              "19" => "Child",
              "20" => "Employee",
              "21" => "Unknown",
              "39" => "Organ Donor",
              "40" => "Cadaver Donor",
              "53" => "Life Partner",
              "G8" => "Other Relationship"))

          E1073 = t::ID.new(:E1073, "Yes/No Condition or Response Code"    , 1, 1,
            s::CodeList.build(
              "N" => "No",
              "Y" => "Yes",
              "W" => "Not Applicable"))

          E1109 = t::ID.new(:E1109, "Race or Ethnicity Code"               , 1, 1)
          E1136 = t::ID.new(:E1136, "Code Category"                        , 2, 2,
            s::CodeList.build(
              "07" => "Ambulance Certification",
              "09" => "Durable Medical Equipment Certification",
              "12" => "Medicare Secondary Working Aged Beneficiary or Spouse with Employer Group Health Plan",
              "13" => "Medicare Secondary End-Stage Renal Disease Beneficiary in Mandated Coordination Period with an Employer's Group Health Plan",
              "14" => "Medicare Secondary, No-fault Insurance including Auto is Primary",
              "15" => "Medicare Secondary Worker's Compensation",
              "16" => "Medicare Secondary Public Health Service (PHS) or Other Federal Agency",
              "41" => "Medicare Secondary Blank Lung",
              "42" => "Medicare Secondary Veteran's Administration",
              "43" => "Medicare Secondary Disabled Beneficiary Under Age 65 with Large Group Health Plan (LGHP)",
              "47" => "Medicare Secondary, Other Liability Insurance is Primary",
              "70" => "Hospice",
              "75" => "Functional Limitations",
              "E1" => "Spectacle Lenses",
              "E2" => "Contact Lenses",
              "E3" => "Spectacle Frames",
              "ZZ" => "Mutually Defined"))

          E1138 = t::ID.new(:E1138, "Payer Responsibility Sequence"        , 1, 1,
            s::CodeList.build(
              "P" => "Primary",
              "S" => "Secondary",
              "T" => "Tertiary",
              "U" => "Unknown",
              "A" => "Payer Responsibility Four",
              "B" => "Payer Responsibility Five",
              "C" => "Payer Responsibility Six",
              "D" => "Payer Responsibility Seven",
              "E" => "Payer Responsibility Eight",
              "F" => "Payer Responsibility Nine",
              "G" => "Payer Responsibility Ten",
              "H" => "Payer Responsibility Eleven"))

          E1143 = t::ID.new(:E1143, "Coordination of Benefits Code"        , 1, 1)
          E1166 = t::ID.new(:E1166, "Contract Type Code"                   , 2, 2,
            s::CodeList.build(
              "01" => "Diagnosis Related Group (DRG)",
              "02" => "Per Diem",
              "03" => "Variable Per Diem",
              "04" => "Flat",
              "05" => "Captitated",
              "06" => "Percent",
              "09" => "Other"))

          E1220 = t::ID.new(:E1220, "Student Status Code"                  , 1, 1)
          E1221 = t::ID.new(:E1221, "Provider Code"                        , 1, 3,
            s::CodeList.build(
              "BI" => "Billing",
              "PE" => "Performing"))

          E1222 = t::AN.new(:E1222, "Provider Specialty Code"              , 1, 3)
            # @note Copied from an unverified 4010 internet source

          E1223 = t::ID.new(:E1223, "Provider Organization Code"           , 3, 3)
          E1250 = t::ID.new(:E1250, "Date Time Period Format Qualifier"    , 2, 3,
            s::CodeList.build(
              "CC"  => "First Two Digits of Year Expressed in Format CCYY",
              "CD"  => "Month and Year Expressed in Format MMMYYY",
              "CM"  => "Date in Format CCYYMM",
              "CQ"  => "Date in Format CCYYQ",
              "CY"  => "Year Expressed in Format CCYY",
              "D6"  => "Date Expressed in Format YYMMDD",
              "D8"  => "Date Expressed in Format CCYYMMDD",
              "DA"  => "Range of Dates within a Single Month Expressed in Format DD-DD",
              "DB"  => "Date Expressed in Format MMDDCCYY",
              "DD"  => "Day of Month in Numeric Format",
              "DDT" => "Range of Dates and Time Expressed in Format CCYYMMDD-CCYYMMDDHHMM",
              "DT"  => "Date and Time Expressed in Format CCYYMMDDHHMM",
              "DTD" => "Range of Dates and Time Expressed in Format CCYYMMDDHHMM-CCYYMMDD",
              "DTS" => "Range of Date and Time Expressed in Format CCYYMMDDHHMMSS-CCYYMMDDHHMMSS",
              "EH"  => "Last Digit of Year and Julian Date Expressed in Format YDDD",
              "KA"  => "Date Expressed in Format YYMMMDD",
              "MD"  => "Month of Year and Day of Month Expressed in Format MMDD",
              "MM"  => "Month of Year in Numeric Format",
              "RD"  => "Range of Dates Expressed in Format MMDDCCYY-MMDDCCYY",
              "RD2" => "Range of Years Expressed in Format YY-YY",
              "RD4" => "Range of Years Expressed in Format CCYY-CCYY",
              "RD5" => "Range of Years and Months Expressed in Format CCYYMM-CCYYMM",
              "RD6" => "Range of Dates Expressed in Format YYMMDD-YYMMDD",
              "RD8" => "Range of Dates Expressed in Format CCYYMMDD-CCYYMMDD",
              "RDM" => "Range of Dates Expressed in Format YYMMDD-MMDD",
              "RDT" => "Range of Date and Time Expressed in Format CCYYMMDDHHMM-CCYYMMDDHHMM",
              "RMD" => "Range of Months and Days Expressed in Format MMDD-MMDD",
              "RMY" => "Range of Years and Months Expressed in Format YYMM-YYMM",
              "RTM" => "Range of Time Expressed in Format HHMM-HHMM",
              "RTS" => "Date and Time Expressed in Format CCYYMMDDHHMMSS",
              "TC"  => "Julian Date Expressed in Format DDD",
              "TM"  => "Time Expressed in Format HHMM",
              "TQ"  => "Date Expressed in Format MMYY",
              "TR"  => "Date and Time Expressed in Format DDMMYYHHMM",
              "TS"  => "Time Expressed in Format HHMMSS",
              "TT"  => "Date Expressed in Format MMDDYY",
              "TU"  => "Date EXpressed in Format YYDDD",
              "UN"  => "Unstructured",
              "YM"  => "Year and Month Expressed in Format YYMM",
              "YMM" => "Range of Year and Month Expressed in Format CCYYMM-MMM",
              "YY"  => "Last Two Digits of Year Expressed in Format CCYY"))

          E1251 = t::AN.new(:E1251, "Date Time Period"                     , 1, 35)
          E1270 = t::ID.new(:E1270, "Code List Qualifier Code"             , 1, 3,
            s::CodeList.build(
              "65"  => s::CodeList.external("508"),
              "68"  => s::CodeList.external("682"),
              "AAU" => s::CodeList.external("131"),
              "AAW" => s::CodeList.external("133"),
              "AAX" => s::CodeList.external("131"),
              "AAY" => s::CodeList.external("135"),
              "ABF" => s::CodeList.external("897"),
              "ABJ" => s::CodeList.external("897"),
              "ABK" => s::CodeList.external("897"),
              "ABN" => s::CodeList.external("897"),
              "ABU" => s::CodeList.external("897"),
              "ABV" => s::CodeList.external("897"),
              "ADD" => s::CodeList.external("897"),
              "APR" => s::CodeList.external("897"),
              "AS"  => s::CodeList.external("656"),
              "ASD" => s::CodeList.external("897"),
              "ATD" => s::CodeList.external("897"),
              "CAH" => s::CodeList.external("843"),
              "BBQ" => s::CodeList.external("896"),
              "BBR" => s::CodeList.external("896"),
              "BE"  => s::CodeList.external("132"),
              "BF"  => s::CodeList.external("131"),
              "BG"  => s::CodeList.external("132"),
              "BH"  => s::CodeList.external("132"),
              "BI"  => s::CodeList.external("132"),
              "BK"  => s::CodeList.external("131"),
              "BJ"  => s::CodeList.external("131"),
              "BN"  => s::CodeList.external("131"),
              "BO"  => s::CodeList.external("130"),
              "BP"  => s::CodeList.external("130"),
              "BQ"  => s::CodeList.external("131"),
              "BR"  => s::CodeList.external("131"),
              "BT"  => s::CodeList.external("407"),
              "BU"  => s::CodeList.external("407"),
              "BS"  => s::CodeList.external("133"),
              "DD"  => s::CodeList.external("131"),
              "DR"  => s::CodeList.external("229"),
              "EK"  => s::CodeList.external("407"),
              "GR"  => s::CodeList.external("284"),
              "GS"  => s::CodeList.external("407"),
              "GU"  => s::CodeList.external("407"),
              "GW"  => s::CodeList.external("407"),
              "HE"  => s::CodeList.external("411"),
              "HI"  => s::CodeList.external("121"),
              "HO"  => s::CodeList.external("537"),
              "JO"  => s::CodeList.external("135"),
              "JP"  => s::CodeList.external("135"),
              "LOI" => s::CodeList.external("663"),
              "NUB" => s::CodeList.external("132"),
              "NDC" => s::CodeList.external("240"),
              "PR"  => s::CodeList.external("131"),
              "PB"  => s::CodeList.external("407"),
              "REC" => s::CodeList.external("860"),
              "RET" => s::CodeList.external("859"),
              "RX"  => s::CodeList.external("530"),
              "S"   => s::CodeList.external("327"),
              "SD"  => s::CodeList.external("131"),
              "SJ"  => s::CodeList.external("407"),
              "SL"  => s::CodeList.external("407"),
              "TC"  => s::CodeList.external("359"),
              "TD"  => s::CodeList.external("131"),
              "TQ"  => s::CodeList.external("135"),
              "UT"  => s::CodeList.external("528")))

          E1271 = t::AN.new(:E1271, "Industry Code"                        , 1, 30,
            s::CodeList.external("508"))

          E1314 = t::ID.new(:E1314, "Admission Source Code"                , 1, 1,
            s::CodeList.external("230"))

          E1315 = t::ID.new(:E1315, "Admission Type Code"                  , 1, 1,
            s::CodeList.external("231"))

          E1316 = t::ID.new(:E1316, "Ambulance Transport Code"             , 1, 1)
          E1317 = t::ID.new(:E1317, "Ambulance Transport Reason Code"      , 1, 1,
            s::CodeList.build(
              "A" => "Patient was transported to nearest facility for care of symptoms, complaints, or both",
              "B" => "Patient was transported for the benefit of a preferred physician",
              "C" => "Patient was transported for the nearness of family members",
              "D" => "Patient was transported for the care of a specialist or for availability of specialized equipment",
              "E" => "Patient Transferred to Rehabilitation Facility"))

          E1321 = t::ID.new(:E1321, "Condition Indicator"                  , 2, 3,
            s::CodeList.build(
              "01" => "Patient was admitted to a hospital",
              "04" => "Patient was moved by stretcher",
              "05" => "Patient was unconscious or in shock",
              "06" => "Patient was transported in an emergency situation",
              "07" => "Patient had to be physically restrained",
              "08" => "Patient had visible hemorrhaging",
              "09" => "Ambulance service was medically necessary",
              "12" => "Patient is confined to a bed or chair",
              "38" => "Certification signed by the physician is on file at the supplier's office",
              "65" => "Open",
              "AV" => "Available - Not Used",
              "IH" => "Independent at Home",
              "L1" => "General Standard of 20 Degree or .5 Diopter Sphere or Cylinder Change Met",
              "L2" => "Replacement Due to Loss or Theft",
              "L3" => "Replacement Due to Breakage or Damage",
              "L4" => "Replacement Due to Patient Preference",
              "L5" => "Replacement Due to Medical Reason",
              "NU" => "Not Used",
              "S2" => "Under Treatment",
              "ST" => "New Services Requested",
              "ZV" => "Replacement Item"))

          E1322 = t::ID.new(:E1322, "Certification Type Code"              , 1, 1,
            s::CodeList.build(
              "I" => "Initial",
              "R" => "Renewal",
              "S" => "Revised"))

          E1325 = t::ID.new(:E1325, "Claim Frequency Type Code"            , 1, 1,
            s::CodeList.external("235"))

          E1327 = t::ID.new(:E1327, "Copay Status Code"                    , 1, 1,
            s::CodeList.build(
              "0" => "Copay exempt"))

          E1328 = t::Nn.new(:E1328, "Diagnosis Code Pointer"               , 1, 2, 0)
          E1331 = t::AN.new(:E1331, "Facility Code Value"                  , 1, 2)
            # S237

          E1332 = t::ID.new(:E1332, "Facility Code Qualifier"              , 1, 2,
            s::CodeList.build(
              "A" => s::CodeList.external("236"),
              "B" => s::CodeList.external("237")))

          E1333 = t::ID.new(:E1333, "Record Format Code"                   , 1, 2)
          E1334 = t::ID.new(:E1334, "Professional Shortage Area Code"      , 1, 1)
          E1335 = t::ID.new(:E1335, "Insulin Type Code"                    , 1, 3)
          E1336 = t::ID.new(:E1336, "Insurance Type Code"                  , 1, 3,
            s::CodeList.build(
              "02" => "Physically Handicapped Children's Program",
              "03" => "Special Federal Funding",
              "05" => "Disability",
              "09" => "Second Opinion or Surgery",
              "12" => "Medicare Secondary Working Aged Beneficiary or Spouse with Employer Group Health Plan",
              "13" => "Medicare Secondary End-Stage Renal Disease Beneficiary in the Mandated Coordination Period",
              "14" => "Medicare Secondary, No-fault Insurance including Auto is Primary",
              "15" => "Medicare Secondary Worker's Compensation",
              "16" => "Medicare Secondary Public Health Service (PHS) or Other Federal Agency",
              "41" => "Medicare Secondary Blank Lung",
              "42" => "Medicare Secondary Veteran's Administration",
              "43" => "Medicare Secondary Disabled Beneficiary Under Age 65 with Large Group Health Plan (LGHP)",
              "47" => "Medicare Secondary, Other Liability Insurance is Primary"))

          E1337 = t::ID.new(:E1337, "Level of Care Code"                   , 1, 1)
          E1338 = t::ID.new(:E1338, "Level of Service Code"                , 1, 3)
          E1339 = t::AN.new(:E1339, "Procedure Modifier"                   , 2, 2)
          E1340 = t::ID.new(:E1340, "Multiple Procedure Code"              , 1, 2)
          E1341 = t::AN.new(:E1341, "National or Local Assigned Review"    , 1, 2)
          E1342 = t::ID.new(:E1342, "Nature of Condition Code"             , 1, 1,
            s::CodeList.build(
              "A" => "Acute Condition",
              "C" => "Chronic Condition",
              "D" => "Non-acute",
              "E" => "Non-Life Threatening",
              "F" => "Routine",
              "G" => "Symptomatic",
              "M" => "Acute Manifestation of a Chronic Condition"))

          E1343 = t::ID.new(:E1343, "Non-Institutional Claim Type Code"    , 1, 2)
          E1345 = t::ID.new(:E1345, "Nursing Home Residential Status Code" , 1, 1)
          E1351 = t::ID.new(:E1351, "Patient Signature Source Code"        , 1, 1,
            s::CodeList.build(
              "P" => "Signature generated by provider because the patient was not physically present for services"))

          E1352 = t::ID.new(:E1352, "Patient Status Code"                  , 1, 2,
            s::CodeList.external("239"))

          E1354 = t::ID.new(:E1354, "Diagnosis Related Group (DRG) Code"   , 1, 4,
            s::CodeList.external("229"))

          E1358 = t::ID.new(:E1358, "Prosthesis, Crown, or Inlay Code"     , 1, 1)
          E1359 = t::ID.new(:E1359, "Provider Accept Assignment Code"      , 1, 1,
            s::CodeList.build(
              "A" => "Assigned",
              "B" => "Assigned Accepted on Clinical Lab Services Only",
              "C" => "Not Assigned"))

          E1360 = t::ID.new(:E1360, "Provider Agreement Code"              , 1, 1)
          E1361 = t::ID.new(:E1361, "Oral Cavity Designation Code"         , 1, 3,
            s::CodeList.external("135"))

          E1362 = t::ID.new(:E1362, "Related-Causes Code"                  , 2, 3,
            s::CodeList.build(
              "AA" => "Auto Accident",
              "EM" => "Employment",
              "OA" => "Other Accident"))

          E1363 = t::ID.new(:E1363, "Release of Information Code"          , 1, 1,
            s::CodeList.build(
              "I" => "Informed Consent to Release Medical Information for Conditions or Diagnoses Regulated by Federal Statutes",
              "Y" => "Yes, Provider has a Signed Statement Permitting Release of Medical Billing Data Related to a Claim"))

          E1364 = t::ID.new(:E1364, "Review Code"                          , 1, 2)
          E1365 = t::ID.new(:E1365, "Service Type Code"                    , 1, 2)
          E1366 = t::ID.new(:E1366, "Special Program Code"                 , 2, 3)
          E1367 = t::ID.new(:E1367, "Sublaxation Level Code"               , 2, 3)
          E1368 = t::ID.new(:E1368, "Tooth Status Code"                    , 1, 2)
          E1369 = t::ID.new(:E1369, "Tooth Surface Code"                   , 1, 2)
          E1371 = t:: R.new(:E1371, "Unit Rate"                            , 1, 10)
          E1383 = t::ID.new(:E1383, "Claim Submission Reason Code"         , 2, 2)
          E1384 = t::ID.new(:E1384, "Patient Location Code"                , 1, 1)
          E1473 = t::ID.new(:E1473, "Pricing Methodology"                  , 2, 2,
            s::CodeList.build(
              "00" => "Zero Pricing (Not Covered Under Contract)",
              "01" => "Priced as Billed at 100%",
              "02" => "Priced at the Standard Fee Schedule",
              "03" => "Priced at a Contractual Percentage",
              "04" => "Bundled Pricing",
              "05" => "Peer Review Pricing",
              "06" => "Per Diem Pricing",
              "07" => "Flat Rate Pricing",
              "08" => "Combination Pricing",
              "09" => "Maternity Pricing",
              "10" => "Other Pricing",
              "11" => "Lower of Cost",
              "12" => "Ratio of Cost",
              "13" => "Cost Reimbursed",
              "14" => "Adjustment Pricing"))

          E1514 = t::ID.new(:E1514, "Delay Reason Code"                    , 1, 2,
            s::CodeList.build(
              "1"  => "Proof of Eligibility Unknown or Unavailable",
              "2"  => "Litigation",
              "3"  => "Authorization Delays",
              "4"  => "Delay in Certifying Provider",
              "5"  => "Delay in Shipping Billing Forms",
              "6"  => "Delay in Delivery of Custom-made Appliances",
              "7"  => "Third Party Processing Delay",
              "8"  => "Delay in Eligibility Determination",
              "9"  => "Original Claim Rejected or Denied Due to a Reason Unrelated to the Billing Limitation Rules",
              "10" => "Administration Delay in the Prior Approval Process",
              "11" => "Other",
              "15" => "Natural Disaster"))

          E1525 = t::ID.new(:E1525, "Request Category Code"                , 1, 2)
          E1526 = t::ID.new(:E1526, "Policy Compliance Code"               , 1, 2,
            s::CodeList.build(
              "1" => "Procedure Followed (Compliance)",
              "2" => "Not Followed - Call Not Made (Non-Compliance Call Not Made)",
              "3" => "Not Medically Necessary (Non-Compliance Non-Medically Necessary)",
              "4" => "Not Followed Other (Non-Compliance Other)",
              "5" => "Emergency Admit to Non-Network Hospital"))

          E1527 = t::ID.new(:E1527, "Exception Code"                       , 1, 2,
            s::CodeList.build(
              "1" => "Non-Network Professional Provider in Network Hospital",
              "2" => "Emergency Care",
              "3" => "Services or Specialist not in Network",
              "4" => "Out-of-Service Area",
              "5" => "State Mandates",
              "6" => "Other"))

          E1528 = t::Nn.new(:E1528, "Component Data Element Position in Composite", 1, 2, 0)
          E1686 = t::Nn.new(:E1686, "Repeating Data Element Position"      , 1, 4, 0)
          E1705 = t::AN.new(:E1705, "Implementation Convention Reference"  , 1, 35)
          E1715 = t::ID.new(:E1715, "Country Subdivision Code"             , 1, 3,
            s::CodeList.external("5"))

          E9998 = t::AN.new(:E9998, "Context Reference"                    , 1, 35)
          E9999 = t::AN.new(:E9998, "Context Name"                         , 1, 35)

          C001 = Schema::CompositeElementDef.build(:C001,
            "Composite Unit of Measure",
            "To identify a composite unit of measure",
            E355 .component_use(r::Mandatory),
            E1018.component_use(r::Optional),
            E649 .component_use(r::Optional),
            E355 .component_use(r::Optional),
            E1018.component_use(r::Optional),
            E649 .component_use(r::Optional),
            E355 .component_use(r::Optional),
            E1018.component_use(r::Optional),
            E649 .component_use(r::Optional),
            E355 .component_use(r::Optional),
            E1018.component_use(r::Optional), # If not used, value is interpreted as 1
            E649 .component_use(r::Optional), # If not used, value is interpreted as 1
            E355 .component_use(r::Optional),
            E1018.component_use(r::Optional), # If not used, value is interpreted as 1
            E649 .component_use(r::Optional)) # If not used, value is interpreted as 1

          # @note Copied from an unverified 4010 internet source
          C002 = Schema::CompositeElementDef.build(:C002,
            "Actions Indicated",
            "",
            E704.component_use(r::Mandatory),
            E704.component_use(r::Optional),
            E704.component_use(r::Optional),
            E704.component_use(r::Optional),
            E704.component_use(r::Optional))

          C003 = Schema::CompositeElementDef.build(:C003,
            "Composite Medical Procedure Identifier",
            "To identify a procedure by its standardized codes and applicable modifiers",
            E235 .component_use(r::Mandatory),
            E234 .component_use(r::Mandatory), # Qualified by C003-01
            E1339.component_use(r::Optional),
            E1339.component_use(r::Optional),
            E1339.component_use(r::Optional),
            E1339.component_use(r::Optional),
            E352 .component_use(r::Optional),
            E234 .component_use(r::Optional)) # Qualified by C003-01

          C004 = Schema::CompositeElementDef.build(:C004,
            "Composite Diagnosis Code Pointer",
            "To identify one or more diagnosis code pointers",
            E1328.component_use(r::Mandatory),
            E1328.component_use(r::Optional),
            E1328.component_use(r::Optional),
            E1328.component_use(r::Optional))

          C005 = Schema::CompositeElementDef.build(:C005,
            "Tooth Surface",
            "To identify one or more tooth surface codes",
            E1369.component_use(r::Mandatory),
            E1369.component_use(r::Optional),
            E1369.component_use(r::Optional),
            E1369.component_use(r::Optional),
            E1369.component_use(r::Optional))

          C006 = Schema::CompositeElementDef.build(:C006,
            "Oral Cavity Designation",
            "To identify one or more areas of oral cavity",
            E1361.component_use(r::Mandatory),
            E1361.component_use(r::Optional),
            E1361.component_use(r::Optional),
            E1361.component_use(r::Optional),
            E1361.component_use(r::Optional))

          C022 = Schema::CompositeElementDef.build(:C022,
            "Health Care Code Information",
            "To send health care codes and their associated dates, amounts and quantities",
            E1270.component_use(r::Mandatory),
            E1271.component_use(r::Mandatory),
            E1250.component_use(r::Relational),
            E1251.component_use(r::Relational),
            E782 .component_use(r::Optional),
            E380 .component_use(r::Optional),
            E799 .component_use(r::Optional),
            E1271.component_use(r::Relational),
            E1073.component_use(r::Relational),
            SyntaxNotes::P.build(3, 4),
            SyntaxNotes::E.build(8, 9))

          C023 = Schema::CompositeElementDef.build(:C023,
            "Health Care Service Location Information",
            "To provide information that identifies the place of service or the type of bill related to the location at which a health care service was rendered",
            E1331 .component_use(r::Mandatory),
            E1332 .component_use(r::Optional),
            E1325 .component_use(r::Optional))

          C024 = Schema::CompositeElementDef.build(:C024,
            "Related Causes Information",
            "To identify one or more related causes and associated state or country information",
            E1362.component_use(r::Optional),
            E1362.component_use(r::Mandatory),
            E1362.component_use(r::Optional),
            E156 .component_use(r::Optional),
            E26  .component_use(r::Optional))

          C030 = Schema::CompositeElementDef.build(:C030,
            "Position in Segment",
            "Code indicating the relative position of the simple data element or composite data structure in error within a segment, count beginning with 1 for the position immediately following the segment ID; additionally, indicating the relative position of a repeating structure in error, count beginning with 1 for the position immediately following the preceding element separator; additionally indicating the relative position of a component of a composite data structure in error, count beginning with 1 for the position following the preceding element or repetition separator",
            E722 .component_use(r::Mandatory),
            E1528.component_use(r::Optional),
            E1686.component_use(r::Optional))

          # @note Copied from an unverified 4010 internet source
          C035 = Schema::CompositeElementDef.build(:C035,
            "Provider Specialty Information",
            "",
            E1222.component_use(r::Mandatory),
            E559 .component_use(r::Optional),
            E1073.component_use(r::Optional))

          C040 = Schema::CompositeElementDef.build(:C040,
            "Reference Identifier",
            "To identify one or more reference numbers or identification numbers as specified by the Reference Qualifier",
            E128 .component_use(r::Mandatory),
            E127 .component_use(r::Mandatory),
            E128 .component_use(r::Relational),
            E127 .component_use(r::Relational),
            E128 .component_use(r::Relational),
            E127 .component_use(r::Relational),
            SyntaxNotes::P.build(3, 4),
            SyntaxNotes::P.build(5, 6))

          C042 = Schema::CompositeElementDef.build(:C042,
            "Adjustment Identifier",
            "To provide the category and identifying reference information for an adjustment",
            E426 .component_use(r::Mandatory),
            E127 .component_use(r::Optional))

          C043 = Schema::CompositeElementDef.build(:C043,
            "Health Care Claim Status",
            "Used to convey status of the entire claim or a specific service line",
            E1271.component_use(r::Mandatory),
            E1271.component_use(r::Mandatory),
            E98  .component_use(r::Optional),
            E1270.component_use(r::Optional))

          C056 = Schema::CompositeElementDef.build(:C056,
            "Composite Race or Ethnicity Information",
            "",
            E1109.component_use(r::Optional),
            E1270.component_use(r::Relational),
            E1271.component_use(r::Relational))

          C998 = Schema::CompositeElementDef.build(:C998,
            "Context Identification",
            "Holds information to identify a context",
            E9999.component_use(r::Mandatory),
            E9998.component_use(r::Optional))

          C999 = Schema::CompositeElementDef.build(:C999,
            "Reference in Segment",
            "To hold the reference number of a data element and optionally component data element within a composite",
            E725.component_use(r::Mandatory),
            E725.component_use(r::Mandatory))

        end
      end
    end
  end
end
