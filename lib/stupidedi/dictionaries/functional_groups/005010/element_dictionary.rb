module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module ElementDictionary

          # Snn:    ID elements linked to a code source "nn"
          # QQ=Snn: When qualifier element value is "QQ", the qualified element code source is nn

          E19   = AN.new("E19"  , "City Name"                            , "", 2, 30)
          E26   = ID.new("E26"  , "Country Code"                         , "", 2, 3)
            # S5

          E28   = ID.new("E28"  , "Group Control Number"                 , "", 1, 9)
          E61   = AN.new("E61"  , "Free-form Information"                , "", 1, 30)
          E66   = ID.new("E66"  , "Identification Code Qualifier"        , "", 1, 2)
            # 38=S5; SJ=S22; 16=SJ; XX=S537; XV=S540; SJ=S22
            #
            # 46 Electronic Transmitter Identification Number (ETIN)
            # AC Attachment Control Number
            # II Standard Unique Health Identifier for each Individual in the United States
            # MI Member Identification Number
            # PI Payor Identification
            # XV Centers for Medicare and Medicaid Services PlanID
            # XX Centers for Medicare and Medicaid Services National Provider Identifier

          E67   = AN.new("E67"  , "Identification Code"                  , "", 2, 80)
          E81   =  R.new("E81"  , "Weight"                               , "", 1, 10)
          E93   = AN.new("E93"  , "Name"                                 , "", 1, 60)
          E96   =  N.new("E96"  , "Number of Included Segments"          , "", 1, 10)
          E97   =  N.new("E97"  , "Number of Transaction Sets Included"  , "", 1, 6)
          E98   = ID.new("E98"  , "Entity Identifier Code"               , "", 2, 3)
            # 41 Submitter
            # 45 Drop-off Location
            # 77 Service Location
            # 82 Rendering Provider
            # 85 Billing Provider
            # 87 Pay-to Provider
            # 98 Receiver
            # DK Ordering Physician
            # DN Referring Provider
            # DQ Supervising Physician
            # IL Insured or Subscriber
            # P3 Primary Care Provider
            # PE Payee
            # PR Payer
            # PW Pickup Address
            # QB Purchase Service Provider
            # QC Patient

          E100  = ID.new("E100" , "Currency Code"                        , "", 3, 3)
            # S5

          E116  = ID.new("E116" , "Postal Code"                          , "", 3, 15)
            # S51, S932

          E118  =  R.new("E118" , "Rate"                                 , "", 1, 9)
          E124  = AN.new("E124" , "Application Receiver's Code"          , "", 2, 15)
          E127  = AN.new("E127" , "Reference Identification"             , "", 1, 50)
          E128  = ID.new("E128" , "Reference Identification Qualifier"   , "", 2, 3)
            # ICD=S131; NF=S245; HPI=S537; ABY=S540; PXC=S682; D3=E307; ICMB=ICMB; MRC=S844
            #
            # 0B  State License Number
            # 1G  Provider UPIN Number
            # 1J  Facility ID Number
            # 2U  Payer Identification Number
            # 4N  Special Payment Reference Number
            # 6R  Provider Control Number
            # 9A  Repriced Claim Reference Number
            # 9B  Repriced Line Item Reference Number
            # 9C  Adjusted Repriced Claim Reference Number
            # 9D  Adjusted Repriced Line Item Reference Number
            # 9F  Referral Number
            # BT  Batch Number
            # D9  Claim Number
            # EA  Medical Record Identification Number
            # EI  Employer's Identification Number
            # EW  Mammography Certification Number
            # F4  Facility Certification Number
            # F5  Medicare Version Code
            # F8  Original Reference Number
            # FY  Claim Office Number
            # G1  Prior Authorization Number
            # G2  Provider Commercial Number
            # LU  Location Number
            # LX  Qualified Products List
            # NF  National Association of Insurance Commisioners (NAIC) Code
            # P4  Project Code
            # PXC Health Care Provider Taxonomy Code
            # SY  Social Security Number
            # T4  Signal Code
            # VY  Link Sequence Number
            # Y4  Agency Claim Number
            # X4  Clinical Laboratory Improvement Amendment Number
            # XZ  Pharmacy Prescription Number

          E142  = AN.new("E142" , "Application's Sender Code"            , "", 2, 3)
          E143  = ID.new("E143" , "Transaction Set Identifier Number"    , "", 3, 3)
            # 837 Health Care Claim
          E156  = ID.new("E156" , "State or Province Code"               , "", 2, 2)
            # S22

          E166  = AN.new("E166" , "Address Information"                  , "", 1, 55)
          E212  =  R.new("E212" , "Unit Price"                           , "", 1, 17)
          E234  = AN.new("E234" , "Product/Service ID"                   , "", 1, 48)
          E235  = ID.new("E235" , "Product/Service ID Qualifier"         , "", 2, 2)
            # CH=S5; A5=S22; DX,ID=S131; AD=S135; ER=S576; DC=S897; HC=S130; NU,RB=S132; N1,N2,N3,N4,N5,N6=S240; IV=S513; HP=S716; WK=S843; IP=S896
            # ER Jurisdiction Specific Procedure and Supply Codes
            # HC Health Care Financing Administration Common Procedural Coding System (HCPCS) Codes
            # N4 National Drug Code in 5-4-2 Format
            # IV Home Infusion EDI Coalition (HIEC) Product/Service Code
            # WK Advanced Billing Concepts (ABC) Codes

          E236  = ID.new("E236" , "Price Identifier Code"                , "", 3, 3)
          E280  =  R.new("E280" , "Exchange Rate"                        , "", 4, 10)
          E289  =  N.new("E289" , "Multiple Price Quantity"              , "", 1, 2)
          E305  = ID.new("E305" , "Transaction Handling Code"            , "", 1, 2)
          E309  = ID.new("E309" , "Location Qualifier"                   , "", 1, 2)
            # PQ=S51; PR,PS=S51

          E310  = ID.new("E310" , "Location Identifier"                  , "", 1, 30)
          E329  = ID.new("E329" , "Transaction Set Control Number"       , "", 4, 9)
          E332  =  R.new("E332" , "Percent, Decimal Format"              , "", 1, 6)
          E337  = TM.new("E337" , "Time"                                 , "", 4, 8)
          E338  =  R.new("E338" , "Terms Discount Percent"               , "", 1, 6)
          E350  = AN.new("E350" , "Assigned Identification"              , "", 1, 20)
          E352  = AN.new("E352" , "Description"                          , "", 1, 80)
          E353  = ID.new("E353" , "Transaction Set Purpose Code"         , "", 2, 2)
            # 00 Original
            # 18 Reissue

          E355  = ID.new("E355" , "Unit or Basis for Measurement Code"   , "", 2, 2)
            # 01 Actual Pounds
            # DA Days
            # DH Miles
            # F2 International Unit
            # GR Gram
            # LB Pound
            # ME Milligram
            # MJ Minutes
            # ML Milliliter
            # MO Months
            # UN Units

          E363  = ID.new("E363" , "Note Reference Code"                  , "", 3, 3)
            # ADD Additional Information
            # CER Certification Narrative
            # DCP Goals, Rehabilitation Potential, or Discharge Plans
            # DGN Diagnosis Description
            # TPO Third Party Organization Notes

          E364  = AN.new("E364" , "Communication Number"                 , "", 1, 256)
          E365  = ID.new("E365" , "Communication Number Qualifier"       , "", 2, 2)
            # EM Electronic Mail
            # EX Telephone Extension
            # FX Facsimile
            # TE Telephone

          E366  = ID.new("E366" , "Contract Function Code"               , "", 2, 2)
            # IC Information Contact

          E373  = DT.new("E373" , "Date"                                 , "", 8, 8)
          E374  = ID.new("E374" , "Date/Time Qualifier"                  , "", 3, 3)
            # 011 Shipped
            # 050 Received
            # 090 Report Start
            # 091 Report End
            # 096 Discharge
            # 296 Initial Disability Period Return To Work
            # 297 Initial Disability Period Last Day Worked
            # 304 Latest Visit or Consultation
            # 314 Disability
            # 360 Initial Disability Period Start
            # 361 Initial Disability Period End
            # 431 Onset of Current Symptoms or Illness
            # 435 Admission
            # 439 Accident
            # 444 First Visit or Consultation
            # 453 Acute Manifestation of a Chronic Condition
            # 454 Initial Treatment
            # 455 Last X-Ray
            # 461 Last Certification
            # 463 Begin Therapy
            # 471 Prescription
            # 472 Service
            # 484 Last Menstrual Period
            # 607 Certification Revision
            # 738 Most Recent Hemoglobin or Hematocrit or Both
            # 739 Most Recent Serum Creatine

          E380  =  R.new("E380" , "Quantity"                             , "", 1, 15)
          E426  = ID.new("E426" , "Adjustment Reason Code"               , "", 2, 2)
          E443  = AN.new("E443" , "Contract Inquiry Reference"           , "", 1, 20)
          E449  = AN.new("E449" , "Fixed Format Information"             , "", 1, 80)
          E478  = ID.new("E478" , "Credit/Debit Flag Code"               , "", 1, 1)
          E479  = ID.new("E479" , "Functional Identifier Code"           , "", 2, 2)
          E455  = ID.new("E455" , "Responsible Agency Code"              , "", 1, 12)
          E480  = AN.new("E480" , "Version / Release / Identifier Code"  , "", 1, 12)
          E481  = ID.new("E481" , "Trace Type Code"                      , "", 1, 2)
          E499  = AN.new("E499" , "Condition Value"                      , "", 1, 10)
          E506  = ID.new("E506" , "DFI Identification Number Qualifier"  , "", 2, 2)
          E507  = AN.new("E507" , "DFI Identification Number"            , "", 3, 12)
          E508  = AN.new("E508" , "Account Number"                       , "", 1, 35)
          E509  = AN.new("E509" , "Originating Company Identifier"       , "", 10,10)
          E510  = AN.new("E510" , "Originating Company Supplemental Code", "", 9, 9)
          E522  = ID.new("E522" , "Amount Qualifier Code"                , "", 1, 3)
            # A8  Noncovered Charges - Actual
            # D   Payor Amount Paid
            # EAF Amount Owed
            # F4  Postage Claimed
            # F5  Patient Amount Paid
            # T   Tax

          E554  =  N.new("E554" , "Assigned Number"                      , "", 1, 6)
          E559  = ID.new("E559" , "Agency Qualifier Code"                , "", 2, 2) # LB=S407 @note Copied from an unverified 4010 internet source
          E569  = ID.new("E569" , "Account Number Qualifier"             , "", 1, 3)
          E584  = ID.new("E584" , "Employment Status Code"               , "", 2, 2)
          E591  = ID.new("E591" , "Payment Method Code"                  , "", 3, 3)
          E594  = ID.new("E594" , "Frequency Code"                       , "", 1, 1)
            # 1 Weekly
            # 4 Monthly
            # 6 Daily

          E609  =  N.new("E609" , "Count"                                , "", 1, 9)
          E623  = ID.new("E623" , "Time Code"                            , "", 2, 2)
          E628  = AN.new("E628" , "Hierachical ID Number"                , "", 1, 12)
          E639  = ID.new("E639" , "Basis of Unit Price Code"             , "", 2, 2)
          E640  = ID.new("E640" , "Transaction Type Code"                , "", 2, 2)
            # 31 Subrogation Demand
            # CH Chargeable
            # RP Reporting

          E648  = ID.new("E648" , "Price Multiplier Qualifier"           , "", 3, 3)
          E649  =  R.new("E649" , "Multiplier"                           , "", 1, 10)
          E659  = ID.new("E659" , "Basis of Verification Code"           , "", 1, 2)
          E669  = ID.new("E669" , "Currency Market/Exchnage Code"        , "", 3, 3)
          E673  = ID.new("E673" , "Quantity Qualifier"                   , "", 2, 2)
            # Patients
            # FL Units

          E687  = ID.new("E687" , "Class of Trade Code"                  , "", 2, 2)
          E704  = ID.new("E704" , "Paperwork/Report Action Code"         , "", 1, 2)
            # @note Copied from an unverified 4010 internet source

          E706  = ID.new("E706" , "Entity Relation Code"                 , "", 2, 2)
          E734  = AN.new("E734" , "Hierarchical Parent ID Number"        , "", 1, 12)
          E735  = ID.new("E735" , "Hierarchical Level Code"              , "", 1, 2)
            # 20 Information Source
            # 22 Subscriber
            # 23 Dependent

          E736  = ID.new("E736" , "Hierarchical Child Code"              , "", 1, 1)
            # 0 No Subordinate HL Segment in This Hierarchical Structure.
            # 1 Additional Subordinate HL Data Segment in This Hierarchical Structure.

          E737  = ID.new("E737" , "Measurement Reference ID Code"        , "", 2, 2)
            # OG Original
            # TR Test Results

          E738  = ID.new("E738" , "Measurement Qualifier"                , "", 2, 2)
            # HT Height
            # R1 Hemoglobin
            # R2 Hematocrit
            # R3 Epoetin Starting Dosage
            # R4 Creatinine

          E739  =  R.new("E739" , "Measurement Value"                    , "", 1, 20)
          E740  =  R.new("E740" , "Range Minimum"                        , "", 1, 20)
          E741  =  R.new("E741" , "Range Maximum"                        , "", 1, 20)
          E752  = ID.new("E752" , "Surface/Layer/Position Code"          , "", 2, 2)
          E753  = ID.new("E753" , "Measurement Method or Device"         , "", 2, 4)
          E755  = ID.new("E755" , "Report Type Code"                     , "", 2, 2)
            # 03 Report Justifying Treatment Beyond Utilization Guidelines
            # 04 Drugs Administered
            # 05 Treatment Diagnosis
            # 06 Initial Assesment
            # 07 Functional Goals
            # 08 Plan of Treatment
            # 09 Progress Report
            # 10 Continued Treatment
            # 11 Chemical Analysis
            # 13 Certified Test Report
            # 15 Justification for Admission
            # 21 Recovery Plan
            # A3 Allergies/Sensitivies Document
            # A4 Autopsy Report
            # AM Ambulance Certification
            # AS Admission Summary
            # B2 Prescription
            # B3 Physician Order
            # B4 Referral Form
            # BR Benchmark Testing Results
            # BS Baseline
            # BT Blanket Test Results
            # CB Chiropractic Justification
            # CK Conset Form(s)
            # CT Certification
            # D2 Drug Profile Document
            # DA Dental Models
            # DB Durable Medical Equipment Prescription
            # DG Diagnostic Report
            # DJ Discharge Monitoring Report
            # DS Discharge Summary
            # EB Explanation of Benefits (Coordination of Benefits or Medicare Secondary Payer)
            # HC Health Cerification
            # HR Health Clinic Records
            # I5 Immunization Record
            # LA Laboratory Results
            # M1 Medical Record Attachment
            # MT Models
            # NN Nursing Notes
            # OB Operative Note
            # OC Oxygen Content Averaging Report
            # OD Orders and Treatments Document
            # OE Objective Physical Examination (including vital signs) Document
            # OX Oxygen Therapy Certification
            # OZ Support Data for Claim
            # P4 Pathology Report
            # P5 Patient Medical History Document
            # PE Parenteral or Enteral Certification
            # PN Physical Therapy Notes
            # PO Prosthetics or Orthotic Certification
            # PQ Paramedical Results
            # PY Physician's Report
            # PZ Physical Therapy Certification
            # RB Radiology Films
            # RR Radiology Reports
            # RT Report of Tests and Analysis Report
            # RX Renewable Oxygen Content Averaging Report
            # SG Symptoms Document
            # V5 Death Notification
            # XP Photographs

          E756  = ID.new("E756" , "Report Transmission Code"             , "", 1, 2)
            # AA Available on Request at Provider Site
            # AB Previously Submitted to Payer
            # AD Certification Included in this Claim
            # AF Narrative Segment Included in this Claim
            # AG No Documentation is Required
            # BM By Mail
            # EL Electronically Only
            # EM E-Mail
            # FT File Transfer
            # FX By Fax
            # NS Not Specified

          E757  =  N.new("E757" , "Report Copies Needed"                 , "", 1, 2)
          E782  =  R.new("E782" , "Monetary Amount"                      , "", 1, 18)
          E799  = AN.new("E799" , "Version Identifier"                   , "", 1, 30)
          E812  = ID.new("E812" , "Payment Format Code"                  , "", 3, 3)
          E901  = ID.new("E901" , "Reject Reason Code"                   , "", 2, 2)
            # T1 Cannot Identify Provider as TPO (Third Party Organization) Participant
            # T2 Cannot Identify Payer as TPO (Third Party Organization) Participant
            # T3 Cannot Identify Insured as TPO (Third Party Organization) Participant
            # T4 Payer Name or Identifier Missing
            # T5 Certification Information Missing
            # T6 Claim does not contain enough information for re-pricing

          E923  = ID.new("E923" , "Prognosis Code"                       , "", 1, 1)

          E935  = ID.new("E935" , "Measurement Significance Code"        , "", 2, 2)
          E936  = ID.new("E936" , "Measurement Attribute Code"           , "", 2, 2)
          E954  =  R.new("E954" , "Percentage as Decimal"                , "", 1,  10)
          E1005 = ID.new("E1005", "Hierarchical Structure Code"          , "", 4, 4)
            # 0019 Information Source, Subscriber, Dependent

          E1018 =  R.new("E1018", "Exponent"                             , "", 1, 15)
          E1028 = AN.new("E1028", "Claim Submitter's Identifier"         , "", 1, 38)
          E1029 = ID.new("E1029", "Claim Status Code"                    , "", 1, 2)
          E1032 = ID.new("E1032", "Claim Filing Indicator Code"          , "", 1, 2)
            # 11 Other Non-Federal Programs
            # 12 Preferred Provider Organization (PPO)
            # 13 Point of Service (POS)
            # 14 Exclusive Provider Organization (EPO)
            # 15 Indemnity Insurance
            # 16 Health Maintenance Organization (HMO) Medicare Risk
            # 17 Dentail Maintenance Organization
            # AM Automobile Medical
            # BL Blue Cross/Blue Shield
            # CH Champus
            # CI Commercial Insurance Co.
            # DS Disability
            # FI Federal Employees Program
            # HM Health Maintenance Organization
            # LM Liability Medical
            # MA Medicare Part A
            # MB Medicare Part B
            # MC Medicaid
            # OF Other Federal Program
            # TV Title V
            # VA Veterans Affairs Plan
            # WC Worker's Compensation Health Claim
            # ZZ Mutually Defined

          E1033 = ID.new("E1033", "Claim Adjustment Group Code"          , "", 1, 12)
            # CO Contractual Obligations
            # CR Corrections and Reversals
            # OA Other adjustments
            # PI Payor Initiated Reductions
            # PR Patient Responsibility

          E1034 = ID.new("E1034", "Claim Adjustment Reason Code"         , "", 1, 5)
            # S139

          E1035 = AN.new("E1035", "Name Last or Organization Code"       , "", 1, 60)
          E1036 = AN.new("E1036", "Name First"                           , "", 1, 35)
          E1037 = AN.new("E1037", "Name Middle"                          , "", 1, 25)
          E1038 = AN.new("E1038", "Name Prefix"                          , "", 1, 10)
          E1039 = AN.new("E1039", "Name Suffix"                          , "", 1, 10)
          E1048 = ID.new("E1048", "Business Function Code"               , "", 1, 3)
          E1065 = ID.new("E1065", "Entity Type Qualifier"                , "", 1, 1)
            # 1 Person
            # 2 Non-Person Entity

          E1066 = ID.new("E1066", "Citizenship Status Code"              , "", 1, 2)
          E1067 = ID.new("E1067", "Marital Status Code"                  , "", 1, 1)
          E1068 = ID.new("E1068", "Gender Code"                          , "", 1, 1)
            # F Female
            # M Mail
            # U Unknown

          E1069 = ID.new("E1069", "Individual Relationship Code"         , "", 2, 2)
            # 01 Spouse
            # 18 Self
            # 19 Child
            # 20 Employee
            # 21 Unknown
            # 39 Organ Donor
            # 40 Cadaver Donor
            # 53 Life Partner
            # G8 Other Relationship

          E1073 = ID.new("E1073", "Yes/No Condition or Response Code"    , "", 1, 1)
            # N No
            # Y Yes
            # W Not Applicable

          E1109 = ID.new("E1109", "Race or Ethnicity Code"               , "", 1, 1)
          E1136 = ID.new("E1136", "Code Category"                        , "", 2, 2)
            # 07 Ambulance Certification
            # 09 Durable Medical Equipment Certification
            # 12 Medicare Secondary Working Aged Beneficiary or Spouse with Employer Group Health Plan
            # 13 Medicare Secondary End-Stage Renal Disease Beneficiary in Mandated Coordination Period with an Employer's Group Health Plan
            # 14 Medicare Secondary, No-fault Insurance including Auto is Primary
            # 15 Medicare Secondary Worker's Compensation
            # 16 Medicare Secondary Public Health Service (PHS) or Other Federal Agency
            # 41 Medicare Secondary Blank Lung
            # 42 Medicare Secondary Veteran's Administration
            # 43 Medicare Secondary Disabled Beneficiary Under Age 65 with Large Group Health Plan (LGHP)
            # 47 Medicare Secondary, Other Liability Insurance is Primary
            # 70 Hospice
            # 75 Functional Limitations
            # E1 Spectacle Lenses
            # E2 Contact Lenses
            # E3 Spectacle Frames
            # ZZ Mutually Defined

          E1138 = ID.new("E1138", "Payer Responsibility Sequence"        , "", 1, 1)
            # P Primary
            # S Secondary
            # T Tertiary
            # A Payer Responsibility Four
            # B Payer Responsibility Five
            # C Payer Responsibility Six
            # D Payer Responsibility Seven
            # E Payer Responsibility Eight
            # F Payer Responsibility Nine
            # G Payer Responsibility Ten
            # H Payer Responsibility Eleven

          E1143 = ID.new("E1143", "Coordination of Benefits Code"        , "", 1, 1)
          E1166 = ID.new("E1166", "Contract Type Code"                   , "", 2, 2)
            # 01 Diagnosis Related Group (DRG)
            # 02 Per Diem
            # 03 Variable Per Diem
            # 04 Flat
            # 05 Captitated
            # 06 Percent
            # 09 Other

          E1220 = ID.new("E1220", "Student Status Code"                  , "", 1, 1)
          E1221 = ID.new("E1221", "Provider Code"                        , "", 1, 3)
            # BI Billing
            # PE Performing

          E1222 = AN.new("E1222", "Provider Specialty Code"              , "", 1, 3)
            # @note Copied from an unverified 4010 internet source

          E1223 = ID.new("E1223", "Provider Organization Code"           , "", 3, 3)
          E1250 = ID.new("E1250", "Date Time Period Format Qualifier"    , "", 2, 3)
            # D8  Date Expressed in Format CCYYMMDD
            # RD8 Range of Dates Expressed in Format CCYYMMDD-CCYYMMDD

          E1251 = AN.new("E1251", "Date Time Period"                     , "", 1, 35)
          E1270 = ID.new("E1270", "Code List Qualifier Code"             , "", 1, 3)
            # BO,BP=S130; BF,BJ,BK,BN,BQ,BR,DD,PR,SD,TD,AAU,AAV,AAX=S131; JO,JP,TQ,AAY=S135; HE=S411; 68=S682; ABF,ABJ,ABK,APR,ASD,ATD=S897; BE,BG,BH,BI,NUB=S132; DR=S229; NDC=S240; HO=S513; CAH=S843; BBQ,BBR=S896; UT=S582; AS=S1270; GR=S284; BT,BU,EK,GS,GU,GW,NI,PB,SJ,SL
            # ABK Internal Classification of Diseases Clinical Modification (ICD-10-CM) Principal Diagnosis
            # ABF Internal Classification of Diseases Clinical Modification (ICD-10-CM) Diagnosis
            # AS  Form Type Code
            # BK  International Classification of Diseases Clinical Modification (ICD-9-CM) Principal Diagnosis
            # BF  International Classification of Diseases Clinical Modification (ICD-9-CM) Diagnosis
            # BG  Condition
            # BO  Health Care Financing Administration Common Procedural Coding System
            # BP  Health Care Financing Administration Common Procedural Coding System Principal Procedure
            # UT  Centers for Medicare and Medicaid Services (CMS) Durable Medical Equipment Regional Carrier (DMERC) Certificate of Medical Necessity (CMD) Forms

          E1271 = AN.new("E1271", "Industry Code"                        , "", 1, 30)
          E1314 = ID.new("E1314", "Admission Source Code"                , "", 1, 1)
            # S230

          E1315 = ID.new("E1315", "Admission Type Code"                  , "", 1, 1)
            # S231

          E1316 = ID.new("E1316", "Ambulance Transport Code"             , "", 1, 1)
          E1317 = ID.new("E1317", "Ambulance Transport Reason Code"      , "", 1, 1)
            # A Patient was transported to nearest facility for care of symptoms, complaints, or both
            # B Patient was transported for the benefit of a preferred physician
            # C Patient was transported for the nearness of family members
            # D Patient was transported for the care of a specialist or for availability of specialized equipment
            # E Patient Transferred to Rehabilitation Facility

          E1321 = ID.new("E1321", "Condition Indicator"                  , "", 2, 3)
            # 01 Patient was admitted to a hospital
            # 04 Patient was moved by stretcher
            # 05 Patient was unconscious or in shock
            # 06 Patient was transported in an emergency situation
            # 07 Patient had to be physically restrained
            # 08 Patient had visible hemorrhaging
            # 09 Ambulance service was medically necessary
            # 12 Patient is confined to a bed or chair
            # 38 Certification signed by the physician is on file at the supplier's office
            # 65 Open
            # AV Available - Not Used
            # IH Independent at Home
            # L1 General Standard of 20 Degree or .5 Diopter Sphere or Cylinder Change Met
            # L2 Replacement Due to Loss or Theft
            # L3 Replacement Due to Breakage or Damage
            # L4 Replacement Due to Patient Preference
            # L5 Replacement Due to Medical Reason
            # NU Not Used
            # S2 Under Treatment
            # ST New Services Requested
            # ZV Replacement Item

          E1322 = ID.new("E1322", "Certification Type Code"              , "", 1, 1)
            # I Initial
            # R Renewal
            # S Revised

          E1325 = ID.new("E1325", "Claim Frequency Type Code"            , "", 1, 1)
            # S235

          E1327 = ID.new("E1327", "Copay Status Code"                    , "", 1, 1)
            # 0 Copay exempt

          E1328 =  N.new("E1328", "Diagnosis Code Pointer"               , "", 1, 2)
          E1331 = AN.new("E1331", "Facility Code Value"                  , "", 1, 2)
          E1332 = ID.new("E1332", "Facility Code Qualifier"              , "", 1, 2)
            # B=S237
            # B Place of Service Codes for Professional or Dental Services

          E1333 = ID.new("E1333", "Record Format Code"                   , "", 1, 2)
          E1334 = ID.new("E1334", "Professional Shortage Area Code"      , "", 1, 1)
          E1335 = ID.new("E1335", "Insulin Type Code"                    , "", 1, 3)
          E1336 = ID.new("E1336", "Insurance Type Code"                  , "", 1, 3)
            # 02 Physically Handicapped Children's Program
            # 03 Special Federal Funding
            # 05 Disability
            # 09 Second Opinion or Surgery
            # 12 Medicare Secondary Working Aged Beneficiary or Spouse with Employer Group Health Plan
            # 13 Medicare Secondary End-Stage Renal Disease Beneficiary in the Mandated Coordination Period
            # 14 Medicare Secondary, No-fault Insurance including Auto is Primary
            # 15 Medicare Secondary Worker's Compensation
            # 16 Medicare Secondary Public Health Service (PHS) or Other Federal Agency
            # 41 Medicare Secondary Blank Lung
            # 42 Medicare Secondary Veteran's Administration
            # 43 Medicare Secondary Disabled Beneficiary Under Age 65 with Large Group Health Plan (LGHP)
            # 47 Medicare Secondary, Other Liability Insurance is Primary

          E1337 = ID.new("E1337", "Level of Care Code"                   , "", 1, 1)
          E1338 = ID.new("E1338", "Level of Service Code"                , "", 1, 3)
          E1339 = AN.new("E1339", "Procedure Modifier"                   , "", 2, 2)
          E1340 = ID.new("E1340", "Multiple Procedure Code"              , "", 1, 2)
          E1341 = AN.new("E1341", "National or Local Assigned Review"    , "", 1, 2)
          E1342 = ID.new("E1342", "Nature of Condition Code"             , "", 1, 1)
            # A Acute Condition
            # C Chronic Condition
            # D Non-acute
            # E Non-Life Threatening
            # F Routine
            # G Symptomatic
            # M Acute Manifestation of a Chronic Condition

          E1343 = ID.new("E1343", "Non-Institutional Claim Type Code"    , "", 1, 2)
          E1345 = ID.new("E1345", "Nursing Home Residential Status Code" , "", 1, 1)
          E1351 = ID.new("E1351", "Patient Signature Source Code"        , "", 1, 1)
            # P Signature generated by provider because the patient was not physically present for services

          E1352 = ID.new("E1352", "Patient Status Code"                  , "", 1, 2)
            # S239

          E1354 = ID.new("E1354", "Diagnosis Related Group (DRG) Code"   , "", 1, 4)
            # S229

          E1358 = ID.new("E1358", "Prosthesis, Crown, or Inlay Code"     , "", 1, 1)
          E1359 = ID.new("E1359", "Provider Accept Assignment Code"      , "", 1, 1)
            # A Assigned
            # B Assigned Accepted on Clinical Lab Services Only
            # C Not Assigned

          E1360 = ID.new("E1360", "Provider Agreement Code"              , "", 1, 1)
          E1361 = ID.new("E1361", "Oral Cavity Designation Code"         , "", 1, 3)
            # S135

          E1362 = ID.new("E1362", "Related-Causes Code"                  , "", 2, 3)
            # AA Auto Accident
            # EM Employment
            # QA Other Accident

          E1363 = ID.new("E1363", "Release of Information Code"          , "", 1, 1)
            # I Informed Consent to Release Medical Information for Conditions or Diagnoses Regulated by Federal Statutes
            # Y Yes, Provider has a Signed Statement Permitting Release of Medical Billing Data Related to a Claim

          E1364 = ID.new("E1364", "Review Code"                          , "", 1, 2)
          E1365 = ID.new("E1365", "Service Type Code"                    , "", 1, 2)
          E1366 = ID.new("E1366", "Special Program Code"                 , "", 2, 3)
          E1367 = ID.new("E1367", "Sublaxation Level Code"               , "", 2, 3)
          E1368 = ID.new("E1368", "Tooth Status Code"                    , "", 1, 2)
          E1369 = ID.new("E1369", "Tooth Surface Code"                   , "", 1, 2)
          E1371 = R .new("E1371", "Unit Rate"                            , "", 1, 10)
          E1383 = ID.new("E1383", "Claim Submission Reason Code"         , "", 2, 2)
          E1384 = ID.new("E1384", "Patient Location Code"                , "", 1, 1)
          E1473 = ID.new("E1473", "Pricing Methodology"                  , "", 2, 2)
            # 00 Zero Pricing (Not Covered Under Contract)
            # 01 Priced as Billed at 100%
            # 02 Priced at the Standard Fee Schedule
            # 03 Priced at a Contractual Percentage
            # 04 Bundled Pricing
            # 05 Peer Review Pricing
            # 07 Flat Rate Pricing
            # 08 Combination Pricing
            # 09 Maternity Pricing
            # 10 Other Pricing
            # 11 Lower of Cost
            # 12 Ratio of Cost
            # 13 Cost Reimbursed
            # 14 Adjustment Pricing

          E1514 = ID.new("E1514", "Delay Reason Code"                    , "", 1, 2)
            # 1  Proof of Eligibility Unknown or Unavailable
            # 2  Litigation
            # 3  Authorization Delays
            # 4  Delay in Certifying Provider
            # 5  Delay in Shipping Billing Forms
            # 6  Delay in Delivery of Custom-made Appliances
            # 7  Third Party Processing Delay
            # 8  Delay in Eligibility Determination
            # 9  Original Claim Rejected or Denied Due to a Reason Unrelated to the Billing Limitation Rules
            # 10 Administration Delay in the Prior Approval Process
            # 11 Other
            # 15 Natural Disaster

          E1525 = ID.new("E1525", "Request Category Code"                , "", 1, 2)
          E1526 = ID.new("E1526", "Policy Compliance Code"               , "", 1, 2)
            # 1 Procedure Followed (Compliance)
            # 2 Not Followed - Call Not Made (Non-Compliance Call Not Made)
            # 3 Not Medically Necessary (Non-Compliance Non-Medically Necessary)
            # 4 Not Followed Other (Non-Compliance Other)
            # 5 Emergency Admit to Non-Network Hospital

          E1527 = ID.new("E1527", "Exception Code"                       , "", 1, 2)
            # 1 Non-Network Professional Provider in Network Hospital
            # 2 Emergency Care
            # 3 Services or Specialist not in Network
            # 4 Out-of-Service Area
            # 5 State Mandates
            # 6 Other

          E1705 = AN.new("E1705", "Implementation Convention Reference"  , "", 1, 35)
          E1715 = ID.new("E1715", "Country Subdivision Code"             , "", 1, 3)
            # S5

          C001 = CompositeElementDef.new \
            "C001", "Composite Unit of Measure",
            "To identify a composite unit of measure",
            E355 .component_use(Mandatory),
            E1018.component_use(Optional),
            E649 .component_use(Optional),
            E355 .component_use(Optional),
            E1018.component_use(Optional),
            E649 .component_use(Optional),
            E355 .component_use(Optional),
            E1018.component_use(Optional),
            E649 .component_use(Optional),
            E355 .component_use(Optional),
            E1018.component_use(Optional), # If not used, value is interpreted as 1
            E649 .component_use(Optional), # If not used, value is interpreted as 1
            E355 .component_use(Optional),
            E1018.component_use(Optional), # If not used, value is interpreted as 1
            E649 .component_use(Optional)  # If not used, value is interpreted as 1

          # @note Copied from an unverified 4010 internet source
          C002 = CompositeElementDef.new \
            "C002", "Actions Indicated",
            "",
            E704.component_use(Mandatory),
            E704.component_use(Optional),
            E704.component_use(Optional),
            E704.component_use(Optional),
            E704.component_use(Optional)

          C003 = CompositeElementDef.new \
            "C003", "Composite Medical Procedure Identifier",
            "To identify a procedure by its standardized codes and applicable modifiers",
            E235 .component_use(Mandatory),
            E234 .component_use(Mandatory), # Qualified by C003-01
            E1339.component_use(Optional),
            E1339.component_use(Optional),
            E1339.component_use(Optional),
            E1339.component_use(Optional),
            E352 .component_use(Optional),
            E234 .component_use(Optional)  # Qualified by C003-01

          C004 = CompositeElementDef.new \
            "C004", "Composite Diagnosis Code Pointer",
            "To identify one or more diagnosis code pointers",
            E1328.component_use(Mandatory),
            E1328.component_use(Optional),
            E1328.component_use(Optional),
            E1328.component_use(Optional)

          C005 = CompositeElementDef.new \
            "C005", "Tooth Surface",
            "To identify one or more tooth surface codes",
            E1369.component_use(Mandatory),
            E1369.component_use(Optional),
            E1369.component_use(Optional),
            E1369.component_use(Optional),
            E1369.component_use(Optional)

          C006 = CompositeElementDef.new \
            "C006", "Oral Cavity Designation",
            "To identify one or more areas of oral cavity",
            E1361.component_use(Mandatory),
            E1361.component_use(Optional),
            E1361.component_use(Optional),
            E1361.component_use(Optional),
            E1361.component_use(Optional)

          C022 = CompositeElementDef.new \
            "C022", "Health Care Code Information",
            "To send health care codes and their associated dates, amounts and quantities",
            E1270.component_use(Mandatory),
            E1271.component_use(Mandatory),
            E1250.component_use(Relational),
            E1251.component_use(Relational),
            E782 .component_use(Optional),
            E380 .component_use(Optional),
            E799 .component_use(Optional),
            E1271.component_use(Relational),
            E1073.component_use(Relational),
            SyntaxNote::P(3, 4),
            SyntaxNote::E(8, 9)

          C023 = CompositeElementDef.new \
            "C023", "Health Care Service Location Information",
            "To provide information that identifies the place of service or the type of bill related to the location at which a health care service was rendered",
            E1331.component_use(Mandatory),
            E1332.component_use(Optional),
            E1325.component_use(Optional)

          C024 = CompositeElementDef.new \
            "C024", "Related Causes Information",
            "To identify one or more related causes and associated state or country information",
            E1362.component_use(Optional),
            E1362.component_use(Mandatory),
            E1362.component_use(Optional),
            E156 .component_use(Optional),
            E26  .component_use(Optional)

          # @note Copied from an unverified 4010 internet source
          C035 = CompositeElementDef.new \
            "C035", "Provider Specialty Information",
            "",
            E1222.component_use(Mandatory),
            E559 .component_use(Optional),
            E1073.component_use(Optional)

          C040 = CompositeElementDef.new \
            "C040", "Reference Identifier",
            "To identify one or more reference numbers or identification numbers as specified by the Reference Qualifier",
            E128.component_use(Mandatory),
            E127.component_use(Mandatory),
            E128.component_use(Relational),
            E127.component_use(Relational),
            E128.component_use(Relational),
            E127.component_use(Relational),
            SyntaxNote::P.new(3, 4),
            SyntaxNote::P.new(5, 6)

          C042 = CompositeElementDef.new \
            "C042", "Adjustment Identifier",
            "To provide the category and identifying reference information for an adjustment",
            E426.component_use(Mandatory),
            E127.component_use(Optional)

          C056 = CompositeElementDef.new \
            "C056", "Composite Race or Ethnicity Information",
            "",
            E1109.component_use(Optional),
            E1270.component_use(Relational),
            E1271.component_use(Relational)


        end
      end
    end
  end
end
