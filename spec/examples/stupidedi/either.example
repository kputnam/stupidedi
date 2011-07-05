require "spec_helper"

describe Stupidedi::Either do

  def mksuccess(value)
    Stupidedi::Either.success(value)
  end

  def mkfailure(value)
    Stupidedi::Either.failure(value)
  end

  describe "#reason" do
    context "on failure" do
      it "returns the value given to the constructor" do
        mkfailure("a").reason.should == "a"
      end
    end
  end

  describe "#==(failure)" do
    let(:failure) { mkfailure("a") }

    context "on success" do
      context "when reason == success.value" do
        it "is false" do
          failure.should_not == mksuccess("a")
        end
      end

      context "when reason != success.value" do
        it "is false" do
          failure.should_not == mksuccess("b")
        end
      end
    end

    context "on failure" do
      context "when reason == failure.reason" do
        it "is true" do
          failure.should == mkfailure("a")
        end
      end

      context "when reason != failure.reason" do
        it "is false" do
          failure.should_not == mkfailure("b")
        end
      end
    end
  end

  describe "#==(success)" do
    let(:success) { mksuccess("a") }

    context "on success" do
      context "when value == success.value" do
        it "is true" do
          success.should == mksuccess("a")
        end
      end

      context "when value != success.value" do
        it "is false" do
          success.should_not == mksuccess("b")
        end
      end
    end

    context "on failure" do
      context "when value == failure.reason" do
        it "is false" do
          success.should_not == mkfailure("a")
        end
      end

      context "when value != failure.reason" do
        it "is false" do
          success.should_not == mkfailure("b")
        end
      end
    end
  end

  describe "#==(other)" do
    context "on success" do
      context "when value == other" do
        it "is false" do
          mksuccess("a").should_not == "a"
        end
      end

      context "when value != other" do
        it "is false" do
          mksuccess("a").should_not == "b"
        end
      end
    end

    context "on failure" do
      context "when reason == other" do
        it "is false" do
          mksuccess("a").should_not == "a"
        end
      end

      context "when reason != other" do
        it "is false" do
          mksuccess("a").should_not == "b"
        end
      end
    end
  end

  describe "#select(reason, &predicate)" do
    context "on success" do
      it "yields the wrapped value" do
        lambda { mksuccess("a").select{|*a| raise a.inspect }}.should raise_error('["a"]')
      end

      context "when predicate is satisfied" do
        it "returns itself" do
          either = mksuccess("a")
          either.select { true }.should eq(either)
        end
      end

      context "when predicate is not satisfied" do
        it "returns a failure" do
          mksuccess("a").select { false }.should_not be_defined
        end

        context "when reason is given" do
          it "returns a failure with the given reason" do
            mksuccess("a").select("criteria not met") { false }.reason.
              should == "criteria not met"
          end
        end

        context "when reason is not given" do
          it "returns a failure with a default reason" do
            mksuccess("a").select { false }.reason.should == "select"
          end
        end
      end
    end

    context "on failure" do
      context "when reason is given" do
        it "returns itself" do
          either = mkfailure("a")
          either.select("a") { false }.should eq(either)
        end
      end

      context "when reason is not given" do
        it "returns itself" do
          either = mkfailure("a")
          either.select.should eq(either)
        end
      end

      it "does not call the block argument" do
        lambda { mkfailure("a").select { raise }}.should_not raise_error
      end
    end
  end

  describe "#reject(reason, &predicate)" do
    context "on success" do
      it "yields the wrapped value" do
        lambda { mksuccess("a").reject{|*a| raise a.inspect }}.should raise_error('["a"]')
      end

      context "when the predicate is satisfied" do
        it "returns a failure" do
          mksuccess("a").reject { true }.should_not be_defined
        end

        context "when reason is given" do
          it "returns a failure with the given reason" do
            mksuccess("a").reject("criteria not met") { true }.reason.
              should == "criteria not met"
          end
        end

        context "when reason is not given" do
          it "returns a failure with a default reason" do
            mksuccess("a").reject { true }.reason.should == "reject"
          end
        end
      end

      context "when the predicate is not satisfied" do
        it "returns itself" do
          either = mksuccess("a")
          either.reject { false }.should eq(either)
        end
      end
    end

    context "on failure" do
      context "when reason is given" do
        it "returns itself" do
          either = mkfailure("a")
          either.reject("criteria not met").should eq(either)
        end
      end

      context "when reason is not given" do
        it "returns itself" do
          either = mkfailure("a")
          either.reject.should eq(either)
        end
      end

      it "does not call the block argument" do
        lambda { mkfailure("a").reject { raise }}.should_not raise_error
      end
    end
  end

  describe "#defined?" do
    context "on success" do
      it "returns true" do
        mksuccess("a").should be_defined
      end
    end

    context "on failure" do
      it "returns false" do
        mkfailure("a").should_not be_defined
      end
    end
  end

  # Success's map method is analogous to Failure's explain method
  describe "#map(&block)" do
    context "on success" do
      it "returns a success" do
        mksuccess("a").map { "b" }.should be_defined
      end

      it "yields the wrapped value" do
        lambda { mksuccess("a").map {|*a| raise a.inspect }}.should raise_error('["a"]')
      end

      it "wraps the return value of the block argument" do
        mksuccess("a").map{|a| a.length }.should == mksuccess(1)
      end
    end

    context "on failure" do
      it "does not evaluate the block argument" do
        lambda { mkfailure("a").map { raise }}.should_not raise_error
      end

      it "returns itself" do
        either = mkfailure("a")
        either.map.should eq(either)
      end
    end
  end

  # Failure's explain method is analogous to Success's map method
  describe "#explain(&block)" do
    context "on success" do
      it "does not evaluate the block argument" do
        lambda { mksuccess("a").explain { raise }}.should_not raise_error
      end

      it "returns itself" do
        either = mksuccess("a")
        either.explain.should eq(either)
      end
    end

    context "on failure" do
      it "returns a failure" do
        mkfailure("a").explain { "b" }.should_not be_defined
      end

      it "yields the wrapped reason" do
        lambda { mkfailure("a").explain{|*a| raise a.inspect }}.should raise_error('["a"]')
      end

      it "wraps the return value of the block argument" do
        mkfailure("a").explain{|a| a.length }.should == mkfailure(1)
      end
    end
  end

  # Failure's or method is analogous to Success's flatmap method
  describe "#or(&either)" do
    context "on success" do
      it "does not call the block argument" do
        lambda { mksuccess("a").or { raise }}.should_not raise_error
      end

      it "returns itself" do
        either = mksuccess("a")
        either.or.should eq(either)
      end
    end

    context "on failure" do
      it "yields the wrapped reason" do
        lambda { mkfailure("a").or{|*a| raise a.inspect }}.should raise_error('["a"]')
      end

      it "returns the return value of the block" do
        mkfailure("a").or{|a| mksuccess(a.succ) }.should == mksuccess("b")
        mkfailure("a").or{|a| mkfailure(a.succ) }.should == mkfailure("b")
      end

      it "typechecks the return value of the block" do
        lambda { mkfailure("a").or{|a| a }}.should raise_error(TypeError)
      end
    end
  end

  # Success's flatmap method is analogous to Failure's or method
  describe "#flatmap(&block)" do
    context "on success" do
      it "yields the wrapped value" do
        lambda { mksuccess("a").flatmap{|*a| raise a.inspect }}.should raise_error('["a"]')
      end

      it "returns the return value of the block argument" do
        mksuccess("a").flatmap{|a| mksuccess(a.succ) }.should == mksuccess("b")
        mksuccess("a").flatmap{|a| mkfailure(a.succ) }.should == mkfailure("b")
      end

      it "typechecks the return value of the block argument" do
        lambda { mksuccess("a").flatmap{|a| a }}.should raise_error(TypeError)
      end
    end

    context "on failure" do
      it "does not evaluate the block argument" do
        lambda { mkfailure("a").flatmap { raise }}.should_not raise_error
      end

      it "returns itself" do
        either = mkfailure("a")
        either.flatmap.should eq(either)
      end
    end
  end

  describe "#each(&block)" do
    context "on success" do
      it "yields the wrapped value" do
        lambda { mksuccess("a").tap{|*a| raise a.inspect }}.should raise_error('["a"]')
      end

      it "returns itself" do
        either = mksuccess("a")
        either.tap{|a| a.length }.should eq(either)
      end
    end

    context "on failure" do
      it "does not evaluate the block argument" do
        lambda { mkfailure("a").tap { raise }}.should_not raise_error
      end

      it "returns itself" do
        either = mkfailure("a")
        either.tap.should eq(either)
      end
    end
  end

end
