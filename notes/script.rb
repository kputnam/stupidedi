
routes = Stupidedi::Envelope::Router.new

routes.interchange.register(Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeDef, "00501"); nil
routes.functional_group.register(Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::FunctionalGroupDef, "005010"); nil
routes.transaction_set.register(Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::TransactionSetDefs::HC837, "005010"); nil
routes.transaction_set.register(Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::TransactionSetDefs::HP835, "005010"); nil

pp s0 = Stupidedi::Builder.new(routes)
pp s1 = s0.segment(:ISA, ["00", "", "00", "", "ZZ", "SUBMITTER", "ZZ", "RECEIVER", "110223", "1245", "^", "00501", "333666999", "1", "T", ":"])
pp s2 = s1.segment(:GS, ["HC", "SENDER", "RECEIVER", "20110223", "1245", "333666999", "X", "005010"])
pp s3 = s2.segment(:ST, ["837", "333666999"])
pp s4 = s3.segment(:HL, ["1", "", "20", "1"])
pp s5 = s4.segment(:CLM, ["CLIENT-KS 123456", 500, "", "", ["11", "B", "1"]])

