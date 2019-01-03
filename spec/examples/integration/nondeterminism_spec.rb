require "spec_helper"
require "pp"

describe "Non-determinism" do
  include NavigationMatchers

  let(:strict)  { Stupidedi::Builder::BuilderDsl.build(config, true)  }
  let(:relaxed) { Stupidedi::Builder::BuilderDsl.build(config, false) }

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

    d::TransactionSetDef.build("BE", "000", "Example of Ambiguous Grammar",
      d::TableDef.header("Table 1",
        s::ST.use(10, r::Mandatory, d::RepeatCount.bounded(1))),
      d::TableDef.detail("Table 2",
        d::LoopDef.build("Loop 1", d::RepeatCount.bounded(1),
          s::N1.use(20, r::Mandatory, d::RepeatCount.bounded(1)),
          s::N3.use(30, r::Optional,  d::RepeatCount.bounded(1))),
        d::LoopDef.build("Loop 2", d::RepeatCount.bounded(1),
          s::N1.use(40, r::Mandatory, d::RepeatCount.bounded(1)),
          s::N4.use(50, r::Optional,  d::RepeatCount.bounded(1)))),
      d::TableDef.summary("Table 3",
        s::SE.use(60, r::Mandatory, d::RepeatCount.bounded(1))))
  end

  let(:nondet_zero) { Fixtures.parse_("GH-129/1.txt") }
  let(:nondet_five) { Fixtures.parse_("GH-129/1.txt") }
  let(:nondet_nine) { Fixtures.parse_("GH-129/1.txt") }

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
            .machine.active.length
          ).to eq(2)
        end

        it "does not discard invalid trees" do
          expect(prelude(relaxed)
            .N1("6Y", "BOB BELCHER")
            .N1("6Y", "NON DETERMINISM") # could be Loop 1 or Loop 2
            .N4("UNKNOWN CITY")          # could only be Loop 2
            .machine.active.length
          ).to eq(2)
        end
      end
    end
  end

  context "reading" do
    def read(suffix, nondeterminism: 1)
      input =
        ["ISA*00*..........*01*SECRET....*ZZ*SUBMITTERS.ID..*ZZ*RECEIVERS.ID...*030101*1253*^*00501*000000905*1*T*:~",
         "GS*BE*SENDER ID*RECEIVER ID*19991231*0802*1*x*005010~",
         "ST*999*0000*005010~",
         "N1*6Y*LINDA BELCHER~",
         suffix].join("\n")

      machine = Stupidedi::Builder::StateMachine.build(config)
      machine.read(Stupidedi::Reader.build(input), nondeterminism: nondeterminism)
    end

    context "when nondenterminism = 1" do
      it "ordinary input suceeds" do
        machine, result = read("N3*OCEAN AVENUE~", nondeterminism: 1)

        result.should_not be_fatal
        result.reason.should eq("reached end of input without finding a segment identifier")
        machine.should be_deterministic
      end

      it "ambiguous input causes a failure result" do
        machine, result = read("N1*6Y*NON DETERMINISM~...", nondeterminism: 1)

        result.should be_fatal # no usable parse tree
        result.reason.should eq("too much non-determinism: N1 Party Identification, N1 Party Identification")
        result.remainder.should eq("...")
        machine.should_not be_deterministic
      end
    end

    context "when nondenterminism = 2" do
      it "acceptably ambiguous input succeeds" do
        machine, result = read("N1*6Y*NON DETERMINISM~...", nondeterminism: 2)

        result.should_not be_fatal # we have a usable parse tree, despite trailing garbage
        result.remainder.should eq("...")
        machine.should_not be_deterministic
        machine.active.length.should eq(2)
      end

      it "too much ambiguity causes a failure" do
        machine, result = read(
          "N1*6Y*NON DETERMINISM~" \
          "N1*6Y*THIS IS TOO MUCH~...", nondeterminism: 2)

        result.should be_fatal # no useable parse tree
        result.remainder.should eq("...")
        machine.should_not be_deterministic
        machine.active.length.should eq(1 + 2)
      end
    end

    context "when nondenterminism = 3" do
      it "too much ambiguity causes a failure" do
        machine, result = read(
          "N1*6Y*NON DETERMINISM~" \
          "N1*6Y*BLAH BLAH BLAH~" \
          "N1*6Y*THIS IS TOO MUCH~" \
          "N1*6Y*NOT GONNA SEE THIS~...", nondeterminism: 3)

        result.should be_fatal # no useable parse tree
        result.remainder.should eq("N1*6Y*NOT GONNA SEE THIS~...")
        machine.should_not be_deterministic
        machine.active.length.should eq(1 + 2*2)
      end
    end
  end

end
