# frozen_string_literal: true

# lib/ruby/array.rb
    class Array
      def blank?
        empty?
      end

      def present?
        not empty?
      end

      # Return the first item. Raises an `IndexError` if the Array is `empty?`.
      #
      # @example
      #   [1, 2, 3].head  #=> 1
      #
      def head
        raise IndexError, "head of empty list" if empty?
        x, = self
        x
      end

      # True if `#at` is defined for the given `n`
      #
      # @example
      #   [1, 2, 3].defined_at?(0)    #=> true
      #   [].defined_at?(0)           #=> false
      #
      def defined_at?(n)
        n < length and -n <= length
      end

      # @group Selection
      #############################################################################

      # Selects all elements except the first.
      #
      # @example
      #   [1, 2, 3].tail  #=> [2, 3]
      #   [1].tail        #=> []
      #   [].tail         #=> []
      #
      # @return [Array]
      def tail
        _, *xs = self
        xs
      end

      # Selects all elements except the last `n` ones.
      #
      # @example
      #   [1, 2, 3].init      #=> [1, 2]
      #   [1, 2, 3].init(2)   #=> [1]
      #   [].tail             #=> []
      #
      # @return [Array]
      def init(n = 1)
        raise ArgumentError, "n cannot be negative" if n < 0
        slice(0..-(n + 1)) or []
      end

      # Select all elements except the first `n` ones.
      #
      # @example
      #   [1, 2, 3].drop(1)   #=> [2, 3]
      #   [1, 3, 3].drop(2)   #=> [3]
      #   [].drop(10)         #=> []
      #
      # @return [Array]
      def drop(n)
        raise ArgumentError, "n cannot be negative" if n < 0
        slice(n..-1) or []
      end

      # Select the first `n` elements.
      #
      # @example
      #   [1, 2, 3].take(2)  #=> [1, 2]
      #   [1, 2, 3].take(0)  #=> []
      #
      # @return [Array]
      def take(n)
        raise ArgumentError, "n cannot be negative" if n < 0
        slice(0, n) or []
      end

      # Split the array in two at the given position.
      #
      # @example
      #   [1, 2, 3].split_at(2)   #=> [[1,2], [3]]
      #   [1, 2, 3].split_at(0)   #=> [[], [1,2,3]]
      #
      # @return [(Array, Array)]
      def split_at(n)
        n = length + n if n < 0
        return take(n), drop(n)
      end

      # @endgroup
      #############################################################################

      # @group Filtering
      #############################################################################

      # Drops the longest prefix of elements that satisfy the predicate.
      #
      # @return [Array]
      def drop_while(&block)
        # This is in tail call form
        if not empty? and yield(head)
          tail.drop_while(&block)
        else
          self
        end
      end

      # Drops the longest prefix of elements that do not satisfy the predicate.
      #
      # @return [Array]
      def drop_until(&block)
        # This is in tail call form
        unless empty? or yield(head)
          tail.drop_until(&block)
        else
          self
        end
      end

      # Takes the longest prefix of elements that satisfy the predicate.
      #
      # @return [Array]
      def take_while(accumulator = [], &block)
        # This is in tail call form
        if not empty? and yield(head)
          tail.take_while(head.snoc(accumulator), &block)
        else
          accumulator
        end
      end

      # Takes the longest prefix of elements that do not satisfy the predicate.
      #
      # @return [Array]
      def take_until(accumulator = [], &block)
        # This is in tail call form
        unless empty? or yield(head)
          tail.take_until(head.snoc(accumulator), &block)
        else
          accumulator
        end
      end

      # Splits the array into prefix/suffix pair according to the predicate.
      #
      # @return [(Array, Array)]
      def split_until(&block)
        prefix = take_while(&block)
        suffix = drop(prefix.length)
        return prefix, suffix
      end

      # Splits the array into prefix/suffix pair according to the predicate.
      #
      # @return [(Array, Array)]
      def split_when(&block)
        prefix = take_until(&block)
        suffix = drop(prefix.length)
        return prefix, suffix
      end

      # Returns a list of sublists, where each sublist contains only equal
      # elements. Equality is determined by a two-argument block parameter.
      # The concatenation of the result is equal to the original argument.
      #
      # @example
      #   "abba".split(//).group_seq(&:==) #=> [["y"], ["a"], ["b", "b"], ["a"]]
      #
      # @return [[Array]]
      def runs(&block)
        unless empty?
          as, bs = tail.split_until{|x| block.call(head, x) }
          head.cons(as).cons(bs.runs(&block))
        else
          []
        end
      end

      # @endgroup
      #############################################################################

      # Accumulate elements using the `+` method, optionally
      # transforming them first using a block
      #
      # @example
      #   ["a", "b", "cd"].sum             #=> "abcd"
      #   ["a", "b", "cd"].sum(&:length)   #=> 4
      #
      def sum(&block)
        if block_given?
          tail.inject(yield(head)){|sum,e| sum + yield(e) }
        else
          tail.inject(head){|sum,e| sum + e }
        end
      end

      # Count the number of elements that satisfy the predicate
      #
      # @example
      #   ["abc", "de", "fg", "hi"].count{|s| s.length == 2 } #=> 3
      #   ["a", "b", "a", "c", "a"].count("a")                #=> 3
      #   [1, 3, 5, 9, 0].count                               #=> 5
      #
      # @return [Integer]
      def count(*args)
        if block_given?
          inject(0){|n, e| yield(e) ? n + 1 : n }
        elsif args.empty?
          size
        else
          inject(0){|n, e| e == args.first ? n + 1 : n }
        end
      end
    end

