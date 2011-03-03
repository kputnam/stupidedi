module Stupidedi
  module Builder

    class AbstractState

      # @return [AbstractState]
      abstract :predecessor

      # @return [Boolean]
      abstract :stuck?

    private

      # @return [Envelope::Router]
      def router
        predecessor.router
      end

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
        segment = segment_use.definition.empty

        if elements.length < segment.definition.element_uses.length
          segment.definition.element_uses.zip(elements) do |use, value|
            segment = segment.append(use.definition.value(value))
          end
        else
          elements.zip(segment.definition.element_uses) do |value, use|
            segment = segment.append(use.definition.value(value))
          end
        end

        segment
      end

    end

  end
end
