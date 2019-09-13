# frozen_string_literal: true
# encoding: utf-8
describe Stupidedi::Reader::StringPtr do

  def pointer(string)
    Stupidedi::Reader::Pointer.build(string)
  end

  def prefix(pointer)
    pointer.storage[0, pointer.offset]
  end

  def suffix(pointer)
    pointer.storage[pointer.offset + pointer.length..-1]
  end

  let(:lower) { "abcdefghijklmnopqrstuvwxyz abcdefghijklmnOPQRSTUVWXYZ".dup }
  let(:upper) { "ABCDEFGHIJKLMNOPQRSTUVWXYZ ABCDEFGHIJKLMNopqrstuvwxyz".dup }

  let(:lower_ptr) { pointer(lower.dup) }
  let(:upper_ptr) { pointer(upper.dup) }

  describe "#to_s" do
    it "is called implicitly" do
      expect("-#{lower_ptr.take(3)}-").to eq("-abc-")
    end

    context "when storage is shared" do
      allocation do
        a = lower_ptr.drop(10)
        b = nil
        expect{ b = a.to_str }.to allocate(String: 1)
        expect(b).to_not be_frozen
      end
    end

    context "when storage is not shared" do
      allocation do
        a = lower_ptr
        b = nil
        expect{ b = a.to_str }.to allocate(String: 1)
        expect(b).to_not be_frozen
      end
    end
  end

  describe "#to_str" do
    it "is called implicitly" do
      comma = Stupidedi::Reader::Pointer.build(",")
      expect(%w(a b c).join(comma)).to eq("a,b,c")
    end

    context "when storage is shared" do
      allocation do
        a = lower_ptr.drop(10)
        b = nil
        expect{ b = a.to_str }.to allocate(String: 1)
        expect(b).to_not be_frozen
      end
    end

    context "when storage is not shared" do
      allocation do
        a = lower_ptr
        b = nil
        expect{ b = a.to_str }.to allocate(String: 1)
        expect(b).to_not be_frozen
      end
    end
  end

  describe "#==" do
    allocation "is reflexive" do
      a = lower_ptr
      b = upper_ptr
      result = nil

      expect{ result = a == a }.to allocate(String: 0)
      expect(result).to be true

      expect{ result = a == b }.to allocate(String: 0)
      expect(result).to be false
    end

    allocation "compares string pointers to plain strings" do
      a, a_ = lower_ptr, lower
      b, b_ = upper_ptr, upper
      result = nil

      expect{ result = a == a_ }.to allocate(String: 0)
      expect(result).to be true

      expect{ result = a == b_ }.to allocate(String: 0)
      expect(result).to be false
    end

    allocation "works on identical substrings" do
      a  = lower_ptr.drop(10).take(10)
      a_ = lower_ptr.drop(10).take(10)
      result = nil

      expect{ result = a == a_ }.to allocate(String: 0)
      expect(result).to be true
    end

    allocation "works on non-identical substrings" do
      a  = lower_ptr.take(10)
      a_ = lower_ptr.drop(27).take(10)
      b_ = upper_ptr.drop(27).take(10)
      result = nil

      expect{ result = a == a_ }.to allocate(String: 0)
      expect(result).to be true

      expect{ result = a == b_ }.to allocate(String: 0)
      expect(result).to be false
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

    # Our backported implementation in Refinements allocates one MatchData
    def cost_of_match?(ncalls)
      unless "".respond_to?(:match?)
        ncalls
      end || 0
    end

    context "when pointer spans whole string" do
      allocation do
        value = lower_ptr
        expect{ value =~ /z/ }.to allocate(String: 0, Array: 1, MatchData: 1)
      end
    end

    context "when pointer starts at zero" do
      context "and remaining string length < 1024" do
        allocation do
          value = lower_ptr.drop(5)
          expect { value =~ /z/ }.to allocate(String: 1, Array: 1, MatchData: 1 + cost_of_match?(1))
        end
      end

      context "and remaining string length > 1024" do
        allocation do
          value = (lower_ptr << "x" * 1024).drop(5)
          expect { value =~ /z/ }.to allocate(String: 1, Array: 1, MatchData: 1)
        end
      end
    end

    context "when pointer ends at -1" do
      context "and remaining string length < 1024" do
        allocation do
          value = lower_ptr.take(5)
          expect { value =~ /z/ }.to allocate_at_most(String: 1, Array: 1, MatchData: 1 + cost_of_match?(1))
        end
      end

      context "and remaining string length > 1024" do
        allocation do
          value = (lower_ptr << "x" * 1024).take(10)
          expect { value =~ /z/ }.to allocate(String: 1, Array: 1)
        end
      end
    end
  end

  describe "#<<" do
    let(:a) { pointer("abcdefghi".dup) }

    context "when argument is a string" do
      context "when pointer suffix starts with argument" do
        allocation do
          b = a.drop(3).take(3)
          c = "gh"

          # Precondition
          expect(suffix(b)).to start_with(c)

          expect{ b << c }.to allocate(String: 0)
          expect(a).to eq("abcdefghi")
          expect(b).to eq("defgh")
          expect(c).to eq("gh")
        end
      end

      context "when argument is pointer suffix plus more" do
        allocation do
          b = a.drop(3).take(3)
          c = "ghijkl"

          # Precondition
          expect(c).to start_with(suffix(b))
          expect(c).to_not eq(suffix(b))

          expect{ b << c }.to allocate(String: 1)
          expect(a).to eq("abcdefghi")
          expect(b).to eq("defghijkl")
          expect(c).to eq("ghijkl")
        end
      end

      context "when argument is not pointer suffix" do
        context "when pointer isn't frozen" do
          allocation do
            b = "xxx"

            # Precondition
            expect(a.storage).to_not be_frozen

            expect{ a << b }.to allocate(String: 0)
            expect(a).to eq("abcdefghixxx")
            expect(b).to eq("xxx")
          end
        end

        context "when pointer is frozen" do
          allocation do
            b = a.take(6)
            c = "xxx"

            # Precondition
            expect(a.storage).to be_frozen

            expect{ b << c }.to allocate(String: 1)
            expect(a).to eq("abcdefghi")
            expect(b).to eq("abcdefxxx")
            expect(c).to eq("xxx")
          end
        end
      end
    end

    context "when argument is a pointer" do
      context "when pointer suffix starts with argument" do
        allocation do
          b = a.drop(3).take(3)
          c = pointer("gh")

          # Precondition
          expect(suffix(b)).to start_with(c)

          expect{ b << c }.to allocate(String: 0)
          expect(a).to eq("abcdefghi")
          expect(b).to eq("defgh")
          expect(c).to eq("gh")
        end
      end

      context "when argument is pointer suffix plus more" do
        allocation do
          b = a.drop(3).take(3)
          c = pointer("ghijkl")

          # Precondition
          expect(c).to start_with(suffix(b))
          expect(c).to_not eq(suffix(b))

          expect{ b << c }.to allocate(String: 1)
          expect(a).to eq("abcdefghi")
          expect(b).to eq("defghijkl")
          expect(c).to eq("ghijkl")
        end
      end

      context "when argument is not pointer suffix" do
        context "when pointer isn't frozen" do
          allocation do
            b = pointer("xxx")

            # Precondition
            expect(a.storage).to_not be_frozen

            expect{ a << b }.to allocate(String: 0)
            expect(a).to eq("abcdefghixxx")
            expect(b).to eq("xxx")
          end
        end

        context "when pointer is frozen" do
          allocation do
            b = a.take(6)
            c = pointer("xxx")

            # Precondition
            expect(a.storage).to be_frozen

            expect{ b << c }.to allocate(String: 1)
            expect(a).to eq("abcdefghi")
            expect(b).to eq("abcdefxxx")
            expect(c).to eq("xxx")
          end
        end
      end
    end
  end

  describe "#+" do
    let(:a) { pointer("abcdefghi".dup) }

    context "when argument is a string" do
      context "when pointer suffix starts with argument" do
        allocation do
          b = a.drop(3).take(3)
          c = "gh"
          d = nil

          # Precondition
          expect(suffix(b)).to start_with(c)

          expect{ d = b + c }.to allocate(String: 0, a.class => 1)
          expect(b).to eq("def")
          expect(c).to eq("gh")
          expect(d).to eq("defgh")
          expect(d).to be_a(a.class)
        end
      end

      context "when argument is pointer suffix plus more" do
        allocation do
          b = a.drop(3).take(3)
          c = "ghijkl"
          d = nil

          # Precondition
          expect(c).to start_with(suffix(b))
          expect(c).to_not eq(suffix(b))

          expect{ d = b + c }.to allocate(String: 1)
          expect(a).to eq("abcdefghi")
          expect(b).to eq("def")
          expect(c).to eq("ghijkl")
          expect(d).to eq("defghijkl")
          expect(d).to be_a(String)
        end
      end

      context "when argument is not pointer suffix" do
        allocation do
          b = a.take(6)
          c = "xxx"
          d = nil

          # Precondition
          expect(a.storage).to be_frozen

          expect{ d = b + c }.to allocate(String: 1)
          expect(a).to eq("abcdefghi")
          expect(b).to eq("abcdef")
          expect(c).to eq("xxx")
          expect(d).to eq("abcdefxxx")
          expect(d).to be_a(String)
        end
      end
    end

    context "when argument is a string pointer" do
      context "when pointer suffix starts with argument" do
        allocation do
          b = a.drop(3).take(3)
          c = pointer("gh")
          d = nil

          # Precondition
          expect(suffix(b)).to start_with(c)

          expect{ d = b + c }.to allocate(String: 0, a.class => 1)
          expect(a).to eq("abcdefghi")
          expect(b).to eq("def")
          expect(c).to eq("gh")
          expect(d).to eq("defgh")
          expect(d).to be_a(a.class)
        end
      end

      context "when argument is pointer suffix plus more" do
        allocation do
          b = a.drop(3).take(3)
          c = pointer("ghijkl")
          d = nil

          # Precondition
          expect(c).to start_with(suffix(b))
          expect(c).to_not eq(suffix(b))

          expect{ d = b + c }.to allocate(String: 1)
          expect(a).to eq("abcdefghi")
          expect(b).to eq("def")
          expect(c).to eq("ghijkl")
          expect(d).to eq("defghijkl")
          expect(d).to be_a(String)
        end
      end

      context "when argument is not pointer suffix" do
        allocation do
          b = a.take(6)
          c = pointer("xxx")
          d = nil

          # Precondition
          expect(suffix(b)).to_not start_with(c)

          expect{ d = b + c }.to allocate(String: 1)
          expect(a).to eq("abcdefghi")
          expect(b).to eq("abcdef")
          expect(c).to eq("xxx")
          expect(d).to eq("abcdefxxx")
          expect(d).to be_a(String)
        end
      end
    end
  end

  describe "#blank?" do
    it "is true on empty strings" do
      expect(lower_ptr.drop(10).take(0)).to be_blank
      expect(lower_ptr.drop(lower_ptr.length)).to be_blank
      expect(pointer("")).to be_blank
    end

    it "is true on whitespace-only strings" do
      expect(pointer(" \r\n\t\v\f")).to be_blank
    end

    it "is false on strings with non-whitespace" do
      expect(lower_ptr).to_not be_blank
      expect(pointer(" \r\n\t\v\f x")).to_not be_blank
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
        expect(lower_ptr.rstrip).to equal(lower_ptr)
      end
    end

    context "when string ends with whitespace" do
      it "is zero-copy" do
        expect(sb.rstrip).to eq("  abc")
        expect(sb.rstrip.storage).to eq(sb.storage)

        expect(mb.rstrip).to eq("  💃🏽🕺🏻")
        expect(mb.rstrip.storage).to eq(mb.storage)
      end
    end
  end

  describe "#lstrip" do
    let(:sb) { Stupidedi::Reader::Pointer.build("  abc  ") }
    let(:mb) { Stupidedi::Reader::Pointer.build("  💃🏽🕺🏻  ") }

    context "when string doesn't begin with whitespace" do
      it "returns self" do
        expect(lower_ptr.lstrip).to equal(lower_ptr)
      end
    end

    context "when string ends with whitespace" do
      it "is zero-copy" do
        expect(sb.lstrip).to eq("abc  ")
        expect(sb.lstrip.storage).to equal(sb.storage)

        expect(mb.lstrip).to eq("💃🏽🕺🏻  ")
        expect(mb.lstrip.storage).to equal(mb.storage)
      end
    end
  end

  describe "#min_graphic_index" do
    context "when string begins with a graphic character" do
      specify { expect(pointer(" abc ").min_graphic_index(0)).to eq(0) }
      specify { expect(pointer(" abc ").min_graphic_index(1)).to eq(1) }
      specify { expect(pointer("  💃🏽🕺🏻  ").min_graphic_index(0)).to eq(0) }
      specify { expect(pointer("  💃🏽🕺🏻  ").min_graphic_index(1)).to eq(1) }
    end

    context "when string doesn't begin with a graphic character" do
      specify { expect(pointer("\r\nabc ").min_graphic_index(0)).to eq(2) }
      specify { expect(pointer("\r\nabc ").min_graphic_index(1)).to eq(2) }
      specify { expect(pointer("\r\n 💃🏽🕺🏻  ").min_graphic_index(0)).to eq(2) }
      specify { expect(pointer("\r\n 💃🏽🕺🏻  ").min_graphic_index(1)).to eq(2) }
    end

    context "when string doesn't contain a graphic character" do
      specify { expect(pointer("").min_graphic_index(0)).to eq(0) }
      specify { expect(pointer("\r\n").min_graphic_index(0)).to eq(2) }
      specify { expect(pointer("abc\r\n").min_graphic_index(3)).to eq(5) }
    end
  end

  describe "#min_whitespace_index" do
  end

  describe "#max_whitespace_index" do
  end
end
