require "stupidedi"
require "pp"

config = Stupidedi::Config.default
reader = Stupidedi::Reader.build(File.open("notes/recover.txt"))
parser = Stupidedi::Builder::StateMachine.build(config)

# This should fail because of an invalid token
parser, result = parser.read(reader)
pp result # LXXX is not a valid segment identifier
pp result.fatal?

result.explain do |reason|
  raise reason + " at #{result.position.inspect}"
end

# Start where we left off, looking for the next ISA
reader = Stupidedi::Reader.build(result.remainder)
parser, result = parser.read(reader)
pp result # Didn't find an ISA segment
