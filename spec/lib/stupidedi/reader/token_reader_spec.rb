describe Stupidedi::Reader::TokenReader do
  using Stupidedi::Refinements

  let(:ty) { Stupidedi::Versions::FiftyTen::ElementTypes }
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

  let(:rq) { Stupidedi::Versions::FiftyTen::ElementReqs }
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
      expect(mkreader("")).not_to be_stream
    end
  end

  describe "#empty?" do
    context "with no input available" do
      it "is true" do
        expect(mkreader("")).to be_empty
      end
    end

    context "with some input available" do
      it "is false" do
        expect(mkreader("abc")).not_to be_empty
      end
    end
  end

  describe "#consume_prefix(s)" do
    context "when s is empty" do
      it "returns self" do
        reader = mkreader("abc")
        result = reader.consume_prefix("")
        expect(result).to be_defined
        result.map{|x| expect(x).to be == reader }
      end
    end

    context "when s is the entire input" do
      property "returns empty reader" do
        string(:alnum)
      end.check do |s|
        reader = mkreader(s)
        result = reader.consume_prefix(s)
        expect(result).to be_defined
        result.map{|x| expect(x).to be_empty }
      end
    end

    context "when s is a prefix of the input" do
      property "returns the remaining input" do
        string(:alnum).bind{|s| s.split_at(between(0, s.length)) }
      end.check do |p, s|
        reader = mkreader("#{p}#{s}")
        result = reader.consume_prefix(p)
        expect(result).to be_defined
        result.map{|x| expect(x.input).to be == s }
      end
    end

    context "when s is not a prefix of the input" do
      property "returns a failure" do
        a = with(:size, between(0, 5)) { string(:alnum) }
        b = with(:size, between(0, 9)) { string(:alnum) }
        guard(a.take(b.length) != b)
        [a, b]
      end.check do |a, b|
        reader = mkreader(a)
        result = reader.consume_prefix(b)
        expect(result).to be_failure
        expect(result.remainder).to be == a
      end
    end
  end

  describe "#consume(s)" do
    context "when s is empty" do
      it "returns self" do
        reader = mkreader("abc")
        result = reader.consume("")
        expect(result).to be_defined
        result.map{|x| expect(x).to be == reader }
      end
    end

    context "when s is the entire input" do
      property "returns empty reader" do
        string(:alnum)
      end.check do |s|
        reader = mkreader(s)
        result = reader.consume(s)
        expect(result).to be_defined
        result.map{|x| expect(x).to be_empty }
      end
    end

    context "when s is a prefix of the input" do
      property "returns the remaining input" do
        string(:alnum).bind{|s| s.split_at(between(0, s.length)) }
      end.check do |p, s|
        reader = mkreader("#{p}#{s}")
        result = reader.consume(p)
        expect(result).to be_defined
        result.map{|x| expect(x.input).to be == s }
      end
    end

    context "when s is a suffix of the input" do
      property "returns empty reader" do
        p, s = string(:alnum).bind{|t| t.split_at(between(0, t.length)) }
        guard("#{p}#{s}".index(s) >= p.length)
        [p, s]
      end.check do |p, s|
        reader = mkreader("#{p}#{s}")
        result = reader.consume(s)
        expect(result).to be_defined
        result.map{|x| expect(x).to be_empty }
      end
    end

    context "when s does not occur in the input" do
      property "returns a failure" do
        a = with(:size, between(0, 5)) { string(:alnum) }
        b = with(:size, between(0, 9)) { string(:alnum) }
        guard(a.index(b).nil?)

        [a, b]
      end.check do |a, b|
        reader = mkreader(a)
        result = reader.consume(b)
        expect(result).to be_failure
        expect(result.remainder).to be == a
      end
    end

    context "when s occurs in the middle of the input" do
      property "returns the remaining input" do
        a = string(:alnum)
        b = string(:alnum)
        c = string(:alnum)
        guard(a != b)
        [a, b, c]
      end.check do |a, b, c|
        reader = mkreader("#{a}#{b}#{c}")
        result = reader.consume(b)
        expect(result).to be_defined
        result.map{|x| expect(x.input).to be == c }
      end
    end
  end

  describe "#read_character" do
    context "when the input is empty" do
      it "returns a failure" do
        reader = mkreader("")
        result = reader.read_character
        expect(result).to be_failure
        expect(result.remainder).to be == ""
        expect(result.reason).to be =~ /less than one character available/
      end
    end

    context "when the input is not empty" do
      it "returns the remaining input" do
        reader = mkreader("abc")
        result = reader.read_character
        expect(result).to be_defined
        result.map{|x, remainder| expect(remainder.input).to be == "bc" }
      end

      it "returns one character" do
        reader = mkreader("abc")
        result = reader.read_character
        expect(result).to be_defined
        result.map{|x, remainder| expect(x).to be == "a" }
      end
    end
  end

  describe "#read_segment" do
    context "when the input is empty" do
      it "returns a failure" do
        reader = mkreader("")
        result = reader.read_segment
        expect(result).to be_failure
        expect(result).not_to be_fatal
        expect(result.remainder).to be == ""
        expect(result.reason).to be =~ /reached end of input/
      end
    end

    context "when the input does not start with a valid segment identifier" do
      it "returns a failure" do
        # Segment ID cannot start with element separator "*"
        reader = mkreader("*ABC")
        result = reader.read_segment
        expect(result).to be_fatal
        expect(result).to be_failure
        expect(result.remainder).to be == "*ABC"
        expect(result.reason).to be =~ /found "\*" instead of segment identifier/
      end

      it "returns a failure" do
        # Segment ID cannot start with segment terminator "~"
        reader = mkreader("~ABC")
        result = reader.read_segment
        expect(result).to be_fatal
        expect(result).to be_failure
        expect(result.remainder).to be == "~ABC"
        expect(result.reason).to be =~ /found "~" instead of segment identifier/
      end

      it "returns a failure" do
        # Segment ID cannot start with a number
        reader = mkreader("0ABC")
        result = reader.read_segment
        expect(result).to be_fatal
        expect(result).to be_failure
        expect(result.remainder).to be == "0ABC"
        expect(result.reason).to be =~ /found "0ABC" instead of segment identifier/
      end

      it "returns a failure" do
        # Segment ID cannot be followed by component separator ":"
        reader = mkreader("ABC:")
        result = reader.read_segment
        expect(result).to be_fatal
        expect(result).to be_failure
        expect(result.remainder).to be == "ABC:"
        expect(result.reason).to be =~ /found ":" following segment identifier/
      end

      it "returns a failure" do
        # Segment ID cannot be followed by repetition separator "^"
        reader = mkreader("ABC^")
        result = reader.read_segment
        expect(result).to be_fatal
        expect(result).to be_failure
        expect(result.remainder).to be == "ABC^"
        expect(result.reason).to be =~ /found "\^" following segment identifier/
      end

      it "returns a failure" do
        # Segment ID must be followed by element delimiter "~" or segment terminator "*"
        reader = mkreader("ABCD")
        result = reader.read_segment
        expect(result).to be_fatal
        expect(result).to be_failure
        expect(result.remainder).to be == "ABCD"
        expect(result.reason).to be =~ /found "D" following segment identifier/
      end
    end

    context "when the input does not have a segment terminator" do
      it "returns a failure" do
        reader = mkreader("XYZ*A*B")
        result = reader.read_segment
        expect(result).to be_fatal
        expect(result).to be_failure
        expect(result.remainder).to be == "B"
        expect(result.reason).to be =~ /reached end of input/
      end
    end

    context "when the input starts with an ise segment" do
      it "the remainder is a StreamReader" do
        reader = mkreader("IEA~...")
        result = reader.read_segment
        expect(result).to be_defined
        result.map do |value, remainder|
          expect(value.id).to be == :IEA
          expect(value.element_toks.size).to be == 0
          expect(remainder.input).to be == "..."
          expect(remainder).to be_stream
        end
      end

      it "the remainder is a StreamReader" do
        reader = mkreader("IEA*A*B~...")
        result = reader.read_segment
        expect(result).to be_defined
        result.map do |value, remainder|
          expect(value.id).to be == :IEA
          expect(value.element_toks.size).to be == 2
          expect(remainder.input).to be == "..."
          expect(remainder).to be_stream
        end
      end
    end

    context "when the input contains no elements" do
      it "returns the empty segment token" do
        reader = mkreader("ABC~...")
        result = reader.read_segment
        expect(result).to be_defined
        result.map do |value, remainder|
          expect(value.id).to be == :ABC
          expect(value.element_toks.size).to be == 0
          expect(remainder.input).to be == "..."
        end
      end

      it "returns the remaining input" do
        reader = mkreader("ABC~...")
        result = reader.read_segment
        expect(result).to be_defined
        result.map{|value, remainder| expect(remainder.input).to be == "..." }
      end
    end

    context "when the input contains one element" do
      it "returns the segment token" do
        reader = mkreader("ABC*O~...")
        result = reader.read_segment
        expect(result).to be_defined
        result.map do |value, remainder|
          expect(value.id).to be == :ABC
          expect(value.element_toks.size).to be == 1
          expect(value.element_toks.head.value).to be == "O"
        end
      end

      it "returns the segment token" do
        reader = mkreader("ABC*~...")
        result = reader.read_segment
        expect(result).to be_defined
        result.map do |value, remainder|
          expect(value.id).to be == :ABC
          expect(value.element_toks.size).to be == 1
          expect(value.element_toks.head.value).to be == ""
        end
      end

      it "returns the remaining input" do
        reader = mkreader("ABC*O~...")
        result = reader.read_segment
        expect(result).to be_defined
        result.map{|value, remainder| expect(remainder.input).to be == "..." }
      end
    end

    context "when the input contains many elements" do
      it "returns the segment token" do
        reader = mkreader("ABC*M*N*O~...")
        result = reader.read_segment
        expect(result).to be_defined
        result.map do |value, remainder|
          expect(value.id).to be == :ABC
          expect(value.element_toks.size).to be == 3
          expect(value.element_toks.map(&:value)).to be == %w(M N O)
        end
      end

      it "returns the segment token" do
        reader = mkreader("ABC***~...")
        result = reader.read_segment
        expect(result).to be_defined
        result.map do |value, remainder|
          expect(value.id).to be == :ABC
          expect(value.element_toks.size).to be == 3
          expect(value.element_toks.map(&:value)).to be == ["", "", ""]
        end
      end

      it "returns the segment token" do
        reader = mkreader("ABC***O~...")
        result = reader.read_segment
        expect(result).to be_defined
        result.map do |value, remainder|
          expect(value.id).to be == :ABC
          expect(value.element_toks.size).to be == 3
          expect(value.element_toks.map(&:value)).to be == ["", "", "O"]
        end
      end

      it "returns the remaining input" do
        reader = mkreader("ABC*M*O~...")
        result = reader.read_segment
        expect(result).to be_defined
        result.map do |value, remainder|
          expect(remainder.input).to be == "..."
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
        expect(result).to be_defined
        result.map do |value, remainder|
          expect(value.element_toks.size).to be == 4
          expect(value.element_toks.map(&:value)).to be == %w(W X Y Z)
        end
      end

      it "returns the remaining input" do
        reader = mkreader("SEG*W*X*Y*Z~...", separators, dictionary)
        result = reader.read_segment
        expect(result).to be_defined
        result.map do |value, remainder|
          expect(remainder.input).to be == "..."
        end
      end
    end

    context "when the input has a non-repeatable simple element" do
      context "with a repetition separator" do
        it "reads the separator as data" do
          reader = mkreader("SEG*W^X*Y^Z~...", separators, dictionary)
          result = reader.read_segment
          expect(result).to be_defined
          result.map do |value, remainder|
            expect(value.element_toks.size).to be == 2
            expect(value.element_toks.head.value).to be == "W^X"
            expect(value.element_toks.last.value).to be == "Y^Z"
          end
        end

        it "returns the remaining input" do
          reader = mkreader("SEG*W^X*Y^Z~...", separators, dictionary)
          result = reader.read_segment
          expect(result).to be_defined
          result.map do |value, remainder|
            expect(remainder.input).to be == "..."
          end
        end
      end

      context "with a component separator" do
        it "reads the separator as data" do
          reader = mkreader("SEG*W:X*Y:Z~...", separators, dictionary)
          result = reader.read_segment
          expect(result).to be_defined
          result.map do |value, remainder|
            expect(value.element_toks.size).to be == 2
            expect(value.element_toks.head.value).to be == "W:X"
            expect(value.element_toks.last.value).to be == "Y:Z"
          end
        end

        it "returns the remaining input" do
          reader = mkreader("SEG*W:X*Y:Z~...", separators, dictionary)
          result = reader.read_segment
          expect(result).to be_defined
          result.map do |value, remainder|
            expect(remainder.input).to be == "..."
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
          expect(result).to be_defined
          result.map do |value, remainder|
            expect(value.element_toks.size).to be == 3
            expect(value.element_toks.head.value).to be == "W"
            expect(value.element_toks.at(1).component_toks.size).to be == 1
            expect(value.element_toks.at(1).component_toks.head.value).to be == "X"
            expect(value.element_toks.at(2).component_toks.size).to be == 1
            expect(value.element_toks.at(2).component_toks.head.value).to be == "Y"
          end
        end

        it "returns the remaining input" do
          reader = mkreader("SEG*W*X*Y~...", separators, dictionary)
          result = reader.read_segment
          expect(result).to be_defined
          result.map do |value, remainder|
            expect(remainder.input).to be == "..."
          end
        end
      end

      context "and many components" do
        it "returns the segment token" do
          reader = mkreader("SEG*W*X:Y*M:N~...", separators, dictionary)
          result = reader.read_segment
          expect(result).to be_defined
          result.map do |value, remainder|
            expect(value.element_toks.size).to be == 3
            expect(value.element_toks.head.value).to be == "W"
            expect(value.element_toks.at(1).component_toks.size).to be == 2
            expect(value.element_toks.at(1).component_toks.head.value).to be == "X"
            expect(value.element_toks.at(1).component_toks.last.value).to be == "Y"
            expect(value.element_toks.at(2).component_toks.size).to be == 2
            expect(value.element_toks.at(2).component_toks.head.value).to be == "M"
            expect(value.element_toks.at(2).component_toks.last.value).to be == "N"
          end
        end

        it "returns the remaining input" do
          reader = mkreader("SEG*W*X:Y*M:N~...", separators, dictionary)
          result = reader.read_segment
          expect(result).to be_defined
          result.map do |value, remainder|
            expect(remainder.input).to be == "..."
          end
        end
      end

      context "and too many components" do
        it "returns the segment token" do
          reader = mkreader("SEG*W*X::Z*M:N:O:P~...", separators, dictionary)
          result = reader.read_segment
          expect(result).to be_defined
          result.map do |value, remainder|
            expect(value.element_toks.size).to be == 3
            expect(value.element_toks.head.value).to be == "W"
            expect(value.element_toks.at(1).component_toks.map(&:value)).to be == ["X", "", "Z"]
            expect(value.element_toks.at(2).component_toks.map(&:value)).to be == %w(M N O P)
          end
        end

        it "returns the remaining input" do
          reader = mkreader("SEG*W*X:Y:Z*M:N:O:P~...", separators, dictionary)
          result = reader.read_segment
          expect(result).to be_defined
          result.map do |value, remainder|
            expect(remainder.input).to be == "..."
          end
        end
      end

      context "and a component with a repetition separator" do
        it "returns the segment token" do
          reader = mkreader("SEG*W*X^Y:Z*M:N^O~...", separators, dictionary)
          result = reader.read_segment
          expect(result).to be_defined
          result.map do |value, remainder|
            expect(value.element_toks.size).to be == 3
            expect(value.element_toks.head.value).to be == "W"
            expect(value.element_toks.at(1).component_toks.map(&:value)).to be == %w(X^Y Z)
            expect(value.element_toks.at(2).component_toks.map(&:value)).to be == %w(M N^O)
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
          expect(result).to be_defined
          result.map do |value, remainder|
            expect(value.element_toks.size).to be == 2
            expect(value.element_toks.head.value).to be == ""
          end
        end

        it "returns the remaining input" do
          reader = mkreader("SEG**~...", separators, dictionary)
          result = reader.read_segment
          expect(result).to be_defined
          result.map do |value, remainder|
            expect(remainder.input).to be == "..."
          end
        end
      end

      context "when the input has one occurance of a repeatable simple element" do
        it "returns the segment token" do
          reader = mkreader("SEG**X~...", separators, dictionary)
          result = reader.read_segment
          expect(result).to be_defined
          result.map do |value, remainder|
            expect(value.element_toks.size).to be == 2
            expect(value.element_toks.last.element_toks.size).to be == 1
            expect(value.element_toks.last.element_toks.head.value).to be == "X"
          end
        end
      end

      context "when the input has many occurances of a repeatable simple element" do
        it "returns the segment token" do
          reader = mkreader("SEG**X^Y~...", separators, dictionary)
          result = reader.read_segment
          expect(result).to be_defined
          result.map do |value, remainder|
            expect(value.element_toks.size).to be == 2
            expect(value.element_toks.last.element_toks.size).to be == 2
            expect(value.element_toks.last.element_toks.head.value).to be == "X"
            expect(value.element_toks.last.element_toks.last.value).to be == "Y"
          end
        end
      end

      context "when the input has too many occurances of a repeatable simple element" do
        it "returns the segment token" do
          reader = mkreader("SEG**X^Y^Z~...", separators, dictionary)
          result = reader.read_segment
          expect(result).to be_defined
          result.map do |value, remainder|
            expect(value.element_toks.size).to be == 2
            expect(value.element_toks.last.element_toks.size).to be == 3
            expect(value.element_toks.last.element_toks.map(&:value)).to be == %w(X Y Z)
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
          expect(result).to be_defined
          result.map do |value, remainder|
            expect(value.element_toks.size).to be == 3
          end
        end
      end

      context "when the input has one occurance of a repeatable composite element" do
        it "returns the segment token" do
          reader = mkreader("SEG**A:B*~...", separators, dictionary)
          result = reader.read_segment
          expect(result).to be_defined
          result.map do |value, remainder|
            expect(value.element_toks.size).to be == 3
            expect(value.element_toks.at(1).element_toks.size).to be == 1
            expect(value.element_toks.at(1).element_toks.head.component_toks.size).to be == 2
            expect(value.element_toks.at(1).element_toks.head.component_toks.head.value).to be == "A"
            expect(value.element_toks.at(1).element_toks.head.component_toks.last.value).to be == "B"
          end
        end
      end

      context "when the input has many occurances of a repeatable composite element" do
        it "returns the segment token" do
          reader = mkreader("SEG**A:B^C:D*~...", separators, dictionary)
          result = reader.read_segment
          expect(result).to be_defined
          result.map do |value, remainder|
            expect(value.element_toks.size).to be == 3
            expect(value.element_toks.at(1).element_toks.head.component_toks.size).to be == 2
            expect(value.element_toks.at(1).element_toks.head.component_toks.head.value).to be == "A"
            expect(value.element_toks.at(1).element_toks.head.component_toks.last.value).to be == "B"
            expect(value.element_toks.at(1).element_toks.last.component_toks.head.value).to be == "C"
            expect(value.element_toks.at(1).element_toks.last.component_toks.last.value).to be == "D"
          end
        end
      end

      context "when the input has too many occurances of a repeatable composite element" do
        it "returns the segment token" do
          reader = mkreader("SEG**A:B^C^D:E:F*~...", separators, dictionary)
          result = reader.read_segment
          expect(result).to be_defined
          result.map do |value, remainder|
            expect(value.element_toks.size).to be == 3
            expect(value.element_toks.at(1).element_toks.head.component_toks.size).to be == 2
            expect(value.element_toks.at(1).element_toks.at(0).component_toks.head.value).to be == "A"
            expect(value.element_toks.at(1).element_toks.at(0).component_toks.last.value).to be == "B"
            expect(value.element_toks.at(1).element_toks.at(1).component_toks.head.value).to be == "C"
            expect(value.element_toks.at(1).element_toks.at(2).component_toks.head.value).to be == "D"
            expect(value.element_toks.at(1).element_toks.at(2).component_toks.last.value).to be == "F"
          end
        end
      end
    end
  end
end
