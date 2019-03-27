describe "Object#inspect" do
  context "on instance of anonymous class" do
    let(:object) do
      klass = Class.new
      klass.class_eval { include Stupidedi::Inspect }
      klass.new
    end

    it "returns a String" do
      expect(object.inspect).to be_a(String)
      expect(object.inspect).to match(/Class:0x/)
    end
  end

  context "on instance of named class" do
    let(:object) do
      stub_const("Stupidedi::ExampleClass", Class.new)
      Stupidedi::ExampleClass.class_eval { include Stupidedi::Inspect }
      Stupidedi::ExampleClass.new
    end

    it "returns a String" do
      expect(object.inspect).to be_a(String)
      expect(object.inspect).to match(/Stupidedi::ExampleClass:0x/)
    end
  end
end
