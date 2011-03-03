config = Stupidedi::Configuration.new;nil
config.interchange.register(Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeDef, "00501");nil
config.functional_group.register(Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::FunctionalGroupDef, "005010");nil
config.transaction_set.register(Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::TransactionSetDefs::HC837, "005010");nil
config.transaction_set.register(Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::TransactionSetDefs::HP835, "005010");nil
config.transaction_set.register(Stupidedi::Guides::FiftyTen::X222::HC837, "005010X222");nil

pp  s0 = Stupidedi::Builder.new(config);nil
pp  s1 =  s0.segment(:ISA, ["00", "", "00", "", "ZZ", "SUBMITTER", "ZZ", "RECEIVER", "110223", "1245", "^", "00501", "333666999", "1", "T", ":"]);nil
pp  s2 =  s1.segment(:GS,  ["HC", "SENDER", "RECEIVER", "20110223", "1245", "333666999", "X", "005010X222"]);nil
pp  s3 =  s2.segment(:ST,  ["837", "333666999", "005010X222"]);nil
pp  s4 =  s3.segment(:BHT, ["0019", "00", "0123", "20010412", "1023", "RP"]);nil
pp  s5 =  s4.segment(:NM1, ["41", "2", "JAMES A SMITH, M.D.", "", "", "", "", "46", "TGJ23"]);nil
pp  s6 =  s5.segment(:PER, ["IC", "LINDA", "TE", "8015552222", "EX", "231"]);nil
pp  s7 =  s6.segment(:NM1, ["40", "2", "ABC CLEARINGHOUSE", "", "", "", "", "46", "66783JJT"]);nil
pp  s8 =  s7.segment(:HL,  ["1", "", "20", "1"]);nil
pp  s9 =  s8.segment(:NM1, ["85", "2", "LANTANA CHIROPRACTIC FIRM", "", "", "", "", "XX", "1876543210"]);nil
pp s10 =  s9.segment(:N3,  ["1234 SONIC WAY ST"]);nil
pp s11 = s10.segment(:N4,  ["JACKSONVILLE", "FL", "331111234"]);nil
pp s12 = s11.segment(:REF, ["EI", "999830001"]);nil
pp s13 = s12.segment(:HL,  ["2", "1", "22", "0"]);nil
pp s14 = s13.segment(:SBR, ["P", "18", "", "", "", "", "", "", "CI"]);nil
pp s15 = s14.segment(:NM1, ["IL", "1", "SMITH", "TED", "", "", "", "MI", "000221111A"]);nil
pp s16 = s15.segment(:N3,  ["236 N MAIN ST"]);nil
pp s17 = s16.segment(:N4,  ["MIAMI", "FL", "33413"]);nil
pp s18 = s17.segment(:DMG, ["D8", "19430501", "M"]);nil
pp s19 = s18.segment(:NM1, ["PR", "2", "BLUE SHIELD OF NORTH DAKOTA", "", "", "", "", "PI", "741234"]);nil
pp s20 = s19.segment(:N4,  ["FARGO", "FL", "33111"]);nil
pp s21 = s20.segment(:CLM, ["MIMS-AZ 666", "75", "", "", ["11", "B", "1"], "Y", "A", "Y", "Y"]);nil
pp s22 = s21.segment(:DTP, ["454", "D8", "20010320"]);nil
pp s23 = s22.segment(:DTP, ["431", "D8", "20010220"]);nil
pp s24 = s23.segment(:DTP, ["455", "D8", "20010401"]);nil
pp s25 = s24.segment(:REF, ["D9", "17312345600006351"]);nil
pp s26 = s25.segment(:CR2, ["", "", "", "", "", "", "", "C"]);nil
pp s27 = s26.segment(:HI , [["BK", "0340"], ["BF", "V7389"]]);nil
pp s28 = s27.segment(:NM1, ["82", "1", "SMITH", "ANDREW", "", "", "", "XX", "1788893331"]);nil
pp s29 = s28.segment(:PRV, ["PE", "PXC", "111N00000X"]);nil
pp s30 = s29.segment(:LX , ["1"]);nil
pp s31 = s30.segment(:SV1, [["HC", "98941"], "75", "UN", "1", "", "", ["1"], "", "Y"]);nil
pp s32 = s31.segment(:DTP, ["472", "D8", "20010401"]);nil
pp s33 = s32.segment(:SE , ["31", "0021"]);nil
pp s34 = s33.segment(:GE , ["1", "1"]);nil
pp s35 = s34.segment(:IEA, ["1", "000000905"]);nil
