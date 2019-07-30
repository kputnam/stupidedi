# frozen_string_literal: true
# encoding: utf-8
describe Stupidedi::Reader::StringPtr do
  let(:lower) { "abcdefghijklmnopqrstuvwxyz abcdefghijklmnOPQRSTUVWXYZ" }
  let(:upper) { "ABCDEFGHIJKLMNOPQRSTUVWXYZ ABCDEFGHIJKLMNopqrstuvwxyz" }

  let(:lower_ptr) { Stupidedi::Reader::Pointer.build(lower.dup) }
  let(:upper_ptr) { Stupidedi::Reader::Pointer.build(upper.dup) }

  describe "#to_s" do
    it "is called implicitly" do
      expect("-#{lower_ptr.take(3)}-").to eq("-abc-")
    end
  end

  describe "#to_str" do
    it "is called implicitly" do
      comma = Stupidedi::Reader::Pointer.build(",")
      expect(%w(a b c).join(comma)).to eq("a,b,c")
    end
  end

  describe "#==" do
    it "is reflexive" do
      expect(lower_ptr).to eq(lower_ptr)
      expect(upper_ptr).to eq(upper_ptr)
    end

    it "compares string pointers to plain strings" do
      expect(lower_ptr).to eq(lower)
      expect(upper_ptr).to eq(upper)
    end

    it "works on identical substrings" do
      expect(lower_ptr.drop(10).take(10)).to eq(lower_ptr.drop(10).take(10))
      expect(upper_ptr.drop(10).take(10)).to eq(upper_ptr.drop(10).take(10))
    end

    it "works on non-identical substrings" do
      expect(lower_ptr.take(10)).to           eq(lower_ptr.drop(27).take(10))
      expect(upper_ptr.drop(15).take(10)).to  eq(lower_ptr.drop(42).take(10))
    end

    it "is case-sensitive" do
      expect(lower_ptr).to_not eq(upper_ptr)
      expect(upper_ptr).to_not eq(lower_ptr)

      expect(lower_ptr).to_not eq(upper)
      expect(upper_ptr).to_not eq(lower)
    end
  end

  describe "=~" do
    it "matches within a substring" do
      expect(lower_ptr =~ /e/).to                 eq(4)
      expect(lower_ptr.drop(3).take(3) =~ /e/).to eq(1)
    end

    it "matches within a substring" do
      expect(lower_ptr.drop(3).take(3) =~ /[a-z]+/).to eq(0)
    end

    it "doesn't match outside of substring" do
      expect(lower_ptr.drop(3) =~ /a/).to   eq(24)
      expect(lower_ptr.drop(27) =~ /z/).to  be_nil
    end

    it "matches when regexp has an anchor" do
      expect(lower_ptr.drop(3)  =~ /^d.f/).to eq(0)
      expect(lower_ptr.drop(3)  =~ /^a/).to   be_nil
      expect(lower_ptr.take(10) =~ /j$/).to   eq(9)
    end

    it "matches when regexp has a character class with $ or ^" do
      expect(lower_ptr =~ /[$a]/).to eq(0)
      expect(lower_ptr =~ /[^a]/).to eq(1)
    end
  end

  describe "#<<" do
    context "when argument is a string" do
      it "is zero-copy when possible" do
        result = lower_ptr.drop(3).take(0) << "defghi"
        expect(result).to         eq("defghi")
        expect(result.storage).to eql(lower_ptr.storage)
      end

      it "is zero-copy when possible" do
        result = lower_ptr.drop(3).take(3) << "ghi"
        expect(result).to         eq("defghi")
        expect(result.storage).to eql(lower_ptr.storage)
      end

      it "is zero-copy when possible" do
        result = lower_ptr << upper_ptr.take(3)
        expect(result).to         eq(lower + "ABC")
        expect(result.storage).to eql(lower_ptr.storage)
      end

      it "allocates new string otherwise" do
        result = lower_ptr.drop(3).take(3) << "xyz"
        expect(result).to             eq("defxyz")
        expect(result.storage).to_not eql(lower_ptr.storage)
      end
    end

    context "when argument is a string pointer" do
      it "is zero-copy when possible" do
        result = lower_ptr.drop(3).take(3) << lower_ptr.drop(6).take(3)
        expect(result).to         eq("defghi")
        expect(result.storage).to eql(lower_ptr.storage)
      end

      todo "is zero-copy when possible" do
        result = lower_ptr.drop(3).take(3) << lower_ptr.drop(33).take(3)
        expect(result).to         eq("defghi")
        expect(result.storage).to eql(lower_ptr.storage)
      end

      todo "is zero-copy when possible" do
        result = lower_ptr.drop(15).take(3) << upper_ptr.drop(45).take(3)
        expect(result).to         eq("pqrstu")
        expect(result.storage).to eql(lower_ptr.storage)
      end
    end
  end

  describe "#+" do
    context "when argument is a string" do
      it "is zero-copy when possible" do
        result = lower_ptr.drop(3).take(0) + "defghi"
        expect(result).to         eq("defghi")
        expect(result.storage).to eql(lower_ptr.storage)
      end

      it "is zero-copy when possible" do
        result = lower_ptr.drop(3).take(3) + "ghi"
        expect(result).to         eq("defghi")
        expect(result.storage).to eql(lower_ptr.storage)
      end

      it "is zero-copy when possible" do
        result = lower_ptr + upper_ptr.take(3)
        expect(result).to eq(lower + "ABC")
        expect(result).to be_a(String)
      end

      it "allocates new string otherwise" do
        result = lower_ptr.drop(3).take(3) + "xyz"
        expect(result).to eq("defxyz")
        expect(result).to be_a(String)
      end
    end

    context "when argument is a string pointer" do
      it "is zero-copy when possible" do
        result = lower_ptr.drop(3).take(3) + lower_ptr.drop(6).take(3)
        expect(result).to         eq("defghi")
        expect(result.storage).to eql(lower_ptr.storage)
      end

      todo "is zero-copy when possible" do
        result = lower_ptr.drop(3).take(3) + lower_ptr.drop(33).take(3)
        expect(result).to         eq("defghi")
        expect(result.storage).to eql(lower_ptr.storage)
      end

      todo "is zero-copy when possible" do
        result = lower_ptr.drop(15).take(3) + upper_ptr.drop(45).take(3)
        expect(result).to         eq("pqrstu")
        expect(result.storage).to eql(lower_ptr.storage)
      end
    end
  end

  describe "#blank?" do
    it "is true on empty strings" do
      expect(lower_ptr.drop(10).take(0)).to be_blank
      expect(lower_ptr.drop(lower_ptr.length)).to be_blank
      expect(Stupidedi::Reader::Pointer.build("")).to be_blank
    end

    it "is true on whitespace-only strings" do
      expect(Stupidedi::Reader::Pointer.build(" \r\n\t\v\f")).to be_blank
    end

    it "is false on strings with non-whitespace" do
      expect(lower_ptr).to_not be_blank
      expect(Stupidedi::Reader::Pointer.build(" \r\n\t\v\f x")).to_not be_blank
    end
  end

  describe "#match?" do
    it "matches within a substring" do
      expect(lower_ptr).to                  be_match(/e/)
      expect(lower_ptr.drop(3).take(3)).to  be_match(/e/)
    end

    it "matches within a substring" do
      expect(lower_ptr.drop(3).take(3)).to be_match(/[a-z]+/)
    end

    it "doesn't match outside of substring" do
      expect(lower_ptr.drop(3)).to      be_match(/a/)
      expect(lower_ptr.drop(27)).to_not be_match(/z/)
    end

    it "matches when regexp has an anchor" do
      expect(lower_ptr.drop(3)).to      be_match(/^d.f/)
      expect(lower_ptr.drop(3)).to_not  be_match(/^a/)
      expect(lower_ptr.take(10)).to     be_match(/j$/)
    end

    it "matches when regexp has a character class with $ or ^" do
      expect(lower_ptr).to be_match(/[$a]/)
      expect(lower_ptr).to be_match(/[^a]/)
    end
  end

  describe "#start_with?" do
    context "when argument is a string" do
      specify { expect(lower_ptr).to         be_start_with("abc") }
      specify { expect(lower_ptr.drop(3)).to be_start_with("def") }

      specify { expect(lower_ptr.drop(3)).to_not be_start_with("abc") }
      specify { expect(lower_ptr.drop(3)).to_not be_start_with("ghi") }
    end

    context "when argument is a string pointer" do
      specify { expect(lower_ptr).to be_start_with(lower_ptr.take(5)) }
      specify { expect(lower_ptr.drop(5)).to_not be_start_with(lower_ptr) }
    end

    context "when argument is an unrelated string pointer" do
      specify do
        stuvw = lower_ptr.drop(45).take(5)
        other = upper_ptr.drop(18).take(5)

        expect(stuvw).to be_start_with(other)
      end
    end

    context "when argument is some other type" do
      it "raises an error" do
        expect{lower_ptr.start_with?(:abc)}.to raise_error(TypeError)
      end
    end
  end

  describe "#index" do
    context "when argument is a regexp" do
      todo "returns the first match"
      todo "doesn't match outside of pointer bounds"
    end

    context "when argument is a string" do
      it "returns the first match" do
        expect(lower_ptr.index("a")).to    eq(0)
        expect(lower_ptr.index("f")).to    eq(5)
        expect(lower_ptr.index("f", 5)).to eq(5)
        expect(lower_ptr.index("f", 6)).to eq(32)
      end

      it "doesn't match outside of pointer bounds" do
        expect(lower_ptr.take(10).index("z")).to be_nil
        expect(lower_ptr.drop(20).index("o")).to be_nil
      end
    end

    todo "when argument is a string pointer"
  end

  describe "#rindex" do
    context "when argument is a regexp" do
      todo "returns the last match"
      todo "doesn't match outside of pointer bounds"
    end

    context "when argument is a string" do
      it "returns the last match" do
        expect(lower_ptr.rindex("a")).to    eq(27)
        expect(lower_ptr.rindex("f")).to    eq(32)
        expect(lower_ptr.rindex("f", 32)).to eq(32)
        expect(lower_ptr.rindex("f", 31)).to eq(5)
      end

      it "doesn't match outside of pointer bounds" do
        expect(lower_ptr.take(10).rindex("z")).to be_nil
        expect(lower_ptr.drop(20).rindex("o")).to be_nil
      end
    end

    todo "when argument is a string pointer"
  end

  describe "#count" do
    it "counts matching substrings" do
      expect(lower_ptr.count("a")).to   eq(2)
      expect(lower_ptr.count(/z/i)).to  eq(2)
      expect(lower_ptr.count("no")).to  eq(1)
    end
  end

  describe "#rstrip" do
    let(:sb) { Stupidedi::Reader::Pointer.build("  abc  ") }
    let(:mb) { Stupidedi::Reader::Pointer.build("  💃🏽🕺🏻  ") }

    context "when string doesn't end with whitespace" do
      it "returns self" do
        expect(lower_ptr.rstrip).to eql(lower_ptr)
      end
    end

    context "when string ends with whitespace" do
      it "is zero-copy" do
        expect(sb.rstrip).to eq("  abc")
        expect(sb.rstrip.storage).to eql(sb.storage)

        expect(mb.rstrip).to eq("  💃🏽🕺🏻")
        expect(mb.rstrip.storage).to eql(mb.storage)
      end
    end
  end

  describe "#lstrip" do
    let(:sb) { Stupidedi::Reader::Pointer.build("  abc  ") }
    let(:mb) { Stupidedi::Reader::Pointer.build("  💃🏽🕺🏻  ") }

    context "when string doesn't end with whitespace" do
      it "returns self" do
        expect(lower_ptr.rstrip).to eql(lower_ptr)
      end
    end

    context "when string ends with whitespace" do
      it "is zero-copy" do
        expect(sb.lstrip).to eq("abc  ")
        expect(sb.lstrip.storage).to eql(sb.storage)

        expect(mb.lstrip).to eq("💃🏽🕺🏻  ")
        expect(mb.lstrip.storage).to eql(mb.storage)
      end
    end
  end
end
