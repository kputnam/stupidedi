config = Stupidedi::Configuration.new
config.interchange.register(Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeDef, "00501"); nil
config.functional_group.register(Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::FunctionalGroupDef, "005010"); nil
config.transaction_set.register(Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::TransactionSetDefs::HC837, "005010"); nil
config.transaction_set.register(Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::TransactionSetDefs::HP835, "005010"); nil
config.transaction_set.register(Stupidedi::Guides::FiftyTen::X222::HC837, "005010X222"); nil

pp  s0 = Stupidedi::Builder.new(config)
pp  s1 =  s0.segment(:ISA, ["00", "", "00", "", "ZZ", "SUBMITTER", "ZZ", "RECEIVER", "110223", "1245", "^", "00501", "333666999", "1", "T", ":"])
pp  s2 =  s1.segment(:GS,  ["HC", "SENDER", "RECEIVER", "20110223", "1245", "333666999", "X", "005010X222"])
pp  s3 =  s2.segment(:ST,  ["837", "333666999", "005010X222"])
pp  s4 =  s3.segment(:BHT, ["0019", "00", "0123", "20010412", "1023", "RP"])
pp  s5 =  s4.segment(:NM1, ["41", "2", "JAMES A SMITH, M.D.", "", "", "", "", "46", "TGJ23"])
pp  s6 =  s5.segment(:PER, ["IC", "LINDA", "TE", "8015552222", "EX", "231"])
pp  s7 =  s6.segment(:NM1, ["40", "2", "ABC CLEARINGHOUSE", "", "", "", "", "46", "66783JJT"])
pp  s8 =  s7.segment(:HL,  ["1", "", "20", "1"])
pp  s9 =  s8.segment(:NM1, ["85", "2", "LANTANA CHIROPRACTIC FIRM", "", "", "", "", "XX", "1876543210"])
pp s10 =  s9.segment(:N3,  ["1234 SONIC WAY ST"])
pp s11 = s10.segment(:N4,  ["JACKSONVILLE", "FL", "331111234"])
pp s12 = s11.segment(:REF, ["EI", "999830001"])
pp s13 = s12.segment(:HL,  ["2", "1", "22", "0"])
pp s14 = s13.segment(:SBR, ["P", "18", "", "", "", "", "", "", "CI"])
pp s15 = s14.segment(:NM1, ["IL", "1", "SMITH", "TED", "", "", "", "MI", "000221111A"])
pp s16 = s15.segment(:N3,  ["236 N MAIN ST"])
pp s17 = s16.segment(:N4,  ["MIAMI", "FL", "33413"])
pp s18 = s17.segment(:DMG, ["D8", "19430501", "M"])
pp s19 = s18.segment(:NM1, ["PR", "2", "BLUE SHIELD OF NORTH DAKOTA", "", "", "", "", "PI", "741234"])
pp s20 = s19.segment(:N4,  ["FARGO", "FL", "33111"])
pp s21 = s20.segment(:CLM, ["MIMS-AZ 666", "75", "", "", ["11", "B", "1"], "Y", "A", "Y", "Y"])

