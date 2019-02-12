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

  context "with an empty tree" do
    let(:m) { Stupidedi::Parser::BuilderDsl.build(config([]), true).machine }

    describe "#empty?" do
      specify { expect(m).to be_empty }
    end

    describe "#first?" do
      specify { expect(m).to be_first }
    end

    describe "#last?" do
      specify { expect(m).to be_last }
    end

    describe "#first" do
      specify { expect(m.first).to be_failure }
    end

    describe "#last" do
      specify { expect(m.last).to be_failure }
    end

    describe "#successors" do
      specify { expect(m.successors.head).to be_a(Stupidedi::Parser::InstructionTable) }
    end

    describe "#parent" do
      specify { expect(m.parent).to be_failure }
    end

    describe "#next" do
      specify { expect(m.next).to be_failure }
    end

    describe "#prev" do
      specify { expect(m.prev).to be_failure }
    end
  end

  context "with a non-empty tree" do
    let(:m) { strict.machine }

    describe "#empty?" do
      specify { expect(m).to_not be_empty }
    end

    describe "#first?" do
      specify { expect(m).to_not be_first }
    end

    describe "#last?" do
      specify { expect(m).to be_last }
    end

    describe "#first" do
      specify { expect(m.first.fetch).to be_first }
      specify { expect(m.first.fetch).to_not be_last }
    end

    describe "#last" do
      specify { expect(m.last.fetch).to_not be_first }
      specify { expect(m.last.fetch).to be_last }
    end

    describe "#successors" do
      specify { expect(m.successors.head).to be_a(Stupidedi::Parser::InstructionTable) }
    end

    describe "#parent" do
      specify { expect(m.parent).to be_success }
      specify { expect(m.parent.fetch).to_not be_first }
      specify { expect(m.parent.flatmap(&:parent).fetch).to be_first }
      specify { expect(m.parent.flatmap(&:parent).flatmap(&:parent)).to be_failure }
    end

    describe "#next" do
      specify { expect(m.next).to be_failure }
      specify { expect(m.first.flatmap{|x| x.next    }).to be_success } # GS
      specify { expect(m.first.flatmap{|x| x.next(1) }).to be_success } # GS
      specify { expect(m.first.flatmap{|x| x.next(2) }).to be_success } # ST
      specify { expect(m.first.flatmap{|x| x.next(3) }).to be_failure }
    end

    describe "#prev" do
      specify { expect(m.prev).to be_success } # GS
      specify { expect(m.prev(1)).to be_success } # GS
      specify { expect(m.prev(2)).to be_success } # ISA
      specify { expect(m.prev(3)).to be_failure }
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

    context "when matching a simple element" do
      let(:b) do
        strict(
          Detail("2",
            Segment(50, NNA(), s_mandatory, unbounded)))
      end

      let(:m) do
        b.NNA(0)
        b.NNA(1)
        b.machine.first.flatmap{|m| m.sequence(:GS, :ST) }.fetch
      end

      context "and element does match" do
        it "returns success" do
          expect(m.find(:NNA, nil)).to be_success
          expect(m.find(:NNA, 0)).to be_success
          expect(m.find(:NNA, 1)).to be_success
        end
      end

      context "and element doesn't match" do
        it "returns failure" do
          expect(m.find(:NNA, 2)).to be_failure
        end
      end
    end

    context "when matching a composite element" do
      let(:b) do
        strict(
          Detail("2",
            Segment(50, COM(), s_mandatory, unbounded)))
      end

      let(:m) do
        b.COM(b.composite(0, 1, 2))
        b.COM(b.composite(3, 4, 5))
        b.machine.first.flatmap{|m| m.sequence(:GS, :ST) }.fetch
      end

      context "and element does match" do
        it "returns success" do
          expect(m.find(:COM)).to be_success

          expect(m.find(:COM, m.composite(0))).to be_success
          expect(m.find(:COM, m.composite(3))).to be_success

          expect(m.find(:COM, m.composite(nil, 1))).to be_success
          expect(m.find(:COM, m.composite(nil, 4))).to be_success

          expect(m.find(:COM, m.composite(nil, nil, 2))).to be_success
          expect(m.find(:COM, m.composite(nil, nil, 5))).to be_success
        end
      end

      context "and element doesn't match" do
        it "returns failure" do
          expect(m.find(:COM, m.composite(9))).to be_failure(/COM\*9~ does not occur/)
          expect(m.find(:COM, m.composite(1, 9))).to be_failure(/COM\*1:9~ does not occur/)
          expect(m.find(:COM, m.composite(1, 2, 9))).to be_failure(/COM\*1:2:9~ does not occur/)
        end
      end
    end

    todo "when matching a repeating element"
  end

  todo "#find!"

  context "#iterate" do
    shared_examples "123456" do
      it "iterates in order of occurrence" do
        ms = m.iterate(:NNA){|m| m }
        expect(ms).to be_success
        expect(ms.fetch.length).to eq(6)
        expect(ms.fetch[0]).to be_segment(:NNA, 1)
        expect(ms.fetch[1]).to be_segment(:NNA, 2)
        expect(ms.fetch[2]).to be_segment(:NNA, 3)
        expect(ms.fetch[3]).to be_segment(:NNA, 4)
        expect(ms.fetch[4]).to be_segment(:NNA, 5)
        expect(ms.fetch[5]).to be_segment(:NNA, 6)
      end

      it "returns values computed at each occurrence" do
        n = 0
        expect(m.iterate(:NNA){ n+=1 }).to be_success([1,2,3,4,5,6])
      end
    end

    context "on repeatable loop first segment" do
      let(:b) do
        strict(
          Detail("2",
            Loop("2000", unbounded,
              Segment(50, NNA(), s_mandatory, bounded(1)))))
      end

      let(:m) do
        b.NNA(1)
        b.NNA(2)
        b.NNA(3)
        b.NNA(4)
        b.NNA(5)
        b.NNA(6)
        b.machine.first.flatmap{|m| m.sequence(:GS, :ST) }.fetch
      end

      include_examples "123456"
    end

    context "on non-repeatable loop first segment" do
      let(:b) do
        strict(
          Detail("2",
            Loop("2000", bounded(1),
              Segment(50, NNA(), s_mandatory, bounded(1)))))
      end

      it "raises an exception" do
        expect(lambda { b.machine.iterate(:NNA) }).to \
          raise_error(/segment NNA~ is not repeatable/)
      end
    end

    context "on repeatble table entry segment" do
      let(:b) do
        strict(
          Detail("2",
            Segment(50, NNA(), s_mandatory, unbounded)))
      end

      let(:m) do
        b.NNA(1)
        b.NNA(2)
        b.NNA(3)
        b.NNA(4)
        b.NNA(5)
        b.NNA(6)
        b.machine.first.flatmap{|m| m.sequence(:GS, :ST) }.fetch
      end

      include_examples "123456"
    end

    context "on non-repeatable table entry segment" do
      let(:b) do
        strict(
          Detail("2",
            Segment(50, NNA(), s_mandatory, bounded(1))))
      end

      it "raises an exception" do
        expect(lambda { b.machine.iterate(:NNA) }).to \
          raise_error(/segment NNA~ is not repeatable/)
      end
    end
  end

  context "#segmentn" do
    context "when syntax tree is empty" do
      let(:m) { Stupidedi::Parser::BuilderDsl.build(config([]), true).machine }

      it "returns failure" do
        expect(m.segmentn).to be_failure(/not a segment/)
      end
    end

    context "when syntax tree is not empty" do
      let(:m) { strict.machine }

      it "returns failure" do
        expect(m.segmentn.fetch).to be_segment(:ST)
      end
    end
  end

  context "#elementn" do
    let(:b) do
      strict(
        Detail("2",
          Segment(50, NNA(), s_optional, unbounded),
          Segment(60, COM(), s_optional, unbounded),
          Segment(70, COR(), s_optional, unbounded),
          Segment(80, REP(), s_optional, unbounded)))
    end

    context "(m)" do
      context "when m is not positive" do
        it "raises an exception" do
          expect { b.machine.elementn(0) }.to raise_error(/positive/)
        end
      end

      context "when mth element cannot occur" do
        it "raises an exception" do
          expect { b.NNA(1).machine.elementn(9) }.to raise_error(/has only 2 elements/)
        end
      end

      context "when mth element does not occur" do
        it "returns an empty value" do
          result = b.NNA(1).machine.elementn(2)
          expect(result).to be_success(&:blank?)
        end
      end

      context "when mth element is simple" do
        it "returns the value" do
          result = b.NNA(1).machine.elementn(1)
          expect(result).to be_success(&:element?)
          expect(result).to be_success(&:simple?)
          expect(result).to be_success(&:numeric?)
          expect(result).to be_success(1)
        end
      end

      context "when mth element is composite" do
        it "returns the value" do
          result = b.COM(b.composite(1, 2, 3)).machine.elementn(1)
          expect(result).to be_success(&:element?)
          expect(result).to be_success(&:composite?)
        end
      end

      context "when mth element is repeating" do
        it "returns the value" do
          result = b.REP(b.repeated(1, 2, 3, 4)).machine.elementn(1)
          expect(result).to be_success(&:element?)
          expect(result).to be_success(&:repeated?)
        end
      end
    end

    context "(m, n)" do
      context "when mth element is simple" do
        it "raises an exception" do
          expect { b.NNA(1).machine.elementn(1, 1) }.to \
            raise_error(/NNA01 is not a composite or repeated element/)
        end
      end

      context "when mth element is composite" do
        context "when n is not positive" do
          it "raises an exception" do
            expect { b.COM.machine.elementn(1, 0) }.to raise_error(/positive/)
          end
        end

        context "when nth component does not occur" do
          it "returns an empty value" do
            result = b.COM(b.composite(1, 2)).machine.elementn(1, 3)
            expect(result).to be_success(&:blank?)
          end
        end

        context "when nth component cannot occur" do
          it "raises an exception" do
            expect { b.COM(b.composite(1, 2)).machine.elementn(1, 5) }.to \
              raise_error(/composite element COM01 only has 3 components/)
          end
        end

        context "when nth component occurs" do
          it "returns the value" do
            result = b.COM(b.composite(1, 3, 5)).machine.elementn(1, 2)
            expect(result).to be_success(&:element?)
            expect(result).to be_success(&:component?)
            expect(result).to be_success(&:numeric?)
            expect(result).to be_success(3)
          end
        end
      end

      context "when mth element is repeating" do
        context "when n is not positive" do
          it "raises an exception" do
            expect { b.REP.machine.elementn(1, 0) }.to raise_error(/positive/)
          end
        end

        context "when mth element does not occur" do
          it "returns a failure" do
            result = b.COR.machine.elementn(1, 2)
            expect(result).to be_failure(/repeatable composite element COR01 does not occur/)
          end
        end

        context "when nth element does not occur" do
          it "returns a failure" do
            result = b.REP(b.repeated(3)).machine.elementn(1, 2)
            expect(result).to be_failure(/repeatable element REP01 only occurs 1 times/)
          end
        end

        context "when nth element cannot occur" do
          it "raises an exception" do
            expect { b.REP(b.repeated(1)).machine.elementn(1, 5) }.to \
              raise_error(/repeatable element REP01 can only occur 3 times/)
          end
        end

        context "when nth element occurs" do
          it "returns the value" do
            result = b.REP(b.repeated(3, 4, 5)).machine.elementn(1, 3)
            expect(result).to be_success(&:element?)
            expect(result).to be_success(&:simple?)
            expect(result).to be_success(&:numeric?)
            expect(result).to be_success(5)
          end
        end
      end
    end

    context "(m, n, o)" do
      context "when n is nil and o is not" do
        it "raises an exception" do
          expect { b.NNA(0).machine.elementn(1, nil, 1) }.to \
            raise_error(/third argument cannot be present unless second argument is present/)
        end
      end

      context "when mth element is simple" do
        it "raises an exception" do
          expect { b.NNA(1).machine.elementn(1, 1, 1) }.to \
            raise_error(/NNA01 is not a composite or repeated element/)
        end
      end

      context "when mth element is not repeating" do
        it "raises an exception" do
          expect { b.COM.machine.elementn(1, 1, 1) }.to \
            raise_error(/component element COM01-01 cannot be further deconstructed/)
        end
      end

      context "when mth element is a repeating simple element" do
        it "raises an exception" do
          expect { b.REP.machine.elementn(1, 1, 1) }.to \
            raise_error(/repeatable element REP01 cannot be further deconstructed/)
        end
      end

      context "when mth element is a repeating composite" do
        context "when o is not positive" do
          it "raises and exception" do
            expect { b.COR.machine.elementn(1, 1, 0) }.to raise_error(/positive/)
          end
        end

        context "when mth element has no occurences" do
          it "returns a failure" do
            result = b.COR.machine.elementn(1, 2, 1)
            expect(result).to be_failure(/repeatable composite element COR01 does not occur/)
          end
        end

        context "when nth repeat does not occur" do
          it "returns an empty value" do
            result = b.COR(b.repeated(b.composite(9, 8, 7))).machine.elementn(1, 2, 3)
            expect(result).to be_failure(/repeatable composite element COR01 only occurs 1 times/)
          end
        end

        context "when nth repeat is blank" do
          it "returns an empty value" do
            result = b.COR(b.repeated(nil, b.composite(9, 8, 7))).machine.elementn(1, 1, 3)
            expect(result).to be_success(&:element?)
            expect(result).to be_success(&:component?)
            expect(result).to be_success(&:numeric?)
            expect(result).to be_success(&:blank?)
          end
        end

        context "when oth component does not occur" do
          it "returns an empty value" do
            result = b.COR(b.repeated(b.composite(1, 2))).machine.elementn(1, 1, 3)
            expect(result).to be_success(&:element?)
            expect(result).to be_success(&:component?)
            expect(result).to be_success(&:numeric?)
            expect(result).to be_success(&:blank?)
          end
        end

        context "when oth component cannot occur" do
          it "returns an empty value" do
            expect { b.COR.machine.elementn(1, 1, 5) }.to \
              raise_error(/repeatable composite element COR01 only has 3 components/)
          end
        end

        context "when oth component does occur" do
          it "returns the value" do
            result = b.COR(b.repeated(b.composite(9, 8, 7))).machine.elementn(1, 1, 3)
            expect(result).to be_success(&:element?)
            expect(result).to be_success(&:component?)
            expect(result).to be_success(&:numeric?)
            expect(result).to be_success(7)
          end

          it "returns the value" do
            result = b.COR(b.repeated(nil, b.composite(9, 8, 7))).machine.elementn(1, 2, 3)
            expect(result).to be_success(&:element?)
            expect(result).to be_success(&:component?)
            expect(result).to be_success(&:numeric?)
            expect(result).to be_success(7)
          end
        end
      end
    end
  end

  todo "#sequence"

  todo "#successors"

  todo "#distance"

  todo "#first"

  todo "#last"

  todo "#parent"

  todo "#next"

  todo "#prev"

  todo "#count"
end
