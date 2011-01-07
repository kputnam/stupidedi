= Embedding RSpec Specifications in YARD Documentation

This plugin demonstrates how RSpec tests can be embedded within standard documentation
using only a small amount of plugin code. The example generates documentation
for the following {String#pig_latin} method and RSpec tests:

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
  describe String, '#pig_latin' do
    it "should be a pig!" do
      "hello".pig_latin.should == "ellohay"
     end

    it "should fail to be a pig!" do
      "hello".pig_latin.should == "hello"
    end
  end

View the "Specifications" section within the {String#pig_latin} method to see
these tests.