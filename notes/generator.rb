require "stupidedi"
require "ruby-prof"

config = Stupidedi::Config.new
config.interchange.register("00501") { Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeDef }
config.functional_group.register("005010") { Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::FunctionalGroupDef }
config.transaction_set.register("005010", "HP", "835") { Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::TransactionSetDefs::HP835 }
config.transaction_set.register("005010", "HC", "837") { Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::TransactionSetDefs::HC837 }
config.transaction_set.register("005010X221", "HP", "835") { Stupidedi::Guides::FiftyTen::X221::HP835 }
config.transaction_set.register("005010X222", "HC", "837") { Stupidedi::Guides::FiftyTen::X222::HC837 }

b = Stupidedi::Builder::BuilderDsl.new(config)
#.ISA("00", "", "00", "", "ZZ", "SUBMITTER ID", "ZZ", "RECEIVER ID", "990531", "1230", "^", "00501", "1234567890", "1", "T", "~")
#. GS("HP", "SENDER ID", "RECEIVER ID", "19990531", "1230", "1", "X", "005010X221")
#. ST("835", "1234", b.not_used)

b.ISA("00", "", "00", "", "ZZ", "SUBMITTER ID", "ZZ", "RECEIVER ID", "990531", "1230", "^", "00501", "1234567890", "1", "T", "~")
b. GS("HC", "SENDER ID", "RECEIVER ID", "19990531", "1230", "1", "X", "005010X222")
b. ST("837", "1234", b.default)
b.BHT("0019", "00", "1230", "19990531", "CH")
b.NM1("41", "2", "PREMIER BILLING SERVICE", "", "", "", "", "46", "12EEER000TY")
b.PER("IC", "JERRY THE CLOWN", "TE", "3056660000")
b.NM1("40", "2", "REPRICER JONES", "", "", "", "", "46", "66783JJT")
b. HL("1", "", "20", "1")
b.NM1("85", "2", "PREMIER BILLING SERVICE", "", "", "", "", "XX", "123234560")
b. N3("1234 SEAWAY ST")
b. N4("MIAMI", "FL", "331111234")
b.REF("EI", "123667894")
b.PER("IC", "CONNIE CHUNG", "TE", "3056661111")
b.NM1("87", "2")
b. N3("2345 OCEAN BLVD")
b. N4("MIAMI", "FL", "33111")
b. HL("2", "1", "22", "0")
b.SBR("S", "18", "", "", "12", "", "", "", "MB")
b.NM1("IL", "1", "BACON", "KEVIN", "", "", "", "MI", "222334444")
b. N3("236 N MAIN ST")
b. N4("MIAMI", "FL", "33413")
b.DMG("D8", "19431022", "M")

z = b.zipper
pp z.root

#b.GS("HP", "SENDER ID", "RECEIVER ID", "19990531", "0030", "1", "X", "005010X221")
#b.ST("835", "4321")

# pp b
# pp b.successors
