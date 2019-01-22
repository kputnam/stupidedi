describe "Enumerable#count" do
  using Stupidedi::Refinements

  context "with no given arguments" do
    property "returns #length" do
      with(:size, between(0, 20)) { array { integer }}
    end.check do |enumerable|
      expect(enumerable.count).to be == enumerable.length
    end
  end

  context "with a given literal" do
    let(:enumerable) { %w(a b a b c d a) }

    it "returns the number of occurrences" do
      expect(enumerable.count("g")).to be == 0
      expect(enumerable.count("a")).to be == 3
      expect(enumerable.count("b")).to be == 2
      expect(enumerable.count("c")).to be == 1
      expect(enumerable.count("d")).to be == 1
    end
  end

  context "with a given block argument" do
    context "that always evaluates false" do
      it "returns 0" do
        expect(%w(a b c d e f).count { false }).to be == 0
      end

      property "returns 0" do
        with(:size, between(0, 20)) { array { integer }}
      end.check do |enumerable|
        expect(enumerable.count { false }).to be == 0
      end
    end

    context "that always evaluates true" do
      it "returns #length" do
        expect(%w(a b c d e f).count { true }).to be == 6
      end

      property "returns #length" do
        with(:size, between(0, 20)) { array { integer }}
      end.check do |enumerable|
        expect(enumerable.count { true }).to be == enumerable.length
      end
    end

    context "that evaluates true or false" do
      it "returns the number of elements that satisfy the predicate" do
        expect(%w(a bc d ef g hi).count{|s| s.length == 2 }).to be == 3
      end

      property "returns the number of elements that satisfy the predicate" do
        divisor    = choose([1,2,3,4])
        enumerable = with(:size, between(0, 20)) { array { integer }}

        [enumerable, divisor]
      end.check do |enumerable, divisor|
        a = enumerable.count{|n| n.modulo(divisor).zero? }
        b = enumerable.inject(0){|sum,n| sum + ((n.modulo(divisor).zero?) ? 1 : 0) }
        expect(a).to be == b
      end
    end
  end
end
