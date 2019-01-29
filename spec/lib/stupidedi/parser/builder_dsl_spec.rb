describe Stupidedi::Parser::BuilderDsl, "strict validation" do
  using Stupidedi::Refinements
  include Definitions

  let(:id) { Stupidedi::Parser::IdentifierStack.new(1)  }

  def strict(*details)
    start_transaction_set(details, true)
  end

  def relaxed(*details)
    start_transaction_set(details, false)
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

  describe "on interchanges" do
    context "with unregistered version (ISA12)" do
      todo "raises an exception"
    end

    context "with registered version (ISA12)" do
      todo "is a-ok"
    end

    context "when repeated" do
      context "at the end of an interchange" do
        todo "is a-ok"
      end

      context "in the middle of an interchange" do
        todo "raises an exception"
      end
    end
  end

  describe "on functional groups" do
    context "with unregistered version (GS08)" do
      todo "raises an exception"
    end

    context "with registered version (GS08)" do
      todo "constructions a functional group"
    end

    context "when repeated" do
      context "at the end of a functional group" do
        todo "is a-ok"
      end

      context "in the middle of a functional group" do
        todo "raises an exception"
      end
    end
  end

  describe "on transaction sets" do
    context "given GS01 + GS08 + ST01" do
      context "when unregistered" do
        todo "raises an exception"
      end

      context "when registered" do
        todo "constructions a transaction set"
      end
    end

    context "given GS01 + ST01 + ST03" do
      context "when unregistered" do
        todo "raises an exception"
      end

      context "when registered" do
        todo "constructions a transaction set"
      end
    end

    context "given GS01 + GS08 + ST01 + ST03" do
      todo "GS08 is ignored in favor of ST03"
    end
  end

  describe "on tables" do
    context "alternating between siblings (#172)" do
      todo "constructs sibling tables"
    end

    context "when not required" do
      todo "but present"
      todo "and missing"
    end

    context "when required" do
      todo "and present"
      todo "but missing"
    end

    context "when too few are present" do
      it "raises an exception" do
        b = strict(
          Detail("2",
            Segment(10, NNA(), s_mandatory, bounded(1))))

        expect(lambda{ b.SE(id.count(b), id.pop_st).GE(id.count, id.pop_gs) }).to \
          raise_error(/required table 2 is missing/)
      end

      todo "raises an exception immediately" do
        b = strict(
          Detail("2",
            Segment(10, NNA(), s_mandatory, bounded(1))))

        expect(lambda{ b.SE(id.count(b), id.pop_st) }).to \
          raise_error(/required table 2 is missing/)
      end

      it "raises an exception" do
        b = strict(
          Detail("2",
            Loop("2000", bounded(2),
              Segment(10, NNA(), s_mandatory, bounded(1)))))

        expect(lambda{ b.SE(id.count(b), id.pop_st).GE(id.count, id.pop_gs) }).to \
          raise_error(/required table 2 is missing/)
      end

      todo "raises an exception immediately" do
        b = strict(
          Detail("2",
            Loop("2000", bounded(2),
              Segment(10, NNA(), s_mandatory, bounded(1)))))

        expect(lambda{ b.SE(id.count(b), id.pop_st) }).to \
          raise_error(/required table 2 is missing/)
      end
    end

    context "when too many are present" do
      let(:b) do
        strict(
          Detail("2a", Segment(10, NNB(), s_optional, unbounded)),
          Detail("2b", Segment(20, NNA(), s_optional, unbounded))).NNB(0).NNA(1)
      end

      it "raises an exception" do
        expect(lambda{ b.NNB(0).SE(id.count(b), id.pop_st).GE(id.count, id.pop_gs) }).to \
          raise_error(/table 2a occurs too many times/)
      end

      todo "raises an exception immediately" do
        expect(lambda{ b.NNB(0) }).to \
          raise_error(/table 2a occurs too many times/)
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
      todo "are constructed when start segment repeats" do
        b = strict(
          Detail("2",
            Loop("2000", unbounded,
              Segment(10, NNA(), s_optional, bounded(1)))))

        b.NNA(1)
        b.NNA(2)
      end

      todo "are constructed when start segment occurs" do
        b = strict(
          Detail("2",
            Loop("2000", unbounded,
              Segment(10, NNA(), s_optional, bounded(1)))))

        b.NNA(1)
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
        expect(lambda{ b.NNA(2) }).to \
          raise_error(/NNA.+? cannot occur here/)
      end

      it "raises an exception" do
        b = strict(
          Detail("2",
            Loop("2000", bounded(2),
              Segment(10, NNA(), s_optional, bounded(1)))))

        b.NNA(1)
        b.NNA(2)

        expect(lambda{ b.NNA(3).SE(id.count(b), id.pop_st).GS(id.count, id.pop_gs) }).to \
          raise_error(/loop 2000 occurs too many times/)
      end

      todo "raises an exception immediately" do
        b = strict(
          Detail("2",
            Loop("2000", bounded(2),
              Segment(10, NNA(), s_optional, bounded(1)))))

        b.NNA(1)
        b.NNA(2)

        expect(lambda{ b.NNA(3) }).to \
          raise_error(/loop 2000 occurs too many times/)
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

        expect(lambda{ b.SE(id.count(b), id.pop_st) }).to \
          raise_error(/required loop 2000 is missing/)
      end
    end
  end

  describe "on segments" do
    context "when shouldn't occur but is present" do
      it "raises an exception" do
        b = strict(
          Detail("2",
            Segment(10, NNA(), s_optional, bounded(1))))

        expect(lambda{ b.NNB(0) }).to \
          raise_error(/segment NNB.*? cannot occur/)
      end

      it "raises an exception" do
        b = strict(
          Detail("2",
            Segment(10, NNA(), s_optional, bounded(1))))

        expect(lambda{ b.ANA("123 MAIN") }).to \
          raise_error(/segment ANA\*123 MAIN~ cannot occur/)
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
        expect(lambda{ b.SE(id.count(b), id.pop_st) }).to \
          raise_error(/segment NNA .+? is missing/)
      end

      pending "raises an exception immediately" do
        # This validation is delayed until this loop is "closed". It would be
        # an improvement for the error to happen immediately, like this:
        expect(lambda{ b.ANA("123 MAIN") }).to \
          raise_error(/segment NNA .+? is missing/)
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

        expect(lambda{ b.NNA(3).SE(id.count(b), id.pop_st) }).to \
          raise_error(/segment NNA .+? occurs too many times/)
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
          expect(lambda{ b.XX(1) }).not_to raise_error
        end
      end

      context "and missing" do
        it "not given is a-ok" do
          expect(lambda{ b.XX }).not_to raise_error
        end

        it "b.blank is a-ok" do
          expect(lambda{ b.XX(b.blank) }).not_to raise_error
        end

        it "b.not_used raises exception" do
          expect(lambda{ b.XX(b.not_used) }).to raise_error(/XX01 is not forbidden/)
        end

        it "nil is a-ok" do
          expect(lambda{ b.XX(nil) }).not_to raise_error
        end

        it "'' is a-ok" do
          expect(lambda{ b.XX('') }).not_to raise_error
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
          expect(lambda{ b.XX(1) }).not_to raise_error
        end
      end

      context "and missing" do
        it "not given raises an exception" do
          expect(lambda{ b.XX }).to raise_error(/required element XX01 .+? is blank/)
        end

        it "b.not_used raises an exception" do
          expect(lambda{ b.XX(b.not_used) }).to raise_error(/XX01 is not forbidden/)
        end

        it "b.blank raises an exception" do
          expect(lambda{ b.XX(b.blank) }).to raise_error(/required element XX01 .+? is blank/)
        end

        it "nil raises an exception" do
          expect(lambda{ b.XX(nil) }).to raise_error(/required element XX01 .+? is blank/)
        end

        it "'' raises an exception" do
          expect(lambda{ b.XX('') }).to raise_error(/required element XX01 .+? is blank/)
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
          expect(lambda{ b.XX(1) }).to raise_error(/forbidden element XX01 .+? is present/)
        end
      end

      context "and missing" do
        it "not given is a-ok" do
          expect(lambda{ b.XX }).not_to raise_error
        end

        it "b.not_used is a-ok" do
          expect(lambda{ b.XX(b.not_used) }).not_to raise_error
        end

        it "b.blank is a-ok" do
          expect(lambda{ b.XX(b.blank) }).not_to raise_error
        end

        it "nil is a-ok" do
          expect(lambda{ b.XX(nil) }).not_to raise_error
        end

        it "'' is a-ok" do
          expect(lambda{ b.XX("") }).not_to raise_error
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
              expect(lambda{ b.XX(5, 5, 5) }).not_to raise_error
            end
          end

          context "but missing" do
            it "raises an exception" do
              expect(lambda{ b.XX(5, nil, 5) }).to raise_error(/, elements? 2 must be present/)
            end

            it "raises an exception" do
              expect(lambda{ b.XX(5, 5, nil) }).to raise_error(/, elements? 3 must be present/)
            end
          end
        end

        context "not required" do
          context "and missing" do
            it "is a-ok" do
              expect(lambda{ b.XX(5) }).not_to raise_error
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
            expect(lambda{ b.XX(5, 5, 5) }).not_to raise_error
          end

          it "is a-ok" do
            expect(lambda{ b.XX(5, nil, 5) }).not_to raise_error
          end

          it "is a-ok" do
            expect(lambda{ b.XX(5, 5, nil) }).not_to raise_error
          end
        end

        context "but missing" do
          it "raises an exception" do
            expect(lambda{ b.XX(5) }).to raise_error(/, at least one of elements 2, 3 must be present/)
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
              expect(lambda{ b.XX(5, 5, 5) }).not_to raise_error
            end
          end

          context "but missing" do
            it "raises an exception" do
              expect(lambda{ b.XX(5, 5, nil) }).to raise_error(/, elements 3 must be present/)
            end
          end
        end

        context "not required" do
          context "but present" do
            it "is a-ok" do
              expect(lambda{ b.XX(5, nil, 5) }).not_to raise_error
            end
          end

          context "and missing" do
            it "is a-ok" do
              expect(lambda{ b.XX(5, nil, nil) }).not_to raise_error
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
              expect(lambda{ b.XX(5, 5, 5) }).not_to raise_error
            end

            it "is a-ok" do
              expect(lambda{ b.XX(5, nil, 5) }).not_to raise_error
            end

            it "is a-ok" do
              expect(lambda{ b.XX(5, 5, nil) }).not_to raise_error
            end
          end

          context "but missing" do
            it "raises an exception" do
              expect(lambda{ b.XX(5, nil, nil) }).to raise_error(/at least one of elements 2, 3 must be present/)
            end
          end
        end

        context "and not required" do
          context "but present" do
            it "is a-ok" do
              expect(lambda{ b.XX(nil, nil, 5) }).not_to raise_error
            end

            it "is a-ok" do
              expect(lambda{ b.XX(nil, 5, nil) }).not_to raise_error
            end

            it "is a-ok" do
              expect(lambda{ b.XX(nil, 5, 5) }).not_to raise_error
            end
          end

          context "and missing" do
            it "is a-ok" do
              expect(lambda{ b.XX }).not_to raise_error
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

        expect(lambda { b.ANA("X") }).to raise_error(/value is too short in element ANA01/)
      end
    end

    context "when too long" do
      it "raises an exception" do
        b = strict(Detail("2",
          Segment(10, ANA(:max_length => 2), s_mandatory, bounded(1))))

        expect(lambda { b.ANA("WXYZ") }).to raise_error(/value is too long in element ANA01/)
      end
    end

    context "simple" do
      context "AN (string)" do
        let(:b) do
          strict(Detail("2", Segment_(10, :XX, "Example", s_mandatory, bounded(1),
            Element(de_AN.copy(:min_length => 2, :max_length => 4), e_mandatory, bounded(1)))))
        end

        context "when given a Date" do
          it "raises an exception" do
            expect(lambda { b.XX(Date.today) }).to raise_error(/invalid element XX01/)
          end
        end

        context "when given a Time" do
          it "raises an exception" do
            expect(lambda { b.XX(Date.today) }).to raise_error(/invalid element XX01/)
          end
        end
      end

      context "DT (date)" do
        shared_examples "2345" do
          context "given a Time" do
            it "is a-ok" do
              expect(lambda { b.XX(Time.now) }).not_to raise_error
            end
          end

          context "given a Date" do
            it "is a-ok" do
              expect(lambda { b.XX(Date.today) }).not_to raise_error
            end
          end

          context "given a String with a 3-digit year" do
            it "raises an exception" do
              expect(lambda { b.XX("9990130") }).to raise_error(/invalid element XX01/)
            end
          end

          context "given a String with a 4-digit year" do
            it "raises an exception" do
              expect(lambda { b.XX("19990130") }).to_not raise_error
            end
          end

          context "given a String with a 5-digit year" do
            it "raises an exception" do
              expect(lambda { b.XX("019990130") }).to_not raise_error
            end
          end

          context "given a value that responds to #year, #month, and #day" do
            context "with a valid date" do
              it "is a-ok" do
                value = OpenStruct.new(:year => 2000, :month => 12, :day => 30)
                expect(lambda { b.XX(value) }).to_not raise_error
              end
            end

            context "with an invalid date" do
              it "raises an exception" do
                value = OpenStruct.new(:year => 2000, :month => 13, :day => 33)
                expect(lambda { b.XX(value) }).to raise_error(/invalid element XX01/)
              end
            end
          end

          context "given some other type of value" do
            it "raises an exception" do
              expect(lambda { b.XX(20001231) }).to raise_error(/invalid element XX01/)
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
            it "raises an exception" do
              expect(lambda { b.XX("990130") }).not_to raise_error
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
              expect(lambda { b.XX("990130") }).to raise_error(/value is too short in element XX01/)
            end
          end
        end
      end

      context "ID (identifier)" do
        let(:b) do
          strict(Detail("2", Segment_(10, :XX, "Example", s_mandatory, bounded(1),
            Element(dE_ID, e_mandatory, bounded(1)))))
        end

        todo
      end

      context "Nn (fixed precision number)" do
        let(:b) do
          strict(Detail("2", Segment_(10, :XX, "Example", s_mandatory, bounded(1),
            Element(dE_N0, e_mandatory, bounded(1)))))
        end

        todo
      end

      context "TM (time)" do
        let(:b) do
          strict(Detail("2", Segment_(10, :XX, "Example", s_mandatory, bounded(1),
            Element(dE_TM, e_mandatory, bounded(1)))))
        end

        todo
      end

      context "R (floating precision number)" do
        let(:b) do
          strict(Detail("2", Segment_(10, :XX, "Example", s_mandatory, bounded(1),
            Element(dE_R, e_mandatory, bounded(1)))))
        end

        todo
      end
    end

    todo "composite"

    context "repeating" do
      todo "simple"

      todo "composite"
    end
  end
end
