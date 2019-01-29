describe Stupidedi::Versions::Common::ElementTypes::TM do
  using Stupidedi::Refinements
  include Definitions

  let(:element_use_4) do
    t = Stupidedi::Versions::Common::ElementTypes
    r = Stupidedi::Versions::Common::ElementReqs
    d = Stupidedi::Schema::RepeatCount
    t::TM.new(:DE1, "Time Element", 4, 4).simple_use(r::Mandatory, d.bounded(1))
  end

  let(:element_use_6) do
    t = Stupidedi::Versions::Common::ElementTypes
    r = Stupidedi::Versions::Common::ElementReqs
    d = Stupidedi::Schema::RepeatCount
    t::TM.new(:DE1, "Time Element", 6, 6).simple_use(r::Mandatory, d.bounded(1))
  end

  let(:element_use_8) do
    t = Stupidedi::Versions::Common::ElementTypes
    r = Stupidedi::Versions::Common::ElementReqs
    d = Stupidedi::Schema::RepeatCount
    t::TM.new(:DE1, "Time Element", 8, 8).simple_use(r::Mandatory, d.bounded(1))
  end

  let(:position) { Stupidedi::Reader::Position.new(100, 4, 19, "test.x12") }

  def value_4(x)
    element_use_4.value(x, position)
  end

  def value_6(x)
    element_use_6.value(x, position)
  end

  def value_8(x)
    element_use_8.value(x, position)
  end

  context "when min_length is invalid" do
    specify do
      expect(lambda do
        Stupidedi::Versions::Common::ElementTypes::TM.new(:DE1, "Time Element", 3, 6)
      end).to raise_error(/min_length/)
    end
  end

  context "when max_length is invalid" do
    specify do
      expect(lambda do
        Stupidedi::Versions::Common::ElementTypes::TM.new(:DE1, "Time Element", 4, 5)
      end).to raise_error(/max_length/)
    end
  end

  describe ".value" do
    context "when given a blank String" do
      specify { expect(value_4("")).to be_blank }
    end

    context "when given an invalid String" do
      specify { expect(value_4("99")).to be_invalid }
    end

    context "when given a wrong type of value" do
      specify { expect(value_4(115959)).to be_invalid }
    end

    context "when given an object with #hour, #min, #sec" do
      specify { expect(value_4(OpenStruct.new(:hour => 12, :min => 30, :sec => 15))).to be_valid }
    end

    context "when given an object with #hour, #min, #sec, #usec" do
      specify { expect(value_4(Time.now)).to be_valid }
    end

    context "when given an object with #hour, #min, #sec, #sec_fraction" do
      specify { expect(value_4(DateTime.now)).to be_valid }
    end

    context "when given an object with valid #hour, #minute, #second" do
      specify { expect(value_4(OpenStruct.new(:hour => 12, :minute => 30, :second => 15))).to be_valid }
    end

    context "when given an object with invalid #hour" do
      specify { expect(value_4(OpenStruct.new(:hour => 29, :minute => 30, :second => 15))).to be_invalid }
    end

    context "when given an object with invalid #minute" do
      specify { expect(value_4(OpenStruct.new(:hour => 29, :minute => -30, :second => 15))).to be_invalid }
    end

    context "when given an object with invalid #second" do
      specify { expect(value_4(OpenStruct.new(:hour => 29, :minute => 30, :second => 65))).to be_invalid }
    end
  end

  context "::Invalid" do
    let(:invalid_val) { value_4("99") }

    describe "#time?" do
      specify { expect(invalid_val).to be_time }
    end

    describe "#too_short?" do
      specify { expect(invalid_val).to_not be_too_short }
    end

    describe "#too_long?" do
      specify { expect(invalid_val).to_not be_too_long }
    end

    describe "#empty?" do
      specify { expect(invalid_val).to_not be_empty }
    end

    describe "#valid?" do
      specify { expect(invalid_val).to_not be_valid }
    end

    describe "#invalid?" do
      specify { expect(invalid_val).to be_invalid }
    end

    describe "#inspect" do
      shared_examples "inspect" do
        it "returns a String" do
          expect(invalid_val.inspect).to be_a(String)
        end

        it "indicates invalid " do
          expect(invalid_val.inspect).to match(/invalid/)
        end
      end

      context "when forbidden" do
        let(:invalid_val) do
          element_use_6.copy(:requirement => e_not_used).value("99", position)
        end

        include_examples "inspect"
      end

      context "when required" do
        let(:invalid_val) do
          element_use_6.copy(:requirement => e_mandatory).value("99", position)
        end

        include_examples "inspect"
      end

      context "when optional" do
        let(:invalid_val) do
          element_use_6.copy(:requirement => e_optional).value("99", position)
        end

        include_examples "inspect"
      end
    end

    describe "#to_s" do
      specify { expect(invalid_val.to_s).to eq("") }
    end

    describe "#to_x12" do
      context "with truncation" do
        specify { expect(invalid_val.to_x12(true)).to eq("") }
      end

      context "without truncation" do
        specify { expect(invalid_val.to_x12(false)).to eq("") }
      end
    end

    todo "#==(other)"

    todo "#copy(changes)"
  end

  context "::Empty" do
    let(:empty_val) { value_6("") }

    describe "#time?" do
      specify { expect(empty_val).to be_time }
    end

    describe "#too_short?" do
      specify { expect(empty_val).to_not be_too_short }
    end

    describe "#too_long?" do
      specify { expect(empty_val).to_not be_too_long }
    end

    describe "#empty?" do
      specify { expect(empty_val).to be_empty }
    end

    describe "#valid?" do
      specify { expect(empty_val).to be_valid }
    end

    describe "#invalid?" do
      specify { expect(empty_val).to_not be_invalid }
    end

    describe "#inspect" do
      shared_examples "inspect" do
        it "returns a String" do
          expect(empty_val.inspect).to be_a(String)
        end

        it "indicates empty " do
          expect(empty_val.inspect).to match(/empty/)
        end
      end

      context "when forbidden" do
        let(:empty_val) do
          element_use_6.copy(:requirement => e_not_used).empty(position)
        end

        include_examples "inspect"
      end

      context "when required" do
        let(:empty_val) do
          element_use_6.copy(:requirement => e_mandatory).empty(position)
        end

        include_examples "inspect"
      end

      context "when optional" do
        let(:empty_val) do
          element_use_6.copy(:requirement => e_optional).empty(position)
        end

        include_examples "inspect"
      end
    end

    describe "#to_s" do
      specify { expect(empty_val.to_s).to eq("") }
    end

    describe "#to_x12" do
      context "with truncation" do
        specify { expect(empty_val.to_x12(true)).to eq("") }
      end

      context "without truncation" do
        specify { expect(empty_val.to_x12(false)).to eq("") }
      end
    end

    describe "#==(other)" do
      todo    { expect(empty_val).to eq("")  }
      specify { expect(empty_val).to eq(nil) }
    end

    todo "#map(&block)"

    todo "#copy(changes)"
  end

  context "::NonEmpty" do
    describe "#time?" do
      specify { expect(value_4("1230")).to     be_time }
      specify { expect(value_6("123000")).to   be_time }
      specify { expect(value_8("12305900")).to be_time }
    end

    describe "#too_short?" do
      context "when value is not shorter than min_length" do
        specify { expect(value_4("1230")).to_not     be_too_short }
        specify { expect(value_4("123059")).to_not   be_too_short }
        specify { expect(value_4("12305900")).to_not be_too_short }
      end

      context "when value is shorter than min_length" do
        specify { expect(value_6("1230")).to   be_too_short }
        specify { expect(value_8("1230")).to   be_too_short }
        specify { expect(value_8("123059")).to be_too_short }
      end
    end

    describe "#too_long?" do
      context "when value is not longer than max_length" do
        specify { expect(value_4("1230")).to_not be_too_long }
        specify { expect(value_6("1230")).to_not be_too_long }
        specify { expect(value_8("1230")).to_not be_too_long }
      end

      context "when value is longer than max_length" do
        specify { expect(value_4("123059")).to_not     be_too_long }
        specify { expect(value_4("12305900")).to_not   be_too_long }
        specify { expect(value_6("12305900")).to_not   be_too_long }
        specify { expect(value_6("1230591111")).to_not be_too_long }
      end
    end

    describe "#empty?" do
      specify { expect(value_6("115959")).to_not be_empty }
    end

    describe "#valid?" do
      specify { expect(value_6("115959")).to be_valid }
    end

    describe "#invalid?" do
      specify { expect(value_6("115959")).to_not be_invalid }
    end

    describe "#inspect" do
      shared_examples "inspect" do
        it "returns a String" do
          expect(element_val.inspect).to be_a(String)
        end

        it "indicates valid " do
          expect(element_val.inspect).to match(/value/)
        end
      end

      context "when forbidden" do
        let(:element_val) do
          element_use_6.copy(:requirement => e_not_used).value("115959", position)
        end

        include_examples "inspect"
      end

      context "when required" do
        let(:element_val) do
          element_use_6.copy(:requirement => e_mandatory).value("115959", position)
        end

        include_examples "inspect"
      end

      context "when optional" do
        let(:element_val) do
          element_use_6.copy(:requirement => e_optional).value("115959", position)
        end

        include_examples "inspect"
      end
    end

    describe "#to_s" do
      context "when minutes are missing" do
        todo { expect(value_6("12").to_s).to eq("12mmss") }
      end

      context "when seconds are missing" do
        specify { expect(value_6("1230").to_s).to eq("1230ss") }
      end
    end

    describe "#to_x12" do
      context "with truncation" do
        specify { expect(value_4("1159591111").to_x12(true)).to eq("1159")     }
        specify { expect(value_6("1159591111").to_x12(true)).to eq("115959")   }
        specify { expect(value_8("1159591111").to_x12(true)).to eq("11595911") }
      end

      context "without truncation" do
        specify { expect(value_4("1159591111").to_x12(false)).to eq("1159591111") }
        specify { expect(value_6("1159591111").to_x12(false)).to eq("1159591111") }
        specify { expect(value_8("1159591111").to_x12(false)).to eq("1159591111") }
      end
    end

    describe "to_time(date, minute, second)" do
      let(:date) { Date.civil(2018, 12, 31) }

      context "when minute is already present" do
        context "and nothing is given" do
          specify { expect(value_4("1159").to_time(date)).to      be_utc }
          specify { expect(value_4("1159").to_time(date).hour).to eq(11) }
          specify { expect(value_4("1159").to_time(date).min).to  eq(59) }
          specify { expect(value_4("1159").to_time(date).sec).to  eq(0)  }
        end

        context "and minute is given" do
          specify { expect(value_4("1159").to_time(date, 30)).to      be_utc }
          specify { expect(value_4("1159").to_time(date, 30).hour).to eq(11) }
          specify { expect(value_4("1159").to_time(date, 30).min).to  eq(59) }
          specify { expect(value_4("1159").to_time(date, 30).sec).to  eq(0)  }
        end

        context "and minute and second are given" do
          specify { expect(value_4("1159").to_time(date, 30, 30)).to      be_utc }
          specify { expect(value_4("1159").to_time(date, 30, 30).hour).to eq(11) }
          specify { expect(value_4("1159").to_time(date, 30, 30).min).to  eq(59) }
          specify { expect(value_4("1159").to_time(date, 30, 30).sec).to  eq(30) }
        end
      end

      context "when minute and second are already present" do
        context "and nothing is given" do
          specify { expect(value_4("115959").to_time(date)).to      be_utc }
          specify { expect(value_4("115959").to_time(date).hour).to eq(11) }
          specify { expect(value_4("115959").to_time(date).min).to  eq(59) }
          specify { expect(value_4("115959").to_time(date).sec).to  eq(59) }
        end

        context "and minute is given" do
          specify { expect(value_4("115959").to_time(date, 30)).to      be_utc }
          specify { expect(value_4("115959").to_time(date, 30).hour).to eq(11) }
          specify { expect(value_4("115959").to_time(date, 30).min).to  eq(59) }
          specify { expect(value_4("115959").to_time(date, 30).sec).to  eq(59)  }
        end

        context "and minute and second are given" do
          specify { expect(value_4("115959").to_time(date, 30, 30)).to      be_utc }
          specify { expect(value_4("115959").to_time(date, 30, 30).hour).to eq(11) }
          specify { expect(value_4("115959").to_time(date, 30, 30).min).to  eq(59) }
          specify { expect(value_4("115959").to_time(date, 30, 30).sec).to  eq(59) }
        end
      end

      todo "when second and minute are nil"
    end

    describe "#==(other)" do
      context "when given a valid TimeVal" do
        specify { expect(value_4("1159")).to       eq(value_4("1159"))     }
        specify { expect(value_4("1159")).to_not   eq(value_4("1130"))     }
        specify { expect(value_4("1159")).to_not   eq(value_6("115900"))   }
        specify { expect(value_4("1159")).to_not   eq(value_8("11595900")) }

        specify { expect(value_4("115959")).to       eq(value_6("115959"))   }
        specify { expect(value_4("115959")).to       eq(value_8("11595900")) }
        specify { expect(value_4("115959")).to_not   eq(value_4("1159"))     }
        specify { expect(value_4("115959")).to_not   eq(value_6("115930"))   }
        specify { expect(value_4("115959")).to_not   eq(value_8("11595911")) }

        specify { expect(value_8("11595900")).to       eq(value_6("115959"))   }
        specify { expect(value_8("11595905")).to       eq(value_8("11595905")) }
        specify { expect(value_8("11595905")).to_not   eq(value_4("1159"))     }
        specify { expect(value_8("11595905")).to_not   eq(value_6("115959"))   }
        specify { expect(value_8("11595905")).to_not   eq(value_8("11595900")) }
      end

      context "when given an empty TimeVal" do
        specify { expect(value_6("115959")).to_not eq(value_6(nil)) }
      end

      context "when given an invalid TimeVal" do
        specify { expect(value_6("115959")).to_not eq(value_6("invalid")) }
      end

      context "when given a Date" do
        specify { expect(value_6("115959")).to_not eq(Date.civil(2020, 12, 31)) }
      end

      context "when given a Time" do
        specify { expect(value_6("115959")).to_not eq(Time.utc(2020, 12, 31, 11, 59, 59)) }
      end
    end

    describe "#copy(changes)" do
      specify { expect(value_6("115959").copy).to                eq(value_6("115959")) }
      specify { expect(value_6("115959").copy(:hour   => 10)).to eq(value_6("105959")) }
      specify { expect(value_6("115959").copy(:minute => 30)).to eq(value_6("113059")) }
      specify { expect(value_6("115959").copy(:second => 30)).to eq(value_6("115930")) }
    end
  end
end
