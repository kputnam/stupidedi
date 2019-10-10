describe Stupidedi::Versions::Common::ElementTypes::ID do
  using Stupidedi::Refinements
  include Definitions

  let(:element_use) do
    t = Stupidedi::Versions::Common::ElementTypes
    r = Stupidedi::Versions::Common::ElementReqs
    d = Stupidedi::Schema::RepeatCount
    t::ID.new(:DE1, "Quailfier Element", 2, 4).simple_use(r::Mandatory, d.bounded(1))
  end

  let(:position) { Stupidedi::Reader::Position.new(100, 4, 19, "test.x12") }

  let(:invalid_str) do
    "i'm angry!!".tap do |invalid|
      class << invalid
        def to_s
          raise "grr"
        end
      end
    end
  end

  def value(x)
    element_use.value(x, position)
  end

  context "::Invalid" do
    let(:invalid_val) { value(invalid_str) }
    include_examples "global_element_types_invalid"

    describe "#id?" do
      specify { expect(invalid_val).to be_id }
    end
  end

  context "::Empty" do
    let(:empty_val) { value("") }
    let(:valid_str) { "X" }
    include_examples "global_element_types_empty"

    describe "#id?" do
      specify { expect(empty_val).to be_id }
    end
  end

  context "::NonEmpty" do
    let(:element_val) { value("ABC") }
    let(:valid_str)   { "XYZ" }
    include_examples "global_element_types_non_empty"

    describe "#id?" do
      specify { expect(element_val).to be_id }
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

    describe "#==(other)" do
      specify { expect(value("ABC")).to_not eq("") }
      specify { expect(value("ABC")).to     eq("ABC ") }
      specify { expect(value("ABC")).to_not eq(" ABC") }
      specify { expect(value("ABC")).to_not eq(" ABC ") }
      specify { expect(value("ABC")).to     eq("ABC") }
      specify { expect(value("ABC")).to     eq(value("ABC")) }
      specify { expect(value("ABC")).to     eq(element_use.value("ABC", nil)) }
      specify { expect(value("ABC ")).to    eq("ABC") }
      specify { expect(value(" ABC")).to    eq(" ABC") }
      specify { expect(value(" ABC ")).to   eq(" ABC") }
    end
  end
end
