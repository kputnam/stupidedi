describe Stupidedi::Reader::DelegatedInput do
  include QuickCheck::Macro
  using Stupidedi::Refinements

  def mkinput(*args)
    Stupidedi::Reader::Input.build(*args)
  end

  describe "#offset" do
    it "returns the value given to the constructor" do
      expect(mkinput("", 10, 20, 30).offset).to be == 10
    end
  end

  describe "#line" do
    it "returns the value given to the constructor" do
      expect(mkinput("", 10, 20, 30).line).to be == 20
    end
  end

  describe "#column" do
    it "returns the value given to the constructor" do
      expect(mkinput("", 10, 20, 30).column).to be == 30
    end
  end

  describe "#position" do
    it "returns a Position value" do
      expect(mkinput("").position).to be_a(Stupidedi::Reader::Position)
    end

    it "returns a Position value at the current offset" do
      expect(mkinput("", 3).position.offset).to be == 3
    end

    it "returns a Position value at the current line" do
      expect(mkinput("", 0, 3).position.line).to be == 3
    end

    it "returns a Position value at the current column" do
      expect(mkinput("", 0, 0, 3).position.column).to be == 3
    end
  end

  describe "#defined_at?(n)" do
    context "when n is less than input length" do
      property "is true" do
        with(:size, between(1, 25)) { [string, between(0, size - 1)] }
      end.check do |s, n|
        expect(mkinput(s).defined_at?(n)).to be true
      end
    end

    context "when n is equal to input length" do
      property "is false" do
        with(:size, between(0, 25)) { [string, size] }
      end.check do |s, n|
        expect(mkinput(s).defined_at?(n)).to be false
      end
    end

    context "when n is greater than input length" do
      property "is false" do
        with(:size, between(0, 25)) { [string, size + integer.abs] }
      end.check do |s, n|
        expect(mkinput(s).defined_at?(n)).to be false
      end
    end
  end

  describe "#empty?" do
    context "when the input is empty" do
      it "is true" do
        expect(mkinput("")).to be_empty
        expect(mkinput([])).to be_empty
      end
    end

    context "when the input is not empty" do
      it "is false" do
        expect(mkinput(" ")).not_to be_empty
        expect(mkinput([1])).not_to be_empty
      end
    end
  end

  describe "#drop(n)" do
    context "when n is zero" do
      it "returns itself" do
        expect(mkinput("abc").drop(0)).to be == "abc"
      end
    end

    context "when n is negative" do
      it "raises an error" do
        expect(lambda { mkinput("abc").drop(-1) }).to raise_error
      end
    end

    context "when less than n elements are available" do
      it "increments the offset" do
        expect(mkinput("abc", 10).drop(25).offset).to be == 13
      end

      property "increments the offset" do
        with(:size, between(0, 25)) do
          [string, between(size + 1, 1000), between(10, 1000)]
        end
      end.check do |s, n, offset|
        expect(mkinput(s, offset).drop(n).offset).to be == offset + s.length
      end

      it "returns an empty input" do
        expect(mkinput("abc", 10).drop(10)).to be_empty
      end
    end

    context "when n elements are available" do
      it "increments the offset" do
        expect(mkinput("abc", 10).drop(2).offset).to be == 12
      end

      property "increments the offset" do
        with(:size, between(0, 25)) do
          [string, between(0, size), between(10, 1000)]
        end
      end.check do |s, n, offset|
        expect(mkinput(s, offset).drop(n).offset).to be == offset + n
      end

      it "returns an input with the first n elements removed" do
        expect(mkinput(%w(a b c d)).drop(3)).to be == %w(d)
      end

      property "returns an input with the first n elements removed" do
        with(:size, between(0, 25)) do
          [string, between(0, size)]
        end
      end.check do |s, n|
        expect(mkinput(s).drop(n)).to be == s.drop(n)
      end
    end

    property "increments the line count" do
      string = array { with(:size, between(0, 15)) { string }}.join("\n")
      n      = between(0, string.length * 2)
      offset = integer
      line   = integer

      [string, n, offset, line]
    end.check do |s, n, o, l|
      expect(mkinput(s, o, l).drop(n).line).to be == l + s.take(n).count("\n")
    end

    it "calculates the column" do
      input = mkinput("abc\nxyz")
      expect(input.drop(0).column).to be == 1
      expect(input.drop(1).column).to be == 2
      expect(input.drop(2).column).to be == 3
      expect(input.drop(3).column).to be == 4
      expect(input.drop(4).column).to be == 1
      expect(input.drop(5).column).to be == 2
      expect(input.drop(6).column).to be == 3
    end

    property "calculates the column" do
      string = array { with(:size, between(0, 50)) { string }}.join("\n")
      n      = between(0, string.length * 2)
      offset = integer
      line   = integer
      column = integer

      [string, n, offset, line, column]
    end.check do |s, n, o, l, c|
      prefix = s.take(n)

      if prefix.include?("\n")
        expect(mkinput(s, o, l, c).drop(n).column).to be == prefix.length - prefix.rindex("\n")
      else
        expect(mkinput(s, o, l, c).drop(n).column).to be == c + prefix.length
      end
    end
  end

  describe "#take(n)" do
    context "when n is zero" do
      it "returns an empty value" do
        expect(mkinput("abc").take(0)).to be == ""
      end

      it "returns an empty value" do
        expect(mkinput(%w(a b c)).take(0)).to be == []
      end
    end

    context "when n is negative" do
      it "raises an error" do
        expect(lambda { mkinput("abc").take(-1) }).to raise_error
      end
    end

    context "when less than n elements are available" do
      it "returns all available elements" do
        expect(mkinput("ab").take(3)).to be == "ab"
      end

      it "returns all available elements" do
        expect(mkinput(%w(a b)).take(3)).to be == %w(a b)
      end

      it "does not update the offset" do
        expect(mkinput("abc", 500).tap{|x| x.take(4) }.offset).to be == 500
      end
    end

    context "when n elements are available" do
      it "returns the first n elements" do
        expect(mkinput("abc").take(2)).to be == "ab"
      end

      it "returns the first n elements" do
        expect(mkinput(%w(a b c)).take(2)).to be == %w(a b)
      end

      it "does not update the offset" do
        expect(mkinput("abc", 500).tap{|x| x.take(2) }.offset).to be == 500
      end
    end
  end

  describe "#at(n)" do
    context "when n is negative" do
      it "raises an error" do
        expect(lambda { mkinput("abc").at(-1) }).to raise_error
      end
    end

    context "when the input is defined_at?(n)" do
      it "returns the element at index n" do
        expect(mkinput("abc").at(2)).to be == "c"
      end

      it "returns the element at index n" do
        expect(mkinput(%w(a b c)).at(2)).to be == "c"
      end

      it "does not update the offset" do
        expect(mkinput("abc", 500).tap{|x| x.at(5) }.offset).to be == 500
      end
    end

    context "when the input is not defined_at?(n)" do
      it "returns nil" do
        expect(mkinput("abc").at(3)).to be_nil
      end

      it "returns nil" do
        expect(mkinput(%w(a b c)).at(3)).to be_nil
      end

      it "does not update the offset" do
        expect(mkinput("abc", 500).tap{|x| x.at(1) }.offset).to be == 500
      end
    end
  end

  describe "#index(search)" do
    context "when search is an element in the input" do
      it "returns the smallest index" do
        expect(mkinput("abcabc").index("b")).to be == 1
        expect(mkinput(%w(a b c a b c)).index("b")).to be == 1
      end
    end

    context "when search is not an element in the input" do
      it "returns nil" do
        expect(mkinput("abc").index("d")).to be_nil
        expect(mkinput(%w(a b c)).index("d")).to be_nil
      end
    end
  end
end
