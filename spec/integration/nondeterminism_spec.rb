describe "Non-determinism" do
  include NavigationMatchers
  using Stupidedi::Refinements

  let(:strict)  { Stupidedi::Parser::BuilderDsl.build(config, true)  }
  let(:relaxed) { Stupidedi::Parser::BuilderDsl.build(config, false) }

  let(:config) do
    Stupidedi::Config.default.customize do |c|
      c.transaction_set.customize do |x|
        x.register("005010", "BE", "999") { schema }
      end
    end
  end

  let(:schema) do
    d = Stupidedi::Schema
    r = Stupidedi::Versions::FiftyTen::SegmentReqs
    s = Stupidedi::Versions::FiftyTen::SegmentDefs

    d::TransactionSetDef.build("BE", "999", "Example of Ambiguous Grammar",
      d::TableDef.header("Table 1",
        s::ST.use(10, r::Mandatory, d::RepeatCount.bounded(1))),
      d::TableDef.detail("Table 2",
        d::LoopDef.build("Loop 1", d::RepeatCount.unbounded,
          s::N1.use(20, r::Mandatory, d::RepeatCount.bounded(1)),
          s::N3.use(30, r::Optional,  d::RepeatCount.bounded(1)),
          d::LoopDef.build("Loop 1.1", d::RepeatCount.unbounded,
            s::N1.use(40, r::Mandatory, d::RepeatCount.bounded(1)),
            s::N4.use(50, r::Optional,  d::RepeatCount.bounded(1))))),
      d::TableDef.summary("Table 3",
        s::SE.use(60, r::Mandatory, d::RepeatCount.bounded(1))))
  end

  def prelude(dsl)
    dsl.ISA("00", "", "00", "", "ZZ", "_", "ZZ", "_",
            Time.now.utc, Time.now.utc, "", "00501",
            123456789, "1", "T", "")

    dsl.GS("BE", "SENDER ID", "RECEIVER ID",
           Time.now.utc, Time.now.utc, "1", "X", "005010")

    dsl.ST("999", "0000", "005010")
  end

  context "generating an ambiguous segment" do
    context "when strict" do
      it "throws an exception" do
        expect(lambda do
          prelude(strict)
            .N1("6Y", "BOB BELCHER")
            .N1("6Y", "NON DETERMINISM") # could be Loop 1 or Loop 2
        end).to raise_error \
          "non-deterministic machine state: N1 Party Identification, N1 Party Identification"
      end
    end

    context "when non-strict" do
      it "does not throw an exception" do
        expect(lambda do
          prelude(relaxed)
            .N1("6Y", "BOB BELCHER")
            .N1("6Y", "NON DETERMINISM") # could be Loop 1 or Loop 2
        end).not_to raise_error
      end

      context "with later unambiguous input" do
        it "does not discard invalid trees" do
          expect(prelude(relaxed)
            .N1("6Y", "BOB BELCHER")
            .N1("6Y", "NON DETERMINISM") # could be Loop 1 or Loop 2
            .N3("OCEAN AVENUE")          # could only be Loop 1
            .machine.active.length).to eq(2)
        end

        it "does not discard invalid trees" do
          expect(prelude(relaxed)
            .N1("6Y", "BOB BELCHER")
            .N1("6Y", "NON DETERMINISM") # could be Loop 1 or Loop 2
            .N4("UNKNOWN CITY")          # could only be Loop 2
            .machine.active.length).to eq(2)
        end
      end
    end
  end

  context "reading" do
    def read(input, nondeterminism: 1)
      builder     = prelude(relaxed).N1("6Y", "LINDA BELCHER")
      separators  = Stupidedi::Reader::Separators.new(":", "^", "*", "~")

      input  = Stupidedi::Reader::Input.build(input)
      reader = Stupidedi::Reader::TokenReader.new(input, separators, builder.reader.segment_dict)
      builder.machine.read(reader, nondeterminism: nondeterminism)
    end

    context "when nondenterminism = 1" do
      it "ordinary input suceeds" do
        machine, result = read("N3*OCEAN AVENUE~", nondeterminism: 1)

        expect(result).to_not be_fatal
        expect(result.reason).to be == "reached end of input without finding a segment identifier"
        expect(machine).to be_deterministic
      end

      it "ambiguous input causes a failure result" do
        machine, result = read("N1*6Y*NON DETERMINISM~...", nondeterminism: 1)

        expect(result).to be_fatal # no usable parse tree
        expect(result.reason).to be == "too much non-determinism: SegmentUse(40, N1, M, 1), SegmentUse(20, N1, M, 1)"
        expect(result.remainder).to be == "..."
        expect(machine).to_not be_deterministic
      end
    end

    context "when nondenterminism = 2" do
      it "acceptably ambiguous input succeeds" do
        machine, result = read("N1*6Y*NON DETERMINISM~...", nondeterminism: 2)

        expect(result).to_not be_fatal # we have a usable parse tree, despite trailing garbage
        expect(result.remainder).to be == "..."
        expect(machine).to_not be_deterministic
        expect(machine.active.length).to be == 2
      end

      it "too much ambiguity causes a failure" do
        machine, result = read(
          ["N1*XX*WHAT IS THIS?~",  # 2
           "N1*YY*LOOP 1 OR 2~",    # 4
           "..."].join, nondeterminism: 2)

        expect(result).to be_fatal # no useable parse tree
        expect(machine).to_not be_deterministic
        expect(machine.active.length).to be == 4
        expect(result.remainder).to be == "..."
      end
    end

    context "when nondenterminism = 3" do
      it "too much ambiguity causes a failure" do
        machine, result = read(
          ["N1*XX*WHAT IS THIS?~",  # 2
           "N1*YY*LOOP 1 OR 2?~",   # 4
           "N1*ZZ*EXPLOSION~",      # 8
           "..."].join, nondeterminism: 3)

        expect(result).to be_fatal # no useable parse tree
        expect(machine).to_not be_deterministic
        expect(machine.active.length).to be == 4
        expect(result.remainder).to be == "N1*ZZ*EXPLOSION~..."
      end
    end
  end
end
