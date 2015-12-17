require "spec_helper"
using Stupidedi::Refinements

describe Stupidedi::Reader::TokenReader do
  include QuickCheck::SerializedEdi::Macro

  let(:ty) { Stupidedi::Versions::FunctionalGroups::FiftyTen::ElementTypes }
  let(:r)  { ty::R .new("R" , "Float",          1, 1) }
  let(:n0) { ty::N0.new("N0", "Whole Number",   1, 1) }
  let(:n1) { ty::N1.new("N1", "Tenths Place",   1, 1) }
  let(:n2) { ty::N2.new("N2", "Money",          1, 1) }
  let(:n3) { ty::N3.new("N3", "N.nnn",          1, 1) }
  let(:n4) { ty::N4.new("N4", "N.nnnn",         1, 1) }
  let(:n5) { ty::N5.new("N5", "N.nnnnn",        1, 1) }
  let(:n6) { ty::N6.new("N6", "N.nnnnnn",       1, 1) }
  let(:n7) { ty::N7.new("N7", "N.nnnnnnn",      1, 1) }
  let(:n8) { ty::N8.new("N8", "N.nnnnnnnnn",    1, 1) }
  let(:n9) { ty::N9.new("N9", "N.nnnnnnnnnn",   1, 1) }
  let(:id) { ty::ID.new("ID", "Qualifier",      1, 1) }
  let(:an) { ty::AN.new("AN", "Free Text",      1, 1) }
  let(:dt) { ty::DT.new("DT", "Date",           8, 8) }
  let(:tm) { ty::TM.new("TM", "Time",           4, 6) }

  let(:rq) { Stupidedi::Versions::FunctionalGroups::FiftyTen::ElementReqs }
  let(:s)  { Stupidedi::Schema }

  let(:separators) do
    Stupidedi::Reader::Separators.new(":", "^", "*", "~")
  end

  let(:dictionary) do
    Stupidedi::Reader::SegmentDict.empty
  end

  def mkseparators(component = ":", repetition = "^", element = "*", segment = "~")
    Stupidedi::Reader::Separators.new(component, repetition, element, segment)
  end

  def mkreader(input, separators = separators(), segment_dict = dictionary())
    Stupidedi::Reader::TokenReader.new(input, separators, segment_dict)
  end

  describe "#stream?" do
    it "returns false" do
      mkreader("").should_not be_stream
    end
  end

  describe "#empty?" do
    context "with no input available" do
      it "is true" do
        mkreader("").should be_empty
      end
    end

    context "with some input available" do
      it "is false" do
        mkreader("abc").should_not be_empty
      end
    end
  end

  describe "#consume_prefix(s)" do
    context "when s is empty" do
      it "returns self" do
        reader = mkreader("abc")
        result = reader.consume_prefix("")
        result.should be_defined
        result.map{|x| x.should == reader }
      end
    end

    context "when s is the entire input" do
      property("returns empty reader") do
        string(:alnum)
      end.check do |s|
        reader = mkreader(s)
        result = reader.consume_prefix(s)
        result.should be_defined
        result.map{|x| x.should be_empty }
      end
    end

    context "when s is a prefix of the input" do
      property("returns the remaining input") do
        string(:alnum).bind{|s| s.split_at(between(0, s.length)) }
      end.check do |p, s|
        reader = mkreader("#{p}#{s}")
        result = reader.consume_prefix(p)
        result.should be_defined
        result.map{|x| x.input.should == s }
      end
    end

    context "when s is not a prefix of the input" do
      property("returns a failure") do
        a = with(:size, between(0, 5)) { string(:alnum) }
        b = with(:size, between(0, 9)) { string(:alnum) }
        guard(a.take(b.length) != b)
        [a, b]
      end.check do |a, b|
        reader = mkreader(a)
        result = reader.consume_prefix(b)
        result.should_not be_defined
        result.remainder.should == a
      end
    end
  end

  describe "#consume(s)" do
    context "when s is empty" do
      it "returns self" do
        reader = mkreader("abc")
        result = reader.consume("")
        result.should be_defined
        result.map{|x| x.should == reader }
      end
    end

    context "when s is the entire input" do
      property("returns empty reader") do
        string(:alnum)
      end.check do |s|
        reader = mkreader(s)
        result = reader.consume(s)
        result.should be_defined
        result.map{|x| x.should be_empty }
      end
    end

    context "when s is a prefix of the input" do
      property("returns the remaining input") do
        string(:alnum).bind{|s| s.split_at(between(0, s.length)) }
      end.check do |p, s|
        reader = mkreader("#{p}#{s}")
        result = reader.consume(p)
        result.should be_defined
        result.map{|x| x.input.should == s }
      end
    end

    context "when s is a suffix of the input" do
      property("returns empty reader") do
        p, s = string(:alnum).bind{|t| t.split_at(between(0, t.length)) }
        guard("#{p}#{s}".index(s) >= p.length)
        [p, s]
      end.check do |p, s|
        reader = mkreader("#{p}#{s}")
        result = reader.consume(s)
        result.should be_defined
        result.map{|x| x.should be_empty }
      end
    end

    context "when s does not occur in the input" do
      property("returns a failure") do
        a = with(:size, between(0, 5)) { string(:alnum) }
        b = with(:size, between(0, 9)) { string(:alnum) }
        guard(a.index(b).nil?)

        [a, b]
      end.check do |a, b|
        reader = mkreader(a)
        result = reader.consume(b)
        result.should_not be_defined
        result.remainder.should == a
      end
    end

    context "when s occurs in the middle of the input" do
      property("returns the remaining input") do
        a = string(:alnum)
        b = string(:alnum)
        c = string(:alnum)
        guard(a != b)
        [a, b, c]
      end.check do |a, b, c|
        reader = mkreader("#{a}#{b}#{c}")
        result = reader.consume(b)
        result.should be_defined
        result.map{|x| x.input.should == c }
      end
    end
  end

  describe "#read_character" do
    context "when the input is empty" do
      it "returns a failure" do
        reader = mkreader("")
        result = reader.read_character
        result.should_not be_defined
        result.remainder.should == ""
        result.reason.should =~ /less than one character available/
      end
    end

    context "when the input is not empty" do
      it "returns the remaining input" do
        reader = mkreader("abc")
        result = reader.read_character
        result.should be_defined
        result.map{|x, remainder| remainder.input.should == "bc" }
      end

      it "returns one character" do
        reader = mkreader("abc")
        result = reader.read_character
        result.should be_defined
        result.map{|x, remainder| x.should == "a" }
      end
    end
  end

  describe "#read_segment" do
    context "when the input is empty" do
      it "returns a failure" do
        reader = mkreader("")
        result = reader.read_segment
        result.should_not be_defined
        result.should_not be_fatal
        result.remainder.should == ""
        result.reason.should =~ /reached end of input/
      end
    end

    context "when the input does not start with a valid segment identifier" do
      it "returns a failure" do
        # Segment ID cannot start with element separator "*"
        reader = mkreader("*ABC")
        result = reader.read_segment
        result.should be_fatal
        result.should_not be_defined
        result.remainder.should == "*ABC"
        result.reason.should =~ /found "\*" instead of segment identifier/
      end

      it "returns a failure" do
        # Segment ID cannot start with segment terminator "~"
        reader = mkreader("~ABC")
        result = reader.read_segment
        result.should be_fatal
        result.should_not be_defined
        result.remainder.should == "~ABC"
        result.reason.should =~ /found "~" instead of segment identifier/
      end

      it "returns a failure" do
        # Segment ID cannot start with a number
        reader = mkreader("0ABC")
        result = reader.read_segment
        result.should be_fatal
        result.should_not be_defined
        result.remainder.should == "0ABC"
        result.reason.should =~ /found "0ABC" instead of segment identifier/
      end

      it "returns a failure" do
        # Segment ID cannot be followed by component separator ":"
        reader = mkreader("ABC:")
        result = reader.read_segment
        result.should be_fatal
        result.should_not be_defined
        result.remainder.should == "ABC:"
        result.reason.should =~ /found ":" following segment identifier/
      end

      it "returns a failure" do
        # Segment ID cannot be followed by repetition separator "^"
        reader = mkreader("ABC^")
        result = reader.read_segment
        result.should be_fatal
        result.should_not be_defined
        result.remainder.should == "ABC^"
        result.reason.should =~ /found "\^" following segment identifier/
      end

      it "returns a failure" do
        # Segment ID must be followed by element delimiter "~" or segment terminator "*"
        reader = mkreader("ABCD")
        result = reader.read_segment
        result.should be_fatal
        result.should_not be_defined
        result.remainder.should == "ABCD"
        result.reason.should =~ /found "D" following segment identifier/
      end
    end

    context "when the input does not have a segment terminator" do
      it "returns a failure" do
        reader = mkreader("XYZ*A*B")
        result = reader.read_segment
        result.should be_fatal
        result.should_not be_defined
        result.remainder.should == "B"
        result.reason.should =~ /reached end of input/
      end
    end

    context "when the input starts with an ise segment" do
      it "the remainder is a StreamReader" do
        reader = mkreader("IEA~...")
        result = reader.read_segment
        result.should be_defined
        result.map do |value, remainder|
          value.id.should == :IEA
          expect(value.element_toks.size).to eq(0)
          remainder.input.should == "..."
          remainder.should be_stream
        end
      end

      it "the remainder is a StreamReader" do
        reader = mkreader("IEA*A*B~...")
        result = reader.read_segment
        result.should be_defined
        result.map do |value, remainder|
          value.id.should == :IEA
          expect(value.element_toks.size).to eq(2)
          remainder.input.should == "..."
          remainder.should be_stream
        end
      end
    end

    context "when the input contains no elements" do
      it "returns the empty segment token" do
        reader = mkreader("ABC~...")
        result = reader.read_segment
        result.should be_defined
        result.map do |value, remainder|
          value.id.should == :ABC
          expect(value.element_toks.size).to eq(0)
          remainder.input.should == "..."
        end
      end

      it "returns the remaining input" do
        reader = mkreader("ABC~...")
        result = reader.read_segment
        result.should be_defined
        result.map{|value, remainder| remainder.input.should == "..." }
      end
    end

    context "when the input contains one element" do
      it "returns the segment token" do
        reader = mkreader("ABC*O~...")
        result = reader.read_segment
        result.should be_defined
        result.map do |value, remainder|
          value.id.should == :ABC
          expect(value.element_toks.size).to eq(1)
          value.element_toks.head.value.should == "O"
        end
      end

      it "returns the segment token" do
        reader = mkreader("ABC*~...")
        result = reader.read_segment
        result.should be_defined
        result.map do |value, remainder|
          value.id.should == :ABC
          expect(value.element_toks.size).to eq(1)
          value.element_toks.head.value.should == ""
        end
      end

      it "returns the remaining input" do
        reader = mkreader("ABC*O~...")
        result = reader.read_segment
        result.should be_defined
        result.map{|value, remainder| remainder.input.should == "..." }
      end
    end

    context "when the input contains many elements" do
      it "returns the segment token" do
        reader = mkreader("ABC*M*N*O~...")
        result = reader.read_segment
        result.should be_defined
        result.map do |value, remainder|
          value.id.should == :ABC
          expect(value.element_toks.size).to eq(3)
          value.element_toks.map(&:value).should == %w(M N O)
        end
      end

      it "returns the segment token" do
        reader = mkreader("ABC***~...")
        result = reader.read_segment
        result.should be_defined
        result.map do |value, remainder|
          value.id.should == :ABC
          expect(value.element_toks.size).to eq(3)
          value.element_toks.map(&:value).should == ["", "", ""]
        end
      end

      it "returns the segment token" do
        reader = mkreader("ABC***O~...")
        result = reader.read_segment
        result.should be_defined
        result.map do |value, remainder|
          value.id.should == :ABC
          expect(value.element_toks.size).to eq(3)
          value.element_toks.map(&:value).should == ["", "", "O"]
        end
      end

      it "returns the remaining input" do
        reader = mkreader("ABC*M*O~...")
        result = reader.read_segment
        result.should be_defined
        result.map do |value, remainder|
          remainder.input.should == "..."
        end
      end
    end

    context "when the input contains too many elements" do
      let(:segment_def) do
        s::SegmentDef.build(:SEG, "Dummy Segment", "",
          id.simple_use(rq::Mandatory, s::RepeatCount.bounded(1)),
          id.simple_use(rq::Mandatory, s::RepeatCount.bounded(1)))
      end

      let(:dictionary) do
        Stupidedi::Reader::SegmentDict.build(:SEG => segment_def)
      end

      it "returns the segment token" do
        reader = mkreader("SEG*W*X*Y*Z~...", separators, dictionary)
        result = reader.read_segment
        result.should be_defined
        result.map do |value, remainder|
          expect(value.element_toks.size).to eq(4)
          value.element_toks.map(&:value).should == %w(W X Y Z)
        end
      end

      it "returns the remaining input" do
        reader = mkreader("SEG*W*X*Y*Z~...", separators, dictionary)
        result = reader.read_segment
        result.should be_defined
        result.map do |value, remainder|
          remainder.input.should == "..."
        end
      end
    end

    context "when the input has a non-repeatable simple element" do
    # let(:segment_def) do
    #   s::SegmentDef.build(:SEG, "Dummy Segment", "",
    #     id.simple_use(rq::Mandatory, s::RepeatCount.bounded(1)),
    #     id.simple_use(rq::Mandatory, s::RepeatCount.bounded(1)))
    # end

    # let(:dictionary) do
    #   Stupidedi::Reader::SegmentDict.build(:SEG => segment_def)
    # end

      context "with a repetition separator" do
        it "reads the separator as data" do
          reader = mkreader("SEG*W^X*Y^Z~...", separators, dictionary)
          result = reader.read_segment
          result.should be_defined
          result.map do |value, remainder|
            expect(value.element_toks.size).to eq(2)
            value.element_toks.head.value.should == "W^X"
            value.element_toks.last.value.should == "Y^Z"
          end
        end

        it "returns the remaining input" do
          reader = mkreader("SEG*W^X*Y^Z~...", separators, dictionary)
          result = reader.read_segment
          result.should be_defined
          result.map do |value, remainder|
            remainder.input.should == "..."
          end
        end
      end

      context "with a component separator" do
        it "reads the separator as data" do
          reader = mkreader("SEG*W:X*Y:Z~...", separators, dictionary)
          result = reader.read_segment
          result.should be_defined
          result.map do |value, remainder|
            expect(value.element_toks.size).to eq(2)
            value.element_toks.head.value.should == "W:X"
            value.element_toks.last.value.should == "Y:Z"
          end
        end

        it "returns the remaining input" do
          reader = mkreader("SEG*W:X*Y:Z~...", separators, dictionary)
          result = reader.read_segment
          result.should be_defined
          result.map do |value, remainder|
            remainder.input.should == "..."
          end
        end
      end
    end

    context "when the input has a non-repeatable composite element" do
      let(:segment_def) do
        s::SegmentDef.build(:SEG, "Dummy Segment", "",
          id.simple_use(rq::Mandatory, s::RepeatCount.bounded(1)),
          s::CompositeElementDef.build(:C000, "Dummy Composite", "",
            id.component_use(rq::Mandatory),
            id.component_use(rq::Mandatory),
            id.component_use(rq::Mandatory)).
            simple_use(rq::Mandatory, s::RepeatCount.bounded(1)),
          s::CompositeElementDef.build(:C000, "Dummy Composite", "",
            id.component_use(rq::Mandatory),
            id.component_use(rq::Mandatory)).
            simple_use(rq::Mandatory, s::RepeatCount.bounded(1)))
      end

      let(:dictionary) do
        Stupidedi::Reader::SegmentDict.build(:SEG => segment_def)
      end

      context "and one component" do
        it "returns the segment token" do
          reader = mkreader("SEG*W*X*Y~...", separators, dictionary)
          result = reader.read_segment
          result.should be_defined
          result.map do |value, remainder|
            expect(value.element_toks.size).to eq(3)
            value.element_toks.head.value.should == "W"

            expect(value.element_toks.at(1).component_toks.size).to eq(1)
            value.element_toks.at(1).component_toks.head.value.should == "X"

            expect(value.element_toks.at(2).component_toks.size).to eq(1)
            value.element_toks.at(2).component_toks.head.value.should == "Y"
          end
        end

        it "returns the remaining input" do
          reader = mkreader("SEG*W*X*Y~...", separators, dictionary)
          result = reader.read_segment
          result.should be_defined
          result.map do |value, remainder|
            remainder.input.should == "..."
          end
        end
      end

      context "and many components" do
        it "returns the segment token" do
          reader = mkreader("SEG*W*X:Y*M:N~...", separators, dictionary)
          result = reader.read_segment
          result.should be_defined
          result.map do |value, remainder|
            expect(value.element_toks.size).to eq(3)
            value.element_toks.head.value.should == "W"

            expect(value.element_toks.at(1).component_toks.size).to eq(2)
            value.element_toks.at(1).component_toks.head.value.should == "X"
            value.element_toks.at(1).component_toks.last.value.should == "Y"

            expect(value.element_toks.at(2).component_toks.size).to eq(2)
            value.element_toks.at(2).component_toks.head.value.should == "M"
            value.element_toks.at(2).component_toks.last.value.should == "N"
          end
        end

        it "returns the remaining input" do
          reader = mkreader("SEG*W*X:Y*M:N~...", separators, dictionary)
          result = reader.read_segment
          result.should be_defined
          result.map do |value, remainder|
            remainder.input.should == "..."
          end
        end
      end

      context "and too many components" do
        it "returns the segment token" do
          reader = mkreader("SEG*W*X::Z*M:N:O:P~...", separators, dictionary)
          result = reader.read_segment
          result.should be_defined
          result.map do |value, remainder|
            expect(value.element_toks.size).to eq(3)
            value.element_toks.head.value.should == "W"
            value.element_toks.at(1).component_toks.map(&:value).should == ["X", "", "Z"]
            value.element_toks.at(2).component_toks.map(&:value).should == %w(M N O P)
          end
        end

        it "returns the remaining input" do
          reader = mkreader("SEG*W*X:Y:Z*M:N:O:P~...", separators, dictionary)
          result = reader.read_segment
          result.should be_defined
          result.map do |value, remainder|
            remainder.input.should == "..."
          end
        end
      end

      context "and a component with a repetition separator" do
        it "returns the segment token" do
          reader = mkreader("SEG*W*X^Y:Z*M:N^O~...", separators, dictionary)
          result = reader.read_segment
          result.should be_defined
          result.map do |value, remainder|
            expect(value.element_toks.size).to eq(3)
            value.element_toks.head.value.should == "W"
            value.element_toks.at(1).component_toks.map(&:value).should == %w(X^Y Z)
            value.element_toks.at(2).component_toks.map(&:value).should == %w(M N^O)
          end
        end
      end
    end

    context "" do
      let(:segment_def) do
        s::SegmentDef.build(:SEG, "Dummy Segment", "",
          id.simple_use(rq::Mandatory, s::RepeatCount.bounded(1)),
          id.simple_use(rq::Mandatory, s::RepeatCount.bounded(2)))
      end

      let(:dictionary) do
        Stupidedi::Reader::SegmentDict.build(:SEG => segment_def)
      end

      context "when the input has no occurances of a repeatable simple element" do
        it "returns the segment token" do
          reader = mkreader("SEG**~...", separators, dictionary)
          result = reader.read_segment
          result.should be_defined
          result.map do |value, remainder|
            expect(value.element_toks.size).to eq(2)
            value.element_toks.head.value.should == ""
          # value.element_toks.last.should have(0).element_toks
          end
        end

        it "returns the remaining input" do
          reader = mkreader("SEG**~...", separators, dictionary)
          result = reader.read_segment
          result.should be_defined
          result.map do |value, remainder|
            remainder.input.should == "..."
          end
        end
      end

      context "when the input has one occurance of a repeatable simple element" do
        it "returns the segment token" do
          reader = mkreader("SEG**X~...", separators, dictionary)
          result = reader.read_segment
          result.should be_defined
          result.map do |value, remainder|
            expect(value.element_toks.size).to eq(2)
            expect(value.element_toks.last.element_toks.size).to eq(1)
            value.element_toks.last.element_toks.head.value.should == "X"
          end
        end
      end

      context "when the input has many occurances of a repeatable simple element" do
        it "returns the segment token" do
          reader = mkreader("SEG**X^Y~...", separators, dictionary)
          result = reader.read_segment
          result.should be_defined
          result.map do |value, remainder|
            expect(value.element_toks.size).to eq(2)
            expect(value.element_toks.last.element_toks.size).to eq(2)
            value.element_toks.last.element_toks.head.value.should == "X"
            value.element_toks.last.element_toks.last.value.should == "Y"
          end
        end
      end

      context "when the input has too many occurances of a repeatable simple element" do
        it "returns the segment token" do
          reader = mkreader("SEG**X^Y^Z~...", separators, dictionary)
          result = reader.read_segment
          result.should be_defined
          result.map do |value, remainder|
            expect(value.element_toks.size).to eq(2)
            expect(value.element_toks.last.element_toks.size).to eq(3)
            value.element_toks.last.element_toks.map(&:value).should == %w(X Y Z)
          end
        end
      end
    end

    context "" do
      let(:segment_def) do
        s::SegmentDef.build(:SEG, "Dummy Segment", "",
          id.simple_use(rq::Mandatory, s::RepeatCount.bounded(1)),
          s::CompositeElementDef.build(:C000, "Dummy Composite", "",
            id.component_use(rq::Mandatory),
            id.component_use(rq::Mandatory),
            id.component_use(rq::Mandatory)).
            simple_use(rq::Mandatory, s::RepeatCount.bounded(2)),
          s::CompositeElementDef.build(:C000, "Dummy Composite", "",
            id.component_use(rq::Mandatory),
            id.component_use(rq::Mandatory)).
            simple_use(rq::Mandatory, s::RepeatCount.bounded(1)))
      end

      let(:dictionary) do
        Stupidedi::Reader::SegmentDict.build(:SEG => segment_def)
      end

      context "when the input has no occurances of a repeatable composite element" do
        it "returns the segment token" do
          reader = mkreader("SEG***~...", separators, dictionary)
          result = reader.read_segment
          result.should be_defined
          result.map do |value, remainder|
            expect(value.element_toks.size).to eq(3)
          # value.element_toks.at(1).should have(0).element_toks
          end
        end
      end

      context "when the input has one occurance of a repeatable composite element" do
        it "returns the segment token" do
          reader = mkreader("SEG**A:B*~...", separators, dictionary)
          result = reader.read_segment
          result.should be_defined
          result.map do |value, remainder|
            expect(value.element_toks.size).to eq(3)
            # value.element_toks.at(1).should have(1).element_tok
            expect(value.element_toks.at(1).element_toks.size).to eq(1)
            expect(value.element_toks.at(1).element_toks.head.component_toks.size).to eq(2)
            value.element_toks.at(1).element_toks.head.component_toks.head.value.should == "A"
            value.element_toks.at(1).element_toks.head.component_toks.last.value.should == "B"
          end
        end
      end

      context "when the input has many occurances of a repeatable composite element" do
        it "returns the segment token" do
          reader = mkreader("SEG**A:B^C:D*~...", separators, dictionary)
          result = reader.read_segment
          result.should be_defined
          result.map do |value, remainder|
            expect(value.element_toks.size).to eq(3)
            expect(value.element_toks.at(1).element_toks.head.component_toks.size).to eq(2)
            value.element_toks.at(1).element_toks.head.component_toks.head.value.should == "A"
            value.element_toks.at(1).element_toks.head.component_toks.last.value.should == "B"
            value.element_toks.at(1).element_toks.last.component_toks.head.value.should == "C"
            value.element_toks.at(1).element_toks.last.component_toks.last.value.should == "D"
          end
        end
      end

      context "when the input has too many occurances of a repeatable composite element" do
        it "returns the segment token" do
          reader = mkreader("SEG**A:B^C^D:E:F*~...", separators, dictionary)
          result = reader.read_segment
          result.should be_defined
          result.map do |value, remainder|
            expect(value.element_toks.size).to eq(3)
            expect(value.element_toks.at(1).element_toks.head.component_toks.size).to eq(2)
            value.element_toks.at(1).element_toks.at(0).component_toks.head.value.should == "A"
            value.element_toks.at(1).element_toks.at(0).component_toks.last.value.should == "B"
            value.element_toks.at(1).element_toks.at(1).component_toks.head.value.should == "C"
            value.element_toks.at(1).element_toks.at(2).component_toks.head.value.should == "D"
            value.element_toks.at(1).element_toks.at(2).component_toks.last.value.should == "F"
          end
        end
      end
    end
  end

end
