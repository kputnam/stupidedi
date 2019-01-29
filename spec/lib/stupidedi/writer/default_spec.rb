describe Stupidedi::Writer::Default do
  using Stupidedi::Refinements
  include Definitions

  let(:id)          { Stupidedi::Parser::IdentifierStack.new(1)  }
  let(:separators)  { Stupidedi::Reader::Separators.default }

  def output(separators, *details, &block)
    Stupidedi::Writer::Default.new(zipper(separators, *details, &block), separators).write
  end

  def zipper(separators, *details, &block)
    generate(separators, *details, &block).machine.zipper.fetch.root
  end

  def generate(separators, *details)
    b = Stupidedi::Parser::BuilderDsl.build(config(details), true)
    b.ISA("00", "", "00", "", "ZZ", "SUBMITTER ID", "ZZ", "RECEIVER ID", Time.now, Time.now, "^", "00501", id.isa, "0", "T", ":")
    b. GS("FA", "SENDER ID", "RECEIVER ID", Time.now, Time.now, id.gs, b.default, "005010")
    b. ST("999", id.st)

    # This is needed for b.composite and b.repeated to work
    b.reader.instance_variable_set(:@segment_dict,
      Stupidedi::Reader::SegmentDict.build(Definitions::SegmentDefs))

    yield b if block_given?

    b. SE(id.count(b), id.pop_st)
    b. GE(id.count, id.pop_gs)
    b.IEA(id.count, id.pop_isa)
  end

  def config(details)
    Stupidedi::Config.default.customize do |x|
      x.transaction_set.register("005010", "FA", "999") do
        Stupidedi::Schema::TransactionSetDef.build("FA", "999", "Example",
          Header("1", Segment(10, :ST, s_mandatory, bounded(1))),
          *details,
          Summary("3", Segment(10, :SE, s_mandatory, bounded(1))))
      end
    end
  end

  context "when segment terminator is blank" do
    it "raises an exception" do
      expect(lambda { output(separators.copy(:segment => nil)) }).to \
        raise_error(/separators.segment cannot be blank/)
    end
  end

  context "when element separator is blank" do
    it "raises an exception" do
      expect(lambda { output(separators.copy(:element => nil)) }).to \
        raise_error(/separators.element cannot be blank/)
    end
  end

  context "when given a subtree" do
    it "returns a String" do
      buildr = generate(separators)
      zipper = buildr.machine.first.flatmap{|m| m.sequence(:GS, :ST) }.fetch.zipper.fetch
      result = Stupidedi::Writer::Default.new(zipper, separators).write
      expect(result).to be_a(String)
    end

    todo "more tests"

    context "and segment terminator occurs as data" do
      it "raises an exception" do
        buildr = generate(separators)
        zipper = buildr.machine.first.flatmap{|m| m.sequence(:GS, :ST) }.fetch.zipper.fetch
        other  = separators.copy(:segment => "9")

        expect(lambda {  Stupidedi::Writer::Default.new(zipper, other).write }).to \
          raise_error(/characters "9" occur as data/)
      end
    end
  end

  context "when given separators match ISA's" do
    it "returns a String" do
      result = output(separators)
      expect(result).to be_a(String)
    end

    todo "more tests"

    context "when a segment separator occurs as data" do
      it "raises an exception" do
        table = Detail("2", Segment(10, NNA(), s_mandatory, bounded(1)))

        expect(lambda do
          output(separators, table) do |b|
            b.NNA(0, separators.segment)
          end
        end).to raise_exception(/characters "~" occur as data/)
      end
    end
  end

  context "when given separators differ from ISA" do
    it "returns a String" do
      zipper = zipper(separators)
      others = separators.copy(:component => "|", :segment   => "~\n")
      result = Stupidedi::Writer::Default.new(zipper, others).write
      expect(result).to be_a(String)
    end

    todo "more tests"

    context "and segment separator occurs as data" do
      it "raises an exception" do
        table  = Detail("2", Segment(10, NNA(), s_mandatory, bounded(1)))
        others = separators.copy(:component => "X", :segment   => "~\n")
        zipper = zipper(separators, table) do |b|
          b.NNA(0, others.component)
        end

        expect(lambda { Stupidedi::Writer::Default.new(zipper, others).write }).to \
          raise_exception(/characters "X" occur as data/)
      end
    end
  end

  context "when tree contains composite elements" do
    it "returns a String" do
      table  = Detail("2", Segment(10, COM(), s_mandatory, bounded(1)))
      result = output(separators, table){|b| b.COM(b.composite(0, 1)) }
      expect(result).to be_a(String)
    end

    todo "more tests"
  end

  context "when tree contains repeated elements" do
    it "returns a String" do
      table  = Detail("2", Segment(10, REP(), s_mandatory, bounded(1)))
      result = output(separators, table){|b| b.REP(b.repeated(0, 1)) }
      expect(result).to be_a(String)
    end
  end
end
