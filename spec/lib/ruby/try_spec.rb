using Stupidedi::Refinements

describe "Object#try" do
  let(:object) { double("object") }

  it "calls a unary block" do
    expect(object).to receive(:message).with(no_args)
    object.try{|o| o.message }
  end

  it "calls a unary block" do
    expect(object).to receive(:message).with(no_args)
    object.try(&:message)
  end

  it "calls a nullary method" do
    expect(object).to receive(:message).with(no_args)
    object.try(:message)
  end

  it "calls a nullary method with a unary block" do
    expect(%w(a b c).try(:map, &:length)).to be == [1, 1, 1]
  end

  it "calls a nullary method with a binary block" do
    expect(%w(abc def ghi).try(:inject, &:+)).to be == "abcdefghi"
  end

  it "calls a unary method" do
    expect(object).to receive(:message).with(:argument)
    object.try(:message, :argument)
  end

  it "calls a unary method with a binary block" do
    expect(%w(abc def ghi).try(:inject, 1){|sum, e| sum + e.length }).to be == 10
  end

  it "calls a binary method" do
    expect(object).to receive(:message).with(:first, :second)
    object.try(:message, :first, :second)
  end
end

describe "NilClass#try" do
  specify { expect(nil.try{ whatever }).to              be nil }
  specify { expect(nil.try(:a)).to                      be nil }
  specify { expect(nil.try(:a) { whatever }).to         be nil }
  specify { expect(nil.try(:a, :b, :c)).to              be nil }
  specify { expect(nil.try(:a, :b, :c) { whatever }).to be nil }
end
