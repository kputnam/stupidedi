describe "Exception#print" do
  using Stupidedi::Refinements

  let(:io) do
    StringIO.new
  end

  let(:exception) do
    begin
      raise RuntimeError, "error message"
    rescue Exception => error
      error
    end
  end

  it "writes to given IO stream" do
    exception.print(io: io)
    expect(io.string).to match(/RuntimeError/)
    expect(io.string).to match(/error message/)
    expect(io.string).to match(/exception_spec.rb:/)
    expect(io.string).to_not match(/module:/)
  end

  it "accepts a module name argument" do
    exception.print(io: io, name: "FooClass")
    expect(io.string).to match(/RuntimeError/)
    expect(io.string).to match(/error message/)
    expect(io.string).to match(/exception_spec.rb:/)
    expect(io.string).to match(/module: FooClass/)
  end
end
