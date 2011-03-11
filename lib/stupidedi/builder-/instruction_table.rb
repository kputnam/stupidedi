module Stupidedi
  module Builder_

    #
    #
    #
    class InstructionTable

      def initialize(instructions)
      end

      # @return [InstructionTable]
      def copy(changes = {})
      end

      # @return [InstructionTable]
      def push(instructions)
        # Because we're adding successor states, we need to recompute all the
        # segment constraints where there are more than one instruction for a
        # given segment identifier. This minimizes non-determinism, but can be
        # relatively expensive to calculate.
      end

      # @return [InstructionTable]
      def drop(count)
        if count.zero?
          self
        else
          copy(:instructions => @instructions.drop(count))
        end
      end

      # @private
      def pretty_print(q)
      end
    end

  end
end
