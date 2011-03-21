module Stupidedi
  module Reader

    class SegmentDict
      include Inspect

      # Return the top element from the stack. This will throw an exception
      # if the stack is {#empty?}
      abstract :top

      # Return the remainder of the stack. This will throw an exception if
      # the stack is {#empty?}
      #
      # @return [SegmentDict]
      abstract :pop

      # Returns a new SegmentDict with +top+ pushed to the top of the stack
      #
      # @return [SegmentDict]
      abstract :push, :args => %w(top)

      # Searches the stack for the definition of the given segment identifier
      abstract :at, :args => %w(segment_id)

      # Returns true if a node in the stack has a definition for the given
      # segment identifier
      abstract :defined_at?, :args => %w(segment_id)

      # True if the stack of dictionaries is empty
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
          if top.is_a?(Module)
            copy(:top => Constants.new(top), :pop => self)
          else
            copy(:top => top, :pop => self)
          end
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

        # @return [void]
        def pretty_print(q)
          q.text "SegmentDict"
          q.group(2, "(", ")") do
            q.breakable ""

            node = self
            until node.empty?
              unless q.current_group.first?
                q.text ","
                q.breakable
              end
              q.pp node.top
              node = node.pop
            end
          end
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
          if top.is_a?(Module)
            NonEmpty.new(Constants.new(top), self)
          else
            NonEmpty.new(top, self)
          end
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

        # @return [void]
        def pretty_print(q)
          q.text "SegmentDict.empty"
        end
      end.new

      class Constants
        def initialize(namespace)
          @namespace = namespace
          @constants = Hash.new
          namespace.constants.each{|c| @constants[c.to_sym] = true }
        end

        def at(segment_id)
          @namespace.const_get(segment_id)
        end

        def defined_at?(segment_id)
          @constants.include?(segment_id.to_sym)
        end

        # @return [void]
        def pretty_print(q)
          q.text("#{@namespace.name}.constants")
        end
      end
    end

    class << SegmentDict
      def empty
        SegmentDict::Empty
      end

      def build(top)
        SegmentDict::Empty.push(top)
      end
    end

    SegmentDict.eigenclass.send(:protected, :new)
    SegmentDict::NonEmpty.eigenclass.send(:public, :new)

  end
end
