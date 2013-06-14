require "stupidedi"
require "ruby-prof"
require "pp"

config = Stupidedi::Config.hipaa
b = Stupidedi::Builder::BuilderDsl.build(config, true)
b.ISA("00", "", "00", "", "ZZ", "SUBMITTER ID", "ZZ", "RECEIVER ID", "990531", "1230", nil, "00501", "123456789", "1", "T", nil)
b. GS("HC", "SENDER ID", "RECEIVER ID", "19990531", "1230", "1", "X", "005010X222")
b. ST("837", "1234", b.default)
b.BHT("0019", "00", "X"*30, "19990531", Time.now.utc, "CH")
b.NM1(b.default, "1", "PREMIER BILLING SERVICE", "", "", "", "", "46", "12EEER000TY")
b.PER("IC", "JERRY THE CLOWN", "TE", "3056660000")
b.NM1("40", "2", "REPRICER JONES", "", "", "", "", "46", "66783JJT")
b. HL("1", "", "20", "1")
b.NM1("85", "2", "PREMIER BILLING SERVICE", "", "", "", "", "XX", "123234560")
b. N3("1234 SEAWAY ST")
b. N4("MIAMI", "FL", "331111234")
b.REF("EI", "123667894")
b.PER("IC", b.blank, "TE", "3056661111")
b.NM1("87", "2")
b. N3("2345 OCEAN BLVD")
b. N4("MIAMI", "FL", "33111")
b. HL("2", "1", "22", "0")
b.SBR("S", "18", "", "", "12", "", "", "", "MB")
#.PAT("1", "2", "3", "4")
b.NM1("IL", "1", "BACON", "KEVIN", "", "", "", "MI", "222334444")
b. N3("236 N MAIN ST")
b. N4("MIAMI", "FL", "33413")
b.DMG("D8", "19431022", "F")

b.zipper.map {|z| pp z.root.node }

# config.editor.register(Stupidedi::Versions::Interchanges::FiveOhOne::InterchangeDef) { Stupidedi::Editor::FiveOhOneEd }
# config.editor.register(Stupidedi::Versions::FunctionalGroups::FiftyTen::FunctionalGroupDef) { Stupidedi::Editor::FiftyTenEd }
# config.editor.register(Stupidedi::Guides::FiftyTen::X222::HC837P) { Stupidedi::Editor::X222 }
# config.editor.register(Stupidedi::Guides::FiftyTen::X222A1::HC837P) { Stupidedi::Editor::X222 }
# 
# envelope_ed = Stupidedi::Editor::TransmissionEd.new(config, Time.now)
# pp envelope_ed.critique(b.machine).results

b.machine.parent.flatmap(&:parent).flatmap(&:parent).flatmap(&:zipper).tap do |z|
  separators =
    Stupidedi::Reader::Separators.build(:segment => "~\n",
                                        :element => "*",
                                        :component => ":",
                                        :repetition => "^")

  w = Stupidedi::Writer::Default.new(z.up.up, separators)
  s = w.write
  $stdout.puts(s)
end

#b.zipper.tap do |z|
#  p z.root.node.characters.to_a
#
#  separators =
#    Stupidedi::Reader::Separators.build(:segment => "~\n", :element => "*")
#
#  Stupidedi::Writer::Default.new(z.root, separators).write($stdout)
#end
conf4 = Stupidedi::Config.new.customize do |c|
  c.interchange.customize do |x|
    x.register("00401") { Stupidedi::Versions::Interchanges::FourOhOne::InterchangeDef }
  end

  c.functional_group.customize do |x|
    x.register("004010") { Stupidedi::Versions::FunctionalGroups::FortyTen::FunctionalGroupDef }
  end
end

b = Stupidedi::Builder::BuilderDsl.build(conf4, true)
b.ISA("00", "----------", "00", "----------", "ZZ", "111111111111111", "ZZ", "111111111111111", "990531", "1230", "U", "00401", "123456789", "0", "T", ">")
b. GS("SM", "SENDER ID", "RECEIVER ID", "19990531", "1230", "1", "X", "004010X12")
b. ST("204", "000010001")
b. B2("RBTW", "12345678", "PP")
b.B2A("00", "LT")
b.L11("55455", "CO")
b.L11("223456", "P8")
b.G62("64", "20100528", "1", "1000")
b.MS3("RBTW", "B", nil, "M")
b.NTE("ZZZ", "THESE ARE HEADER NOTES")
b.N1("BT", "BILL TO NAME", "ZZ", "12345")
b.N3("BILL TO ADDRESS")
b.N4("CITY", "ST", "ZIP", "USA")
b.G61("CN", "TRACY", "TE", "555-666-4444")
b. N7("123456", "FT")
b. M7("777C8")
b. S5("1", "CL")
b.L11("111", "PO")
b.L11("123456A1", "BM")
b.G62("37", "20100530", "I", "1000")
b.G62("38", "20100501", "K", "1000")
b.NTE("ZZZ", "THIS IS A PICKUP NOTE")

b.zipper.map {|z| pp z.root.node }
b.machine.parent.flatmap(&:parent).flatmap(&:parent).flatmap(&:zipper).tap do |z|
  separators =
    Stupidedi::Reader::Separators.build(:segment => "~\n",
                                        :element => "*",
                                        :component => ":",
                                        :repetition => "^")

  w = Stupidedi::Writer::Default.new(z.up.up, separators)
  s = w.write
  $stdout.puts(s)
end
