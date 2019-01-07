using Stupidedi::Refinements

describe "Symbol#to_proc" do
  include QuickCheck::Macro

  it "calls nullary methods" do
    expect(:length.to_proc.call("abc")).to be == 3
  end

  it "calls nullary methods" do
    expect(:length.to_proc.call([1,1,1])).to be == 3
  end

  it "shortens the syntax when passing unary blocks" do
    expect(%w(abc de f).map(&:length)).to be == [3, 2, 1]
  end

  it "shortens the syntax when passing unary blocks" do
    expect([1, 4, 3, 0, 2].count(&:zero?)).to be == 1
  end

  it "calls unary methods" do
    a = {          :a => 10, :b => 10}
    b = {:a => 20,           :c => 20}

    expect(:merge.to_proc.call(a, b)).to be == a.merge(b)
    expect(:merge.to_proc.call(a, b)).to be == {:a => 20, :b => 10, :c => 20}
  end

  it "shortens the syntax when passing binary blocks" do
    a = {          :a => 10, :b => 10}
    b = {:a => 20, :b => 20, :c => 20}
    c = {:b => 30, :c => 30, :d => 30}

    expect([a, b, c].inject(&:merge)).to be == a.merge(b).merge(c)
    expect([a, b, c].inject(&:merge)).to be == {:a => 20, :b => 30, :c => 30, :d => 30}
  end

  property "calls n-ary methods" do
    map(between(0, 10)) { integer }
  end.check do |as|
    expect(:call.to_proc.call(lambda{|*bs| bs }, *as)).to be == as
  end

  property "calls n-ary methods" do
    map(between(0, 10)) { integer }
  end.check do |as|
    expect(:call.to_proc.call(lambda{|*bs| bs.length }, *as)).to be == as.length
  end

  pending "shortens the syntax when passing n-ary blocks",
    unless: RUBY_VERSION >= "2.4" || RUBY_PLATFORM == "java" do
    list = []

    # avert your eyes, lisp haters!
    [[:zero?,     1       ],  #=> 1.__send__(:zero?)            == 1.zero?
     [:length,    "string"],  #=> "string".__send__(:length)    == "string".length
     [:+,         "a", "b"],  #=> "a".__send__(:+, "b")         == "a" + "b"
     [:fetch, {}, "a", "b"],  #=> {}.__send__(:fetch, "a", "b") == {}.fetch("a","b")
     [:[]=, list,  2, true],  #=> list.__send__(:[]=, 2, true)  == list[2] = true
     [:call, :length, "ab"]]. #=> :length.__send__(:call, "ab") == "ab".length

     expect(map{|n,*as| n.call(*as) }).to be ==
       [1.zero?,
        "string".length,
        ("a" + "b"),
        {}.fetch("a","b"),
        true,
        "ab".length]
    expect(list[2]).to be == true
  end
end

describe "Symbol#call" do
  include QuickCheck::Macro

  it "requires at least one argument" do
    expect(lambda { :message.call }).to raise_error(ArgumentError)
  end

  it "sends a message to the first argument" do
    receiver = double("object")
    expect(receiver).to receive(:message)
    :message.call(receiver)
  end

  it "passes the remaining arguments along" do
    receiver = double("object")
    expect(receiver).to receive(:message).with("a", "b")
    :message.call(receiver, "a", "b")
  end

  it "does not flatten the argument list" do
    receiver = double("object")
    expect(receiver).to receive(:message).with(["a", "b"], "c")
    :message.call(receiver, ["a", "b"], "c")
  end
end
