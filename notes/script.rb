require 'stupidedi'

#dict = Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::SegmentDefs
#book = dict.constants.inject({}){|hash,c| hash[c.to_sym] = dict.const_get(c); hash }; nil
#ss = OpenStruct.new(:element_separator => '*', :segment_terminator => '~', :component_separator => ':', :repetition_separator => '^')

## QTY01 is a simple element -- the tokenizer reads ":" as data
## QTY03 is a composite element -- the tokenizer reads two components
#pp Stupidedi::Reader::TokenReader.new(
#  Stupidedi::Reader::Input.build("QTY*A:B*C*D:E~"), ss, book).read_segment

## AK901 is a repeatable simple element -- the tokenizer reads two repeats with ":" as data
## AK902 is a non-repeatable simple element -- the tokenizer reads a single element
#pp Stupidedi::Reader::TokenReader.new(
#  Stupidedi::Reader::Input.build("AK9*A:B^C:D*E^F~"), ss, book).read_segment

## CTX01 is a repeatable composite element -- the tokenizer reads two composite elements
## CTX02 is a non-repeatable simple element -- the tokenizer reads a single element
#pp Stupidedi::Reader::TokenReader.new(
#  Stupidedi::Reader::Input.build("CTX*A:B^C:D*E^F~"), ss, book).read_segment

config = Stupidedi::Configuration.new;nil
config.interchange.register(Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeDef, "00501");nil
config.functional_group.register(Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::FunctionalGroupDef, "005010");nil
config.transaction_set.register(Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::TransactionSetDefs::HC837, "005010");nil
config.transaction_set.register(Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::TransactionSetDefs::HP835, "005010");nil
config.transaction_set.register(Stupidedi::Guides::FiftyTen::X222::HC837, "005010X222");nil
#config.transaction_set.register(Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::TransactionSetDefs::HC837, "005010X222");nil

pp  s0 = Stupidedi::Builder_::StateMachine.build(config);nil
pp doc = Stupidedi::Reader::StreamReader.new(Stupidedi::Reader::Input.build(File.open("837.txt")));nil
pp s0.read!(doc);nil
#pp s0
