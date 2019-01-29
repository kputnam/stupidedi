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

  def value(x)
    element_use.value(x, position)
  end

  context "::Invalid" do
    let(:invalid) do
      "i'm angry!!".tap do |invalid|
        class << invalid
          def to_s
            raise "grr"
          end
        end
      end
    end

    let(:invalid_val) do
      value(invalid)
    end

    describe "#id?" do
      specify { expect(invalid_val).to be_id }
    end

    describe "#position" do
      specify { expect(invalid_val.position).to eql(position) }
    end

    describe "#valid?" do
      specify { expect(invalid_val).to_not be_valid }
    end

    describe "#invalid?" do
      specify { expect(invalid_val).to be_invalid }
    end

    describe "#empty?" do
      specify { expect(invalid_val).to_not be_empty }
    end

    describe "#too_short?" do
      specify { expect(invalid_val).to_not be_too_short }
    end

    describe "#too_short?" do
      specify { expect(invalid_val).to_not be_too_long }
    end

    describe "#map(&block)" do
      specify { expect{|b| invalid_val.map(&b) }.to yield_with_args(nil) }
      specify { expect(invalid_val.map { "xx" }).to eq(value("xx"))      }
      specify { expect(invalid_val.map { nil }).to  eq(value(""))        }
    end

    describe "#to_s" do
      specify { expect(invalid_val.to_s).to eq("") }
    end

    describe "#to_x12" do
      context "with truncation" do
        specify { expect(invalid_val.to_x12(true)).to eql("") }
      end

      context "without truncation" do
        specify { expect(invalid_val.to_x12(false)).to eql("") }
      end
    end

    describe "#inspect" do
      shared_examples "inspect" do
        it "returns a String" do
          expect(invalid_val.inspect).to be_a(String)
        end

        it "indicates invalid" do
          expect(invalid_val.inspect).to match(/invalid/)
        end
      end

      context "when forbidden" do
        let(:invalid_val) do
          element_use.copy(:requirement => e_not_used).value(invalid, position)
        end

        include_examples "inspect"
      end

      context "when required" do
        let(:invalid_val) do
          element_use.copy(:requirement => e_mandatory).value(invalid, position)
        end

        include_examples "inspect"
      end

      context "when optional" do
        let(:invalid_val) do
          element_use.copy(:requirement => e_optional).value(invalid, position)
        end

        include_examples "inspect"
      end
    end

    describe "#==(other)" do
      specify { expect(invalid_val).to     eq(invalid_val) }
      specify { expect(invalid_val).to_not eq(value("")) }
      specify { expect(invalid_val).to_not eq("") }
    end

    describe "#copy(changes)" do
      specify { expect(invalid_val.copy).to eql(invalid_val) }
    end
  end

  context "::Empty" do
    let(:empty_val) { value("") }

    describe "#id?" do
      specify { expect(empty_val).to be_id }
    end

    describe "#position" do
      specify { expect(empty_val.position).to eql(position) }
    end

    describe "#empty?" do
      specify { expect(empty_val).to be_empty }
    end

    describe "#valid?" do
      specify { expect(empty_val).to be_valid }
    end

    describe "#invalid?" do
      specify { expect(empty_val).not_to be_invalid }
    end

    describe "#too_short?" do
      specify { expect(empty_val).to_not be_too_short }
    end

    describe "#too_short?" do
      specify { expect(empty_val).to_not be_too_long }
    end

    describe "#map(&block)" do
      specify { expect{|b| empty_val.map(&b) }.to yield_with_args(nil) }
      specify { expect(empty_val.map { "x" }).to eq(value("x")) }
      specify { expect(empty_val.map { nil }).to  eq(value("")) }
    end

    describe "#to_s" do
      specify { expect(empty_val.to_s).to eq("") }
    end

    describe "#to_x12(truncate)" do
      context "with truncation" do
        specify { expect(empty_val.to_x12(true)).to eql("") }
      end

      context "without truncation" do
        specify { expect(empty_val.to_x12(false)).to eql("") }
      end
    end

    describe "#==(other)" do
      specify { expect(empty_val).to eq(empty_val) }
      specify { expect(empty_val).to eq("") }
      specify { expect(empty_val).to eq(value("")) }
    end

    describe "#inspect" do
      shared_examples "inspect" do
        it "returns a String" do
          expect(empty_val.inspect).to be_a(String)
        end

        it "indicates empty" do
          expect(empty_val.inspect).to match(/empty/)
        end
      end

      context "when forbidden" do
        let(:empty_val) do
          element_use.copy(:requirement => e_not_used).empty(position)
        end

        include_examples "inspect"
      end

      context "when required" do
        let(:empty_val) do
          element_use.copy(:requirement => e_mandatory).empty(position)
        end

        include_examples "inspect"
      end

      context "when optional" do
        let(:empty_val) do
          element_use.copy(:requirement => e_optional).empty(position)
        end

        include_examples "inspect"
      end
    end

    describe "#copy(changes)" do
      specify { expect(empty_val.copy).to eq(empty_val) }
      specify { expect(empty_val.copy(:value => "abc")).to eq(value("abc")) }
      specify { expect(empty_val.copy(:value => "abc").position).to eql(position) }
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

    describe "#valid?" do
      specify { expect(value("ABC")).to be_valid }
    end

    describe "#invalid?" do
      specify { expect(value("ABC")).to_not be_invalid }
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

    describe "#inspect" do
      shared_examples "inspect" do
        it "returns a String" do
          expect(element_val.inspect).to be_a(String)
        end

        it "indicates valid" do
          expect(element_val.inspect).to match(/value/)
        end

        it "indicates value" do
          expect(element_val.inspect).to match(/#{element_val.value}/)
        end
      end

      context "when forbidden" do
        let(:element_val) do
          element_use.copy(:requirement => e_not_used).value("abc", position)
        end

        include_examples "inspect"
      end

      context "when required" do
        let(:element_val) do
          element_use.copy(:requirement => e_mandatory).value("abc", position)
        end

        include_examples "inspect"
      end

      context "when optional" do
        let(:element_val) do
          element_use.copy(:requirement => e_optional).value("abc", position)
        end

        include_examples "inspect"
      end

      context "with an internal code list" do
        let(:element_use_) do
          element_use.copy(
            :allowed_values => Stupidedi::Sets.absolute(["A"]),
            :definition     => element_use.definition.copy(
              :code_list => Stupidedi::Schema::CodeList.build("A" => "OK", "B" => "NO")))
        end

        context "and an allowed value" do
          it "indicates code meaning" do
            expect(element_use_.value("A", position).inspect).to match(/OK/)
          end
        end

        context "and an unallowed value" do
          it "indicates code meaning" do
            expect(element_use_.value("B", position).inspect).to match(/NO/)
          end
        end

        context "and an unknown value" do
          it "does not indicate code meaning" do
            expect(element_use_.value("C", position).inspect).to_not match(/OK|NO/)
          end
        end
      end
    end

    describe "#copy(changes" do
      specify { expect(value("abc").copy).to eq(value("abc")) }
      specify { expect(value("abc").copy(:value => "")).to eq(value("")) }
      specify { expect(value("abc").copy(:value => "").position).to eql(position) }
    end
  end
end
