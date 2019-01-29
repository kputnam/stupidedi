Definitions.interchange_defs.each do |constant_name, interchange_def|
  describe constant_name, :schema do
    version_id = Fixtures.versions.invert.fetch(
      constant_name.split("::").at(-2))

    let(:version_id) { version_id }
    let(:separators) { Stupidedi::Reader::Separators.default }

    def mksegment_tok(id, *elements)
      Stupidedi::Reader::SegmentTok.build(id,
        elements.map{|e| Stupidedi::Reader::SimpleElementTok.build(e, nil, "")}, nil, "")
    end

    let(:segment_val) do
      segment_use = interchange_def.header_segment_uses.first
      segment_tok = mksegment_tok(:ISA,
        "00", "..........",
        "00", "..........",
        "ZZ", "SUBMITTERS.ID..",
        "ZZ", "RECEIVERS.ID...",
        "010101", "0101",
        "P", # separators.repetition,
        version_id,
        "000000001", "1", "T",
        "Q") #separators.component)

      Stupidedi::Parser::AbstractState.mksegment(segment_tok, segment_use)
    end

    describe "#separators" do
      it "returns Separators" do
        expect(interchange_def.separators(segment_val)).to be_a(Stupidedi::Reader::Separators)
      end

      it "sets component separator" do
        expect(interchange_def.separators(segment_val).component).to eq("Q")
      end

      if version_id < "00500"
        it "does not set repetition separator" do
          expect(interchange_def.separators(segment_val).repetition).to eq(nil)
        end
      else
        it "sets repetition separator" do
          expect(interchange_def.separators(segment_val).repetition).to eq("P")
        end
      end
    end

    describe "#replace_separators" do
      let(:before) { segment_val }
      let(:after)  { interchange_def.replace_separators(segment_val, separators) }

      it "returns a segment" do
        expect(after).to be_segment
      end

      it "sets component separator" do
        expect(interchange_def.separators(after).component).to eq(separators.component)
      end

      it "sets component separator" do
        expect(after.element(16)).to eq(separators.component)
      end

      if version_id < "00500"
        it "does not set repetition separator" do
          expect(after.element(11)).to eq("P")
        end
      else
        it "sets repetition separator" do
          expect(after.element(11)).to eq(separators.repetition)
        end
      end

      it "does not change other elements" do
        ns = [1,2,3,4,5,6,7,8,9,10,  12,13,14,15]
        b  = ns.map{|n| before.element(n) }
        a  = ns.map{|n|  after.element(n) }
        expect(a).to eq(b)
      end
    end

    describe "#id" do
      it "matches module name" do
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
