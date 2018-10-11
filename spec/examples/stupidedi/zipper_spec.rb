require "spec_helper"

describe Stupidedi::Zipper do
  describe ".build" do
    it "returns a RootCursor" do
      Stupidedi::Zipper.build(Node.new("x")).should be_root
    end
  end
end
