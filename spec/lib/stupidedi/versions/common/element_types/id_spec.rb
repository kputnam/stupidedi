describe "Stupidedi::Versions::Common::ElementTypes::ID" do
  let(:types) { Stupidedi::Versions::FiftyTen::ElementTypes }
  let(:r)     { Stupidedi::Versions::FiftyTen::ElementReqs }
  let(:d)     { Stupidedi::Schema::RepeatCount }

  # Dummy element definition E1: min/max length 4/10
  let(:eldef) { types::ID.new(:E1, "Qualifier Element", 2, 4) }
  let(:eluse) { eldef.simple_use(r::Mandatory, d.bounded(1)) }

  # Dummy file position
  let(:position) { Stupidedi::Reader::Position.new(100, 4, 19, "test.x12") }

  context "Invalid" do
    let(:el) do
      invalid = "whatever" 
      class << invalid; undef_method :to_s; end
      eluse.value(invalid, position)
    end

    describe "#position" do
      specify { expect(el.position).to be == position }
    end

    describe "#valid?" do
      specify { expect(el).to_not be_valid }
    end

    describe "#empty?" do
      specify { expect(el).to_not be_empty }
    end

    describe "#too_short?" do
      specify { expect(el).to_not be_too_short }
    end

    describe "#too_short?" do
      specify { expect(el).to_not be_too_long }
    end

    describe "#map" do
      specify { expect(el.map { "xx" }).to  be_id }
      specify { expect(el.map { "xx" }).to  be == "xx" }
      specify { expect(el.map { nil }).to   be == "" }
      specify { expect(el.map { nil }).to   be_id }
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
      specify { expect(el.map { "xx" }).to  be_id }
      specify { expect(el.map { "xx" }).to  be == "xx" }
      specify { expect(el.map { nil }).to   be_id }
      specify { expect(el.map { nil }).to   be == "" }
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

    describe "#too_short?" do
      specify { expect(eluse.value("A", position)).to           be_too_short }
      specify { expect(eluse.value("AB", position)).not_to      be_too_short }
      specify { expect(eluse.value("ABCD", position)).not_to    be_too_short }
      specify { expect(eluse.value("ABCDEF", position)).not_to  be_too_short }
    end

    describe "#too_long?" do
      specify { expect(eluse.value("A", position)).not_to     be_too_long }
      specify { expect(eluse.value("AB", position)).not_to    be_too_long }
      specify { expect(eluse.value("ABCD", position)).not_to  be_too_long }
      specify { expect(eluse.value("ABCDEF", position)).to    be_too_long }
    end

    describe "#to_s" do
      specify { expect(eluse.value("abc", position).to_s).to   be_a(String) }
      specify { expect(eluse.value("abc", position).to_s).to   be == "abc" }
      specify { expect(eluse.value(" abc ", position).to_s).to be == " abc" }
    end

    describe "#to_x12" do
      context "with truncation" do
        specify { expect(eluse.value("a", position).to_x12(true)).to      be == "a " }
        specify { expect(eluse.value(" a", position).to_x12(true)).to     be == " a" }
        specify { expect(eluse.value("ab", position).to_x12(true)).to     be == "ab" }
        specify { expect(eluse.value("abcd", position).to_x12(true)).to   be == "abcd" }
        specify { expect(eluse.value("abcdef", position).to_x12(true)).to be == "abcd" }
      end

      context "without truncation" do
        specify { expect(eluse.value("a", position).to_x12(false)).to      be == "a " }
        specify { expect(eluse.value(" a", position).to_x12(false)).to     be == " a" }
        specify { expect(eluse.value("ab", position).to_x12(false)).to     be == "ab" }
        specify { expect(eluse.value("abcdef", position).to_x12(false)).to be == "abcdef" }
      end
    end

    describe "#map" do
      specify { expect(eluse.value("abc", position).map(&:upcase)).to be == "ABC" }
      specify { expect(eluse.value("abc", position).map(&:upcase)).to be_id }
    end

    describe "#==" do
      specify { expect(eluse.value("ABC",   position)).not_to be == "" }
      specify { expect(eluse.value("ABC",   position)).not_to be == "ABC " }
      specify { expect(eluse.value("ABC",   position)).not_to be == " ABC" }
      specify { expect(eluse.value("ABC",   position)).not_to be == " ABC " }
      specify { expect(eluse.value("ABC",   position)).to     be == "ABC" }
      specify { expect(eluse.value("ABC",   position)).to     be == eluse.value("ABC", position) }
      specify { expect(eluse.value("ABC ",  position)).to     be == "ABC" }
      specify { expect(eluse.value(" ABC",  position)).to     be == " ABC" }
      specify { expect(eluse.value(" ABC ", position)).to     be == " ABC" }
    end
  end
end
