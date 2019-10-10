using Stupidedi::Refinements

describe "String#at" do
  context "on an empty string" do
    let(:string) { "" }

    context "index zero" do
      specify { expect(string.at(0)).to be nil }
    end

    context "index one" do
      specify { expect(string.at(1)).to be nil }
    end

    context "index two" do
      specify { expect(string.at(2)).to be nil }
    end
  end

  context %[on "abc"] do
    let(:string) { "abc" }

    context "index zero" do
      specify { expect(string.at(0)).to be == "a" }
    end

    context "index one" do
      specify { expect(string.at(1)).to be == "b" }
    end

    context "index two" do
      specify { expect(string.at(2)).to be == "c" }
    end
  end
end

describe "String#drop" do
  context "from an empty string" do
    let(:string) { "" }

    context "zero characters" do
      specify { expect(string.drop(0)).to be == "" }
    end

    context "one character" do
      specify { expect(string.drop(1)).to be == "" }
    end

    context "two characters" do
      specify { expect(string.drop(2)).to be == "" }
    end
  end

  context %[from "abc"] do
    let(:string) { "abc" }

    context "zero characters" do
      specify { expect(string.drop(0)).to be == "abc" }
    end

    context "one character" do
      specify { expect(string.drop(1)).to be ==  "bc" }
    end

    context "two characters" do
      specify { expect(string.drop(2)).to be ==   "c" }
    end

    context "three characters" do
      specify { expect(string.drop(3)).to be ==    "" }
    end
  end
end

describe "String#take" do
  context "from an empty string" do
    let(:string) { "" }

    context "zero characters" do
      specify { expect(string.take(0)).to be == "" }
    end

    context "one character" do
      specify { expect(string.take(1)).to be == "" }
    end

    context "two characters" do
      specify { expect(string.take(2)).to be == "" }
    end
  end

  context %[from "abc"] do
    let(:string) { "abc" }

    context "zero characters" do
      specify { expect(string.take(0)).to be == ""    }
    end

    context "one character" do
      specify { expect(string.take(1)).to be == "a"   }
    end

    context "two characters" do
      specify { expect(string.take(2)).to be == "ab"  }
    end

    context "three characters" do
      specify { expect(string.take(3)).to be == "abc" }
    end
  end
end

describe "String#join" do
  context "single-line string" do
    let(:string) { "\t test  string \t" }
    specify { expect(string.join).to be == string }
  end

  context "multi-line string" do
    specify do
      x = "  abc
          def"
      expect(x.join).to be == "  abc def"
    end

    specify do
      x = "abc
          def  "
      expect(x.join).to be == "abc def  "
    end

    specify do
      x = "abc
            def"
      expect(x.join).to be == "abc def"
    end
  end
end
