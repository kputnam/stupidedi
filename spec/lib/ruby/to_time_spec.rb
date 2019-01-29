describe "Time#to_time" do
  using Stupidedi::Refinements

  it "returns self" do
    now = Time.now
    expect(now.to_time).to eql(now)
  end
end

describe "String#to_time" do
  using Stupidedi::Refinements

  it "parses time" do
    # Round off milliseconds, since to_s doesn't print them
    now = Time.at(Time.now.to_f.floor)
    expect(now.to_s.to_time).to eq(now)
  end

  context "when given invalid time" do
    it "raises an exception" do
      expect(lambda { "foo".to_time }).to \
        raise_error(ArgumentError)
    end
  end
end
