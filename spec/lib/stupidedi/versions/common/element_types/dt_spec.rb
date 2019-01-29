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

  let(:position) { Stupidedi::Reader::Position.new(100, 4, 19, "test.x12") }

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

    describe "#date?" do
      specify { expect(invalid_val).to be_date }
    end

    describe "#proper?" do
      specify { expect(invalid_val).to_not be_proper }
    end

    describe "#position" do
      specify { expect(invalid_val.position).to eql(position) }
    end

    describe "#empty?" do
      specify { expect(invalid_val).to_not be_empty }
    end

    describe "#valid?" do
      specify { expect(invalid_val).to_not be_valid }
    end

    describe "#invalid?" do
      specify { expect(invalid_val).to be_invalid }
    end

    describe "#too_short?" do
      specify { expect(invalid_val).to_not be_too_short }
    end

    describe "#too_long?" do
      specify { expect(invalid_val).to_not be_too_long }
    end

    describe "#map(&block)" do
      specify { expect{|b| invalid_val.map(&b) }.to       yield_with_args(nil)        }
      specify { expect(invalid_val.map { "70130" }).to    be_invalid                  }
      specify { expect(invalid_val.map {|x| x }).to       eq(value_8(""))             }
      specify { expect(invalid_val.map { "20200130" }).to eq(Date.civil(2020, 1, 30)) }
    end

    todo "#==(other)"

    describe "#to_s" do
      it "is an empty string" do
        expect(invalid_val.to_s).to eq("")
      end
    end

    describe "#to_x12" do
      context "with truncation" do
        it "is an empty string" do
          expect(invalid_val.to_x12(true)).to eq("")
        end
      end

      context "without truncation" do
        it "is an empty string" do
          expect(invalid_val.to_x12(false)).to eq("")
        end
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

        it "includes element value" do
          expect(invalid_val.inspect).to match(/#{invalid_val.value.inspect}/)
        end
      end

      context "when forbidden" do
        let(:invalid_val) do
          element_use_8.copy(:requirement => e_not_used).value("boo", position)
        end

        include_examples "inspect"
      end

      context "when required" do
        let(:invalid_val) do
          element_use_8.copy(:requirement => e_mandatory).value("boo", position)
        end

        include_examples "inspect"
      end

      context "when optional" do
        let(:invalid_val) do
          element_use_8.copy(:requirement => e_optional).value("boo", position)
        end

        include_examples "inspect"
      end
    end
  end

  context "::Empty" do
    let(:empty_val) { value_8("") }

    describe "#date?" do
      specify { expect(empty_val).to be_date }
    end

    describe "#proper?" do
      specify { expect(empty_val).to_not be_proper }
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

    describe "#too_long?" do
      specify { expect(empty_val).to_not be_too_long }
    end

    describe "#map(&block)" do
      specify { expect{|b| empty_val.map(&b) }.to       yield_with_args(nil)        }
      specify { expect(empty_val.map { "70130" }).to    be_invalid                  }
      specify { expect(empty_val.map { "20110713" }).to eq(Date.civil(2011, 7, 13)) }
      specify { expect(empty_val.map {|x| x }).to       eq(empty_val)             }
    end

    describe "#to_s" do
      specify { expect(empty_val.to_s).to eql("") }
    end

    describe "#to_x12(truncate)" do
      context "with truncation" do
        specify { expect(empty_val.to_x12(true)).to eql("") }
      end

      context "without truncation" do
        specify { expect(empty_val.to_x12(false)).to eql("") }
      end
    end

    describe "#inspect" do
      shared_examples "inspect" do
        it "returns a String" do
          expect(empty_val.inspect).to be_a(String)
        end

        it "indicates empty " do
          expect(empty_val.inspect).to match(/empty/)
        end
      end

      context "when forbidden" do
        let(:empty_val) do
          element_use_8.copy(:requirement => e_not_used).value("", position)
        end

        include_examples "inspect"
      end

      context "when required" do
        let(:empty_val) do
          element_use_8.copy(:requirement => e_mandatory).value("", position)
        end

        include_examples "inspect"
      end

      context "when optional" do
        let(:empty_val) do
          element_use_8.copy(:requirement => e_optional).value("", position)
        end

        include_examples "inspect"
      end
    end

    describe "#==(other)" do
      specify { expect(empty_val).to eq(nil)                     }
      specify { expect(empty_val).to eq(empty_val)               }
      specify { expect(empty_val).to eq(value_8(""))             }
      specify { expect(empty_val).not_to eq(value_8(Date.today)) }
    end
  end

  context "::Proper" do
    describe "#position" do
      specify { expect(value_8(Date.today).position).to eql(position) }
    end

    describe "#proper?" do
      specify { expect(value_8(Date.today)).to be_proper }
    end

    describe "#empty?" do
      specify { expect(value_8(Date.today)).to_not be_empty }
    end

    describe "#valid?" do
      specify { expect(value_8(Date.today)).to be_valid }
    end

    describe "#invalid?" do
      specify { expect(value_8(Date.today)).not_to be_invalid }
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
    let(:improper_val) { value_8("200411") }

    describe "#valid?" do
      specify { expect(improper_val).to be_valid }
    end

    describe "#invalid?" do
      specify { expect(improper_val).to_not be_invalid }
    end

    describe "#proper?" do
      specify { expect(improper_val).to_not be_proper }
    end

    describe "#empty?" do
      specify { expect(improper_val).to_not be_empty }
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

    describe "#inspect" do
      shared_examples "inspect" do
        it "returns a String" do
          expect(improper_val.inspect).to be_a(String)
        end

        it "indicates valid" do
          expect(improper_val.inspect).to match(/value/)
        end

        it "includes element value" do
          expect(improper_val.inspect).to match(/\d{2}-\d{2}-\d{2}/)
        end
      end

      context "when forbidden" do
        let(:improper_val) do
          element_use_8.copy(:requirement => e_not_used).value("190131", position)
        end

        include_examples "inspect"
      end

      context "when required" do
        let(:improper_val) do
          element_use_8.copy(:requirement => e_mandatory).value("190131", position)
        end

        include_examples "inspect"
      end

      context "when optional" do
        let(:improper_val) do
          element_use_8.copy(:requirement => e_optional).value("190131", position)
        end

        include_examples "inspect"
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
