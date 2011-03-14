require 'stupidedi'

pp root = Stupidedi::Builder_::InstructionTable.build(Stupidedi::Builder_::TransmissionState.new(nil, nil, nil, nil).instructions)
pp isa  = root.pop(0).drop(0).push(Stupidedi::Builder_::InterchangeState.instructions(Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeDef))
pp gs   = isa.drop(3).push(Stupidedi::Builder_::FunctionalGroupState.instructions(Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::FunctionalGroupDef))

pp use    = Stupidedi::Guides::FiftyTen::X222::HC837.table_defs.head.header_segment_uses.head
pp ptable = Stupidedi::Builder_::InstructionTable.build(Stupidedi::Builder_::TransactionSetState.instructions(Stupidedi::Guides::FiftyTen::X222::HC837))
pp pstart = ptable.at(use)
pp ttable = Stupidedi::Builder_::InstructionTable.build(Stupidedi::Builder_::TableState.instructions(use.parent))
pp tstart = ttable.at(use)
pp st = gs.concat(ptable.drop(pstart.try(:drop_count) || 0).concat(ttable.drop(tstart.drop_count)))

#dict = Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::SegmentDefs
#book = dict.constants.inject({}){|hash,c| hash[c.to_sym] = dict.const_get(c); hash }; nil
#ss = OpenStruct.new(:element_separator => '*', :segment_terminator => '~', :component_separator => ':', :repetition_separator => '^')
#
## QTY01 is a simple element -- the tokenizer reads ":" as data
## QTY03 is a composite element -- the tokenizer reads two components
#pp Stupidedi::Reader::TokenReader.new(
#  Stupidedi::Reader::Input.build("QTY*A:B*C*D:E~"), ss, book).read_segment
#
## AK901 is a repeatable simple element -- the tokenizer reads two repeats with ":" as data
## AK902 is a non-repeatable simple element -- the tokenizer reads a single element
#pp Stupidedi::Reader::TokenReader.new(
#  Stupidedi::Reader::Input.build("AK9*A:B^C:D*E^F~"), ss, book).read_segment
#
## CTX01 is a repeatable composite element -- the tokenizer reads two composite elements
## CTX02 is a non-repeatable simple element -- the tokenizer reads a single element
#pp Stupidedi::Reader::TokenReader.new(
#  Stupidedi::Reader::Input.build("CTX*A:B^C:D*E^F~"), ss, book).read_segment
#
#config = Stupidedi::Configuration.new;nil
#config.interchange.register(Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeDef, "00501");nil
#config.functional_group.register(Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::FunctionalGroupDef, "005010");nil
#config.transaction_set.register(Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::TransactionSetDefs::HC837, "005010");nil
#config.transaction_set.register(Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::TransactionSetDefs::HP835, "005010");nil
#config.transaction_set.register(Stupidedi::Guides::FiftyTen::X222::HC837, "005010X222");nil
#
#pp  s0 = Stupidedi::Builder.new(config);nil
#pp doc = Stupidedi::Reader::StreamReader.new(Stupidedi::Reader::Input.build(File.open("837P.txt")));nil
#pp  s0.read!(doc);nil
#
#pp doc.read_segment.map{|r| s0.successors(r.value) };nil
#
##pp doc = Stupidedi::Reader::StreamReader.new("ISA*00*...*00*...*ZZ*SUBMITTER*ZZ*RECEIVER*110223*1245*^*00501*333666999*1*T*\n:~")
#
#pp  s1 =  s0.segment(:ISA,
#                     [[:simple, "00"],
#                      [:simple, ""],
#                      [:simple, "00"],
#                      [:simple, ""],
#                      [:simple, "ZZ"],
#                      [:simple, "SUBMITTER"],
#                      [:simple, "ZZ"],
#                      [:simple, "RECEIVER"],
#                      [:simple, "110223"],
#                      [:simple, "1245"],
#                      [:simple, "^"],
#                      [:simple, "00501"],
#                      [:simple, "333666999"],
#                      [:simple, "1"],
#                      [:simple, "T"],
#                      [:simple, ":"]]);nil
#
#pp  s2 =  s1.segment(:GS,
#                     [[:simple, "HC"],
#                      [:simple, "SENDER"],
#                      [:simple, "RECEIVER"],
#                      [:simple, "20110223"],
#                      [:simple, "1245"],
#                      [:simple, "333666999"],
#                      [:simple, "X"],
#                      [:simple, "005010X222"]]);nil
#
#pp  s3 =  s2.segment(:ST,
#                     [[:simple, "837"],
#                      [:simple, "333666999"],
#                      [:simple, "005010X222"]]);nil
#
#pp  s4 =  s3.segment(:BHT,
#                     [[:simple, "0019"],
#                      [:simple, "00"],
#                      [:simple, "0123"],
#                      [:simple, "20010412"],
#                      [:simple, "1023"],
#                      [:simple, "RP"]]);nil
#
#pp  s5 =  s4.segment(:NM1,
#                     [[:simple, "41"],
#                      [:simple, "2"],
#                      [:simple, "JAMES A SMITH, M.D."],
#                      [:simple, ""],
#                      [:simple, ""],
#                      [:simple, ""],
#                      [:simple, ""],
#                      [:simple, "46"],
#                      [:simple, "TGJ23"]]);nil
#
#pp  s6 =  s5.segment(:PER,
#                     [[:simple, "IC"],
#                      [:simple, "LINDA"],
#                      [:simple, "TE"],
#                      [:simple, "8015552222"],
#                      [:simple, "EX"],
#                      [:simple, "231"]]);nil
#
#pp  s7 =  s6.segment(:NM1,
#                     [[:simple, "40"],
#                      [:simple, "2"],
#                      [:simple, "ABC CLEARINGHOUSE"],
#                      [:simple, ""],
#                      [:simple, ""],
#                      [:simple, ""],
#                      [:simple, ""],
#                      [:simple, "46"],
#                      [:simple, "66783JJT"]]);nil
#
#pp  s8 =  s7.segment(:HL,
#                     [[:simple, "1"],
#                      [:simple, ""],
#                      [:simple, "20"],
#                      [:simple, "1"]]);nil
#
#pp  s9 =  s8.segment(:NM1,
#                     [[:simple, "85"],
#                      [:simple, "2"],
#                      [:simple, "LANTANA CHIROPRACTIC FIRM"],
#                      [:simple, ""],
#                      [:simple, ""],
#                      [:simple, ""],
#                      [:simple, ""],
#                      [:simple, "XX"],
#                      [:simple, "1876543210"]]);nil
#
#pp s10 =  s9.segment(:N3, [[:simple, "1234 SONIC WAY ST"]]);nil
#
#pp s11 = s10.segment(:N4,
#                     [[:simple, "JACKSONVILLE"],
#                      [:simple, "FL"],
#                      [:simple, "331111234"]]);nil
#
#pp s12 = s11.segment(:REF,
#                     [[:simple, "EI"],
#                      [:simple, "999830001"]]);nil
#
#pp s13 = s12.segment(:HL,
#                     [[:simple, "2"],
#                      [:simple, "1"],
#                      [:simple, "22"],
#                      [:simple, "0"]]);nil
#
#pp s14 = s13.segment(:SBR,
#                     [[:simple, "P"],
#                      [:simple, "18"],
#                      [:simple, ""],
#                      [:simple, ""],
#                      [:simple, ""],
#                      [:simple, ""],
#                      [:simple, ""],
#                      [:simple, ""],
#                      [:simple, "CI"]]);nil
#
#pp s15 = s14.segment(:NM1,
#                     [[:simple, "IL"],
#                      [:simple, "1"],
#                      [:simple, "SMITH"],
#                      [:simple, "TED"],
#                      [:simple, ""],
#                      [:simple, ""],
#                      [:simple, ""],
#                      [:simple, "MI"],
#                      [:simple, "000221111A"]]);nil
#
#pp s16 = s15.segment(:N3, [[:simple, "236 N MAIN ST"]]);nil
#
#pp s17 = s16.segment(:N4, [[:simple, "MIAMI", "FL", "33413"]]);nil
#
#pp s18 = s17.segment(:DMG,
#                     [[:simple, "D8"],
#                      [:simple, "19430501"],
#                      [:simple, "M"]]);nil
#
#pp s19 = s18.segment(:NM1,
#                     [[:simple, "PR"],
#                      [:simple, "2"],
#                      [:simple, "BLUE SHIELD OF NORTH DAKOTA"],
#                      [:simple, ""],
#                      [:simple, ""],
#                      [:simple, ""],
#                      [:simple, ""],
#                      [:simple, "PI"],
#                      [:simple, "741234"]]);nil
#
#pp s20 = s19.segment(:N4,
#                     [[:simple, "FARGO"],
#                      [:simple, "FL"],
#                      [:simple, "33111"]]);nil
#
#pp s21 = s20.segment(:CLM,
#                     [[:simple, "MIMS-AZ 666"],
#                      [:simple, "75"],
#                      [:simple, ""],
#                      [:simple, ""],
#                      [:composite,
#                        [:simple, "11"],
#                        [:simple, "B"],
#                        [:simple, "1"]],
#                      [:simple, "Y"],
#                      [:simple, "A"],
#                      [:simple, "Y"],
#                      [:simple, "Y"]]);nil
#
#pp s22 = s21.segment(:DTP, ["454", "D8", "20010320"]);nil
#
#pp s23 = s22.segment(:DTP, ["431", "D8", "20010220"]);nil
#
#pp s24 = s23.segment(:DTP, ["455", "D8", "20010401"]);nil
#
#pp s25 = s24.segment(:REF, ["D9", "17312345600006351"]);nil
#
#pp s26 = s25.segment(:CR2, ["", "", "", "", "", "", "", "C"]);nil
#
#pp s27 = s26.segment(:HI , [["BK", "0340"], ["BF", "V7389"]]);nil
#
#pp s28 = s27.segment(:NM1, ["82", "1", "SMITH", "ANDREW", "", "", "", "XX", "1788893331"]);nil
#
#pp s29 = s28.segment(:PRV, ["PE", "PXC", "111N00000X"]);nil
#
#pp s30 = s29.segment(:LX , ["1"]);nil
#
#pp s31 = s30.segment(:SV1, [["HC", "98941"], "75", "UN", "1", "", "", ["1"], "", "Y"]);nil
#
#pp s32 = s31.segment(:DTP, ["472", "D8", "20010401"]);nil
#
#pp s33 = s32.segment(:SE , ["31", "0021"]);nil
#
#pp s34 = s33.segment(:GE , ["1", "1"]);nil
#
#pp s35 = s34.segment(:IEA, ["1", "000000905"]);nil
#
