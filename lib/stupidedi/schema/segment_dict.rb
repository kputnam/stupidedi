module Stupidedi
  module Schema

    class SegmentDict
      # Return the top element from the stack. This will throw an exception
      # if the stack is {empty?}
      abstract :top

      # Return the remainder of the stack. This will throw an exception if
      # the stack is {empty?}
      #
      # @return [SegmentDict]
      abstract :pop

      # Returns a new SegmentDict with {top} pushed to the top of the stack
      #
      # @return [SegmentDict]
      abstract :push, :args => %w(top)

      # Returns a new stack where the elements in {other} follow all of
      # the elements in {self}
      #
      # @return [SegmentDict]
      abstract :concat, :args => %w(other)

      # Searches the stack for the definition of the given segment identifier
      abstract :at, :args => %w(segment_id)

      # Returns true if a node in the stack has a definition for the given
      # segment identifier
      abstract :defined_at?, :args => %w(segment_id)

      abstract :empty?

      class NonEmpty < SegmentDict
        attr_reader :top

        # @return [SegmentDict]
        attr_reader :pop

        def initialize(top, pop = SegmentDict.empty)
          @top, @pop = top, pop
        end

        # @return [SegmentDict]
        def copy(changes = {})
          self.class.new \
            changes.fetch(:top, @top),
            changes.fetch(:pop, @pop)
        end

        def push(top)
          copy(:top => top, :pop => self)
        end

        def concat(other)
          copy(:pop => @pop.concat(other))
        end

        def at(segment_id)
          if @top.defined_at?(segment_id)
            @top.at(segment_id)
          else
            @pop.at(segment_id)
          end
        end

        def defined_at?(segment_id)
          @top.defined_at?(segment_id) or
          @pop.defined_at?(segment_id)
        end

        def empty?
          false
        end

        def length
          1 + @pop.length
        end
      end

      # Singleton instance
      Empty = Class.new(SegmentDict) do
        def top
          raise TypeError, "empty stack"
        end

        def pop
          raise TypeError, "stack underflow"
        end

        def push(top)
          SegmentDict::NonEmpty.new(top, self)
        end

        def concat(other)
          other
        end

        def defined_at?(segment_id)
          false
        end

        def at(segment_id)
          raise TypeError, "empty stack"
        end

        def empty?
          true
        end

        def length
          0
        end
      end.new
    end

    class << SegmentDict
      def empty
        SegmentDict::Empty
      end

      def constants(namespace)
        top = Class.new do
          def initialize(namespace)
            @namespace = namespace
          end

          def at(segment_id)
            @namespace.const_get(segment_id)
          end

          def defined_at?(segment_id)
            @namespace.constants.any?{|c| c.to_s == segment_id.to_s }
          end
        end.new(namespace)

        SegmentDict::NonEmpty.new(top)
      end

      def build(top)
        case top
        when Module
          constants(top)
        else
          SegmentDict::NonEmpty.new(top)
        end
      end
    end

    SegmentDict.eigenclass.send(:protected, :new)
    SegmentDict::NonEmpty.eigenclass.send(:public, :new)

  end
end
