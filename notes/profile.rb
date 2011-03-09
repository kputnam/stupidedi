require "stupidedi"
require "ruby-prof"

config = Stupidedi::Configuration.new
config.interchange.register(Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeDef, "00501")
config.functional_group.register(Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::FunctionalGroupDef, "005010")
config.transaction_set.register(Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::TransactionSetDefs::HC837, "005010")
config.transaction_set.register(Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::TransactionSetDefs::HP835, "005010")
config.transaction_set.register(Stupidedi::Guides::FiftyTen::X222::HC837, "005010X222")

s = Stupidedi::Builder.new(config)
doc = Stupidedi::Reader::StreamReader.new(Stupidedi::Reader::Input.build(File.open("837s.txt")))
tok = nil
pp s.read!(doc)

#result = RubyProf.profile do
#  tok = s.read!(doc)
#end
#
#RubyProf::GraphPrinter.new(result).print($stdout)

#pp s.read!(doc)

#if s.stuck?
#  pp s.failures#last.predecessor.predecessor.predecessor.predecessor
#else
#  pp s
#end

#pp tok

