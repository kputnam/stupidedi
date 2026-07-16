# frozen_string_literal: true

describe Stupidedi::Schema::LoopDef do
  using Stupidedi::Refinements

  let(:d) { Stupidedi::Schema }
  let(:r) { Stupidedi::Versions::FiftyTen::SegmentReqs }
  let(:s) { Stupidedi::Versions::FiftyTen::SegmentDefs }

  describe ".build" do
    context "with segments only before child loops" do
      it "succeeds" do
        expect {
          d::LoopDef.build("0100", d::RepeatCount.bounded(1),
            s::N1.use(100, r::Mandatory, d::RepeatCount.bounded(1)),
            s::N3.use(200, r::Optional,  d::RepeatCount.bounded(1)),
            s::N4.use(300, r::Optional,  d::RepeatCount.bounded(1)),
            d::LoopDef.build("0110", d::RepeatCount.bounded(5),
              s::REF.use(400, r::Optional, d::RepeatCount.bounded(1))))
        }.not_to raise_error
      end
    end

    context "with trailer segments after all child loops" do
      it "succeeds" do
        expect {
          d::LoopDef.build("0100", d::RepeatCount.bounded(1),
            s::N1.use(100, r::Mandatory, d::RepeatCount.bounded(1)),
            d::LoopDef.build("0110", d::RepeatCount.bounded(5),
              s::REF.use(200, r::Optional, d::RepeatCount.bounded(1))),
            s::NTE.use(300, r::Optional, d::RepeatCount.bounded(1)))
        }.not_to raise_error
      end
    end

    context "with interleaved segments and loops" do
      it "succeeds when a segment appears between two child loops" do
        # This is valid per X12 standard but currently raises InvalidSchemaError
        # See: X222.pdf 2.2.2 Loops, X222.pdf B.1.3.12.4 Loops of Data Segments
        expect {
          d::LoopDef.build("0100", d::RepeatCount.bounded(1),
            s::N1.use(100, r::Mandatory, d::RepeatCount.bounded(1)),
            d::LoopDef.build("0110", d::RepeatCount.bounded(5),
              s::N3.use(200, r::Optional, d::RepeatCount.bounded(1))),
            s::NTE.use(300, r::Optional, d::RepeatCount.bounded(1)),
            d::LoopDef.build("0120", d::RepeatCount.bounded(5),
              s::REF.use(400, r::Optional, d::RepeatCount.bounded(1))))
        }.not_to raise_error
      end

      it "succeeds with multiple interleaved segments and loops" do
        # Pattern: segment -> loop -> segment -> loop -> segment -> loop
        expect {
          d::LoopDef.build("0300", d::RepeatCount.bounded(1),
            s::N1.use(100, r::Mandatory, d::RepeatCount.bounded(1)),
            s::N3.use(200, r::Optional,  d::RepeatCount.bounded(1)),
            d::LoopDef.build("0305", d::RepeatCount.bounded(5),
              s::NTE.use(300, r::Optional, d::RepeatCount.bounded(1))),
            s::N4.use(400, r::Optional, d::RepeatCount.bounded(1)),
            d::LoopDef.build("0310", d::RepeatCount.bounded(5),
              s::REF.use(500, r::Optional, d::RepeatCount.bounded(1))),
            s::PER.use(600, r::Optional, d::RepeatCount.bounded(1)),
            d::LoopDef.build("0320", d::RepeatCount.bounded(5),
              s::DTM.use(700, r::Optional, d::RepeatCount.bounded(1))))
        }.not_to raise_error
      end
    end

    context "validation" do
      it "requires the first child to be a SegmentUse" do
        expect {
          d::LoopDef.build("0100", d::RepeatCount.bounded(1),
            d::LoopDef.build("0110", d::RepeatCount.bounded(5),
              s::N1.use(100, r::Mandatory, d::RepeatCount.bounded(1))))
        }.to raise_error(Stupidedi::Exceptions::InvalidSchemaError, /first child must be a SegmentUse/)
      end

      it "requires the first segment to have RepeatCount.bounded(1)" do
        expect {
          d::LoopDef.build("0100", d::RepeatCount.bounded(1),
            s::N1.use(100, r::Mandatory, d::RepeatCount.bounded(5)))
        }.to raise_error(Stupidedi::Exceptions::InvalidSchemaError, /RepeatCount\.bounded\(1\)/)
      end
    end
  end
end
