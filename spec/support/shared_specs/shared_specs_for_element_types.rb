RSpec.shared_examples "global_element_types_invalid" do
  describe "#too_short?" do
    specify { expect(invalid_val).to_not be_too_short }
  end

  describe "#too_long?" do
    specify { expect(invalid_val).to_not be_too_long }
  end

  describe "#empty?" do
    specify { expect(invalid_val).to_not be_empty }
  end

  describe "#blank?" do
    specify { expect(invalid_val).to_not be_blank }
  end

  describe "#valid?" do
    specify { expect(invalid_val).to_not be_valid }
  end

  describe "#invalid?" do
    specify { expect(invalid_val).to be_invalid }
  end

  describe "#usage" do
    specify { expect(invalid_val.usage).to eql(element_use) }
  end

  describe "#position" do
    specify { expect(invalid_val.position).to eql(position) }
  end

  describe "#inspect" do
    context "when optional" do
      let(:invalid_use_) { invalid_val.usage.copy(:requirement => e_optional) }
      let(:invalid_val_) { invalid_use_.value(invalid_val.value, position) }

      specify { expect(invalid_val_.inspect).to be_a(String) }
      specify { expect(invalid_val_.inspect).to match(/invalid/) }
    end

    context "when required" do
      let(:invalid_use_) { invalid_val.usage.copy(:requirement => e_required) }
      let(:invalid_val_) { invalid_use_.value(invalid_val.value, position) }

      specify { expect(invalid_val_.inspect).to be_a(String) }
      specify { expect(invalid_val_.inspect).to match(/invalid/) }
    end

    context "when forbidden" do
      let(:invalid_use_) { invalid_val.usage.copy(:requirement => e_not_used) }
      let(:invalid_val_) { invalid_use_.value(invalid_val.value, position) }

      specify { expect(invalid_val_.inspect).to be_a(String) }
      specify { expect(invalid_val_.inspect).to match(/invalid/) }
    end
  end

  describe "#to_s" do
    specify { expect(invalid_val.to_s).to eq("") }
  end

  describe "#to_x12(truncate)" do
    context "with truncation" do
      specify { expect(invalid_val.to_x12(true)).to eq("") }
    end

    context "without truncation" do
      specify { expect(invalid_val.to_x12(true)).to eq("") }
    end
  end

  describe "#copy(changes)" do
    specify { expect(invalid_val.copy).to eql(invalid_val) }
    specify { expect(invalid_val.copy(:usage => nil)).to eql(invalid_val) }
    specify { expect(invalid_val.copy(:position => nil)).to eql(invalid_val) }
  end

  describe "#coerce(other)" do
    specify { expect(invalid_val).to_not respond_to(:coerce) }
  end

  describe "#map(&block)" do
    specify { expect{|b| invalid_val.map(&b) }.to_not yield_control }
  end

  describe "#==(other)" do
    specify { expect(invalid_val).to_not eq("") }
    specify { expect(invalid_val).to_not eq(nil) }
    specify { expect(invalid_val).to eq(invalid_val) }
  end
end

RSpec.shared_examples "global_element_types_empty" do
  describe "#too_short?" do
    specify { expect(empty_val).to_not be_too_short }
  end

  describe "#too_long?" do
    specify { expect(empty_val).to_not be_too_long }
  end

  describe "#empty?" do
    specify { expect(empty_val).to be_empty }
  end

  describe "#blank?" do
    specify { expect(empty_val).to be_blank }
  end

  describe "#valid?" do
    specify { expect(empty_val).to be_valid }
  end

  describe "#invalid?" do
    specify { expect(empty_val).to be_valid }
  end

  describe "#usage" do
    specify { expect(empty_val.usage).to eql(element_use) }
  end

  describe "#position" do
    specify { expect(empty_val.position).to eql(position) }
  end

  describe "#inspect" do
    context "when optional" do
      let(:empty_use_) { empty_val.usage.copy(:requirement => e_optional) }
      let(:empty_val_) { empty_use_.value("", position) }

      specify { expect(empty_val_.inspect).to be_a(String) }
      specify { expect(empty_val_.inspect).to match(/empty/) }
    end

    context "when required" do
      let(:empty_use_) { empty_val.usage.copy(:requirement => e_required) }
      let(:empty_val_) { empty_use_.value("", position) }

      specify { expect(empty_val_.inspect).to be_a(String) }
      specify { expect(empty_val_.inspect).to match(/empty/) }
    end

    context "when forbidden" do
      let(:empty_use_) { empty_val.usage.copy(:requirement => e_not_used) }
      let(:empty_val_) { empty_use_.value("", position) }

      specify { expect(empty_val_.inspect).to be_a(String) }
      specify { expect(empty_val_.inspect).to match(/empty/) }
    end
  end

  describe "#to_s" do
    specify { expect(empty_val.to_s).to eq("") }
  end

  describe "#to_x12(truncate)" do
    context "with truncation" do
      specify { expect(empty_val.to_x12(true)).to eq("") }
    end

    context "without truncation" do
      specify { expect(empty_val.to_x12(false)).to eq("") }
    end
  end

  describe "#copy(changes)" do
    specify { expect(empty_val.copy).to eq(empty_val) }
    specify { expect(empty_val.copy(:value => valid_str)).to be_valid }
    specify { expect(empty_val.copy(:value => valid_str)).to_not be_empty }
    specify { expect(empty_val.copy(:value => invalid_str)).to be_invalid }
  end

  describe "#coerce(other)" do
    specify do
      he, me = empty_val.coerce(valid_str)
      expect(he).to be_valid
      expect(me).to eql(empty_val)
    end
  end

  describe "#map(&block)" do
    specify { expect{|b| empty_val.map(&b) }.to yield_with_args(empty_val.value) }
    specify { expect(empty_val.map{|_| valid_str }).to eq(empty_val.usage.value(valid_str, position)) }
  end

  describe "#==(other)" do
    specify { expect(empty_val).to eq(empty_val) }
    specify { expect(empty_val).to eq(empty_val.value) }
    specify { expect(empty_val).to_not eq(empty_val.copy(:value => valid_str)) }
    specify { expect(empty_val).to eq(empty_val.to_x12) }
  end
