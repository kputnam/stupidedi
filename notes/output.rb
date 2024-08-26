#!/usr/bin/env ruby
require "pathname"
$:.unshift(File.expand_path("../../lib", Pathname.new(__FILE__).realpath))

require "stupidedi"
require "pp"

# This will be auto-enabled when $stdout.tty?, but -C forces color output
require "term/ansicolor" if ARGV.delete("-C")

config = Stupidedi::Config.new
config.interchange.tap do |c|
  c.register("00401") { Stupidedi::Interchanges::FourOhOne::InterchangeDef }
  c.register("00501") { Stupidedi::Interchanges::FiveOhOne::InterchangeDef }
end

config.functional_group.tap do |c|
  # The 4010 functional group definition doesn't actually have any segment defs,
  # so the tokenizer makes assumptions (eg, that every element is simple), which
  # results in tokens that don't match the transaction set definition. This is
  # only because we linked some 4010 transaction sets to the 5010 definitions.
  # It would never happen when the transaction set definition is built from the
  # same set of segment definitions. There might be a good place to detect this
  # mismatch, but it's not yet implemented.
  #
  # c.register("004010") { Stupidedi::Versions::FortyTen::FunctionalGroupDef }

  c.register("004010") { Stupidedi::Versions::FiftyTen::FunctionalGroupDef }
  c.register("005010") { Stupidedi::Versions::FiftyTen::FunctionalGroupDef }
end

config.transaction_set.tap do |c|
  c.register("005010", "HN", "277") { Stupidedi::TransactionSets::FiftyTen::Standards::HN277 }
  c.register("005010", "BE", "834") { Stupidedi::TransactionSets::FiftyTen::Standards::BE834 }
  c.register("005010", "HP", "835") { Stupidedi::TransactionSets::FiftyTen::Standards::HP835 }
  c.register("005010", "HC", "837") { Stupidedi::TransactionSets::FiftyTen::Standards::HC837 }
  c.register("005010", "FA", "999") { Stupidedi::TransactionSets::FiftyTen::Standards::FA999 }

  c.register("005010X214",   "HN", "277") { Stupidedi::TransactionSets::FiftyTen::Implementations::X214::HN277 }
  c.register("005010X220",   "BE", "834") { Stupidedi::TransactionSets::FiftyTen::Implementations::X220::BE834 }
  c.register("005010X221",   "HP", "835") { Stupidedi::TransactionSets::FiftyTen::Implementations::X221::HP835 }
  c.register("005010X222",   "HC", "837") { Stupidedi::TransactionSets::FiftyTen::Implementations::X222::HC837 }
  c.register("005010X231",   "FA", "999") { Stupidedi::TransactionSets::FiftyTen::Implementations::X231::FA999 }
  c.register("005010X220A1", "BE", "834") { Stupidedi::TransactionSets::FiftyTen::Implementations::X220A1::BE834 }
  c.register("005010X221A1", "HP", "835") { Stupidedi::TransactionSets::FiftyTen::Implementations::X221A1::HP835 }
  c.register("004010X098A1", "HC", "837") { Stupidedi::TransactionSets::FiftyTen::Implementations::X222A1::HC837 }
  c.register("005010X222A1", "HC", "837") { Stupidedi::TransactionSets::FiftyTen::Implementations::X222A1::HC837 }
  c.register("005010X231A1", "FA", "999") { Stupidedi::TransactionSets::FiftyTen::Implementations::X231A1::FA999 }
end

parser = Stupidedi::Parser.build(config)
start  = Time.now

ARGV.each do |path|
  File.open(path) do |io|
    parser, result = parser.read(Stupidedi::Reader.build(io))
    pp result
  end
end

stop = Time.now

parser.zipper.map{|z| pp z.root.node }.
  explain { puts "Non-deterministic state" }

#begin
#  count  = 0
#  cursor = parser.first
#
#  while cursor.defined?
#    count += 1
#    cursor = cursor.flatmap{|c| c.next }
#  end
#
#  puts "#{count} segments"
#end
#
#begin
#  a = parser.first
#  b = parser.last
#
#  a.flatmap{|a| b.flatmap{|b| a.distance(b) }}.
#    tap{|d| puts "#{d + 1} segments" }
#end

separators = Stupidedi::Reader::Separators.build \
  :element => "*",
  :segment => "~\n"

cursor = parser.first
while cursor.defined?
  cursor = cursor.flatmap do |isa|
    either =
      if isa.deterministic?
        isa.zipper
      else
        Stupidedi::Either.success(isa.active.head.node.zipper)
      end.map(&:up)

    either.tap do |z|
      $stdout.puts("*" * 80)
      writer = Stupidedi::Writer::Default.new(z, separators)
      writer.write($stdout)
      $stdout.puts
    end

    isa.find(:ISA)
  end
end

puts "%0.3f seconds" % (stop - start)
