describe Stupidedi::Versions::Common::ElementTypes::DT do
  using Stupidedi::Refinements
  include Definitions

  let(:element_use_8) do
    t = Stupidedi::Versions::Common::ElementTypes
    r = Stupidedi::Versions::Common::ElementReqs
    d = Stupidedi::Schema::RepeatCount
    t::DT.new(:DE1, "Date Element", 8, 8).simple_use(r::Mandatory, d.bounded(1))
  end

  let(:element_use_6) do
    t = Stupidedi::Versions::Common::ElementTypes
    r = Stupidedi::Versions::Common::ElementReqs
    d = Stupidedi::Schema::RepeatCount
    t::DT.new(:DE1, "Date Element", 6, 6).simple_use(r::Mandatory, d.bounded(1))
  end

  let(:position) { Stupidedi::Reader::NoPosition }

  def value_8(x)
    element_use_8.value(x, position)
  end

  def value_6(x)
    element_use_6.value(x, position)
  end

  context "with an invalid min_length" do
    it "raises an exception" do
      expect(lambda do
        Stupidedi::Versions::Common::ElementTypes::DT.new(:DE1, "Data Element", 4, 8)
      end).to raise_error(/min_length/)
    end
  end

  context "with an invalid max_length" do
    it "raises an exception" do
      expect(lambda do
        Stupidedi::Versions::Common::ElementTypes::DT.new(:DE1, "Data Element", 6, 7)
      end).to raise_error(/max_length/)
    end
  end

  describe ".value" do
    context "given an invalid String" do
      specify { expect(value_8("alphabet")).to  be_invalid }
      specify { expect(value_8("-20110530")).to be_invalid }
      specify { expect(value_8("-110530")).to   be_invalid }
      specify { expect(value_8("20115050")).to  be_invalid }
      specify { expect(value_8("115050")).to    be_invalid }
    end

    context "when given a DateVal::Proper" do
    end

    context "when given a DateVal::Improper" do
      specify { expect(value_8(value_8("190131"))).to eq(value_8("190131")) }
    end

    context "given a number" do
      specify { expect(value_8(20190131)).to be_invalid }
    end
  end

  context "::Invalid" do
    let(:invalid_val) { value_8("20090230") }
    let(:element_use) { element_use_8 }
    include_examples "global_element_types_invalid"

    describe "#date?" do
      specify { expect(invalid_val).to be_date }
    end

    describe "#proper?" do
      specify { expect(invalid_val).to_not be_proper }
    end
  end

  context "::Empty" do
    let(:empty_val)   { value_8("") }
    let(:valid_str)   { Date.civil(2020, 12, 31) }
    let(:invalid_str) { "20201300" }
    let(:element_use) { element_use_8 }
    include_examples "global_element_types_empty"

    describe "#date?" do
      specify { expect(empty_val).to be_date }
    end

    describe "#proper?" do
      specify { expect(empty_val).to_not be_proper }
    end
  end

  context "::Proper" do
    let(:element_val) { value_8("20180630") }
    let(:element_use) { element_use_8 }
    let(:valid_str)   { Date.civil(2020, 12, 31) }
    let(:invalid_str) { "wrong" }
    let(:inspect_str) { "2018-06-30" }
    include_examples "global_element_types_non_empty"

    describe "#proper?" do
      specify { expect(element_val).to be_proper }
    end

    describe "#too_short?" do
      specify { expect(value_8("110713")).to       be_too_short }
      specify { expect(value_8("20110713")).to_not be_too_short }
    end

    describe "#too_long?" do
      context "when length is 8" do
        specify { expect(value_8("20110713")).to_not be_too_long }
        specify { expect(value_8("920110713")).to    be_invalid  }
      end

      context "when length is 6" do
        specify { expect(value_6("110713")).to_not   be_too_long }
        specify { expect(value_6("20110713")).to_not be_too_long }
        specify { expect(value_6("920110713")).to    be_invalid  }
      end
    end

    describe "#to_s" do
      specify { expect(value_8("20110713").to_s).to eq("2011-07-13") }
    end

    describe "#to_x12(truncate)" do
      context "when max_length is 8" do
        context "with truncation" do
          specify { expect(value_8("20110713").to_x12(true)).to  eq("20110713") }
        end

        context "without truncation" do
          specify { expect(value_8("20110713").to_x12(false)).to  eq("20110713") }
        end
      end

      context "when length is 6" do
        context "with truncation" do
          specify { expect(value_6("20110713").to_x12(true)).to  eq("110713") }
        end

        context "without truncation" do
          specify { expect(value_6("20110713").to_x12(false)).to  eq("110713") }
        end
      end
    end

    describe "#inspect" do
      shared_examples "inspect" do
        it "returns a String" do
          expect(proper_val.inspect).to be_a(String)
        end

        it "indicates valid" do
          expect(proper_val.inspect).to match(/value/)
        end

        it "includes value" do
          expect(proper_val.inspect).to match(/#{proper_val.strftime("%Y-%m-%d")}/)
        end
      end

      context "when forbidden" do
        let(:proper_val) do
          element_use_8.copy(:requirement => e_not_used).value(Date.today, position)
        end

        include_examples "inspect"
      end

      context "when required" do
        let(:proper_val) do
          element_use_8.copy(:requirement => e_mandatory).value(Date.today, position)
        end

        include_examples "inspect"
      end

      context "when optional" do
        let(:proper_val) do
          element_use_8.copy(:requirement => e_optional).value(Date.today, position)
        end

        include_examples "inspect"
      end
    end

    describe "#map(&block)" do
      specify { expect(value_8("20110713").map{|d| "" }).to         be_empty }
      specify { expect{|b| value_8("20110713").map(&b) }.to         yield_with_args(Date.civil(2011, 7, 13)) }
      specify { expect(value_8("20110713").map{|d| Date.today }).to eq(value_8(Date.today)) }
    end

    describe "#to_time(hour, minute, second)" do
      before do
        @time = Time.now.utc
        @date = @time.to_date
        @tm   = Stupidedi::Versions::Common::ElementTypes::TM.new(
          :DE1, "Quailfier Element", 4, 6).simple_use(e_mandatory, bounded(1))
      end

      specify { expect(value_8(@date).to_time(@time).to_i).to                            eq(@time.to_i) }
      specify { expect(value_8(@date).to_time(@tm.value(@time, position)).to_i).to       eq(@time.to_i) }
      specify { expect(value_8(@date).to_time(@time.hour, @time.min, @time.sec).to_i).to eq(@time.to_i) }
      specify { expect(value_8(@date).to_time(@time.hour, @time.min, @time.sec).to_i).to eq(@time.to_i) }

      specify { expect(value_8(@date).to_time(@time.hour, @time.min).to_date).to         eq(@date) }
      specify { expect(value_8(@date).to_time(@time.hour).to_date).to                    eq(@date) }
      specify { expect(value_8(@date).to_time.to_date).to                                eq(@date) }
    end

    describe "#future" do
      specify { expect(value_8("20110530").future).to eq(value_8(Date.civil(2011, 5, 30))) }
    end

    describe "#past" do
      specify { expect(value_8("20110530").past).to eq(value_8(Date.civil(2011, 5, 30))) }
    end

    describe "#oldest(date)" do
      let(:date) { Date.today }

      specify  { expect(value_8(date).oldest(date >> 1)).to eq(date) }
      specify  { expect(value_8(date).oldest(date << 1)).to eq(date) }
    end

    describe "#newest(date)" do
      let(:date) { Date.today }

      specify  { expect(value_8(date).newest(date >> 1)).to eq(date) }
      specify  { expect(value_8(date).newest(date << 1)).to eq(date) }
    end

    describe "#==" do
      before do
        @time = Time.now.utc
        @date = @time.to_date
      end

      specify { expect(value_8(@time)).to eq(@date) }
      specify { expect(value_8(@time)).to eq(@time) }
      specify { expect(value_8(@date)).to eq(@time) }
      specify { expect(value_8(@date)).to eq(@date) }
    end

    describe "relational operators" do
      before do
        @time = Time.now.utc
        @date = @time.to_date
      end

      specify { expect(value_8(@date + 1)).to     be > @date }
      specify { expect(value_8(@date + 1)).to     be > @time }
      specify { expect(value_8(@date + 1)).to     be >= @date }
      specify { expect(value_8(@date + 1)).to     be >= @time }
      specify { expect(value_8(@date + 1)).not_to eq(@date) }
      specify { expect(value_8(@date + 1)).not_to eq(@time) }
      specify { expect(value_8(@date - 1)).to     be < @date }
      specify { expect(value_8(@date - 1)).to     be < @time }
      specify { expect(value_8(@date - 1)).to     be <= @date }
      specify { expect(value_8(@date - 1)).to     be <= @time }
      specify { expect(value_8(@date - 1)).not_to eq(@date) }
      specify { expect(value_8(@date - 1)).not_to eq(@time) }
    end

    # The Date and Time classes don't support type coercion until Ruby 1.9
    describe "relational operators" do
      before do
        @time = Time.now.utc
        @date = @time.to_date
      end

      specify { expect(@date).to be < value_8(@date + 1) }
      specify { expect(@time).to be < value_8(@date + 1) }

      specify { expect(@date).to be <= value_8(@date + 1) }
      specify { expect(@time).to be <= value_8(@date + 1) }

      specify { expect(@time).not_to eq(value_8(@date + 1)) }
      specify { expect(@date).not_to eq(value_8(@date + 1)) }

      specify { expect(@date).to be > value_8(@date - 1) }
      specify { expect(@time).to be > value_8(@date - 1) }

      specify { expect(@date).to be >= value_8(@date - 1) }
      specify { expect(@time).to be >= value_8(@date - 1) }

      specify { expect(@date).not_to eq(value_8(@date - 1)) }
      specify { expect(@time).not_to eq(value_8(@date - 1)) }
    end

    describe "arithmatic operators" do
      before do
        @time = Time.now.utc
        @date = @time.to_date
      end

      specify { expect(value_8(@date)  + 1).to       eq(@date  + 1) }
      specify { expect(value_8(@date) >> 1).to       eq(@date >> 1) }
      specify { expect(value_8(@date) << 1).to       eq(@date << 1) }
      specify { expect(value_8(@date).next_month).to eq(@date.next_month) }
      specify { expect(value_8(@date).prev_month).to eq(@date.prev_month) }
      specify { expect(value_8(@date).next_year).to  eq(@date.next_year) }
      specify { expect(value_8(@date).prev_year).to  eq(@date.prev_year) }
      specify { expect(value_8(@date).start).to      eq(@date.start) }
      specify { expect(value_8(@date).succ).to       eq(@date.succ) }
      specify { expect(value_8(@date).next).to       eq(@date.next) }
      specify { expect(value_8(@date).to_s).to       eq(@date.to_s) }
    end
  end

  context "::Improper" do
    let(:element_val)  { value_6("200311") }
    let(:element_use)  { element_use_6 }
    let(:invalid_str)  { "wrong" }
    let(:valid_str)    { "201231" }
    let(:inspect_str)  { "XX20-03-11" }
    include_examples "global_element_types_non_empty"

    let(:improper_val) { value_6("200411") }

    describe "#proper?" do
      specify { expect(improper_val).to_not be_proper }
    end

    describe "#copy(changes)" do
      specify { expect(improper_val.copy).to               eq(improper_val)      }
      specify { expect(improper_val.copy(:year => 21)).to  eq(value_8("210411")) }
      specify { expect(improper_val.copy(:month => 10)).to eq(value_8("201011")) }
      specify { expect(improper_val.copy(:day => 31)).to   eq(value_8("200431")) }
    end

    describe "#century(cc)" do
      specify { expect(improper_val.century(19)).to eq(value_8(Date.civil(1920, 4, 11))) }
      specify { expect(improper_val.century(20)).to eq(value_8(Date.civil(2020, 4, 11))) }
      specify { expect(improper_val.century(21)).to eq(value_8(Date.civil(2120, 4, 11))) }
    end

    describe "#oldest(date)" do
      specify { expect(improper_val.oldest(Date.civil(1919, 5, 30))).to eq(value_8(Date.civil(1920, 4, 11))) }
      specify { expect(improper_val.oldest(Date.civil(1920, 3, 30))).to eq(value_8(Date.civil(1920, 4, 11))) }
      specify { expect(improper_val.oldest(Date.civil(1920, 4, 10))).to eq(value_8(Date.civil(1920, 4, 11))) }
      specify { expect(improper_val.oldest(Date.civil(1920, 4, 11))).to eq(value_8(Date.civil(1920, 4, 11))) }
      specify { expect(improper_val.oldest(Date.civil(1920, 4, 12))).to eq(value_8(Date.civil(2020, 4, 11))) }
      specify { expect(improper_val.oldest(Date.civil(1920, 5, 10))).to eq(value_8(Date.civil(2020, 4, 11))) }
      specify { expect(improper_val.oldest(Date.civil(1921, 2, 20))).to eq(value_8(Date.civil(2020, 4, 11))) }
    end

    describe "#newest(date)" do
      specify { expect(improper_val.newest(Date.civil(2019, 5, 30))).to eq(value_8(Date.civil(1920, 4, 11))) }
      specify { expect(improper_val.newest(Date.civil(2020, 3, 30))).to eq(value_8(Date.civil(1920, 4, 11))) }
      specify { expect(improper_val.newest(Date.civil(2020, 4, 10))).to eq(value_8(Date.civil(1920, 4, 11))) }
      specify { expect(improper_val.newest(Date.civil(2020, 4, 11))).to eq(value_8(Date.civil(2020, 4, 11))) }
      specify { expect(improper_val.newest(Date.civil(2020, 4, 12))).to eq(value_8(Date.civil(2020, 4, 11))) }
      specify { expect(improper_val.newest(Date.civil(2020, 5, 10))).to eq(value_8(Date.civil(2020, 4, 11))) }
      specify { expect(improper_val.newest(Date.civil(2021, 2, 20))).to eq(value_8(Date.civil(2020, 4, 11))) }
    end

    describe "#past" do
      if Date.today <= Date.civil(2020, 4, 11)
        specify { expect(improper_val.past).to eq(value_8(Date.civil(1920, 4, 11))) }
      else
        specify { expect(improper_val.past).to eq(value_8(Date.civil(2020, 4, 11))) }
      end
    end

    describe "#future" do
      if Date.today <= Date.civil(2020, 4, 11)
        specify { expect(improper_val.future).to eq(value_8(Date.civil(2020, 4, 11))) }
      else
        specify { expect(improper_val.future).to eq(value_8(Date.civil(2120, 4, 11))) }
      end
    end

    describe "#to_s" do
      specify { expect(improper_val.to_s).to eq("XX200411") }
    end

    describe "#to_x12" do
      context "with truncation" do
        it "is an empty string" do
          expect(improper_val.to_x12(true)).to eq("200411")
        end
      end

      context "without truncation" do
        it "is an empty string" do
          expect(improper_val.to_x12(false)).to eq("200411")
        end
      end
    end
  end
end
