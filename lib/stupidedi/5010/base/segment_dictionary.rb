module Stupidedi
  module FiftyTen
    module Base
      module SegmentDictionary

        E = ElementDictionary
        R = Designations::ElementRepetition
        M = Designations::ElementRequirement::M
        O = Designations::ElementRequirement::O
        X = Designations::ElementRequirement::X

        ST = SegmentDef.new \
          "ST", "Transaction Set Header",
          E::E143 .simple_use(M, R::Once),
          E::E329 .simple_use(M, R::Once),
          E::E1705.simple_use(O, R::Once)

        SE = SegmentDef.new \
          "SE", "Transaction Set Trailer",
          E::E96 .simple_use(M, R::Once),
          E::E329.simple_use(M, R::Once)

        AMT = SegmentDef.new \
          "AMT", "Monetary Amount Information",
          E::E522.simple_use(M, R::Once),
          E::E782.simple_use(M, R::Once),
          E::E478.simple_use(O, R::Once)

        BHT = SegmentDef.new \
          "BHT", "Beginning of Hierarchical Transaction",
          E::E1005.simple_use(M, R::Once),
          E::E353 .simple_use(M, R::Once),
          E::E127 .simple_use(O, R::Once),
          E::E373 .simple_use(O, R::Once),
          E::E337 .simple_use(O, R::Once),
          E::E640 .simple_use(O, R::Once)

        BPR = SegmentDef.new \
          "BPR", "Financial Information",
          E::E305 .simple_use(M, R::Once),
          E::E782 .simple_use(M, R::Once),
          E::E478 .simple_use(M, R::Once),
          E::E591 .simple_use(M, R::Once),
          E::E812 .simple_use(O, R::Once),
          E::E506 .simple_use(X, R::Once),
          E::E507 .simple_use(X, R::Once),
          E::E569 .simple_use(X, R::Once),
          E::E508 .simple_use(X, R::Once),
          E::E509 .simple_use(O, R::Once),
          E::E510 .simple_use(O, R::Once),
          E::E506 .simple_use(X, R::Once),
          E::E507 .simple_use(X, R::Once),
          E::E569 .simple_use(O, R::Once),
          E::E508 .simple_use(X, R::Once),
          E::E373 .simple_use(O, R::Once),
          E::E1048.simple_use(O, R::Once),
          E::E506 .simple_use(X, R::Once),
          E::E507 .simple_use(X, R::Once),
          E::E569 .simple_use(O, R::Once),
          E::E508 .simple_use(X, R::Once)

        CAS = SegmentDef.new \
          "CAS", "Claims Adjustment",
          E::E1033.simple_use(M, R::Once),
          E::E1034.simple_use(M, R::Once),
          E::E782 .simple_use(M, R::Once),
          E::E380 .simple_use(O, R::Once),
          E::E1034.simple_use(X, R::Once),
          E::E782 .simple_use(X, R::Once),
          E::E380 .simple_use(X, R::Once),
          E::E1034.simple_use(X, R::Once),
          E::E782 .simple_use(X, R::Once),
          E::E380 .simple_use(X, R::Once),
          E::E1034.simple_use(X, R::Once),
          E::E782 .simple_use(X, R::Once),
          E::E380 .simple_use(X, R::Once),
          E::E1034.simple_use(X, R::Once),
          E::E782 .simple_use(X, R::Once),
          E::E380 .simple_use(X, R::Once),
          E::E1034.simple_use(X, R::Once),
          E::E782 .simple_use(X, R::Once),
          E::E380 .simple_use(X, R::Once)

        CLM = SegmentDef.new \
          "CLM", "Health Claim",
          E::E1028.simple_use(M, R::Once),
          E::E782 .simple_use(O, R::Once),
          E::E1032.simple_use(O, R::Once),
          E::E1343.simple_use(O, R::Once),
          E::C023 .simple_use(O, R::Once),
          E::E1073.simple_use(O, R::Once),
          E::E1359.simple_use(O, R::Once),
          E::E1073.simple_use(O, R::Once),
          E::E1363.simple_use(O, R::Once),
          E::E1351.simple_use(O, R::Once),
          E::C024 .simple_use(O, R::Once),
          E::E1366.simple_use(O, R::Once),
          E::E1073.simple_use(O, R::Once),
          E::E1338.simple_use(O, R::Once),
          E::E1073.simple_use(O, R::Once),
          E::E1360.simple_use(O, R::Once),
          E::E1029.simple_use(O, R::Once),
          E::E1073.simple_use(O, R::Once),
          E::E1383.simple_use(O, R::Once),
          E::E1514.simple_use(O, R::Once)

        CLP = SegmentDef.new \
          "CLP", "Claim Level Data",
          E::E1028.simple_use(M, R::Once),
          E::E1029.simple_use(M, R::Once),
          E::E782 .simple_use(M, R::Once),
          E::E782 .simple_use(M, R::Once),
          E::E782 .simple_use(O, R::Once),
          E::E1032.simple_use(O, R::Once),
          E::E127 .simple_use(O, R::Once),
          E::E1331.simple_use(O, R::Once),
          E::E1325.simple_use(O, R::Once),
          E::E1352.simple_use(O, R::Once),
          E::E1354.simple_use(O, R::Once),
          E::E380 .simple_use(O, R::Once),
          E::E954 .simple_use(O, R::Once),
          E::E1073.simple_use(O, R::Once)

        CN1 = SegmentDef.new \
          "CN1", "Contract Information",
          E::E1166.simple_use(M, R::Once),
          E::E782 .simple_use(O, R::Once),
          E::E332 .simple_use(O, R::Once),
          E::E127 .simple_use(O, R::Once),
          E::E338 .simple_use(O, R::Once),
          E::E799 .simple_use(O, R::Once)

        CR1 = SegmentDef.new \
          "CR1", "Ambulance Certification",
          E::E355 .simple_use(X, R::Once),
          E::E81  .simple_use(X, R::Once),
          E::E1316.simple_use(O, R::Once),
          E::E1317.simple_use(O, R::Once),
          E::E355 .simple_use(X, R::Once),
          E::E380 .simple_use(X, R::Once),
          E::E166 .simple_use(O, R::Once),
          E::E166 .simple_use(O, R::Once),
          E::E352 .simple_use(O, R::Once),
          E::E352 .simple_use(O, R::Once)

        CR2 = SegmentDef.new \
          "CR2", "Chiropractic Certification",
          E::E609 .simple_use(X, R::Once),
          E::E380 .simple_use(X, R::Once),
          E::E1367.simple_use(X, R::Once),
          E::E1367.simple_use(O, R::Once),
          E::E355 .simple_use(X, R::Once),
          E::E380 .simple_use(X, R::Once),
          E::E380 .simple_use(O, R::Once),
          E::E1342.simple_use(O, R::Once),
          E::E1073.simple_use(O, R::Once),
          E::E352 .simple_use(O, R::Once),
          E::E352 .simple_use(O, R::Once),
          E::E1073.simple_use(O, R::Once)

        CR3 = SegmentDef.new \
          "CR3", "Durable Medical Equipment Certification",
          E::E1322.simple_use(O, R::Once),
          E::E355 .simple_use(X, R::Once),
          E::E380 .simple_use(X, R::Once),
          E::E1335.simple_use(O, R::Once),
          E::E352 .simple_use(O, R::Once)

        CRC = SegmentDef.new \
          "CRC", "Conditions Indicator",
          E::E1136.simple_use(M, R::Once),
          E::E1073.simple_use(M, R::Once),
          E::E1321.simple_use(M, R::Once),
          E::E1321.simple_use(O, R::Once),
          E::E1321.simple_use(O, R::Once),
          E::E1321.simple_use(O, R::Once),
          E::E1321.simple_use(O, R::Once)

        CTP = SegmentDef.new \
          "CTP", "Pricing Information",
          E::E687.simple_use(O, R::Once),
          E::E236.simple_use(X, R::Once),
          E::E212.simple_use(X, R::Once),
          E::E380.simple_use(X, R::Once),
          E::C001.simple_use(X, R::Once),
          E::E648.simple_use(O, R::Once),
          E::E649.simple_use(X, R::Once),
          E::E782.simple_use(O, R::Once),
          E::E639.simple_use(O, R::Once),
          E::E499.simple_use(O, R::Once),
          E::E289.simple_use(O, R::Once)

        CUR = SegmentDef.new \
          "CUR", "Currency",
          E::E98 .simple_use(M, R::Once),
          E::E100.simple_use(M, R::Once),
          E::E280.simple_use(O, R::Once),
          E::E98 .simple_use(O, R::Once),
          E::E100.simple_use(O, R::Once),
          E::E669.simple_use(O, R::Once),
          E::E374.simple_use(X, R::Once),
          E::E373.simple_use(O, R::Once),
          E::E337.simple_use(O, R::Once),
          E::E374.simple_use(X, R::Once),
          E::E373.simple_use(X, R::Once),
          E::E337.simple_use(X, R::Once),
          E::E374.simple_use(X, R::Once),
          E::E373.simple_use(X, R::Once),
          E::E337.simple_use(X, R::Once),
          E::E374.simple_use(X, R::Once),
          E::E373.simple_use(X, R::Once),
          E::E337.simple_use(X, R::Once),
          E::E374.simple_use(X, R::Once),
          E::E373.simple_use(X, R::Once),
          E::E337.simple_use(X, R::Once)

        DMG = SegmentDef.new \
          "DMG", "Demographic Information",
          E::E1250.simple_use(X, R::Once),
          E::E1251.simple_use(X, R::Once),
          E::E1068.simple_use(O, R::Once),
          E::E1067.simple_use(O, R::Once),
          E::C056 .simple_use(X, R::Max(10)),
          E::E1066.simple_use(O, R::Once),
          E::E26  .simple_use(O, R::Once),
          E::E380 .simple_use(O, R::Once),
          E::E1270.simple_use(X, R::Once),
          E::E1271.simple_use(X, R::Once)

        DTM = SegmentDef.new \
          "DTM", "Date/Time Reference",
          E::E374 .simple_use(M, R::Once),
          E::E373 .simple_use(X, R::Once),
          E::E337 .simple_use(X, R::Once),
          E::E623 .simple_use(O, R::Once),
          E::E1250.simple_use(X, R::Once),
          E::E1251.simple_use(X, R::Once)

        DTP = SegmentDef.new \
          "DTP", "Date or Time Period",
          E::E374 .simple_use(M, R::Once),
          E::E1250.simple_use(M, R::Once),
          E::E1251.simple_use(M, R::Once)

        FRM = SegmentDef.new \
          "FRM", "Supporting Documentation",
          E::E350 .simple_use(M, R::Once),
          E::E1073.simple_use(X, R::Once),
          E::E127 .simple_use(X, R::Once),
          E::E373 .simple_use(X, R::Once),
          E::E332 .simple_use(X, R::Once)

        HCP = SegmentDef.new \
          "HCP", "Health Care Pricing",
          E::E1473.simple_use(X, R::Once),
          E::E782 .simple_use(O, R::Once),
          E::E782 .simple_use(O, R::Once),
          E::E127 .simple_use(O, R::Once),
          E::E118 .simple_use(O, R::Once),
          E::E127 .simple_use(O, R::Once),
          E::E782 .simple_use(O, R::Once),
          E::E234 .simple_use(O, R::Once),
          E::E235 .simple_use(X, R::Once),
          E::E234 .simple_use(X, R::Once),
          E::E355 .simple_use(X, R::Once),
          E::E380 .simple_use(X, R::Once),
          E::E901 .simple_use(X, R::Once),
          E::E1526.simple_use(O, R::Once),
          E::E1527.simple_use(O, R::Once)

        HI = SegmentDef.new \
          "HI", "Health Care Information Codes",
          E::C022.simple_use(M, R::Once),
          E::C022.simple_use(O, R::Once),
          E::C022.simple_use(O, R::Once),
          E::C022.simple_use(M, R::Once),
          E::C022.simple_use(O, R::Once),
          E::C022.simple_use(O, R::Once),
          E::C022.simple_use(M, R::Once),
          E::C022.simple_use(O, R::Once),
          E::C022.simple_use(O, R::Once),
          E::C022.simple_use(O, R::Once),
          E::C022.simple_use(O, R::Once),
          E::C022.simple_use(O, R::Once)

        HL = SegmentDef.new \
          "HL", "Hierarchical Level",
          E::E628.simple_use(M, R::Once),
          E::E734.simple_use(O, R::Once),
          E::E735.simple_use(M, R::Once),
          E::E736.simple_use(O, R::Once)

        K3 = SegmentDef.new \
          "K3", "File Information",
          E::E449 .simple_use(M, R::Once),
          E::E1333.simple_use(O, R::Once),
          E::C001 .simple_use(O, R::Once)

        LIN = SegmentDef.new \
          "LIN", "Item Identification",
          E::E350.simple_use(O, R::Once),
          E::E235.simple_use(M, R::Once),
          E::E234.simple_use(M, R::Once),
          E::E235.simple_use(X, R::Once),
          E::E234.simple_use(X, R::Once),
          E::E235.simple_use(X, R::Once),
          E::E234.simple_use(X, R::Once),
          E::E235.simple_use(X, R::Once),
          E::E234.simple_use(X, R::Once),
          E::E235.simple_use(X, R::Once),
          E::E234.simple_use(X, R::Once),
          E::E235.simple_use(X, R::Once),
          E::E234.simple_use(X, R::Once),
          E::E235.simple_use(X, R::Once),
          E::E234.simple_use(X, R::Once),
          E::E235.simple_use(X, R::Once),
          E::E234.simple_use(X, R::Once),
          E::E235.simple_use(X, R::Once),
          E::E234.simple_use(X, R::Once),
          E::E235.simple_use(X, R::Once),
          E::E234.simple_use(X, R::Once),
          E::E235.simple_use(X, R::Once),
          E::E234.simple_use(X, R::Once),
          E::E235.simple_use(X, R::Once),
          E::E234.simple_use(X, R::Once),
          E::E235.simple_use(X, R::Once),
          E::E234.simple_use(X, R::Once),
          E::E235.simple_use(X, R::Once),
          E::E234.simple_use(X, R::Once),
          E::E235.simple_use(X, R::Once),
          E::E234.simple_use(X, R::Once)

        LQ = SegmentDef.new \
          "LQ", "Industry Code Identification",
          E::E1270.simple_use(O, R::Once),
          E::E1271.simple_use(X, R::Once)

        LX = SegmentDef.new \
          "LX", "Transaction Set Line Number",
          E::E554.simple_use(M, R::Once)

        MEA = SegmentDef.new \
          "MEA", "Measurements",
          E::E737 .simple_use(O, R::Once),
          E::E738 .simple_use(O, R::Once),
          E::E739 .simple_use(X, R::Once),
          E::C001 .simple_use(X, R::Once),
          E::E740 .simple_use(X, R::Once),
          E::E741 .simple_use(X, R::Once),
          E::E935 .simple_use(O, R::Once),
          E::E936 .simple_use(X, R::Once),
          E::E752 .simple_use(O, R::Once),
          E::E753 .simple_use(O, R::Once),
          E::E1270.simple_use(X, R::Once),
          E::E1271.simple_use(X, R::Once)

        MIA = SegmentDef.new \
          "MIA", "Medicare Inpatient Adjudication",
          E::E380.simple_use(M, R::Once),
          E::E782.simple_use(O, R::Once),
          E::E380.simple_use(O, R::Once),
          E::E782.simple_use(O, R::Once),
          E::E127.simple_use(O, R::Once),
          E::E782.simple_use(O, R::Once),
          E::E782.simple_use(O, R::Once),
          E::E782.simple_use(O, R::Once),
          E::E782.simple_use(O, R::Once),
          E::E782.simple_use(O, R::Once),
          E::E782.simple_use(O, R::Once),
          E::E782.simple_use(O, R::Once),
          E::E782.simple_use(O, R::Once),
          E::E782.simple_use(O, R::Once),
          E::E380.simple_use(O, R::Once),
          E::E782.simple_use(O, R::Once),
          E::E782.simple_use(O, R::Once),
          E::E782.simple_use(O, R::Once),
          E::E782.simple_use(O, R::Once),
          E::E127.simple_use(O, R::Once),
          E::E127.simple_use(O, R::Once),
          E::E127.simple_use(O, R::Once),
          E::E127.simple_use(O, R::Once),
          E::E782.simple_use(O, R::Once)

        MOA = SegmentDef.new \
          "MOA", "Medicare Outpatient Adjudication",
          E::E954.simple_use(O, R::Once),
          E::E782.simple_use(O, R::Once),
          E::E127.simple_use(O, R::Once),
          E::E127.simple_use(O, R::Once),
          E::E127.simple_use(O, R::Once),
          E::E127.simple_use(O, R::Once),
          E::E127.simple_use(O, R::Once),
          E::E782.simple_use(O, R::Once),
          E::E782.simple_use(O, R::Once)

        N1 = SegmentDef.new \
          "N1", "Party Identification",
          E::E98 .simple_use(M, R::Once),
          E::E93 .simple_use(X, R::Once),
          E::E66 .simple_use(X, R::Once),
          E::E67 .simple_use(X, R::Once),
          E::E706.simple_use(O, R::Once),
          E::E98 .simple_use(O, R::Once)

        N3 = SegmentDef.new \
          "N3", "Party Location",
          E::E166.simple_use(M, R::Once),
          E::E166.simple_use(O, R::Once)

        N4 = SegmentDef.new \
          "N4", "Geographic Location",
          E::E19  .simple_use(O, R::Once),
          E::E156 .simple_use(X, R::Once),
          E::E116 .simple_use(O, R::Once),
          E::E26  .simple_use(X, R::Once),
          E::E309 .simple_use(X, R::Once),
          E::E310 .simple_use(O, R::Once),
          E::E1715.simple_use(X, R::Once)

        NM1 = SegmentDef.new \
          "NM1", "Individual or Organizational Name",
          E::E98  .simple_use(M, R::Once),
          E::E1065.simple_use(M, R::Once),
          E::E1035.simple_use(X, R::Once),
          E::E1036.simple_use(O, R::Once),
          E::E1037.simple_use(O, R::Once),
          E::E1038.simple_use(O, R::Once),
          E::E1039.simple_use(O, R::Once),
          E::E66  .simple_use(X, R::Once),
          E::E67  .simple_use(X, R::Once),
          E::E706 .simple_use(X, R::Once),
          E::E98  .simple_use(O, R::Once),
          E::E1035.simple_use(O, R::Once)

        NTE = SegmentDef.new \
          "NTE", "Note/Special Instruction",
          E::E363.simple_use(O, R::Once),
          E::E352.simple_use(M, R::Once)

        OI = SegmentDef.new \
          "OI", "Other Health Insurance Information",
          E::E1032.simple_use(O, R::Once),
          E::E1383.simple_use(O, R::Once),
          E::E1073.simple_use(O, R::Once),
          E::E1351.simple_use(O, R::Once),
          E::E1360.simple_use(O, R::Once),
          E::E1363.simple_use(O, R::Once)

        PAT = SegmentDef.new \
          "PAT", "Patient Information",
          E::E1069.simple_use(O, R::Once),
          E::E1384.simple_use(O, R::Once),
          E::E584 .simple_use(O, R::Once),
          E::E1220.simple_use(O, R::Once),
          E::E1250.simple_use(X, R::Once),
          E::E1251.simple_use(X, R::Once),
          E::E355 .simple_use(X, R::Once),
          E::E81  .simple_use(X, R::Once),
          E::E1073.simple_use(O, R::Once)

        PER = SegmentDef.new \
          "PER", "Administrative Communications Contact",
          E::E366.simple_use(M, R::Once),
          E::E93 .simple_use(O, R::Once),
          E::E365.simple_use(X, R::Once),
          E::E364.simple_use(X, R::Once),
          E::E365.simple_use(X, R::Once),
          E::E364.simple_use(X, R::Once),
          E::E365.simple_use(X, R::Once),
          E::E364.simple_use(X, R::Once),
          E::E443.simple_use(O, R::Once)

        PLB = SegmentDef.new \
          "PLB", "Provider Level Adjustment",
          E::E127.simple_use(M, R::Once),
          E::E373.simple_use(M, R::Once),
          E::C042.simple_use(M, R::Once),
          E::E782.simple_use(M, R::Once),
          E::C042.simple_use(X, R::Once),
          E::E782.simple_use(X, R::Once),
          E::C042.simple_use(X, R::Once),
          E::E782.simple_use(X, R::Once),
          E::C042.simple_use(X, R::Once),
          E::E782.simple_use(X, R::Once),
          E::C042.simple_use(X, R::Once),
          E::E782.simple_use(X, R::Once),
          E::C042.simple_use(X, R::Once),
          E::E782.simple_use(X, R::Once)

        PRV = SegmentDef.new \
          "PRV", "Provider Information",
          E::E1221.simple_use(M, R::Once),
          E::E128 .simple_use(X, R::Once),
          E::E127 .simple_use(X, R::Once),
          E::E156 .simple_use(O, R::Once),
          E::C035 .simple_use(O, R::Once),
          E::E1223.simple_use(O, R::Once)

        PS1 = SegmentDef.new \
          "PS1", "Purchase Service",
          E::E127.simple_use(M, R::Once)
          E::E782.simple_use(M, R::Once)
          E::E156.simple_use(O, R::Once)

        PWK = SegmentDef.new \
          "PWK", "Paperwork",
          E::E755 .simple_use(M, R::Once),
          E::E756 .simple_use(O, R::Once),
          E::E757 .simple_use(O, R::Once),
          E::E98  .simple_use(O, R::Once),
          E::E66  .simple_use(O, R::Once),
          E::E67  .simple_use(O, R::Once),
          E::E352 .simple_use(O, R::Once),
          E::C002 .simple_use(O, R::Once),
          E::E1525.simple_use(O, R::Once)

        QTY = SegmentDef.new \
          "QTY", "Quantity Information",
          E::E673.simple_use(M, R::Once),
          E::E380.simple_use(X, R::Once),
          E::C001.simple_use(O, R::Once),
          E::E61 .simple_use(X, R::Once)

        RDM = SegmentDef.new \
          "RDM", "Remittance Delivery Method",
          E::E756.simple_use(M, R::Once),
          E::E93 .simple_use(O, R::Once),
          E::E364.simple_use(O, R::Once),
          E::C040.simple_use(O, R::Once),
          E::C040.simple_use(O, R::Once)

        REF = SegmentDef.new \
          "REF", "Reference Information",
          E::E128.simple_use(M, R::Once),
          E::E127.simple_use(X, R::Once),
          E::E352.simple_use(X, R::Once),
          E::C040.simple_use(O, R::Once)

        SBR = SegmentDef.new \
          "SBR", "Subscriber Information",
          E::E1138.simple_use(M, R::Once),
          E::E1069.simple_use(O, R::Once),
          E::E127 .simple_use(O, R::Once),
          E::E93  .simple_use(O, R::Once),
          E::E1336.simple_use(O, R::Once),
          E::E1143.simple_use(O, R::Once),
          E::E1073.simple_use(O, R::Once),
          E::E584 .simple_use(O, R::Once),
          E::E1032.simple_use(O, R::Once)

        SV1 = SegmentDef.new \
          "SV1", "Professional Service",
          E::C003 .simple_use(M, R::Once),
          E::E782 .simple_use(O, R::Once),
          E::E355 .simple_use(X, R::Once),
          E::E380 .simple_use(X, R::Once),
          E::E1331.simple_use(O, R::Once),
          E::E1365.simple_use(O, R::Once),
          E::C004 .simple_use(O, R::Once),
          E::E782 .simple_use(O, R::Once),
          E::E1073.simple_use(O, R::Once),
          E::E1340.simple_use(O, R::Once),
          E::E1073.simple_use(O, R::Once),
          E::E1073.simple_use(O, R::Once),
          E::E1364.simple_use(O, R::Once),
          E::E1341.simple_use(O, R::Once),
          E::E1327.simple_use(O, R::Once),
          E::E1334.simple_use(O, R::Once),
          E::E127 .simple_use(O, R::Once),
          E::E116 .simple_use(O, R::Once),
          E::E782 .simple_use(O, R::Once),
          E::E1337.simple_use(O, R::Once),
          E::E1360.simple_use(O, R::Once)

        SV5 = SegmentDef.new \
          "SV5", "Durable Medical Equipment Service",
          E::C003.simple_use(M, R::Once),
          E::E355.simple_use(M, R::Once),
          E::E380.simple_use(X, R::Once),
          E::E782.simple_use(X, R::Once),
          E::E782.simple_use(O, R::Once)

        SVC = SegmentDef.new \
          "SVC", "Service Payment Information",
          E::C003.simple_use(M, R::Once),
          E::E782.simple_use(M, R::Once),
          E::E782.simple_use(O, R::Once),
          E::E234.simple_use(O, R::Once),
          E::E380.simple_use(O, R::Once),
          E::C003.simple_use(O, R::Once),
          E::E380.simple_use(O, R::Once)

        SVD = SegmentDef.new \
          "SVD", "Service Line Adjustment",
          E::E67 .simple_use(M, R::Once),
          E::E782.simple_use(X, R::Once),
          E::C003.simple_use(O, R::Once),
          E::E234.simple_use(O, R::Once),
          E::E380.simple_use(O, R::Once),
          E::E554.simple_use(O, R::Once)

        TRN = SegmentDef.new \
          "TRN", "Trace",
          E::E481.simple_use(M, R::Once),
          E::E127.simple_use(M, R::Once),
          E::E509.simple_use(O, R::Once),
          E::E127.simple_use(O, R::Once)

        TS2 = SegmentDef.new \
          "TS2", "Transaction Supplemental Statistics",
          E::E782.simple_use(O, R::Once),
          E::E782.simple_use(O, R::Once),
          E::E782.simple_use(O, R::Once),
          E::E782.simple_use(O, R::Once),
          E::E782.simple_use(O, R::Once),
          E::E782.simple_use(O, R::Once),
          E::E380.simple_use(O, R::Once),
          E::E782.simple_use(O, R::Once),
          E::E782.simple_use(O, R::Once),
          E::E380.simple_use(O, R::Once),
          E::E380.simple_use(O, R::Once),
          E::E380.simple_use(O, R::Once),
          E::E380.simple_use(O, R::Once),
          E::E380.simple_use(O, R::Once),
          E::E782.simple_use(O, R::Once),
          E::E380.simple_use(O, R::Once),
          E::E782.simple_use(O, R::Once),
          E::E782.simple_use(O, R::Once),
          E::E782.simple_use(O, R::Once)

        TS3 = SegmentDef.new \
          "TS3", "Transaction Statistics",
          E::E127 .simple_use(M, R::Once),
          E::E1331.simple_use(M, R::Once),
          E::E373 .simple_use(M, R::Once),
          E::E380 .simple_use(M, R::Once),
          E::E782 .simple_use(M, R::Once),
          E::E782 .simple_use(O, R::Once),
          E::E782 .simple_use(O, R::Once),
          E::E782 .simple_use(O, R::Once),
          E::E782 .simple_use(O, R::Once),
          E::E782 .simple_use(O, R::Once),
          E::E782 .simple_use(O, R::Once),
          E::E782 .simple_use(O, R::Once),
          E::E782 .simple_use(O, R::Once),
          E::E782 .simple_use(O, R::Once),
          E::E782 .simple_use(O, R::Once),
          E::E782 .simple_use(O, R::Once),
          E::E782 .simple_use(O, R::Once),
          E::E782 .simple_use(O, R::Once),
          E::E782 .simple_use(O, R::Once),
          E::E782 .simple_use(O, R::Once),
          E::E782 .simple_use(O, R::Once),
          E::E782 .simple_use(O, R::Once),
          E::E380 .simple_use(O, R::Once),
          E::E782 .simple_use(O, R::Once)

      end
    end
  end
end
