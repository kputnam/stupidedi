describe Stupidedi::Parser::Navigation do
  using Stupidedi::Refinements
  include NavigationMatchers
  include Definitions

  let(:id) { Stupidedi::Parser::IdentifierStack.new(1)  }

  def strict(*details)
    start_transaction_set(details, true)
  end

  def start_transaction_set(details, strict)
    b = Stupidedi::Parser::BuilderDsl.build(config(details), strict)
    b.ISA("00", "", "00", "", "ZZ", "SUBMITTER ID", "ZZ", "RECEIVER ID", Time.now, Time.now, "^", "00501", id.isa, "0", "T", ":")
    b. GS("FA", "SENDER ID", "RECEIVER ID", Time.now, Time.now, id.gs, b.default, "005010")
    b. ST("999", id.st)
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

  describe "#find" do
    shared_examples "123456" do
      it "finds first unqualified match" do
        expect(m).to be_able_to_find(:IDA).with_result_matching("A", nil, 1)
      end

      it "finds first qualified match" do
        expect(m).to be_able_to_find(:IDA, "A").with_result_matching(nil, nil, 1)
        expect(m).to be_able_to_find(:IDA, "B").with_result_matching(nil, nil, 3)
      end

      it "finds each qualified match" do
        expect(m).to be_able_to_find(:IDA, "A", nil, 1)
        expect(m).to be_able_to_find(:IDA, "A", nil, 2)
        expect(m).to be_able_to_find(:IDA, "B", nil, 3)
        expect(m).to be_able_to_find(:IDA, "A", nil, 4)
        expect(m).to be_able_to_find(:IDA, "B", nil, 5)
        expect(m).to be_able_to_find(:IDA, "B", nil, 6)
      end

      it "finds each unqualified match" do
        expect(m).to be_able_to_find(:IDA, nil, nil, 1)
        expect(m).to be_able_to_find(:IDA, nil, nil, 2)
        expect(m).to be_able_to_find(:IDA, nil, nil, 3)
        expect(m).to be_able_to_find(:IDA, nil, nil, 4)
        expect(m).to be_able_to_find(:IDA, nil, nil, 5)
        expect(m).to be_able_to_find(:IDA, nil, nil, 6)
      end
    end

    context "when match is a sibling" do
      context "immediately adjacent" do
        let(:b) do
          strict(
            Detail("2",
              Segment(50, NNA(), s_mandatory, bounded(1)),
              Segment(60, IDA(), s_mandatory, unbounded)))
        end

        let(:m) do
          b.NNA(0)
          b.IDA("A", "", 1)
          b.IDA("A", "", 2)
          b.IDA("B", "", 3)
          b.IDA("A", "", 4)
          b.IDA("B", "", 5)
          b.IDA("B", "", 6)
          b.machine.first.flatmap{|m| m.sequence(:GS, :ST, :NNA) }.fetch
        end

        include_examples "123456"
      end

      context "immediately adjacent (because a closer sibling is not present)" do
        let(:b) do
          strict(
            Detail("2",
              Segment(50, NNA(), s_mandatory, bounded(1)),
              Segment(60, NNB(), s_mandatory, bounded(1)),
              Segment(70, IDA(), s_mandatory, unbounded)))
        end

        let(:m) do
          b.NNA(0)
          b.IDA("A", "", 1)
          b.IDA("A", "", 2)
          b.IDA("B", "", 3)
          b.IDA("A", "", 4)
          b.IDA("B", "", 5)
          b.IDA("B", "", 6)
          b.machine.first.flatmap{|m| m.sequence(:GS, :ST, :NNA) }.fetch
        end

        include_examples "123456"
      end

      context "not immediately adjacent" do
        let(:b) do
          strict(
            Detail("2",
              Segment(50, NNA(), s_mandatory, bounded(1)),
              Segment(60, NNB(), s_mandatory, bounded(1)),
              Segment(80, IDA(), s_mandatory, unbounded)))
        end

        let(:m) do
          b.NNA(0)
          b.NNB(1)
          b.IDA("A", "", 1)
          b.IDA("A", "", 2)
          b.IDA("B", "", 3)
          b.IDA("A", "", 4)
          b.IDA("B", "", 5)
          b.IDA("B", "", 6)
          b.machine.first.flatmap{|m| m.sequence(:GS, :ST, :NNA) }.fetch
        end

        include_examples "123456"
      end
    end

    context "when match is a nephew " do
      context "one level down" do
        context "in an immediately adjacent unqualified loop" do
          let(:b) do
            strict(
              Detail("2",
                Segment(50, NNA(), s_mandatory, bounded(1)),
                Loop("2000", unbounded,
                  Segment(60, IDA(), s_mandatory, bounded(1)))))
          end

          let(:m) do
            b.NNA(0)
            b.IDA("A", "", 1)
            b.IDA("A", "", 2)
            b.IDA("B", "", 3)
            b.IDA("A", "", 4)
            b.IDA("B", "", 5)
            b.IDA("B", "", 6)
            b.machine.first.flatmap{|m| m.sequence(:GS, :ST, :NNA) }.fetch
          end

          include_examples "123456"
        end

        context "in an immediately adjacent quailfied loop" do
          let(:b) do
            strict(
              Detail("2",
                Segment(50, NNA(), s_mandatory, bounded(1)),
                Loop("2000A", unbounded,
                  Segment(60, IDA(%w(A)), s_mandatory, bounded(1))),
                Loop("2000B", unbounded,
                  Segment(60, IDA(%w(B)), s_mandatory, bounded(1)))))
          end

          let(:m) do
            b.NNA(0)
            b.IDA("A", "", 1)
            b.IDA("A", "", 2)
            b.IDA("B", "", 3)
            b.IDA("A", "", 4)
            b.IDA("B", "", 5)
            b.IDA("B", "", 6)
            b.machine.first.flatmap{|m| m.sequence(:GS, :ST, :NNA) }.fetch
          end

          include_examples "123456"
        end

        context "in a non-adjacent unqualified loop" do
          let(:b) do
            strict(
              Detail("2",
                Segment(50, NNA(), s_mandatory, bounded(1)),
                Segment(60, NNB(), s_mandatory, bounded(1)),
                Loop("2000", unbounded,
                  Segment(70, IDA(), s_mandatory, bounded(1)))))
          end

          let(:m) do
            b.NNA(0)
            b.NNB(0)
            b.IDA("A", "", 1)
            b.IDA("A", "", 2)
            b.IDA("B", "", 3)
            b.IDA("A", "", 4)
            b.IDA("B", "", 5)
            b.IDA("B", "", 6)
            b.machine.first.flatmap{|m| m.sequence(:GS, :ST, :NNA) }.fetch
          end

          include_examples "123456"
        end

        context "in a non-adjacent quailfied loop" do
          let(:b) do
            strict(
              Detail("2",
                Segment(50, NNA(), s_mandatory, bounded(1)),
                Segment(60, NNB(), s_mandatory, bounded(1)),
                Loop("2000A", unbounded,
                  Segment(70, IDA(%w(A)), s_mandatory, bounded(1))),
                Loop("2000B", unbounded,
                  Segment(70, IDA(%w(B)), s_mandatory, bounded(1)))))
          end

          let(:m) do
            b.NNA(0)
            b.NNB(0)
            b.IDA("A", "", 1)
            b.IDA("A", "", 2)
            b.IDA("B", "", 3)
            b.IDA("A", "", 4)
            b.IDA("B", "", 5)
            b.IDA("B", "", 6)
            b.machine.first.flatmap{|m| m.sequence(:GS, :ST, :NNA) }.fetch
          end

          include_examples "123456"
        end
      end

      context "two levels down" do
        todo
      end
    end

    context "when match is a cousin" do
      context "in another loop" do
        context "one parent up" do
          let(:b) do
            strict(
              Detail("2",
                Loop("2000", unbounded,
                  Segment(50, NNA(), s_mandatory, bounded(1))),
                Loop("2100", unbounded,
                  Segment(60, IDA(), s_mandatory, bounded(1)))))
          end

          let(:m) do
            b.NNA(0)
            b.IDA("A", "", 1)
            b.IDA("A", "", 2)
            b.IDA("B", "", 3)
            b.IDA("A", "", 4)
            b.IDA("B", "", 5)
            b.IDA("B", "", 6)
            b.machine.first.flatmap{|m| m.sequence(:GS, :ST, :NNA) }.fetch
          end

          include_examples "123456"
        end

        context "two parents up" do
          let(:b) do
            strict(
              Detail("2",
                Loop("2000", bounded(1),
                  Segment(50, NNA(), s_mandatory, bounded(1)),
                  Loop("2100", bounded(1),
                    Segment(60, NNB(), s_mandatory, bounded(1)))),
                Loop("2100", unbounded,
                  Segment(70, IDA(), s_mandatory, bounded(1)))))
          end

          let(:m) do
            b.NNA(0)
            b.NNB(0)
            b.IDA("A", "", 1)
            b.IDA("A", "", 2)
            b.IDA("B", "", 3)
            b.IDA("A", "", 4)
            b.IDA("B", "", 5)
            b.IDA("B", "", 6)
            b.machine.first.flatmap{|m| m.sequence(:GS, :ST, :NNA, :NNB) }.fetch
          end

          include_examples "123456"
        end

        context "three parents up" do
          todo
        end
      end

      context "in another table" do
        context "one parent up" do
          context "which begins with a repeatable segment" do
            let(:b) do
              strict(
                Detail("2",
                  Segment(60, IDA(), s_mandatory, unbounded)))
            end

            let(:m) do
              b.IDA("A", "", 1)
              b.IDA("A", "", 2)
              b.IDA("B", "", 3)
              b.IDA("A", "", 4)
              b.IDA("B", "", 5)
              b.IDA("B", "", 6)
              b.machine.first.flatmap{|m| m.sequence(:GS, :ST) }.fetch
            end

            include_examples "123456"
          end

          context "which begins with an optional segment then a repeatable segment" do
            let(:b) do
              strict(
                Detail("2",
                  Segment(50, NNA(), s_optional,  bounded(1)),
                  Segment(60, IDA(), s_mandatory, unbounded)))
            end

            let(:m) do
              b.IDA("A", "", 1)
              b.IDA("A", "", 2)
              b.IDA("B", "", 3)
              b.IDA("A", "", 4)
              b.IDA("B", "", 5)
              b.IDA("B", "", 6)
              b.machine.first.flatmap{|m| m.sequence(:GS, :ST) }.fetch
            end

            include_examples "123456"
          end

          context "and each match is in a separate table" do
            let(:b) do
              strict(
                Detail("2A",
                  Segment(50, IDA(%w(A)), s_mandatory, bounded(1))),
                Detail("2B",
                  Segment(50, IDA(%w(B)), s_mandatory, bounded(1))))
            end

            let(:m) do
              b.IDA("A", "", 1)
              b.IDA("A", "", 2)
              b.IDA("B", "", 3)
              b.IDA("A", "", 4)
              b.IDA("B", "", 5)
              b.IDA("B", "", 6)
              b.machine.first.flatmap{|m| m.sequence(:GS, :ST) }.fetch
            end

            include_examples "123456"
          end

          context "and each match is in a loop within a separate table" do
            let(:b) do
              strict(
                Detail("2A",
                  Loop("2000A", unbounded,
                    Segment(50, IDA(%w(A)), s_mandatory, bounded(1)))),
                Detail("2B",
                  Loop("2000B", unbounded,
                    Segment(50, IDA(%w(B)), s_mandatory, bounded(1)))))
            end

            let(:m) do
              b.IDA("A", "", 1)
              b.IDA("A", "", 2)
              b.IDA("B", "", 3)
              b.IDA("A", "", 4)
              b.IDA("B", "", 5)
              b.IDA("B", "", 6)
              b.machine.first.flatmap{|m| m.sequence(:GS, :ST) }.fetch
            end

            include_examples "123456"
          end

          context "and all matches are in one table's sibling loops" do
            let(:b) do
              strict(
                Detail("2",
                  Loop("2000A", unbounded,
                    Segment(50, IDA(%w(A)).copy(:name => "A"), s_mandatory, bounded(1))),
                  Loop("2000B", unbounded,
                    Segment(50, IDA(%w(B)).copy(:name => "B"), s_mandatory, bounded(1)))))
            end

            let(:m) do
              b.IDA("A", "", 1)
              b.IDA("A", "", 2)
              b.IDA("B", "", 3)
              b.IDA("A", "", 4)
              b.IDA("B", "", 5)
              b.IDA("B", "", 6)
              b.machine.first.flatmap{|m| m.sequence(:GS, :ST) }.fetch
            end

            include_examples "123456"
          end

          context "which begins with an optional segment then sibling loops" do
            let(:b) do
              strict(
                Detail("2",
                  Segment(50, NNA(), s_optional, bounded(1)),
                  Loop("2000A", unbounded,
                    Segment(60, IDA(%w(A)), s_mandatory, bounded(1))),
                  Loop("2000B", unbounded,
                    Segment(60, IDA(%w(B)), s_mandatory, bounded(1)))))
            end

            let(:m) do
              b.IDA("A", "", 1)
              b.IDA("A", "", 2)
              b.IDA("B", "", 3)
              b.IDA("A", "", 4)
              b.IDA("B", "", 5)
              b.IDA("B", "", 6)
              b.machine.first.flatmap{|m| m.sequence(:GS, :ST) }.fetch
            end

            include_examples "123456"
          end

          context "which begins with a required segment then sibling loops" do
            let(:b) do
              strict(
                Detail("2",
                  Segment(50, NNA(), s_mandatory, bounded(1)),
                  Loop("2000A", unbounded,
                    Segment(60, IDA(%w(A)), s_mandatory, bounded(1))),
                  Loop("2000B", unbounded,
                    Segment(60, IDA(%w(B)), s_mandatory, bounded(1)))))
            end

            let(:m) do
              b.NNA(0)
              b.IDA("A", "", 1)
              b.IDA("A", "", 2)
              b.IDA("B", "", 3)
              b.IDA("A", "", 4)
              b.IDA("B", "", 5)
              b.IDA("B", "", 6)
              b.machine.first.flatmap{|m| m.sequence(:GS, :ST) }.fetch
            end

            it "does not find an unqualified match" do
              expect(m).to_not be_able_to_find(:IDA)
            end

            it "does not find an qualified match" do
              expect(m).to_not be_able_to_find(:IDA, "A")
              expect(m).to_not be_able_to_find(:IDA, "B")
            end
          end
        end
      end
    end

    context "when match is an uncle" do
      context "one parent up" do
        let(:b) do
          strict(
            Detail("2",
              Segment(50, NNA(), s_mandatory, bounded(1)),
              Loop("2000", unbounded,
                Segment(50, NNB(), s_mandatory, bounded(1))),
              Segment(70, IDA(), s_mandatory, unbounded)))
        end

        let(:m) do
          b.NNA(0)
          b.NNB(0)
          b.IDA("A", "", 1)
          b.IDA("A", "", 2)
          b.IDA("B", "", 3)
          b.IDA("A", "", 4)
          b.IDA("B", "", 5)
          b.IDA("B", "", 6)
          b.machine.first.flatmap{|m| m.sequence(:GS, :ST, :NNA, :NNB) }.fetch
        end

        include_examples "123456"
      end

      context "two parents up" do
        let(:b) do
          strict(
            Detail("2",
              Loop("2000", unbounded,
                Segment(60, NNA(), s_mandatory, bounded(1)),
                Loop("2010", unbounded,
                  Segment(50, NNB(), s_mandatory, bounded(1))),
              Segment(70, IDA(), s_mandatory, unbounded))))
        end

        let(:m) do
          b.NNA(0)
          b.NNB(0)
          b.IDA("A", "", 1)
          b.IDA("A", "", 2)
          b.IDA("B", "", 3)
          b.IDA("A", "", 4)
          b.IDA("B", "", 5)
          b.IDA("B", "", 6)
          b.machine.first.flatmap{|m| m.sequence(:GS, :ST, :NNA, :NNB) }.fetch
        end

        include_examples "123456"
      end

      context "three parents up" do
        todo
      end
    end

  end

  todo "#find!"

  todo "#iterate"

  todo "#sequence"

  todo "#segmentn"

  todo "#elementn"

  todo "#successors"

  todo "#distance"

  todo "#first"

  todo "#last"

  todo "#parent"

  todo "#next"

  todo "#prev"

  todo "#count"
end