# lib/ruby/blank.rb
    class String
      # True if the string is `empty?` or contains all whitespace
      #
      # @example
      #   "abc".blank?    #=> false
      #   "   ".blank?    #=> true
      #   "".blank?       #=> true
      #
      def blank?
        self !~ /\S/
      end

      def present?
        self =~ /\S/
      end
    end

    class NilClass
      # Always `true`. Note this overrides {Object#blank?} which returns false.
      #
      # @example
      #   nil.blank?    #=> true
      #
      def blank?
        true
      end

      def present?
        false
      end
    end

    class Object
      # Always `false`. Note that {NilClass#blank?} is overridden to return `true`
      #
      # @example
      #   false.blank?    #=> false
      #   100.blank?      #=> false
      #
      def blank?
        false
      end

      def present?
        true
      end
    end

# lib/ruby/hash.rb
    class Hash
      def defined_at?(x)
        include?(x)
      end

      def at(x)
        self[x]
      end
    end

# lib/ruby/instance_exec.rb
    class Object
      if RUBY_VERSION < "1.9"
        module InstanceExecHelper; end
        include InstanceExecHelper

        # @see http://eigenclass.org/hiki/instance_exec
        def instance_exec(*args, &block)
          thread = Thread.current.object_id.abs
          object = object_id.abs
          mname  = "__instance_exec_#{thread}_#{object}"
          InstanceExecHelper.module_eval { define_method(mname, &block) }

          begin
            __send__(mname, *args)
          ensure
            begin
              InstanceExecHelper.module_eval { remove_method(mname) }
            rescue
            end
          end
        end
      end
    end

# lib/ruby/module.rb
    class Module
      # Creates an abstract method
      #
      # @example
      #   class Collection
      #     abstract :size
      #     abstract :add, :args => %w(item)
      #   end
      #
      # @return [void]
      def abstract(name, *params)
        if params.last.is_a?(Hash)
          # abstract :method, :args => %w(a b c)
          params = params.last[:args]
        end

        file, line, = Stupidedi.caller

        if params.empty?
          class_eval(<<-RUBY, file, line.to_i - 1)
            def #{name}(*args)
              raise NoMethodError,
                "method \#{self.class.name}.#{name} is abstract"
            end
          RUBY
        else
          class_eval(<<-RUBY, file, line.to_i - 1)
            def #{name}(*args)
              raise NoMethodError,
                "method \#{self.class.name}.#{name}(#{params.join(', ')}) is abstract"
            end
          RUBY
        end
      end

      def def_delegators(target, *methods)
        file, line, = Stupidedi.caller

        for m in methods
          if m.to_s =~ /=$/
            class_eval(<<-RUBY, file, line.to_i - 1)
              def #{m}(value)
                #{target}.#{m}(value)
              end
            RUBY
          else
            class_eval(<<-RUBY, file, line.to_i - 1)
              def #{m}(*args, &block)
                #{target}.#{m}(*args, &block)
              end
            RUBY
          end
        end
      end
    end

