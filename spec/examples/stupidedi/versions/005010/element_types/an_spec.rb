require "spec_helper"
using Stupidedi::Refinements

describe Stupidedi::Versions::FiftyTen::ElementTypes do
  describe "StringVal" do

    let(:x5010) { Stupidedi::Versions::FiftyTen }
    let(:types) { x5010::ElementTypes }
    let(:req)   { x5010::ElementReqs }
    let(:rep)   { Stupidedi::Schema::RepeatCount }

    # Dummy element definition E1: min/max length 4/10
    let(:eldef) { types::AN.new(:E1, "String Element", 4, 10) }
    let(:eluse) { eldef.simple_use(req::Mandatory, rep.bounded(1)) }

    # Dummy file position
    let(:position) { Stupidedi::Reader::Position.new(100, 4, 19, "test.x12") }

    context "Invalid" do
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
        specify { el.map { "abc" }.should == "abc" }
        specify { el.map { "abc" }.should be_string }
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
        specify { el.should == "" }
        specify { el.should == eluse.value("", position) }
      end
    end

    context "NonEmpty" do
      describe "#position" do
        specify { eluse.value("ABC", position).position.should == position }
      end

      describe "#empty?" do
        specify { eluse.value("ABC", position).should_not be_empty }
      end

      describe "#valid?" do
        specify { eluse.value("ABC", position).should be_valid }
      end

      describe "#too_short?" do
        specify { eluse.value("A", position).should be_too_short }
        specify { eluse.value("ABCD", position).should_not be_too_short }
        specify { eluse.value("ABCDEFGHIJ", position).should_not be_too_short }
        specify { eluse.value("ABCDEFGHIJK", position).should_not be_too_short }
      end

      describe "#too_long?" do
        specify { eluse.value("A", position).should_not be_too_long }
        specify { eluse.value("ABCD", position).should_not be_too_long }
        specify { eluse.value("ABCDEFGHIJ", position).should_not be_too_long }
        specify { eluse.value("ABCDEFGHIJK", position).should be_too_long }
      end

      describe "#to_d" do
        specify { eluse.value("1.3", position).to_d.should == "1.3".to_d }
      end

      describe "#to_f" do
        specify { eluse.value("1.3", position).to_f.should == "1.3".to_f }
      end

      describe "#to_s" do
        specify { eluse.value("abc", position).to_s.should be_a(String) }
        specify { eluse.value("abc", position).to_s.should == "abc" }
        specify { eluse.value(" abc ", position).to_s.should == " abc" }
      end

      describe "#to_x12" do
        context "with truncation" do
          specify { eluse.value("a", position).to_x12(true).should == "a   " }
          specify { eluse.value(" a", position).to_x12(true).should == " a  " }
          specify { eluse.value("a"*10, position).to_x12(true).should == "a"*10 }
          specify { eluse.value("a"*11, position).to_x12(true).should == "a"*10 }
        end

        context "without truncation" do
          specify { eluse.value("a", position).to_x12(false).should == "a   " }
          specify { eluse.value(" a", position).to_x12(false).should == " a  " }
          specify { eluse.value("a"*10, position).to_x12(false).should == "a"*10 }
          specify { eluse.value("a"*11, position).to_x12(false).should == "a"*11 }
        end
      end

      describe "#length" do
        specify { eluse.value("abc", position).length.should == 3 }
        specify { eluse.value("abc ", position).length.should == 3 }
        specify { eluse.value(" abc", position).length.should == 4 }
        specify { eluse.value(" abc ", position).length.should == 4 }
      end

      describe "#=~" do
        specify { eluse.value("abc", position).should =~ /b/ }
      end

      describe "#map" do
        specify { eluse.value("abc", position).map(&:upcase).should == "ABC" }
        specify { eluse.value("abc", position).map(&:upcase).should be_string }
      end

      describe "#to_date" do
        context "D8" do
          subject { eluse.value("20110713", position) }
          specify { subject.to_date("D8").should be_a(Date) }
          specify { subject.to_date("D8").year.should == 2011 }
          specify { subject.to_date("D8").month.should == 7 }
          specify { subject.to_date("D8").day.should == 13 }
        end

        context "RD8 start..stop" do
          subject { eluse.value("20080304-20110713", position) }
          specify { subject.to_date("RD8").should be_a(Range) }

          specify { subject.to_date("RD8").first.should be_a(Date) }
          specify { subject.to_date("RD8").first.year.should == 2008 }
          specify { subject.to_date("RD8").first.month.should == 3 }
          specify { subject.to_date("RD8").first.day.should == 4 }

          specify { subject.to_date("RD8").last.should be_a(Date) }
          specify { subject.to_date("RD8").last.year.should == 2011 }
          specify { subject.to_date("RD8").last.month.should == 7 }
          specify { subject.to_date("RD8").last.day.should == 13 }
        end

        context "RD8 stop..start" do
          subject { eluse.value("20110713-20080304", position) }
          specify { subject.to_date("RD8").should be_a(Range) }

          specify { subject.to_date("RD8").last.should be_a(Date) }
          specify { subject.to_date("RD8").last.year.should == 2008 }
          specify { subject.to_date("RD8").last.month.should == 3 }
          specify { subject.to_date("RD8").last.day.should == 4 }

          specify { subject.to_date("RD8").first.should be_a(Date) }
          specify { subject.to_date("RD8").first.year.should == 2011 }
          specify { subject.to_date("RD8").first.month.should == 7 }
          specify { subject.to_date("RD8").first.day.should == 13 }
        end
      end

      describe "#==" do
        specify { eluse.value("ABC", position).should_not == "" }
        specify { eluse.value("ABC", position).should_not == "ABC " }
        specify { eluse.value("ABC", position).should_not == " ABC" }
        specify { eluse.value("ABC", position).should_not == " ABC " }

        specify { eluse.value("ABC", position).should == "ABC" }
        specify { eluse.value("ABC", position).should ==
                  eluse.value("ABC", position) }
        specify { eluse.value("ABC ", position).should == "ABC" }
        specify { eluse.value(" ABC", position).should == " ABC" }
        specify { eluse.value(" ABC ", position).should == " ABC" }
      end
    end

  end
end
