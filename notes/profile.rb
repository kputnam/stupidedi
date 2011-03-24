require "stupidedi"
require "ruby-prof"

Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeDef
Stupidedi::Guides::FiftyTen::X222::HC837

config = Stupidedi::Config.new
config.interchange.register("00501") { Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeDef }
config.functional_group.register("005010") { Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::FunctionalGroupDef }
config.transaction_set.register("005010", "HP", "835") { Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::TransactionSetDefs::HP835 }
config.transaction_set.register("005010", "HC", "837") { Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::TransactionSetDefs::HC837 }
config.transaction_set.register("005010X221", "HP", "835") { Stupidedi::Guides::FiftyTen::X221::HP835 }
config.transaction_set.register("005010X222", "HC", "837") { Stupidedi::Guides::FiftyTen::X222::HC837 }

input     = Stupidedi::Reader::Input.build(File.open(ARGV.first))
tokenizer = Stupidedi::Reader::StreamReader.new(input)
parser    = Stupidedi::Builder::StateMachine.build(config)

start = Time.now
parser.read!(tokenizer)
stop  = Time.now
puts stop - start
#p parser.zipper.root.node

#result = RubyProf.profile do
#  parser.read!(tokenizer)
#end
#RubyProf::GraphPrinter.new(result || RubyProf.stop).print($stdout)
#pp parser
