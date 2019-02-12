module NavigationMatchers
  extend RSpec::Matchers::DSL
  using Stupidedi::Refinements

  matcher :have_parent do |parent|
    match do |child|
      if child.respond_to?(:segment)
        parent.segment.flatmap do |e|
          child.parent.flatmap(&:segment).
            select{|f| e.node.eql?(f.node) }
        end.defined?
      elsif child.is_a?(Symbol)
        parent.segment.
          select{|e| e.node.id.eql?(child) }.defined?
      end
    end
  end

  def be_segment(segment_id, *elements)
    BeSegment.new(segment_id, elements)
  end

  class BeSegment
    include Stupidedi::Parser::Navigation
    include Stupidedi::Parser::Tokenization

    def initialize(segment_id, elements)
      @segment_id, @elements = segment_id, elements
    end

    def description
      if @elements.empty?
        "be segmenu #{@segment_id}~"
      else
        "be segment #{@segment_id}*#{@elements.map(&:inspect).join("*")})"
      end
    end

    def matches?(value)
      @filter_tok, @syntax_val = extract_arguments(value)
      not @filter_tok.nil? and @syntax_val.segment? and not filter?(@filter_tok, @syntax_val)
    end

    def failure_message
      if @filter_tok.nil?
        "#{@syntax_val} doesn't belong to a functional group"
      elsif @syntax_val.segment?
        separators  = Stupidedi::Reader::Separators.default
        "#{@syntax_val.pretty_inspect} does not match #{@filter_tok.to_x12(separators)}"
      else
        "#{@syntax_val.pretty_inspect} is not a segment"
      end
    end

    def does_not_match?(machine)
      @filter_tok, @syntax_val = extract_arguments(value)
      not @filter_tok.nil? and @syntax_val.segment? and filter?(@filter_tok, @syntax_val)
    end

    def failure_message_when_negated
      if @filter_tok.nil?
        "#{@syntax_val} doesn't belong to a functional group"
      elsif @syntax_val.segment?
        separators  = Stupidedi::Reader::Separators.default
        "#{@syntax_val.pretty_inspect} matches #{@filter_tok.to_x12(separators)}"
      else
        "#{@syntax_val.pretty_inspect} is not a segment"
      end
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

  def have_sequence(expected)
    HaveSequence.new(expected)
  end

  class HaveSequence
    def initialize(expected)
      @expected  = expected.map(&:to_sym)
      @forwards  = []
      @backwards = []
    end

    def matches?(machine)
      cursor = machine.first
      while cursor.defined?
        cursor = cursor.flatmap do |c|
          c.segment.tap{|x| @forwards << x.node.id }
          c.next
        end
      end

      cursor = machine.last
      while cursor.defined?
        cursor = cursor.flatmap do |c|
          c.segment.tap{|x| @backwards << x.node.id }
          c.prev
        end
      end

      @forwards == @expected and @backwards == @expected.reverse
    end

    def description
      "have sequence"
    end

    def failure_message
      @expected.each_with_index do |e, k|
        forward  = @forwards[k]
        #ackward = @backwards[@expected.length - k]

        if e != forward
          return "segment #{k+1} was #{forward}, not #{e}"
        end
      end

      extra = @forwards.drop(@expected.length)
      "extra segments #{extra.map(&:inspect).join(", ")}"
    end
  end

  def have_structure(expected)
    HaveStructure.new(expected)
  end

  # list of branches to take
  def Ss(*segments)
    if segments.first.is_a?(Hash)
      segments
    else
      segments
    end
  end

  # composite
  def C(*components)
    [:composite, components, nil]
  end

  # reachable and exists
  def S(id, *elements)
    :S.cons(id.cons(elements))
  end

  # reacheable and doesn't exist
  def R(id, *elements)
    :R.cons(id.cons(elements))
  end

  # unreachable
  def X(id, *elements)
    :X.cons(id.cons(elements))
  end

  class HaveStructure
    def initialize(expected)
      @expected = expected
    end

    def matches?(machine)
      navigate(machine, @expected)
    end

    def description
      "have structure"
    end

  private

    def navigate(machine, selectors)
      if selectors.is_a?(Hash)
        selectors.each do |selector, children|
          tag, *selector = selector

          result =
            begin
              machine.find(*selector).tap do |m|
                if children.is_a?(Enumerable) and children.present?
                  navigate(m, children)
                end
              end
            rescue => ex
              Stupidedi::Either.failure(ex)
            end

          begin
            interpret(tag, result, selector)
          rescue Exception
            raise "#{$!.message} from #{machine.pretty_inspect}"
          end
        end
      elsif selectors.is_a?(Array)
        selectors.each do |selector|
          return navigate(machine, selector) if selector.is_a?(Hash)

          tag, *selector = selector

          result =
            begin
              machine.find(*selector)
            rescue => ex
              Stupidedi::Either.failure(ex)
            end

          begin
            interpret(tag, result, selector)
          rescue Exception
            raise "#{$!.message} from #{machine.pretty_inspect}"
          end
        end
      end

      true
    end

    def interpret(tag, result, selector)
      case tag
      when :X # Shouldn't be reachable
        result.explain do |e|
          unless e.is_a?(Exception)
            # Didn't find a match, but it was reachable
            raise "#{selector.first} was reachable"
          end
        end.tap do |m|
          # Found a match
          raise "#{selector.first} exists #{m.pretty_inspect}"
        end
      when :R # Should be reachable, but shouldn't occur
        result.explain do |e|
          if e.is_a?(Exception)
            # Not reachable
            raise e
          end
        end.tap do |m|
          # Found
          raise "#{selector.first} exists #{m.pretty_inspect}"
        end
      when :S # Should be reachable, and should occur
        result.explain do |e|
          # Not found or not reachable
          if e.is_a?(Exception)
            raise e
          else
            raise e
          end
        end
      end
    end
  end
end
