fdescribe Stupidedi::Versions::Common::ElementTypes::ID do
  using Stupidedi::Refinements

  let(:element_use) do
    t = Stupidedi::Versions::FiftyTen::ElementTypes
    r = Stupidedi::Versions::FiftyTen::ElementReqs
    d = Stupidedi::Schema::RepeatCount
    t::ID.new(:DE1, "Quailfier Element", 2, 4).simple_use(r::Mandatory, d.bounded(1))
  end

  let(:position) { Stupidedi::Reader::Position.new(100, 4, 19, "test.x12") }

  def value(x)
    element_use.value(x, position)
  end


  context "::Invalid" do
    let(:element_val) do
      invalid = "i don't have a #to_s"
      class << invalid; undef_method :to_s; end
      value(invalid)
    end

    describe "#id?" do
      specify { expect(element_val).to be_id }
    end

    describe "#position" do
      specify { expect(element_val.position).to eql(position) }
    end

    describe "#valid?" do
      specify { expect(element_val).to_not be_valid }
    end

    describe "#invalid?" do
      specify { expect(element_val).to be_invalid }
    end

    describe "#empty?" do
      specify { expect(element_val).to_not be_empty }
    end

    describe "#too_short?" do
      specify { expect(element_val).to_not be_too_short }
    end

    describe "#too_short?" do
      specify { expect(element_val).to_not be_too_long }
    end

    describe "#map(&block)" do
      specify { expect{|b| element_val.map(&b) }.to yield_with_args(nil) }
      specify { expect(element_val.map { "xx" }).to eq(value("xx"))      }
      specify { expect(element_val.map { nil }).to  eq(value(""))        }
    end

    describe "#to_s" do
      specify { expect(element_val.to_s).to eq("") }
    end

    describe "#to_x12" do
      context "with truncation" do
        specify { expect(element_val.to_x12(true)).to eql("") }
      end

      context "without truncation" do
        specify { expect(element_val.to_x12(false)).to eql("") }
      end
    end
  end

  context "::Empty" do
    let(:element_val) { value("") }

    describe "#id?" do
      specify { expect(element_val).to be_id }
    end

    describe "#position" do
      specify { expect(element_val.position).to eql(position) }
    end

    describe "#empty?" do
      specify { expect(element_val).to be_empty }
    end

    describe "#valid?" do
      specify { expect(element_val).to be_valid }
    end

    describe "#invalid?" do
      specify { expect(element_val).not_to be_invalid }
    end

    describe "#too_short?" do
      specify { expect(element_val).to_not be_too_short }
    end

    describe "#too_short?" do
      specify { expect(element_val).to_not be_too_long }
    end

    describe "#map(&block)" do
      specify { expect{|b| element_val.map(&b) }.to yield_with_args("") }
      specify { expect(element_val.map { "xx" }).to eq(value("xx"))     }
      specify { expect(element_val.map { nil }).to  eq(value(""))       }
    end

    describe "#to_s" do
      specify { expect(element_val.to_s).to eq("") }
    end

    describe "#to_x12(truncate)" do
      context "with truncation" do
        specify { expect(element_val.to_x12(true)).to eql("") }
      end

      context "without truncation" do
        specify { expect(element_val.to_x12(false)).to eql("") }
      end
    end

    describe "#==(other)" do
      specify { expect(element_val).to eq(element_val) }
      specify { expect(element_val).to eq("") }
      specify { expect(element_val).to eq(value("")) }
    end
  end

  context "::NonEmpty" do
    describe "#position" do
      specify { expect(value("ABC").position).to eql(position) }
    end

    describe "#id?" do
      specify { expect(value("ABC")).to be_id }
    end

    describe "#empty?" do
      specify { expect(value("ABC")).to_not be_empty }
    end

    describe "#too_short?" do
      specify { expect(value("A")).to           be_too_short }
      specify { expect(value("AB")).not_to      be_too_short }
      specify { expect(value("ABCD")).not_to    be_too_short }
      specify { expect(value("ABCDEF")).not_to  be_too_short }
    end

    describe "#too_long?" do
      specify { expect(value("A")).not_to     be_too_long }
      specify { expect(value("AB")).not_to    be_too_long }
      specify { expect(value("ABCD")).not_to  be_too_long }
      specify { expect(value("ABCDEF")).to    be_too_long }
    end

    describe "#to_s" do
      specify { expect(value("abc").to_s).to   be_a(String) }
      specify { expect(value("abc").to_s).to   eq("abc") }
      specify { expect(value(" abc ").to_s).to eq(" abc") }
    end

    describe "#to_x12(truncate)" do
      context "with truncation" do
        specify { expect(value("a").to_x12(true)).to      eq("a ") }
        specify { expect(value(" a").to_x12(true)).to     eq(" a") }
        specify { expect(value("ab").to_x12(true)).to     eq("ab") }
        specify { expect(value("abcd").to_x12(true)).to   eq("abcd") }
        specify { expect(value("abcdef").to_x12(true)).to eq("abcd") }
      end

      context "without truncation" do
        specify { expect(value("a").to_x12(false)).to      eq("a ") }
        specify { expect(value(" a").to_x12(false)).to     eq(" a") }
        specify { expect(value("ab").to_x12(false)).to     eq("ab") }
        specify { expect(value("abcdef").to_x12(false)).to eq("abcdef") }
      end
    end

    describe "#map(&block)" do
      specify { expect{|b| value("ABC").map(&b) }.to  yield_with_args("ABC") }
      specify { expect(value("abc").map(&:upcase)).to eq("ABC")              }
      specify { expect(value("abc").map(&:upcase)).to be_id                  }
    end

    describe "#==(Other)" do
      specify { expect(value("ABC")).not_to eq("") }
      specify { expect(value("ABC")).not_to eq("ABC ") }
      specify { expect(value("ABC")).not_to eq(" ABC") }
      specify { expect(value("ABC")).not_to eq(" ABC ") }
      specify { expect(value("ABC")).to     eq("ABC") }
      specify { expect(value("ABC")).to     eq(value("ABC")) }
      specify { expect(value("ABC")).to     eq(element_use.value("ABC", nil)) }
      specify { expect(value("ABC ")).to    eq("ABC") }
      specify { expect(value(" ABC")).to    eq(" ABC") }
      specify { expect(value(" ABC ")).to   eq(" ABC") }
    end
  end
end
