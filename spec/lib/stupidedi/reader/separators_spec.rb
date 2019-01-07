require "spec_helper"

describe Stupidedi::Reader::Separators do
  let(:empty) { Stupidedi::Reader::Separators.empty }

  describe ".empty" do
    it "returns Separators(nil, nil, nil, nil)" do
      expect(empty.element).to be_nil
      expect(empty.segment).to be_nil
      expect(empty.component).to be_nil
      expect(empty.repetition).to be_nil
    end
  end

  describe "#merge(other)" do
    let(:first) do
      empty.copy(:element     => "a",
                 :segment     => "b",
                 :component   => "c",
                 :repetition  => "d")
    end

    context "if other.element.nil?" do
      it "then a.merge(b).element == a.element" do
        expect(first.merge(empty).element).to be == first.element
      end
    end

    context "if not other.element.nil?" do
      it "then a.merge(b).element == b.element" do
        expect(first.merge(empty.copy(:element => "A")).element).to be == "A"
      end
    end

    context "if other.segment.nil?" do
      it "then a.merge(b).segment == a.segment" do
        expect(first.merge(empty).segment).to be == first.segment
      end
    end

    context "if not other.segment.nil?" do
      it "then a.merge(b).segment == b.segment" do
        expect(first.merge(empty.copy(:segment => "A")).segment).to be == "A"
      end
    end

    context "if other.component.nil?" do
      it "then a.merge(b).component == a.component" do
        expect(first.merge(empty).component).to be == first.component
      end
    end

    context "if not other.component.nil?" do
      it "then a.merge(b).component == b.component" do
        expect(first.merge(empty.copy(:component => "A")).component).to be == "A"
      end
    end

    context "if other.repetition.nil?" do
      it "then a.merge(b).repetition == a.repetition" do
        expect(first.merge(empty).repetition).to be == first.repetition
      end
    end

    context "if not other.repetition.nil?" do
      it "then a.merge(b).repetition == b.repetition" do
        expect(first.merge(empty.copy(:repetition => "A")).repetition).to be == "A"
      end
    end
  end
end
