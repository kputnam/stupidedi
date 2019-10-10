# Run `yardoc -e ../lib/yard-spec example_code.rb`


class String
  # Pig latin of a String
  def pig_latin
    self[1..-1] + self[0] + "ay"
  end
end

# 
# Specs
# 
describe String do
  describe '#pig_latin' do
    it "should be a pig!" do
      "hello".pig_latin.should == "ellohay"
     end

    it "should fail to be a pig!" do
      "hello".pig_latin.should == "hello"
    end
  end
end