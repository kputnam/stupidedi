# encoding: utf-8
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

    todo "when position class is NoPosition"
    todo "when position class is OffsetPosition"
    todo "when position class is a custom struct"
  end

  def self.repeated(*args)
    args
  end

  def self.composite(*args)
    args
  end

  def add_control_chars(string, start_on_graphic = true)
    insert = "\a\b\t\n\v\f\r".chars
    string.chars.inject(["", []]) do |(s, xs), c|
      unless start_on_graphic and s.empty?
        prefix = insert.sample(rand(3)).join
        suffix = insert.sample(rand(3)).join
      else
        prefix = ""
        suffix = insert.sample(rand(3)).join
      end

      xs << s.length + prefix.length
      s  << prefix << c << suffix

      [s, xs]
    end
  end

  todo "#next_isa_segment"

  todo "#next_segment" do
    todo "when separators are blank"
    todo "when segment is found is SegmentDict"
    todo "when segment is not found in SegmentDict"
    todo "when next segment is ISA"
    todo "when next segment is IEA"
    todo "when next segment ID isn't found"
    todo "when segment ID is followed by EOF"
    todo "when segment ID is not followed by separator"
    todo "when elements cannot be read"
  end

  describe "#_next_isa_segment_id" do
    todo "when 'ISA' is found at start of input"
    todo "when 'ISA' is found after ignored data"
    todo "when 'I' does not occur"
    todo "when 'S' does not occur"
    todo "when 'A' does not occur"
    todo "when next character after 'I' is not 'S'"
    todo "when next character after 'S' is not 'A'"
    todo "when character after 'A' is not a valid separator"
  end

  todo "#_read_isa_elements" do
    todo "when component separator (ISA16) is ':'"
    todo "when segment terminator is '\r\n'"
    todo "when segment terminator is '\n'"
    todo "when segment terminator is '~'"
    todo "when component separator (ISA16) is not unique"
    todo "when component separator (ISA16) is not valid"
    todo "when segment terminator is not not unique"
    todo "when segment terminator is not valid"
  end

  describe "#_next_segment_id" do
    def self.pass(prefix, suffix, expected)
      specify "#{(prefix + suffix).inspect} => #{expected.inspect}" do
        t = Stupidedi::Reader.build(prefix + suffix, position: Stupidedi::Position::OffsetPosition)
        t.separators = Stupidedi::Reader::Separators.default

        r = t.send(:_next_segment_id, t.instance_variable_get(:@input))
        expect(r).to_not            be_fail
        expect(r.value).to          eq(expected)
        expect(r.position).to       eq(0)
        expect(r.rest).to           eq(suffix)
        expect(r.rest.position).to  eq(prefix.length)
      end

      specify "#{(prefix + suffix).inspect} with control characters => #{expected.inspect}" do
        str, pos = add_control_chars(prefix + suffix)
        prefix_  = str[0 .. pos[prefix.length] - 1]
        suffix_  = str[pos[prefix.length] .. -1]

        t = Stupidedi::Reader.build(str, position: Stupidedi::Position::OffsetPosition)
        t.separators = Stupidedi::Reader::Separators.default

        r = t.send(:_next_segment_id, t.instance_variable_get(:@input))
        expect(r).to_not            be_fail
        expect(r.value).to          eq(expected)
        expect(r.position).to       eq(pos[0])
        expect(r.rest.to_s).to      eq(suffix_)
        expect(r.rest.position).to  eq(prefix_.length)
      end
    end

    def self.fail(input, reason: nil)
      specify "#{input.inspect} is not tokenizable" do
        t = Stupidedi::Reader.build(input, position: Stupidedi::Position::OffsetPosition)
        t.separators = Stupidedi::Reader::Separators.default

        r = t.send(:_next_segment_id, t.instance_variable_get(:@input))
        expect(r).to          be_fail
        expect(r.position).to eq(0)
        expect(r.error).to    match(reason)
      end
    end

    pass "XYZ", "*100~...", :XYZ
    pass "XYZ", "*100~...", :XYZ
    pass "XY", "~NM1*...",  :XY
    pass "XY", "~NM1*...",  :XY
    fail "XYZ:100~...",  reason: %q(expected segment identifier, found "XYZ:100")
    fail "XYZ^100~...",  reason: %q(expected segment identifier, found "XYZ^100")
    fail "X Z*100~...",  reason: %q(expected segment identifier, found "X Z")
    fail "W*100~...",    reason: %q(expected segment identifier, found "W")
    fail "WXYZ*100~...", reason: %q(expected segment identifier, found "WXYZ")
  end

  todo "#_read_elements" do
    def self.pass(prefix, suffix, expected)
    end

    def self.fail(input, reason: nil)
    end
  end

  describe "#_read_simple_element" do
    def self.pass(prefix, suffix, expected)
      specify "#{(prefix + suffix).inspect} => #{expected.inspect}" do
        t = Stupidedi::Reader.build(prefix + suffix, position: Stupidedi::Position::OffsetPosition)
        t.separators = Stupidedi::Reader::Separators.default

        # This is Stupidedi::Reader::Input
        input = t.instance_variable_get(:@input)

        if expected.is_a?(Array)
          r = t.send(:_read_simple_element, input, true, :XYZ, 4)
          expect(r).to_not            be_fail
          expect(r.value).to_not      be_simple
          expect(r.value).to          be_repeated
          expect(r.value).to_not      be_composite
          expect(r.value.element_toks.map{|t|t.value.to_s}).to eq(expected)
          expect(r.value.position).to eq(0)
          expect(r.position).to       eq(0)
          expect(r.rest).to           eq(suffix)
          expect(r.rest.position).to  eq(prefix.length)
        else
          r = t.send(:_read_simple_element, input, false, :XYZ, 1)
          expect(r).to_not            be_fail
          expect(r.value).to          be_simple
          expect(r.value).to_not      be_repeated
          expect(r.value).to_not      be_composite
          expect(r.value.value.to_s).to eq(expected)
          expect(r.value.position).to eq(0)
          expect(r.position).to       eq(0)
          expect(r.rest).to           eq(suffix)
          expect(r.rest.position).to  eq(prefix.length)
        end
      end

      specify "#{(prefix + suffix).inspect} with control characters => #{expected.inspect}" do
        str, pos = add_control_chars(prefix + suffix)
        prefix_  = str[0 .. pos[prefix.length] - 1]
        suffix_  = str[pos[prefix.length] .. -1]

        t = Stupidedi::Reader.build(str, position: Stupidedi::Position::OffsetPosition)
        t.separators = Stupidedi::Reader::Separators.default

        # This is Stupidedi::Reader::Input
        input = t.instance_variable_get(:@input)

        if expected.is_a?(Array)
          r = t.send(:_read_simple_element, input, true, :XYZ, 4)
          expect(r).to_not            be_fail
          expect(r.value).to_not      be_simple
          expect(r.value).to          be_repeated
          expect(r.value).to_not      be_composite
          expect(r.value.element_toks.map{|t|t.value.to_s}).to eq(expected)
          expect(r.value.position).to eq(pos[0])
          expect(r.position).to       eq(pos[0])
          expect(r.rest).to           eq(suffix_)
          expect(r.rest.position).to  eq(prefix_.length)
        else
          r = t.send(:_read_simple_element, input, false, :XYZ, 1)
          expect(r).to_not            be_fail
          expect(r.value).to          be_simple
          expect(r.value).to_not      be_repeated
          expect(r.value).to_not      be_composite
          expect(r.value.value.to_s).to eq(expected)
          expect(r.value.position).to eq(pos[0])
          expect(r.position).to       eq(pos[0])
          expect(r.rest).to           eq(suffix_)
          expect(r.rest.position).to  eq(prefix_.length)
        end
      end
    end

    def self.fail(input, reason: nil)
      specify "#{input.inspect} is not tokenizable" do
        t = Stupidedi::Reader.build(input, position: Stupidedi::Position::OffsetPosition)
        t.separators = Stupidedi::Reader::Separators.default

        # This is Stupidedi::Reader::Input
        input = t.instance_variable_get(:@input)

        r = t.send(:_read_simple_element, input, false, :XYZ, 4)
        expect(r).to          be_fail
        expect(r.error).to    match(reason) unless reason.nil?
        expect(r.position).to eq(0)
      end
    end

    pass "*A", "*",       "A"
    pass "*A", "*B:",     "A"
    pass "*A", "*B:C^",   "A"
    pass "*A", "*B:C^D~", "A"
    pass "*A", "*B:C~",   "A"
    pass "*A", "*B:C~D^", "A"
    pass "*A", "*B^",     "A"
    pass "*A", "*B^C:",   "A"
    pass "*A", "*B^C:D~", "A"
    pass "*A", "*B^C~",   "A"
    pass "*A", "*B^C~D:", "A"
    pass "*A", "*B~",     "A"
    pass "*A", "*B~C:",   "A"
    pass "*A", "*B~C:D^", "A"
    pass "*A", "*B~C^",   "A"
    pass "*A", "*B~C^D:", "A"
    fail "*A:"
    pass "*A:B", "*",     "A:B"
    pass "*A:B", "*C^",   "A:B"
    pass "*A:B", "*C^D~", "A:B"
    pass "*A:B", "*C~",   "A:B"
    pass "*A:B", "*C~D^", "A:B"
    fail "*A:B^"

    context "when repeating" do
      pass "*A:B^C", "*",   repeated("A:B", "C")
      pass "*A:B^C", "*D~", repeated("A:B", "C")
      pass "*A:B^C", "~",   repeated("A:B", "C")
      pass "*A:B^C", "~D*", repeated("A:B", "C")
    end

    context "when non-repeating" do
      pass "*A:B^C", "*",   "A:B^C"
      pass "*A:B^C", "*D~", "A:B^C"
      pass "*A:B^C", "~",   "A:B^C"
      pass "*A:B^C", "~D*", "A:B^C"
    end

    pass "*A:B", "~",     "A:B"
    pass "*A:B", "~C*",   "A:B"
    pass "*A:B", "~C*D^", "A:B"
    pass "*A:B", "~C^",   "A:B"
    pass "*A:B", "~C^D*", "A:B"
    fail "*A^"

    context "when repeating" do
      pass "*A^B", "*",     repeated("A", "B")
      pass "*A^B", "*C:",   repeated("A", "B")
      pass "*A^B", "*C:D~", repeated("A", "B")
      pass "*A^B", "*C~",   repeated("A", "B")
      pass "*A^B", "*C~D:", repeated("A", "B")
      fail "*A^B:"
      pass "*A^B:C", "*",   repeated("A", "B:C")
      pass "*A^B:C", "*D~", repeated("A", "B:C")
      pass "*A^B:C", "~",   repeated("A", "B:C")
      pass "*A^B:C", "~D*", repeated("A", "B:C")
      pass "*A^B", "~",     repeated("A", "B")
      pass "*A^B", "~C*",   repeated("A", "B")
      pass "*A^B", "~C*D:", repeated("A", "B")
      pass "*A^B", "~C:",   repeated("A", "B")
      pass "*A^B", "~C:D*", repeated("A", "B")
    end

    context "when non-repeating" do
      pass "*A^B", "*",     "A^B"
      pass "*A^B", "*C:",   "A^B"
      pass "*A^B", "*C:D~", "A^B"
      pass "*A^B", "*C~",   "A^B"
      pass "*A^B", "*C~D:", "A^B"
      fail "*A^B:"
      pass "*A^B:C", "*",   "A^B:C"
      pass "*A^B:C", "*D~", "A^B:C"
      pass "*A^B:C", "~",   "A^B:C"
      pass "*A^B:C", "~D*", "A^B:C"
      pass "*A^B", "~",     "A^B"
      pass "*A^B", "~C*",   "A^B"
      pass "*A^B", "~C*D:", "A^B"
      pass "*A^B", "~C:",   "A^B"
      pass "*A^B", "~C:D*", "A^B"
    end

    pass "*A", "~",       "A"
    pass "*A", "~B*",     "A"
    pass "*A", "~B*C:",   "A"
    pass "*A", "~B*C:D^", "A"
    pass "*A", "~B*C^",   "A"
    pass "*A", "~B*C^D:", "A"
    pass "*A", "~B:",     "A"
    pass "*A", "~B:C*",   "A"
    pass "*A", "~B:C*D^", "A"
    pass "*A", "~B:C^",   "A"
    pass "*A", "~B:C^D*", "A"
    pass "*A", "~B^",     "A"
    pass "*A", "~B^C*",   "A"
    pass "*A", "~B^C*D:", "A"
    pass "*A", "~B^C:",   "A"
    pass "*A", "~B^C:D*", "A"
  end

  describe "#_read_component_element" do
    def self.pass(prefix, suffix, expected, parent_repeatable: false)
      specify "#{(prefix + suffix).inspect} => #{expected.inspect}" do
        t = Stupidedi::Reader.build(prefix + suffix, position: Stupidedi::Position::OffsetPosition)
        t.separators = Stupidedi::Reader::Separators.default

        input = t.instance_variable_get(:@input)

        if expected.is_a?(Array)
          r = t.send(:_read_component_element, input, true, parent_repeatable, :XYZ, 5, 6)
          expect(r).to_not            be_fail
          expect(r.value).to_not      be_simple
          expect(r.value).to          be_repeated
          expect(r.value).to_not      be_composite
          expect(r.value.element_toks.map{|t|t.value.to_s}).to eq(expected)
          expect(r.value.position).to eq(0)
          expect(r.position).to       eq(0)
          expect(r.rest).to           eq(suffix)
          expect(r.rest.position).to  eq(prefix.length)
        else
          r = t.send(:_read_component_element, input, false, parent_repeatable, :XYZ, 5, 6)
          expect(r).to_not            be_fail
          expect(r.value).to          be_simple
          expect(r.value).to_not      be_repeated
          expect(r.value).to_not      be_composite
          expect(r.value.value.to_s).to eq(expected)
          expect(r.value.position).to eq(0)
          expect(r.position).to       eq(0)
          expect(r.rest).to           eq(suffix)
          expect(r.rest.position).to  eq(prefix.length)
        end
      end

      specify "#{(prefix + suffix).inspect} with control characters => #{expected.inspect}" do
        str, pos = add_control_chars(prefix + suffix)
        prefix_  = str[0 .. pos[prefix.length] - 1]
        suffix_  = str[pos[prefix.length] .. -1]

        t = Stupidedi::Reader.build(str, position: Stupidedi::Position::OffsetPosition)
        t.separators = Stupidedi::Reader::Separators.default

        input = t.instance_variable_get(:@input)

        if expected.is_a?(Array)
          r = t.send(:_read_component_element, input, true, parent_repeatable, :XYZ, 5, 6)
          expect(r).to_not            be_fail
          expect(r.value).to_not      be_simple
          expect(r.value).to          be_repeated
          expect(r.value).to_not      be_composite
          expect(r.value.element_toks.map{|t|t.value.to_s}).to eq(expected)
          expect(r.value.position).to eq(pos[0])
          expect(r.position).to       eq(pos[0])
          expect(r.rest).to           eq(suffix_)
          expect(r.rest.position).to  eq(prefix_.length)
        else
          r = t.send(:_read_component_element, input, false, parent_repeatable, :XYZ, 5, 6)
          expect(r).to_not            be_fail
          expect(r.value).to          be_simple
          expect(r.value).to_not      be_repeated
          expect(r.value).to_not      be_composite
          expect(r.value.value.to_s).to eq(expected)
          expect(r.value.position).to eq(pos[0])
          expect(r.position).to       eq(pos[0])
          expect(r.rest).to           eq(suffix_)
          expect(r.rest.position).to  eq(prefix_.length)
        end
      end
    end

    def self.fail(input, repeatable: false, parent_repeatable: false, reason: nil)
      specify "#{input.inspect} is not tokenizable" do
        t = Stupidedi::Reader.build(input, position: Stupidedi::Position::OffsetPosition)
        t.separators = Stupidedi::Reader::Separators.default

        # This is Stupidedi::Reader::Input
        input = t.instance_variable_get(:@input)

        r = t.send(:_read_component_element, input, repeatable, parent_repeatable, :XYZ, 5, 6)
        expect(r).to          be_fail
        expect(r.position).to eq(0)
        expect(r.error).to    match(reason) unless reason.nil?
      end
    end

    pass "*A", "*",       "A"
    pass "*A", "*B:",     "A"
    pass "*A", "*B:C^",   "A"
    pass "*A", "*B:C^D~", "A"
    pass "*A", "*B:C~",   "A"
    pass "*A", "*B:C~D^", "A"
    pass "*A", "*B^",     "A"
    pass "*A", "*B^C:",   "A"
    pass "*A", "*B^C:D~", "A"
    pass "*A", "*B^C~",   "A"
    pass "*A", "*B^C~D:", "A"
    pass "*A", "*B~",     "A"
    pass "*A", "*B~C:",   "A"
    pass "*A", "*B~C:D^", "A"
    pass "*A", "*B~C^",   "A"
    pass "*A", "*B~C^D:", "A"
    pass "*A", ":",       "A"
    pass "*A", ":B*",     "A"
    pass "*A", ":B*C^",   "A"
    pass "*A", ":B*C^D~", "A"
    pass "*A", ":B*C~",   "A"
    pass "*A", ":B*C~D^", "A"
    pass "*A", ":B^",     "A"
    pass "*A", ":B^C*",   "A"
    pass "*A", ":B^C*D~", "A"
    pass "*A", ":B^C~",   "A"
    pass "*A", ":B^C~D*", "A"
    pass "*A", ":B~",     "A"
    pass "*A", ":B~C*",   "A"
    pass "*A", ":B~C*D^", "A"
    pass "*A", ":B~C^",   "A"
    pass "*A", ":B~C^D*", "A"
    fail "*A^"

    context "when repeating" do
      pass "*A^B", "*",     repeated("A", "B"), parent_repeatable: false
      pass "*A^B", "*C:",   repeated("A", "B"), parent_repeatable: false
      pass "*A^B", "*C:D~", repeated("A", "B"), parent_repeatable: false
      pass "*A^B", "*C~",   repeated("A", "B"), parent_repeatable: false
      pass "*A^B", "*C~D:", repeated("A", "B"), parent_repeatable: false
      pass "*A^B", ":",     repeated("A", "B"), parent_repeatable: false
      pass "*A^B", ":C*",   repeated("A", "B"), parent_repeatable: false
      pass "*A^B", ":C*D~", repeated("A", "B"), parent_repeatable: false
      pass "*A^B", ":C~",   repeated("A", "B"), parent_repeatable: false
      pass "*A^B", ":C~D*", repeated("A", "B"), parent_repeatable: false
      pass "*A^B", "~",     repeated("A", "B"), parent_repeatable: false
      pass "*A^B", "~C*",   repeated("A", "B"), parent_repeatable: false
      pass "*A^B", "~C*D:", repeated("A", "B"), parent_repeatable: false
      pass "*A^B", "~C:",   repeated("A", "B"), parent_repeatable: false
      pass "*A^B", "~C:D*", repeated("A", "B"), parent_repeatable: false
    end

    context "when component and composite are repeating" do
      pass "*A^B", "*",     repeated("A", "B"), parent_repeatable: true
      pass "*A^B", "*C:",   repeated("A", "B"), parent_repeatable: true
      pass "*A^B", "*C:D~", repeated("A", "B"), parent_repeatable: true
      pass "*A^B", "*C~",   repeated("A", "B"), parent_repeatable: true
      pass "*A^B", "*C~D:", repeated("A", "B"), parent_repeatable: true
      pass "*A^B", ":",     repeated("A", "B"), parent_repeatable: true
      pass "*A^B", ":C*",   repeated("A", "B"), parent_repeatable: true
      pass "*A^B", ":C*D~", repeated("A", "B"), parent_repeatable: true
      pass "*A^B", ":C~",   repeated("A", "B"), parent_repeatable: true
      pass "*A^B", ":C~D*", repeated("A", "B"), parent_repeatable: true
      pass "*A^B", "~",     repeated("A", "B"), parent_repeatable: true
      pass "*A^B", "~C*",   repeated("A", "B"), parent_repeatable: true
      pass "*A^B", "~C*D:", repeated("A", "B"), parent_repeatable: true
      pass "*A^B", "~C:",   repeated("A", "B"), parent_repeatable: true
      pass "*A^B", "~C:D*", repeated("A", "B"), parent_repeatable: true
    end

    context "when component and composite are non-repeating" do
      pass "*A^B", "*",     "A^B", parent_repeatable: false
      pass "*A^B", "*C:",   "A^B", parent_repeatable: false
      pass "*A^B", "*C:D~", "A^B", parent_repeatable: false
      pass "*A^B", "*C~",   "A^B", parent_repeatable: false
      pass "*A^B", "*C~D:", "A^B", parent_repeatable: false
      pass "*A^B", ":",     "A^B", parent_repeatable: false
      pass "*A^B", ":C*",   "A^B", parent_repeatable: false
      pass "*A^B", ":C*D~", "A^B", parent_repeatable: false
      pass "*A^B", ":C~",   "A^B", parent_repeatable: false
      pass "*A^B", ":C~D*", "A^B", parent_repeatable: false
      pass "*A^B", "~",     "A^B", parent_repeatable: false
      pass "*A^B", "~C*",   "A^B", parent_repeatable: false
      pass "*A^B", "~C*D:", "A^B", parent_repeatable: false
      pass "*A^B", "~C:",   "A^B", parent_repeatable: false
      pass "*A^B", "~C:D*", "A^B", parent_repeatable: false
    end

    context "when component is non-repeating but composite is repeating" do
      pass "*A", "^B*",     "A", parent_repeatable: true
      pass "*A", "^B*C:",   "A", parent_repeatable: true
      pass "*A", "^B*C:D~", "A", parent_repeatable: true
      pass "*A", "^B*C~",   "A", parent_repeatable: true
      pass "*A", "^B*C~D:", "A", parent_repeatable: true
      pass "*A", "^B:",     "A", parent_repeatable: true
      pass "*A", "^B:C*",   "A", parent_repeatable: true
      pass "*A", "^B:C*D~", "A", parent_repeatable: true
      pass "*A", "^B:C~",   "A", parent_repeatable: true
      pass "*A", "^B:C~D*", "A", parent_repeatable: true
      pass "*A", "^B~",     "A", parent_repeatable: true
      pass "*A", "^B~C*",   "A", parent_repeatable: true
      pass "*A", "^B~C*D:", "A", parent_repeatable: true
      pass "*A", "^B~C:",   "A", parent_repeatable: true
      pass "*A", "^B~C:D*", "A", parent_repeatable: true
    end

    pass "*A", "~",       "A"
    pass "*A", "~B*",     "A"
    pass "*A", "~B*C:",   "A"
    pass "*A", "~B*C:D^", "A"
    pass "*A", "~B*C^",   "A"
    pass "*A", "~B*C^D:", "A"
    pass "*A", "~B:",     "A"
    pass "*A", "~B:C*",   "A"
    pass "*A", "~B:C*D^", "A"
    pass "*A", "~B:C^",   "A"
    pass "*A", "~B:C^D*", "A"
    pass "*A", "~B^",     "A"
    pass "*A", "~B^C*",   "A"
    pass "*A", "~B^C*D:", "A"
    pass "*A", "~B^C:",   "A"
    pass "*A", "~B^C:D*", "A"
  end

  describe "#_read_composite_element" do
    def self.pass(prefix, suffix, expected, repeatable: false)
      specify "#{(prefix + suffix).inspect} => #{expected.inspect}" do
        t = Stupidedi::Reader.build(prefix + suffix, position: Stupidedi::Position::OffsetPosition)
        t.separators = Stupidedi::Reader::Separators.default

        # This is Stupidedi::Reader::Input
        input = t.instance_variable_get(:@input)

        if repeatable
          r = t.send(:_read_composite_element, input, true, :XYZ, 7)
          expect(r).to_not            be_fail
          expect(r.value).to_not      be_simple
          expect(r.value).to          be_repeated
          expect(r.value).to_not      be_composite
          expect(r.value.element_toks.map{|t|t.component_toks.map{|c|c.value.to_s}}).to eq(expected)
          expect(r.value.position).to eq(0)
          expect(r.position).to       eq(0)
          expect(r.rest).to           eq(suffix)
          expect(r.rest.position).to  eq(prefix.length)
        else
          r = t.send(:_read_composite_element, input, false, :XYZ, 7)
          expect(r).to_not            be_fail
          expect(r.value).to_not      be_simple
          expect(r.value).to_not      be_repeated
          expect(r.value).to          be_composite
          expect(r.value.component_toks.map{|t|t.value.to_s}).to eq(expected)
          expect(r.value.position).to eq(0)
          expect(r.position).to       eq(0)
          expect(r.rest).to           eq(suffix)
          expect(r.rest.position).to  eq(prefix.length)
        end
      end

      specify "#{(prefix + suffix).inspect} with control characters => #{expected.inspect}" do
        str, pos = add_control_chars(prefix + suffix)
        prefix_  = str[0 .. pos[prefix.length] - 1]
        suffix_  = str[pos[prefix.length] .. -1]

        t = Stupidedi::Reader.build(str, position: Stupidedi::Position::OffsetPosition)
        t.separators = Stupidedi::Reader::Separators.default

        # This is Stupidedi::Reader::Input
        input = t.instance_variable_get(:@input)

        if repeatable
          r = t.send(:_read_composite_element, input, true, :XYZ, 7)
          expect(r).to_not            be_fail
          expect(r.value).to_not      be_simple
          expect(r.value).to          be_repeated
          expect(r.value).to_not      be_composite
          expect(r.value.element_toks.map{|t|t.component_toks.map{|c|c.value.to_s}}).to eq(expected)
          expect(r.value.position).to eq(pos[0])
          expect(r.position).to       eq(pos[0])
          expect(r.rest).to           eq(suffix_)
          expect(r.rest.position).to  eq(prefix_.length)
        else
          r = t.send(:_read_composite_element, input, false, :XYZ, 7)
          expect(r).to_not            be_fail
          expect(r.value).to_not      be_simple
          expect(r.value).to_not      be_repeated
          expect(r.value).to          be_composite
          expect(r.value.component_toks.map{|t|t.value.to_s}).to eq(expected)
          expect(r.value.position).to eq(pos[0])
          expect(r.position).to       eq(pos[0])
          expect(r.rest).to           eq(suffix_)
          expect(r.rest.position).to  eq(prefix_.length)
        end
      end
    end

    def self.fail(input, position: 0, reason: nil, repeatable: false)
      it "#{input.inspect} is not tokenizable" do
        t = Stupidedi::Reader.build(input, position: Stupidedi::Position::OffsetPosition)
        t.separators = Stupidedi::Reader::Separators.default

        # This is Stupidedi::Reader::Input
        input = t.instance_variable_get(:@input)

        r = t.send(:_read_composite_element, input, repeatable, :XYZ, 7)
        expect(r).to          be_fail
        expect(r.position).to eq(position)
        expect(r.error).to    match(reason) unless reason.nil?
      end
    end

    pass "*A", "*",       composite("A")
    pass "*A", "*B:",     composite("A")
    pass "*A", "*B:C^",   composite("A")
    pass "*A", "*B:C^D~", composite("A")
    pass "*A", "*B:C~",   composite("A")
    pass "*A", "*B:C~D^", composite("A")
    pass "*A", "*B^",     composite("A")
    pass "*A", "*B^C:",   composite("A")
    pass "*A", "*B^C:D~", composite("A")
    pass "*A", "*B^C~",   composite("A")
    pass "*A", "*B^C~D:", composite("A")
    pass "*A", "*B~",     composite("A")
    pass "*A", "*B~C:",   composite("A")
    pass "*A", "*B~C:D^", composite("A")
    pass "*A", "*B~C^",   composite("A")
    pass "*A", "*B~C^D:", composite("A")
    fail "*A:",           position: 2
    pass "*A:B", "*",     composite("A", "B")
    pass "*A:B", "*C^",   composite("A", "B")
    pass "*A:B", "*C^D~", composite("A", "B")
    pass "*A:B", "*C~",   composite("A", "B")
    pass "*A:B", "*C~D^", composite("A", "B")
    fail "*A:B^",         position: 2

    context "when repeatable" do
      pass "*A:B^C", "*",   repeated(composite("A", "B"), composite("C")), repeatable: true
      pass "*A:B^C", "*D~", repeated(composite("A", "B"), composite("C")), repeatable: true
      pass "*A:B^C", "~",   repeated(composite("A", "B"), composite("C")), repeatable: true
      pass "*A:B^C", "~D*", repeated(composite("A", "B"), composite("C")), repeatable: true
    end

    context "when non-repeatable" do
      pass "*A:B^C", "*",   composite("A", "B^C")
      pass "*A:B^C", "*D~", composite("A", "B^C")
      pass "*A:B^C", "~",   composite("A", "B^C")
      pass "*A:B^C", "~D*", composite("A", "B^C")
    end

    pass "*A:B", "~",     composite("A", "B")
    pass "*A:B", "~C*",   composite("A", "B")
    pass "*A:B", "~C*D^", composite("A", "B")
    pass "*A:B", "~C^",   composite("A", "B")
    pass "*A:B", "~C^D*", composite("A", "B")
    fail "*A^"

    context "when repeatable" do
      pass "*A^B", "*",     repeated(composite("A"), composite("B")), repeatable: true
      pass "*A^B", "*C:",   repeated(composite("A"), composite("B")), repeatable: true
      pass "*A^B", "*C:D~", repeated(composite("A"), composite("B")), repeatable: true
      pass "*A^B", "*C~",   repeated(composite("A"), composite("B")), repeatable: true
      pass "*A^B", "*C~D:", repeated(composite("A"), composite("B")), repeatable: true
      fail "*A^B:",         position: 4, repeatable: true
      pass "*A^B:C", "*",   repeated(composite("A"), composite("B", "C")), repeatable: true
      pass "*A^B:C", "*D~", repeated(composite("A"), composite("B", "C")), repeatable: true
      pass "*A^B:C", "~",   repeated(composite("A"), composite("B", "C")), repeatable: true
      pass "*A^B:C", "~D*", repeated(composite("A"), composite("B", "C")), repeatable: true
      pass "*A^B", "~",     repeated(composite("A"), composite("B")), repeatable: true
      pass "*A^B", "~C*",   repeated(composite("A"), composite("B")), repeatable: true
      pass "*A^B", "~C*D:", repeated(composite("A"), composite("B")), repeatable: true
      pass "*A^B", "~C:",   repeated(composite("A"), composite("B")), repeatable: true
      pass "*A^B", "~C:D*", repeated(composite("A"), composite("B")), repeatable: true
    end

    context "when non-repeatable" do
      pass "*A^B", "*",     composite("A^B")
      pass "*A^B", "*C:",   composite("A^B")
      pass "*A^B", "*C:D~", composite("A^B")
      pass "*A^B", "*C~",   composite("A^B")
      pass "*A^B", "*C~D:", composite("A^B")
      fail "*A^B:",         position: 4
      pass "*A^B:C", "*",   composite("A^B", "C")
      pass "*A^B:C", "*D~", composite("A^B", "C")
      pass "*A^B:C", "~",   composite("A^B", "C")
      pass "*A^B:C", "~D*", composite("A^B", "C")
      pass "*A^B", "~",     composite("A^B")
      pass "*A^B", "~C*",   composite("A^B")
      pass "*A^B", "~C*D:", composite("A^B")
      pass "*A^B", "~C:",   composite("A^B")
      pass "*A^B", "~C:D*", composite("A^B")
    end

    pass "*A", "~",       composite("A")
    pass "*A", "~B*",     composite("A")
    pass "*A", "~B*C:",   composite("A")
    pass "*A", "~B*C:D^", composite("A")
    pass "*A", "~B*C^",   composite("A")
    pass "*A", "~B*C^D:", composite("A")
    pass "*A", "~B:",     composite("A")
    pass "*A", "~B:C*",   composite("A")
    pass "*A", "~B:C*D^", composite("A")
    pass "*A", "~B:C^",   composite("A")
    pass "*A", "~B:C^D*", composite("A")
    pass "*A", "~B^",     composite("A")
    pass "*A", "~B^C*",   composite("A")
    pass "*A", "~B^C*D:", composite("A")
    pass "*A", "~B^C:",   composite("A")
    pass "*A", "~B^C:D*", composite("A")
  end
end
