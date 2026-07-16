# frozen_string_literal: true
require "spec_helper"

# Reproducer for the non-determinism error that fires when a LoopDef has
# two structurally-identical SegmentUse slots for the same segment id and
# the input fills only the earlier slot. See:
#
#   ai/tickets/tediparse-04-resolve-duplicate-segment-slot-nondeterminism.md
#
# Uses generic placeholder segment ids (:AA, :CC) and a synthetic transaction
# set "XX*999" registered into a fresh Config so the test is independent of
# any X12 transaction-set definition.
describe "Duplicate sibling segment slots in a single loop" do
  using Stupidedi::Refinements

  let(:b) { Stupidedi::TransactionSets::Builder       }
  let(:d) { Stupidedi::Schema                          }
  let(:r) { Stupidedi::Versions::FiftyTen::SegmentReqs }
  let(:e) { Stupidedi::Versions::FiftyTen::ElementReqs }
  let(:s) { Stupidedi::Versions::FiftyTen::SegmentDefs }

  # Generic placeholder element types — single-character ID with a code list
  # of {P, O} lets us discriminate the two opener slots; AN with no code
  # list keeps the ambiguous slot indiscriminate.
  let(:de_qualifier) do
    Stupidedi::Versions::Common::ElementTypes::ID.new(:DE_QUAL, "Qualifier", 1, 1,
      d::CodeList.internal({"P" => "Primary", "O" => "Override"}))
  end

  let(:de_text) do
    Stupidedi::Versions::Common::ElementTypes::AN.new(:DE_TEXT, "Free Text", 1, 30)
  end

  # Synthetic AA opener: qualifier + free text. Per-use Values("P") / Values("O")
  # let ValueBased discriminate the two AA SegmentUses in the loop.
  let(:aa_def) do
    d::SegmentDef.build(:AA, "AA Opener", "",
      de_qualifier.simple_use(e::Mandatory, d::RepeatCount.bounded(1)),
      de_text.simple_use(e::Optional, d::RepeatCount.bounded(1)))
  end

  # Synthetic CC ambiguous segment: two free-text elements, no code list.
  # Two CC SegmentUses in the same loop are structurally identical — there
  # is no element value the parser can use to discriminate them.
  let(:cc_def) do
    d::SegmentDef.build(:CC, "CC Ambiguous", "",
      de_text.simple_use(e::Mandatory, d::RepeatCount.bounded(1)),
      de_text.simple_use(e::Optional, d::RepeatCount.bounded(1)))
  end

  # Single loop with two AA opener slots (P-qualified primary, O-qualified
  # override) and two CC ambiguous slots — mirrors the partner-customised
  # 4010 PO850 N1 loop from TEDI-422.
  let(:transaction_set_def) do
    aa = aa_def
    cc = cc_def

    b.build("XX", "999", "Test - duplicate slots in one loop",
      d::TableDef.header("Heading",
        s::ST.use(100, r::Mandatory, d::RepeatCount.bounded(1)),
        d::LoopDef.build("L1", d::RepeatCount.bounded(1),
          b.Segment(200, aa, "Primary Opener", r::Mandatory,
            d::RepeatCount.bounded(1),
            b.Element(e::Mandatory, "AA01 Qualifier", b.Values("P")),
            b.Element(e::Optional,  "AA02 Free Text")),
          b.Segment(300, cc, "Primary CC", r::Optional,
            d::RepeatCount.bounded(1),
            b.Element(e::Mandatory, "CC01 First"),
            b.Element(e::Optional,  "CC02 Second")),
          b.Segment(400, aa, "Override Opener", r::Optional,
            d::RepeatCount.bounded(1),
            b.Element(e::Mandatory, "AA01 Qualifier", b.Values("O")),
            b.Element(e::Optional,  "AA02 Free Text")),
          b.Segment(500, cc, "Override CC", r::Optional,
            d::RepeatCount.bounded(1),
            b.Element(e::Mandatory, "CC01 First"),
            b.Element(e::Optional,  "CC02 Second"))),
        s::SE.use(600, r::Mandatory, d::RepeatCount.bounded(1))))
  end

  let(:config) do
    ts = transaction_set_def
    Stupidedi::Config.default.customize do |c|
      c.transaction_set.register("005010", "XX", "999") { ts }
    end
  end

  def envelope(body)
    <<~EDI.gsub("\n", "~")
      ISA*00*          *00*          *ZZ*SENDER         *ZZ*RECEIVER       *230101*1200*U*00501*000000001*0*P*>
      GS*XX*SENDER*RECEIVER*20230101*1200*1*X*005010
      ST*999*0001
      #{body}
      SE*99*0001
      GE*1*1
      IEA*1*000000001
    EDI
  end

  def parse(edi)
    Stupidedi::Parser.build(config).read(Stupidedi::Reader.build(edi))
  end

  def first_cc(machine)
    machine.first
      .flatmap{|m| m.find(:GS) }
      .flatmap{|m| m.find(:ST) }
      .flatmap{|m| m.find(:AA) }
      .flatmap{|m| m.find(:CC) }
      .fetch
  end

  def cc_position(machine)
    first_cc(machine).zipper.fetch.node.usage.position
  end

  context "earlier slot only (TEDI-422 reproducer)" do
    it "parses successfully and binds CC to the earlier-positioned slot" do
      machine, result = parse(envelope("AA*P*hello\nCC*alpha"))

      if result.fatal?
        result.explain { |msg| fail "Parse error: #{msg}" }
      end
      expect(result).to be_success

      expect(cc_position(machine)).to eq(300)
    end
  end

  # Mirrors the real-world PO850 N1 loop shape: the loop is opened by the
  # primary opener (AA*P at position 200), then a second qualifier-
  # distinguished opener inside the loop body (AA*O at position 400)
  # advances the parse into the override block. The override CC must bind
  # to position 500, even though both CC slots remain candidates from the
  # constraint table's perspective. This is what Variant A buys over
  # Variant B: the structural-reachability check uses the parse tree to
  # see that the cursor has already moved past position 400.
  context "later slot reached via in-loop opener" do
    it "binds CC to the later-positioned slot" do
      machine, result = parse(envelope("AA*P*hello\nAA*O*goodbye\nCC*beta"))

      if result.fatal?
        result.explain { |msg| fail "Parse error: #{msg}" }
      end
      expect(result).to be_success
      expect(cc_position(machine)).to eq(500)
    end
  end

  context "both blocks present" do
    it "parses successfully and binds each CC to its own slot" do
      machine, result = parse(envelope("AA*P*hello\nCC*alpha\nAA*O*goodbye\nCC*beta"))

      if result.fatal?
        result.explain { |msg| fail "Parse error: #{msg}" }
      end
      expect(result).to be_success

      # Walk to the first CC, then iterate to the next CC.
      first  = first_cc(machine)
      second = first.find(:CC).fetch

      expect(first .zipper.fetch.node.usage.position).to eq(300)
      expect(second.zipper.fetch.node.usage.position).to eq(500)
    end
  end

  # End-to-end guard for the genuinely-ambiguous case: two CC SegmentUses
  # whose parents are different LoopDef objects. The disambiguation
  # precondition `parent.equal?` fails, the helper bails out, and the
  # parser surfaces "too much non-determinism" exactly as it did before
  # the fix. This proves the precondition correctly trickles out of
  # disambiguate_sibling_slots into the parser's failure path, not just
  # the unit test below.
  context "two same-id slots in different parent loops (genuinely ambiguous)" do
    let(:ambiguous_transaction_set_def) do
      cc = cc_def

      b.build("XX", "998", "Test - ambiguous across parent loops",
        d::TableDef.header("Heading",
          s::ST.use(100, r::Mandatory, d::RepeatCount.bounded(1)),
          d::LoopDef.build("LA", d::RepeatCount.bounded(1),
            b.Segment(200, cc, "LA CC", r::Optional,
              d::RepeatCount.bounded(1),
              b.Element(e::Mandatory, "CC01 First"),
              b.Element(e::Optional,  "CC02 Second"))),
          d::LoopDef.build("LB", d::RepeatCount.bounded(1),
            b.Segment(400, cc, "LB CC", r::Optional,
              d::RepeatCount.bounded(1),
              b.Element(e::Mandatory, "CC01 First"),
              b.Element(e::Optional,  "CC02 Second"))),
          s::SE.use(600, r::Mandatory, d::RepeatCount.bounded(1))))
    end

    let(:ambiguous_config) do
      ts = ambiguous_transaction_set_def
      Stupidedi::Config.default.customize do |c|
        c.transaction_set.register("005010", "XX", "998") { ts }
      end
    end

    def envelope_998(body)
      <<~EDI.gsub("\n", "~")
        ISA*00*          *00*          *ZZ*SENDER         *ZZ*RECEIVER       *230101*1200*U*00501*000000001*0*P*>
        GS*XX*SENDER*RECEIVER*20230101*1200*1*X*005010
        ST*998*0001
        #{body}
        SE*99*0001
        GE*1*1
        IEA*1*000000001
      EDI
    end

    it "preserves the non-determinism error when survivors have different parents" do
      _machine, result = Stupidedi::Parser.build(ambiguous_config)
        .read(Stupidedi::Reader.build(envelope_998("CC*alpha")))
      expect(result.fatal?).to be true
      msg = nil
      result.explain {|m| msg = m }
      expect(msg).to include("too much non-determinism")
    end
  end

  # Mirrors the LoopDef shape supported since commit 7d203a74 — segments
  # interleaved with child loops. Outer loop layout:
  #   [AA@200, CC@300, inner_loop@400, CC@500]
  # After consuming AA*P + the inner loop's BB segment, a CC token must
  # bind to position 500 (post-inner-loop), not position 300 (pre).
  #
  # `highest_consumed_position` only scans segment children of the
  # matching parent loop, so on its own it would return position 200
  # (the outer AA) and pick CC@300 — wrong. This case nonetheless
  # works because `InstructionTable#drop_count` prunes CC@300 from the
  # candidate set when the parser advances past the inner loop, so by
  # the time the CC token arrives `disambiguate_sibling_slots` is not
  # called at all (single-instruction `Stub` is selected upstream in
  # `ConstraintTable.build`). This spec locks in that interaction:
  # if a future change to the InstructionTable mechanism stops pruning,
  # this test will fail and the watermark logic will need to consider
  # consumed sibling LoopVals.
  context "interleaved child loop between two same-id sibling slots" do
    let(:bb_def) do
      d::SegmentDef.build(:BB, "BB Inner Opener", "",
        de_text.simple_use(e::Mandatory, d::RepeatCount.bounded(1)))
    end

    let(:interleaved_transaction_set_def) do
      aa = aa_def
      bb = bb_def
      cc = cc_def

      b.build("XX", "997", "Test - interleaved child loop",
        d::TableDef.header("Heading",
          s::ST.use(100, r::Mandatory, d::RepeatCount.bounded(1)),
          d::LoopDef.build("L1", d::RepeatCount.bounded(1),
            b.Segment(200, aa, "Outer Opener", r::Mandatory,
              d::RepeatCount.bounded(1),
              b.Element(e::Mandatory, "AA01 Qualifier", b.Values("P")),
              b.Element(e::Optional,  "AA02 Free Text")),
            b.Segment(300, cc, "Pre-loop CC", r::Optional,
              d::RepeatCount.bounded(1),
              b.Element(e::Mandatory, "CC01 First"),
              b.Element(e::Optional,  "CC02 Second")),
            d::LoopDef.build("L1A", d::RepeatCount.bounded(1),
              b.Segment(400, bb, "Inner Opener", r::Mandatory,
                d::RepeatCount.bounded(1),
                b.Element(e::Mandatory, "BB01 First"))),
            b.Segment(500, cc, "Post-loop CC", r::Optional,
              d::RepeatCount.bounded(1),
              b.Element(e::Mandatory, "CC01 First"),
              b.Element(e::Optional,  "CC02 Second"))),
          s::SE.use(600, r::Mandatory, d::RepeatCount.bounded(1))))
    end

    let(:interleaved_config) do
      ts = interleaved_transaction_set_def
      Stupidedi::Config.default.customize do |c|
        c.transaction_set.register("005010", "XX", "997") { ts }
      end
    end

    def envelope_997(body)
      <<~EDI.gsub("\n", "~")
        ISA*00*          *00*          *ZZ*SENDER         *ZZ*RECEIVER       *230101*1200*U*00501*000000001*0*P*>
        GS*XX*SENDER*RECEIVER*20230101*1200*1*X*005010
        ST*997*0001
        #{body}
        SE*99*0001
        GE*1*1
        IEA*1*000000001
      EDI
    end

    it "binds CC to the post-inner-loop slot when the inner loop is consumed" do
      machine, result = Stupidedi::Parser.build(interleaved_config)
        .read(Stupidedi::Reader.build(envelope_997("AA*P\nBB*innervalue\nCC*beta")))

      if result.fatal?
        result.explain { |msg| fail "Parse error: #{msg}" }
      end
      expect(result).to be_success

      cc = machine.first
        .flatmap{|m| m.find(:GS) }
        .flatmap{|m| m.find(:ST) }
        .flatmap{|m| m.find(:AA) }
        .flatmap{|m| m.find(:BB) }
        .flatmap{|m| m.find(:CC) }
        .fetch
      expect(cc.zipper.fetch.node.usage.position).to eq(500)
    end
  end

  # Direct unit tests on the helper that disambiguates duplicate sibling
  # slots. Constructing a parser state where two same-id SegmentUses with
  # *different* parents both survive ValueBased filtering is awkward and
  # partner-grammar specific, so we pin the precondition logic with a unit
  # test instead. LoopDef#build leaves children with `parent: nil`; we use
  # LoopDef.new with a non-nil parent argument so the constructor's
  # re-parenting block fires (see schema/loop_def.rb:35-37) and SegmentUse
  # parents become the LoopDef instances.
  context "ConstraintTable::ValueBased#disambiguate_sibling_slots" do
    let(:stub_parent) { Object.new }

    def make_instruction(segment_use)
      Stupidedi::Parser::Instruction.new(:CC, segment_use, 0, 0, nil)
    end

    def make_table(instructions)
      Stupidedi::Parser::ConstraintTable::ValueBased.new(instructions)
    end

    it "picks earliest position when survivors share a parent loop" do
      shared_loop = d::LoopDef.new("LS", d::RepeatCount.bounded(1),
        [cc_def.use(100, r::Optional, d::RepeatCount.bounded(1)),
         cc_def.use(200, r::Optional, d::RepeatCount.bounded(1))],
        stub_parent)

      early_use = shared_loop.children.at(0)
      late_use  = shared_loop.children.at(1)

      expect(early_use.parent).to be(shared_loop)
      expect(late_use.parent).to  be(shared_loop)

      early = make_instruction(early_use)
      late  = make_instruction(late_use)

      result = make_table([early, late]).send(:disambiguate_sibling_slots, [early, late])
      expect(result).to contain_exactly(early)
    end

    it "returns input unchanged when survivors are in different parent loops" do
      loop_a = d::LoopDef.new("LA", d::RepeatCount.bounded(1),
        [cc_def.use(100, r::Optional, d::RepeatCount.bounded(1))], stub_parent)
      loop_b = d::LoopDef.new("LB", d::RepeatCount.bounded(1),
        [cc_def.use(200, r::Optional, d::RepeatCount.bounded(1))], stub_parent)

      use_a = loop_a.children.at(0)
      use_b = loop_b.children.at(0)

      expect(use_a.parent).not_to be(use_b.parent)

      instr_a = make_instruction(use_a)
      instr_b = make_instruction(use_b)

      result = make_table([instr_a, instr_b]).send(:disambiguate_sibling_slots, [instr_a, instr_b])
      expect(result).to contain_exactly(instr_a, instr_b)
    end
  end
end
