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

def el(m, n, &block)
  m.tap{|m| m.element(n).tap{|e| yield(e.node.value) }}
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
  .tap do |m|
    m.element(3).tap do |l|
    m.element(4).tap do |f|
      puts "Patient: #{l.node.value}, #{f.node.value}"
    end
    end
  end
