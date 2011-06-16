# encoding: UTF-8

module Stupidedi
  module Sets

    #
    # This data type encodes a set of unique values that belong to an _infinite_
    # universe of possible values (aka domain). Set operations generally perform
    # worse than {AbsoluteSet}, as they operate on {Hash} values and require
    # iterating the underlying {Hash} of at least one of the two sets in `O(n)`
    # time.
    #
    # This is suitable for sets that don't have an inherently restricted domain
    # (eg sets of arbitrary {String} values), including those where the domain
    # is significantly large compared to the typical size of sets built from
    # those values. {RelativeSet} also requires only a single step to execute
    # {#include?}, while {AbsoluteSet} requires two.
    #
    class RelativeSet < AbstractSet
      include Enumerable

      def initialize(hash)
        @hash = hash
      end

      # Yields each element in the set to the implicit block argument.
      #
      # @return [void]
      def each
        @hash.keys.each{|o| yield o }
      end

      # Returns an {Array} containing each element in this set
      #
      # @return [Array]
      def to_a
        @hash.keys
      end

      # (see AbstractSet#include?)
      def include?(object)
        @hash.include?(object)
      end

      # (see AbstractSet#finite?)
      #
      # @return true
      def finite?
        true
      end

      # Returns a single element from the set, with no guarantees about which
      # element. If the set is {#empty?}, the return value is undefined.
      def first
        @hash.keys.first
      end

      # (see AbstractSet#replace)
      def replace(other)
        Sets.build(other)
      end

      # (see AbstractSet#size)
      def size
        @hash.size
      end

      # (see AbstractSet#empty?)
      def empty?
        @hash.empty?
      end

      # @group Set Operations
      #########################################################################

      # @return [RelativeSet]
      def map
        RelativeSet.new(@hash.keys.inject({}) do |hash, key|
          hash[yield(key)] = true
          hash
        end)
      end

      # @return [RelativeSet]
      def select
        RelativeSet.new(@hash.clone.delete_if{|o,_| not yield(o) })
      end

      # @return [RelativeSet]
      def reject
        RelativeSet.new(@hash.clone.delete_if{|o,_| yield(o) })
      end

      # (see AbstractSet#complement)
      # @return [RelativeComplement]
      def complement
        RelativeComplement.new(self)
      end

      # (see AbstractSet#intersection)
      def intersection(other)
        if other.is_a?(RelativeComplement)
          # A ∩ ¬B = ¬B ∩ A
          other.intersection(self)
        elsif other.is_a?(AbstractSet)
          if other.is_a?(RelativeSet) and size > other.size
            # For efficiency, iterate the smaller of the two sets: A ∩ B = B ∩ A
            other.intersection(self)
          elsif other.empty?
            # A ∩ ∅ = ∅
            NullSet.build
          else
            hash = @hash.clone.delete_if{|o,_| not other.include?(o) }

            if hash.empty?
              NullSet.build
            else
              RelativeSet.new(hash)
            end
          end
        else
          intersection(Sets.build(other))
        end
      end

      # (see AbstractSet#intersection)
      def union(other)
        if other.is_a?(RelativeComplement)
          # A ∪ ¬B = ¬B ∪ A
          other.union(self)
        elsif other.is_a?(AbstractSet)
          unless other.is_a?(RelativeSet) and size < other.size
            hash = other.inject(@hash.clone){|h,o| h[o] = true; h }

            if hash.empty?
              NullSet.build
            else
              RelativeSet.new(hash)
            end
          else
            # For efficiency, iterate the smaller of the two sets: A ∪ B = B ∪ A
            if other.empty?
              self
            else
              other.union(self)
            end
          end
        else
          union(Sets.build(other))
        end
      end

      # (see AbstractSet#difference)
      def difference(other)
        if other.is_a?(RelativeComplement)
          # A ∖ ¬B = A ∩ B
          intersection(other.complement)
        elsif other.is_a?(AbstractSet)
          if other.empty?
            self
          else
            # A ∖ B = A ∩ ¬B
            hash = @hash.clone.delete_if{|o,_| other.include?(o) }

            if hash.empty?
              NullSet.build
            else
              RelativeSet.new(hash)
            end
          end
        else
          difference(Sets.build(other))
        end
      end

      # (see AbstractSet#symmetric_difference)
      def symmetric_difference(other)
        if other.is_a?(RelativeComplement)
          # A ⊖ ~B = (A ∖ ¬B) | (¬B ∖ A)
          #        = (A ∩ B)  | (¬B ∩ ¬A)
          #        = (B ∖ ¬A) | (¬A ∖ B)
          #        = ~A ⊖ B
          intersection(other.complement).
            union(other.intersection(complement))
        else
          # A ⊖ B = (A ∖ B) | (B ∖ A)
          #       = (A ∪ B) - (A ∩ B)
          other = Sets.build(other)

          if other.empty?
            self
          else
            union(other).difference(intersection(other))
          end
        end
      end

      # @group Set Ordering
      #########################################################################

      # (see AbstractSet#==)
      def ==(other)
        eql?(other) or
          (other.is_a?(Enumerable) and
           @hash.keys == other.to_a)
      end

      # @group Pretty Printing
      #########################################################################

      # @return [void]
      def pretty_print(q)
        q.text("RelativeSet[#{size}]")
        q.group(2, "(", ")") do
          q.breakable ""

          elements = to_a
          elements.take(5).each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end

          if elements.length > 5
            q.text ","
            q.breakable
            q.text "..."
          end
        end
      end

      # @return [String]
      def inspect
        "RelativeSet(#{to_a.map(&:inspect).join(', ')})"
      end

      # @endgroup
      #########################################################################
    end

    class << RelativeSet
      # @group Constructors
      #########################################################################

      # @return [RelativeSet]
      def build(object)
        if object.is_a?(RelativeSet)
          object
        elsif object.is_a?(Enumerable)
          if object.empty?
            NullSet.build
          elsif object.is_a?(Hash)
            new(object)
          else
            new(object.inject({}){|h,o| h[o] = true; h })
          end
        else
          raise TypeError
        end
      end

      # @endgroup
      #########################################################################
    end

  end
end
