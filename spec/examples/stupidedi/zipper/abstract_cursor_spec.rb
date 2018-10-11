require "spec_helper"

describe Stupidedi::Zipper do
  describe ".build" do
    it "returns a RootCursor" do
      Stupidedi::Zipper.build(Node.new("x")).should be_root
    end
  end
end

describe Stupidedi::Zipper::AbstractCursor do
  let(:root)    { Stupidedi::Zipper.build(Node.new("a")) }
  let(:leaf)    { root.append_child(Leaf.new("x"))       }
  let(:root_a)  { root.append_child(Node.new("b"))       }
  let(:root_b)  { root_a.append(Node.new("c"))           }
  let(:root_aa) { root_a.append_child(Node.new("d"))     }
  let(:root_ab) { root_aa.append(Node.new("e"))          }

  describe "#depth" do
    context "of root" do
      it "is 0" do
        root.depth.should == 0
      end
    end

    context "of root's child" do
      it "is 1" do
        root_a.depth.should == 1
        root_b.depth.should == 1
        root_a.up.down.depth.should == 1
        root_b.up.down.depth.should == 1
      end
    end

    context "of root's grandchild" do
      it "is 2" do
        root_aa.depth.should == 2
        root_ab.depth.should == 2
        root_aa.up.down.depth.should == 2
        root_ab.up.down.depth.should == 2
      end
    end
  end

  describe "#first?" do
    context "on root" do
      it "is true" do
        root.should be_first
      end
    end

    context "on an only child" do
      it "is true" do
        root_a.should be_first
        root_aa.should be_first

        root_a.up.down.should be_first
        root_aa.up.down.should be_first

        root.dangle.should be_first
      end
    end

    context "on the first child" do
      it "is true" do
        root_b.prev.should be_first
        root_ab.prev.should be_first

        root_b.up.down.should be_first
        root_ab.up.down.should be_first
      end
    end

    context "on the last child" do
      it "is false" do
        root_b.should_not be_first
        root_ab.should_not be_first

        root_b.up.down.last.should_not be_first
        root_ab.up.down.last.should_not be_first
      end
    end
  end

  describe "#last?" do
    context "on root" do
      it "is true" do
        root.should be_last
        root_a.up.should be_last
        root_aa.up.up.should be_last
      end
    end

    context "on an only child" do
      it "is true" do
        root.dangle.should be_last
        root_a.should be_last
        root_aa.should be_last

        root_a.up.down.should be_last
        root_aa.up.down.should be_last
      end
    end

    context "on the first child" do
      it "is false" do
        root_b.prev.should_not be_last
        root_ab.prev.should_not be_last

        root_b.up.down.should_not be_last
        root_ab.up.down.should_not be_last
      end
    end

    context "on the last child" do
      it "is false" do
        root_b.should be_last
        root_ab.should be_last

        root_b.up.down.last.should be_last
        root_ab.up.down.last.should be_last
      end
    end
  end

  describe "#leaf?" do
    context "on root" do
      context "with no children" do
        it "is true" do
          root.should be_leaf
          root.dangle.should be_leaf
          root_a.dangle.should be_leaf
        end
      end

      context "with children" do
        it "is false" do
          root_a.up.should_not be_leaf
        end
      end
    end

    context "on child" do
      context "with no children" do
        it "is true" do
          root_a.should be_leaf
          root_a.up.down.should be_leaf
        end
      end

      context "with children" do
        it "is false" do
          root_aa.up.should_not be_leaf
          root_ab.up.up.down.should_not be_leaf
        end
      end
    end
  end

  describe "#root?" do
    context "on root" do
      it "is true" do
        root.should be_root
        root_a.up.should be_root
        root_b.up.should be_root
      end
    end

    context "on a child" do
      it "is false" do
        root_a.should_not be_root
        root_b.up.down.should_not be_root
        root.dangle.should_not be_root
      end
    end
  end

  describe "#child(n)" do
    context "on a leaf" do
      it "raises an exception" do
        lambda { root.child(0) }.should \
          raise_error(Stupidedi::Exceptions::ZipperError)
      end
    end

    context "on a parent" do
      it "returns the nth child" do
        root_a.up.child(0).node.should == root_a.node
        root_b.up.child(0).node.should == root_a.node
        root_b.up.child(1).node.should == root_b.node
      end
    end

    context "when n is negative" do
      it "raises an exception" do
        lambda { root_a.up.child(-1) }.should \
          raise_error(Stupidedi::Exceptions::ZipperError)
      end
    end
  end

  describe "#dangle" do
    context "on a leaf" do
      let(:dangle) { root.dangle }

      it "returns a placeholder" do
        dangle.should be_first
        dangle.should be_last
        dangle.should be_leaf

        dangle.up.should   == root
        dangle.root.should == root
        dangle.depth.should == 1

        dangle.first.should  == dangle
        dangle.last.should   == dangle
        dangle.delete.should == dangle

        lambda { dangle.next   }.should \
          raise_error(Stupidedi::Exceptions::ZipperError)

        lambda { dangle.prev   }.should \
          raise_error(Stupidedi::Exceptions::ZipperError)

        lambda { dangle.dangle }.should \
          raise_error(Stupidedi::Exceptions::ZipperError)

        lambda { dangle.append_child(Node.new("w")) }.should \
          raise_error(Stupidedi::Exceptions::ZipperError)

        lambda { dangle.prepend_child(Node.new("w")) }.should \
          raise_error(Stupidedi::Exceptions::ZipperError)
      end
    end

    context "on a leaf class" do
      it "raises an exception" do
        lambda { leaf.dangle }.should \
          raise_error(Stupidedi::Exceptions::ZipperError)
      end
    end

    context "on a parent" do
      it "returns the first child" do
        root_a.up.dangle.node.should == root_a.node
      end
    end
  end

  describe "#down" do
    context "on a leaf" do
      it "raises an exception" do
        lambda { root.down }.should \
          raise_exception(Stupidedi::Exceptions::ZipperError)
        lambda { root_a.down }.should \
          raise_exception(Stupidedi::Exceptions::ZipperError)
        lambda { root_b.down }.should \
          raise_exception(Stupidedi::Exceptions::ZipperError)
      end
    end

    context "on a parent" do
      it "returns the first child" do
        root_a.up.down.node.should == root_a.node
        root_b.up.down.node.should == root_a.node
      end
    end
  end

  describe "#descendant(n, *ns)"

  describe "#first" do
    context "on root" do
      it "returns itself" do
        root.first.should == root
      end
    end

    context "on the first sibling" do
      it "returns itself" do
        root_a.first.node.should == root_a.node
        root_aa.first.node.should == root_aa.node

        root_b.up.down.first.node.should == root_a.node
        root_ab.up.down.first.node.should == root_aa.node
      end
    end

    context "on a next sibling" do
      it "returns the first sibling" do
        root_b.first.node.should == root_a.node
        root_ab.first.node.should == root_aa.node

        root_b.up.down.last.first.node.should == root_a.node
        root_ab.up.down.last.first.node.should == root_aa.node
      end
    end
  end

  describe "#last" do
    context "on root" do
      it "returns root" do
        root.last.should == root
      end
    end

    context "on the last sibling" do
      it "returns itself" do
        root_a.last.node.should == root_a.node
        root_b.last.node.should == root_b.node
        root_ab.last.node.should == root_ab.node
        root_ab.last.node.should == root_ab.node

        root_a.up.down.last.node.should == root_a.node
        root_aa.up.down.last.node.should == root_aa.node
      end
    end

    context "on a prev sibling" do
      it "returns the last sibling" do
        root_b.prev.last.node.should == root_b.node
        root_ab.prev.last.node.should == root_ab.node

        root_b.up.down.last.node.should == root_b.node
        root_ab.up.down.last.node.should == root_ab.node
      end
    end
  end

  describe "#next" do
    context "on root" do
      it "raises an exception" do
        lambda { root.next }.should \
          raise_error(Stupidedi::Exceptions::ZipperError)
      end
    end

    context "on the last sibling" do
      it "raises an exception" do
        lambda { root_a.next }.should \
          raise_error(Stupidedi::Exceptions::ZipperError)
        lambda { root_b.next }.should \
          raise_error(Stupidedi::Exceptions::ZipperError)
        lambda { root_b.up.down.next.next }.should \
          raise_error(Stupidedi::Exceptions::ZipperError)
      end
    end

    context "on the prev sibling" do
      it "returns the next sibling" do
        root_b.prev.next.node.should == root_b.node
        root_ab.prev.next.node.should == root_ab.node

        root_b.up.down.next.node.should == root_b.node
        root_ab.up.down.next.node.should == root_ab.node
      end
    end
  end

  describe "#prev" do
    context "on root" do
      it "raises an exception" do
        lambda { root.prev }.should \
          raise_error(Stupidedi::Exceptions::ZipperError)
      end
    end

    context "on the first sibling" do
      it "raises an exception" do
        lambda { root_a.prev }.should \
          raise_error(Stupidedi::Exceptions::ZipperError)
        lambda { root_aa.prev }.should \
          raise_error(Stupidedi::Exceptions::ZipperError)

        lambda { root_b.up.down.prev }.should \
          raise_error(Stupidedi::Exceptions::ZipperError)
        lambda { root_ab.up.down.prev }.should \
          raise_error(Stupidedi::Exceptions::ZipperError)
      end
    end

    context "on the next sibling" do
      it "returns the prev sibling" do
        root_b.prev.node.should == root_a.node
        root_ab.prev.node.should == root_aa.node

        root_b.up.down.next.prev.node.should == root_a.node
        root_ab.up.down.next.prev.node.should == root_aa.node
      end
    end
  end

  describe "#root" do
    context "on root" do
      it "returns root" do
        root.root.should == root
      end
    end
  end

  describe "#up" do
    context "on root" do
      it "raises an error" do
        lambda { root.up }.should \
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
