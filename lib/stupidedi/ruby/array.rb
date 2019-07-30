# frozen_string_literal: true
module Stupidedi
  module Refinements
    refine Array do
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
        raise IndexError, "head of empty array" if empty?
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
      #   "yabba".split(//).group_seq(&:==) #=> [["y"], ["a"], ["b", "b"], ["a"]]
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
  end
end
