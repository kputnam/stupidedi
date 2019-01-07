describe "Stupidedi::Versions::Common::ElementTypes::DT" do
  let(:types) { Stupidedi::Versions::FiftyTen::ElementTypes }
  let(:r)     { Stupidedi::Versions::FiftyTen::ElementReqs }
  let(:d)     { Stupidedi::Schema::RepeatCount }

  # Dummy element definition E1: min/max length 8/8
  let(:eldef) { types::DT.new(:E1, "Date Element", 8, 8) }
  let(:eluse) { eldef.simple_use(r::Mandatory, d.bounded(1)) }

  # Dummy file position
  let(:position) { Stupidedi::Reader::Position.new(100, 4, 19, "test.x12") }

  context "Invalid" do
    let(:el) { eluse.value("20090230", position) }

    describe "#position" do
      specify { expect(el.position).to eq(position) }
    end

    describe "#empty?" do
      specify { expect(el).to_not be_empty }
    end

    describe "#valid?" do
      specify { expect(el).to_not be_valid }
    end

    describe "#too_short?" do
      specify { expect(el).to_not be_too_short }
    end

    describe "#too_short?" do
      specify { expect(el).to_not be_too_long }
    end
  end

  context "Empty" do
    let(:el) { eluse.value("", position) }

    describe "#position" do
      specify { expect(el.position).to eq(position) }
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
      specify { expect(el.map { "20110713" }).to be_date }
      specify { expect(el.map { "20110713" }).to be == "20110713" }

      specify { expect(el.map { nil }).to be == nil }
      specify { expect(el.map { nil }).to be_date }
    end

    describe "#to_s" do
      specify { expect(el.to_s).to eq("") }
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
      specify { expect(el).to be == nil }
      specify { expect(el).to be == el }
      specify { expect(el).to be == eluse.value("", position) }
    end
  end

  context "NonEmpty" do
    describe "#position" do
      specify { expect(eluse.value("20110713", position).position).to eq(position) }
    end

    describe "#empty?" do
      specify { expect(eluse.value("20110713", position)).to_not be_empty }
    end

    describe "#too_short?" do
      specify { expect(eluse.value("110713", position)).to       be_too_short }
      specify { expect(eluse.value("20110713", position)).to_not be_too_short }
    end

    describe "#too_long?" do
      specify { expect(eluse.value("20110713", position)).to_not be_too_long }
      specify { expect(eluse.value("920110713", position)).to    be_too_long }
    end

    describe "#to_s" do
      specify { expect(eluse.value("20110713", position).to_s).to be_a(String) }
      specify { expect(eluse.value("20110713", position).to_s).to be == "2011-07-13" }
    end

    describe "#to_x12" do
      context "with truncation" do
        specify { expect(eluse.value("20110713",  position).to_x12(true)).to be == "20110713" }
        specify { expect(eluse.value("920110713", position).to_x12(true)).to be == "20110713" }
      end

      context "without truncation" do
        specify { expect(eluse.value("20110713",  position).to_x12(false)).to be == "20110713"  }
        specify { expect(eluse.value("920110713", position).to_x12(false)).to be == "920110713" }
      end
    end

    describe "#map" do
      specify { expect(eluse.value("20110713", position).map{|d| "" }).to             be_empty }
      specify { expect(eluse.value("20110713", position).map{|d| Date.today }).to_not be_empty }
      specify { expect(eluse.value("20110713", position).map{|d| Date.today }).to_not be_invalid }
    end

    describe "#to_time" do
      before do
        @time = Time.now.utc
        @date = @time.to_date
      end

      specify { expect(eluse.value(@time, position).to_time(@time.hour, @time.min, @time.sec).to_i).to be == @time.to_i }
      specify { expect(eluse.value(@date, position).to_time(@time.hour, @time.min, @time.sec).to_i).to be == @time.to_i }
      specify { expect(eluse.value(@date, position).to_time(@time.hour, @time.min).to_date).to         be == @date }
      specify { expect(eluse.value(@date, position).to_time(@time.hour).to_date).to                    be == @date }
      specify { expect(eluse.value(@date, position).to_time.to_date).to                                be == @date }
    end

    describe "#oldest" do
      let(:el) { eluse.value(Date.today, position) }

      specify  { expect(el.future).to                  be == el }
      specify  { expect(el.oldest(Date.today >> 1)).to be == el }
      specify  { expect(el.oldest(Date.today >> 1)).to be == el }
    end

    describe "#newest" do
      let(:el) { eluse.value(Date.today, position) }

      specify  { expect(el.past).to                    be == el }
      specify  { expect(el.oldest(Date.today << 1)).to be == el }
      specify  { expect(el.oldest(Date.today >> 1)).to be == el }
    end

    describe "#==" do
      before do
        @time = Time.now.utc
        @date = @time.to_date
      end

      specify { expect(eluse.value(@time, position)).to be == @date }
      specify { expect(eluse.value(@time, position)).to be == @time }
      specify { expect(eluse.value(@date, position)).to be == @time }
      specify { expect(eluse.value(@date, position)).to be == @date }
    end

    describe "relational operators" do
      before do
        @time = Time.now.utc
        @date = @time.to_date
      end

      specify { expect(eluse.value(@date + 1, position)).to     be > @date }
      specify { expect(eluse.value(@date + 1, position)).to     be > @time }
      specify { expect(eluse.value(@date + 1, position)).to     be >= @date }
      specify { expect(eluse.value(@date + 1, position)).to     be >= @time }
      specify { expect(eluse.value(@date + 1, position)).not_to be == @date }
      specify { expect(eluse.value(@date + 1, position)).not_to be == @time }
      specify { expect(eluse.value(@date - 1, position)).to     be < @date }
      specify { expect(eluse.value(@date - 1, position)).to     be < @time }
      specify { expect(eluse.value(@date - 1, position)).to     be <= @date }
      specify { expect(eluse.value(@date - 1, position)).to     be <= @time }
      specify { expect(eluse.value(@date - 1, position)).not_to be == @date }
      specify { expect(eluse.value(@date - 1, position)).not_to be == @time }
    end

    # The Date and Time classes don't support type coercion until Ruby 1.9
    describe "relational operators" do
      before do
        @time = Time.now.utc
        @date = @time.to_date
      end

      specify { expect(@date).to be < eluse.value(@date + 1, position) }
      specify { expect(@time).to be < eluse.value(@date + 1, position) }

      specify { expect(@date).to be <= eluse.value(@date + 1, position) }
      specify { expect(@time).to be <= eluse.value(@date + 1, position) }

      specify { expect(@time).not_to be == eluse.value(@date + 1, position) }
      specify { expect(@date).not_to be == eluse.value(@date + 1, position) }

      specify { expect(@date).to be > eluse.value(@date - 1, position) }
      specify { expect(@time).to be > eluse.value(@date - 1, position) }

      specify { expect(@date).to be >= eluse.value(@date - 1, position) }
      specify { expect(@time).to be >= eluse.value(@date - 1, position) }

      specify { expect(@date).not_to be == eluse.value(@date - 1, position) }
      specify { expect(@time).not_to be == eluse.value(@date - 1, position) }
    end

    describe "arithmatic operators" do
      before do
        @time = Time.now.utc
        @date = @time.to_date
      end

      specify { expect((eluse.value(@date, position)  + 1)).to     be == (@date + 1) }
      specify { expect((eluse.value(@date, position) >> 1)).to     be == (@date >> 1) }
      specify { expect((eluse.value(@date, position) << 1)).to     be == (@date << 1) }
      specify { expect(eluse.value(@date, position).next_month).to be == @date.next_month }
      specify { expect(eluse.value(@date, position).prev_month).to be == @date.prev_month }
      specify { expect(eluse.value(@date, position).next_year).to  be == @date.next_year }
      specify { expect(eluse.value(@date, position).prev_year).to  be == @date.prev_year }
      specify { expect(eluse.value(@date, position).succ).to       be == @date.succ }
      specify { expect(eluse.value(@date, position).next).to       be == @date.next }
      specify { expect(eluse.value(@date, position).start).to      be == @date.start }
      specify { expect(eluse.value(@date, position).to_s).to       be == @date.to_s }
    end
  end
end