# lib/ruby/object.rb
    class Object
      # @group List Constructors
      #############################################################################

      # Prepend the item to the front of a new list
      #
      # @example
      #   1.cons              #=> [1]
      #   1.cons(2.cons)      #=> [1, 2]
      #   1.cons([0, 0, 0])   #=> [1, 0, 0, 0]
      #
      # @return [Array]
      def cons(array = [])
        [self] + array
      end

      # Append the item to rear of a new list
      #
      # @example
      #   1.snoc              #=> [1]
      #   1.snoc(2.snoc)      #=> [2, 1]
      #   1.snoc([0, 0, 0])   #=> [0, 0, 0, 1]
      #
      # @return [Array]
      def snoc(array = [])
        array + [self]
      end

      # @group Combinators
      #############################################################################

      # Yields `self` to a block argument
      #
      # @example
      #   nil.bind{|a| a.nil? }   #=> true
      #   100.bind{|a| a.nil? }   #=> false
      #
      def bind
        yield self
      end

      # Yields `self` to a side-effect block argument and return `self`
      #
      # @example:
      #   100.tap{|a| puts "debug: #{a}" }   #=> 100
      #
      # @return self
      def tap
        yield self
        self
      end unless nil.respond_to?(:tap)

      # @endgroup
      #############################################################################

      # Return the "eigenclass" where singleton methods reside
      #
      # @return [Class]
      def eigenclass
        class << self; self; end
      end
    end

# lib/ruby/string.rb
    class String
      # Return the one-character string at the given index
      #
      # @example
      #   "abc".at(0)   #=> "a"
      #   "abc".at(2)   #=> "c"
      #
      # @param [Integer] n zero-based index of the character to read
      #
      # @return [String]
      def at(n)
        raise ArgumentError, "n must be positive" if n < 0
        self[n, 1] unless n >= length
      end

      # Return the string with `n` characters removed from the front
      #
      # @example
      #   "abc".drop(0)   #=> "abc"
      #   "abc".drop(2)   #=> "c"
      #
      # @param [Integer] n number of characters to drop (`n > 0`)
      #
      # @return [String]
      def drop(n)
        raise ArgumentError, "n must be positive" if n < 0
        (length >= n) ? self[n..-1] : ""
      end

      # Return the first `n` characters from the front
      #
      # @example
      #   "abc".take(0)   #=> ""
      #   "abc".take(2)   #=> "ab"
      #
      # @param [Integer] n number of characters to select (`n > 0`)
      #
      # @return [String]
      def take(n)
        raise ArgumentError, "n must be positive" if n < 0
        self[0, n]
      end

      # Split the string in two at the given position
      #
      # @example
      #   "abc".split_at(0)   #=> ["", "abc"]
      #   "abc".split_at(2)   #=> ["ab", "c"]
      #
      # @param [Integer] n number of characters at which to split (`n > 0`)
      #
      # @return [Array(String, String)]
      def split_at(n)
        [take(n), drop(n)]
      end

      # True if the string is long enough such that {#at} is defined for the
      # given `n`
      #
      # @example
      #   "abc".defined_at?(0)  #=> true
      #   "abc".defined_at?(3)  #=> false
      def defined_at?(n)
        n < length
      end

      # To make String compatible with the {Stupidedi::Reader::Input} interface,
      # we have to define `#position`... shameful!
      def position
        nil
      end
    end

