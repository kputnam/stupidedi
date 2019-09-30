describe Stupidedi, _trict: true do
  before do
    # These files do not (and should not?) have corresponding specs, they're
    # mostly just modules with autoload statements for submodules
    @no_specs = %w(
      stupidedi
      stupidedi/builder
      stupidedi/contrib
      stupidedi/guides
      stupidedi/parser
      stupidedi/schema
      stupidedi/sets
      stupidedi/tokens
      stupidedi/values
      stupidedi/version
      stupidedi/versions
      stupidedi/versions/interchanges
      stupidedi/writer
      stupidedi/interchanges/common
      stupidedi/interchanges/common/element_types
      stupidedi/transaction_sets/common
      stupidedi/transaction_sets/validation
      stupidedi/transaction_sets/common/implementations
      stupidedi/versions/common
      stupidedi/versions/common/element_types)

    # These need specs, but we ignore for now
    @no_specs.concat %w(
      stupidedi/ruby/hash
      stupidedi/ruby/regexp
      stupidedi/ruby/to_date
      stupidedi/interchanges/common/element_types/special_an
      stupidedi/reader/array_ptr
      stupidedi/position
      stupidedi/position/no_position
      stupidedi/position/offset_position
      stupidedi/position/stacktrace_position
      stupidedi/reader/segment_dict
      stupidedi/transaction_sets/builder
      stupidedi/zipper/stack_cursor)

    # These probably aren't worth testing?
    @no_specs.concat %w(
      stupidedi/config/code_list_config
      stupidedi/config/editor_config
      stupidedi/config/functional_group_config
      stupidedi/config/interchange_config
      stupidedi/config/transaction_set_config
      stupidedi/exceptions
      stupidedi/exceptions/invalid_element_error
      stupidedi/exceptions/invalid_schema_error
      stupidedi/exceptions/output_error
      stupidedi/exceptions/parse_error
      stupidedi/exceptions/stupidedi_error
      stupidedi/exceptions/zipper_error
      stupidedi/schema/code_list
      stupidedi/schema/abstract_def
      stupidedi/schema/abstract_use
      stupidedi/schema/abstract_element_def
      stupidedi/schema/abstract_element_use
      stupidedi/schema/component_element_use
      stupidedi/schema/composite_element_use
      stupidedi/schema/composite_element_def
      stupidedi/schema/simple_element_def
      stupidedi/schema/simple_element_use
      stupidedi/schema/interchange_def
      stupidedi/schema/functional_group_def
      stupidedi/schema/transaction_set_def
      stupidedi/schema/element_req
      stupidedi/schema/segment_req
      stupidedi/schema/repeat_count
      stupidedi/schema/segment_def
      stupidedi/schema/segment_use
      stupidedi/schema/loop_def
      stupidedi/schema/table_def
      stupidedi/schema/syntax_note
      stupidedi/transaction_sets/common/implementations/element_reqs
      stupidedi/transaction_sets/common/implementations/segment_reqs
      stupidedi/versions/common/element_reqs
      stupidedi/versions/common/segment_reqs
      stupidedi/versions/common/syntax_notes
      stupidedi/versions/common/element_types/operators
      stupidedi/versions/common/element_types/simple_element)

    # These are better tested indirectly through Stupidedi::Parser
    @no_specs.concat %w(
      stupidedi/reader/tokenizer/result
      stupidedi/reader/tokenizer/element_tok_switch
      stupidedi/parser/constraint_table
      stupidedi/parser/generation
      stupidedi/parser/instruction
      stupidedi/parser/instruction_table
      stupidedi/parser/state_machine
      stupidedi/parser/tokenization
      stupidedi/parser/states/abstract_state
      stupidedi/parser/states/failure_state
      stupidedi/parser/states/functional_group_state
      stupidedi/parser/states/initial_state
      stupidedi/parser/states/interchange_state
      stupidedi/parser/states/loop_state
      stupidedi/parser/states/table_state
      stupidedi/parser/states/transaction_set_state
      stupidedi/parser/states/transmission_state
      stupidedi/tokens/component_element_tok
      stupidedi/tokens/composite_element_tok
      stupidedi/tokens/repeated_element_tok
      stupidedi/tokens/simple_element_tok
      stupidedi/tokens/segment_tok
      stupidedi/tokens/ignored_tok
      stupidedi/values/abstract_val
      stupidedi/values/abstract_element_val
      stupidedi/values/composite_element_val
      stupidedi/values/repeated_element_val
      stupidedi/values/simple_element_val
      stupidedi/values/functional_group_val
      stupidedi/values/interchange_val
      stupidedi/values/invalid_envelope_val
      stupidedi/values/segment_val_group
      stupidedi/values/loop_val
      stupidedi/values/table_val
      stupidedi/values/segment_val
      stupidedi/values/invalid_segment_val
      stupidedi/values/transaction_set_val
      stupidedi/values/transmission_val)

    # These are tested as part of Stupidedi::Zipper, but not individually
    @no_specs.concat %w(
      stupidedi/zipper/abstract_cursor
      stupidedi/zipper/dangling_cursor
      stupidedi/zipper/edited_cursor
      stupidedi/zipper/memoized_cursor
      stupidedi/zipper/root_cursor
      stupidedi/zipper/path)

    # These specs cover Stupidedi::Versions::*::ElementDefs and ::SegmentDefs
    @no_libs = %w(
      stupidedi/reader/native_ext
      stupidedi/versions/element_defs
      stupidedi/versions/segment_defs)
  end

  let(:libs) do
    libs = Set.new(Dir["lib/**/*.rb"].map!{|x| x[4..-4] })

    libs -= @no_specs
  end

  let(:specs) do
    specs  = Set.new(Dir["spec/lib/**/*_spec.rb"].map!{|x| x[9..-9] })
    specs -= @no_libs
  end

  specify "no specs are without a corresponding library file" do
    missing_specs = libs - specs

    # These don't require specs, but it's not an error if they do have specs
    missing_specs.reject!{|x| x =~ %r(/editor(?:/|$)) }
    missing_specs.reject!{|x| x =~ %r(/versions/\d{6}.*) }
    missing_specs.reject!{|x| x =~ %r(/interchanges/\d{5}.*) }
    missing_specs.reject!{|x| x =~ %r(/transaction_sets/\d{6}.*) }
    missing_specs.map!{|x| "lib/#{x}.rb" }

    expect(missing_specs.to_a.sort).to be_empty
  end

  specify "each spec has a file" do
    missing_libs = specs - libs
    missing_libs.map!{|x| "spec/lib/#{x}_spec.rb" }

    expect(missing_libs.to_a.sort).to be_empty
  end
end
