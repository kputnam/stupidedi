using Stupidedi::Refinements

describe "Stupidedi::Versions::Common::ElementTypes::AN" do
  let(:types) { Stupidedi::Versions::FiftyTen::ElementTypes }
  let(:r)     { Stupidedi::Versions::FiftyTen::ElementReqs }
  let(:d)     { Stupidedi::Schema::RepeatCount }

  # Dummy element definition E1: min/max length 4/10
  let(:eldef) { types::AN.new(:E1, "String Element", 4, 10) }
  let(:eluse) { eldef.simple_use(r::Mandatory, d.bounded(1)) }

  # Dummy file position
  let(:position) { Stupidedi::Reader::Position.new(100, 4, 19, "test.x12") }

  context "Invalid" do
    skip
  end

  context "Empty" do
    let(:el) { eluse.value("", position) }

    describe "#position" do
      specify { expect(el.position).to be == position }
    end

    describe "#empty?" do
      specify { expect(el).to be_empty }
    end

    describe "#valid?" do
      specify { expect(el).to be_valid }
    end

    describe "#too_short?" do
      specify { expect(el).to_not be_too_short }
    end

    describe "#too_short?" do
      specify { expect(el).to_not be_too_long }
    end

    describe "#map" do
      specify { expect(el.map { "abc" }).to be == "abc" }
    end

    describe "#to_s" do
      specify { expect(el.to_s).to be == "" }
    end

    describe "#to_x12" do
      context "with truncation" do
        specify { expect(el.to_x12(true)).to be == "" }
        specify { expect(el.to_x12(true)).to be_a(String) }
      end

      context "without truncation" do
        specify { expect(el.to_x12(false)).to be == "" }
        specify { expect(el.to_x12(false)).to be_a(String) }
      end
    end

    describe "#==" do
      specify { expect(el).to be == el }
      specify { expect(el).to be == "" }
      specify { expect(el).to be == eluse.value("", position) }
    end
  end

  context "NonEmpty" do
    describe "#position" do
      specify { expect(eluse.value("ABC", position).position).to be == position }
    end

    describe "#empty?" do
      specify { expect(eluse.value("ABC", position)).to_not be_empty }
    end

    describe "#valid?" do
      specify { expect(eluse.value("ABC", position)).to be_valid }
    end

    describe "#too_short?" do
      specify { expect(eluse.value("A", position)).to               be_too_short }
      specify { expect(eluse.value("ABCD", position)).to_not        be_too_short }
      specify { expect(eluse.value("ABCDEFGHIJ", position)).to_not  be_too_short }
      specify { expect(eluse.value("ABCDEFGHIJK", position)).to_not be_too_short }
    end

    describe "#too_long?" do
      specify { expect(eluse.value("A", position)).to_not           be_too_long }
      specify { expect(eluse.value("ABCD", position)).to_not        be_too_long }
      specify { expect(eluse.value("ABCDEFGHIJ", position)).to_not  be_too_long }
      specify { expect(eluse.value("ABCDEFGHIJK", position)).to     be_too_long }
    end

    describe "#to_d" do
      specify { expect(eluse.value("1.3", position).to_d).to be == "1.3".to_d }
    end

    describe "#to_f" do
      specify { expect(eluse.value("1.3", position).to_f).to be == "1.3".to_f }
    end

    describe "#to_s" do
      specify { expect(eluse.value("abc", position).to_s).to    be_a(String) }
      specify { expect(eluse.value("abc", position).to_s).to    be == "abc"  }
      specify { expect(eluse.value(" abc ", position).to_s).to  be == " abc" }
    end

    describe "#to_x12" do
      context "with truncation" do
        specify { expect(eluse.value("a", position).to_x12(true)).to    be == "a   " }
        specify { expect(eluse.value(" a", position).to_x12(true)).to   be == " a  " }
        specify { expect(eluse.value("a"*10, position).to_x12(true)).to be == "a"*10 }
        specify { expect(eluse.value("a"*11, position).to_x12(true)).to be == "a"*10 }
      end

      context "without truncation" do
        specify { expect(eluse.value("a", position).to_x12(false)).to be    == "a   " }
        specify { expect(eluse.value(" a", position).to_x12(false)).to be   == " a  " }
        specify { expect(eluse.value("a"*10, position).to_x12(false)).to be == "a"*10 }
        specify { expect(eluse.value("a"*11, position).to_x12(false)).to be == "a"*11 }
      end
    end

    describe "#length" do
      specify { expect(eluse.value("abc", position).length).to    be == 3 }
      specify { expect(eluse.value("abc ", position).length).to   be == 3 }
      specify { expect(eluse.value(" abc", position).length).to   be == 4 }
      specify { expect(eluse.value(" abc ", position).length).to  be == 4 }
    end

    describe "#=~" do
      specify { expect(eluse.value("abc", position)).to be =~ /b/ }
    end

    describe "#map" do
      specify { expect(eluse.value("abc", position).map(&:upcase)).to be == "ABC" }
      specify { expect(eluse.value("abc", position).map(&:upcase)).to be_string }
    end

    describe "#to_date" do
      context "D8" do
        subject { eluse.value("20110713", position) }

        specify { expect(subject.to_date("D8")).to        be_a(Date) }
        specify { expect(subject.to_date("D8").year).to   be == 2011 }
        specify { expect(subject.to_date("D8").month).to  be == 7   }
        specify { expect(subject.to_date("D8").day).to    be == 13  }
      end

      context "RD8 start..stop" do
        subject { eluse.value("20080304-20110713", position) }

        specify { expect(subject.to_date("RD8")).to             be_a(Range) }
        specify { expect(subject.to_date("RD8").first).to       be_a(Date) }
        specify { expect(subject.to_date("RD8").first.year).to  be == 2008 }
        specify { expect(subject.to_date("RD8").first.month).to be == 3 }
        specify { expect(subject.to_date("RD8").first.day).to   be == 4 }
        specify { expect(subject.to_date("RD8").last).to        be_a(Date) }
        specify { expect(subject.to_date("RD8").last.year).to   be == 2011 }
        specify { expect(subject.to_date("RD8").last.month).to  be == 7 }
        specify { expect(subject.to_date("RD8").last.day).to    be == 13 }
      end

      context "RD8 stop..start" do
        subject { eluse.value("20110713-20080304", position) }

        specify { expect(subject.to_date("RD8")).to be_a(Range) }
        specify { expect(subject.to_date("RD8").last).to        be_a(Date) }
        specify { expect(subject.to_date("RD8").last.year).to   be == 2008 }
        specify { expect(subject.to_date("RD8").last.month).to  be == 3 }
        specify { expect(subject.to_date("RD8").last.day).to    be == 4 }
        specify { expect(subject.to_date("RD8").first).to       be_a(Date) }
        specify { expect(subject.to_date("RD8").first.year).to  be == 2011 }
        specify { expect(subject.to_date("RD8").first.month).to be == 7 }
        specify { expect(subject.to_date("RD8").first.day).to   be == 13 }
      end
    end

    describe "#==" do
      specify { expect(eluse.value("ABC", position)).not_to be == "" }
      specify { expect(eluse.value("ABC", position)).not_to be == "ABC " }
      specify { expect(eluse.value("ABC", position)).not_to be == " ABC" }
      specify { expect(eluse.value("ABC", position)).not_to be == " ABC " }
      specify { expect(eluse.value("ABC", position)).to     be == "ABC" }
      specify { expect(eluse.value("ABC", position)).to     be == eluse.value("ABC", position) }
      specify { expect(eluse.value("ABC ", position)).to    be == "ABC"   }
      specify { expect(eluse.value(" ABC", position)).to    be == " ABC" }
      specify { expect(eluse.value(" ABC ", position)).to   be == " ABC" }
    end
  end
end
