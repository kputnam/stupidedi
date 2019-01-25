Definitions.interchange_defs.each do |constant_name, interchange_def|
  describe constant_name, :schema do
    let(:separators) { Stupidedi::Reader::Separators.default }

    describe "#id" do
      it "matches module name" do
        version_name = constant_name.split("::").at(-2)
        version_id   = Fixtures.versions.invert.fetch(version_name)
        expect(interchange_def.id).to eq(version_id)
      end
    end

    describe "#empty" do
      it "returns a InterchangeVal" do
        expect(interchange_def.empty(separators)).to be_interchange
      end
    end

    describe "#segment_dict" do
      it "is a module" do
        expect(interchange_def.segment_dict).to be_a(Module)
      end
    end

    describe "#entry_segment_use" do
      it "is a SegmentUse" do
        expect(interchange_def.entry_segment_use).to be_segment
      end
    end

    describe "#header_segment_uses" do
      let(:subject) { interchange_def.header_segment_uses }

      it "is not empty" do
        expect(subject).to_not be_empty
      end

      it "are defined in #segment_dict" do
        segment_dict = Stupidedi::Reader::SegmentDict.build(interchange_def.segment_dict)
        subject.each do |segment_use|
          expect(segment_dict).to be_defined_at(segment_use.id)
          expect(segment_dict.at(segment_use.id)).to be_segment
        end
      end
    end

    describe "#trailer_segment_uses" do
      let(:subject) {interchange_def.trailer_segment_uses }

      it "is not empty" do
        expect(subject).to_not be_empty
      end

      it "are defined in #segment_dict" do
        segment_dict = Stupidedi::Reader::SegmentDict.build(interchange_def.segment_dict)
        subject.each do |segment_use|
          expect(segment_dict).to be_defined_at(segment_use.id)
          expect(segment_dict.at(segment_use.id)).to be_segment
        end
      end
    end

    describe "#descriptor" do
      it "is a String" do
        expect(interchange_def.descriptor).to be_a(String)
        expect(interchange_def.descriptor).to_not be_empty
      end
    end
  end
end
