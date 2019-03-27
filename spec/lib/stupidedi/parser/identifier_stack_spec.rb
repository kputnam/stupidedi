describe Stupidedi::Parser::IdentifierStack do
  using Stupidedi::Refinements

  let(:stack) { Stupidedi::Parser::IdentifierStack.new(10) }

  describe "#count" do
    it "returns number of interchanges" do
                                expect(stack.count).to eq(0)
      stack.isa; stack.pop_isa; expect(stack.count).to eq(1)
      stack.isa; stack.pop_isa; expect(stack.count).to eq(2)
      stack.isa; stack.pop_isa; expect(stack.count).to eq(3)
    end
  end

  describe "#isa" do
    it "cannot be called consecutively (without #pop_isa)" do
      stack.isa
      expect(stack).to_not respond_to(:isa)
      expect { stack.isa }.to raise_error(NoMethodError)
    end

    it "returns a new interchange control number" do
      expect(stack.isa).to                eq(10)
      stack.pop_isa; expect(stack.isa).to eq(11)
      stack.pop_isa; expect(stack.isa).to eq(12)
    end

    describe "#id" do
      it "returns the current interchange control number" do
        expect(stack.isa).to                eq(stack.id)
        stack.pop_isa; expect(stack.isa).to eq(stack.id)
        stack.pop_isa; expect(stack.isa).to eq(stack.id)
      end
    end

    describe "#pop_isa" do
      it "cannot be called before #isa" do
        expect(stack).to_not respond_to(:pop_isa)
        expect { stack.pop_isa }.to raise_error(NoMethodError)
      end

      it "returns previous isa control number" do
        expect(stack.isa).to eq(stack.pop_isa)
        expect(stack.isa).to eq(stack.pop_isa)
        expect(stack.isa).to eq(stack.pop_isa)
      end
    end

    describe "#count" do
      it "returns number of functional groups" do
        stack.isa;              expect(stack.count).to eq(0)
        stack.gs; stack.pop_gs; expect(stack.count).to eq(1)
        stack.gs; stack.pop_gs; expect(stack.count).to eq(2)
        stack.gs; stack.pop_gs; expect(stack.count).to eq(3)
      end
    end
  end

  describe "#gs" do
    let(:stack) { Stupidedi::Parser::IdentifierStack.new(10) }

    it "cannot be called before #isa" do
      expect(stack).to_not respond_to(:gs)
      expect { stack.gs }.to raise_error(NoMethodError)
    end

    it "cannot be called consecutively (without #pop_gs)" do
      stack.isa
      stack.gs
      expect(stack).to_not respond_to(:gs)
      expect { stack.gs }.to raise_error(NoMethodError)
    end

    it "returns a new functional group control number" do
      stack.isa
      expect(stack.gs).to               eq(11)
      stack.pop_gs; expect(stack.gs).to eq(12)
      stack.pop_gs; expect(stack.gs).to eq(13)
    end

    describe "#id" do
      it "returns the current functional group control number" do
        stack.isa
        expect(stack.gs).to               eq(stack.id)
        stack.pop_gs; expect(stack.gs).to eq(stack.id)
        stack.pop_gs; expect(stack.gs).to eq(stack.id)
      end
    end

    describe "#pop_gs" do
      it "cannot be called before #gs" do
        stack.isa
        expect(stack).to_not respond_to(:pop_gs)
        expect { stack.pop_gs }.to raise_error(NoMethodError)
      end

      it "returns previous functional group control number" do
        stack.isa
        expect(stack.gs).to eq(stack.pop_gs)
        expect(stack.gs).to eq(stack.pop_gs)
        expect(stack.gs).to eq(stack.pop_gs)
      end
    end

    describe "#count" do
      it "returns number of transaction sets" do
        stack.isa
        stack.gs
                                expect(stack.count).to eq(0)
        stack.st; stack.pop_st; expect(stack.count).to eq(1)
        stack.st; stack.pop_st; expect(stack.count).to eq(2)
        stack.st; stack.pop_st; expect(stack.count).to eq(3)
      end
    end
  end

  describe "#st" do
    it "cannot be called before #gs" do
      expect(stack).to_not respond_to(:st)
      expect { stack.st }.to raise_error(NoMethodError)
    end

    it "cannot be called consecutively (without #pop_st)" do
      stack.isa
      stack.gs
      stack.st
      expect(stack).to_not respond_to(:st)
      expect { stack.st }.to raise_error(NoMethodError)
    end

    it "returns a new transaction set control number" do
      stack.isa
      stack.gs
      expect(stack.st).to               eq("0012")
      stack.pop_st; expect(stack.st).to eq("0013")
      stack.pop_st; expect(stack.st).to eq("0014")
    end

    describe "#id" do
      it "returns the current transaction set control number" do
        stack.isa
        stack.gs
        expect(stack.st).to               eq(stack.id)
        stack.pop_st; expect(stack.st).to eq(stack.id)
        stack.pop_st; expect(stack.st).to eq(stack.id)
      end
    end

    describe "#pop_st" do
      it "cannot be called before #st" do
        stack.isa
        stack.gs
        expect(stack).to_not respond_to(:pop_st)
        expect { stack.pop_st }.to raise_error(NoMethodError)
      end

      it "returns previous transaction set control number" do
        stack.isa
        stack.gs
        stack.st; expect(stack.id).to eq(stack.pop_st)
        stack.st; expect(stack.id).to eq(stack.pop_st)
        stack.st; expect(stack.id).to eq(stack.pop_st)
      end
    end
  end

  describe "#hl" do
    it "cannot be called before #st" do
      stack.isa
      expect(stack).to_not respond_to(:hl)
      expect { stack.hl }.to raise_error(NoMethodError);

      stack.gs
      expect(stack).to_not respond_to(:hl)
      expect { stack.hl }.to raise_error(NoMethodError);
    end

    it "can be called consecutively (nesting)" do
      stack.isa
      stack.gs
      stack.st
      stack.hl
      expect(stack).to respond_to(:hl)
    end

    it "returns a new HL identifier" do
      stack.isa
      stack.gs
      stack.st
      expect(stack.hl).to               eq(1)
      stack.pop_hl; expect(stack.hl).to eq(2)
      stack.pop_hl; expect(stack.hl).to eq(3)

                                # 3
      expect(stack.hl).to eq(4) # +- 4
      expect(stack.hl).to eq(5) #    +- 5
      expect(stack.hl).to eq(6) #       +- 6
    end

    describe "#id" do
      it "returns the current HL identifier" do
        stack.isa
        stack.gs
        stack.st
        expect(stack.hl).to               eq(stack.id)
        stack.pop_hl; expect(stack.hl).to eq(stack.id)
        stack.pop_hl; expect(stack.hl).to eq(stack.id)

        expect(stack.hl).to eq(stack.id)
        expect(stack.hl).to eq(stack.id)
        expect(stack.hl).to eq(stack.id)
      end
    end

    describe "#pop_hl" do
      it "returns the parent HL identifier" do
        stack.isa
        stack.gs
        stack.st
        expect(stack.hl).to eq(stack.pop_hl)
        expect(stack.hl).to eq(stack.pop_hl)
        expect(stack.hl).to eq(stack.pop_hl)

        a = stack.hl
        b = stack.hl
        c = stack.hl
        expect(stack.pop_hl).to eq(c)
        expect(stack.pop_hl).to eq(b)
        expect(stack.pop_hl).to eq(a)
      end
    end

    describe "#parent_hl" do
      it "returns the parent identifier" do
        stack.isa
        stack.gs
        stack.st

        a = stack.hl
        b = stack.hl
        c = stack.hl
        stack.hl

        expect(stack.parent_hl).to               eq(c)
        stack.pop_hl; expect(stack.parent_hl).to eq(b)
        stack.pop_hl; expect(stack.parent_hl).to eq(a)
      end

      it "without a parent, it raises and exception" do
        stack.isa
        stack.gs
        stack.st
        stack.hl
        expect { stack.parent_hl }.to raise_error(/does not have a parent/)
      end
    end
  end

  describe "#lx" do
    it "cannot be called before #st" do
      stack.isa
      stack.gs
      expect(stack).to_not respond_to(:lx)
      expect { stack.lx }.to raise_error(NoMethodError)
    end

    it "can be called consecutively" do
      stack.isa
      stack.gs
      stack.st
      stack.lx
      stack.lx
      stack.lx
    end

    it "returns a new loop identifier" do
      stack.isa
      stack.gs
      stack.st
      expect(stack.lx).to eq(1)
      expect(stack.lx).to eq(2)
      expect(stack.lx).to eq(3)
    end
  end
end
