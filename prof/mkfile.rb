#!/usr/bin/env ruby

base = <<-X12
ISA*00* *00* *14*004321519IBMP *ZZ*7777777777 *071011*0239*U*00400*000409939* *P*>~
GS*SC*004321519*7777777777*20071011*0239*409939*X*004010~
ST*832*0001~
BCT*PC*FISHER 10/10/07****CATALOG 0000001~
DTM*009*20071010*1632~
N1*ST*SPECIAL LABS*91*999999001~
N3*1000 PENNSYLVANIA AVE~
N4*PITTSBURGH*PA*15222~
X12

# P: 60151
#

prod1 = <<-X12
LIN*000001*VN*1234321~
PID*F*08***LENS PAPER BOOK 12BK/PK~
PO4*12**EA~
CTP**CON*14.80*1*PK~
X12

prod2 = <<-X12
LIN*000002*VN*2345432~
PID*F*08***LENS PAPER BOOK 24BK/PK~
PO4*12**EA~
CTP**CON*20.80*1*PK~
X12

# LIN: 35006
# PID: 45005
#  08: 35031
#
# PO4: 35003
# CTP: 45005
#   1: 52929

footer = <<-X12
CTT*2~
SE*16*0001~
GE*1*409939~
IEA*1*000409939~
X12

buffer = StringIO.new

if ARGV.delete('--tiny')
  n = 1
  m = 1
elsif ARGV.delete('--small')
  n = 10
  m = 250
else
  n = 100
  m = 250
end

n.times do
  buffer.write(base)
  m.times { buffer.write(prod1) }
  m.times { buffer.write(prod2) }
  buffer.write(footer)
end

STDOUT.write(buffer.string)
