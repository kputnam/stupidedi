#!/usr/bin/env ruby
require File.expand_path("../../lib/stupidedi", __FILE__)
require "pp"

# See https://github.com/irobayna/stupidedi/issues/160
class MyBuilder < Stupidedi::Parser::BuilderDsl
  def DTP(dtp01, dtp02, dtp03, *args)
    super(dtp01, dtp02, strftime(dtp02, dtp03), *args)
  end

  def DMG(dmg01, dmg02, *args)
    super(dmg01, strftime(dmg01, dmg02), *args)
  end

  def strftime(format, value)
    Stupidedi::Versions::Common::ElementTypes::AN.strftime(format, value)
  end

end

stack = Stupidedi::Parser::IdentifierStack.new(60)
b = MyBuilder.build(Stupidedi::Config.hipaa)

b.ISA("00", "",
      "00", "",
      "ZZ", "SUBMITTER ID",
      "ZZ", "RECEIVER ID",
      Time.now, Time.now, "^",
      "00501",
      stack.isa, "0", "T", ":")

# Calling `stack.gs` will only work when last thing called on `stack` was
# `stack.isa`, else a {NoMethodError} is thrown. This generates a new value to
# be used in GS06 and GE02.
#
b. GS("HC", "SENDER ID", "RECEIVER ID",
      Time.now, Time.now,
      stack.gs, b.default, "005010")

# HEADER
#
# Calling `stack.st` will only work when the last thing called on `stack` was
# `stack.gs`.  Otherwise, results in {NoMethodError}. It will generate a new
# unique value that can be used in ST02 and SE.
#
b. ST("837", stack.st, "005010X223A2")
b.BHT("0019", "00", "X"*30, "19990531", Time.now.utc, "CH")

  # 1000A SUBMITTER NAME
  b.NM1("41", "1", "SUBMITTER NAME", "", "", "", "", "46", "12EEER000TY")
  b.PER(b.default, b.blank, "TE", "7607067425")

  # 1000B RECEIVER NAME
  b.NM1("40", "2", "RECEIVER NAME", "", "", "", "", "46", "IDENTIFICATION")

# LOOP 2000A BILLING PROVIDER (@todo: required)
#
# Generate a unique value to use in HL01 and children HL02 with `stack.hl`. Note
# you must have previously called `stack.st`.
b. HL(stack.hl, b.not_used, "20", b.default)
  # LOOP 2010AA
  b.NM1("85", b.default, "BILLING PROVIDER")
  b. N3("123 SESAME STREET")
  b. N4("NEW YORK CITY")
  b.REF(b.default, "TAX IDENTIFIER")

# LOOP 2000B SUBSCRIBER (@todo: required)
#
# This HL segment is a sibling of the previous one (2000A), at the syntactical
# level. However, semantically, 2000B is a child of 2000A, because the we put
# the value from 2000A's HL01 in this 2000B's HL02.
b.HL(stack.hl, stack.parent_hl, "22", "0")
  b.SBR("P")

  # LOOP 2010BA SUBSCRIBER NAME
  b.NM1("IL", "2", "SUBSCRIBER NAME", nil, nil, nil, nil, "MI", "MEMBER ID")
  b. N4("NEW YORK CITY")

  # LOOP 2010BB PAYER NAME
  b.NM1("PR", b.default, "PAYER NAME", nil, nil, nil, nil, "PI", "PAYER ID")
  b. N4("NEW YORK CITY")

# LOOP 2000C PATIENT
b.HL(stack.hl, stack.parent_hl, "23", b.default)
  b.PAT("01")

  # LOOP 2010CA PATIENT NAME
  b.NM1(b.default, b.default, "SPOUSE NAME")
  b. N3("123 SESAME STREET")
  b. N4("NEW YORK CITY")
  b.DMG("D8", Time.now, "U")

  # LOOP 2300 CLAIM INFORMATION
  b.CLM("CLAIM ID", 7500, nil, nil, b.composite("1", b.default, "1"), nil, "A", "Y", "I")
  b.DTP("434", "RD8", Time.now .. Time.now)
  b.CL1("3", nil, "21")
  b. HI(b.composite("BK", "277.0"))

    # LOOP 2400 SERVICE LINE
    b. LX(1)
    b.SV2("0242", b.composite("HC", "30713"), 2500, "UN", 2)

stack.pop_hl # Discard 2000C's HL01
stack.pop_hl # Discard 2000B's HL01
stack.pop_hl # Discard 2000A's HL01

# Calculate number of segments between ST/SE, then return the transaction set
# control number (ST02 / SE02)
b. SE(stack.count(b), stack.pop_st)

# Calculate number of ST/SE envelopes, and then return the functional group
# control number (GS01 / GE02)
b. GE(stack.count, stack.pop_gs)

# Calculate number of ISA/IEA envelopes in IEA01, and then get the interchange
# control number (ISA13 / IEA02)
b.IEA(stack.count, stack.pop_isa)

# Pretty print the parse tree
b.zipper.tap {|z| pp z.root.node; puts }

# Print X12-formatted text
b.machine.zipper.tap do |z|
  separators = Stupidedi::Reader::Separators.build \
    :segment    => "~\n",
    :element    => "*"
    # @note: We can override values provided to ISA11 and ISA16 here
    # :component  => ":",
    # :repetition => "^",

  Stupidedi::Writer::Default.new(z.root, separators).write($stdout)
end
