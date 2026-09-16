# frozen_string_literal: true

describe "inspect and pretty_print coverage" do
  it "covers Config objects via pp" do
    config = Stupidedi::Config.default
    expect { pp config }.not_to raise_error
    expect { pp config.transaction_set }.not_to raise_error
    expect { pp config.interchange }.not_to raise_error
    expect { pp config.functional_group }.not_to raise_error
    expect { pp config.code_list }.not_to raise_error
    expect { pp config.editor }.not_to raise_error
  end

  it "covers Either objects via pp" do
    success = Stupidedi::Either.success("test_value")
    failure = Stupidedi::Either.failure("test_reason")
    expect { pp success }.not_to raise_error
    expect { pp failure }.not_to raise_error
  end
end

describe "parsed values via pp" do
  it "covers parsed object hierarchy via pp" do
    machine, result = Fixtures.parse!("005010/X221 HP835 Health Care Claim Payment Advice/case/1.edi")
    roots = machine.__send__(:roots)

    expect { roots.each { |root| pp root.node.zipper } }.not_to raise_error
  end
end

describe "schema definitions via pp" do
  it "covers interchange and functional group definitions via pp" do
    config = Stupidedi::Config.default

    %w(005010 004010 003050).each do |version|
      expect { pp config.interchange.at(version) }.not_to raise_error
      expect { pp config.functional_group.at(version) }.not_to raise_error
    end
  end
end

describe "tokens via pp" do
  it "covers token objects via pp" do
    position = Stupidedi::Position::NoPosition
    simple_tok = Stupidedi::Tokens::SimpleElementTok.build("test", position)

    expect { pp Stupidedi::Tokens::SimpleElementTok.build("test_value", position) }.not_to raise_error
    expect { pp Stupidedi::Tokens::CompositeElementTok.build([simple_tok], position) }.not_to raise_error
    expect { pp Stupidedi::Tokens::ComponentElementTok.build([simple_tok], position) }.not_to raise_error
    expect { pp Stupidedi::Tokens::RepeatedElementTok.build([simple_tok], position) }.not_to raise_error
    expect { pp Stupidedi::Tokens::SegmentTok.build("ISA", [simple_tok], position) }.not_to raise_error
    expect { pp Stupidedi::Tokens::IgnoredTok.build("~", position) }.not_to raise_error
  end
end

describe "parser and element types via pp" do
  it "covers parser objects via pp" do
    expect { pp Stupidedi::Parser::ConstraintTable.new }.not_to raise_error
    expect { pp Stupidedi::Parser::InstructionTable.new }.not_to raise_error
  end

  it "covers element types via pp" do
    config = Stupidedi::Config.default
    element_type = Stupidedi::Versions::Common::ElementTypes::AN
    expect { pp element_type }.not_to raise_error
  end

  it "covers position via pp" do
    expect { pp Stupidedi::Position::NoPosition }.not_to raise_error
  end
end

describe "reader and position infrastructure via pp" do
  it "covers reader separators via pp" do
    separators = Stupidedi::Reader::Separators.build(:segment => "~", :element => "*", :component => ":", :repetition => "^")
    expect { pp separators }.not_to raise_error
  end
end
