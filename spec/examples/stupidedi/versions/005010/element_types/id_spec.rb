require "spec_helper"

describe Stupidedi::Versions::FiftyTen::ElementTypes do
  describe "IdentifierVal" do

    let(:x5010) { Stupidedi::Versions::FiftyTen }
    let(:types) { x5010::ElementTypes }
    let(:req)   { x5010::ElementReqs }
    let(:rep)   { Stupidedi::Schema::RepeatCount }

    # Dummy element definition E1: min/max length 4/10
    let(:eldef) { types::ID.new(:E1, "Qualifier Element", 2, 4) }
    let(:eluse) { eldef.simple_use(req::Mandatory, rep.bounded(1)) }

    # Dummy file position
    let(:position) { Stupidedi::Reader::Position.new(100, 4, 19, "test.x12") }

    context "Invalid" do
      let(:el) do
        invalid = "whatever" 
        class << invalid; undef_method :to_s; end
        eluse.value(invalid, position)
      end

      describe "#position" do
        specify { el.position.should == position }
      end

      describe "#valid?" do
        specify { el.should_not be_valid }
      end

      describe "#empty?" do
        specify { el.should_not be_empty }
      end

      describe "#too_short?" do
        specify { el.should_not be_too_short }
      end

      describe "#too_short?" do
        specify { el.should_not be_too_long }
      end

      describe "#map" do
        specify { el.map { "xx" }.should be_id }
        specify { el.map { "xx" }.should == "xx" }

        specify { el.map { nil }.should == "" }
        specify { el.map { nil }.should be_id }
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
        specify { el.map { "xx" }.should be_id }
        specify { el.map { "xx" }.should == "xx" }

        specify { el.map { nil }.should == "" }
        specify { el.map { nil }.should be_id }
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

      describe "#too_short?" do
        specify { eluse.value("A", position).should be_too_short }
        specify { eluse.value("AB", position).should_not be_too_short }
        specify { eluse.value("ABCD", position).should_not be_too_short }
        specify { eluse.value("ABCDEF", position).should_not be_too_short }
      end

      describe "#too_long?" do
        specify { eluse.value("A", position).should_not be_too_long }
        specify { eluse.value("AB", position).should_not be_too_long }
        specify { eluse.value("ABCD", position).should_not be_too_long }
        specify { eluse.value("ABCDEF", position).should be_too_long }
      end

      describe "#to_s" do
        specify { eluse.value("abc", position).to_s.should be_a(String) }
        specify { eluse.value("abc", position).to_s.should == "abc" }
        specify { eluse.value(" abc ", position).to_s.should == " abc" }
      end

      describe "#to_x12" do
        context "with truncation" do
          specify { eluse.value("a", position).to_x12(true).should == "a " }
          specify { eluse.value(" a", position).to_x12(true).should == " a" }
          specify { eluse.value("ab", position).to_x12(true).should == "ab" }
          specify { eluse.value("abcd", position).to_x12(true).should == "abcd" }
          specify { eluse.value("abcdef", position).to_x12(true).should == "abcd" }
        end

        context "without truncation" do
          specify { eluse.value("a", position).to_x12(false).should == "a " }
          specify { eluse.value(" a", position).to_x12(false).should == " a" }
          specify { eluse.value("ab", position).to_x12(false).should == "ab" }
          specify { eluse.value("abcdef", position).to_x12(false).should == "abcdef" }
        end
      end

      describe "#map" do
        specify { eluse.value("abc", position).map(&:upcase).should == "ABC" }
        specify { eluse.value("abc", position).map(&:upcase).should be_id }
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

