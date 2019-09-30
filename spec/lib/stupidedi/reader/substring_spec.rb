describe Stupidedi::Reader::Substring do
  using Stupidedi::HashOps
  using Stupidedi::Refinements

  def slice(string, frozen: nil)
    frozen = false if frozen.nil?
    #rozen = [true, false].sample if frozen.nil?
    string.freeze       if frozen and not string.frozen?
    string = string.dup if not frozen and string.frozen?
    Stupidedi::Reader::Slice.build(string)
  end

  def prefix(slice)
    slice.storage[0, slice.offset]
  end

  def suffix(slice)
    slice.storage[slice.offset + slice.length..-1]
  end

  # Yields all valid offset and length pairs for a string of the given length
  def substrings(length)
    return enum_for(:substrings, length) unless block_given?
    length.times{|n| (length - n).times{|o| yield o, n } unless n.zero? }
  end

  let(:lower) { "abcdefghi" }
  let(:upper) { "ABCDEFGHI" }

  describe "#to_s" do
    it "is called implicitly" do
      p = slice(lower)
      expect("#{p}").to eq(lower)
    end

    context "when storage is shared" do
      specify do
        p = slice(lower)
        q = p.drop(10)
        expect(q.to_s).to_not be_frozen
      end

      allocation do
        p = slice(lower)
        q = p.drop(10)
        expect{ q.to_s }.to allocate(String: 1)
      end
    end

    context "when storage is not shared" do
      specify do
        p = slice(lower, frozen: false)
        expect(p.to_s).to_not be_frozen
      end

      allocation do
        p = slice(lower, frozen: false)
        expect{ p.to_s }.to allocate(String: 1)
      end
    end
  end

  describe "#to_str" do
    it "is called implicitly" do
      expect(lower).to eq(slice(lower))
      expect(slice(lower)).to eq(lower)
    end

    context "when storage is shared" do
      specify do
        p = slice(lower)
        q = p.drop(10)
        expect(q.to_str).to_not be_frozen
      end

      allocation do
        p = slice(lower)
        q = p.drop(10)
        expect{ q.to_str }.to allocate(String: 1)
      end
    end

    context "when storage is not shared" do
      specify do
        p = slice(lower, frozen: false)
        expect(p.to_str).to_not be_frozen
      end

      allocation do
        p = slice(lower, frozen: false)
        expect{ p.to_str }.to allocate(String: 1)
      end
    end
  end

  describe "#==" do
    allocation "is reflexive" do
      a = slice(lower)
      b = slice(upper)

      expect(a).to eq(a)
      expect(a).to_not eq(b)
    end

    allocation "is reflexive" do
      a = slice(lower)
      b = slice(upper)
      expect{ a == a }.to allocate(String: 0)
      expect{ a == b }.to allocate(String: 0)
    end

    context "when slice is a String" do
      specify do
        a, a_ = slice(lower), lower
        _, b_ = slice(upper), upper

        expect(a).to     eq(a_)
        expect(a).to_not eq(b_)
      end

      allocation do
        a, a_ = slice(lower), lower
        _, b_ = slice(upper), upper
        expect{ a == a_ }.to allocate(String: 0)
        expect{ a == b_ }.to allocate(String: 0)
      end
    end

    context "when two slices are identical" do
      specify do
        a  = slice(lower).drop(10).take(10)
        a_ = slice(lower).drop(10).take(10)

        expect(a).to eq(a_)
      end

      allocation do
        a  = slice(lower).drop(10).take(10)
        a_ = slice(lower).drop(10).take(10)
        expect{ a == a_ }.to allocate(String: 0)
      end
    end

    context "when slices are not identical" do
      specify do
        p  = slice("abcdef abcdef")
        a  = p.take(3)
        a_ = p.drop(7).take(3)
        b_ = p.drop(2).take(3)

        expect(a).to     eq(a_)
        expect(a).to_not eq(b_)
      end

      allocation do
        p  = slice("abcdef abcdef")
        a  = p.take(3)
        a_ = p.drop(1).take(3)
        b_ = p.drop(2).take(3)
        expect{ a == a_ }.to allocate(String: 0)
        expect{ a == b_ }.to allocate(String: 0)
      end
    end
  end

  describe "#<<" do
    context "when argument is a String" do
      context "and encodings don't match" do
        todo "raises an exception"
      end

      context "and slice suffix starts with argument" do
        specify do
          a = slice(lower)
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
          a   = slice(lower)
          b   = a.drop(3).take(3)
          gh  = "gh"
          expect(suffix(b)).to start_with(gh)
          expect{ b << gh }.to allocate(String: 0)
        end
      end

      context "and argument is slice suffix plus more" do
        specify do
          a = slice(lower)
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
          a = slice(lower)
          b = a.drop(3).take(3)
          c = "ghijkl"
          expect(c).to start_with(suffix(b))
          expect(c).to_not eq(suffix(b))
          expect{ b << c }.to allocate(String: 1)
        end
      end

      context "and argument is not slice suffix" do
        context "when slice isn't frozen" do
          specify do
            a = slice(lower, frozen: false)
            b = "xxx"

            # Precondition
            expect(a.storage).to_not be_frozen

            a << b
            expect(a).to eq("abcdefghixxx")
            expect(b).to eq("xxx")
          end

          allocation do
            a = slice(lower, frozen: false)
            b = "xxx"
            expect(a.storage).to_not be_frozen
            expect{ a << b }.to allocate(String: 0)
          end
        end

        context "when slice is frozen" do
          specify do
            a = slice(lower, frozen: true)
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
            a = slice(lower, frozen: true)
            b = a.take(6)
            c = "xxx"
            expect(a.storage).to be_frozen
            expect{ b << c }.to allocate(String: 1)
          end
        end
      end
    end

    context "when argument is a Slice" do
      context "and encodings don't match" do
        todo "raises an exception"
      end

      context "and slice suffix starts with argument" do
        specify do
          a = slice(lower)
          b = a.drop(3).take(3)
          c = slice("gh")

          # Precondition
          expect(suffix(b)).to start_with(c)

          b << c
          expect(a).to eq("abcdefghi")
          expect(b).to eq("defgh")
          expect(c).to eq("gh")
        end

        allocation do
          a = slice(lower)
          b = a.drop(3).take(3)
          c = slice("gh")
          expect(suffix(b)).to start_with(c)
          expect{ b << c }.to allocate(String: 0)
        end
      end

      context "and argument is slice suffix plus more" do
        specify do
          a = slice(lower)
          b = a.drop(3).take(3)
          c = slice("ghijkl")

          # Precondition
          expect(c).to start_with(suffix(b))
          expect(c).to_not eq(suffix(b))

          b << c
          expect(a).to eq("abcdefghi")
          expect(b).to eq("defghijkl")
          expect(c).to eq("ghijkl")
        end

        allocation do
          a = slice(lower)
          b = a.drop(3).take(3)
          c = slice("ghijkl")
          expect(c).to start_with(suffix(b))
          expect(c).to_not eq(suffix(b))
          expect{ b << c }.to allocate(String: 1)
        end
      end

      context "and argument is not slice suffix" do
        context "when slice isn't frozen" do
          specify do
            a = slice(lower, frozen: false)
            b = slice("xxx".freeze)

            # Precondition
            expect(a.storage).to_not be_frozen

            a << b
            #expect(a).to eq("abcdefghixxx")
            #expect(b).to eq("xxx")
          end

          allocation do
            a = slice(lower, frozen: false)
            b = slice("xxx", frozen: true)
            expect(a.storage).to_not be_frozen
            expect{ a << b }.to allocate(String: 0)
          end
        end

        context "when slice is frozen" do
          specify do
            a = slice(lower)
            b = a.take(6)
            c = slice("xxx")

            # Precondition
            expect(b.storage).to be_frozen

            b << c
            expect(a).to eq("abcdefghi")
            expect(b).to eq("abcdefxxx")
            expect(c).to eq("xxx")
          end

          allocation do
            a = slice(lower)
            b = a.take(6)
            c = slice("xxx", frozen: true)
            expect(b.storage).to be_frozen
            expect{ b << c }.to allocate(String: 1)
          end
        end
      end
    end

    context "when argument is something else" do
      specify { expect{ slice(lower) << :no }.to raise_error(TypeError) }
    end
  end

  describe "#+" do
    let(:a) { slice("abcdefghi".dup) }

    context "when argument is a String" do
      context "and encodings don't match" do
        todo "raises an exception"
      end

      context "and slice suffix starts with argument" do
        specify do
          a = slice(lower)
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
          a = slice(lower)
          b = a.drop(3).take(3)
          c = "gh"
          expect(suffix(b)).to start_with(c)
          expect{ b + c }.to allocate(String: 0, a.class => 1)
        end
      end

      context "and argument is slice suffix plus more" do
        specify do
          a = slice(lower)
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
          a = slice(lower)
          b = a.drop(3).take(3)
          c = "ghijkl"
          expect(c).to start_with(suffix(b))
          expect(c).to_not eq(suffix(b))
          expect{ b + c }.to allocate(String: 1)
        end
      end

      context "and argument is not slice suffix" do
        specify do
          a = slice(lower)
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
          a = slice(lower)
          b = a.take(6)
          c = "xxx"
          expect(a.storage).to be_frozen
          expect{ b + c }.to allocate(String: 1)
        end
      end
    end

    context "when argument is a Substring" do
      context "and encodings don't match" do
        todo "raises an exception"
      end

      context "and slice suffix starts with argument" do
        specify do
          a = slice(lower)
          b = a.drop(3).take(3)
          c = slice("gh")

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
          a = slice(lower)
          b = a.drop(3).take(3)
          c = slice("gh")
          expect(suffix(b)).to start_with(c)
          expect{ b + c }.to allocate(String: 0, a.class => 1)
        end
      end

      context "and argument is slice suffix plus more" do
        specify do
          a = slice(lower)
          b = a.drop(3).take(3)
          c = slice("ghijkl")

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
          a = slice(lower)
          b = a.drop(3).take(3)
          c = slice("ghijkl")
          expect(c).to start_with(suffix(b))
          expect(c).to_not eq(suffix(b))
          expect{ b + c }.to allocate(String: 1)
        end
      end

      context "and argument is not slice suffix" do
        specify do
          a = slice(lower)
          b = a.take(6)
          c = slice("xxx")

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
          a = slice(lower)
          b = a.take(6)
          c = slice("xxx", frozen: true)
          expect(suffix(b)).to_not start_with(c)
          expect{ b + c }.to allocate(String: 1)
        end
      end
    end
  end

  allocation do
    skip "Only needed for debugging other failed specs"

    abc = "abc"
    dot = /./
    zee = /z/

    # NOTE: We reset $~ before doing any kind of Regexp operation because it
    # makes object allocation predictable. Otherwise things like this happen
    # (observed with Ruby 2.6):
    #
    #   p = /a/
    #   s = "x"
    #
    #   s =~ p          # String: 1, MatchData: 1 <-- the MatchData is $~
    #   s =~ p          # String: 1               <-- probably $~ is reused
    #
    #   s = "b"; s =~ p # no allocation           <-- this sets $~ to nil
    #   s = "a"; s =~ p # String: 1, MatchData: 1 <-- no $~ here to reuse

    zee =~ abc
    dot =~ abc

    unless RUBY_VERSION < "2.4"
      # These tests can be performed in any order and the results won't change
      expect{ $~ = nil; abc =~ zee }.to allocate(String: 0, MatchData: 0)
      expect{ $~ = nil; zee =~ abc }.to allocate(String: 0, MatchData: 0)
      expect{ $~ = nil; abc =~ dot }.to allocate(String: 1, MatchData: 1)
      expect{ $~ = nil; dot =~ abc }.to allocate(String: 1, MatchData: 1)

      expect{ $~ = nil; abc.match(zee) }.to allocate(String: 0, MatchData: 0)
      expect{ $~ = nil; zee.match(abc) }.to allocate(String: 0, MatchData: 0)
      expect{ $~ = nil; abc.match(dot) }.to allocate(String: 1, MatchData: 1)
      expect{ $~ = nil; dot.match(abc) }.to allocate(String: 1, MatchData: 1)

      expect{ $~ = nil; abc.match?(zee) }.to allocate(String: 0, MatchData: 0)
      expect{ $~ = nil; abc.match?(dot) }.to allocate(String: 0, MatchData: 0)
      expect{ $~ = nil; zee.match?(abc) }.to allocate(String: 0, MatchData: 0)
      expect{ $~ = nil; dot.match?(abc) }.to allocate(String: 0, MatchData: 0)
    else
      # For some reason older versions of Ruby have even further unprectible
      # behavior. The same statements above will produce different results if
      # they are executed in a different order. That means one assertion will
      # affect the outcome of another... I give up at this point.
    end
  end

  # Returns number of objects allocated per class by Slice#reify
  def alloc_reify(slice)
    slice.storage.frozen? \
      && slice.offset.zero? \
      && slice.length == slice.storage.length \
      && {String: 0} || {String: 1}
  end

  # Returns number of objects allocated per class by String#match
  def alloc_match(success)
    if success
      @alloc_match_t ||= begin
        p = /a/; s = "a"; p.inspect
        r = MemProf.report { $~ = nil; s.match(p) }
        Hash[r.allocations_by_class.map{|v| [v[:group].name.to_sym, v[:count]] }]
      end
    else
      @alloc_match_f ||= begin
        p = /x/; s = "a"; p.inspect
        r = MemProf.report { $~ = nil; s.match(p) }
        Hash[r.allocations_by_class.map{|v| [v[:group].name.to_sym, v[:count]] }]
      end
    end
  end

  # Returns number of objects allocated per class by String#match?
  def alloc_match?(success)
    if success
      @alloc_matchp_t ||= begin
        p = /a/; s = "a"; p.inspect
        r = MemProf.report { $~ = nil; s.match?(p) }
        Hash[r.allocations_by_class.map{|v| [v[:group].name.to_sym, v[:count]] }]
      end
    else
      @alloc_matchp_f ||= begin
        p = /x/; s = "a"; p.inspect
        r = MemProf.report { $~ = nil; s.match?(p) }
        Hash[r.allocations_by_class.map{|v| [v[:group].name.to_sym, v[:count]] }]
      end
    end
  end

  describe "=~" do
    shared_examples "=~ memory allocation" do
      let(:anchored) { anchor_a || anchor_z }

      it "works like String#=~" do
        str = lower
        ptr = slice(str)
        all = substrings(lower.length).map{|idx, len| [ptr[idx,len], str[idx,len]]}
        expect(all).to(smallcheck{|p,s| (p =~ regexp_o) == (s =~ regexp_o) })
        expect(all).to(smallcheck{|p,s| (p =~ regexp_x) == (s =~ regexp_x) })
      end

      context "and slice looks like [*************]" do
        specify do
          a = slice(lower)

          # Preconditions
          expect(a.length).to         eq(a.storage.length)
          expect(a.storage.length).to be < 1024

          expect(a).to_not match(regexp_x)
          expect(a).to     match(regexp_o)
        end

        allocation do
          skip "requires ruby >= 2.4" unless RUBY_VERSION >= "2.4"
          a = slice(lower)

          # Preconditions
          expect(a.length).to         eq(a.storage.length)
          expect(a).to                match(regexp_o)
          expect(a).to_not            match(regexp_x)
          expect(a.storage.length).to be < 1024

          expect{ $~ = nil; a =~ regexp_x }.to allocate({String: 0, Array: 0} + alloc_match(false))
          expect{ $~ = nil; a =~ regexp_o }.to allocate({String: 0, Array: 1} + alloc_match(true))
        end
      end

      context "and slice looks like [*****]--------" do
        specify do
          a = slice(lower).take(6)

          # Preconditions
          expect(a.offset).to         eq(0)
          expect(a.length).to         be < a.storage.length
          expect(a.storage.length).to be < 1024

          expect(a).to_not match(regexp_x)
          expect(a).to     match(regexp_o)
        end

        allocation do
          skip "requires ruby >= 2.4" unless RUBY_VERSION >= "2.4"
          a = slice(lower).take(6)

          # Preconditions
          expect(a.offset).to         eq(0)
          expect(a.length).to         be < a.storage.length
          expect(a).to                match(regexp_o)
          expect(a).to_not            match(regexp_x)
          expect(a.storage.length).to be < 1024

          if reify_oox
            expect { $~ = nil; a =~ regexp_x }.to allocate(
              {String: 1}         + # pattern.inspect
              alloc_match?(true)  + # ANCHORS_Z.match?
              {Array: 1}          + # [..., 0]
              alloc_reify(a)      + # reify
              alloc_match(false))   # reify.match

            expect { $~ = nil; a =~ regexp_o }.to allocate(
              {String: 1}         + # pattern.inspect
              alloc_match?(true)  + # ANCHORS_Z.match?
              {Array: 1}          + # [..., 0]
              alloc_reify(a)      + # reify
              alloc_match(true))    # reify.match
          else
            # We know ANCHORS_A won't be tested, because a.offset == 0 and
            # we know ANCHORS_Z will be tested but fail (reify_oox is false)

            expect { $~ = nil; a =~ regexp_x }.to allocate(
              {String: 1}         + # pattern.inspect
              alloc_match?(false) + # ANCHORS_Z.match?
              alloc_match(false))   # @storage.match

            expect { $~ = nil; a =~ regexp_o }.to allocate(
              {String: 1}                      + # pattern.inspect
              alloc_match?(anchor_a && 1 || 0) + # ANCHORS_Z.match?
              alloc_match(true)                + # @storage.match
              {Array: 1}                       - # [m, -@offset]
              {String: 1})                       # TODO: no clue
          end
        end
      end

      context "and slice looks like ----[*****]----" do
        specify do
          a = slice(lower).drop(3).take(3)

          # Preconditions
          expect(a.offset).to_not         eq(0)
          expect(a.offset + a.length).to  be < a.storage.length
          expect(a.storage.length).to     be < 1024

          expect(a).to_not match(regexp_x)
          expect(a).to     match(regexp_o)
        end

        allocation do
          skip "requires ruby >= 2.4" unless RUBY_VERSION >= "2.4"

          a = slice(lower).drop(3).take(3)
          expect(a.offset).to_not         eq(0)
          expect(a.offset + a.length).to  be < a.storage.length
          expect(a).to                    match(regexp_o)
          expect(a).to_not                match(regexp_x)
          expect(a.storage.length).to     be < 1024

          if reify_xox
            # Either ANCHORS_A matched or it failed and ANCHORS_Z matched
            expect { $~ = nil; a =~ regexp_x }.to allocate(
              {String: 1}                                + # pattern.inspect
              (anchor_a &&
               alloc_match?(true)                       || # ANCHORS_A.match?
               alloc_match?(false) + alloc_match?(true)) + # ANCHORS_Z.match?
               alloc_reify(a)                            + # reify
               alloc_match(false)                        + # reify.match
               {Array: 1})                                 # [reify.match, nil]

            expect { $~ = nil; a =~ regexp_o }.to allocate(
              {String: 1}                                + # pattern.inspect
              (anchor_a &&
               alloc_match?(true)                       || # ANCHORS_A.match?
               alloc_match?(false) + alloc_match?(true)) + # ANCHORS_Z.match?
               alloc_reify(a)                            + # reify
               alloc_match(true)                         + # reify.match
               {Array: 1})                                 # [reify.match, nil]
          else
            # We know ANCHORS_A and ANCHORS_Z failed to match
            expect { $~ = nil; a =~ regexp_x }.to allocate(
              {String: 1}         + # pattern.inspect
              alloc_match?(false) + # ANCHORS_A.match?
              alloc_match?(false) + # ANCHORS_Z.match?
              alloc_match(false))   # @storage.match

            expect { $~ = nil; a =~ regexp_o }.to allocate(
              {String: 1}         + # pattern.inspect
              alloc_match?(false) + # ANCHORS_A.match?
              alloc_match?(false) + # ANCHORS_Z.match?
              alloc_match(true)   + # @storage.match
              {Array: 1}          - # [m, -@offset]
              {String: 1})          # TODO: no clue
          end
        end
      end

      context "and slice looks like --------[*****]" do
        specify do
          a = slice(lower).drop(3)

          # Preconditions
          expect(a.offset + a.length).to  eq(a.storage.length)
          expect(a.offset).to_not         eq(0)
          expect(a.storage.length).to     be < 1024

          expect(a).to_not match(regexp_x)
          expect(a).to     match(regexp_o)
        end

        allocation do
          skip "requires ruby >= 2.4" unless RUBY_VERSION >= "2.4"

          a = slice(lower).drop(3)

          # Preconditions
          expect(a.offset + a.length).to  eq(a.storage.length)
          expect(a.offset).to_not         eq(0)
          expect(a).to                    match(regexp_o)
          expect(a).to_not                match(regexp_x)
          expect(a.storage.length).to     be < 1024

          if reify_xoo
            expect { $~ = nil; a =~ regexp_x }.to allocate(
              {String: 1}         + # pattern.inspect
              alloc_match?(true)  + # ANCHORS_A.match?
              {Array: 1}          + # [..., 0]
              alloc_reify(a)      + # reify
              alloc_match(false))   # reify.match

            expect { $~ = nil; a =~ regexp_o }.to allocate(
              {String: 1}         + # pattern.inspect
              alloc_match?(true)  + # ANCHORS_A.match?
              {Array: 1}          + # [..., 0]
              alloc_reify(a)      + # reify
              alloc_match(true))    # reify.match
          else
            # We know ANCHORS_A will be tested and fail (reify_xoo is false),
            # and ANCHORS_Z won't be tested due to where the slice ends.

            expect { $~ = nil; a =~ regexp_x }.to allocate(
              {String: 1}         + # pattern.inspect
              alloc_match?(false) + # ANCHORS_A.match?
              alloc_match(false))   # @storage.match

            expect { $~ = nil; a =~ regexp_o }.to allocate(
              {String: 1}         + # pattern.inspect
              alloc_match?(false) + # ANCHORS_Z.match?
              alloc_match(true)   + # @storage.match
              {Array: 1}          - # [m, -@offset]
              {String: 1})          # TODO: no clue
          end
        end
      end
    end

    context "when regexp doesn't have an anchor" do
      let(:regexp_o) { /.../ }
      let(:regexp_x) { /xxx/ }

      let(:anchor_a)  { false }
      let(:anchor_z)  { false }
      let(:reify_xoo) { false }
      let(:reify_oox) { false }
      let(:reify_xox) { false }

      include_examples "=~ memory allocation"
    end

    context "when regexp has an anchor /^.../" do
      let(:regexp_o) { /^.../ }
      let(:regexp_x) { /^xxx/ }

      let(:anchor_a)  { true  }
      let(:anchor_z)  { false }
      let(:reify_oox) { false }
      let(:reify_xox) { true  }
      let(:reify_xoo) { true  }

      include_examples "=~ memory allocation"
    end

    context "when regexp has an anchor /...$/" do
      let(:regexp_o) { /...$/ }
      let(:regexp_x) { /xxx$/ }

      let(:anchor_a)  { false }
      let(:anchor_z)  { true  }
      let(:reify_oox) { true  }
      let(:reify_xox) { true  }
      let(:reify_xoo) { false }

      include_examples "=~ memory allocation"
    end

    context "when regexp has [\\^]" do
      let(:regexp_o) { /[\^a-z]/ }
      let(:regexp_x) { /[\^0-9]/ }

      let(:anchor_a)  { false }
      let(:anchor_z)  { false }
      let(:reify_oox) { false }
      let(:reify_xox) { false }
      let(:reify_xoo) { false }

      include_examples "=~ memory allocation"
    end

    context "when regexp has [\\$]" do
      let(:regexp_o) { /[a-z\$]/ }
      let(:regexp_x) { /[\$0-9]/ }

      let(:anchor_a)  { false }
      let(:anchor_z)  { false }
      let(:reify_oox) { false }
      let(:reify_xox) { false }
      let(:reify_xoo) { false }

      include_examples "=~ memory allocation"
    end

    context "when regexp match ends out of bounds" do
      let(:regexp_o) { /..+/ }
      let(:regexp_x) { /xxx/ }

      it "works like String#=~" do
        str = lower
        ptr = slice(str)
        all = substrings(lower.length).map{|idx, len| [ptr[idx,len], str[idx,len]]}
        expect(all).to(smallcheck{|p,s| (p =~ regexp_o) == (s =~ regexp_o) })
        expect(all).to(smallcheck{|p,s| (p =~ regexp_x) == (s =~ regexp_x) })
      end

      allocation do
        a = slice(lower).drop(3).take(3)

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

    todo "when there is a long string past the end of the slice"
  end

  describe "#blank?" do
    it "is true on empty strings" do
      expect(slice(lower).drop(10).take(0)).to be_blank
      expect(slice(lower).drop(lower.length)).to be_blank
      expect(slice("")).to be_blank
    end

    it "is true on whitespace-only strings" do
      expect(slice(" \r\n\t\v\f")).to be_blank
    end

    it "is false on strings with non-whitespace" do
      expect(slice(lower)).to_not be_blank
      expect(slice(" \r\n\t\v\f x")).to_not be_blank
    end
  end

  describe "#match?" do
    shared_examples "#match?(pattern)" do
      context "and offset not given" do
        it "works like String#match?" do
          str = lower
          ptr = slice(str)
          all = substrings(lower.length).map{|idx, len| [ptr[idx,len], str[idx,len]]}
          expect(all).to(smallcheck{|p,s| p.match?(regexp_o) == s.match?(regexp_o) })
          expect(all).to(smallcheck{|p,s| p.match?(regexp_x) == s.match?(regexp_x) })
        end
      end
    end

    shared_examples "#match?(pattern, offset)" do
      context "and offset is given" do
        it "works like String#match?" do
          str = lower
          ptr = slice(str)
          all = substrings(lower.length).flat_map do |idx, len|
            (len + 1).times.map do |offset|
              [ptr[idx,len], str[idx,len], offset]
            end
          end
          expect(all).to(smallcheck{|p,s,n| p.match?(regexp_o, n) == s.match?(regexp_o, n) })
          expect(all).to(smallcheck{|p,s,n| p.match?(regexp_x, n) == s.match?(regexp_x, n) })
        end
      end
    end

    context "when regexp has an anchor /^.../" do
      let(:regexp_o) { /^.../ }
      let(:regexp_x) { /^xxx/ }
      include_examples "#match?(pattern)"

      # NOTE: In this circumstance, `#match?pattern, offset)` is not tested for
      # equivalence with `String#match?(pattern, offset)`.
      #
      # Substring#match?(pattern, offset) does not work like the String
      # implementation when the pattern has an ^ or \A anchor. String#match?
      # interprets ^ to mean the beginning of @storage (even when the offset
      # argument is not 0).
      #
      # Substring#match? works as if ^ is at the given offset, so we can check
      # if a pattern would match as if we had called `#reify` on the substring.
      # Therefore we do not have `include_examples "#match?(pattern, offset)"`.
    end

    context "when regexp has an anchor /...$/" do
      let(:regexp_o) { /...$/ }
      let(:regexp_x) { /xxx$/ }
      include_examples "#match?(pattern)"

      # NOTE: In this circumstance, `#match?pattern, offset)` is not tested for
      # equivalence with `String#match?(pattern, offset)`.
      #
      # Substring#match?(pattern, offset) does not work like the String
      # implementation when the pattern has an $ or \Z anchor. String#match?
      # interprets $ to mean the end of @storage
      #
      # Substring#match? works as if $ is at the end of the substring, so we can
      # check if a pattern would match as if we had called `#reify` on the
      # substring.
    end

    context "when regexp doesn't have an anchor" do
      let(:regexp_o) { /.../ }
      let(:regexp_x) { /xxx/ }
      include_examples "#match?(pattern)"
      include_examples "#match?(pattern, offset)"
    end

    context "when regexp has [\\^]" do
      let(:regexp_o) { /[\^a-z]/ }
      let(:regexp_x) { /[\^0-9]/ }
      include_examples "#match?(pattern)"
      include_examples "#match?(pattern, offset)"
    end

    context "when regexp has [\\$]" do
      let(:regexp_o) { /[a-z\$]/ }
      let(:regexp_x) { /[\$0-9]/ }
      include_examples "#match?(pattern)"
      include_examples "#match?(pattern, offset)"
    end

    context "when regexp match ends out of bounds" do
      let(:regexp_o) { /..+/ }
      let(:regexp_x) { /xxx/ }
      include_examples "#match?(pattern)"
      include_examples "#match?(pattern, offset)"
    end
  end

  describe "#start_with?" do
    context "when argument is a String" do
      specify { expect(slice(lower)).to         be_start_with("abc") }
      specify { expect(slice(lower).drop(3)).to be_start_with("def") }

      specify { expect(slice(lower).drop(3)).to_not be_start_with("abc") }
      specify { expect(slice(lower).drop(3)).to_not be_start_with("ghi") }
    end

    context "when argument is a Substring" do
      specify { expect(slice(lower)).to be_start_with(slice(lower).take(5)) }
      specify { expect(slice(lower).drop(5)).to_not be_start_with(slice(lower)) }
    end

    context "when argument is an unrelated string slice" do
      specify do
        stuvw = slice("stuvwx").drop(3)
        other = slice("vw uts").take(2)
        expect(stuvw).to be_start_with(other)
      end
    end

    context "when argument is some other type" do
      it "raises an error" do
        expect{slice(lower).start_with?(:abc)}.to raise_error(TypeError)
      end
    end
  end

  describe "#index" do
    let(:a) { slice("abcdef abcdef") }

    context "when argument is a Regexp" do
      it "returns the first match" do
        expect(a.index(/a/)).to    eq(0)
        expect(a.index(/f/)).to    eq(5)
        expect(a.index(/f/, 5)).to eq(5)
        expect(a.index(/f/, 6)).to eq(12)
      end

      it "doesn't match outside of slice bounds" do
        expect(a.take(0).index(/./)).to be_nil
        expect(a.take(5).index(/ /)).to be_nil
        expect(a.take(5).index(/e./)).to be_nil
        expect(a.drop(8).index(/a/)).to be_nil
      end
    end

    context "when argument is a String" do
      it "returns the first match" do
        expect(a.index("a")).to    eq(0)
        expect(a.index("f")).to    eq(5)
        expect(a.index("f", 5)).to eq(5)
        expect(a.index("f", 6)).to eq(12)
      end

      it "doesn't match outside of slice bounds" do
        expect(a.take(5).index(" ")).to be_nil
        expect(a.drop(8).index("a")).to be_nil
      end
    end

    context "when argument is a Substring" do
      it "returns the first match" do
        expect(a.index(slice("a"))).to    eq(0)
        expect(a.index(slice("f"))).to    eq(5)
        expect(a.index(slice("f"), 5)).to eq(5)
        expect(a.index(slice("f"), 6)).to eq(12)
      end

      it "doesn't match outside of slice bounds" do
        expect(a.take(5).index(slice(" "))).to be_nil
        expect(a.drop(8).index(slice("a"))).to be_nil
      end
    end

    context "when argument is something else" do
      specify{ expect{ a.index(:no) }.to raise_error(TypeError) }
    end
  end

  describe "#rindex" do
    let(:a) { slice("abcdef abcdef") }

    context "when argument is a Regexp" do
      it "returns the last match" do
        expect(a.rindex(/a/)).to     eq(7)
        expect(a.rindex(/f/)).to     eq(12)
        expect(a.rindex(/f/, 12)).to eq(12)
        expect(a.rindex(/f/, 11)).to eq(5)
      end

      it "doesn't match outside of slice bounds" do
        expect(a.take(5).rindex(/f/)).to be_nil
        expect(a.drop(8).rindex(/ /)).to be_nil
      end
    end

    context "when argument is a String" do
      it "returns the last match" do
        expect(a.rindex("a")).to     eq(7)
        expect(a.rindex("f")).to     eq(12)
        expect(a.rindex("f", 12)).to eq(12)
        expect(a.rindex("f", 11)).to eq(5)
      end

      it "doesn't match outside of slice bounds" do
        expect(a.take(5).rindex("f")).to be_nil
        expect(a.drop(8).rindex(" ")).to be_nil
      end
    end

    context "when argument is a Substring" do
      it "returns the last match" do
        expect(a.rindex(slice("a"))).to     eq(7)
        expect(a.rindex(slice("f"))).to     eq(12)
        expect(a.rindex(slice("f"), 12)).to eq(12)
        expect(a.rindex(slice("f"), 11)).to eq(5)
      end

      it "doesn't match outside of slice bounds" do
        expect(a.take(5).rindex(slice("f"))).to be_nil
        expect(a.drop(8).rindex(slice(" "))).to be_nil
      end
    end

    context "when argument is something else" do
      specify{ expect{ a.rindex(:no) }.to raise_error(TypeError) }
    end
  end

  describe "#count" do
    specify { expect(slice(lower).count("b")).to eq(1) }

    context "when match starts before slice" do
      specify { expect(slice(lower).drop(3).count("c")).to eq(0) }
    end

    context "when match starts past slice" do
      specify { expect(slice(lower).take(3).count("d")).to eq(0) }
    end

    context "when match extends past slice" do
      specify { expect(slice(lower).take(3).count("cd")).to eq(0) }
    end

    allocation do
      a  = slice(lower)
      b  = "b"
      bc = "bc"
      expect{ a.count(b)  }.to allocate(String: 0)
      expect{ a.count(bc) }.to allocate(String: 0)
    end

    todo "when a match ends out of bounds"
  end

  describe "#rstrip" do
    let(:sb) { slice("  abc  ") }
    let(:mb) { slice("  💃🏽🕺🏻  ") }

    context "when string is empty" do
      specify { expect(sb.take(0).rstrip).to eq("") }
    end

    context "when string doesn't end with whitespace" do
      it "returns self" do
        p = slice(lower)
        expect(p.rstrip).to equal(p)
      end
    end

    context "when string ends with whitespace" do
      it "works like String#rstrip" do
        expect(sb.rstrip).to eq(sb.storage.rstrip)
        expect(mb.rstrip).to eq(mb.storage.rstrip)
      end

      allocation do
        sb; mb # pre-allocate Substring
        expect{ mb.rstrip }.to allocate(String: 0, mb.class => 1)
        expect{ sb.rstrip }.to allocate(String: 0, sb.class => 1)
      end
    end
  end

  describe "#lstrip" do
    let(:sb) { slice("  abc  ") }
    let(:mb) { slice("  💃🏽🕺🏻  ") }

    context "when string is empty" do
      specify { expect(sb.take(0).lstrip).to eq("") }
    end

    context "when string doesn't begin with whitespace" do
      it "returns self" do
        p = slice(lower)
        expect(p.lstrip).to equal(p)
      end
    end

    context "when string ends with whitespace" do
      specify do
        expect(sb.lstrip).to eq(sb.storage.lstrip)
        expect(mb.lstrip).to eq(mb.storage.lstrip)
      end

      allocation do
        sb; mb # pre-allocate Substring
        expect{ sb.lstrip }.to allocate(String: 0, sb.class => 1)
        expect{ mb.lstrip }.to allocate(String: 0, mb.class => 1)
      end
    end
  end

  describe "#min_graphic_index" do
    context "when string begins with a graphic character" do
      specify { expect(slice(" abc ").min_graphic_index(0)).to eq(0) }
      specify { expect(slice(" abc ").min_graphic_index(1)).to eq(1) }
      specify { expect(slice("  💃🏽🕺🏻  ").min_graphic_index(0)).to eq(0) }
      specify { expect(slice("  💃🏽🕺🏻  ").min_graphic_index(1)).to eq(1) }
    end

    context "when string doesn't begin with a graphic character" do
      specify { expect(slice("\r\nabc ").min_graphic_index(0)).to eq(2) }
      specify { expect(slice("\r\nabc ").min_graphic_index(1)).to eq(2) }
      specify { expect(slice("\r\n 💃🏽🕺🏻  ").min_graphic_index(0)).to eq(2) }
      specify { expect(slice("\r\n 💃🏽🕺🏻  ").min_graphic_index(1)).to eq(2) }
    end

    context "when string doesn't contain a graphic character" do
      specify { expect(slice("").min_graphic_index(0)).to eq(0) }
      specify { expect(slice("\r\n").min_graphic_index(0)).to eq(2) }
      specify { expect(slice("abc\r\n").min_graphic_index(3)).to eq(5) }
    end
  end


  describe "#clean" do
    context "when no control characters present" do
      let(:sb) { slice("*A^B~C:D*A:B~C*D^") }
      let(:mb) { slice("  💃🏽🕺🏻  ") }

      allocation do
        sb; mb # pre-allocate Substring
        expect { sb.clean }.to allocate(String: 1)
        expect { mb.clean }.to allocate(String: 1)
      end

      specify { expect(sb.clean).to eq(sb) }
      specify { expect(mb.clean).to eq(mb) }
    end

    context "when some control characters present" do
      let(:sb) { slice("*A^B\r\nC:D*A:B\r\nC*D^") }
      let(:mb) { slice("\r\n💃🏽🕺🏻\r\n") }

      allocation do
        sb; mb # pre-allocate Substring
        expect { sb.clean }.to allocate(String: 3)
        expect { mb.clean }.to allocate(String: 1)
      end

      specify { expect(sb.clean).to eq(sb.storage.gsub(/[\r\n]/, "")) }
      specify { expect(mb.clean).to eq(mb.storage.gsub(/[\r\n]/, "")) }
    end
  end

  todo "#min_whitespace_index"
  todo "#max_whitespace_index"

  describe "#[]" do
    todo "when regexp is given"
  end
end
