describe "Stupidedi::TransactionSets::Validation::Ambiguity" do
  using Stupidedi::Refinements

  let(:d) { Stupidedi::Schema }
  let(:b) { Stupidedi::TransactionSets::Builder }
  let(:s) { Stupidedi::TransactionSets::FiftyTen::SegmentDefs }
  let(:e) { Stupidedi::TransactionSets::FiftyTen::Implementations::ElementReqs }
  let(:r) { Stupidedi::TransactionSets::FiftyTen::Implementations::SegmentReqs }

  def audit(t, msg=nil)
    Stupidedi::TransactionSets::Validation::Ambiguity.build(t,
      Stupidedi::Versions::FiftyTen::FunctionalGroupDef).audit
  end

  def complain(*patterns)
    raise_error(Stupidedi::Exceptions::InvalidSchemaError) do |e|
      patterns.each do |p|
        raise e unless e.message =~ p
      end
    end
  end

  it "no need" do
    expect(lambda do
      audit(b.build("XX", "000", "Example",
        d::TableDef.header("Table 1",
          s::ST.use(10, r::Required, d::RepeatCount.bounded(1)),
          d::LoopDef.build("Loop 1", d::RepeatCount.bounded(2),
            s::HI.use(20, r::Required, d::RepeatCount.bounded(1)),
            s::LS.use(30, r::Required, d::RepeatCount.bounded(1))))))
    end).not_to complain
  end

  it "no constraints, sibling" do
    expect(lambda do
      audit(b.build("XX", "000", "Example",
        d::TableDef.header("Table 1",
          s::ST.use(10, r::Required, d::RepeatCount.bounded(1)),
          s::ST.use(20, r::Required, d::RepeatCount.bounded(1)))))
    end).to complain(/no constraints/, /Stub/)
  end

  it "no constraints, loop" do
    expect(lambda do
      audit(b.build("XX", "000", "Example",
        d::TableDef.header("Table 1",
          s::ST.use(10, r::Required, d::RepeatCount.bounded(1)),
          d::LoopDef.build("Loop 1", d::RepeatCount.bounded(2),
            s::HI.use(20, r::Required, d::RepeatCount.bounded(1)),
            s::ST.use(30, r::Required, d::RepeatCount.bounded(1))))))
    end).to complain(/no constraints/)
  end

  it "no constraints, nested loop" do
    expect(lambda do
      audit(b.build("XX", "000", "Example",
        d::TableDef.header("Table 1",
          s::ST.use(10, r::Required, d::RepeatCount.bounded(1)),
          d::LoopDef.build("Loop 1", d::RepeatCount.bounded(2),
            s::LS.use(20, r::Required, d::RepeatCount.bounded(1)),
            d::LoopDef.build("Loop 1.1", d::RepeatCount.bounded(2),
              s::ST.use(30, r::Required, d::RepeatCount.bounded(1)))))))
    end).to complain(/no constraints/)
  end

  it "overlapping qualifiers" do
    # In NTE01, ADD is common between both uses
    expect(lambda do
      audit(b.build("XX", "000", "Example",
        d::TableDef.header("Table 1",
          s::ST.use(10, r::Required, d::RepeatCount.bounded(1)),
          b::Segment(20, s::NTE, "1", r::Required, d::RepeatCount.bounded(1),
            b::Element(e::Required, "NTE01", b::Values("ADD","CER")),
            b::Element(e::Required, "NTE02")),
          b::Segment(20, s::NTE, "2", r::Required, d::RepeatCount.bounded(1),
            b::Element(e::Required, "NTE01", b::Values("ADD")),
            b::Element(e::Required, "NTE02")))))
    end).to complain(/overlapping/, /ValueBased/)
  end

  it "optional qualifiers" do
    # In NTE01, ADD and CER are mutually exclusive, but NTE01 is optional
    expect(lambda do
      audit(b.build("XX", "000", "Example",
        d::TableDef.header("Table 1",
          s::ST.use(10, r::Required, d::RepeatCount.bounded(1)),
          b::Segment(20, s::NTE, "1", r::Required, d::RepeatCount.bounded(1),
            b::Element(e::Situational, "NTE01", b::Values("CER")),
            b::Element(e::Required,    "NTE02")),
          b::Segment(20, s::NTE, "2", r::Required, d::RepeatCount.bounded(1),
            b::Element(e::Situational, "NTE01", b::Values("ADD")),
            b::Element(e::Required,    "NTE02")))))
    end).to complain(/optional/, /ValueBased/)
  end

  it "disjoint qualifiers" do
    # In NTE01, ADD and CER are mutually exclusive, but NTE01 is optional
    expect(lambda do
      audit(b.build("XX", "000", "Example",
        d::TableDef.header("Table 1",
          s::ST.use(10, r::Required, d::RepeatCount.bounded(1)),
          b::Segment(20, s::NTE, "1", r::Required, d::RepeatCount.bounded(1),
            b::Element(e::Required, "NTE01", b::Values("CER")),
            b::Element(e::Required, "NTE02")),
          b::Segment(20, s::NTE, "2", r::Required, d::RepeatCount.bounded(1),
            b::Element(e::Required, "NTE01", b::Values("ADD")),
            b::Element(e::Required, "NTE02")))))
    end).not_to complain
  end
end
