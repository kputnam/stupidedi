#!/usr/bin/env ruby
require File.expand_path("../../lib/stupidedi", __FILE__)
require "pp"

# See https://github.com/irobayna/stupidedi/issues/160
class MyBuilder < Stupidedi::Parser::BuilderDsl
  def DTP(dtp01, dtp02, dtp03, *args)
    super(dtp01, dtp02, fmt1251(dtp02, dtp03), *args)
  end

  def DMG(dmg01, dmg02, *args)
    super(dmg01, fmt1251(dmg01, dmg02), *args)
  end

  def fmt1251(code, value)
    single =
     {"CC" => "%C",
      "CM" => "%Y%m",
      "CY" => "%Y",
      "D6" => "%y%m%d",
      "D8" => "%Y%m%d",
      "DB" => "%m%d%Y",
      "DD" => "%d",
      "DT" => "%Y%m%d%H%M",
      "KA" => "%y%m%d",
      "MD" => "%m%d",
      "MM" => "%m",
      "TM" => "%H%M",
      "TQ" => "%m%y",
      "TR" => "%d%m%y%H%M",
      "TS" => "%H%M%S",
      "TT" => "%m%d%y",
      "UN" => "",
      "YM" => "%y%m",
      "YY" => "%Y"}

    range =
     {"DA"  => ["%d", "%d"],
      "DDT" => ["%Y%m%d", "%Y%m%d%H%M"],
      "DTD" => ["%Y%m%d%H%M", "%Y%m%d"],
      "DTS" => ["%Y%m%d%H%M%S", "%Y%m%d%H%M%S"],
      "RD"  => ["%m%d%Y", "%m%d%Y"],
      "RD2" => ["%y", "%y"],
      "RD4" => ["%Y", "%Y"],
      "RD5" => ["%Y%m", "%Y%m"],
      "RD6" => ["%y%m%d", "%y%m%d"],
      "RD8" => ["%Y%m%d", "%Y%m%d"],
      "RDM" => ["%y%m%d", "%m%d"],
      "RDT" => ["%Y%m%d%H%M", "%Y%m%d%H%M"],
      "RMD" => ["%m%d", "%m%d"],
      "RMY" => ["%y%m", "%y%m"],
      "RTM" => ["%H%M", "%H%M"],
      "RTS" => ["%Y%m%d%H%M%S"]}

    if range.include?(code)
      unless value.is_a?(Range)
        raise "expected a range (a..b) but got #{value.inspect}"
      end
      a, b = range[code]
      "#{value.begin.strftime(a)}-#{value.end.strftime(b)}"
    elsif single.include?(code)
      value.strftime(single[code])
    else
      raise "unrecognized format code #{code.inspect}"
    end
  end
end

x = Stupidedi::Parser::IdentifierStack.new(60)
b = MyBuilder.build(Stupidedi::Config.hipaa)

b.ISA("00", "",
      "00", "",
      "ZZ", "SUBMITTER ID",
      "ZZ", "RECEIVER ID",
      Time.now, Time.now, "^",  # @note: repetition separator "^" is ignored here
      "00501",
      x.isa, "0", "T", ":")     # @note: component separator ":" is ignored here

# Calling `x.gs` will only work when last thing called on `x` was `x.gs`, else
# a {NoMethodError} is thrown. This generates a new value to be used in GS06
# and GE02.
#
b. GS("HC", "SENDER ID", "RECEIVER ID",
      Time.now, Time.now,
      x.gs, b.default, "005010")

# HEADER
#
# Calling `x.st` will only work when the last thing called on `x` was `x.gs`.
# Otherwise, results in {NoMethodError}. It will generate a new unique value
# that can be used in ST02 and SE.
#
b. ST("837", x.st, "005010X223")
b.BHT("0019", "00", "X"*30, "19990531", Time.now.utc, "CH")

  # 1000A SUBMITTER NAME
  b.NM1("41", "1", "SUBMITTER NAME", "", "", "", "", "46", "12EEER000TY")
  b.PER(b.default, b.blank, "TE", "7607067425")

  # 1000B RECEIVER NAME
  b.NM1("40", "2", "RECEIVER NAME", "", "", "", "", "46", "IDENTIFICATION")

# LOOP 2000A BILLING PROVIDER (@todo: required)
#
# Generate a unique value to use in HL01 and children HL02 with `x.hl`. Note
# you must have previously called `x.st`.
b. HL(x.hl, b.not_used, "20", b.default)
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
#
# @note: It is important that we do `x.pop` *first*, to get the 2000A HL's id
# *before* calling `x.hl` again for 2000B's HL01. The data dependency is more
# clearly demonstrated this way:
#
#   l2000a_hl01 = x.hl
#   l2000b_hl02 = x.pop   #=> equal to l2000a_hl01 (most recent x.hl)
#   l2000b_hl01 = x.hl
#   ...
#   x.pop                 #=> equal to l2000b_hl01 (most recent x.hl)
#
x.pop.tap{|parent| b. HL(x.hl, parent, "22", "0") }
  b.SBR("P")

  # LOOP 2010BA SUBSCRIBER NAME
  b.NM1("IL", "2", "SUBSCRIBER NAME", nil, nil, nil, nil, "MI", "MEMBER ID")
  b. N4("NEW YORK CITY")

  # LOOP 2010BB PAYER NAME
  b.NM1("PR", b.default, "PAYER NAME", nil, nil, nil, nil, "PI", "PAYER ID")
  b. N4("NEW YORK CITY")

# LOOP 2000C PATIENT
x.pop.tap{|parent| b.HL(x.hl, parent, "23", b.default) }
  b.PAT("01")

  # LOOP 2010CA PATIENT NAME
  b.NM1(b.default, b.default, "SPOUSE NAME")
  b. N3("123 SESAME STREET")
  b. N4("NEW YORK CITY")
  b.DMG("D8", Time.now, "U")

  # LOOP 2300 CLAIM INFORMATION
  b.CLM("CLAIM ID", 7500, nil, nil, b.composite("1", b.default, "1"), nil, "A", "Y", "I")
  b.DTP("434", "RD8", Time.now .. Time.now)
  b.CL1(nil, nil, "21")
  b. HI(b.composite("BK", "277.0"))

    # LOOP 2400 SERVICE LINE
    b. LX(1)
    b.SV2("0242", b.composite("HC", "30713"), 2500, "UN", 2)

x.pop # Discard 2000C's HL01, nothing needs to refer back to it

# Calculate number of segments between ST/SE, then return the transaction set
# control number (ST02 / SE02)
b. SE(x.count(b), x.pop)

# Calculate number of ST/SE envelopes, and then return the functional group
# control number (GS01 / GE02)
b. GE(x.count, x.pop)

# Calculate number of ISA/IEA envelopes in IEA01, and then get the interchange
# control number (ISA13 / IEA02)
b.IEA(x.count, x.pop)

# Pretty print the parse tree
b.zipper.map {|z| pp z.root.node }

# Print X12-formatted text
b.machine.zipper.tap do |z|
  separators = Stupidedi::Reader::Separators.build \
    :segment    => "~\n",
    :element    => "*",
    :component  => ":",
    :repetition => "^"

  puts
  w = Stupidedi::Writer::Default.new(z.root, separators)
  $stdout.write(w.write)
end
