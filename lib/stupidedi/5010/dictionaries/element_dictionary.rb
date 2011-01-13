module Stupidedi
  module FiftyTen
    module Dictionaries
      module ElementDict

        # @private
        AN = Definitions::ElementTypes::AN

        # @private
        ID = Definitions::ElementTypes::ID

        # @private
        DT = Definitions::ElementTypes::DT

        # @private
        TM = Definitions::ElementTypes::TM

        # @private
        R  = Definitions::ElementTypes::R

        # @private
        N  = Definitions::ElementTypes::N

        E19   = AN.new("E19"  , "City Name"                            , "", 2, 30)
        E26   = ID.new("E26"  , "Country Code"                         , "", 2, 3)  # S5
        E28   = ID.new("E28"  , "Group Control Number"                 , "", 1, 9)
        E61   = AN.new("E61"  , "Free-form Information"                , "", 1, 30)
        E66   = ID.new("E66"  , "Identification Code Qualifier"        , "", 1, 2)  # 38=S5; SJ=S22; 16=SJ; XX=S537; XV=S540; SJ=S22
        E67   = AN.new("E67"  , "Identification Code"                  , "", 2, 80)
        E81   =  R.new("E81"  , "Weight"                               , "", 1, 10)
        E93   = AN.new("E93"  , "Name"                                 , "", 1, 60)
        E96   =  N.new("E96"  , "Number of Included Segments"          , "", 1, 10)
        E97   =  N.new("E97"  , "Number of Transaction Sets Included"  , "", 1, 6)
        E98   = ID.new("E98"  , "Entity Identifier Code"               , "", 2, 3)
        E100  = ID.new("E100" , "Currency Code"                        , "", 3, 3)  # S5
        E116  = ID.new("E116" , "Postal Code"                          , "", 3, 15) # S51, S932
        E118  =  R.new("E118" , "Rate"                                 , "", 1, 9)
        E124  = AN.new("E124" , "Application Receiver's Code"          , "", 2, 15)
        E127  = AN.new("E127" , "Reference Identification"             , "", 1, 50)
        E128  = ID.new("E128" , "Reference Identification Qualifier"   , "", 2, 3)  # ICD=S131; NF=S245; HPI=S537; ABY=S540; PXC=S682; D3=E307; ICMB=ICMB; MRC=S844
        E142  = AN.new("E142" , "Application's Sender Code"            , "", 2, 3)
        E143  = ID.new("E143" , "Transaction Set Identifier Number"    , "", 3, 3)
        E156  = ID.new("E156" , "State or Province Code"               , "", 2, 2)  # S22
        E166  = AN.new("E166" , "Address Information"                  , "", 1, 55)
        E212  =  R.new("E212" , "Unit Price"                           , "", 1, 17)
        E234  = AN.new("E234" , "Product/Service ID"                   , "", 1, 48)
        E235  = ID.new("E235" , "Product/Service ID Qualifier"         , "", 2, 2)  # CH=S5; A5=S22; DX,ID=S131; AD=S135; ER=S576; DC=S897; HC=S130; NU,RB=S132; N1,N2,N3,N4,N5,N6=S240; IV=S513; HP=S716; WK=S843; IP=S896
        E236  = ID.new("E236" , "Price Identifier Code"                , "", 3, 3)
        E280  =  R.new("E280" , "Exchange Rate"                        , "", 4, 10)
        E289  =  N.new("E289" , "Multiple Price Quantity"              , "", 1, 2)
        E305  = ID.new("E305" , "Transaction Handling Code"            , "", 1, 2)
        E309  = ID.new("E309" , "Location Qualifier"                   , "", 1, 2)  # PQ=S51; PR,PS=S51
        E310  = ID.new("E310" , "Location Identifier"                  , "", 1, 30)
        E329  = ID.new("E329" , "Transaction Set Control Number"       , "", 4, 9)
        E332  =  R.new("E332" , "Percent, Decimal Format"              , "", 1, 6)
        E337  = TM.new("E337" , "Time"                                 , "", 4, 8)
        E338  =  R.new("E338" , "Terms Discount Percent"               , "", 1, 6)
        E350  = AN.new("E350" , "Assigned Identification"              , "", 1, 20)
        E352  = AN.new("E352" , "Description"                          , "", 1, 80)
        E353  = ID.new("E353" , "Transaction Set Purpose Code"         , "", 2, 2)
        E355  = ID.new("E355" , "Unit or Basis for Measurement Code"   , "", 2, 2)
        E363  = ID.new("E363" , "Note Reference Code"                  , "", 3, 3)
        E364  = AN.new("E364" , "Communication Number"                 , "", 1, 256)
        E365  = ID.new("E365" , "Communication Number Qualifier"       , "", 2, 2)
        E366  = ID.new("E366" , "Contract Function Code"               , "", 2, 2)
        E373  = DT.new("E373" , "Date"                                 , "", 8, 8)
        E374  = ID.new("E374" , "Date/Time Qualifier"                  , "", 3, 3)
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
        E554  =  N.new("E554" , "Assigned Number"                      , "", 1, 6)
        E559  = ID.new("E559" , "Agency Qualifier Code"                , "", 2, 2) # LB=S407 @note Copied from an unverified 4010 internet source
        E569  = ID.new("E569" , "Account Number Qualifier"             , "", 1, 3)
        E584  = ID.new("E584" , "Employment Status Code"               , "", 2, 2)
        E591  = ID.new("E591" , "Payment Method Code"                  , "", 3, 3)
        E609  =  N.new("E609" , "Count"                                , "", 1, 9)
        E623  = ID.new("E623" , "Time Code"                            , "", 2, 2)
        E628  = AN.new("E628" , "Hierachical ID Number"                , "", 1, 12)
        E639  = ID.new("E639" , "Basis of Unit Price Code"             , "", 2, 2)
        E640  = ID.new("E640" , "Transaction Type Code"                , "", 2, 2)
        E648  = ID.new("E648" , "Price Multiplier Qualifier"           , "", 3, 3)
        E649  =  R.new("E649" , "Multiplier"                           , "", 1, 10)
        E659  = ID.new("E659" , "Basis of Verification Code"           , "", 1, 2)
        E669  = ID.new("E669" , "Currency Market/Exchnage Code"        , "", 3, 3)
        E673  = ID.new("E673" , "Quantity Qualifier"                   , "", 2, 2)
        E687  = ID.new("E687" , "Class of Trade Code"                  , "", 2, 2)
        E704  = ID.new("E704" , "Paperwork/Report Action Code"         , "", 1, 2) # @note Copied from an unverified 4010 internet source
        E706  = ID.new("E706" , "Entity Relation Code"                 , "", 2, 2)
        E734  = AN.new("E734" , "Hierarchical Parent ID Number"        , "", 1, 12)
        E735  = ID.new("E735" , "Hierarchical Level Code"              , "", 1, 2)
        E736  = ID.new("E736" , "Hierarchical Child Code"              , "", 1, 1)
        E737  = ID.new("E737" , "Measurement Reference ID Code"        , "", 2, 2)
        E738  = ID.new("E738" , "Measurement Qualifier"                , "", 2, 2)
        E739  =  R.new("E739" , "Measurement Value"                    , "", 1, 20)
        E740  =  R.new("E740" , "Range Minimum"                        , "", 1, 20)
        E741  =  R.new("E741" , "Range Maximum"                        , "", 1, 20)
        E752  = ID.new("E752" , "Surface/Layer/Position Code"          , "", 2, 2)
        E753  = ID.new("E753" , "Measurement Method or Device"         , "", 2, 4)
        E755  = ID.new("E755" , "Report Type Code"                     , "", 2, 2)
        E756  = ID.new("E756" , "Report Transmission Code"             , "", 1, 2)
        E757  =  N.new("E757" , "Report Copies Needed"                 , "", 1, 2)
        E782  =  R.new("E782" , "Monetary Amount"                      , "", 1, 18)
        E799  = AN.new("E799" , "Version Identifier"                   , "", 1, 30)
        E812  = ID.new("E812" , "Payment Format Code"                  , "", 3, 3)
        E901  = ID.new("E901" , "Reject Reason Code"                   , "", 2, 2)
        E935  = ID.new("E935" , "Measurement Significance Code"        , "", 2, 2)
        E936  = ID.new("E936" , "Measurement Attribute Code"           , "", 2, 2)
        E954  =  R.new("E954" , "Percentage as Decimal"                , "", 1,  10)
        E1005 = ID.new("E1005", "Hierarchical Structure Code"          , "", 4, 4)
        E1018 =  R.new("E1018", "Exponent"                             , "", 1, 15)
        E1028 = AN.new("E1028", "Claim Submitter's Identifier"         , "", 1, 38)
        E1029 = ID.new("E1029", "Claim Status Code"                    , "", 1, 2)
        E1032 = ID.new("E1032", "Claim Filing Indicator Code"          , "", 1, 2)
        E1033 = ID.new("E1033", "Claim Adjustment Group Code"          , "", 1, 12)
        E1034 = ID.new("E1034", "Claim Adjustment Reason Code"         , "", 1, 5)  # S139
        E1035 = AN.new("E1035", "Name Last or Organization Code"       , "", 1, 60)
        E1036 = AN.new("E1036", "Name First"                           , "", 1, 35)
        E1037 = AN.new("E1037", "Name Middle"                          , "", 1, 25)
        E1038 = AN.new("E1038", "Name Prefix"                          , "", 1, 10)
        E1039 = AN.new("E1039", "Name Suffix"                          , "", 1, 10)
        E1048 = ID.new("E1048", "Business Function Code"               , "", 1, 3)
        E1065 = ID.new("E1065", "Entity Type Qualifier"                , "", 1, 1)
        E1066 = ID.new("E1066", "Citizenship Status Code"              , "", 1, 2)
        E1067 = ID.new("E1067", "Marital Status Code"                  , "", 1, 1)
        E1068 = ID.new("E1068", "Gender Code"                          , "", 1, 1)
        E1069 = ID.new("E1069", "Individual Relationship Code"         , "", 2, 2)
        E1073 = ID.new("E1073", "Yes/No Condition or Response Code"    , "", 1, 1)
        E1109 = ID.new("E1109", "Race or Ethnicity Code"               , "", 1, 1)
        E1136 = ID.new("E1136", "Code Category"                        , "", 2, 2)
        E1138 = ID.new("E1138", "Payer Responsibility Sequence"        , "", 1, 1)
        E1143 = ID.new("E1143", "Coordination of Benefits Code"        , "", 1, 1)
        E1166 = ID.new("E1166", "Contract Type Code"                   , "", 2, 2)
        E1220 = ID.new("E1220", "Student Status Code"                  , "", 1, 1)
        E1221 = ID.new("E1221", "Provider Code"                        , "", 1, 3)
        E1222 = AN.new("E1222", "Provider Specialty Code"              , "", 1, 3) # @note Copied from an unverified 4010 internet source
        E1223 = ID.new("E1223", "Provider Organization Code"           , "", 3, 3)
        E1250 = ID.new("E1250", "Date Time Period Format Qualifier"    , "", 2, 3)
        E1251 = AN.new("E1251", "Date Time Period"                     , "", 1, 35)
        E1270 = ID.new("E1270", "Code List Qualifier Code"             , "", 1, 3)  # BO,BP=S130; BF,BJ,BK,BN,BQ,BR,DD,PR,SD,TD,AAU,AAV,AAX=S131; JO,JP,TQ,AAY=S135; HE=S411; 68=S682; ABF,ABJ,ABK,APR,ASD,ATD=S897; BE,BG,BH,BI,NUB=S132; DR=S229; NDC=S240; HO=S513; CAH=S843; BBQ,BBR=S896; UT=S582; AS=S1270; GR=S284; BT,BU,EK,GS,GU,GW,NI,PB,SJ,SL 
        E1271 = AN.new("E1271", "Industry Code"                        , "", 1, 30)
        E1314 = ID.new("E1314", "Admission Source Code"                , "", 1, 1)  # S230
        E1315 = ID.new("E1315", "Admission Type Code"                  , "", 1, 1)  # S231
        E1316 = ID.new("E1316", "Ambulance Transport Code"             , "", 1, 1)
        E1317 = ID.new("E1317", "Ambulance Transport Reason Code"      , "", 1, 1)
        E1321 = ID.new("E1321", "Condition Indicator"                  , "", 2, 3)
        E1322 = ID.new("E1322", "Certification Type Code"              , "", 1, 1)
        E1325 = ID.new("E1325", "Claim Frequency Type Code"            , "", 1, 1)  # S235
        E1327 = ID.new("E1327", "Copay Status Code"                    , "", 1, 1)
        E1328 =  N.new("E1328", "Diagnosis Code Pointer"               , "", 1, 2)
        E1331 = AN.new("E1331", "Facility Code Value"                  , "", 1, 2)
        E1332 = ID.new("E1332", "Facility Code Qualifier"              , "", 1, 2)  # B=S237
        E1333 = ID.new("E1333", "Record Format Code"                   , "", 1, 2)
        E1334 = ID.new("E1334", "Professional Shortage Area Code"      , "", 1, 1)
        E1335 = ID.new("E1335", "Insulin Type Code"                    , "", 1, 3)
        E1336 = ID.new("E1336", "Insurance Type Code"                  , "", 1, 3)
        E1337 = ID.new("E1337", "Level of Care Code"                   , "", 1, 1)
        E1338 = ID.new("E1338", "Level of Service Code"                , "", 1, 3)
        E1339 = AN.new("E1339", "Procedure Modifier"                   , "", 2, 2)
        E1340 = ID.new("E1340", "Multiple Procedure Code"              , "", 1, 2)
        E1341 = AN.new("E1341", "National or Local Assigned Review"    , "", 1, 2)
        E1342 = ID.new("E1342", "Nature of Condition Code"             , "", 1, 1)
        E1343 = ID.new("E1343", "Non-Institutional Claim Type Code"    , "", 1, 2)
        E1345 = ID.new("E1345", "Nursing Home Residential Status Code" , "", 1, 1)
        E1351 = ID.new("E1351", "Patient Signature Source Code"        , "", 1, 1)
        E1352 = ID.new("E1352", "Patient Status Code"                  , "", 1, 2) # S239
        E1354 = ID.new("E1354", "Diagnosis Related Group (DRG) Code"   , "", 1, 4) # S229
        E1358 = ID.new("E1358", "Prosthesis, Crown, or Inlay Code"     , "", 1, 1)
        E1359 = ID.new("E1359", "Provider Accept Assignment Code"      , "", 1, 1)
        E1360 = ID.new("E1360", "Provider Agreement Code"              , "", 1, 1)
        E1361 = ID.new("E1361", "Oral Cavity Designation Code"         , "", 1, 3) # S135
        E1362 = ID.new("E1362", "Related-Causes Code"                  , "", 2, 3)
        E1363 = ID.new("E1363", "Release of Information Code"          , "", 1, 1)
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
        E1514 = ID.new("E1514", "Delay Reason Code"                    , "", 1, 2)
        E1525 = ID.new("E1525", "Request Category Code"                , "", 1, 2)
        E1526 = ID.new("E1526", "Policy Compliance Code"               , "", 1, 2)
        E1527 = ID.new("E1527", "Exception Code"                       , "", 1, 2)
        E1705 = AN.new("E1705", "Implementation Convention Reference"  , "", 1, 35)
        E1715 = ID.new("E1715", "Country Subdivision Code"             , "", 1, 3)  # S5


        # @private
        M = Definitions::ElementRequirement::M

        # @private
        O = Definitions::ElementRequirement::O

        # @private
        X = Definitions::ElementRequirement::X

        # @private
        CompositeElementDef = Definitions::CompositeElementDef

        C001 = CompositeElementDef.new \
          "C001", "Composite Unit of Measure",
          "To identify a composite unit of measure",
          E355 .component_use(M),
          E1018.component_use(O),
          E649 .component_use(O),
          E355 .component_use(O),
          E1018.component_use(O),
          E649 .component_use(O),
          E355 .component_use(O),
          E1018.component_use(O),
          E649 .component_use(O),
          E355 .component_use(O),
          E1018.component_use(O), # If not used, value is interpreted as 1
          E649 .component_use(O), # If not used, value is interpreted as 1
          E355 .component_use(O),
          E1018.component_use(O), # If not used, value is interpreted as 1
          E649 .component_use(O)  # If not used, value is interpreted as 1

        # @note Copied from an unverified 4010 internet source
        C002 = CompositeElementDef.new \
          "C002", "Actions Indicated",
          "",
          E704.component_use(M),
          E704.component_use(O),
          E704.component_use(O),
          E704.component_use(O),
          E704.component_use(O)

        C003 = CompositeElementDef.new \
          "C003", "Composite Medical Procedure Identifier",
          "To identify a procedure by its standardized codes and applicable modifiers",
          E235 .component_use(M),
          E234 .component_use(M), # Qualified by C003-01
          E1339.component_use(O),
          E1339.component_use(O),
          E1339.component_use(O),
          E1339.component_use(O),
          E352 .component_use(O),
          E234 .component_use(O)  # Qualified by C003-01

        C004 = CompositeElementDef.new \
          "C004", "Composite Diagnosis Code Pointer",
          "To identify one or more diagnosis code pointers",
          E1328.component_use(M),
          E1328.component_use(O),
          E1328.component_use(O),
          E1328.component_use(O)

        C005 = CompositeElementDef.new \
          "C005", "Tooth Surface",
          "To identify one or more tooth surface codes",
          E1369.component_use(M),
          E1369.component_use(O),
          E1369.component_use(O),
          E1369.component_use(O),
          E1369.component_use(O)

        C006 = CompositeElementDef.new \
          "C006", "Oral Cavity Designation",
          "To identify one or more areas of oral cavity",
          E1361.component_use(M),
          E1361.component_use(O),
          E1361.component_use(O),
          E1361.component_use(O),
          E1361.component_use(O)

        C022 = CompositeElementDef.new \
          "C022", "Health Care Code Information",
          "To send health care codes and their associated dates, amounts and quantities",
          # P0304; E0809
          E1270.component_use(M),
          E1271.component_use(M),
          E1250.component_use(X),
          E1251.component_use(X),
          E782 .component_use(O),
          E380 .component_use(O),
          E799 .component_use(O),
          E1271.component_use(X),
          E1073.component_use(X)

        C023 = CompositeElementDef.new \
          "C023", "Health Care Service Location Information",
          "To provide information that identifies the place of service or the type of bill related to the location at which a health care service was rendered",
          E1331.component_use(M),
          E1332.component_use(O),
          E1325.component_use(O)

        C024 = CompositeElementDef.new \
          "C024", "Related Causes Information",
          "To identify one or more related causes and associated state or country information",
          E1362.component_use(O),
          E1362.component_use(M),
          E1362.component_use(O),
          E156 .component_use(O),
          E26  .component_use(O)

        # @note Copied from an unverified 4010 internet source
        C035 = CompositeElementDef.new \
          "C035", "Provider Specialty Information",
          "",
          E1222.component_use(M),
          E559 .component_use(O),
          E1073.component_use(O)

        C040 = CompositeElementDef.new \
          "C040", "Reference Identifier",
          "To identify one or more reference numbers or identification numbers as specified by the Reference Qualifier",
          # P0304; P0506
          E128.component_use(M),
          E127.component_use(M),
          E128.component_use(X),
          E127.component_use(X),
          E128.component_use(X),
          E127.component_use(X)

        C042 = CompositeElementDef.new \
          "C042", "Adjustment Identifier",
          "To provide the category and identifying reference information for an adjustment",
          E426.component_use(M),
          E127.component_use(O)

        C056 = CompositeElementDef.new \
          "C056", "Composite Race or Ethnicity Information", "",
          E1109.component_use(O),
          E1270.component_use(X),
          E1271.component_use(X)
      end
    end
  end
end
