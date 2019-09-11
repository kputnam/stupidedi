describe Stupidedi::Reader::Pointer do
  using Stupidedi::Refinements

  let(:empty) { Stupidedi::Reader::Pointer.build([])        }
  let(:three) { Stupidedi::Reader::Pointer.build(%w(a b c)) }

  describe "#inspect" do
  end

  describe "#reify" do
    let(:shared) { three.drop(1) }

    context "when storage is shared" do
      it "is zero-copy when possible" do
        ignore = shared
        result = three.reify

        expect(result).to eq(%w(a b c))
        expect(result).to be_a(Array)
        expect(result).to equal(three.storage)
        expect(ignore.storage).to equal(three.storage)
      end

      it "returns a copy when asked" do
        ignore = shared
        result = three.reify(true)
        expect(result).to_not equal(three.storage)
        expect(ignore.storage).to equal(three.storage)
      end

      it "returns a copy when needed" do
        expect(shared.reify).to_not equal(shared.storage)
      end
    end

    context "when storage is not shared" do
      it "returns a copy" do
        expect(three.reify).to_not equal(three.storage)
      end
    end
  end

  describe "#empty?" do
    specify { expect(empty).to be_empty }
    specify { expect(three).to_not be_empty }
  end

  describe "#blank?" do
    specify { expect(empty).to be_blank }
    specify { expect(three).to_not be_blank }
  end

  describe "#present?" do
    specify { expect(empty).to_not be_present }
    specify { expect(three).to be_present }
  end

  describe "#==" do
    it "is reflexive" do
      expect(three).to eq(three)
      expect(empty).to eq(empty)
    end

    context "when given a pointer" do
      specify { expect(three.drop(1)).to_not eq(three) }
      specify { expect(three.drop(3)).to     eq(empty) }
      specify { expect(empty).to     eq(three.drop(3)) }
    end

    context "when given another type" do
      specify { expect(three).to      eq(%w(a b c)) }
      specify { expect(three).to_not  eq(%w(x y z)) }
      specify { expect(empty).to      eq([]) }
      specify { expect(empty).to_not  eq(%w(a b c)) }
    end
  end

  describe "+" do
    context "is zero-copy when possible" do
      specify { expect(three.take(1) + three.drop(1)).to eq(three) }
      specify { expect((three.take(1) + three.drop(1)).storage).to equal(three.storage) }
    end

    context "returns new storage otherwise" do
      specify { expect(three + empty).to be_a(Array) }
      specify { expect(three + empty).to eq(three.storage) }
      specify { expect(empty + three).to eq(three.storage) }
      specify { expect(three + three).to be_a(Array) }
      specify { expect(three + three).to eq(%w(a b c a b c)) }
    end
  end

  describe "#head" do
    context "when empty" do
      specify { expect(empty.head).to be_nil }
    end

    context "when non-empty" do
      specify { expect(three.head).to eq("a") }
      specify { expect(three.take(2).head).to eq("a") }
      specify { expect(three.drop(1).head).to eq("b") }
    end
  end

  describe "#last" do
    context "when empty" do
      specify { expect(empty.last).to be_nil }
    end

    context "when non-empty" do
      specify { expect(three.last).to eq("c") }
      specify { expect(three.drop(1).last).to eq("c") }
      specify { expect(three.take(2).last).to eq("b") }
    end
  end

  describe "#defined_at?" do
    specify { expect(empty).to_not be_defined_at(0) }
    specify { expect(three).to     be_defined_at(0) }
    specify { expect(three).to     be_defined_at(1) }
    specify { expect(three).to     be_defined_at(2) }
    specify { expect(three).to_not be_defined_at(3) }
    specify { expect{three.defined_at?(-1)}.to raise_error(ArgumentError) }
  end

  describe "#at" do
    specify { expect(empty.at(0)).to be_nil }
    specify { expect(three.at(0)).to eq("a") }
    specify { expect(three.at(1)).to eq("b") }
    specify { expect(three.at(2)).to eq("c") }
    specify { expect(three.at(3)).to be_nil }
    specify { expect{three.at(-1)}.to raise_error(ArgumentError) }
  end

  describe "#tail" do
    specify { expect(empty.tail).to eq([]) }
    specify { expect(three.tail).to eq(%w(b c)) }
    specify { expect(three.tail).to be_a(Stupidedi::Reader::Pointer) }
  end

  describe "#[]" do
    context "when length given" do
      specify { expect(three[0,2]).to be_a(Stupidedi::Reader::Pointer) }
      specify { expect{three[0,-1]}.to raise_error(ArgumentError) }
      specify { expect(three[0,0]).to eq([]) }
      specify { expect(three[0,1]).to eq(%w(a)) }
      specify { expect(three[0,2]).to eq(%w(a b)) }
      specify { expect(three[0,3]).to eq(%w(a b c)) }
      specify { expect(three[0,4]).to eq(%w(a b c)) }
      specify { expect(three[1,2]).to eq(%w(b c)) }
      specify { expect(three[2,2]).to eq(%w(c)) }
      specify { expect(three[3,2]).to be_nil }
    end

    context "when offset is a range" do
      specify { expect(three[0..2]).to be_a(Stupidedi::Reader::Pointer) }
      specify { expect(three[0...0]).to eq([]) }
      specify { expect(three[0..0]).to eq(%w(a)) }
      specify { expect(three[1..2]).to eq(%w(b c)) }
      specify { expect(three[1..-1]).to eq(%w(b c)) }
      specify { expect(three[1...-1]).to eq(%w(b)) }
      specify { expect(three[-3..-2]).to eq(%w(a b)) }
      specify { expect(three[-4..-1]).to be_nil }
      specify { expect(three[4..-1]).to be_nil }
      specify { expect(three[2..9]).to eq(%w(c)) }
    end

    context "when length is not given" do
      specify { expect(empty[-1]).to be_nil }
      specify { expect(empty[0]).to be_nil }
      specify { expect(empty[1]).to be_nil }

      specify { expect(three[-4]).to be_nil }
      specify { expect(three[-3]).to eq("a") }
      specify { expect(three[-2]).to eq("b") }
      specify { expect(three[-1]).to eq("c") }
      specify { expect(three[0]).to eq("a") }
      specify { expect(three[1]).to eq("b") }
      specify { expect(three[2]).to eq("c") }
      specify { expect(three[3]).to be_nil }
    end
  end

  describe "#drop" do
    specify { expect{empty.drop(-1)}.to raise_error(ArgumentError) }
    specify { expect(empty.drop(0)).to eq(empty) }
    specify { expect(empty.drop(1)).to eq(empty) }
    specify { expect(three.drop(0)).to eq(three) }
    specify { expect(three.drop(1)).to eq(%w(b c)) }
    specify { expect(three.drop(2)).to eq(%w(c)) }
    specify { expect(three.drop(3)).to be_empty }
    specify { expect(three.drop(4)).to be_empty }
  end

  describe "#drop!" do
    it "mutates the receiver" do
      expect(three.drop!(0)).to equal(three)
      expect(three).to eq(%w(a b c))
    end

    it "mutates the receiver" do
      expect(three.drop!(1)).to equal(three)
      expect(three).to eq(%w(b c))
    end

    it "mutates the receiver" do
      expect(three.drop!(2)).to equal(three)
      expect(three).to eq(%w(c))
    end

    it "mutates the receiver" do
      expect(three.drop!(3)).to equal(three)
      expect(three).to eq([])
    end
  end

  describe "take" do
    specify { expect{empty.take(-1)}.to raise_error(ArgumentError) }
    specify { expect(empty.take(0)).to eq([]) }
    specify { expect(empty.take(1)).to eq([]) }
    specify { expect(three.take(0)).to eq([]) }
    specify { expect(three.take(1)).to eq(%w(a)) }
    specify { expect(three.take(2)).to eq(%w(a b)) }
    specify { expect(three.take(3)).to eq(%w(a b c)) }
    specify { expect(three.take(4)).to eq(%w(a b c)) }
  end

  context "#take!" do
    it "mutates the receiver" do
      expect(three.take!(0)).to equal(three)
      expect(three).to eq([])
    end

    it "mutates the receiver" do
      expect(three.take!(1)).to equal(three)
      expect(three).to eq(%w(a))
    end

    it "mutates the receiver" do
      expect(three.take!(2)).to equal(three)
      expect(three).to eq(%w(a b))
    end

    it "mutates the receiver" do
      expect(three.take!(3)).to equal(three)
      expect(three).to eq(%w(a b c))
    end
  end

  describe "#drop_take" do
    it "is equivalent to drop(n).take(m)" do
      for m in 0..4
        for n in 0..4
          expect(empty.drop_take(n, m)).to eq(empty.drop(n).take(m))
          expect(three.drop_take(n, m)).to eq(three.drop(n).take(m))
        end
      end
    end
  end

  describe "#split_at" do
    it "returns a prefix and suffix" do
      for n in 0..3
        prefix, suffix = three.split_at(n)
        expect(prefix + suffix).to eq(three)
        expect(prefix.length).to eq(n)
        expect(suffix.length).to eq(3-n)
      end
    end
  end

  describe ".build" do
    context "when given a String" do
      specify { expect(Stupidedi::Reader::Pointer.build("abc")).to be_a(Stupidedi::Reader::StringPtr) }
    end

    context "when given a Pointer" do
      specify { expect(Stupidedi::Reader::Pointer.build(empty)).to equal(empty) }
      specify { expect(Stupidedi::Reader::Pointer.build(three)).to equal(three) }
    end

    context "when given something else" do
      specify { expect{Stupidedi::Reader::Pointer.build(OpenStruct.new())}.to raise_error(TypeError) }
      specify { expect{Stupidedi::Reader::Pointer.build(OpenStruct.new(:[] => 0))}.to raise_error(TypeError) }
      specify { expect{Stupidedi::Reader::Pointer.build(OpenStruct.new(:[] => 0, :length => 0))}.to_not raise_error }
      specify { %w(a b c).then{|x| expect(Stupidedi::Reader::Pointer.build(x).storage).to equal(x) }}
    end
  end
end
