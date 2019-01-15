using Stupidedi::Refinements

describe "Navigating" do
  include NavigationMatchers

  let(:payment) { Fixtures.parse!("005010/X221-HP835/case/1.edi").head.first  }
  let(:claim)   { Fixtures.parse!("005010/X222-HC837/case/3b.edi").head.first }

  context "unqualified segments" do
  end

  context "qualified segments" do
  end

  context "sequence of segments" do
  end

  context "parent segments" do
    specify "the first ISA is a root" do
      # ISA has no parent segment
      expect(payment.flatmap(&:parent)).not_to be_defined
    end

    specify "the second ISA's parent is the first ISA" do
      payment.flatmap do |isa|
        isa.last.tap do |iea|
          b = Stupidedi::Parser::BuilderDsl.new(iea, false)
          b.ISA("00", "",
                "00", "",
                "ZZ", "",
                "ZZ", "",
                Time.now.utc,
                Time.now.utc,
                "", "00501", 123456789, "1", "T", "")

          # The ISA segment we just added has the first ISA for a dad
          expect(b.machine).to have_parent(isa)
        end
      end
    end
  end

  context "segments" do
    specify do
      expect(payment.flatmap(&:segment).tap do |isa|
        expect(isa.node).to be_segment
        expect(isa.node.id).to eq(:ISA)
      end).to be_defined
    end
  end

  context "repeatable segments" do
    specify "can be iterated" do
      expect(lambda do
        payment.flatmap do |m|
          m.iterate(:ISA) do |isa|
            raise "didn't expect a second ISA segment"
          end
        end
      end).not_to raise_error
    end

    specify "can be iterated" do
      expect(lambda do
        payment.flatmap do |m|
          m.iterate(:GS) do |gs|
            expect(gs.segment.tap do |segment|
              expect(segment.node.id).to eq(:GS)
            end).to be_defined

            gs.iterate(:ST) do |st|
              expect(st.segment.tap do |segment|
                expect(segment.node.id).to eq(:ST)
              end).to be_defined
            end
          end
        end
      end).not_to raise_error
    end
  end

  context "non-repeatable segments" do
    specify "cannot be iterated" do
      expect(lambda do
        payment.flatmap do |m|
          m.iterate(:GS) do |gs|
            gs.iterate(:ST) do |st|
              st.iterate(:BHT)
            end
          end
        end
      end).to raise_error("BHT segment is not repeatable")
    end
  end

  describe "error handling" do
    context "accessing an undefined element" do
      it "raises an exception" do
        expect(lambda { payment.tap{|isa| isa.element(40) }}).to \
          raise_error("ISA segment has only 16 elements")
      end

      it "raises an exception" do
        expect(lambda { payment.tap{|isa| isa.element(0) }}).to \
          raise_error("argument must be positive")
      end
    end

    context "accessing an element of an invalid segment" do
      it "returns a failure" do
        expect(payment.flatmap(&:last).tap do |iea|
          # non-strict builder used to append a bad segment (ISA version)
          b = Stupidedi::Parser::BuilderDsl.new(iea, false)
          b.ISA("00", "",
                "00", "",
                "ZZ", "",
                "ZZ", "",
                Time.now.utc,
                Time.now.utc,
                "", "BAD-VERSION", 123456789, "1", "T", "")

          expect(b.machine.element(1)).not_to be_defined
          expect(b.machine.element(1).reason).to eq("invalid segment")
        end).to be_defined
      end
    end

    context "accessing a simple element as if it were a composite" do
      it "raises an exception" do
        expect(lambda { payment.flatmap{|isa| isa.element(1, 1) }}).to \
          raise_error("ISA01 is a simple element")
      end
    end

    context "accessing a simple element as if it were a repeated composite" do
      it "raises an exception" do
        expect(lambda { payment.flatmap{|isa| isa.element(1, 1, 1) }}).to \
          raise_error("ISA01 is a simple element")
      end
    end
  end

  describe "simple elements" do
    context "using the segment zipper" do
      specify "StateMachine#zipper returns a zipper pointing at SegmentVal" do
        expect(payment.flatmap{|m| m.zipper.select{|z| z.node.segment? }}).to \
          be_defined
      end

      specify do
        payment.flatmap(&:zipper).tap do |z|
          # z is a zipper pointing to SegmentVal[ISA]
          expect(z.node.id).to eq(:ISA)
        end
      end

      it "is equivalent to using the state machine" do
        expect(claim.flatmap do |m|
          m.segment.tap do |z|
            # z is a zipper pointing to SegmentVal[ISA]
            # m is a StateMachine pointing at that zipper
            m.element( 1).tap{|e| expect(e.node).to be_eql(z.node.element( 1)) }
            m.element( 2).tap{|e| expect(e.node).to be_eql(z.node.element( 2)) }
            m.element( 3).tap{|e| expect(e.node).to be_eql(z.node.element( 3)) }
            m.element( 4).tap{|e| expect(e.node).to be_eql(z.node.element( 4)) }
            m.element( 5).tap{|e| expect(e.node).to be_eql(z.node.element( 5)) }
            m.element( 6).tap{|e| expect(e.node).to be_eql(z.node.element( 6)) }
            m.element( 7).tap{|e| expect(e.node).to be_eql(z.node.element( 7)) }
            m.element( 8).tap{|e| expect(e.node).to be_eql(z.node.element( 8)) }
            m.element( 9).tap{|e| expect(e.node).to be_eql(z.node.element( 9)) }
            m.element(10).tap{|e| expect(e.node).to be_eql(z.node.element(10)) }
            m.element(11).tap{|e| expect(e.node).to be_eql(z.node.element(11)) }
            m.element(12).tap{|e| expect(e.node).to be_eql(z.node.element(12)) }
            m.element(13).tap{|e| expect(e.node).to be_eql(z.node.element(13)) }
            m.element(14).tap{|e| expect(e.node).to be_eql(z.node.element(14)) }
            m.element(15).tap{|e| expect(e.node).to be_eql(z.node.element(15)) }
            m.element(16).tap{|e| expect(e.node).to be_eql(z.node.element(16)) }
          end
        end).to be_defined

        expect(claim.flatmap(&:next).flatmap do |m|
          m.segment.tap do |z|
            # z is a zipper pointing to SegmentVal[GS]
            # m is a StateMachine pointing at that zipper
            m.element(1).tap{|e| expect(e.node).to be_eql(z.node.element(1)) }
            m.element(2).tap{|e| expect(e.node).to be_eql(z.node.element(2)) }
            m.element(3).tap{|e| expect(e.node).to be_eql(z.node.element(3)) }
            m.element(4).tap{|e| expect(e.node).to be_eql(z.node.element(4)) }
            m.element(5).tap{|e| expect(e.node).to be_eql(z.node.element(5)) }
          end
        end).to be_defined
      end
    end

    context "time elements" do
      specify "using the state machine" do
        expect(payment.flatmap{|isa| isa.element(10) }.tap do |tm|
          expect(tm.node).to be_time
          expect(tm.node.hour).to eq(12)
          expect(tm.node.minute).to eq(53)
          expect(tm.node.second).to be_nil
        end).to be_defined
      end

      specify "using the state machine" do
        expect(payment.flatmap(&:next).flatmap{|gs| gs.element(5) }.tap do |tm|
          expect(tm.node).to be_time
          expect(tm.node.hour).to eq(8)
          expect(tm.node.minute).to eq(2)
          expect(tm.node.second).to be_nil
        end).to be_defined
      end
    end

    context "date elements" do
      specify do
        # This is the one "improper" date with 2-digit year
        expect(payment.flatmap{|isa| isa.element(9) }.tap do |dt|
          expect(dt.node).to be_date
          expect(dt.node.year).to  eq(3)
          expect(dt.node.month).to eq(1)
          expect(dt.node.day).to  eq(1)
          expect(dt.node.future.year).to eq(2103)
          expect(dt.node.past.year).to eq(2003)
        end).to be_defined
      end

      specify do
        # This is a typical "proper" date with 4-digit year
        expect(payment.flatmap(&:next).flatmap{|gs| gs.element(4) }.tap do |dt|
          expect(dt.node).to be_date
          expect(dt.node.year).to eq(1999)
          expect(dt.node.month).to eq(12)
          expect(dt.node.day).to eq(31)
          expect(dt.node.future.year).to eq(1999)
          expect(dt.node.past.year).to eq(1999)
        end).to be_defined
      end
    end

    context "fixed precision numeric elements" do
    end

    context "floating precision numeric elements" do
    end
  end

  context "composite elements" do
  end

  context "repeated simple elements" do
  end

  context "repeated composite elements" do
  end
end
