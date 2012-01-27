require "stupidedi"

config = Stupidedi::Config.default
parser = Stupidedi::Builder::StateMachine.build(config)

input  = if RUBY_VERSION > "1.8"
           File.open("spec/fixtures/X221-HP835/1-good.txt", :encoding => "ISO-8859-1")
         else
           File.open("spec/fixtures/X221-HP835/1-good.txt")
         end

# Reader.build accepts IO (File), String, and DelegateInput
parser, result = parser.read(Stupidedi::Reader.build(input))

# Handle fatal tokenizer failures
if result.fatal?
  result.explain{|reason| raise reason + " at #{result.position.inspect}" }
end

def el(m, *ns, &block)
  if Stupidedi::Either === m
    m.tap{|m| el(m, *ns, &block) }
  else
    yield(*ns.map{|n| m.element(*n).map(&:node).map(&:value).fetch(nil) })
  end
end

# Print some information
parser.first
  .flatmap{|m| m.find(:GS) }
  .flatmap{|m| m.find(:ST) }
  .tap do |m|
    el(m.find(:N1, "PR"), 2){|e| puts "Payer: #{e}" }
    el(m.find(:N1, "PE"), 2){|e| puts "Payee: #{e}" }
  end
  .flatmap{|m| m.find(:LX) }
  .flatmap{|m| m.find(:CLP) }
  .flatmap{|m| m.find(:NM1, "QC") }
  .tap{|m| el(m, 3, 4){|l,f| puts "Patient: #{l}, #{f}" }}
