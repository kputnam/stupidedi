using Stupidedi::Refinements

describe "Object#cons" do
  context "with no argument" do
    it "creates a singleton list" do
      expect(0.cons).to be == [0]
    end
  end

  context "with an array argument" do
    it "prepends the object" do
      expect("a".cons(%w(b c d))).to be == %w(a b c d)
    end

    property "prepends the object" do
      [character, array { character }]
    end.check do |a, as|
      expect(a.cons(as).length).to be == 1 + as.length
      expect(a.cons(as).first).to  be == a
    end

    it "does not destructively modify the argument" do
      array = %w(b c d)
      "a".cons(array)
      expect(array).to be == %w(b c d)
    end
  end
end

describe "Object#snoc" do
  context "with no argument" do
    it "creates a singleton list" do
      expect(0.snoc).to be == [0]
    end
  end

  context "with an array argument" do
    it "appends the object" do
      expect("d".snoc(%w(a b c))).to be == %w(a b c d)
    end

    it "does not destructively modify the argument" do
      array = %w(a b c)
      "d".snoc(array)
      expect(array).to be == %w(a b c)
    end
  end
end

describe "Object#bind" do
  it "provides an alternative syntax to local variables and parethesized expressions" do
    expect(1.then{|a| a + 2 } * 3).to be == ((1 + 2) * 3)
  end

  it "provides an alternative syntax to local variables and parethesized expressions" do
    expect(1.then{|a| (a + 2).then{|b| b * 3 }}).to be == ((1 + 2) * 3)
  end

  it "provides an alternative syntax to local variables and parethesized expressions" do
    expect(1.then{|a| a.then{|b| b + 2 }.then{|c| c * 3 }}).to be == ((1 + 2) * 3)
  end
end

describe "Object#tap" do
  let(:object) { double("object") }

  it "requires a block argument" do
    expect(lambda { object.tap }).to raise_error(LocalJumpError)
  end

  it "yields the object to a block argument" do
    expect(object).to receive(:message).with(:argument)
    object.tap{|o| o.message(:argument) }
  end

  it "returns the object" do
    expect(object.tap { :whatever }).to be == object
  end
end

describe "Object#eigenclass" do
  let(:object) { double("object") }

  it "returns a Class" do
    expect(object.eigenclass).to be_a(Class)
  end

  it "cannot be instantiated" do
    expect(lambda { object.eigenclass.new }).to raise_error(TypeError)
  end

  specify { expect(object.eigenclass).to be == (class << object; self; end) }
end
