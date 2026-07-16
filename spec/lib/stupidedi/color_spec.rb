describe Stupidedi::Color do
  shared_examples "methods" do
    Stupidedi::Color::Wrapper.instance_methods(false).each do |m|
      describe "##{m}" do
        it "returns a String" do
          expect(wrapper.__send__(m, "abcABCxyzXYZ")).to be_a(String)
          expect(wrapper.__send__(m, "abcABCxyzXYZ")).to match(/abcABCxyzXYZ/)
        end
      end
    end

    Stupidedi::Color::Stub::METHODS.each do |m|
      describe "##{m}" do
        it "returns a String" do
          expect(wrapper.__send__(m, "abcABCxyzXYZ")).to be_a(String)
          expect(wrapper.__send__(m, "abcABCxyzXYZ")).to match(/abcABCxyzXYZ/)
        end
      end
    end
  end

  describe "stub" do
    let(:wrapper) { Stupidedi::Color::Wrapper.new(Stupidedi::Color::Stub) }
    include_examples "methods"
  end

  describe "implementation" do
    let(:wrapper) { Stupidedi::Color::Wrapper.new(Stupidedi::Color::ANSI) }
    include_examples "methods"
  end
end
