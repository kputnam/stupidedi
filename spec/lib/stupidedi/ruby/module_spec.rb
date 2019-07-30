using Stupidedi::Refinements

describe Module do
  describe ".abstract" do
    context "when args provided" do
      todo
    end

    context "when args not provided" do
      todo
    end
  end

  describe ".def_delegators" do
    receiver_class =
      Class.new do
        def required_argument(w, x)     x end
        def required_keyword(w, x:)     x end
        def splat_argument(w, *x)       x end
        def optional_argument(w, x=:x)  x end
        def optional_keyword(w, x: :x)  x end
        def block_argument(w, &block)   block end
      end

    shared_examples "def_delegators_behavior" do
      context "when method has a required argument" do
        specify { expect(delegator.required_argument(:w, :z)).to eq(:z) }
      end

      context "when method has a required keyword: argument" do
        specify { expect(delegator.required_keyword(:w, x: "z")).to eq("z") }
      end

      context "when method has a *splat argument" do
        specify { expect(delegator.splat_argument(:x, :y, :z)).to eq([:y, :z])  }
      end

      context "when method has an optional argument" do
        specify { expect(delegator.optional_argument(:w, :z)).to eq(:z) }
        specify { expect(delegator.optional_argument(:w)).to     eq(:x) }
      end

      context "when method has an optional keyword: argument" do
        specify { expect(delegator.optional_keyword(:w, x: "z")).to eq("z") }
        specify { expect(delegator.optional_keyword(:w)).to         eq(:x)  }
      end

      context "when method has a &block argument" do
        let(:block) { :to_s.to_proc }
        specify { expect(delegator.block_argument(:w, &block)).to eql(block) }
      end
    end

    shared_examples "def_delegators_arity" do
      context "when method has a required argument" do
        specify { expect(delegator.method(:required_argument).arity).to eq(2) }
      end

      context "when method has a required keyword: argument" do
        specify { expect(delegator.method(:required_keyword).arity).to eq(2) }
      end

      context "when method has a *splat argument" do
        specify { expect(delegator.method(:splat_argument).arity).to  eq(-2) }
      end

      context "when method has an optional argument" do
        specify { expect(delegator.method(:optional_argument).arity).to eq(-2) }
      end

      context "when method has an optional keyword: argument" do
        specify { expect(delegator.method(:optional_keyword).arity).to eq(-2) }
      end

      context "when method has a &block argument" do
        let(:block) { :to_s.to_proc }
        specify { expect(delegator.method(:block_argument).arity).to eq(1) }
      end
    end

    context "when instance is provided" do
      let(:delegator) do
        Class.new do |klass|
          klass.class_variable_set(:@@receiver, receiver_class.new)
          def_delegators :@@receiver, :required_argument, :required_keyword,
            :splat_argument, :optional_argument, :optional_keyword,
            :block_argument, instance: receiver_class.new, debug: false
        end.new
      end

      include_examples "def_delegators_arity"
      include_examples "def_delegators_behavior"
    end

    context "when type is provided" do
      let(:delegator) do
        Class.new do |klass|
          klass.class_variable_set(:@@receiver, receiver_class.new)
          def_delegators :@@receiver, :required_argument, :required_keyword,
            :splat_argument, :optional_argument, :optional_keyword,
            :block_argument, type: receiver_class, debug: false
        end.new
      end

      include_examples "def_delegators_arity"
      include_examples "def_delegators_behavior"
    end

    context "when no type or instance is provided" do
      let(:delegator) do
        Class.new do |klass|
          klass.class_variable_set(:@@receiver, receiver_class.new)
          def_delegators :@@receiver, :required_argument, :required_keyword,
            :splat_argument, :optional_argument, :optional_keyword,
            :block_argument, debug: false
        end.new
      end

      include_examples "def_delegators_behavior"
    end
  end
end
