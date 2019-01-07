using Stupidedi::Refinements

#
# This class is designed to be subclassed, to avoid polluting the minimal
# base class. Subclasses can add parameters with the macro "has_parameter",
# and parameters are inherited when subclassing.
#
# @see https://github.com/hayeah/rantly
#
class QuickCheck
  autoload :Characters, "support/quickcheck/characters"
  autoload :Property,   "support/quickcheck/property"

  def initialize
    @bindings = []
  end
end

class << QuickCheck
  def property(base, *args, &setup)
    QuickCheck::Property.new(base, new, *args, &setup)
  end

  # Generate `count` values, returning nil
  def each(count, limit = 10, &block)
    new.each(count, limit, &block)
  end

  # Generate an array of `count` values
  def map(count, limit = 10, &block)
    new.map(count, limit, &block)
  end

  # Generate a single value
  def value(limit = 10,  &block)
    new.value(limit, &block)
  end

  def generate(count, limit, setup, &block)
    new.generate(count, limit, setup, &block)
  end

  # @return [Class]
  def default
    @default ||= (superclass == Object) ?
      Class.new.new :
      Class.new(superclass).new
  end

  # @return [void]
  def has_parameter(name, value)
    scope = self
    define_method(name) { instance_variable_get("@_parameter_#{name}") || scope.default.send(name) }
    default.class.send(:define_method, name) { value }
  end
end

class QuickCheck
  module Macro
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def property(*args, &setup)
        QuickCheck.property(self, *args, &setup)
      end
    end
  end

  class GuardFailure < StandardError; end

  class NoMoreTries < StandardError
    # @return [Integer]
    attr_reader :limit

    # @return [Integer]
    attr_reader :tries

    def initialize(limit, tries)
      @limit, @tries = limit, tries
    end

    # @return [String]
    def to_s
      "Exceeded limit #{limit}: #{tries} failed guards"
    end
  end

  # Controls the size of sized generators: array, string
  has_parameter :size, 6

  # Generate `count` values, returning nil
  def each(count, limit = 10, &setup)
    generate(count, limit, setup)
  end

  # Generate an array of `count` values
  def map(count, limit = 10, &setup)
    acc = []; generate(count, limit, setup) {|x| acc << x }; acc
  end

  # Generate a single value
  def value(limit = 10, &setup)
    generate(1, limit, setup) {|x| return x }
  end

  def generate(count, limit, setup, &block)
    retries  = count * limit
    failures = successes = 0

    @bindings.push(eval("self", block.binding))

    while successes < count
      raise NoMoreTries.new(count * limit, failures) if retries < 0

      begin
        retries -= 1
        value    = instance_eval(&setup)
      rescue GuardFailure
        failures += 1
      else
        successes += 1
        yield(value) if block_given?
      end
    end

    @bindings.pop
  end

  def guard(condition)
    raise GuardFailure unless condition
  end

  # Called with a block, sets `parameters` temporarily while evaluating the
  # block, and returns the value of the block. Without a block, this permanently
  # sets `parameters`
  def with(*parameters)
    parameters = Hash[*parameters]

    if block_given?
      # Copy current parameters to a safe place
      prev = instance_variables.grep(/@_parameter/).inject({}) do |hash, name|
        hash.update(name => instance_variable_get(name))
      end

      # Update the given parameters
      parameters.each{|name, value| instance_variable_set("@_parameter_#{name}", value) }

      begin
        yield
      ensure
        # Remove all the parameters
        instance_variables.each do |name|
          next unless /^@_parameter_/ =~ name
          remove_instance_variable(name)
        end

        # Restore previous parameters from the copy
        prev.each{|name, value| instance_variable_set(name, value) }
      end
    else
      parameters.each{|name, value| instance_variable_set("@_parameter_#{name}", value) }
    end
  end

  INTMIN = 2 ** (0.size * 8 - 2) - 1
  INTMAX = -INTMIN + 1

  # Returns the given parameter
  def literal(x); x end

  # Generates an integer
  def integer(magnitude = nil)
    case magnitude
    when Range   then between(magnitude.end, magnitude.begin)
    when Integer then between(magnitude, -magnitude)
    else              between(INTMAX, INTMIN) end
  end

  # Generates a float
  alias float rand

  # Generates a value between the given range
  def between(lo, hi = nil)
    case lo
    when Numeric
      rand(hi + 1 - lo) + lo
    when Range
      # @todo: #to_a is wasteful for large Ranges
      lo.to_a.bind{|a| a[between(0, a.length - 1)] }
    end
  end

  # Generates true or false
  def boolean
    rand(2) == 0
  end

  # Generates a sized array by iteratively evaluating `block`
  def array(&block)
    @bindings.push(eval("self", block.binding))

    (1..size).inject([]) {|a,_| a << instance_eval(&block) }.tap do
      @bindings.pop
    end
  end

  # Generates a character the given character class
  def character(type = :print)
    chars = case type
            when Regexp then Characters.of(type)
            when Symbol then Characters::CLASSES[type] end

    raise ArgumentError, "unrecognized character type #{type.inspect}" unless chars
    choose(chars)
  end

  # Generates a sized string of the given character class
  def string(type = :print)
    chars = case type
            when Regexp then Characters.of(type)
            when Symbol then Characters::CLASSES[type] end

    raise ArgumentError, "unrecognized character type #{type.inspect}" unless chars
    acc = ""; size.times { acc << choose(chars) }; acc
  end

  # Generate a weighted value by calling the tail of each element
  #
  # @example
  #   freq [1, :literal, "one"],
  #        [2, :string],
  #        [3, :string, :alpha],
  #        [4, [:string, :alpha]],
  #        [5, lambda{ with(:size, 2) { string }}],
  #        [6, lambda{|x| with(:size, x) { string }}, 2]
  def freq(*pairs)
    total = 0
    pairs = pairs.map do |p|
      case p
      when Symbol, String, Proc
        total += 1; [1, p]
      when Array
        total += p.head; p
      end
    end

    index = between(1, total)
    pairs.each do |p|
      weight, generator, *args = p
      if index <= weight
        return call(generator, *args)
      else
        index -= weight
      end
    end
  end

  # Generates an element from the given array of values
  def choose(values)
    values[between(0, values.length - 1)]
  end

  # Executes `call` on a random element from the given array of values
  def branch(generators)
    call(choose(generators))
  end

  # Executes the given generator
  #
  # @example
  #   call(:integer)
  #   call(:choose, [1,2,3])
  #   call([:choose, [1,2,3]])
  #   call(lambda { choose([1,2,3]) }
  def call(generator, *args)
    case generator
    when Symbol, String
      send(generator, *args)
    when Array
      send(generator.head, *generator.tail)
    when Proc
      @bindings.push(eval("self", generate.binding))

      instance_eval { generator.call(*args) }.tap do
        @bindings.pop
      end
    else
      raise ArgumentError, "unrecognized generator type #{generator.inspect}"
    end
  end

private

  def method_missing(name, *args, &block)
    unless @bindings.empty?
      @bindings.last.__send__(name, *args, &block)
    else
      super
    end
  end
end
