# encoding: UTF-8

module Stupidedi
  module Sets

    #
    # This data type encodes a set of unique values that belong to an _infinite_
    # universe of possible values. Set operations generally perform worse than
    # {AbsoluteSet}, as they operate on {Hash} values and require iterating the
    # underlying {Hash} of at least one of the two sets in `O(n)` time.
    #
    # This is suitable for sets that don't have an inherently restricted universe
    # of allowed values (eg sets of arbitrary {String} values), including those
    # where the universe is significantly large compared to the typical size of
    # sets built from those values. {RelativeSet} also requires only a single
    # step to execute {#include?}, while {AbsoluteSet} requires two.
    #
    class RelativeSet < AbstractSet
      include Enumerable

      def initialize(hash)
        @hash = hash
      end

      # @return [void]
      def inspect
        "RelativeSet(#{to_a.join(', ')})"
      end

      # @return [void]
      def each
        @hash.keys.each{|o| yield o }
      end

      # @return [Array]
      def to_a
        @hash.keys
      end

      def include?(object)
        @hash.include?(object)
      end

      # @return true
      def finite?
        true
      end

      def first
        @hash.at(@hash.keys.first)
      end

      # @return [AbstractSet]
      def replace(other)
        Sets.build(other)
      end

      # @return [Integer]
      def size
        @hash.size
      end

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

      # @return [RelativeComplement]
      def complement
        RelativeComplement.new(self)
      end

      # @return [AbstractSet]
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

      # @return [AbstractSet]
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

      # @return [AbstractSet]
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

      # @return [AbstractSet]
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

      # @endgroup
      #########################################################################

      # @group Set Ordering
      #########################################################################

      # @return [Boolean]
      def ==(other)
        eql?(other) or
          (other.is_a?(Enumerable) and
           @hash.keys == other.to_a)
      end

      # @endgroup
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
    end

    class << RelativeSet
      # @group Constructor Methods
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
