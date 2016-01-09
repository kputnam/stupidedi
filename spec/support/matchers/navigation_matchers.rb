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

  matcher :have_separators do |expected|
    match do |machine|
      machine.separators.segment == expected[:segment] and
      machine.separators.element == expected[:element] and
      machine.separators.component == expected[:component] and
      machine.separators.repetition == expected[:repetition]
    end
  end

  def have_distance(expected)
    Class.new do
      def initialize(distance)
        @distance = distance
      end

      def from(machine)
        HaveDistance.new(@distance, machine)
      end

      def to(machine)
        HaveDistance.new(@distance, machine)
      end
    end.new(expected)
  end

  class HaveDistance
    def initialize(expected, start)
      @expected, @start =
        expected, start
    end

    def matches?(machine)
      @stop   = machine
      @actual = @start.distance(machine)

      @actual.select{|d| d == @expected }.defined?
    end

    def failure_message
      if @actual.defined?
        actual = nil
        @actual.tap{|d| actual = d }
        "expected #{@expected} but was #{actual} segments apart"
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
        backward = @backwards[@expected.length - k]
        
        if e != forward
          return "segment #{k+1} was #{forward} not #{e}"
        end
      end

      extra = @forwards.drop(@expected.length)
      return "extra segments #{extra.map(&:inspect).join(", ")}"
    end
  end

  def have_structure(expected)
    HaveStructure.new(expected)
  end

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
            $!.message << " from #{PP.pp(machine, "")}"
            raise
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
            $!.message << " from #{PP.pp(machine, "")}"
            raise
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
          raise "#{selector.first} exists #{PP.pp(m, "")}"
        end
      when :R # Should be reachable, but shouldn't occur
        result.explain do |e|
          if e.is_a?(Exception)
            # Not reachable
            raise e
          end
        end.tap do |m|
          # Found
          raise "#{selector.first} exists #{PP.pp(m, "")}"
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
