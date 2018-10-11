require "spec_helper"

describe Stupidedi::Versions::FunctionalGroups::FiftyTen::ElementTypes do
  describe "DateVal" do

    let(:x5010) { Stupidedi::Versions::FunctionalGroups::FiftyTen }
    let(:types) { x5010::ElementTypes }
    let(:req)   { x5010::ElementReqs }
    let(:rep)   { Stupidedi::Schema::RepeatCount }

    # Dummy element definition E1: min/max length 8/8
    let(:eldef) { types::DT.new(:E1, "Date Element", 8, 8) }
    let(:eluse) { eldef.simple_use(req::Mandatory, rep.bounded(1)) }

    # Dummy file position
    let(:position) { Stupidedi::Reader::Position.new(100, 4, 19, "test.x12") }

    context "Invalid" do
      let(:el) { eluse.value("20090230", position) }

      describe "#position" do
        specify { el.position.should == position }
      end

      describe "#empty?" do
        specify { el.should_not be_empty }
      end

      describe "#valid?" do
        specify { el.should_not be_valid }
      end

      describe "#too_short?" do
        specify { el.should_not be_too_short }
      end

      describe "#too_short?" do
        specify { el.should_not be_too_long }
      end
    end

    context "Empty" do
      let(:el) { eluse.value("", position) }

      describe "#position" do
        specify { el.position.should == position }
      end

      describe "#empty?" do
        specify { el.should be_empty }
      end

      describe "#valid?" do
        specify { el.should be_valid }
      end

      describe "#too_short?" do
        specify { el.should_not be_too_short }
      end

      describe "#too_short?" do
        specify { el.should_not be_too_long }
      end

      describe "#map" do
        specify { el.map { "20110713" }.should be_date }
        specify { el.map { "20110713" }.should == "20110713" }

        specify { el.map { nil }.should == nil }
        specify { el.map { nil }.should be_date }
      end

      describe "#to_s" do
        specify { el.to_s.should == "" }
      end

      describe "#to_x12" do
        context "with truncation" do
          specify { el.to_x12(true).should == "" }
          specify { el.to_x12(true).should be_a(String) }
        end

        context "without truncation" do
          specify { el.to_x12(false).should == "" }
          specify { el.to_x12(false).should be_a(String) }
        end
      end

      describe "#==" do
        specify { el.should == el }
        specify { el.should == nil }
        specify { el.should == eluse.value("", position) }
      end
    end

    context "NonEmpty" do
      describe "#position" do
        specify { eluse.value("20110713", position).position.should == position }
      end

      describe "#empty?" do
        specify { eluse.value("20110713", position).should_not be_empty }
      end

      describe "#too_short?" do
        specify { eluse.value("110713", position).should be_too_short }
        specify { eluse.value("20110713", position).should_not be_too_short }
      end

      describe "#too_long?" do
        specify { eluse.value("20110713", position).should_not be_too_long }
        specify { eluse.value("920110713", position).should be_too_long }
      end

      describe "#to_s" do
        specify { eluse.value("20110713", position).to_s.should be_a(String) }
        specify { eluse.value("20110713", position).to_s.should == "2011-07-13" }
      end

      describe "#to_x12" do
        context "with truncation" do
          specify { eluse.value("20110713", position).to_x12(true).should == "20110713" }
          specify { eluse.value("920110713", position).to_x12(true).should == "20110713" }
        end

        context "without truncation" do
          specify { eluse.value("20110713", position).to_x12(false).should == "20110713" }
          specify { eluse.value("920110713", position).to_x12(false).should == "920110713" }
        end
      end

      describe "#map" do
        specify { eluse.value("20110713", position).map{|d| "" }.should be_empty }
        specify { eluse.value("20110713", position).map{|d| Date.today }.should_not be_empty }
        specify { eluse.value("20110713", position).map{|d| Date.today }.should_not be_invalid }
      end

      describe "#to_time" do
        before do
          @time = Time.now.utc
          @date = @time.to_date
        end

        specify { eluse.value(@time, position).to_time(@time.hour, @time.min, @time.sec).to_i.should == @time.to_i }
        specify { eluse.value(@date, position).to_time(@time.hour, @time.min, @time.sec).to_i.should == @time.to_i }

        specify { eluse.value(@date, position).to_time(@time.hour, @time.min).to_date.should == @date }
        specify { eluse.value(@date, position).to_time(@time.hour).to_date.should == @date }
        specify { eluse.value(@date, position).to_time.to_date.should == @date }
      end

      describe "#oldest" do
        let(:el) { eluse.value(Date.today, position) }
        specify  { el.future.should == el }
        specify  { el.oldest(Date.today >> 1).should == el }
        specify  { el.oldest(Date.today >> 1).should == el }
      end

      describe "#newest" do
        let(:el) { eluse.value(Date.today, position) }
        specify  { el.past.should == el }
        specify  { el.oldest(Date.today << 1).should == el }
        specify  { el.oldest(Date.today >> 1).should == el }
      end

      describe "#==" do
        before do
          @time = Time.now.utc
          @date = @time.to_date
        end

        specify { eluse.value(@time, position).should == @date }
        specify { eluse.value(@time, position).should == @time }
        specify { eluse.value(@date, position).should == @time }
        specify { eluse.value(@date, position).should == @date }
      end

      describe "relational operators" do
        before do
          @time = Time.now.utc
          @date = @time.to_date
        end

        specify { eluse.value(@date + 1, position).should > @date }
        specify { eluse.value(@date + 1, position).should > @time }

        specify { eluse.value(@date + 1, position).should >= @date }
        specify { eluse.value(@date + 1, position).should >= @time }

        specify { eluse.value(@date + 1, position).should_not == @date }
        specify { eluse.value(@date + 1, position).should_not == @time }

        specify { eluse.value(@date - 1, position).should < @date }
        specify { eluse.value(@date - 1, position).should < @time }

        specify { eluse.value(@date - 1, position).should <= @date }
        specify { eluse.value(@date - 1, position).should <= @time }

        specify { eluse.value(@date - 1, position).should_not == @date }
        specify { eluse.value(@date - 1, position).should_not == @time }
      end

      # The Date and Time classes don't support type coercion until Ruby 1.9
      describe "relational operators", :ruby => "1.9" do
        before do
          @time = Time.now.utc
          @date = @time.to_date
        end

        specify { @date.should < eluse.value(@date + 1, position) }
        specify { @time.should < eluse.value(@date + 1, position) }

        specify { @date.should <= eluse.value(@date + 1, position) }
        specify { @time.should <= eluse.value(@date + 1, position) }

        specify { @time.should_not == eluse.value(@date + 1, position) }
        specify { @date.should_not == eluse.value(@date + 1, position) }

        specify { @date.should > eluse.value(@date - 1, position) }
        specify { @time.should > eluse.value(@date - 1, position) }

        specify { @date.should >= eluse.value(@date - 1, position) }
        specify { @time.should >= eluse.value(@date - 1, position) }

        specify { @date.should_not == eluse.value(@date - 1, position) }
        specify { @time.should_not == eluse.value(@date - 1, position) }
      end

      describe "arithmatic operators" do
        before do
          @time = Time.now.utc
          @date = @time.to_date
        end

        specify { (eluse.value(@date, position) + 1).should == (@date + 1) }
        specify { (eluse.value(@date, position) >> 1).should == (@date >> 1) }
        specify { (eluse.value(@date, position) << 1).should == (@date << 1) }

        context :ruby => "1.9" do
          specify { eluse.value(@date, position).next_month.should == @date.next_month }
          specify { eluse.value(@date, position).prev_month.should == @date.prev_month }
          specify { eluse.value(@date, position).next_year.should == @date.next_year }
          specify { eluse.value(@date, position).prev_year.should == @date.prev_year }
        end

        specify { eluse.value(@date, position).succ.should == @date.succ }
        specify { eluse.value(@date, position).next.should == @date.next }
        specify { eluse.value(@date, position).start.should == @date.start }

        specify { eluse.value(@date, position).to_s.should == @date.to_s }
      end

    end

  end
end


