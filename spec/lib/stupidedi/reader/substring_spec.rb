# frozen_string_literal: true
# encoding: utf-8
describe Stupidedi::Reader::Substring do
  using Stupidedi::Refinements

  def pointer(string)
    Stupidedi::Reader::Pointer.build(string)
  end

  def prefix(pointer)
    pointer.storage[0, pointer.offset]
  end

  def suffix(pointer)
    pointer.storage[pointer.offset + pointer.length..-1]
  end

  # Yields all valid offset and length pairs for a string of the given length
  def substrings(length)
    length.times do |n|
      next if n.zero?

      (length - n).times do |o|
        yield o, n
      end
    end
  end

  let(:lower) { "abcdefghi".dup }
  let(:upper) { "ABCDEFGHI".dup }

  let(:lower_ptr) { pointer(lower.dup) }
  let(:upper_ptr) { pointer(upper.dup) }

  describe "#to_s" do
    it "is called implicitly" do
      expect("#{lower_ptr}").to eq(lower)
    end

    context "when storage is shared" do
      specify do
        a = lower_ptr.drop(10)
        b = a.to_s
        expect(b).to_not be_frozen
      end

      allocation do
        a = lower_ptr.drop(10)
        expect{ a.to_s }.to allocate(String: 1)
      end
    end

    context "when storage is not shared" do
      specify do
        a = lower_ptr
        b = a.to_s
        expect(b).to_not be_frozen
      end

      allocation do
        a = lower_ptr
        expect{ a.to_s }.to allocate(String: 1)
      end
    end
  end

  describe "#to_str" do
    it "is called implicitly" do
      expect(lower).to eq(lower_ptr)
      expect(lower_ptr).to eq(lower)
    end

    context "when storage is shared" do
      specify do
        a = lower_ptr.drop(10)
        b = a.to_str
        expect(b).to_not be_frozen
      end

      allocation do
        a = lower_ptr.drop(10)
        expect{ a.to_str }.to allocate(String: 1)
      end
    end

    context "when storage is not shared" do
      specify do
        a = lower_ptr
        b = a.to_str
        expect(b).to_not be_frozen
      end

      allocation do
        a = lower_ptr
        expect{ a.to_str }.to allocate(String: 1)
      end
    end
  end

  describe "#==" do
    allocation "is reflexive" do
      a = lower_ptr
      b = upper_ptr

      expect(a).to eq(a)
      expect(a).to_not eq(b)
    end

    allocation "is reflexive" do
      a = lower_ptr
      b = upper_ptr
      expect{ a == a }.to allocate(String: 0)
      expect{ a == b }.to allocate(String: 0)
    end

    context "when pointer is a string" do
      specify do
        a, a_ = lower_ptr, lower
        b, b_ = upper_ptr, upper
        result = nil

        expect(a).to     eq(a_)
        expect(a).to_not eq(b_)
      end

      allocation do
        a, a_ = lower_ptr, lower
        b, b_ = upper_ptr, upper
        expect{ a == a_ }.to allocate(String: 0)
        expect{ a == b_ }.to allocate(String: 0)
      end
    end

    context "when two pointers are identical" do
      specify do
        a  = lower_ptr.drop(10).take(10)
        a_ = lower_ptr.drop(10).take(10)

        expect(a).to eq(a_)
      end

      allocation do
        a  = lower_ptr.drop(10).take(10)
        a_ = lower_ptr.drop(10).take(10)
        expect{ a == a_ }.to allocate(String: 0)
      end
    end

    context "when pointers are not identical" do
      specify do
        p  = pointer("abcdef abcdef")
        a  = p.take(3)
        a_ = p.drop(7).take(3)
        b_ = p.drop(2).take(3)

        expect(a).to     eq(a_)
        expect(a).to_not eq(b_)
      end

      allocation do
        p  = pointer("abcdef abcdef")
        a  = p.take(3)
        a_ = p.drop(1).take(3)
        b_ = p.drop(2).take(3)
        expect{ a == a_ }.to allocate(String: 0)
        expect{ a == b_ }.to allocate(String: 0)
      end
    end
  end

  describe "#<<" do
    let(:a) { lower_ptr }

    context "when argument is a string" do
      context "when pointer suffix starts with argument" do
        specify do
          b = a.drop(3).take(3)
          c = "gh"

          # Precondition
          expect(suffix(b)).to start_with(c)

          b << c
          expect(a).to eq("abcdefghi")
          expect(b).to eq("defgh")
          expect(c).to eq("gh")
        end

        allocation do
          b = a.drop(3).take(3)
          expect(suffix(b)).to start_with("gh")
          expect{ b << "gh" }.to allocate(String: 0)
        end
      end

      context "when argument is pointer suffix plus more" do
        specify do
          b = a.drop(3).take(3)
          c = "ghijkl"

          # Precondition
          expect(c).to start_with(suffix(b))
          expect(c).to_not eq(suffix(b))

          b << c
          expect(a).to eq("abcdefghi")
          expect(b).to eq("defghijkl")
          expect(c).to eq("ghijkl")
        end

        allocation do
          b = a.drop(3).take(3)
          c = "ghijkl"
          expect(c).to start_with(suffix(b))
          expect(c).to_not eq(suffix(b))
          expect{ b << c }.to allocate(String: 1)
        end
      end

      context "when argument is not pointer suffix" do
        context "when pointer isn't frozen" do
          specify do
            b = "xxx"

            # Precondition
            expect(a.storage).to_not be_frozen

            a << b
            expect(a).to eq("abcdefghixxx")
            expect(b).to eq("xxx")
          end

          allocation do
            expect(a.storage).to_not be_frozen
            expect{ a << "xxx" }.to allocate(String: 0)
          end
        end

        context "when pointer is frozen" do
          specify do
            b = a.take(6)
            c = "xxx"

            # Precondition
            expect(a.storage).to be_frozen

            b << c
            expect(a).to eq("abcdefghi")
            expect(b).to eq("abcdefxxx")
            expect(c).to eq("xxx")
          end

          allocation do
            b = a.take(6)
            expect(a.storage).to be_frozen
            expect{ b << "xxx" }.to allocate(String: 1)
          end
        end
      end
    end

    context "when argument is a pointer" do
      context "when pointer suffix starts with argument" do
        specify do
          b = a.drop(3).take(3)
          c = pointer("gh")

          # Precondition
          expect(suffix(b)).to start_with(c)

          b << c
          expect(a).to eq("abcdefghi")
          expect(b).to eq("defgh")
          expect(c).to eq("gh")
        end

        allocation do
          b = a.drop(3).take(3)
          c = pointer("gh")
          expect(suffix(b)).to start_with(c)
          expect{ b << c }.to allocate(String: 0)
        end
      end

      context "when argument is pointer suffix plus more" do
        specify do
          b = a.drop(3).take(3)
          c = pointer("ghijkl")

          # Precondition
          expect(c).to start_with(suffix(b))
          expect(c).to_not eq(suffix(b))

          b << c
          expect(a).to eq("abcdefghi")
          expect(b).to eq("defghijkl")
          expect(c).to eq("ghijkl")
        end

        allocation do
          b = a.drop(3).take(3)
          c = pointer("ghijkl")
          expect(c).to start_with(suffix(b))
          expect(c).to_not eq(suffix(b))
          expect{ b << c }.to allocate(String: 1)
        end
      end

      context "when argument is not pointer suffix" do
        context "when pointer isn't frozen" do
          specify do
            b = pointer("xxx")

            # Precondition
            expect(a.storage).to_not be_frozen

            a << b
            expect(a).to eq("abcdefghixxx")
            expect(b).to eq("xxx")
          end

          allocation do
            b = pointer("xxx")
            expect(a.storage).to_not be_frozen
            expect{ a << b }.to allocate(String: 0)
          end
        end

        context "when pointer is frozen" do
          specify do
            b = a.take(6)
            c = pointer("xxx")

            # Precondition
            expect(a.storage).to be_frozen

            b << c
            expect(a).to eq("abcdefghi")
            expect(b).to eq("abcdefxxx")
            expect(c).to eq("xxx")
          end

          allocation do
            b = a.take(6)
            c = pointer("xxx")
            expect(a.storage).to be_frozen
            expect{ b << c }.to allocate(String: 1)
          end
        end
      end
    end
  end

  describe "#+" do
    let(:a) { pointer("abcdefghi".dup) }

    context "when argument is a string" do
      context "when pointer suffix starts with argument" do
        specify do
          b = a.drop(3).take(3)
          c = "gh"

          # Precondition
          expect(suffix(b)).to start_with(c)

          d = b + c
          expect(b).to eq("def")
          expect(c).to eq("gh")
          expect(d).to eq("defgh")
          expect(d).to be_a(a.class)
        end

        allocation do
          b = a.drop(3).take(3)
          c = "gh"
          expect(suffix(b)).to start_with(c)
          expect{ b + c }.to allocate(String: 0, a.class => 1)
        end
      end

      context "when argument is pointer suffix plus more" do
        specify do
          b = a.drop(3).take(3)
          c = "ghijkl"

          # Precondition
          expect(c).to start_with(suffix(b))
          expect(c).to_not eq(suffix(b))

          d = b + c
          expect(a).to eq("abcdefghi")
          expect(b).to eq("def")
          expect(c).to eq("ghijkl")
          expect(d).to eq("defghijkl")
          expect(d).to be_a(String)
        end

        allocation do
          b = a.drop(3).take(3)
          c = "ghijkl"
          expect(c).to start_with(suffix(b))
          expect(c).to_not eq(suffix(b))
          expect{ b + c }.to allocate(String: 1)
        end
      end

      context "when argument is not pointer suffix" do
        specify do
          b = a.take(6)
          c = "xxx"

          # Precondition
          expect(a.storage).to be_frozen

          d = b + c
          expect(a).to eq("abcdefghi")
          expect(b).to eq("abcdef")
          expect(c).to eq("xxx")
          expect(d).to eq("abcdefxxx")
          expect(d).to be_a(String)
        end

        allocation do
          b = a.take(6)
          c = "xxx"
          expect(a.storage).to be_frozen
          expect{ b + c }.to allocate(String: 1)
        end
      end
    end

    context "when argument is a string pointer" do
      context "when pointer suffix starts with argument" do
        specify do
          b = a.drop(3).take(3)
          c = pointer("gh")

          # Precondition
          expect(suffix(b)).to start_with(c)

          d = b + c
          expect(a).to eq("abcdefghi")
          expect(b).to eq("def")
          expect(c).to eq("gh")
          expect(d).to eq("defgh")
          expect(d).to be_a(a.class)
        end

        allocation do
          b = a.drop(3).take(3)
          c = pointer("gh")
          expect(suffix(b)).to start_with(c)
          expect{ b + c }.to allocate(String: 0, a.class => 1)
        end
      end

      context "when argument is pointer suffix plus more" do
        specify do
          b = a.drop(3).take(3)
          c = pointer("ghijkl")

          # Precondition
          expect(c).to start_with(suffix(b))
          expect(c).to_not eq(suffix(b))

          d = b + c
          expect(a).to eq("abcdefghi")
          expect(b).to eq("def")
          expect(c).to eq("ghijkl")
          expect(d).to eq("defghijkl")
          expect(d).to be_a(String)
        end

        allocation do
          b = a.drop(3).take(3)
          c = pointer("ghijkl")
          expect(c).to start_with(suffix(b))
          expect(c).to_not eq(suffix(b))
          expect{ b + c }.to allocate(String: 1)
        end
      end

      context "when argument is not pointer suffix" do
        specify do
          b = a.take(6)
          c = pointer("xxx")

          # Precondition
          expect(suffix(b)).to_not start_with(c)

          d = b + c
          expect(a).to eq("abcdefghi")
          expect(b).to eq("abcdef")
          expect(c).to eq("xxx")
          expect(d).to eq("abcdefxxx")
          expect(d).to be_a(String)
        end

        allocation do
          b = a.take(6)
          c = pointer("xxx")
          expect(suffix(b)).to_not start_with(c)
          expect{ b + c }.to allocate(String: 1)
        end
      end
    end
  end

  # We backported this method from Ruby 2.4+, but our implementation allocates
  # an object that 2.4+ doesn't (when a match is made)
  def matchp(num_calls)
    if "".respond_to?(:match?) then 0 else 1 end
  end

  allocation do
    skip "Only needed to verify assumptions made in other tests"

    expect{ "abc" =~ /z/ }.to allocate(MatchData: 0)
    expect{ "abc" =~ /./ }.to allocate(MatchData: 1)
    expect{ /z/ =~ "abc" }.to allocate(MatchData: 0)
    expect{ /./ =~ "abc" }.to allocate(MatchData: 1)

    expect{ "abc".match(/z/) }.to allocate(MatchData: 0)
    expect{ "abc".match(/./) }.to allocate(MatchData: 1)
    expect{ /z/.match("abc") }.to allocate(MatchData: 0)
    expect{ /./.match("abc") }.to allocate(MatchData: 1)

    expect{ "abc".match?(/z/) }.to allocate(MatchData: matchp(1))
    expect{ "abc".match?(/./) }.to allocate(MatchData: matchp(1))
    expect{ /z/.match?("abc") }.to allocate(MatchData: matchp(1))
    expect{ /./.match?("abc") }.to allocate(MatchData: matchp(1))
  end

  describe "=~" do
    shared_examples "=~ memory allocation" do
      let(:anchored) { anchor_a || anchor_z }

      # NOTE: There are three places a String can be allocated
      # - Invoking Regexp#inspect to determine if the regexp is anchored
      # - When the regexp matches, the MatchData has the matching substring
      # - For anchored regexps, in some cases, Pointer#reify is called

      context "when pointer looks like [*************]" do
        specify do
          a = lower_ptr

          # Preconditions
          expect(a.length).to         eq(a.storage.length)
          expect(a.storage.length).to be < 1024

          expect(a).to_not match(regexp_x)
          expect(a).to     match(regexp_o)
        end

        allocation do
          a = lower_ptr
          expect(a.length).to         eq(a.storage.length)
          expect(a).to                match(regexp_o)
          expect(a).to_not            match(regexp_x)
          expect(a.storage.length).to be < 1024

          if reify_ooo
            expect{ a =~ regexp_x }.to allocate(String: 2, Array: 0, MatchData: 0)
            expect{ a =~ regexp_o }.to allocate(String: 3, Array: 0, MatchData: 1)
          else
            expect{ a =~ regexp_x }.to allocate(String: 0, Array: 0, MatchData: 0)
            expect{ a =~ regexp_o }.to allocate(String: 1, Array: 1, MatchData: 1)
          end
        end
      end

      context "when pointer looks like [*****]--------" do
        specify do
          a = lower_ptr.take(6)

          # Preconditions
          expect(a.offset).to         eq(0)
          expect(a.length).to         be < a.storage.length
          expect(a.storage.length).to be < 1024

          expect(a).to_not match(regexp_x)
          expect(a).to     match(regexp_o)
        end

        allocation do
          a = lower_ptr.take(6)
          expect(a.offset).to         eq(0)
          expect(a.length).to         be < a.storage.length
          expect(a).to                match(regexp_o)
          expect(a).to_not            match(regexp_x)
          expect(a.storage.length).to be < 1024

          if reify_oox
            expect{ a =~ regexp_x }.to allocate(String: 2, Array: (anchor_z && 1 || 0), MatchData: 0+matchp(anchored && 1 || 0))
            expect{ a =~ regexp_o }.to allocate(String: 3, Array: (anchor_z && 1 || 0), MatchData: 1+matchp(anchored && 1 || 0))
          else
            expect{ a =~ regexp_x }.to allocate(String: 1, Array: (anchor_z && 1 || 0), MatchData: 0+matchp(anchored && 1 || 0))
            expect{ a =~ regexp_o }.to allocate(String: 1, Array: (anchor_z && 1 || 1), MatchData: 1+matchp(anchored && 1 || 0))
          end
        end
      end

      context "when pointer looks like ----[*****]----" do
        specify do
          a = lower_ptr.drop(3).take(3)

          # Preconditions
          expect(a.offset).to_not         eq(0)
          expect(a.offset + a.length).to  be < a.storage.length
          expect(a.storage.length).to     be < 1024

          expect(a).to_not match(regexp_x)
          expect(a).to     match(regexp_o)
        end

        allocation do
          a = lower_ptr.drop(3).take(3)
          expect(a.offset).to_not         eq(0)
          expect(a.offset + a.length).to  be < a.storage.length
          expect(a).to                    match(regexp_o)
          expect(a).to_not                match(regexp_x)
          expect(a.storage.length).to     be < 1024

          if reify_xox
            expect{ a =~ regexp_x }.to allocate(String: 2, Array: 1, MatchData: 0+matchp(anchored && 1 || 0))
            expect{ a =~ regexp_o }.to allocate(String: 3, Array: 1, MatchData: 1+matchp(anchored && 1 || 0))
          else
            expect{ a =~ regexp_x }.to allocate(String: 1, Array: 0, MatchData: 0+matchp(anchored && 1 || 0))
            expect{ a =~ regexp_o }.to allocate(String: 1, Array: 1, MatchData: 1+matchp(anchored && 1 || 0))
          end
        end
      end

      context "when pointer looks like --------[*****]" do
        specify do
          a = lower_ptr.drop(3)

          # Preconditions
          expect(a.offset + a.length).to  eq(a.storage.length)
          expect(a.offset).to_not         eq(0)
          expect(a.storage.length).to     be < 1024

          expect(a).to_not match(regexp_x)
          expect(a).to     match(regexp_o)
        end

        allocation do
          a = lower_ptr.drop(3)

          # Preconditions
          expect(a.offset + a.length).to  eq(a.storage.length)
          expect(a.offset).to_not         eq(0)
          expect(a).to                    match(regexp_o)
          expect(a).to_not                match(regexp_x)
          expect(a.storage.length).to     be < 1024

          if reify_xoo
            expect{ a =~ regexp_x }.to allocate(String: 2, Array: (anchor_a && 1 || 0), MatchData: 0+matchp(anchored && 1 || 0))
            expect{ a =~ regexp_o }.to allocate(String: 3, Array: (anchor_a && 1 || 0), MatchData: 1+matchp(anchored && 1 || 0))
          else
            expect{ a =~ regexp_x }.to allocate(String: 1, Array: (anchor_a && 1 || 0), MatchData: 0+matchp(anchored && 1 || 0))
            expect{ a =~ regexp_o }.to allocate(String: 1, Array: (anchor_a && 1 || 1), MatchData: 1+matchp(anchored && 1 || 0))
          end
        end
      end
    end

    context "when regexp doesn't have an anchor" do
      let(:regexp_o) { /.../ }
      let(:regexp_x) { /xxx/ }

      it "works like String#=~" do
        substrings(lower.length) do |idx, len|
          expect(lower_ptr[idx, len] =~ regexp_o).to eq(lower[idx, len] =~ regexp_o)
          expect(lower_ptr[idx, len] =~ regexp_x).to eq(lower[idx, len] =~ regexp_x)
        end
      end

      let(:anchor_a)  { false }
      let(:anchor_z)  { false }
      let(:reify_ooo) { false }
      let(:reify_xoo) { false }
      let(:reify_oox) { false }
      let(:reify_xox) { false }

      include_examples "=~ memory allocation"
    end

    context "when regexp has an anchor /^.../" do
      let(:regexp_o) { /^.../ }
      let(:regexp_x) { /^xxx/ }

      it "works like String#=~" do
        substrings(lower.length) do |idx, len|
          expect(lower_ptr[idx, len] =~ regexp_o).to eq(lower[idx, len] =~ regexp_o)
          expect(lower_ptr[idx, len] =~ regexp_x).to eq(lower[idx, len] =~ regexp_x)
        end
      end

      let(:anchor_a)  { true  }
      let(:anchor_z)  { false }
      let(:reify_ooo) { false }
      let(:reify_oox) { false }
      let(:reify_xox) { true  }
      let(:reify_xoo) { true  }

      include_examples "=~ memory allocation"
    end

    context "when regexp has an anchor /...$/" do
      it "works like String#=~" do
        substrings(lower.length) do |idx, len|
          expect(lower_ptr[idx, len] =~ regexp_o).to eq(lower[idx, len] =~ regexp_o)
          expect(lower_ptr[idx, len] =~ regexp_x).to eq(lower[idx, len] =~ regexp_x)
        end
      end

      let(:regexp_o) { /...$/ }
      let(:regexp_x) { /xxx$/ }

      let(:anchor_a)  { false }
      let(:anchor_z)  { true  }
      let(:reify_ooo) { false }
      let(:reify_oox) { true  }
      let(:reify_xox) { true  }
      let(:reify_xoo) { false }

      include_examples "=~ memory allocation"
    end

    context "when regexp has [\\^]" do
      let(:regexp_o) { /[\^a-z]/ }
      let(:regexp_x) { /[\^0-9]/ }

      it "works like String#=~" do
        substrings(lower.length) do |idx, len|
          expect(lower_ptr[idx, len] =~ regexp_o).to eq(lower[idx, len] =~ regexp_o)
          expect(lower_ptr[idx, len] =~ regexp_x).to eq(lower[idx, len] =~ regexp_x)
        end
      end

      let(:anchor_a)  { false }
      let(:anchor_z)  { false }
      let(:reify_ooo) { false }
      let(:reify_oox) { false }
      let(:reify_xox) { false }
      let(:reify_xoo) { false }

      include_examples "=~ memory allocation"
    end

    context "when regexp has [\\$]" do
      let(:regexp_o) { /[a-z\$]/ }
      let(:regexp_x) { /[\$0-9]/ }

      it "works like String#=~" do
        substrings(lower.length) do |idx, len|
          expect(lower_ptr[idx, len] =~ regexp_x).to eq(lower[idx, len] =~ regexp_x)
          expect(lower_ptr[idx, len] =~ regexp_o).to eq(lower[idx, len] =~ regexp_o)
        end
      end

      let(:anchor_a)  { false }
      let(:anchor_z)  { false }
      let(:reify_ooo) { false }
      let(:reify_oox) { false }
      let(:reify_xox) { false }
      let(:reify_xoo) { false }

      include_examples "=~ memory allocation"
    end

    context "when regexp match ends out of bounds" do
      let(:regexp_o) { /..+/ }
      let(:regexp_x) { /xxx/ }

      #it "works like String#=~" do
      #  substrings(lower.length) do |idx, len|
      #    expect(lower_ptr[idx, len] =~ regexp_o).to eq(lower[idx, len] =~ regexp_o)
      #    expect(lower_ptr[idx, len] =~ regexp_x).to eq(lower[idx, len] =~ regexp_x)
      #  end
      #end

      allocation do
        a = lower_ptr.drop(3).take(3)

        # Preconditions
        expect(a.offset + a.length).to  be < a.storage.length
        expect(a.offset).to_not         eq(0)
        expect(a).to                    match(regexp_o)
        expect(a).to_not                match(regexp_x)
        expect(a.storage.length).to     be < 1024

        expect{ a =~ regexp_x }.to allocate(String: 1, Array: 0, MatchData: 0)
        expect{ a =~ regexp_o }.to allocate(String: 3, Array: 1, MatchData: 2)
      end
    end

    context "when there is a long string past the end of the pointer"
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
    it "returns true when matched" do
      expect(lower_ptr.drop(3).take(3)).to be_match(/e/)
      expect(lower_ptr.drop(3).take(3)).to be_match(/$/)
    end

    it "returns false when not matched" do
      expect(lower_ptr.drop(3).take(3)).to_not be_match(/c/)
      expect(lower_ptr.drop(3).take(3)).to_not be_match(/i/)
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
        stuvw = pointer("stuvwx").drop(3)
        other = pointer("vw uts").take(2)

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
    let(:a) { pointer("abcdef abcdef") }

    context "when argument is a regexp" do
      todo "returns the first match"
      todo "doesn't match outside of pointer bounds"
    end

    context "when argument is a string" do
      it "returns the first match" do
        expect(a.index("a")).to    eq(0)
        expect(a.index("f")).to    eq(5)
        expect(a.index("f", 5)).to eq(5)
        expect(a.index("f", 6)).to eq(12)
      end

      it "doesn't match outside of pointer bounds" do
        expect(a.take(5).index(" ")).to be_nil
        expect(a.drop(8).index("a")).to be_nil
      end
    end

    todo "when argument is a substring"

    todo "when argument is a string pointer"
  end

  describe "#rindex" do
    let(:a) { pointer("abcdef abcdef") }

    context "when argument is a regexp" do
      todo "returns the last match"
      todo "doesn't match outside of pointer bounds"
    end

    context "when argument is a string" do
      it "returns the last match" do
        expect(a.rindex("a")).to     eq(7)
        expect(a.rindex("f")).to     eq(12)
        expect(a.rindex("f", 12)).to eq(12)
        expect(a.rindex("f", 11)).to eq(5)
      end

      it "doesn't match outside of pointer bounds" do
        expect(a.take(5).rindex("f")).to be_nil
        expect(a.drop(8).rindex(" ")).to be_nil
      end
    end

    todo "when argument is a string pointer"
  end

  describe "#count" do
    specify { expect(lower_ptr.count("b")).to eq(1) }

    context "when match starts before pointer" do
      specify { expect(lower_ptr.drop(3).count("c")).to eq(0) }
    end

    context "when match starts past pointer" do
      specify { expect(lower_ptr.take(3).count("d")).to eq(0) }
    end

    context "when match extends past pointer" do
      specify { expect(lower_ptr.take(3).count("cd")).to eq(0) }
    end

    allocation do
      a = lower_ptr
      expect{ a.count("b")  }.to allocate(String: 0)
      expect{ a.count("bc") }.to allocate(String: 0)
    end

    todo "when a match ends out of bounds"
  end

  describe "#rstrip" do
    let(:sb) { Stupidedi::Reader::Pointer.build("  abc  ") }
    let(:mb) { Stupidedi::Reader::Pointer.build("  💃🏽🕺🏻  ") }

    context "when string is empty" do
      specify { expect(sb.take(0).rstrip).to eq("") }
    end

    context "when string doesn't end with whitespace" do
      it "returns self" do
        expect(lower_ptr.rstrip).to equal(lower_ptr)
      end
    end

    context "when string ends with whitespace" do
      it "works like String#rstrip" do
        expect(sb.rstrip).to eq(sb.storage.rstrip)
        expect(mb.rstrip).to eq(mb.storage.rstrip)
      end

      allocation do
        expect{ mb.rstrip }.to allocate(String: 0, mb.class => 1)
        expect{ sb.rstrip }.to allocate(String: 0, sb.class => 1)
      end
    end
  end

  describe "#lstrip" do
    let(:sb) { Stupidedi::Reader::Pointer.build("  abc  ") }
    let(:mb) { Stupidedi::Reader::Pointer.build("  💃🏽🕺🏻  ") }

    context "when string is empty" do
      specify { expect(sb.take(0).lstrip).to eq("") }
    end

    context "when string doesn't begin with whitespace" do
      it "returns self" do
        expect(lower_ptr.lstrip).to equal(lower_ptr)
      end
    end

    context "when string ends with whitespace" do
      specify do
        expect(sb.lstrip).to eq(sb.storage.lstrip)
        expect(mb.lstrip).to eq(mb.storage.lstrip)
      end

      allocation do
        expect{ sb.lstrip }.to allocate(String: 0, sb.class => 1)
        expect{ mb.lstrip }.to allocate(String: 0, mb.class => 1)
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
