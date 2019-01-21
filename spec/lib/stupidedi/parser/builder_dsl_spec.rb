describe Stupidedi::Parser::Generation, "strict validation" do
  using Stupidedi::Refinements
  include NavigationMatchers
  include Definitions

  let(:id) { Stupidedi::Parser::IdentifierStack.new(1)  }

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
        b = strict(Detail("2", Segment(10, :LX, s_mandatory, bounded(1))))

        expect(lambda{ b.SE(id.count(b), id.pop_st) }).to \
          raise_error(/required table 2 is missing/)
      end

      it "raises an exception" do
        b = strict(Detail("2",
                     Loop("2000", bounded(2),
                       Segment(10, :LX, s_mandatory, bounded(1)))))

        expect(lambda{ b.SE(id.count(b), id.pop_st) }).to \
          raise_error(/required table 2 is missing/)
      end
    end

    context "when too many are present" do
      let(:b) do
        strict(Detail("2a", Segment(10, :LQ, s_optional, unbounded)),
               Detail("2b", Segment(20, :LX, s_optional, unbounded))).LQ.LX(1)
      end

      it "raises an exception" do
        expect(lambda{ b.LQ.SE(id.count(b), id.pop_st) }).to \
          raise_error(/table 2a occurs too many times/)
      end

      pending "raises an exception immediately" do
        # This validation is delayed until this loop is "closed". It would be
        # an improvement for the error to happen immediately, like this:
        expect(lambda{ b.LQ }).to \
          raise_error(/table 2a occurs too many times/)
      end
    end
  end

  describe "on loops" do
    context "when correct number are present" do
      todo "are constructed when start segment repeats" do
        b = strict(Detail("2",
                     Loop("2000", unbounded,
                       Segment(10, :LX, s_optional, bounded(1)))))
        b.LX(1)
        b.LX(2)
      end

      todo "are constructed when start segment occurs" do
        b = strict(Detail("2",
                     Loop("2000", unbounded,
                       Segment(10, :LX, s_optional, bounded(1)))))
        b.LX(1)
      end
    end

    context "when too many are present" do
      it "raises an exception" do
        b = strict(Detail("2",
                     Loop("2000", bounded(1),
                       Segment(10, :LX, s_optional, bounded(1)))))
        b.LX(1)

        # The parser throws away the {Instruction} for LX once it's executed, so
        # it doesn't even allow an extra one to occur. This error occurs before
        # the "loop 2000 occurs too many times" error
        expect(lambda{ b.LX(2) }).to \
          raise_error(/LX.+? cannot occur here/)
      end

      it "raises an exception" do
        b = strict(Detail("2",
                     Loop("2000", bounded(2),
                       Segment(10, :LX, s_optional, bounded(1)))))
        b.LX(1)
        b.LX(2)

        expect(lambda{ b.LX(3) }).to \
          raise_error(/loop 2000 occurs too many times/)
      end
    end

    context "too few are present" do
      it "raises an exception" do
        b = strict(Detail("2",
                     Segment(10, :LQ, s_optional, bounded(1)),
                     Loop("2000", bounded(2),
                       Segment(20, :LX, s_mandatory, bounded(1)))))
        b.LQ

        expect(lambda{ b.SE(id.count(b), id.pop_st) }).to \
          raise_error(/required loop 2000 is missing/)
      end
    end
  end

  describe "on segments" do
    context "when shouldn't occur but is present" do
      it "raises an exception" do
        b = strict(Detail("2", Segment(10, :LX, s_optional, bounded(1))))
        expect(lambda{ b.LQ }).to \
          raise_error(/segment LQ.*? cannot occur/)
      end

      it "raises an exception" do
        b = strict(Detail("2", Segment(10, :LX, s_optional, bounded(1))))
        expect(lambda{ b.N3("123 MAIN ST") }).to \
          raise_error(/segment N3\*123 MAIN ST~ cannot occur/)
      end
    end

    context "when too few are present" do
      let(:b) do
        strict(Detail("2",
                     Segment(10, :LQ, s_mandatory, bounded(1)),
                     Segment(20, :LX, s_mandatory, bounded(1)),
                     Segment(30, :N3, s_optional,  bounded(1)))).LQ
      end

      it "raises an exception" do
        expect(lambda{ b.SE(id.count(b), id.pop_st) }).to \
          raise_error(/segment LX .+? is missing/)
      end

      pending "raises an exception immediately" do
        # This validation is delayed until this loop is "closed". It would be
        # an improvement for the error to happen immediately, like this:
        expect(lambda{ b.N3("123 MAIN ST") }).to \
          raise_error(/segment LX .+? is missing/)
      end
    end

    context "when too many are present" do
      it "raises an exception" do
        b = strict(Detail("2a",
                     Segment(10, :LQ, s_optional, bounded(1)),
                     Segment(10, :LX, s_optional, bounded(2))))
        b.LQ
        b.LX(1)
        b.LX(2)

        expect(lambda{ b.LX(3).SE(id.count(b), id.pop_st) }).to \
          raise_error(/segment LX .+? occurs too many times/)
      end
    end
  end

  describe "on elements" do
    context "when Optional (or Situational)" do
      let(:b) do
        strict(Detail("2",
          Segment_(10, :XX, "Example", s_mandatory, bounded(1),
            Element(:E554, e_optional, bounded(1)))))
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
        strict(Detail("2",
          Segment_(10, :XX, "Example", s_mandatory, bounded(1),
            Element(:E554, e_mandatory, bounded(1)))))
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
        strict(Detail("2",
          Segment_(10, :XX, "Example", s_mandatory, bounded(1),
            Element(:E554, e_not_used, bounded(1)))))
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
              Element(:E554, e_mandatory,  bounded(1)),
              Element(:E554, e_relational, bounded(1)),
              Element(:E554, e_relational, bounded(1)),
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
              Element(:E554, e_mandatory,  bounded(1)),
              Element(:E554, e_relational, bounded(1)),
              Element(:E554, e_relational, bounded(1)),
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
              Element(:E554, e_mandatory,  bounded(1)),
              Element(:E554, e_relational, bounded(1)),
              Element(:E554, e_relational, bounded(1)),
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
              Element(:E554, e_optional,   bounded(1)),
              Element(:E554, e_relational, bounded(1)),
              Element(:E554, e_relational, bounded(1)),
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
      todo "raises an exception"
    end

    context "when too long" do
      todo "raises an exception"
    end

    context "simple" do
      todo "AN (string)"

      todo "DT (date)"

      todo "ID (identifier)"

      todo "Nn (fixed precision number)"

      todo "TM (time)"

      todo "R (floating precision number)"
    end

    todo "composite"

    context "repeating" do
      todo "simple"

      todo "composite"
    end
  end
end