end

RSpec.shared_examples "global_element_types_non_empty" do
  describe "#too_short?" do
    specify { expect(element_val).to_not be_too_short }
  end

  describe "#too_long?" do
    specify { expect(element_val).to_not be_too_long }
  end

  describe "#empty?" do
    specify { expect(element_val).to_not be_empty }
  end

  describe "#blank?" do
    specify { expect(element_val).to_not be_blank }
  end

  describe "#valid?" do
    specify { expect(element_val).to be_valid }
  end

  describe "#invalid?" do
    specify { expect(element_val).to_not be_invalid }
  end

  describe "#usage" do
    specify { expect(element_val.usage).to eql(element_use) }
  end

  describe "#position" do
    specify { expect(element_val.position).to eql(position) }
  end

  describe "#inspect" do
    let(:inspect_str_) do
      if respond_to?(:inspect_str)
        inspect_str
      else
        element_val_.to_s
      end
    end

    context "when optional" do
      let(:element_use_) { element_val.usage.copy(:requirement => e_optional) }
      let(:element_val_) { element_use_.value(element_val, element_val.position) }

      specify { expect(element_val_.inspect).to be_a(String) }
      specify { expect(element_val_.inspect).to match(/value/) }
      specify { expect(element_val_.inspect).to match(inspect_str_) }
    end

    context "when required" do
      let(:element_use_) { element_val.usage.copy(:requirement => e_required) }
      let(:element_val_) { element_use_.value(element_val, element_val.position) }

      specify { expect(element_val_.inspect).to be_a(String) }
      specify { expect(element_val_.inspect).to match(/value/) }
      specify { expect(element_val_.inspect).to match(inspect_str_) }
    end

    context "when forbidden" do
      let(:element_use_) { element_val.usage.copy(:requirement => e_not_used) }
      let(:element_val_) { element_use_.value(element_val, element_val.position) }

      specify { expect(element_val_.inspect).to be_a(String) }
      specify { expect(element_val_.inspect).to match(/value/) }
      specify { expect(element_val_.inspect).to match(inspect_str_) }
    end
  end

  describe "#copy(changes)" do
    specify { expect(element_val.copy).to eq(element_val) }
    specify { expect(element_val.copy(:value => valid_str)).to be_valid }
    specify { expect(element_val.copy(:value => invalid_str)).to be_invalid }
  end

  describe "#coerce(other)" do
    specify do
      he, me = element_val.coerce(valid_str)
      expect(he).to be_valid
      expect(me).to eql(element_val)
    end

    specify do
      he, me = element_val.coerce(invalid_str)
      expect(he).to be_invalid
      expect(me).to eql(element_val)
    end
  end

  describe "#map(&block)" do
    specify { expect{|b| element_val.map(&b) }.to yield_control }
    specify { expect(element_val.map{|_| valid_str }).to be_valid }
    specify { expect(element_val.map{|_| invalid_str }).to be_invalid }
  end

  describe "#==(other)" do
    specify { expect(element_val).to_not eq(nil) }
    specify { expect(element_val).to eq(element_val.to_x12(false)) }
    specify do
      if element_val.respond_to?(:value)
        expect(element_val).to eq(element_val.value)
      end
    end
  end
end
