require "spec_helper"
using Stupidedi::Refinements

describe "String#at" do
  context "on an empty string" do
    let(:string) { "" }

    context "index zero" do
      specify { string.at(0).should be_nil }
    end

    context "index one" do
      specify { string.at(1).should be_nil }
    end

    context "index two" do
      specify { string.at(2).should be_nil }
    end
  end

  context %[on "abc"] do
    let(:string) { "abc" }

    context "index zero" do
      specify { string.at(0).should == "a" }
    end

    context "index one" do
      specify { string.at(1).should == "b" }
    end

    context "index two" do
      specify { string.at(2).should == "c" }
    end
  end
end

describe "String#drop" do
  context "from an empty string" do
    let(:string) { "" }

    context "zero characters" do
      specify { string.drop(0).should == "" }
    end

    context "one character" do
      specify { string.drop(1).should == "" }
    end

    context "two characters" do
      specify { string.drop(2).should == "" }
    end
  end

  context %[from "abc"] do
    let(:string) { "abc" }

    context "zero characters" do
      specify { string.drop(0).should == "abc" }
    end

    context "one character" do
      specify { string.drop(1).should ==  "bc" }
    end

    context "two characters" do
      specify { string.drop(2).should ==   "c" }
    end

    context "three characters" do
      specify { string.drop(3).should ==    "" }
    end
  end
end

describe "String#take" do
  context "from an empty string" do
    let(:string) { "" }

    context "zero characters" do
      specify { string.take(0).should == "" }
    end

    context "one character" do
      specify { string.take(1).should == "" }
    end

    context "two characters" do
      specify { string.take(2).should == "" }
    end
  end

  context %[from "abc"] do
    let(:string) { "abc" }

    context "zero characters" do
      specify { string.take(0).should == ""    }
    end

    context "one character" do
      specify { string.take(1).should == "a"   }
    end

    context "two characters" do
      specify { string.take(2).should == "ab"  }
    end

    context "three characters" do
      specify { string.take(3).should == "abc" }
    end
  end
end
