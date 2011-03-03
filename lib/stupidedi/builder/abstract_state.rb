module Stupidedi
  module Builder

    class AbstractState

      # @return [AbstractState]
      abstract :predecessor

      # @return [InterchangeVal, FunctionalGroupVal, TransactionSetVal, TableVal, LoopVal, SegmentVal]
      abstract :value

      # @return [Boolean]
      abstract :stuck?

      # @return [Envelope::Router]
      def router
        predecessor.router
      end

    private

      # @return [Array<AbstractState>]
      def branches(successors)
        if successors.is_a?(Array)
          successors
        else
          Array[successors]
        end
      end

      # @return [Array<AbstractState>]
      def step(successor)
        Array[successor]
      end

      # @return [Array<FailureState>]
      def failure(explanation)
        FailureState.new(explanation).cons
      end

      # @return [SegmentVal]
      def construct(segment_use, elements)
        segment_def = segment_use.definition
        segment_val = segment_use.definition.empty

        if elements.length < segment_def.element_uses.length
          segment_def.element_uses.zip(elements) do |use, value|
            segment_val = segment_val.append(use.definition.value(value))
          end
        else
          elements.zip(segment_def.element_uses) do |value, use|
            segment_val = segment_val.append(use.definition.value(value))
          end
        end

        segment_val
      end

    end

  end
end
