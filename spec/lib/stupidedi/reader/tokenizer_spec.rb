describe Stupidedi::Reader::Tokenizer do
  describe "#each_isa" do
    let(:filepath)  { Fixtures.filepath("tokenizer/each_isa.edi") }
    let(:tokenizer) { Stupidedi::Reader.build(filepath) }

    let(:tokens)    { tokenizer.each_isa.to_a }
    let(:segments)  { tokens.select{|t| t.is_a?(Stupidedi::Tokens::SegmentTok) }}
    let(:ignoreds)  { tokens.select{|t| t.is_a?(Stupidedi::Tokens::IgnoredTok) }}

    it "returns an iterator when block not given" do
      expect(tokenizer.each_isa).to be_a(Enumerator)
    end

    context "when at least one segment is found" do
      it "returns a non-fatal status" do
        result = tokenizer.each_isa{|t| }

        expect(result).to be_fail
        expect(result).to_not be_fatal
        expect(result.error).to match(/, found eof/)
      end
    end

    context "when no segments are found" do
      it "returns a fatal status" do
        result = Stupidedi::Reader.build("No ISA segment here").each_isa{|t| }

        expect(result).to be_fail
        expect(result).to be_fatal
        expect(result.error).to match(/, found eof/)
      end
    end

    it "yields each ISA segment and skips everything between" do
      ignored = Stupidedi::Tokens::IgnoredTok
      segment = Stupidedi::Tokens::SegmentTok

      expect(tokens.map(&:class)).to eq([ignored, segment,
                                         ignored, segment,
                                         ignored, segment])

      expect(ignoreds[0].value).to match(/^SINCE the an.+ philosophy/m)
      expect(ignoreds[1].value).to match(/^GS\*.+Data b.+ be skipped/m)
      expect(ignoreds[2].value).to match(/^THE CONTENT in.+00000011~/m)

      expect(segments.map(&:id)).to eq([:ISA, :ISA, :ISA])
      expect(segments[0].element_toks.at(12).value).to eq("000000000")
      expect(segments[1].element_toks.at(12).value).to eq("000000011")
      expect(segments[2].element_toks.at(12).value).to eq("000000022")

      expect(segments[0].element_toks.length).to eq(16)
      expect(segments[0].element_toks.at(0).value).to eq("00")
      expect(segments[0].element_toks.at(1).value).to be_blank
      expect(segments[0].element_toks.at(2).value).to eq("00")
      expect(segments[0].element_toks.at(3).value).to be_blank
      expect(segments[0].element_toks.at(4).value).to eq("ZZ")
      expect(segments[0].element_toks.at(5).value).to eq("123456789012345")
      expect(segments[0].element_toks.at(6).value).to eq("ZZ")
      expect(segments[0].element_toks.at(7).value).to eq("123456789012346")
      expect(segments[0].element_toks.at(8).value).to eq("061015")
      expect(segments[0].element_toks.at(9).value).to eq("1705")
      expect(segments[0].element_toks.at(10).value).to eq(">")
      expect(segments[0].element_toks.at(11).value).to eq("00501")
      expect(segments[0].element_toks.at(13).value).to eq("0")
      expect(segments[0].element_toks.at(14).value).to eq("T")
      expect(segments[0].element_toks.at(15).value).to eq(":")
    end

    context "when position class is NoPosition" do
      let(:tokenizer) { Stupidedi::Reader.build(filepath, position: Stupidedi::Position::NoPosition) }

      it "doesn't track token positions" do
        expect(segments[0].position).to equal(Stupidedi::Position::NoPosition)
        expect(segments[1].position).to equal(Stupidedi::Position::NoPosition)
        expect(segments[2].position).to equal(Stupidedi::Position::NoPosition)

        segments[0].element_toks.each{|t| expect(t.position).to equal(Stupidedi::Position::NoPosition) }
        segments[1].element_toks.each{|t| expect(t.position).to equal(Stupidedi::Position::NoPosition) }
        segments[2].element_toks.each{|t| expect(t.position).to equal(Stupidedi::Position::NoPosition) }
      end
    end

    context "when position class is OffsetPosition" do
      let(:tokenizer) { Stupidedi::Reader.build(filepath, position: Stupidedi::Position::OffsetPosition) }

      it "tracks token offsets" do
        expect(segments[0].position).to eq(363)
        expect(segments[1].position).to eq(1911)
        expect(segments[2].position).to eq(2164)

        filesize = filepath.size

        # These tests could be more precise
        segments.each do |s|
          s.element_toks.inject(s.position) do |prev, t|
            expect(t.position).to be > prev
            expect(t.position).to be < filesize
            t.position
          end
        end
      end
    end

    context "when position class is custom a struct" do
      let(:tokenizer) { Stupidedi::Reader.build(filepath, position: Fixtures.position) }

      it "tracks various token position information" do
        # These tests could be more precise
        segments.each do |s|
          s.element_toks.inject(s.position) do |prev, t|
            expect(t.position.line).to   be >= prev.line
            expect(t.position.offset).to be > prev.offset
            expect(t.position.column).to be > prev.column if t.position.line == prev.line
            expect(t.position.name).to   eq(filepath)
            t.position
          end
        end

      end
    end
  end

  describe "#each" do
    let(:config)    { Stupidedi::Config.new }
    let(:tokenizer) { Stupidedi::Reader.build(filepath) }

    let(:segments)  { tokens.select{|t| t.is_a?(Stupidedi::Tokens::SegmentTok) }}
    let(:ignoreds)  { tokens.select{|t| t.is_a?(Stupidedi::Tokens::IgnoredTok) }}

    # We have to do some work so that component and repetition separators are
    # recognized by the tokenizer. This is normally handled by Stupidedi::Parser
    let(:tokens) do
      tokenizer.each.map do |token|
        if token.is_a?(Stupidedi::Tokens::SegmentTok) and token.id == :ISA
          version = token.element(12).to_s

          if config.interchange.defined_at?(version)
            interchange_def = config.interchange.at(version)
            var_separators  = interchange_def.separators(token)
            tokenizer.separators = tokenizer.separators.merge(var_separators)
          end
        end

        token
      end
    end

    context "when element isn't known to be composite" do
      let(:filepath) { Fixtures.filepath("tokenizer/each_composite.edi") }

      it "tokenizes component separator as data" do
        # The blank `config` doesn't assign any special meaning to ISA16, which
        # is normally the component separator

        segments.select{|t| t.id == :HI }.each do |t|
          expect(t.element_toks.at(0)).to       be_simple
          expect(t.element_toks.at(0).value).to match(/:/)
        end

        segments.select{|t| t.id == :SV1 }.each do |t|
          expect(t.element_toks.at(0)).to       be_simple
          expect(t.element_toks.at(0).value).to match(/:/)
        end

        segments.select{|t| t.id == :CLM }.each do |t|
          expect(t.element_toks.at(4)).to       be_simple
          expect(t.element_toks.at(4).value).to match(/:/)
        end
      end
    end

    context "when element is known to be composite" do
      let(:filepath) { Fixtures.filepath("tokenizer/each_composite.edi") }
      let(:config)   { Stupidedi::Config.default }

      it "assigns meaning to component separator" do
        tokenizer.segment_dict = tokenizer.segment_dict.push \
          Stupidedi::Versions::FiftyTen::SegmentDefs

        segments.select{|t| t.id == :HI }.each do |t|
          expect(t.element_toks.at(0)).to be_composite
          children = t.element_toks.at(0).component_toks
          expect(children.map(&:value).join).to_not match(/:/)
        end

        segments.select{|t| t.id == :SV1 }.each do |t|
          expect(t.element_toks.at(0)).to be_composite
          children = t.element_toks.at(0).component_toks
          expect(children.map(&:value).join).to_not match(/:/)
        end

        segments.select{|t| t.id == :CLM }.each do |t|
          expect(t.element_toks.at(4)).to be_composite
          children = t.element_toks.at(4).component_toks
          expect(children.map(&:value).join).to_not match(/:/)
        end
      end
    end

    todo "when element isn't know to be repeatable"
    todo "when element is known to be repeatable"
    todo "when position class is NoPosition"
    todo "when position class is OffsetPosition"
    todo "when position class is a custom struct"
  end
end
