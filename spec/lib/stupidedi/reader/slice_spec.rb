# frozen_string_literal: false

describe Stupidedi::Reader::Slice do
  using Stupidedi::Refinements

  def slice(string, frozen: nil)
    frozen = [true, false].sample if frozen.nil?
    string.freeze       if frozen and not string.frozen?
    string = string.dup if not frozen and string.frozen?
    Stupidedi::Reader::Slice.build(string)
  end


  def slice_(*args)
    Stupidedi::Reader::Slice.new(args)
  end

  def prefix(slice)
    slice.storage[0, slice.offset]
  end

  def suffix(slice)
    slice.storage[slice.offset + slice.length..-1]
  end

  let(:three) { slice([5,0,1]) }
  let(:empty) { slice([])      }

  describe ".build" do
    context "when value is a String" do
      specify { expect(slice("111")).to be_a(Stupidedi::Reader::Slice) }

      allocation do
        storage = "111"
        expect{ slice(storage, frozen: true) }.to \
          allocate(Stupidedi::Reader::Substring => 1, Hash => 2)
      end if RUBY_VERSION < "2.2"

      allocation do
        storage = "111"
        expect{ slice(storage, frozen: true) }.to allocate(Stupidedi::Reader::Substring => 1)
      end if RUBY_VERSION >= "2.2"
    end

    context "when value is an Array" do
      specify { expect(slice([5,6])).to be_a(Stupidedi::Reader::Slice) }

      allocation do
        storage = [1,2]
        expect{ slice(storage, frozen: true) }.to \
          allocate(Stupidedi::Reader::Slice => 1, Hash => 2)
      end if RUBY_VERSION < "2.2"

      allocation do
        storage = [1,2]
        expect{ slice(storage, frozen: true) }.to allocate(Stupidedi::Reader::Slice => 1)
      end if RUBY_VERSION >= "2.2"
    end

    context "when value is a Slice" do
      specify do
        p = slice("xyz")
        expect(slice(p)).to equal(p)

        q = slice([5,6])
        expect(slice(q)).to equal(q)
      end
    end

    todo "when value is a compatible type"

    todo "when value is an incompatible type"

    context "when offset is negative" do
      specify { expect{ slice_("xxx", -1, 0) }.to raise_error(ArgumentError) }
    end

    context "when offset exceeds length" do
      specify { expect{ slice_("xxx", 4, 0) }.to raise_error(ArgumentError) }
    end

    context "when length is negative" do
      specify { expect{ slice_("xxx", 0, -1) }.to raise_error(ArgumentError) }
    end

    context "when length exceeds storage length" do
      specify { expect{ slice_("xxx", 0, 4) }.to raise_error(ArgumentError) }
    end
  end

  describe "#reify" do
    context "when storage is frozen" do
      let(:p) { slice("abcdef", frozen: true) }

      context "and storage spans entire storage" do
        allocation { p; expect{ p.send(:reify)        }.to allocate(String: 0) }
        allocation { p; expect{ p.send(:reify, false) }.to allocate(String: 0) }

        context "but always_allocate is true" do
          allocation { p; expect{ p.send(:reify, true) }.to allocate(String: 1) }
        end
      end

      context "and storage does not span entire storage" do
        allocate { p = p.drop(1); expect{ p.send(:reify) }.to allocate(String: 1) }
        allocate { p = p.take(1); expect{ p.send(:reify) }.to allocate(String: 1) }
      end
    end

    context "when storage is not frozen" do
      let(:p) { slice("abcdef", frozen: false) }

      context "and storage spans entire storage" do
        allocation { p; expect{ p.send(:reify)        }.to allocate(String: 1) }
        allocation { p; expect{ p.send(:reify, false) }.to allocate(String: 1) }

        context "but always_allocate is true" do
          allocation { p; expect{ p.send(:reify, true) }.to allocate(String: 1) }
        end
      end

      context "and storage does not span entire storage" do
        allocate { p = p.drop(1); expect{ p.send(:reify) }.to allocate(String: 1) }
        allocate { p = p.take(1); expect{ p.send(:reify) }.to allocate(String: 1) }
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
    specify { expect(three).to be_present }
    specify { expect(empty).to_not be_present }
  end

  describe "#==" do
    context "when compared to self" do
      specify { p = slice("xxx"); expect(p).to eq(p) }
    end

    context "when storage is separate" do
      context "and substring is equal" do
        specify { expect(slice("xxx")).to eq(slice("xxx")) }
        specify { expect(slice("xxx")).to eq(slice("   xxx").drop(3)) }
        specify { expect(slice("xxx")).to eq(slice("xxx    ").take(3)) }
        specify { expect(slice("xxx")).to eq(slice("   xxx    ").drop(3).take(3)) }
      end

      context "and substring is not equal" do
        specify { expect(slice("ooo")).to_not eq(slice("xxx")) }
        specify { expect(slice("ooo")).to_not eq(slice("    xxx").drop(3)) }
        specify { expect(slice("ooo")).to_not eq(slice("xxx    ").take(3)) }
        specify { expect(slice("ooo")).to_not eq(slice("   xxx    ").drop(3).take(3)) }
      end
    end

    context "when storage is shared" do
      context "and substring is equal" do
        let(:p) { slice("xxxoooxxx") }
        specify { expect(p.take(3)).to eq(p.take(3)) }
        specify { expect(p.take(3)).to eq(p.drop(6)) }
        specify { expect(p.take(3)).to eq(p.drop(6)) }
      end

      context "and substring is not equal" do
        let(:p) { slice("oooxxxooo") }
        specify { expect(p.take(3)).to eq(p.take(3)) }
        specify { expect(p.take(3)).to eq(p.drop(6)) }
        specify { expect(p.take(3)).to eq(p.drop(6)) }
      end
    end

    allocation do
      ooo = slice("ooo")
      xxx = slice("xxx")

      expect{ ooo == xxx }.to allocate(String: 0)
      expect{ ooo == ooo }.to allocate(String: 0)
    end
  end

  describe "#+" do
    context "when argument is a non-Slice value" do
      context "and slice suffix starts with argument" do
        specify do
          a = slice("abcdefghi")
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
          a = slice("abcdefghi")
          b = a.drop(3).take(3)
          c = "gh"
          expect(suffix(b)).to start_with(c)
          expect{ b + c }.to allocate(b.class => 1)
        end
      end

      context "and argument is slice suffix plus more" do
        specify do
          a = slice("abcdefghi")
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
          expect(d).to be_a(c.class)
        end

        allocation do
          a = slice("abcdefghi")
          b = a.drop(3).take(3)
          c = "ghijkl"
          expect(c).to start_with(suffix(b))
          expect(c).to_not eq(suffix(b))
          expect{ b + c }.to allocate(c.class => 1)
        end
      end

      context "and argument is not slice suffix" do
        specify do
          a = slice("abcdefghi")
          b = a.take(6)
          c = "xxx"

          # Precondition
          expect(a.storage).to be_frozen

          d = b + c
          expect(a).to eq("abcdefghi")
          expect(b).to eq("abcdef")
          expect(c).to eq("xxx")
          expect(d).to eq("abcdefxxx")
          expect(d).to be_a(c.class)
        end

        allocation do
          a = slice("abcdefghi")
          b = a.take(6)
          c = "xxx"
          expect(a.storage).to be_frozen
          expect{ b + c }.to allocate(c.class => 1)
        end
      end
    end

    context "when argument is a Substring" do
      context "and slice suffix starts with argument" do
        specify do
          a = slice("abcdefghi")
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
          a = slice("abcdefghi")
          b = a.drop(3).take(3)
          c = slice("gh")
          expect(suffix(b)).to start_with(c)
          expect{ b + c }.to allocate(b.class => 1)
        end
      end

      context "and argument is slice suffix plus more" do
        specify do
          a = slice("abcdefghi")
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
          a = slice("abcdefghi")
          b = a.drop(3).take(3)
          c = slice("ghijkl")
          expect(c).to start_with(suffix(b))
          expect(c).to_not eq(suffix(b))
          expect{ b + c }.to allocate(String: 1)
        end
      end

      context "and argument is not slice suffix" do
        specify do
          a = slice("abcdefghi")
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
          a = slice("abcdefghi")
          b = a.take(6)
          c = slice("xxx", frozen: true)
          expect(suffix(b)).to_not start_with(c)
          expect{ b + c }.to allocate(String: 1 + (c.storage.frozen? && 0 || 1))
        end

        allocation do
          a = slice("abcdefghi")
          b = a.take(6)
          c = slice("xxx", frozen: false)
          expect(suffix(b)).to_not start_with(c)
          expect{ b + c }.to allocate(String: 1 + (c.storage.frozen? && 0 || 1))
        end
      end
    end
  end

  todo "#head"
  todo "#first"
  todo "#last"
  todo "#defined_at?"
  todo "#at"
  todo "#tail"
  todo "#[]"
  todo "#drop"
  todo "take"
  todo "#drop_take"
  todo "#split_at"
  todo "#drop!"
  todo "#take!"
  todo "#inspect"
  todo ".build"
end
