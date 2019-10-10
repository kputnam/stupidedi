describe "Stupidedi::Either" do
  def mksuccess(value)
    Stupidedi::Either.success(value)
  end

  def mkfailure(value)
    Stupidedi::Either.failure(value)
  end

  describe "#reason" do
    context "on failure" do
      it "returns the value given to the constructor" do
        expect(mkfailure("a").reason).to be == "a"
      end
    end
  end

  describe "#pretty_print" do
    context "on success" do
      it "returns a String" do
        expect(mksuccess("xyz").pretty_inspect).to be_a(String)
        expect(mksuccess("xyz").pretty_inspect).to match(/xyz/)
      end
    end

    context "on failure" do
      it "returns a String" do
        expect(mkfailure("xyz").pretty_inspect).to  be_a(String)
        expect(mkfailure("xyz").pretty_inspect).to  match(/xyz/)
      end
    end
  end

  describe "#inspect" do
    context "on success" do
      it "returns a String" do
        expect(mksuccess("xyz").inspect).to be_a(String)
        expect(mksuccess("xyz").inspect).to match(/xyz/)
      end
    end

    context "on failure" do
      it "returns a String" do
        expect(mkfailure("xyz").inspect).to  be_a(String)
        expect(mkfailure("xyz").inspect).to  match(/xyz/)
      end
    end
  end

  describe "#fetch(default)" do
    context "on success" do
      it "returns a the value" do
        expect(mksuccess("xyz").fetch(:default)).to eq("xyz")
      end
    end

    context "on failure" do
      it "returns a default" do
        expect(mkfailure("xyz").fetch(:default)).to eq(:default)
      end
    end
  end

  describe "#==(failure)" do
    let(:failure) { mkfailure("a") }

    context "on success" do
      context "when reason == success.value" do
        it "is false" do
          expect(failure).not_to be == mksuccess("a")
        end
      end

      context "when reason != success.value" do
        it "is false" do
          expect(failure).not_to be == mksuccess("b")
        end
      end
    end

    context "on failure" do
      context "when reason == failure.reason" do
        it "is true" do
          expect(failure).to be == mkfailure("a")
        end
      end

      context "when reason != failure.reason" do
        it "is false" do
          expect(failure).not_to be == mkfailure("b")
        end
      end
    end
  end

  describe "#==(success)" do
    let(:success) { mksuccess("a") }

    context "on success" do
      context "when value == success.value" do
        it "is true" do
          expect(success).to be == mksuccess("a")
        end
      end

      context "when value != success.value" do
        it "is false" do
          expect(success).not_to be == mksuccess("b")
        end
      end
    end

    context "on failure" do
      context "when value == failure.reason" do
        it "is false" do
          expect(success).not_to be == mkfailure("a")
        end
      end

      context "when value != failure.reason" do
        it "is false" do
          expect(success).not_to be == mkfailure("b")
        end
      end
    end
  end

  describe "#==(other)" do
    context "on success" do
      context "when value == other" do
        it "is false" do
          expect(mksuccess("a")).not_to be == "a"
        end
      end

      context "when value != other" do
        it "is false" do
          expect(mksuccess("a")).not_to be == "b"
        end
      end
    end

    context "on failure" do
      context "when reason == other" do
        it "is false" do
          expect(mksuccess("a")).not_to be == "a"
        end
      end

      context "when reason != other" do
        it "is false" do
          expect(mksuccess("a")).not_to be == "b"
        end
      end
    end
  end

  describe "#select(reason, &predicate)" do
    context "on success" do
      it "yields the wrapped value" do
        expect(lambda { mksuccess("a").select{|*a| raise a.inspect }}).to raise_error('["a"]')
      end

      context "when predicate is satisfied" do
        it "returns itself" do
          either = mksuccess("a")
          expect(either.select { true }).to be == either
        end
      end

      context "when predicate is not satisfied" do
        it "returns a failure" do
          expect(mksuccess("a").select { false }).to be_failure("select")
        end

        context "when reason is given" do
          it "returns a failure with the given reason" do
            expect(mksuccess("a").select("criteria not met") { false }.reason).to be == "criteria not met"
          end
        end

        context "when reason is not given" do
          it "returns a failure with a default reason" do
            expect(mksuccess("a").select { false }.reason).to be == "select"
          end
        end
      end
    end

    context "on failure" do
      context "when reason is given" do
        it "returns itself" do
          either = mkfailure("a")
          expect(either.select("a") { false }).to be == either
        end
      end

      context "when reason is not given" do
        it "returns itself" do
          either = mkfailure("a")
          expect(either.select).to be == either
        end
      end

      it "does not call the block argument" do
        expect(lambda { mkfailure("a").select { raise }}).to_not raise_error
      end
    end
  end

  describe "#reject(reason, &predicate)" do
    context "on success" do
      it "yields the wrapped value" do
        expect(lambda { mksuccess("a").reject{|*a| raise a.inspect }}).to raise_error('["a"]')
      end

      context "when the predicate is satisfied" do
        it "returns a failure" do
          expect(mksuccess("a").reject { true }).to be_failure("reject")
        end

        context "when reason is given" do
          it "returns a failure with the given reason" do
            expect(mksuccess("a").reject("criteria not met") { true }.reason).to be == "criteria not met"
          end
        end

        context "when reason is not given" do
          it "returns a failure with a default reason" do
            expect(mksuccess("a").reject { true }.reason).to be == "reject"
          end
        end
      end

      context "when the predicate is not satisfied" do
        it "returns itself" do
          either = mksuccess("a")
          expect(either.reject { false }).to be == either
        end
      end
    end

    context "on failure" do
      context "when reason is given" do
        it "returns itself" do
          either = mkfailure("a")
          expect(either.reject("criteria not met")).to be == either
        end
      end

      context "when reason is not given" do
        it "returns itself" do
          either = mkfailure("a")
          expect(either.reject).to be == either
        end
      end

      it "does not call the block argument" do
        expect(lambda { mkfailure("a").reject { raise }}).not_to raise_error
      end
    end
  end

  describe "#defined?" do
    context "on success" do
      it "returns true" do
        expect(mksuccess("a")).to be_defined
      end
    end

    context "on failure" do
      it "returns false" do
        expect(mkfailure("a")).not_to be_defined
      end
    end
  end

  # Success's map method is analogous to Failure's explain method
  describe "#map(&block)" do
    context "on success" do
      it "returns a success" do
        expect(mksuccess("a").map { "b" }).to be_defined
      end

      it "yields the wrapped value" do
        expect(lambda { mksuccess("a").map {|*a| raise a.inspect }}).to raise_error('["a"]')
      end

      it "wraps the return value of the block argument" do
        expect(mksuccess("a").map{|a| a.length }).to be == mksuccess(1)
      end
    end

    context "on failure" do
      it "does not evaluate the block argument" do
        expect(lambda { mkfailure("a").map { raise }}).not_to raise_error
      end

      it "returns itself" do
        either = mkfailure("a")
        expect(either.map).to be == either
      end
    end
  end

  # Failure's explain method is analogous to Success's map method
  describe "#explain(&block)" do
    context "on success" do
      it "does not evaluate the block argument" do
        expect(lambda { mksuccess("a").explain { raise }}).to_not raise_error
      end

      it "returns itself" do
        either = mksuccess("a")
        expect(either.explain).to be == either
      end
    end

    context "on failure" do
      it "returns a failure" do
        expect(mkfailure("a").explain { "b" }).to be_failure("b")
      end

      it "yields the wrapped reason" do
        expect(lambda { mkfailure("a").explain{|*a| raise a.inspect }}).to raise_error('["a"]')
      end

      it "wraps the return value of the block argument" do
        expect(mkfailure("a").explain{|a| a.length }).to be == mkfailure(1)
      end
    end
  end

  # Failure's or method is analogous to Success's flatmap method
  describe "#or(&either)" do
    context "on success" do
      it "does not call the block argument" do
        expect(lambda { mksuccess("a").or { raise }}).not_to raise_error
      end

      it "returns itself" do
        either = mksuccess("a")
        expect(either.or).to be == either
      end
    end

    context "on failure" do
      it "yields the wrapped reason" do
        expect(lambda { mkfailure("a").or{|*a| raise a.inspect }}).to raise_error('["a"]')
      end

      it "returns the return value of the block" do
        expect(mkfailure("a").or{|a| mksuccess(a.succ) }).to be == mksuccess("b")
        expect(mkfailure("a").or{|a| mkfailure(a.succ) }).to be == mkfailure("b")
      end

      it "typechecks the return value of the block" do
        expect(lambda { mkfailure("a").or{|a| a }}).to raise_error(TypeError)
      end
    end
  end

  # Success's flatmap method is analogous to Failure's or method
  describe "#flatmap(&block)" do
    context "on success" do
      it "yields the wrapped value" do
        expect(lambda { mksuccess("a").flatmap{|*a| raise a.inspect }}).to raise_error('["a"]')
      end

      it "returns the return value of the block argument" do
        expect(mksuccess("a").flatmap{|a| mksuccess(a.succ) }).to be == mksuccess("b")
        expect(mksuccess("a").flatmap{|a| mkfailure(a.succ) }).to be == mkfailure("b")
      end

      it "typechecks the return value of the block argument" do
        expect(lambda { mksuccess("a").flatmap{|a| a }}).to raise_error(TypeError)
      end
    end

    context "on failure" do
      it "does not evaluate the block argument" do
        expect(lambda { mkfailure("a").flatmap { raise }}).to_not raise_error
      end

      it "returns itself" do
        either = mkfailure("a")
        expect(either.flatmap).to be == either
      end
    end
  end

  describe "#tap(&block)" do
    context "on success" do
      it "yields the wrapped value" do
        expect(lambda { mksuccess("a").tap{|*a| raise a.inspect }}).to raise_error('["a"]')
      end

      it "returns itself" do
        either = mksuccess("a")
        expect(either.tap{|a| a.length }).to be == either
      end
    end

    context "on failure" do
      it "does not evaluate the block argument" do
        expect(lambda { mkfailure("a").tap { raise }}).to_not raise_error
      end

      it "returns itself" do
        either = mkfailure("a")
        expect(either.tap).to be == either
      end
    end
  end
end
