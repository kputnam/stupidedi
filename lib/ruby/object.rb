# frozen_string_literal: true
module Stupidedi
  module Refinements

    refine Object do
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

  end
end
