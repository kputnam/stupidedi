Definitions.functional_group_defs.each do |constant_name, functional_group_def|
  describe constant_name, :schema do
    describe "#empty" do
      it "returns a FunctionalGroupVal" do
        expect(functional_group_def.empty).to be_functional_group
      end
    end

    describe "#id" do
      it "matches module name" do
        version_name = constant_name.split("::").at(-2)
        version_id   = Fixtures.versions.invert.fetch(version_name)
        expect(functional_group_def.id).to eq(version_id)
      end
    end

    describe "#header_segment_uses" do
      let(:subject) { functional_group_def.header_segment_uses }

      it "is not empty" do
        expect(subject).to_not be_empty
      end

      it "are defined in #segment_dict" do
        segment_dict = Stupidedi::Reader::SegmentDict.build(functional_group_def.segment_dict)
        subject.each do |segment_use|
          expect(segment_dict).to be_defined_at(segment_use.id)
          expect(segment_dict.at(segment_use.id)).to be_segment
        end
      end
    end

    describe "#trailer_segment_uses" do
      let(:subject) { functional_group_def.trailer_segment_uses }

      it "is not empty" do
        expect(subject).to_not be_empty
      end

      it "are defined in #segment_dict" do
        segment_dict = Stupidedi::Reader::SegmentDict.build(functional_group_def.segment_dict)
        subject.each do |segment_use|
          expect(segment_dict).to be_defined_at(segment_use.id)
          expect(segment_dict.at(segment_use.id)).to be_segment
        end
      end
    end

    describe "#segment_dict" do
      it "is a module" do
        expect(functional_group_def.segment_dict).to be_a(Module)
      end
    end

    describe "#descriptor" do
      it "is a String" do
        expect(functional_group_def.descriptor).to be_a(String)
        expect(functional_group_def.descriptor).to_not be_empty
      end
    end

  end
end
