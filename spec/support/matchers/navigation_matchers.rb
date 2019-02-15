module NavigationMatchers
  using Stupidedi::Refinements

  def be_segment(segment_id = nil, *elements)
    BeSegment.new(segment_id, elements)
  end

  class BeSegment
    include Stupidedi::Parser::Navigation
    include Stupidedi::Parser::Tokenization

    def initialize(segment_id, elements)
      @segment_id, @elements = segment_id, elements
    end

    def description
      if @segment_id.nil?
        "be segment"
      else
        if @elements.empty?
          "be segment #{@segment_id}~"
        else
          "be segment #{@segment_id}*#{@elements.map(&:inspect).join("*")})"
        end
      end
    end

    def matches?(value)
      @filter_tok, @syntax_val = extract_arguments(value)
      matches   = @syntax_val.segment? 
      matches &&= !(@syntax_id.present? and filter?(@filter_tok, @syntax_val))
    end

    def failure_message
      if not @syntax_val.segment?
        "#{@syntax_val.pretty_inspect} is not a segment"
      elsif @filter_tok.nil?
        "#{@syntax_val} doesn't belong to a functional group"
      else
        separators  = Stupidedi::Reader::Separators.default
        "#{@syntax_val.pretty_inspect} does not match #{@filter_tok.to_x12(separators)}"
      end
    end

    def does_not_match?(machine)
      raise "don't negate be_segment"
    end

  private

    def extract_arguments(value)
      case value
      when Stupidedi::Parser::StateMachine
        filter_tok = filter_tok(value.active.head.node.zipper)
        syntax_val = value.zipper.fetch.node
      when Stupidedi::Zipper::AbstractCursor
        filter_tok = filter_tok(value)
        syntax_val = value.node
      when Stupidedi::Values::AbstractVal
        filter_tok = filter_tok(nil, Stupidedi::Reader::SegmentDict.build(Definitions::SegmentDefs))
        syntax_val = value
      else
        raise TypeError, "value must be a StateMachine, AbstractCursor, or AbstractVal"
      end
      return filter_tok, syntax_val
    end

    def filter_tok(zipper, segment_dict = nil)
      return nil if @segment_id.nil?
      return nil if @elemnets.nil?

      unless segment_dict.nil?
        return mksegment_tok(segment_dict, @segment_id, @elements, nil)
      end

      until zipper.root?
        syntax_val = zipper.node

        unless syntax_val.functional_group?
          zipper = zipper.up
        else
          # Make sure composite and repeated elements are understood
          segment_dict = Stupidedi::Reader::SegmentDict.empty
          segment_dict = segment_dict.push(syntax_val.segment_dict)
          segment_dict = segment_dict.push(Definitions::SegmentDefs)
          return mksegment_tok(segment_dict, @segment_id, @elements, nil)
        end
      end
    end
  end

  def have_separators(expected)
    HaveSeparators.new(expected)
  end

  class HaveSeparators
    def initialize(expected)
      @expected = Stupidedi::Reader::Separators.build(expected)
    end

    def matches?(machine)
      @given = machine.separators

      return false if @expected.segment     and @given.segment     != @expected.segment
      return false if @expected.element     and @given.element     != @expected.element
      return false if @expected.component   and @given.component   != @expected.component
      return false if @expected.repetition  and @given.repetition  != @expected.repetition

      true
    end

    def description
      "have separators #{@expected.inspect}"
    end

    def failure_message
      "\nexpected: #{@expected.inspect}\n     got: #{@given.inspect}\n"
    end
  end

  def be_able_to_find(*arguments)
    BeAbleToFind.new(arguments)
  end

  class BeAbleToFind
    def initialize(arguments)
      @arguments  = arguments
      @elements   = nil
      @machine    = nil
      @filter_tok = nil
    end

    def with_result_matching(*elements)
      @elements = elements
      self
    end

    def matches?(machine)
      @machine = machine

      begin
        @result = machine.find(*@arguments)

        if @result.defined?
          zipper       = @result.fetch.zipper.fetch
          @segment_val = zipper.node

          if @elements
            @filter_tok = machine.__send__(:mksegment_tok,
              machine.active.head.node.segment_dict, @segment_val.id, @elements, nil)

            not machine.__send__(:filter?, @filter_tok, @segment_val)
          else
            true
          end
        else
          false
        end
      rescue Stupidedi::Exceptions::ParseError => error
        @error = error
        false
      end
    end

    def does_not_match?(machine)
      if @elements
        raise "don't use with_result_matching(..) along with expect(..).to_not"
      end

      not matches?(machine)
    end

    def description
      "be able to find(#{@arguments.map(&:inspect).join(", ")})"
    end

    def failure_message
      if @error.nil?
        if @result.defined?
          separators  = Stupidedi::Reader::Separators.new(":", "^", "*", "~")
          segment_val = @segment_val.pretty_inspect
          filter_tok  = @filter_tok.to_s(separators)
          "#{segment_val} result does not match #{filter_tok}"
        else
          @result.reason
        end
      else
        @error.to_s
      end
    end

    def failure_message_when_negated
      found = @segment_val.pretty_inspect
      "expected find nothing, but found #{found}"
    end
  end

  def have_distance(expected)
    HaveDistance.new(expected)
  end

  class HaveDistance
    def initialize(expected)
      @expected = expected
    end

    def from(machine)
      @start = machine
      self
    end

    def to(machine)
      @start = machine
      self
    end

    def matches?(machine)
      @stop   = machine
      @actual = @start.distance(machine)
      @actual.select{|d| d == @expected }.defined?
    end

    def failure_message
      if @actual.defined?
        "expected #{@expected} but was #{@actual.fetch} segments apart"
      else
        "not in the same tree: #{@start} and #{@stop}"
      end
    end
  end
end
