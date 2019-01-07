describe "Stupidedi::Zipper" do
  describe ".build" do
    it "returns a RootCursor" do
      expect(Stupidedi::Zipper.build(Node.new("x"))).to be_root
    end
  end

  let(:root)    { Stupidedi::Zipper.build(Node.new("a")) }
  let(:leaf)    { root.append_child(Leaf.new("x"))       }
  let(:root_a)  { root.append_child(Node.new("b"))       }
  let(:root_b)  { root_a.append(Node.new("c"))           }
  let(:root_aa) { root_a.append_child(Node.new("d"))     }
  let(:root_ab) { root_aa.append(Node.new("e"))          }

  describe "#depth" do
    context "of root" do
      it "is 0" do
        expect(root.depth).to eq(0)
      end
    end

    context "of root's child" do
      it "is 1" do
        expect(root_a.depth).to eq(1)
        expect(root_b.depth).to eq(1)
        expect(root_a.up.down.depth).to eq(1)
        expect(root_b.up.down.depth).to eq(1)
      end
    end

    context "of root's grandchild" do
      it "is 2" do
        expect(root_aa.depth).to eq(2)
        expect(root_ab.depth).to eq(2)
        expect(root_aa.up.down.depth).to eq(2)
        expect(root_ab.up.down.depth).to eq(2)
      end
    end
  end

  describe "#first?" do
    context "on root" do
      it "is true" do
        expect(root).to be_first
      end
    end

    context "on an only child" do
      it "is true" do
        expect(root_a).to be_first
        expect(root_aa).to be_first

        expect(root_a.up.down).to be_first
        expect(root_aa.up.down).to be_first

        expect(root.dangle).to be_first
      end
    end

    context "on the first child" do
      it "is true" do
        expect(root_b.prev).to be_first
        expect(root_ab.prev).to be_first

        expect(root_b.up.down).to be_first
        expect(root_ab.up.down).to be_first
      end
    end

    context "on the last child" do
      it "is false" do
        expect(root_b).to_not be_first
        expect(root_ab).to_not be_first

        expect(root_b.up.down.last).to_not be_first
        expect(root_ab.up.down.last).to_not be_first
      end
    end
  end

  describe "#last?" do
    context "on root" do
      it "is true" do
        expect(root).to be_last
        expect(root_a.up).to be_last
        expect(root_aa.up.up).to be_last
      end
    end

    context "on an only child" do
      it "is true" do
        expect(root.dangle).to be_last
        expect(root_a).to be_last
        expect(root_aa).to be_last

        expect(root_a.up.down).to be_last
        expect(root_aa.up.down).to be_last
      end
    end

    context "on the first child" do
      it "is false" do
        expect(root_b.prev).to_not be_last
        expect(root_ab.prev).to_not be_last

        expect(root_b.up.down).to_not be_last
        expect(root_ab.up.down).to_not be_last
      end
    end

    context "on the last child" do
      it "is false" do
        expect(root_b).to be_last
        expect(root_ab).to be_last

        expect(root_b.up.down.last).to be_last
        expect(root_ab.up.down.last).to be_last
      end
    end
  end

  describe "#leaf?" do
    context "on root" do
      context "with no children" do
        it "is true" do
          expect(root).to be_leaf
          expect(root.dangle).to be_leaf
          expect(root_a.dangle).to be_leaf
        end
      end

      context "with children" do
        it "is false" do
          expect(root_a.up).to_not be_leaf
        end
      end
    end

    context "on child" do
      context "with no children" do
        it "is true" do
          expect(root_a).to be_leaf
          expect(root_a.up.down).to be_leaf
        end
      end

      context "with children" do
        it "is false" do
          expect(root_aa.up).to_not be_leaf
          expect(root_ab.up.up.down).to_not be_leaf
        end
      end
    end
  end

  describe "#root?" do
    context "on root" do
      it "is true" do
        expect(root).to be_root
        expect(root_a.up).to be_root
        expect(root_b.up).to be_root
      end
    end

    context "on a child" do
      it "is false" do
        expect(root_a).to_not be_root
        expect(root_b.up.down).to_not be_root
        expect(root.dangle).to_not be_root
      end
    end
  end

  describe "#child(n)" do
    context "on a leaf" do
      it "raises an exception" do
        expect(lambda { root.child(0) }).to \
          raise_error(Stupidedi::Exceptions::ZipperError)
      end
    end

    context "on a parent" do
      it "returns the nth child" do
        expect(root_a.up.child(0).node).to eq(root_a.node)
        expect(root_b.up.child(0).node).to eq(root_a.node)
        expect(root_b.up.child(1).node).to eq(root_b.node)
      end
    end

    context "when n is negative" do
      it "raises an exception" do
        expect(lambda { root_a.up.child(-1) }).to \
          raise_error(Stupidedi::Exceptions::ZipperError)
      end
    end
  end

  describe "#dangle" do
    context "on a leaf" do
      let(:dangle) { root.dangle }

      it "returns a placeholder" do
        expect(dangle).to be_first
        expect(dangle).to be_last
        expect(dangle).to be_leaf

        expect(dangle.up).to eq(root)
        expect(dangle.root).to eq(root)
        expect(dangle.depth).to eq(1)

        expect(dangle.first).to  eq(dangle)
        expect(dangle.last).to   eq(dangle)
        expect(dangle.delete).to eq(dangle)

        expect(lambda { dangle.next   }).to \
          raise_error(Stupidedi::Exceptions::ZipperError)

        expect(lambda { dangle.prev   }).to \
          raise_error(Stupidedi::Exceptions::ZipperError)

        expect(lambda { dangle.dangle }).to \
          raise_error(Stupidedi::Exceptions::ZipperError)

        expect(lambda { dangle.append_child(Node.new("w")) }).to \
          raise_error(Stupidedi::Exceptions::ZipperError)

        expect(lambda { dangle.prepend_child(Node.new("w")) }).to \
          raise_error(Stupidedi::Exceptions::ZipperError)
      end
    end

    context "on a leaf class" do
      it "raises an exception" do
        expect(lambda { leaf.dangle }).to \
          raise_error(Stupidedi::Exceptions::ZipperError)
      end
    end

    context "on a parent" do
      it "returns the first child" do
        expect(root_a.up.dangle.node).to eq(root_a.node)
      end
    end
  end

  describe "#down" do
    context "on a leaf" do
      it "raises an exception" do
        expect(lambda { root.down }).to \
          raise_exception(Stupidedi::Exceptions::ZipperError)
        expect(lambda { root_a.down }).to \
          raise_exception(Stupidedi::Exceptions::ZipperError)
        expect(lambda { root_b.down }).to \
          raise_exception(Stupidedi::Exceptions::ZipperError)
      end
    end

    context "on a parent" do
      it "returns the first child" do
        expect(root_a.up.down.node).to eq(root_a.node)
        expect(root_b.up.down.node).to eq(root_a.node)
      end
    end
  end

  describe "#descendant(n, *ns)"

  describe "#first" do
    context "on root" do
      it "returns itself" do
        expect(root.first).to eq(root)
      end
    end

    context "on the first sibling" do
      it "returns itself" do
        expect(root_a.first.node).to eq(root_a.node)
        expect(root_aa.first.node).to eq(root_aa.node)
        expect(root_b.up.down.first.node).to eq(root_a.node)
        expect(root_ab.up.down.first.node).to eq(root_aa.node)
      end
    end

    context "on a next sibling" do
      it "returns the first sibling" do
        expect(root_b.first.node).to eq(root_a.node)
        expect(root_ab.first.node).to eq(root_aa.node)
        expect(root_b.up.down.last.first.node).to eq(root_a.node)
        expect(root_ab.up.down.last.first.node).to eq(root_aa.node)
      end
    end
  end

  describe "#last" do
    context "on root" do
      it "returns root" do
        expect(root.last).to eq(root)
      end
    end

    context "on the last sibling" do
      it "returns itself" do
        expect(root_a.last.node).to eq(root_a.node)
        expect(root_b.last.node).to eq(root_b.node)
        expect(root_ab.last.node).to eq(root_ab.node)
        expect(root_ab.last.node).to eq(root_ab.node)
        expect(root_a.up.down.last.node).to eq(root_a.node)
        expect(root_aa.up.down.last.node).to eq(root_aa.node)
      end
    end

    context "on a prev sibling" do
      it "returns the last sibling" do
        expect(root_b.prev.last.node).to eq(root_b.node)
        expect(root_ab.prev.last.node).to eq(root_ab.node)
        expect(root_b.up.down.last.node).to eq(root_b.node)
        expect(root_ab.up.down.last.node).to eq(root_ab.node)
      end
    end
  end

  describe "#next" do
    context "on root" do
      it "raises an exception" do
        expect(lambda { root.next }).to \
          raise_error(Stupidedi::Exceptions::ZipperError)
      end
    end

    context "on the last sibling" do
      it "raises an exception" do
        expect(lambda { root_a.next }).to \
          raise_error(Stupidedi::Exceptions::ZipperError)
        expect(lambda { root_b.next }).to \
          raise_error(Stupidedi::Exceptions::ZipperError)
        expect(lambda { root_b.up.down.next.next }).to \
          raise_error(Stupidedi::Exceptions::ZipperError)
      end
    end

    context "on the prev sibling" do
      it "returns the next sibling" do
        expect(root_b.prev.next.node).to eq(root_b.node)
        expect(root_ab.prev.next.node).to eq(root_ab.node)
        expect(root_b.up.down.next.node).to eq(root_b.node)
        expect(root_ab.up.down.next.node).to eq(root_ab.node)
      end
    end
  end

  describe "#prev" do
    context "on root" do
      it "raises an exception" do
        expect(lambda { root.prev }).to \
          raise_error(Stupidedi::Exceptions::ZipperError)
      end
    end

    context "on the first sibling" do
      it "raises an exception" do
        expect(lambda { root_a.prev }).to \
          raise_error(Stupidedi::Exceptions::ZipperError)
        expect(lambda { root_aa.prev }).to \
          raise_error(Stupidedi::Exceptions::ZipperError)

        expect(lambda { root_b.up.down.prev }).to \
          raise_error(Stupidedi::Exceptions::ZipperError)
        expect(lambda { root_ab.up.down.prev }).to \
          raise_error(Stupidedi::Exceptions::ZipperError)
      end
    end

    context "on the next sibling" do
      it "returns the prev sibling" do
        expect(root_b.prev.node).to eq(root_a.node)
        expect(root_ab.prev.node).to eq(root_aa.node)
        expect(root_b.up.down.next.prev.node).to eq(root_a.node)
        expect(root_ab.up.down.next.prev.node).to eq(root_aa.node)
      end
    end
  end

  describe "#root" do
    context "on root" do
      it "returns root" do
        expect(root.root).to eq(root)
      end
    end
  end

  describe "#up" do
    context "on root" do
      it "raises an error" do
        expect(lambda { root.up }).to \
          raise_error(Stupidedi::Exceptions::ZipperError)
      end
    end
  end

  describe "#append(sibling)"
  describe "#append_child(child)"
  describe "#prepend(sibling)"
  describe "#prepend_child(child)"
  describe "#delete"
  describe "#replace(node)"

end
