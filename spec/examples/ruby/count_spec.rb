require "spec_helper"
using Stupidedi::Refinements

describe "Enumerable#count" do
  include QuickCheck::Macro

  context "with no given arguments" do
    property("returns #length") do
      with(:size, between(0, 20)) { array { integer }}
    end.check do |enumerable|
      enumerable.count.should == enumerable.length
    end
  end

  context "with a given literal" do
    let(:enumerable) { %w(a b a b c d a) }

    it "returns the number of occurrences" do
      enumerable.count("g").should == 0
      enumerable.count("a").should == 3
      enumerable.count("b").should == 2
      enumerable.count("c").should == 1
      enumerable.count("d").should == 1
    end
  end

  context "with a given block argument" do
    context "that always evaluates false" do
      it "returns 0" do
        %w(a b c d e f).count { false }.should == 0
      end

      property("returns 0") do
        with(:size, between(0, 20)) { array { integer }}
      end.check do |enumerable|
        enumerable.count { false }.should == 0
      end
    end

    context "that always evaluates true" do
      it "returns #length" do
        %w(a b c d e f).count { true }.should == 6
      end

      property("returns #length") do
        with(:size, between(0, 20)) { array { integer }}
      end.check do |enumerable|
        enumerable.count { true }.should == enumerable.length
      end
    end

    context "that evaluates true or false" do
      it "returns the number of elements that satisfy the predicate" do
        %w(a bc d ef g hi).count{|s| s.length == 2 }.should == 3
      end

      property("returns the number of elements that satisfy the predicate") do
        divisor    = choose([1,2,3,4])
        enumerable = with(:size, between(0, 20)) { array { integer }}

        [enumerable, divisor]
      end.check do |enumerable, divisor|
        enumerable.count{|n| n.modulo(divisor).zero? }.should ==
          enumerable.inject(0){|sum,n| sum + ((n.modulo(divisor).zero?) ? 1 : 0) }
      end
    end

  end
end
