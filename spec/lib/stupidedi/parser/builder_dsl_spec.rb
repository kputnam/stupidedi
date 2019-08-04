describe Stupidedi::Parser::BuilderDsl, "strict validation" do
  using Stupidedi::Refinements
  include Definitions
  include NavigationMatchers

  let(:stack) { Stupidedi::Parser::IdentifierStack.new(1)  }

  def strict(*details)
    start_transaction_set(details, true)
  end

  def relaxed(*details)
    start_transaction_set(details, false)
  end

  def start_transaction_set(details, strict)
    b = Stupidedi::Parser::BuilderDsl.build(config(details), strict)
    b.ISA("00", "", "00", "", "ZZ", "SUBMITTER ID", "ZZ", "RECEIVER ID", Time.now, Time.now, "^", "00501", stack.isa, "0", "T", ":")
    b. GS("FA", "SENDER ID", "RECEIVER ID", Time.now, Time.now, stack.gs, b.default, "005010")
    b. ST("999", stack.st)
  end

  def config(details, version = "005010")
    Stupidedi::Config.default.customize do |x|
      x.functional_group.register("005010",
        Definitions::FunctionalGroupDelegator.new(x.functional_group.at("005010")))

      x.transaction_set.register(version, "FA", "999") do
        Stupidedi::Schema::TransactionSetDef.build("FA", "999", "Example",
          Header("1", Segment(10, :ST, s_mandatory, bounded(1))),
          *details,
          Summary("3", Segment(10, :SE, s_mandatory, bounded(1))))
      end
    end
  end

  describe "on interchanges" do
    context "with unregistered version (ISA12)" do
      it "raises an exception" do
        expect do
          b = Stupidedi::Parser::BuilderDsl.build(config([]), true)
          b.ISA("00", "", "00", "", "ZZ", "SUBMITTER ID", "ZZ", "RECEIVER ID", Time.now, Time.now, "^", "00001", stack.isa, "0", "T", ":")
        end.to raise_error(/version "00001"/)
      end
    end

    context "with registered version (ISA12)" do
      it "is a-ok" do
        b = Stupidedi::Parser::BuilderDsl.build(config([]), true)
        b.ISA("00", "", "00", "", "ZZ", "SUBMITTER ID", "ZZ", "RECEIVER ID", Time.now, Time.now, "^", "00501", stack.isa, "0", "T", ":")

        expect(b.machine.first.fetch.zipper.tap do |z|
          expect(z.node).to be_segment
          expect(z.parent.node).to be_interchange
        end).to be_defined
      end
    end

    context "when repeated" do
      context "at the end of an interchange" do
        it "is a-ok" do
          b = Stupidedi::Parser::BuilderDsl.build(config([]), true)
          b.ISA("00", "", "00", "", "ZZ", "SUBMITTER ID", "ZZ", "RECEIVER ID", Time.now, Time.now, "^", "00501", stack.isa, "0", "T", ":")
          b.IEA(stack.count, stack.pop_isa)
          b.ISA("00", "", "00", "", "ZZ", "SUBMITTER ID", "ZZ", "RECEIVER ID", Time.now, Time.now, "^", "00501", stack.isa, "0", "T", ":")

          expect(b.machine.first.fetch.zipper.tap do |z|
            expect(z.node).to be_segment

            expect(z.parent.node).to be_interchange
            expect(z.parent.children.length).to eq(2)

            expect(z.parent.next.node).to be_interchange
            expect(z.parent.next.children.length).to eq(1)
          end).to be_defined
        end
      end

      context "in the middle of an interchange" do
        it "raises an exception" do
          expect do
            b = Stupidedi::Parser::BuilderDsl.build(config([]), true)
            b.ISA("00", "", "00", "", "ZZ", "SUBMITTER ID", "ZZ", "RECEIVER ID", Time.now, Time.now, "^", "00501", 1, "0", "T", ":")
            b.ISA("00", "", "00", "", "ZZ", "SUBMITTER ID", "ZZ", "RECEIVER ID", Time.now, Time.now, "^", "00501", 2, "0", "T", ":")
          end.to raise_error(/segment IEA .+? missing/)
        end
      end
    end
  end

  describe "on functional groups" do
    context "with unregistered version (GS08)" do
      it "raises an exception" do
        expect do
          b = Stupidedi::Parser::BuilderDsl.build(config([]), true)
          b.ISA("00", "", "00", "", "ZZ", "SUBMITTER ID", "ZZ", "RECEIVER ID", Time.now, Time.now, "^", "00501", stack.isa, "0", "T", ":")
          b. GS("FA", "SENDER ID", "RECEIVER ID", Time.now, Time.now, stack.gs, b.default, "000010")
        end.to raise_error(/version "000010"/)
      end
    end

    context "with registered version (GS08)" do
      it "constructions a functional group" do
        b = Stupidedi::Parser::BuilderDsl.build(config([]), true)
        b.ISA("00", "", "00", "", "ZZ", "SUBMITTER ID", "ZZ", "RECEIVER ID", Time.now, Time.now, "^", "00501", stack.isa, "0", "T", ":")
        b. GS("FA", "SENDER ID", "RECEIVER ID", Time.now, Time.now, stack.gs, b.default, "005010")

        expect(b.machine.first.fetch.find(:GS).fetch.zipper.tap do |z|
          expect(z.node).to be_segment

          expect(z.parent.node).to be_functional_group
          expect(z.parent.children.length).to eq(1)

          expect(z.parent.parent.node).to be_interchange
          expect(z.parent.parent.children.length).to eq(2) # ISA + FunctionalGroupVal
        end).to be_defined
      end
    end

    context "when repeated" do
      context "at the end of a functional group" do
        it "is a-ok" do
          b = Stupidedi::Parser::BuilderDsl.build(config([]), true)
          b.ISA("00", "", "00", "", "ZZ", "SUBMITTER ID", "ZZ", "RECEIVER ID", Time.now, Time.now, "^", "00501", stack.isa, "0", "T", ":")
          b. GS("FA", "SENDER ID", "RECEIVER ID", Time.now, Time.now, stack.gs, b.default, "005010")
          b. GE(stack.count, stack.pop_gs)
          b. GS("FA", "SENDER ID", "RECEIVER ID", Time.now, Time.now, stack.gs, b.default, "005010")

          expect(b.machine.first.fetch.sequence(:GS, :GS).fetch.zipper.tap do |z|
            expect(z.node).to be_segment

            expect(z.parent.node).to be_functional_group
            expect(z.parent.children.length).to eq(1) # GS

            expect(z.parent.prev.node).to be_functional_group
            expect(z.parent.prev.children.length).to eq(2) # GS + GE

            expect(z.parent.parent.node).to be_interchange
            expect(z.parent.parent.children.length).to eq(3) # ISA + FunctionalGroupVal + FunctionalGroupVal
          end).to be_defined
        end
      end

      context "in the middle of a functional group" do
        it "raises an exception" do
          expect do
            b = Stupidedi::Parser::BuilderDsl.build(config([]), true)
            b.ISA("00", "", "00", "", "ZZ", "SUBMITTER ID", "ZZ", "RECEIVER ID", Time.now, Time.now, "^", "00501", stack.isa, "0", "T", ":")
            b. GS("FA", "SENDER ID", "RECEIVER ID", Time.now, Time.now, 1, b.default, "005010")
            b. GS("FA", "SENDER ID", "RECEIVER ID", Time.now, Time.now, 2, b.default, "005010")
          end.to raise_error(/segment GE .+? missing/)
        end
      end
    end
  end

  describe "on transaction sets" do
    context "given GS01 + GS08 + ST01" do
      context "when unregistered" do
        it "raises an exception" do
          expect do
            b = Stupidedi::Parser::BuilderDsl.build(config([]), true)
            b.ISA("00", "", "00", "", "ZZ", "SUBMITTER ID", "ZZ", "RECEIVER ID", Time.now, Time.now, "^", "00501", stack.isa, "0", "T", ":")
            b. GS("FA", "SENDER ID", "RECEIVER ID", Time.now, Time.now, stack.gs, b.default, "005010")
            b. ST("000", stack.st)
          end.to raise_error(/unknown transaction set "005010" "FA" "000"/)
        end
      end

      context "when registered" do
        it "constructions a transaction set" do
          b = Stupidedi::Parser::BuilderDsl.build(config([]), true)
          b.ISA("00", "", "00", "", "ZZ", "SUBMITTER ID", "ZZ", "RECEIVER ID", Time.now, Time.now, "^", "00501", stack.isa, "0", "T", ":")
          b. GS("FA", "SENDER ID", "RECEIVER ID", Time.now, Time.now, stack.gs, b.default, "005010")
          b. ST("999", stack.st)

          expect(b.machine.first.fetch.sequence(:GS, :ST).fetch.zipper.tap do |z|
            expect(z.node).to be_segment

            expect(z.parent.node).to be_table
            expect(z.parent.children.length).to eq(1) # ST

            expect(z.parent.parent.node).to be_transaction_set
            expect(z.parent.parent.children.length).to eq(1) # Table 1

            expect(z.parent.parent.parent.node).to be_functional_group
            expect(z.parent.parent.parent.children.length).to eq(2) # GS + TransactionSetVal
          end).to be_defined
        end
      end
    end

    context "given GS01 + GS08 with industry code + ST01" do
      context "when unregistered" do
        it "raises an exception" do
          expect do
            b = Stupidedi::Parser::BuilderDsl.build(config([], "005010X999"), true)
            b.ISA("00", "", "00", "", "ZZ", "SUBMITTER ID", "ZZ", "RECEIVER ID", Time.now, Time.now, "^", "00501", stack.isa, "0", "T", ":")
            b. GS("FA", "SENDER ID", "RECEIVER ID", Time.now, Time.now, stack.gs, b.default, "005010X000")
            b. ST("000", stack.st)
          end.to raise_error(/unknown transaction set "005010X000" "FA" "000"/)
        end
      end

      context "when registered" do
        it "constructions a transaction set" do
          b = Stupidedi::Parser::BuilderDsl.build(config([], "005010X999"), true)
          b.ISA("00", "", "00", "", "ZZ", "SUBMITTER ID", "ZZ", "RECEIVER ID", Time.now, Time.now, "^", "00501", stack.isa, "0", "T", ":")
          b. GS("FA", "SENDER ID", "RECEIVER ID", Time.now, Time.now, stack.gs, b.default, "005010X999")
          b. ST("999", stack.st)

          expect(b.machine.first.fetch.sequence(:GS, :ST).fetch.zipper.tap do |z|
            expect(z.node).to be_segment

            expect(z.parent.node).to be_table
            expect(z.parent.children.length).to eq(1) # ST

            expect(z.parent.parent.node).to be_transaction_set
            expect(z.parent.parent.children.length).to eq(1) # Table 1

            expect(z.parent.parent.parent.node).to be_functional_group
            expect(z.parent.parent.parent.children.length).to eq(2) # GS + TransactionSetVal
          end).to be_defined
        end
      end
    end

    context "given GS01 + GS08 + ST01 + ST03" do
      context "when unregistered" do
        it "raises an exception" do
          expect do
            b = Stupidedi::Parser::BuilderDsl.build(config([], "005010X999"), true)
            b.ISA("00", "", "00", "", "ZZ", "SUBMITTER ID", "ZZ", "RECEIVER ID", Time.now, Time.now, "^", "00501", stack.isa, "0", "T", ":")
            b. GS("FA", "SENDER ID", "RECEIVER ID", Time.now, Time.now, stack.gs, b.default, "005010")
            b. ST("999", stack.st, "005010X000")
          end.to raise_error(/unknown transaction set "005010X000" "FA" "999"/)
        end
      end

      context "when registered" do
        it "constructions a transaction set" do
          b = Stupidedi::Parser::BuilderDsl.build(config([], "005010X999"), true)
          b.ISA("00", "", "00", "", "ZZ", "SUBMITTER ID", "ZZ", "RECEIVER ID", Time.now, Time.now, "^", "00501", stack.isa, "0", "T", ":")
          b. GS("FA", "SENDER ID", "RECEIVER ID", Time.now, Time.now, stack.gs, b.default, "005010")
          b. ST("999", stack.st, "005010X999")

          expect(b.machine.first.fetch.sequence(:GS, :ST).fetch.zipper.tap do |z|
            expect(z.node).to be_segment

            expect(z.parent.node).to be_table
            expect(z.parent.children.length).to eq(1) # ST

            expect(z.parent.parent.node).to be_transaction_set
            expect(z.parent.parent.children.length).to eq(1) # Table 1

            expect(z.parent.parent.parent.node).to be_functional_group
            expect(z.parent.parent.parent.children.length).to eq(2) # GS + TransactionSetVal
          end).to be_defined
        end
      end
    end

    context "given GS01 + GS08 + ST01 + ST03" do
      context "when unregistered" do
        it "ST03 takes precedence over GS08" do
          expect do
            b = Stupidedi::Parser::BuilderDsl.build(config([], "005010X999"), true)
            b.ISA("00", "", "00", "", "ZZ", "SUBMITTER ID", "ZZ", "RECEIVER ID", Time.now, Time.now, "^", "00501", stack.isa, "0", "T", ":")
            b. GS("FA", "SENDER ID", "RECEIVER ID", Time.now, Time.now, stack.gs, b.default, "005010X999")
            b. ST("999", stack.st, "005010X000")
          end.to raise_error(/unknown transaction set "005010X000" "FA" "999"/)
        end
      end

      context "when registered" do
        it "ST03 takes precedence over GS08" do
          b = Stupidedi::Parser::BuilderDsl.build(config([], "005010X999"), true)
          b.ISA("00", "", "00", "", "ZZ", "SUBMITTER ID", "ZZ", "RECEIVER ID", Time.now, Time.now, "^", "00501", stack.isa, "0", "T", ":")
          b. GS("FA", "SENDER ID", "RECEIVER ID", Time.now, Time.now, stack.gs, b.default, "005010X000")
          b. ST("999", stack.st, "005010X999")

          expect(b.machine.first.fetch.sequence(:GS, :ST).fetch.zipper.tap do |z|
            expect(z.node).to be_segment

            expect(z.parent.node).to be_table
            expect(z.parent.children.length).to eq(1) # ST

            expect(z.parent.parent.node).to be_transaction_set
            expect(z.parent.parent.children.length).to eq(1) # Table 1

            expect(z.parent.parent.parent.node).to be_functional_group
            expect(z.parent.parent.parent.children.length).to eq(2) # GS + TransactionSetVal
          end).to be_defined
        end
      end
    end
  end

  describe "on tables" do
    context "when start segment repeats" do
      context "but is not repeatable" do
        it "raises an exception" do
          b = strict(
            Detail("2",
              Segment(10, NNA(), s_mandatory, bounded(1))))

          b.NNA(0)
          expect { b.NNA(1) }.to raise_error(/NNA\*1~ cannot occur here/)
        end

        it "raises an exception" do
          b = strict(
            Detail("2",
              Loop("2000A", bounded(1),
                Segment(10, NNA(), s_mandatory, bounded(1)))))

          b.NNA(0)
          expect { b.NNA(1) }.to raise_error(/NNA\*1~ cannot occur here/)
        end
      end

      context "when table starts with a repeatable loop" do
        it "is a-ok" do
          b = strict(
            Detail("2",
              Loop("2000A", unbounded,
                Segment(10, NNA(), s_mandatory, bounded(1)))))

          b.NNA(0)
          b.NNA(1)

          # Ensure only one table is constructed, with two children loops
          expect(b.machine.first.fetch.sequence(:GS, :ST, :NNA).fetch.zipper.tap do |z|
            expect(z.node).to be_segment

            expect(z.parent.node).to be_loop
            expect(z.parent.children.length).to eq(1)

            expect(z.parent.parent.node).to be_table
            expect(z.parent.parent.children.length).to eq(2) # 2000A, 2000A

            expect(z.parent.next.node).to be_loop
            expect(z.parent.next.children.length).to eq(1)
          end).to be_defined
        end
      end

      context "when table is repeatable (#172)" do
        it "is a-ok" do
          b = strict(
            Detail("2A",
              Loop("2000A", unbounded,
                Segment(10, IDA(%w(A)), s_mandatory, bounded(1)))),
            Detail("2B",
              Loop("2000B", unbounded,
                Segment(10, IDA(%w(B)), s_mandatory, bounded(1)))))

          b.IDA("A")
          b.IDA("B")
          b.IDA("A")
          b.IDA("B")

          expect(b.machine.first.fetch.sequence(:GS, :ST, :IDA).fetch.zipper.tap do |z|
            expect(z.parent.node).to be_loop
            expect(z.parent.parent.node).to be_table
            expect(z.parent.parent.parent.node).to be_transaction_set
            expect(z.parent.parent.parent.children.length).to eq(5) # 1, 2A, 2B, 2A, 2B
          end).to be_defined
        end
      end
    end

    context "in sequence" do
      context "when detail tables have same start position" do
        let(:b) do
          strict(
            Detail("2A",
              Segment(10, IDA(%w(A)), s_optional, bounded(1))),
            Detail("2B",
              Segment(10, IDA(%w(B)), s_optional, bounded(1))))
        end

        it "can start in either order" do
          b.IDA("A")
          b.IDA("B")

          expect(b.machine.first.fetch.sequence(:GS, :ST, :IDA).fetch.zipper.tap do |z|
            expect(z.node).to be_segment #(:IDA, "A")

            expect(z.parent.node).to be_table
            expect(z.parent.children.length).to eq(1)

            expect(z.parent.parent.node).to be_transaction_set
            expect(z.parent.parent.children.length).to eq(3) # 1, 2A, 2B
          end).to be_defined
        end

        it "can start in either order" do
          b.IDA("B")
          b.IDA("A")

          expect(b.machine.first.fetch.sequence(:GS, :ST, :IDA).fetch.zipper.tap do |z|
            expect(z.node).to be_segment #(:IDA, "A")

            expect(z.parent.node).to be_table
            expect(z.parent.children.length).to eq(1)

            expect(z.parent.parent.node).to be_transaction_set
            expect(z.parent.parent.children.length).to eq(3) # 1, 2A, 2B
          end).to be_defined
        end
      end

      context "when detail tables have increasing start positions" do
        let(:b) do
          strict(
            Detail("2A",
              Segment(10, NNA(), s_optional, bounded(1))),
            Detail("2B",
              Segment(20, NNB(), s_optional, bounded(1))))
        end

        # Currently only the ordering of the *type* of table (header, detail,
        # or summary) is enforced. It's unknown if details can or do have a
        # particular ordering.
        #
        # It's possible that X12 standards and implementation guides are
        # designed to sidestep this question, by making all detail tables begin
        # at the same position.
        todo "enforces order of tables" do
          b.NNB(3)
          expect { b.NNA(2) }.to raise_error(/todo/)
        end
      end

      context "when detail table occurs after summary table" do
        it "raises an exception" do
          b = strict(
            Detail("2",
              Segment(20, NNA(), s_optional, bounded(1))))

          b.SE(stack.count(b), stack.pop_st)
          expect { b.NNA(0) }.to raise_error(/segment NNA\*0~ cannot occur here/)
        end
      end
    end

    context "when not required" do
      let(:b) do
        strict(
          Detail("2A",
            Segment(10, NNA(), s_optional, bounded(1))),
          Detail("2B",
            Segment(20, NNB(), s_optional, bounded(1))))
      end

      context "but present" do
        it "is a-ok" do
          b.NNA(1)
          b.NNB(0)

          expect(b.machine.first.fetch.sequence(:GS, :ST, :NNB).fetch.zipper.tap do |z|
            expect(z.parent.node).to be_table
            expect(z.parent.parent.node).to be_transaction_set
            expect(z.parent.parent.children.length).to eq(3) # 1, 2A, 2B
          end).to be_defined
        end
      end

      context "and missing" do
        it "is a-ok" do
          b.NNB(0)

          expect(b.machine.first.fetch.sequence(:GS, :ST, :NNB).fetch.zipper.tap do |z|
            expect(z.parent.node).to be_table
            expect(z.parent.parent.node).to be_transaction_set
            expect(z.parent.parent.children.length).to eq(2) # 1, 2B
          end).to be_defined
        end
      end
    end

    context "when required" do
      let(:b) do
        strict(
          Detail("2A",
            Segment(10, NNA(), s_mandatory, bounded(1))),
          Detail("2B",
            Segment(20, NNB(), s_optional, bounded(1))))
      end

      context "and present" do
        it "is a-ok" do
          b.NNA(1)
          b.NNB(0)

          expect(b.machine.first.fetch.sequence(:GS, :ST, :NNB).fetch.zipper.tap do |z|
            expect(z.parent.node).to be_table
            expect(z.parent.parent.node).to be_transaction_set
            expect(z.parent.parent.children.length).to eq(3) # 1, 2A, 2B
          end).to be_defined
        end
      end

      context "but missing" do
        it "raises an exception" do
          b.NNB(0)
          b.SE(stack.count(b), stack.pop_st)

          expect do
            b.GE(stack.count, stack.pop_gs)
          end.to raise_error(/required table 2A is missing/)
        end

        todo "raises an exception, immediately" do
          expect do
            b.NNB(0)
          end.to raise_error(/required table 2A is missing/)
        end
      end
    end

    context "when too few are present" do
      it "raises an exception" do
        b = strict(
          Detail("2",
            Segment(10, NNA(), s_mandatory, bounded(1))))

        expect do
          b.SE(stack.count(b), stack.pop_st)
          b.GE(stack.count, stack.pop_gs)
        end.to raise_error(/required table 2 is missing/)
      end

      todo "raises an exception immediately" do
        b = strict(
          Detail("2",
            Segment(10, NNA(), s_mandatory, bounded(1))))

        expect do
          b.SE(stack.count(b), stack.pop_st)
        end.to raise_error(/required table 2 is missing/)
      end

      it "raises an exception" do
        b = strict(
          Detail("2",
            Loop("2000", bounded(2),
              Segment(10, NNA(), s_mandatory, bounded(1)))))

        expect do
          b.SE(stack.count(b), stack.pop_st)
          b.GE(stack.count, stack.pop_gs)
        end.to raise_error(/required table 2 is missing/)
      end

      todo "raises an exception immediately" do
        b = strict(
          Detail("2",
            Loop("2000", bounded(2),
              Segment(10, NNA(), s_mandatory, bounded(1)))))

        expect do
          b.SE(stack.count(b), stack.pop_st)
        end.to raise_error(/required table 2 is missing/)
      end
    end

    context "when too many are present" do
      let(:b) do
        strict(
          Detail("2a", Segment(10, NNB(), s_optional, unbounded)),
          Detail("2b", Segment(20, NNA(), s_optional, unbounded))).NNB(0).NNA(1)
      end

      it "raises an exception" do
        expect do
          b.NNB(0).SE(stack.count(b), stack.pop_st)
          b.GE(stack.count, stack.pop_gs)
        end.to raise_error(/table 2a occurs too many times/)
      end

      todo "raises an exception immediately" do
        expect { b.NNB(0) }.to raise_error(/table 2a occurs too many times/)
      end
    end
  end

  describe "on loops" do
    todo
    # NM1*A
    # NM1*A
    # NM1*B
    # NM1*B
    # NM1*A
    #
    # Table 2A
    #   Loop 2000A
    #   Loop 2000A  -- should not go in a separate Table 2A
    # Table 2B
    #   Loop 2000B
    #   Loop 2000B
    # Table 2A
    #   Loop 2000A

    context "when correct number are present" do
      it "are constructed when start segment occurs" do
        b = strict(
          Detail("2",
            Loop("2000", unbounded,
              Segment(10, NNA(), s_optional, bounded(1)))))

        b.NNA(1)
        b.machine.first
         .flatmap{|m| m.sequence(:GS, :ST, :NNA) }
         .flatmap{|m| m.zipper }
         .tap do |z|
           expect(z.node).to be_segment
           expect(z.parent.node).to be_loop
           expect(z.parent.parent.node).to be_table

           expect(z.parent.node.children.length).to eq(1)         # Loop 2000 > ...
           expect(z.parent.parent.node.children.length).to eq(1)  # Table 2   > ...
        end
      end

      it "are constructed when start segment repeats" do
        b = strict(
          Detail("2",
            Loop("2000", unbounded,
              Segment(10, NNA(), s_optional, bounded(1)))))

        b.NNA(1)
        b.NNA(2)
        b.machine.first
         .flatmap{|m| m.sequence(:GS, :ST, :NNA) }
         .flatmap{|m| m.zipper }
         .tap do |z|
           expect(z.node).to be_segment
           expect(z.parent.node).to be_loop
           expect(z.parent.parent.node).to be_table

           expect(z.parent.node.children.length).to eq(1)         # Loop 2000 > ...
           expect(z.parent.parent.node.children.length).to eq(2)  # Table 2   > ...
        end
      end
    end

    context "when too many are present" do
      it "raises an exception" do
        b = strict(
          Detail("2",
            Loop("2000", bounded(1),
              Segment(10, NNA(), s_optional, bounded(1)))))

        b.NNA(1)

        # The parser throws away the {Instruction} for NNA once it's executed, so
        # it doesn't even allow an extra one to occur. This error occurs before
        # the "loop 2000 occurs too many times" error
        expect { b.NNA(2) }.to raise_error(/NNA.+? cannot occur here/)
      end

      it "raises an exception" do
        b = strict(
          Detail("2",
            Loop("2000", bounded(2),
              Segment(10, NNA(), s_optional, bounded(1)))))

        b.NNA(1)
        b.NNA(2)

        expect do
          b.NNA(3)
          b.SE(stack.count(b), stack.pop_st)
          b.GS(stack.count, stack.pop_gs)
        end.to raise_error(/loop 2000 occurs too many times/)
      end

      todo "raises an exception immediately" do
        b = strict(
          Detail("2",
            Loop("2000", bounded(2),
              Segment(10, NNA(), s_optional, bounded(1)))))

        b.NNA(1)
        b.NNA(2)

        expect { b.NNA(3) }.to raise_error(/loop 2000 occurs too many times/)
      end
    end

    context "too few are present" do
      it "raises an exception" do
        b = strict(
          Detail("2",
            Segment(10, NNB(), s_optional, bounded(1)),
            Loop("2000", bounded(2),
              Segment(20, NNA(), s_mandatory, bounded(1)))))

        b.NNB(0)

        expect do
          b.SE(stack.count(b), stack.pop_st)
        end.to raise_error(/required loop 2000 is missing/)
      end
    end
  end

  describe "on segments" do
    context "when shouldn't occur but is present" do
      it "raises an exception" do
        b = strict(
          Detail("2",
            Segment(10, NNA(), s_optional, bounded(1))))

        expect { b.NNB(0) }.to raise_error(/segment NNB.*? cannot occur/)
      end

      it "raises an exception" do
        b = strict(
          Detail("2",
            Segment(10, NNA(), s_optional, bounded(1))))

        expect do
          b.ANA("123 MAIN")
        end.to raise_error(/segment ANA\*123 MAIN~ cannot occur/)
      end
    end

    context "when too few are present" do
      let(:b) do
        strict(
          Detail("2",
           Segment(10, NNB(), s_mandatory, bounded(1)),
           Segment(20, NNA(), s_mandatory, bounded(1)),
           Segment(30, ANA(), s_optional,  bounded(1)))).NNB(0)
      end

      it "raises an exception" do
        expect do
          b.SE(stack.count(b), stack.pop_st)
        end.to raise_error(/segment NNA .+? is missing/)
      end

      pending "raises an exception immediately" do
        # This validation is delayed until this loop is "closed". It would be
        # an improvement for the error to happen immediately, like this:
        expect do
          b.ANA("123 MAIN")
        end.to raise_error(/segment NNA .+? is missing/)
      end
    end

    context "when too many are present" do
      it "raises an exception" do
        b = strict(
          Detail("2a",
           Segment(10, NNB(), s_optional, bounded(1)),
           Segment(10, NNA(), s_optional, bounded(2))))

        b.NNB(0)
        b.NNA(1)
        b.NNA(2)

        expect do
          b.NNA(3)
          b.SE(stack.count(b), stack.pop_st)
        end.to raise_error(/segment NNA .+? occurs too many times/)
      end
    end
  end

  describe "on elements" do
    context "when Optional (or Situational)" do
      let(:b) do
        strict(Detail("2", Segment_(10, :XX, "Example", s_mandatory, bounded(1),
          Element(de_N0, e_optional, bounded(1)))))
      end

      context "and present" do
        it "is a-ok" do
          expect { b.XX(1) }.not_to raise_error
        end
      end

      context "and missing" do
        it "not given is a-ok" do
          expect { b.XX }.not_to raise_error
        end

        it "b.blank is a-ok" do
          expect { b.XX(b.blank) }.not_to raise_error
        end

        it "b.not_used raises exception" do
          expect { b.XX(b.not_used) }.to raise_error(/XX01 is not forbidden/)
        end

        it "nil is a-ok" do
          expect { b.XX(nil) }.not_to raise_error
        end

        it "'' is a-ok" do
          expect { b.XX("") }.not_to raise_error
        end
      end
    end

    context "when Mandatory (or Required)" do
      let(:b) do
        strict(Detail("2", Segment_(10, :XX, "Example", s_mandatory, bounded(1),
          Element(de_N0, e_mandatory, bounded(1)))))
      end

      context "and present" do
        it "is a-ok" do
          expect { b.XX(1) }.not_to raise_error
        end
      end

      context "and missing" do
        it "not given raises an exception" do
          expect { b.XX }.to raise_error(/required element XX01 .+? is blank/)
        end

        it "b.not_used raises an exception" do
          expect { b.XX(b.not_used) }.to raise_error(/XX01 is not forbidden/)
        end

        it "b.blank raises an exception" do
          expect { b.XX(b.blank) }.to raise_error(/required element XX01 .+? is blank/)
        end

        it "nil raises an exception" do
          expect { b.XX(nil) }.to raise_error(/required element XX01 .+? is blank/)
        end

        it "'' raises an exception" do
          expect { b.XX('') }.to raise_error(/required element XX01 .+? is blank/)
        end
      end
    end

    context "when NotUsed" do
      let(:b) do
        strict(Detail("2", Segment_(10, :XX, "Example", s_mandatory, bounded(1),
          Element(de_N0, e_not_used, bounded(1)))))
      end

      context "and present" do
        it "raises an exception" do
          expect { b.XX(1) }.to raise_error(/forbidden element XX01 .+? is present/)
        end
      end

      context "and missing" do
        it "not given is a-ok" do
          expect { b.XX }.not_to raise_error
        end

        it "b.not_used is a-ok" do
          expect { b.XX(b.not_used) }.not_to raise_error
        end

        it "b.blank is a-ok" do
          expect { b.XX(b.blank) }.not_to raise_error
        end

        it "nil is a-ok" do
          expect { b.XX(nil) }.not_to raise_error
        end

        it "'' is a-ok" do
          expect { b.XX("") }.not_to raise_error
        end
      end
    end

    context "when Relational" do
      # if any are present, all are must be present
      context "with SyntaxNotes::P" do
        let(:b) do
          strict(Detail("2",
            Segment_(10, :XX, "Example", s_mandatory, bounded(1),
              Element(de_N0, e_mandatory,  bounded(1)),
              Element(de_N0, e_relational, bounded(1)),
              Element(de_N0, e_relational, bounded(1)),
              P(2, 3))))
        end

        context "and required" do
          context "and present" do
            it "is a-ok" do
              expect { b.XX(5, 5, 5) }.not_to raise_error
            end
          end

          context "but missing" do
            it "raises an exception" do
              expect { b.XX(5, nil, 5) }.to raise_error(/, elements? 2 must be present/)
            end

            it "raises an exception" do
              expect { b.XX(5, 5, nil) }.to raise_error(/, elements? 3 must be present/)
            end
          end
        end

        context "not required" do
          context "and missing" do
            it "is a-ok" do
              expect { b.XX(5) }.not_to raise_error
            end
          end
        end
      end

      # at least one must be present
      context "with SyntaxNotes::R" do
        let(:b) do
          strict(Detail("2",
            Segment_(10, :XX, "Example", s_mandatory, bounded(1),
              Element(de_N0, e_mandatory,  bounded(1)),
              Element(de_N0, e_relational, bounded(1)),
              Element(de_N0, e_relational, bounded(1)),
              R(2, 3))))
        end

        context "and present" do
          it "is a-ok" do
            expect { b.XX(5, 5, 5) }.not_to raise_error
          end

          it "is a-ok" do
            expect { b.XX(5, nil, 5) }.not_to raise_error
          end

          it "is a-ok" do
            expect { b.XX(5, 5, nil) }.not_to raise_error
          end
        end

        context "but missing" do
          it "raises an exception" do
            expect { b.XX(5) }.to raise_error(/, at least one of elements 2, 3 must be present/)
          end
        end
      end

      # if first is present, others must be present
      context "with SyntaxNotes::C" do
        let(:b) do
          strict(Detail("2",
            Segment_(10, :XX, "Example", s_mandatory, bounded(1),
              Element(de_N0, e_mandatory,  bounded(1)),
              Element(de_N0, e_relational, bounded(1)),
              Element(de_N0, e_relational, bounded(1)),
              C(2, 3))))
        end

        context "and required" do
          context "and present" do
            it "is a-ok" do
              expect { b.XX(5, 5, 5) }.not_to raise_error
            end
          end

          context "but missing" do
            it "raises an exception" do
              expect { b.XX(5, 5, nil) }.to raise_error(/, elements 3 must be present/)
            end
          end
        end

        context "not required" do
          context "but present" do
            it "is a-ok" do
              expect { b.XX(5, nil, 5) }.not_to raise_error
            end
          end

          context "and missing" do
            it "is a-ok" do
              expect { b.XX(5, nil, nil) }.not_to raise_error
            end
          end
        end
      end

      # if first is present, then at least one other must be present
      context "with SyntaxNotes::L" do
        let(:b) do
          strict(Detail("2",
            Segment_(10, :XX, "Example", s_mandatory, bounded(1),
              Element(de_N0, e_optional,   bounded(1)),
              Element(de_N0, e_relational, bounded(1)),
              Element(de_N0, e_relational, bounded(1)),
              L(1, 2, 3))))
        end

        context "and required" do
          context "and present" do
            it "is a-ok" do
              expect { b.XX(5, 5, 5) }.not_to raise_error
            end

            it "is a-ok" do
              expect { b.XX(5, nil, 5) }.not_to raise_error
            end

            it "is a-ok" do
              expect { b.XX(5, 5, nil) }.not_to raise_error
            end
          end

          context "but missing" do
            it "raises an exception" do
              expect { b.XX(5, nil, nil) }.to \
                raise_error(/at least one of elements 2, 3 must be present/)
            end
          end
        end

        context "and not required" do
          context "but present" do
            it "is a-ok" do
              expect { b.XX(nil, nil, 5) }.not_to raise_error
            end

            it "is a-ok" do
              expect { b.XX(nil, 5, nil) }.not_to raise_error
            end

            it "is a-ok" do
              expect { b.XX(nil, 5, 5) }.not_to raise_error
            end
          end

          context "and missing" do
            it "is a-ok" do
              expect { b.XX }.not_to raise_error
            end
          end
        end
      end

      # not more than one may be present
      context "with SyntaxNotes::E" do
        context "and present"

        context "and missing"
      end
    end

    context "when too short" do
      it "raises an exception" do
        b = strict(Detail("2",
          Segment(10, ANA(:min_length => 4), s_mandatory, bounded(1))))

        expect { b.ANA("X") }.to raise_error(/value is too short in element ANA01/)
        expect(b.machine).to be_segment(:ST)
      end
    end

    context "when too long" do
      it "raises an exception" do
        b = strict(Detail("2",
          Segment(10, ANA(:max_length => 2), s_mandatory, bounded(1))))

        expect { b.ANA("WXYZ") }.to raise_error(/value is too long in element ANA01/)
        expect(b.machine).to be_segment(:ST)
      end
    end

    context "simple" do
      context "when element should be repeating" do
        let(:b) do
          strict(Detail("2", Segment(10, REP(), s_mandatory, bounded(1))))
        end

        it "raises an exception" do
          expect { b.REP("A") }.to raise_error(/REP01 is a repeatable element/)
          expect(b.machine).to be_segment(:ST)
        end
      end

      context "when element should be composite" do
        let(:b) do
          strict(Detail("2", Segment(10, COM(), s_mandatory, bounded(1))))
        end

        it "raises an exception" do
          expect { b.COM(1) }.to raise_error(/COM01 is a non-repeatable composite element/)
          expect(b.machine).to be_segment(:ST)
        end
      end

      context "AN (string)" do
        let(:b) do
          strict(Detail("2", Segment_(10, :XX, "Example", s_mandatory, bounded(1),
            Element(de_AN.copy(:min_length => 2, :max_length => 4), e_mandatory, bounded(1)))))
        end

        context "when given a Date" do
          it "raises an exception" do
            expect { b.XX(Date.today) }.to raise_error(/invalid element XX01/)
            expect(b.machine).to be_segment(:ST)
          end
        end

        context "when given a Time" do
          it "raises an exception" do
            expect { b.XX(Date.today) }.to raise_error(/invalid element XX01/)
            expect(b.machine).to be_segment(:ST)
          end
        end

        context "when given a valid string" do
          it "is a-ok" do
            expect { b.XX("AB") }.to_not raise_error
            expect(b.machine).to be_segment(:XX)
          end
        end
      end

      context "DT (date)" do
        shared_examples "2345" do
          context "given a Time" do
            it "is a-ok" do
              expect { b.XX(Time.now) }.not_to raise_error
              expect(b.machine).to be_segment(:XX)
            end
          end

          context "given a Date" do
            it "is a-ok" do
              expect { b.XX(Date.today) }.not_to raise_error
              expect(b.machine).to be_segment(:XX)
            end
          end

          context "given a String with a 3-digit year" do
            it "raises an exception" do
              expect { b.XX("9990130") }.to raise_error(/invalid element XX01/)
              expect(b.machine).to be_segment(:ST)
            end
          end

          context "given a String with a 4-digit year" do
            it "is a-ok" do
              expect { b.XX("19990130") }.to_not raise_error
              expect(b.machine).to be_segment(:XX)
            end
          end

          context "given a String with a 5-digit year" do
            it "raises an exception" do
              expect { b.XX("019990130") }.to_not raise_error
              expect(b.machine).to be_segment(:XX)
            end
          end

          context "given a value that responds to #year, #month, and #day" do
            context "with a valid date" do
              it "is a-ok" do
                value = OpenStruct.new(:year => 2000, :month => 12, :day => 30)
                expect { b.XX(value) }.to_not raise_error
                expect(b.machine).to be_segment(:XX)
              end
            end

            context "with an invalid date" do
              it "raises an exception" do
                value = OpenStruct.new(:year => 2000, :month => 13, :day => 33)
                expect { b.XX(value) }.to raise_error(/invalid element XX01/)
                expect(b.machine).to be_segment(:ST)
              end
            end
          end

          context "given some other type of value" do
            it "raises an exception" do
              expect { b.XX(20001231) }.to raise_error(/invalid element XX01/)
              expect(b.machine).to be_segment(:ST)
            end
          end
        end

        context "of length 6" do
          let(:b) do
            strict(Detail("2", Segment_(10, :XX, "Example", s_mandatory, bounded(1),
              Element(de_DT6, e_mandatory, bounded(1)))))
          end

          include_examples "2345"

          context "given a String with a 2-digit year" do
            it "is a-ok" do
              expect { b.XX("990130") }.not_to raise_error
              expect(b.machine).to be_segment(:XX)
            end
          end
        end

        context "of length 8" do
          let(:b) do
            strict(Detail("2", Segment_(10, :XX, "Example", s_mandatory, bounded(1),
              Element(de_DT8, e_mandatory, bounded(1)))))
          end

          include_examples "2345"

          context "given a String with a 2-digit year" do
            it "raises an exception" do
              expect { b.XX("990130") }.to raise_error(/value is too short in element XX01/)
              expect(b.machine).to be_segment(:ST)
            end
          end
        end
      end

      context "ID (identifier)" do
        context "when a simple element" do
          let(:b) do
            strict(Detail("2",
              # No additional restrictions on IDA01, all A-Z allowed
              Segment(10, IDA(), s_optional, bounded(1)),

              # Two instances are disjoint, IDB01 determins which of these is used
              Segment(20, IDB(%w(X), "Example X"), s_optional, bounded(1)),
              Segment(20, IDB(%w(Y), "Example Y"), s_optional, bounded(1)),

              # Two instances have some shared values (A), so ambiguity is possible
              Segment(30, IDC(%w(A X), "Example X"), s_optional, bounded(1)),
              Segment(30, IDC(%w(A Y), "Example Y"), s_optional, bounded(1))))
          end

          context "when given a non-allowed value" do
            context "and no choice is involved" do
              it "raises an exception" do
                expect { b.IDA("0") }.to  raise_error(/value 0 is not allowed in element IDA01/)
                expect(b.machine).to be_segment(:ST)
              end
            end

            context "and choice is involved" do
              it "raises an exception" do
                expect { b.IDB("0") }.to raise_error(/value 0 is not allowed in element IDB01/)
                expect(b.machine).to be_segment(:ST)
              end

              it "raises an exception" do
                expect { b.IDC("0") }.to raise_error(/value 0 is not allowed in element IDC01/)
                expect(b.machine).to be_segment(:ST)
              end
            end
          end

          context "when given an ambiguous value" do
            it "raises an exception" do
              expect { b.IDB(nil) }.to raise_error(/non-deterministic machine state: IDB Example X, IDB Example Y/)
              expect(b.machine).to be_segment(:ST)
            end

            it "raises an exception" do
              expect { b.IDC("A") }.to \
                raise_error(/non-deterministic machine state: IDC Example X, IDC Example Y/)
              expect(b.machine).to be_segment(:ST)
            end
          end

          context "when given an allowed value" do
            it "is a-ok" do
              expect do
                b.IDA("X")
                b.IDB("X")
                b.IDB("Y")
                b.IDC("X")
                b.IDC("Y")
              end.to_not raise_error
              expect(b.machine).to be_segment(:IDC)
            end
          end
        end

        context "when a component element" do
          let(:b) do
            strict(Detail("2",
              # No additional restrictions on XX01, all A-Z allowed
              Segment(20, COI(), s_optional, bounded(1)),

              # Two instances are disjoint, XX01 determins which of these is used
              Segment(20, COJ(%w(X), "Example X"), s_optional, bounded(1)),
              Segment(20, COJ(%w(Y), "Example Y"), s_optional, bounded(1)),

              # Two instances have some shared values (A), so ambiguity is possible
              Segment(30, COK(%w(A X), "Example X"), s_optional, bounded(1)),
              Segment(30, COK(%w(A Y), "Example Y"), s_optional, bounded(1))))
          end

          context "when given a non-allowed value" do
            context "and no choice is involved" do
              it "raises an exception" do
                expect { b.COI(b.composite("0")) }.to \
                  raise_error(/value 0 is not allowed in element COI01-01/)
                expect(b.machine).to be_segment(:ST)
              end
            end

            context "and choice is involved" do
              it "raises an exception" do
                expect { b.COJ(b.composite("0")) }.to \
                  raise_error(/value 0 is not allowed in element COJ01-01/)
                expect(b.machine).to be_segment(:ST)
              end

              it "raises an exception" do
                expect { b.COK(b.composite("0")) }.to \
                  raise_error(/value 0 is not allowed in element COK01-01/)
                expect(b.machine).to be_segment(:ST)
              end
            end
          end

          context "when given an ambiguous value" do
            it "raises an exception" do
              expect { b.COJ(b.composite(nil)) }.to \
                raise_error(/non-deterministic machine state: COJ Example X, COJ Example Y/)
              expect(b.machine).to be_segment(:ST)
            end

            it "raises an exception" do
              expect { b.COK(b.composite("A")) }.to \
                raise_error(/non-deterministic machine state: COK Example X, COK Example Y/)
              expect(b.machine).to be_segment(:ST)
            end
          end

          context "when given an allowed value" do
            it "is a-ok" do
              expect do
                b.COI(b.composite("X"))
                b.COJ(b.composite("X"))
                b.COJ(b.composite("Y"))
                b.COK(b.composite("X"))
                b.COK(b.composite("Y"))
              end.to_not raise_error
              expect(b.machine).to be_segment(:COK)
            end
          end
        end
      end

      context "Nn (fixed precision number)" do
        let(:b) do
          strict(Detail("2", Segment_(10, :XX, "Example", s_mandatory, bounded(1),
            Element(de_N0, e_mandatory, bounded(1)))))
        end

        context "when given a non-numeric value" do
          it "throws an exception" do
            expect { b.XX("A") }.to raise_error(/invalid element XX01/)
          end
        end

        context "when given a valid number" do
          it "is a-ok" do
            expect { b.XX(1) }.to_not raise_error
            expect(b.machine).to be_segment(:XX, 1)
          end
        end
      end

      context "TM (time)" do
        let(:b) do
          strict(Detail("2", Segment_(10, :XX, "Example", s_mandatory, bounded(1),
            Element(de_TM, e_mandatory, bounded(1)))))
        end

        context "when given a non-numeric string" do
          it "raises an exception" do
            expect { b.XX("A") }.to raise_error(/invalid element XX01/)
            expect(b.machine).to be_segment(:ST)
          end
        end

        context "when given an invalid time" do
          it "raises an exception" do
            value = OpenStruct.new(:hour => 30, :minute => 10, :second => 45)
            expect { b.XX(value) }.to raise_error(/invalid element XX01/)
            expect(b.machine).to be_segment(:ST)
          end
        end
      end

      context "R (floating precision number)" do
        let(:b) do
          strict(Detail("2", Segment_(10, :XX, "Example", s_mandatory, bounded(1),
            Element(de_R, e_mandatory, bounded(1)))))
        end

        context "when given a non-numeric value" do
          it "raises an exception" do
            expect { b.XX("A") }.to raise_error(/invalid element XX01/)
            expect(b.machine).to be_segment(:ST)
          end
        end

        context "when given a valid number" do
          it "is a-ok" do
            expect { b.XX(1) }.to_not raise_error
            expect(b.machine).to be_segment(:XX, 1)
          end
        end
      end
    end

    context "composite" do
      context "when element is missing" do
        let(:b) do
          strict(Detail("2", Segment(10, COS(), s_mandatory, bounded(1))))
        end

        it "raises an exception" do
          expect { b.COS() }.to raise_error(/required element COS01 .+? is blank/)
          expect(b.machine).to be_segment(:ST)
        end
      end

      context "when element should be simple" do
        let(:b) do
          strict(Detail("2", Segment(10, IDA(), s_mandatory, bounded(1))))
        end

        it "raises an exception" do
          expect { b.IDA(b.composite(1)) }.to raise_error(/IDA01 is a non-repeatable simple element/)
          expect(b.machine).to be_segment(:ST)
        end
      end

      context "when element is repeating" do
        let(:b) do
          strict(Detail("2", Segment(10, REP(), s_mandatory, bounded(1))))
        end

        it "raises an exception" do
          expect { b.REP(b.composite(1)) }.to raise_error(/REP01 is a repeatable element/)
          expect(b.machine).to be_segment(:ST)
        end
      end

      context "when given a valid composite value" do
        let(:b) do
          strict(Detail("2", Segment(10, COM(), s_mandatory, bounded(1))))
        end

        it "is a-ok" do
          expect { b.COM(b.composite(1, 2)) }.to_not raise_error
          expect(b.machine).to be_segment(:COM, b.composite(1, 2))
        end
      end
    end

    context "repeating" do
      context "when element should not repeat" do
        let(:b) do
          strict(Detail("2", Segment(10, IDA(), s_mandatory, bounded(1))))
        end

        it "raises and exception" do
          expect { b.IDA(b.repeated("A", "B")) }.to raise_error(/IDA01 is a non-repeatable simple element/)
        end
      end

      context "when too many repeats are present" do
        let(:b) do
          strict(Detail("2", Segment(10, REP(), s_mandatory, bounded(1))))
        end

        it "raises an exception" do
          expect { b.REP(b.repeated(1, 2, 3, 4)) }.to raise_error(/repeating element REP01 .+? occurs too many times/)
        end
      end

      context "when " do
        let(:b) do
          strict(Detail("2", Segment(10, REP(), s_mandatory, bounded(1))))
        end

        it "is a-ok" do
          expect { b.REP(b.repeated(1, 2, 3)) }.to_not raise_error
          expect(b.machine).to be_segment(:REP)
          # expect(b.machine).to be_segment(:REP, b.repeated(1, 2, 3))
        end
      end
    end
  end
end
