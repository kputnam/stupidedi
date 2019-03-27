describe Array do
  using Stupidedi::Refinements

  # Creates an array with length `2*n-1` containing elements
  # 1, 2, 3, ..., n-1, n, n-1, ..., 3, 2, 1
  def mkarray(n)
    (1..n).to_a.bind{|as| as.concat(as.init.reverse) }
  end

  describe "#sum" do
    context "on empty array" do
      it "throws an exception" do
        expect(lambda { [].sum(&:to_s) }).to raise_error(/of empty array/)
      end
    end

    context "on one-element array" do
      context "without a block" do
        it "returns the element" do
          element = Object.new
          expect([element].sum).to eql(element)
        end
      end

      context "with a block" do
        it "is same as element.bind" do
          expect{|b| [-10].sum(&b) }.to yield_with_args(-10)
          expect([-10].sum(&:abs)).to eq(10)
        end
      end
    end

    context "on two-element array" do
      context "without a block" do
        it "adds two items" do
          expect([10, 10].sum).to eq(20)
          expect([10, -10].sum).to eq(0)
          expect(%w(a b).sum).to eq("ab")
        end
      end

      context "with a block" do
        it "adds transformed items" do
          expect([10, 10].sum(&:abs)).to eq(20)
          expect([10, -10].sum(&:abs)).to eq(20)
          expect(%w(a b).sum(&:length)).to eq(2)
        end
      end
    end
  end

  describe "#defined_at?(n)" do
    context "on an empty array" do
      property "is false" do
        integer
      end.check{|n| expect([].defined_at?(n)).not_to be }
    end
  end

  describe "#head" do
    context "of an empty array" do
      it "throws an exception" do
        expect(lambda { [].head }).to raise_error("head of empty array")
      end
    end

    context "of a one-element array" do
      it "is the first element" do
        expect([1].head).to eq( 1)
      end

      property "is the first element" do
        integer
      end.check{|x| expect([x].head).to eq( x )}
    end

    context "of a two-element array" do
      it "is the first element" do
        expect([1, 2].head).to eq( 1)
      end

      property "is the first element" do
        [integer, integer]
      end.check{|x,y| expect([x,y].head).to eq( x ) }
    end
  end

  describe "#tail(n)" do
    context "of an empty array" do
      it "is an empty array" do
        expect([].tail).to eq([])
      end
    end

    context "of a one-element array" do
      it "is an empty array" do
        expect([1].tail).to eq([])
      end

      property "is an empty array" do
        integer
      end.check{|x| expect([x].tail).to eq([]) }
    end

    context "of a two-element array" do
      it "contains only the second element" do
        expect([1, 2].tail).to eq([2])
      end

      property "contains only the second element" do
        [integer, integer]
      end.check{|x,y| expect([x,y].tail).to eq([y]) }
    end
  end

  describe "#init(n)" do
    context "of an empty array" do
      it "is an empty array" do
        expect([].init).to eq([])
      end
    end

    context "of a one-element array" do
      it "is an empty array" do
        expect([1].init).to eq([])
      end

      property "is an empty array" do
        integer
      end.check{|x| expect([x].init).to eq([]) }
    end

    context "of a two-element array" do
      it "contains only the first element" do
        expect([1, 2].init).to eq([1])
      end

      property "contains only the first element" do
        [integer, integer]
      end.check{|x,y| expect([x,y].init).to eq([x]) }
    end
  end

  describe "#drop(n)" do
    context "of an empty array" do
      it "is an empty array" do
        expect([].drop(10)).to eq([])
      end

      property "is an empty array" do
        integer.abs
      end.check{|n| expect([].drop(n)).to eq([]) }
    end

    context "a negative number of elements" do
      property "throws an exception" do
        integer.abs
      end.check do |n|
        expect(lambda { %w(a b).drop(-n) }).to raise_error("n cannot be negative")
      end
    end

    context "zero elements" do
      it "returns the original array" do
        expect(%w(a b).drop(0)).to eq(%w(a b))
      end

      property "returns the original array" do
        with(:size, between(0, 25)) { array { integer }}
      end.check do |as|
        expect(as.drop(0)).to eq(as)
      end
    end

    context "one element" do
      context "from a one-element array" do
        it "is an empty array" do
          expect(%w(a).drop(1)).to eq([])
        end

        property "is an empty array" do
          integer
        end.check{|x| expect([x].drop(1)).to eq([]) }
      end

      context "from a two-element array" do
        it "contains only the second element" do
          expect(%w(a b).drop(1)).to eq(%w(b))
        end

        property "contains only the second element" do
          [integer, integer]
        end.check{|x,y| expect([x,y].drop(1)).to eq([y]) }
      end
    end

    context "two elements" do
      context "from a one-element array" do
        it "is an empty array" do
          expect(%w(a).drop(2)).to eq([])
        end

        property "is an empty array" do
          integer
        end.check{|x| expect([x].drop(2)).to eq([]) }
      end

      context "from a two-element array" do
        it "is an empty array" do
          expect(%w(a b).drop(2)).to eq([])
        end

        property "is an empty array" do
          [integer, integer]
        end.check{|x,y| expect([x,y].drop(2)).to eq([]) }
      end
    end
  end

  describe "#drop_while" do
    context "when predicate is always satisfied" do
      it "is an empty array" do
        expect([1, 2, 3, 2, 1].drop_while{|x| x >= 1 }).to eq([])
      end

      property "is an empty array" do
        mkarray(between(0, 10))
      end.check do |as|
        expect(as.drop_while { true }).to eq( [])
      end
    end

    context "when the first element does not satisfy the predicate" do
      it "is the original array" do
        expect([1, 2, 3, 2, 1].drop_while{|x| x <= 0 }).to eq([1, 2, 3, 2, 1])
      end

      property "is the original array" do
        mkarray(between(0, 10))
      end.check do |as|
        expect(as.drop_while { false }).to eq(as)
      end
    end

    context "when the second element does not satisfy the predicate" do
      it "contains all except the first element" do
        expect([1, 2, 3, 2, 1].drop_while{|x| x <= 1 }).to eq([2, 3, 2, 1])
      end

      property "contains all except the first element" do
        mkarray(between(2, 10))
      end.check do |as|
        expect(as.drop_while{|x| x <= 1 }).to eq( as.tail)
      end
    end

    context "when the third element does not satisfy the predicate" do
      it "contains all except the first two elements" do
        expect([1, 2, 3, 2, 1].drop_while{|x| x <= 2 }).to eq([3, 2, 1])
      end

      property "contains all except the first two elements" do
        mkarray(between(3, 10))
      end.check do |as|
        expect(as.drop_while {|x| x <= 2 }).to eq(as.tail.tail)
      end
    end
  end

  describe "#drop_until" do
    context "when predicate is always satisfied" do
      property "is the original array" do
        mkarray(between(0, 10))
      end.check do |as|
        expect(as.drop_until { true }).to eq(as)
      end
    end

    context "when predicate is never satisfied" do
      property "is an empty array" do
        mkarray(between(0, 10))
      end.check do |as|
        expect(as.drop_until { false }).to eq([])
      end
    end
  end

  describe "#take(n)" do
    context "from an empty array" do
      it "is an empty array" do
        expect([].take(10)).to eq([])
      end

      property "is an empty array" do
        integer.abs
      end.check{|n| expect([].take(n)).to eq([]) }
    end

    context "a negative number of elements" do
      property "throws an exception" do
        integer.abs
      end.check do |n|
        expect(lambda { %w(a b).take(-n) }).to raise_error("n cannot be negative")
      end
    end

    context "zero elements" do
      context "from a one-element array" do
        it "is an empty array" do
          expect(%w(a).take(0)).to eq([])
        end

        property "is an empty array" do
          integer
        end.check{|x| expect([x].take(0)).to eq([]) }
      end

      context "from a two-element array" do
        it "is an empty array" do
          expect(%w(a b).take(0)).to eq( [])
        end

        property "is an empty array" do
          [integer, integer]
        end.check{|x,y| expect([x,y].take(0)).to eq([]) }
      end
    end

    context "one element" do
      context "from a one-element array" do
        it "contains only the first element" do
          expect(%w(a).take(1)).to eq( %w(a))
        end

        property "contains only the first element" do
          integer
        end.check{|x| expect([x].take(1)).to eq([x]) }
      end

      context "from a two-element array" do
        it "contains only the first element" do
          expect(%w(a b).take(1)).to eq( %w(a))
        end

        property "contains only the first element" do
          [integer, integer]
        end.check{|x,y| expect([x,y].take(1)).to eq([x]) }
      end
    end

    context "two elements" do
      context "from a one-element array" do
        it "contains only the first element" do
          expect(%w(a).take(2)).to eq( %w(a))
        end

        property "contains only the first element" do
          integer
        end.check{|x| expect([x].take(2)).to eq([x]) }
      end

      context "from a two-element array" do
        it "contains only both the elements" do
          expect(%w(a b).take(2)).to eq( %w(a b))
        end

        property "contains only both the elements" do
          [integer, integer]
        end.check{|x,y| expect([x,y].take(2)).to eq([x,y]) }
      end
    end
  end

  describe "#take_while" do
    context "when predicate is always satisfied" do
      it "is the original array" do
        expect([1, 2, 3, 2, 1].take_while{|x| x >= 1 }).to eq([1, 2, 3, 2, 1])
      end

      property "is the original array" do
        mkarray(between(0, 10))
      end.check do |as|
        expect(as.take_while { true }).to eq( as)
      end
    end

    context "when the first element does not satisfy the predicate" do
      it "is the empty array" do
        expect([1, 2, 3, 2, 1].take_while{|x| x <= 0 }).to eq([])
      end

      property "is the empty array" do
        mkarray(between(1, 10))
      end.check do |as|
        expect(as.take_while { false }).to eq( [])
      end
    end

    context "when the second element does not satisfy the predicate" do
      it "contains only the first element" do
        expect([1, 2, 3, 2, 1].take_while{|x| x <= 1 }).to eq([1])
      end

      property "contains only the first element" do
        mkarray(between(2, 10))
      end.check do |as|
        expect(as.take_while{|x| x <= 1 }).to eq(as[0, 1])
      end
    end

    context "when the third element does not satisfy the predicate" do
      it "contains only the first two elements" do
        expect([1, 2, 3, 2, 1].take_while{|x| x <= 2 }).to eq([1, 2])
      end

      property "contains only the first two elements" do
        mkarray(between(3, 10))
      end.check do |as|
        expect(as.take_while {|x| x <= 2 }).to eq(as[0, 2])
      end
    end
  end

  describe "#take_until" do
    skip
  end

  describe "#split_at" do
    context "index zero" do
      context "on an empty array" do
        it "returns [], []" do
          expect([].split_at(0)).to eq([[], []])
        end
      end

      context "on a one-element array" do
        it "returns [], [a]" do
          expect(%w(a).split_at(0)).to eq([[], %w(a)])
        end
      end

      context "on a two-element array" do
        it "returns [], [a, b]" do
          expect(%w(a b).split_at(0)).to eq([[], %w(a b)])
        end
      end
    end

    context "index one" do
      context "at a negative index" do
        property "throws an exception" do
          integer.abs
        end.check do |n|
          expect(lambda { [].split_at(-n) }).to raise_error("n cannot be negative")
        end
      end

      context "on an empty array" do
        it "returns [], []" do
          expect([].split_at(1)).to eq([[], []])
        end
      end

      context "on a one-element array" do
        it "returns [a], []" do
          expect(%w(a).split_at(1)).to eq([%w(a), []])
        end
      end

      context "on a two-element array" do
        it "returns [a], [b]" do
          expect(%w(a b).split_at(1)).to eq( [%w(a), %w(b)] )
        end
      end
    end

    context "index two" do
      context "on an empty array" do
        it "returns [], []" do
          expect([].split_at(2)).to eq( [[], []] )
        end
      end

      context "on a one-element array" do
        it "returns [a], []" do
          expect(%w(a).split_at(2)).to eq( [%w(a), []] )
        end
      end

      context "on a two-element array" do
        it "returns [a, b], []" do
          expect(%w(a b).split_at(2)).to eq( [%w(a b), []] )
        end
      end
    end

    context "at a a non-negative index" do
      property "is equal to [take(n), drop(n)]" do
        with(:size, between(0, 25)) do
          [array { integer }, integer.abs]
        end
      end.check do |as, n|
        expect(as.split_at(n)).to eq( [as.take(n), as.drop(n)] )
      end
    end
  end

  describe "#split_until" do
    skip
  end

  describe "#split_when" do
    skip
  end
end