# lib/ruby/symbol.rb
    class Symbol
      # Returns a proc that calls self on the proc's parameter
      #
      # @example
      #   [1, 2, 3].map(&:-@)       #=> [-1, -2, -3]
      #   [-1, -2, -3].map(&:abs)   #=> [1, 2, 3]
      #
      def to_proc
        lambda{|*args| args.head.__send__(self, *args.tail) }
      end

      # Calls self on the given receiver
      #
      # @example
      #   :to_s.call(100)           #=> "100"
      #   :join.call([1,2,3], "-")  #=> "1-2-3"
      #
      def call(receiver, *args)
        receiver.__send__(self, *args)
      end
    end

# lib/ruby/to_d.rb
    class BigDecimal
      # @return [BigDecimal] self
      def to_d
        self
      end
    end

    class String
      BIGDECIMAL = /\A[+-]?            (?# optional leading sign            )
                    (?:
                      (?:\d+\.?\d*)  | (?# whole with optional decimal or ..)
                      (?:\d*?\.?\d+) ) (?# optional whole with decimal      )
                    (?:E[+-]?\d+)?     (?# optional exponent                )
                   \Z/ix

      # Converts the string to a BigDecimal after validating the format. If the
      # string does not match the pattern for a valid number, an `ArgumentError`
      # is raised.
      #
      # @example
      #   "1.0".to_d  #=> BigDecimal("1.0")
      #
      # @return [BigDecimal]
      def to_d
        if BIGDECIMAL =~ self
          BigDecimal(to_s)
        else
          raise ArgumentError, "#{inspect} is not a valid number"
        end
      end
    end

    class Integer
      # Converts the integer to a BigDecimal
      #
      # @example
      #   10.to_d   #=> BigDecimal("10")
      #
      # @return [BigDecimal]
      def to_d
        BigDecimal(to_s)
      end
    end

    class Rational
      # Converts the rational to a BigDecimal
      #
      # @example
      #   Rational(3, 4).to_d   #=> BigDecimal("3") / BigDecimal("4")
      #
      # @return [BigDecimal]
      def to_d
        numerator.to_d / denominator.to_d
      end
    end

    class Float
      # Raises a `TypeError` exception. The reason this method is defined at
      # all is to produce a more meaningful error than `NoSuchMethod`.
      #
      # @return [void]
      def to_d
        # The problem is there isn't a way to know the correct precision,
        # since there are (many) values that cannot be represented exactly
        # using Floats. For instance, we can't assume which value is correct
        #
        #   "%0.10f" % 1.8 #=> "1.8000000000"
        #   "%0.20f" % 1.8 #=> "1.80000000000000004441"
        #
        # The programmer should convert the Float to a String using whatever
        # precision he chooses, and call #to_d on the String.
        raise TypeError, "cannot convert Float to BigDecimal"
      end
    end

# lib/ruby/to_date.rb
    class Time
      def to_date
        Date.civil(year, month, day)
      end
    end

    class String
      def to_date
        Date.parse(self)
      end
    end

    class Date
      def to_date
        self
      end
    end

# lib/ruby/to_time.rb
    class Time
      # @return [Time]
      def to_time
        self
      end
    end

    class << Time
      public :parse
    end

    class String
      def to_time
        Time.parse(self)
      end
    end

# lib/ruby/try.rb
    class Object
      # @group Combinators
      #############################################################################

      # Sends the arguments to `self` or yields `self` (when `self` is non-`nil`).
      # This is overridden by {NilClass#try}, which always returns `nil`.
      #
      # @example
      #   "non-nil".try(&:length)       #=> 7
      #   nil.try(&:length)             #=> nil
      #
      #   "non-nil".try(:slice, 0, 3)   #=> "non"
      #   nil.try(:slice, 0, 3)         #=> nil
      #
      def try(*args, &block)
        if args.empty?
          yield self
        else
          __send__(*args, &block)
        end
      end
    end

    class NilClass
      # @group Combinators
      #############################################################################

      # Returns `nil` (when `self` is `nil`). This overrides {Object#try}
      #
      # @example
      #   "non-nil".try(&:length) #=> 7
      #   nil.try(&:length)       #=> nil
      #
      #   "non-nil".try(:slice, 0, 3)   #=> "non"
      #   nil.try(:slice, 0, 3)         #=> nil
      #
      # @return nil
      def try(*args)
        self
      end
    end
