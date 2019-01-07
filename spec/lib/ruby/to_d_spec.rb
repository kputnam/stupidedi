using Stupidedi::Refinements

describe "Float#to_d" do
  include QuickCheck::Macro

  property "f.to_d raises an error" do
    float
  end.check do |f|
    expect(lambda { f.to_d }).to raise_error
  end
end

describe "Integer#to_d" do
  include QuickCheck::Macro

  property "int.to_d = int" do
    integer
  end.check{|n| expect(n).to be == n.to_d }

  property "int.to_d is a BigDecimal" do
    integer
  end.check{|n| expect(n.to_d).to be_a(BigDecimal) }
end

describe "Rational#to_d" do
  include QuickCheck::Macro

  property "rational.to_d ≈ rational" do
    Rational(integer, integer)
  end.check{|r| expect(r.to_d).to be_within(1e-10).of(r) }

  property "rational.to_d is a BigDecimal" do
    Rational(integer, integer)
  end.check{|r| expect(r.to_d).to be_a(BigDecimal) }
end

describe "BigDecimal#to_d" do
  include QuickCheck::Macro

  property "decimal.to_d = decimal" do
    integer.to_d
  end.check{|b| expect(b.to_d).to be == b }
end

describe "String#to_d" do
  include QuickCheck::Macro

  context "when string has a valid format" do
    property "string.to_d = BigDecimal(s)" do
      Rational(integer, integer).to_d.to_s("F")
    end.check{|s| expect(s.to_d).to be == BigDecimal(s) }

    property "string.to_d = BigDecimal(s)" do
      Rational(integer, integer).to_d.to_s
    end.check{|s| expect(s.to_d).to be == BigDecimal(s) }

    property "string.to_d = BigDecimal(s)" do
      integer.to_s
    end.check{|s| expect(s.to_d).to be == BigDecimal(s) }

    property "string.to_d = BigDecimal(s)" do
      Rational(integer, integer).to_f.to_s
    end.check{|s| expect(s.to_d).to be == BigDecimal(s) }
  end

  context "when string has an invalid format" do
    property "string.to_d raises an error" do
      string
    end.check do |s|
      expect(lambda { s.to_d }).to raise_error
    end
  end
end
