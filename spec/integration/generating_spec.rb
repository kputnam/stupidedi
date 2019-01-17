describe "Generating" do
  include NavigationMatchers

  let(:config)  { Stupidedi::Config.hipaa }
  let(:strict)  { Stupidedi::Parser::BuilderDsl.build(config, true)  }
  let(:relaxed) { Stupidedi::Parser::BuilderDsl.build(config, false) }

  context "unrecognized methods" do
    it "raises an exception" do
      expect(lambda { relaxed.xyz }).to \
        raise_error(NoMethodError)
    end

    it "does not respond to invalid segment name" do
      expect(relaxed.respond_to?(:bad_segment_name)).to be false
    end
  end

  context "recognized methods" do
    it "responds to valid segment name" do
      expect(relaxed.respond_to?(:ISA)).to be true
    end
  end

  context "unrecognized interchange version" do
    def isa(dsl, version)
      dsl.ISA("00", "",
              "00", "",
              "ZZ", "",
              "ZZ", "",
              Time.now.utc,
              Time.now.utc,
              "", version, 123456789, "1", "T", "")
    end

    context "when non-strict" do
      it "quietly proceeds" do
        # 0050x isn't configured
        isa(relaxed, "0050x")

        # An invalid ISA segment was added
        expect(relaxed.zipper.select{|z| z.node.invalid? }).to be_defined

        # It's parent is an InvalidEnvelopeVal
        expect(relaxed.zipper.select{|z| z.parent.node.invalid? }).to be_defined
      end
    end

    context "when strict" do
      it "loudly complains" do
        expect(lambda do
          isa(strict, "0050x")
        end).to raise_error(/^unknown interchange version "0050x"/)

        # The ISA segment wasn't added
        expect(relaxed).to be_empty
      end
    end
  end

  context "interchange 00501" do
    context "tracks separators" do
      def isa(dsl, component = ":", repetition = "^")
        dsl.ISA("00", "",
                "00", "",
                "ZZ", "431777999",
                "ZZ", "133052274",
                Time.now.utc,
                Time.now.utc,
                repetition, "00501", 123456789, "1", "T",
                component)
      end

      it "on the first interchange" do
        isa(relaxed, ":", "^")

        expect(relaxed.machine.separators.component).to eq(":")
        expect(relaxed.machine.separators.repetition).to eq("^")
      end

      it "on subsequent interchanges" do
        isa(relaxed, "$", "%")
        isa(relaxed, "@", "#")

        expect(relaxed.machine.separators.component).to eq("@")
        expect(relaxed.machine.separators.repetition).to eq("#")

        expect(relaxed.machine.prev.tap do |machine|
          expect(machine.separators.component).to eq("$")
          expect(machine.separators.repetition).to eq("%")
        end).to be_defined
      end
    end

    context "with missing IEA" do
      def isa(dsl)
        dsl.ISA("00", "",
                "00", "",
                "ZZ", "431777999",
                "ZZ", "133052274",
                Time.now.utc,
                Time.now.utc,
                "", "00501", 123456789, "1", "T", "")
      end

      context "when strict" do
        it "loudly complains" do
          expect(lambda { isa(strict) }).not_to raise_error
          # ("required segment IEA is missing from interchange 00501")

          expect(lambda { isa(strict) }).to \
            raise_error(/^required segment IEA.*? is missing from interchange 00501/)

          expect(strict).to be_first
        end
      end

      context "when non-strict" do
        it "quietly proceeds" do
          expect(lambda { isa(relaxed) }).not_to raise_error
          # ("required segment IEA is missing from interchange 00501")

          expect(lambda { isa(relaxed) }).not_to raise_error
          # ("required segment IEA is missing from interchange 00501")

          expect(relaxed).not_to be_first
        end
      end
    end

    context "with mising required elements" do
      def isa(dsl)
        dsl.ISA("00", "",
                "00", "",
                "ZZ", "",
                "ZZ", "133052274",
                Time.now.utc,
                Time.now.utc,
                "", "00501", 123456789, "1", "T", "")
      end

      context "when strict" do
        it "loudly complains" do
          expect(lambda { isa(strict) }).to \
            raise_error(/^required element ISA06.*? is blank/)

          expect(strict).to be_empty
        end
      end

      context "when non-strict" do
        it "quietly proceeds" do
          expect(lambda { isa(relaxed) }).not_to raise_error
          # ("required element ISA06 is blank")

          expect(relaxed.element(6).select{|e| e.node == "" }).to be_defined
          expect(relaxed.element(6).select{|e| e.node.empty? }).to be_defined
        end
      end
    end

    context "invalid values" do
      context "with disallowed ID values" do
        def isa(dsl)
          dsl.ISA("XX", "",
                  "00", "",
                  "ZZ", "431777999",
                  "ZZ", "133052274",
                  Time.now.utc,
                  Time.now.utc,
                  "", "00501", 123456789, "1", "T", "")
        end

        context "when strict" do
          it "loudly complains" do
            expect(lambda { isa(strict) }).to \
              raise_error(/^value XX not allowed in element ISA01/)

            expect(strict).to be_empty
          end
        end

        context "when non-strict" do
          it "quietly proceeds" do
            expect(lambda { isa(relaxed) }).not_to raise_error
            # ("value XX not allowed in element ISA01")

            expect(relaxed.element(1).select{|e| e.node == "XX" }).to be_defined
            expect(relaxed.element(1).select{|e| e.node.invalid? }).not_to be_defined
          end
        end
      end

      context "with invalid DT values" do
        def isa(dsl)
          dsl.ISA("00", "",
                  "00", "",
                  "ZZ", "431777999",
                  "ZZ", "133052274",
                  "DATE",
                  Time.now.utc,
                  "", "00501", 123456789, "1", "T", "")
        end

        context "when strict" do
          it "loudly complains" do
            expect(lambda { isa(strict) }).to raise_error
            # ("invalid element ISA09")

            expect(strict).to be_empty
          end
        end

        context "when non-strict" do
          it "quietly proceeds" do
            expect(lambda { isa(relaxed) }).not_to raise_error
            # ("invalid element ISA09")

            expect(relaxed.element(9).select{|e| e.node.invalid? }).to be_defined
            expect(relaxed.element(9).select{|e| e.node == "DATE" }).not_to be_defined
          end
        end
      end

      context "with invalid TM values" do
        def isa(dsl)
          dsl.ISA("00", "",
                  "00", "",
                  "ZZ", "431777999",
                  "ZZ", "133052274",
                  Time.now.utc,
                  "TIME",
                  "", "00501", 123456789, "1", "T", "")
        end

        context "when strict" do
          it "loudly complains" do
            expect(lambda { isa(strict) }).to \
              raise_error(/^invalid element ISA10/)

            expect(strict).to be_empty
          end
        end

        context "when non-strict" do
          it "quietly proceeds" do
            expect(lambda { isa(relaxed) }).not_to raise_error
            # ("invalid element ISA10")

            expect(relaxed.element(10).select{|e| e.node.invalid? }).to be_defined
            expect(relaxed.element(10).select{|e| e.node == "TIME" }).not_to be_defined
          end
        end
      end

      context "with invalid Nn values" do
        def isa(dsl)
          dsl.ISA("00", "",
                  "00", "",
                  "ZZ", "431777999",
                  "ZZ", "133052274",
                  Time.now.utc,
                  Time.now.utc,
                  "", "00501", "1234ABC", "1", "T", "")
        end

        context "when strict" do
          it "loudly complains" do
            expect(lambda { isa(strict) }).to \
              raise_error(/^invalid element ISA13/)

            expect(strict).to be_empty
          end
        end

        context "when non-strict" do
          it "quietly proceeds" do
            expect(lambda { isa(relaxed) }).not_to raise_error

            expect(relaxed.element(13).select{|e| e.node.invalid? }).to be_defined
          end
        end
      end
    end

    context "incorrect element lengths" do
      context "with Nn elements that are too long" do
        def setup(dsl)
          dsl.ISA("00", "",
                  "00", "",
                  "ZZ", "431777999",
                  "ZZ", "133052274",
                  Time.now.utc,
                  Time.now.utc,
                  "^", "00501", 1234567890, "1", "T", ":")
        end

        context "when strict" do
          it "loudly complains" do
            expect(lambda { setup(strict) }).to \
              raise_error(/^value is too long in element ISA13/)
          end
        end

        context "when non-strict" do
          it "quietly proceeds" do
            expect(lambda { setup(relaxed) }).not_to \
              raise_error

            expect(relaxed.element(13).select{|e| e.node == 1234567890 }).to be_defined
            expect(relaxed.element(13).select{|e| e.node.too_long? }).to be_defined
          end
        end
      end

      context "with Nn element that are too short" do
        # I don't know of any Nn elements that have a min_length
        # that isn't just 1. So the #too_short? method in FixnumVal
        # don't bother testing and returns false in every case, for
        # simplicity.
      end

      context "with R elements that are too long" do
      end

      context "with R elements that are too short" do
        # I don't know of any R elements that have a min_length
        # that isn't just 1. So the #too_short? method in FloatVal
        # don't bother testing and returns false in every case, for
        # simplicity.
      end

      context "with AN elements that are too long" do
        def setup(dsl)
          dsl.ISA("00", "",
                  "00", "",
                  "ZZ", "431777999xxxxxxxxxxx",
                  "ZZ", "133052274",
                  Time.now.utc,
                  Time.now.utc,
                  "^", "00501", 123456789, "1", "T", ":")
        end

        context "when strict" do
          it "loudly complains" do
            expect(lambda { setup(strict) }).to \
              raise_error(/^value is too long in element ISA06/)
          end
        end

        context "when non-strict" do
          it "quietly proceeds" do
            expect(lambda { setup(relaxed) }).not_to raise_error
            # ("value is too long in element ISA06")

            expect(relaxed.element(6).select{|e| e.node == "431777999xxxxxxxxxxx" }).to be_defined
            expect(relaxed.element(6).select{|e| e.node.too_long? }).to be_defined
          end
        end
      end

      context "with AN elements that are too short" do
        # I don't know of any AN elements that have a min_length
        # that isn't just 1. But the #too_short? method in StringVal
        # is correctly implemented
      end

      context "with TM elements that are too long" do
        # Because TM definitions ensure max_length is 2, 4, or greater
        # than 6 and because of the values are parsed into TimeVals, we
        # can always safely truncate output to max_length. So there
        # isn't a case where a TM element value is too long
      end

      context "with TM elements that are too short" do
        def setup(dsl, time = Time.now.utc)
          dsl.ISA("00", "",
                  "00", "",
                  "ZZ", "431777999",
                  "ZZ", "133052274",
                  Time.now.utc,
                  time.hour.to_s,
                  "^", "00501", 123456789, "1", "T", ":")
        end

        context "when strict" do
          it "complains loudly" do
            expect(lambda { setup(strict) }).to \
              raise_error(/^value is too short in element ISA10/)
          end
        end

        context "when non-strict" do
          it "proceeds quietly" do
            time = Time.now.utc

            expect(lambda { setup(relaxed, time) }).not_to raise_error
            # ("value is too short in element ISA10")

            expect(relaxed.element(10).select{|e| e.node.hour == time.hour }).to be_defined
            expect(relaxed.element(10).select{|e| e.node.too_short? }).to be_defined
          end
        end
      end

      context "with DT elements that are too long" do
        def setup(dsl)
          dsl.ISA("00", "",
                  "00", "",
                  "ZZ", "431777999",
                  "ZZ", "133052274",
                  Time.now.utc,
                  Time.now.utc,
                  "^", "00501", 123456789, "1", "T", ":")

          dsl.GS("HC",
                 "SENDER ID",
                 "RECEIVER ID",
                 "222221105",
                 Time.now.utc, "1", "X", "005010X222A1")
        end

        context "when strict" do
          it "complains loudly" do
            expect(lambda { setup(strict) }).to \
              raise_error(/^value is too long in element GS04/)
          end
        end

        context "when non-strict" do
          it "quietly proceeds" do
            expect(lambda { setup(relaxed) }).not_to raise_error
            # ("value is too long in element GS04")

            expect(relaxed.element(4).select{|e| expect(e.node.year).to eq(22222) }).to be_defined
          end
        end
      end

      context "with DT elements that are too short" do
        def setup(dsl)
          dsl.ISA("00", "",
                  "00", "",
                  "ZZ", "431777999",
                  "ZZ", "133052274",
                  Time.now.utc,
                  Time.now.utc,
                  "^", "00501", 123456789, "1", "T", ":")

          dsl.GS("HC",
                 "SENDER ID",
                 "RECEIVER ID",
                 "110605",
                 Time.now.utc, "1", "X", "005010X222A1")
        end

        context "when strict" do
          it "complains loudly" do
            expect(lambda { setup(strict) }).to \
              raise_error(/^value is too short in element GS04/)
          end
        end

        context "when non-strict" do
          it "quietly proceeds" do
            expect(lambda { setup(relaxed) }).not_to \
              raise_error #("value is too short in element GS04")

            expect(relaxed.element(4).select{|e| expect(e.node.year).to eq(11) }).to be_defined
          end
        end
      end
    end

    context "placeholder elements" do
      def setup(dsl, ts)
        dsl.ISA("00", "",
                "00", "",
                "ZZ", "431777999",
                "ZZ", "133052274",
                Time.now.utc,
                Time.now.utc,
                "^", "00501", 123456789, "1", "T", ":")

        dsl.GS("HC",
               "SENDER ID",
               "RECEIVER ID",
               Time.now.utc,
               Time.now.utc, "1", "X", ts)
      end

      context "with default element placeholder" do
        context "when value cannot be inferred" do
          it "raises an error" do
            setup(relaxed, "005010X222A1")

            expect(lambda { relaxed.ST("837", relaxed.default, "005010X222A1") }).to \
              raise_error(/^ST02 cannot be inferred/)
          end
        end

        context "when blank value can be inferred" do
          it "generates an empty element" do
            setup(relaxed, "005010X221")

            expect(lambda { relaxed.ST("835", "CONTROLNUM", relaxed.default) }).not_to \
              raise_error #("ST02 cannot be inferred")

            expect(relaxed.element(3).select{|e| e.node == "" }).to be_defined
            expect(relaxed.element(3).select{|e| e.node.blank? }).to be_defined
          end
        end

        context "when non-empty value can be inferred" do
          it "generates a non-empty element value" do
            setup(relaxed, "005010X222A1")

            expect(lambda { relaxed.ST("837", "CONTROLNUM", relaxed.default) }).not_to \
              raise_error #("ST02 cannot be inferred")

            expect(relaxed.element(3).select{|e| e.node == "005010X222A1" }).to be_defined
          end
        end
      end

      context "with not_used element placeholder" do
        context "when element is declared forbidden" do
          it "generates an empty element" do
            setup(relaxed, "005010X221")

            expect(lambda { relaxed.ST("835", "CONTROLNUM", relaxed.not_used) }).not_to \
              raise_error #("ST03 is not forbidden")

            expect(relaxed.element(3).select{|e| e.node == "" }).to be_defined
            expect(relaxed.element(3).select{|e| e.node.blank? }).to be_defined
          end
        end

        context "when element is not declared forbidden" do
          it "generates a non-empty element value" do
            setup(relaxed, "005010X222A1")

            expect(lambda { relaxed.ST("837", "CONTROLNUM", relaxed.not_used) }).to \
              raise_error(/^ST03 is not forbidden/)
          end
        end
      end
    end
  end
end
