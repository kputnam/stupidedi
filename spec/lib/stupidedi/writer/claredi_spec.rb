describe Stupidedi::Writer::Claredi do
  using Stupidedi::Refinements
  include Definitions

  let(:id) { Stupidedi::Parser::IdentifierStack.new(1)  }

  def output(*details, &block)
    Stupidedi::Writer::Claredi.new(zipper(*details, &block).node).write.string
  end

  def zipper(*details, &block)
    generate(*details, &block).machine.zipper.fetch.root
  end

  def generate(*details)
    b = Stupidedi::Parser::BuilderDsl.build(config(details), true)
    b.ISA("00", "", "00", "", "ZZ", "SUBMITTER ID", "ZZ", "RECEIVER ID", Time.now, Time.now, "^", "00501", id.isa, "0", "T", ":")
    b. GS("FA", "SENDER ID", "RECEIVER ID", Time.now, Time.now, id.gs, b.default, "005010")
    b. ST("999", id.st)

    yield b if block_given?

    b. SE(id.count(b), id.pop_st)
    b. GE(id.count, id.pop_gs)
    b.IEA(id.count, id.pop_isa)
  end

  def config(details)
    Stupidedi::Config.default.customize do |x|
      x.functional_group.register("005010",
        Definitions::FunctionalGroupDelegator.new(x.functional_group.at("005010")))

      x.transaction_set.register("005010", "FA", "999") do
        Stupidedi::Schema::TransactionSetDef.build("FA", "999", "Example",
          Header("1", Segment(10, :ST, s_mandatory, bounded(1))),
          *details,
          Summary("3", Segment(10, :SE, s_mandatory, bounded(1))))
      end
    end
  end

  context "when given a subtree" do
    it "returns a String" do
      buildr = generate
      zipper = buildr.machine.first.flatmap{|m| m.sequence(:GS, :ST) }.fetch.zipper.fetch
      result = Stupidedi::Writer::Claredi.new(zipper.node).write.string

      expect(result).to be_a(String)
    end

    todo "more tests"
  end

  context "when given a boring tree" do
    it "returns a String" do
      result = output(
        Detail("2",
          Loop("2000A", unbounded,
            Segment(10, NNA(), s_mandatory, bounded(1))),
          Loop("2000B NAMED LOOP", unbounded,
            Segment(10, NNB(), s_mandatory, bounded(1))))) do |b|
        b.NNA(0)
        b.NNB(0)
        b.NNA(1)
        b.NNB(1)
      end

      expect(result).to be_a(String)
    end

    todo "more tests"
  end

  context "when tree contains composite elements" do
    it "returns a String" do
      table  = Detail("2", Segment(10, COM(), s_mandatory, bounded(1)))
      result = output(table){|b| b.COM(b.composite(0, 1)) }

      expect(result).to be_a(String)
    end
  end

  context "when tree contains repeated elements" do
    it "returns a String" do
      table  = Detail("2", Segment(10, REP(), s_mandatory, bounded(1)))
      result = output(table){|b| b.REP(b.repeated(0, 1)) }

      expect(result).to be_a(String)
    end

    todo "more tests"
  end
end
