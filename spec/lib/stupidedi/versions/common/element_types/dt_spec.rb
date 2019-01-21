describe Stupidedi::Versions::Common::ElementTypes::DT do
  using Stupidedi::Refinements

  let(:element_use) do
    t = Stupidedi::Versions::FiftyTen::ElementTypes
    r = Stupidedi::Versions::FiftyTen::ElementReqs
    d = Stupidedi::Schema::RepeatCount
    t::DT.new(:DE1, "Date Element", 8, 8).simple_use(r::Mandatory, d.bounded(1))
  end

  let(:position) { Stupidedi::Reader::Position.new(100, 4, 19, "test.x12") }

  def value(x)
    element_use.value(x, position)
  end

  describe ".value" do
    specify { expect(value(Date.civil(2020, 1, 30))).to eq(value("20200130")) }
    specify { expect(value(Date.today)).to              eq(value(Time.now))   }
  end

  context "::Invalid" do
    let(:element_val) { value("20090230") }

    describe "#date?" do
      specify { expect(element_val).to be_date }
    end

    describe "#position" do
      specify { expect(element_val.position).to eql(position) }
    end

    describe "#empty?" do
      specify { expect(element_val).to_not be_empty }
    end

    describe "#valid?" do
      specify { expect(element_val).to_not be_valid }
    end

    describe "#invalid?" do
      specify { expect(element_val).to be_invalid }
    end

    describe "#too_short?" do
      specify { expect(element_val).to_not be_too_short }
    end

    describe "#too_short?" do
      specify { expect(element_val).to_not be_too_long }
    end

    describe "#map(&block)" do
      specify { expect{|b| element_val.map(&b) }.to       yield_with_args(nil)        }
      specify { expect(element_val.map { "70130" }).to    be_invalid                  }
      specify { expect(element_val.map {|x| x }).to       eq(value(""))               }
      specify { expect(element_val.map { "20200130" }).to eq(Date.civil(2020, 1, 30)) }
    end

    todo "#==(other)"
  end

  context "::Empty" do
    let(:element_val) { value("") }

    describe "#date?" do
      specify { expect(element_val).to be_date }
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
      specify { expect{|b| element_val.map(&b) }.to       yield_with_args(nil)        }
      specify { expect(element_val.map { "70130" }).to    be_invalid                  }
      specify { expect(element_val.map { "20110713" }).to eq(Date.civil(2011, 7, 13)) }
      specify { expect(element_val.map {|x| x }).to       eq(element_val)             }
    end

    describe "#to_s" do
      specify { expect(element_val.to_s).to eql("") }
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
      specify { expect(element_val).to eq(nil)                    }
      specify { expect(element_val).to eq(element_val)            }
      specify { expect(element_val).to eq(value(""))              }
      specify { expect(element_val).not_to eq(value(Date.today))  }
    end
  end

  context "::Proper" do
    describe "#position" do
      specify { expect(value(Date.today).position).to eql(position) }
    end

    describe "#empty?" do
      specify { expect(value(Date.today)).to_not be_empty }
    end

    describe "#valid?" do
      specify { expect(value(Date.today)).to be_valid }
    end

    describe "#invalid?" do
      specify { expect(value(Date.today)).not_to be_invalid }
    end

    describe "#too_short?" do
      specify { expect(value("110713")).to       be_too_short }
      specify { expect(value("20110713")).to_not be_too_short }
    end

    describe "#too_long?" do
      specify { expect(value("20110713")).to_not be_too_long }
      specify { expect(value("920110713")).to    be_too_long }
    end

    describe "#to_s" do
      specify { expect(value("20110713").to_s).to eq("2011-07-13") }
    end

    describe "#to_x12(truncate)" do
      context "with truncation" do
        specify { expect(value("20110713").to_x12(true)).to  eq("20110713") }
        specify { expect(value("920110713").to_x12(true)).to eq("20110713") }
      end

      context "without truncation" do
        specify { expect(value("20110713").to_x12(false)).to  eq("20110713")  }
        specify { expect(value("920110713").to_x12(false)).to eq("920110713") }
      end
    end

    describe "#map(&block)" do
      specify { expect(value("20110713").map{|d| "" }).to         be_empty }
      specify { expect{|b| value("20110713").map(&b) }.to         yield_with_args(Date.civil(2011, 7, 13)) }
      specify { expect(value("20110713").map{|d| Date.today }).to eq(value(Date.today)) }
    end

    describe "#to_time(hour, minute, second)" do
      before do
        @time = Time.now.utc
        @date = @time.to_date
      end

      specify { expect(value(@time).to_time(@time.hour, @time.min, @time.sec).to_i).to eq(@time.to_i) }
      specify { expect(value(@date).to_time(@time.hour, @time.min, @time.sec).to_i).to eq(@time.to_i) }
      specify { expect(value(@date).to_time(@time.hour, @time.min).to_date).to         eq(@date) }
      specify { expect(value(@date).to_time(@time.hour).to_date).to                    eq(@date) }
      specify { expect(value(@date).to_time.to_date).to                                eq(@date) }
    end

    describe "#future" do
      specify { expect(value("20110530").future).to eq(value(Date.civil(2011, 5, 30))) }
    end

    describe "#past" do
      specify { expect(value("20110530").past).to eq(value(Date.civil(2011, 5, 30))) }
    end

    describe "#oldest(date)" do
      let(:date) { Date.today }

      specify  { expect(value(date).oldest(date >> 1)).to eq(date) }
      specify  { expect(value(date).oldest(date << 1)).to eq(date) }
    end

    describe "#newest(date)" do
      let(:date) { Date.today }

      specify  { expect(value(date).newest(date >> 1)).to eq(date) }
      specify  { expect(value(date).newest(date << 1)).to eq(date) }
    end

    describe "#==" do
      before do
        @time = Time.now.utc
        @date = @time.to_date
      end

      specify { expect(value(@time)).to eq(@date) }
      specify { expect(value(@time)).to eq(@time) }
      specify { expect(value(@date)).to eq(@time) }
      specify { expect(value(@date)).to eq(@date) }
    end

    describe "relational operators" do
      before do
        @time = Time.now.utc
        @date = @time.to_date
      end

      specify { expect(value(@date + 1)).to     be > @date }
      specify { expect(value(@date + 1)).to     be > @time }
      specify { expect(value(@date + 1)).to     be >= @date }
      specify { expect(value(@date + 1)).to     be >= @time }
      specify { expect(value(@date + 1)).not_to eq(@date) }
      specify { expect(value(@date + 1)).not_to eq(@time) }
      specify { expect(value(@date - 1)).to     be < @date }
      specify { expect(value(@date - 1)).to     be < @time }
      specify { expect(value(@date - 1)).to     be <= @date }
      specify { expect(value(@date - 1)).to     be <= @time }
      specify { expect(value(@date - 1)).not_to eq(@date) }
      specify { expect(value(@date - 1)).not_to eq(@time) }
    end

    # The Date and Time classes don't support type coercion until Ruby 1.9
    describe "relational operators" do
      before do
        @time = Time.now.utc
        @date = @time.to_date
      end

      specify { expect(@date).to be < value(@date + 1) }
      specify { expect(@time).to be < value(@date + 1) }

      specify { expect(@date).to be <= value(@date + 1) }
      specify { expect(@time).to be <= value(@date + 1) }

      specify { expect(@time).not_to eq(value(@date + 1)) }
      specify { expect(@date).not_to eq(value(@date + 1)) }

      specify { expect(@date).to be > value(@date - 1) }
      specify { expect(@time).to be > value(@date - 1) }

      specify { expect(@date).to be >= value(@date - 1) }
      specify { expect(@time).to be >= value(@date - 1) }

      specify { expect(@date).not_to eq(value(@date - 1)) }
      specify { expect(@time).not_to eq(value(@date - 1)) }
    end

    describe "arithmatic operators" do
      before do
        @time = Time.now.utc
        @date = @time.to_date
      end

      specify { expect(value(@date)  + 1).to       eq(@date  + 1) }
      specify { expect(value(@date) >> 1).to       eq(@date >> 1) }
      specify { expect(value(@date) << 1).to       eq(@date << 1) }
      specify { expect(value(@date).next_month).to eq(@date.next_month) }
      specify { expect(value(@date).prev_month).to eq(@date.prev_month) }
      specify { expect(value(@date).next_year).to  eq(@date.next_year) }
      specify { expect(value(@date).prev_year).to  eq(@date.prev_year) }
      specify { expect(value(@date).start).to      eq(@date.start) }
      specify { expect(value(@date).succ).to       eq(@date.succ) }
      specify { expect(value(@date).next).to       eq(@date.next) }
      specify { expect(value(@date).to_s).to       eq(@date.to_s) }
    end
  end

  context "::Improper" do
    let(:element_val) { value("200411") }

    describe "#century(cc)" do
      specify { expect(element_val.century(19)).to eq(value(Date.civil(1920, 4, 11))) }
      specify { expect(element_val.century(20)).to eq(value(Date.civil(2020, 4, 11))) }
      specify { expect(element_val.century(21)).to eq(value(Date.civil(2120, 4, 11))) }
    end

    describe "#oldest(date)" do
      specify { expect(element_val.oldest(Date.civil(1919, 5, 30))).to eq(value(Date.civil(1920, 4, 11))) }
      specify { expect(element_val.oldest(Date.civil(1920, 3, 30))).to eq(value(Date.civil(1920, 4, 11))) }
      specify { expect(element_val.oldest(Date.civil(1920, 4, 10))).to eq(value(Date.civil(1920, 4, 11))) }
      specify { expect(element_val.oldest(Date.civil(1920, 4, 11))).to eq(value(Date.civil(1920, 4, 11))) }
      specify { expect(element_val.oldest(Date.civil(1920, 4, 12))).to eq(value(Date.civil(2020, 4, 11))) }
      specify { expect(element_val.oldest(Date.civil(1920, 5, 10))).to eq(value(Date.civil(2020, 4, 11))) }
      specify { expect(element_val.oldest(Date.civil(1921, 2, 20))).to eq(value(Date.civil(2020, 4, 11))) }
    end

    describe "#newest(date)" do
      specify { expect(element_val.newest(Date.civil(2019, 5, 30))).to eq(value(Date.civil(1920, 4, 11))) }
      specify { expect(element_val.newest(Date.civil(2020, 3, 30))).to eq(value(Date.civil(1920, 4, 11))) }
      specify { expect(element_val.newest(Date.civil(2020, 4, 10))).to eq(value(Date.civil(1920, 4, 11))) }
      specify { expect(element_val.newest(Date.civil(2020, 4, 11))).to eq(value(Date.civil(2020, 4, 11))) }
      specify { expect(element_val.newest(Date.civil(2020, 4, 12))).to eq(value(Date.civil(2020, 4, 11))) }
      specify { expect(element_val.newest(Date.civil(2020, 5, 10))).to eq(value(Date.civil(2020, 4, 11))) }
      specify { expect(element_val.newest(Date.civil(2021, 2, 20))).to eq(value(Date.civil(2020, 4, 11))) }
    end

    describe "#past" do
      if Date.today <= Date.civil(2020, 4, 11)
        specify { expect(element_val.past).to eq(value(Date.civil(1920, 4, 11))) }
      else
        specify { expect(element_val.past).to eq(value(Date.civil(2020, 4, 11))) }
      end
    end

    describe "#future" do
    end
  end
end
