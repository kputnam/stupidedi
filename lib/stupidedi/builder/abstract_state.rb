module Stupidedi
  module Builder

    class AbstractState

      # @return [AbstractState]
      abstract :predecessor

      # @return [InterchangeVal, FunctionalGroupVal, TransactionSetVal, TableVal, LoopVal, SegmentVal]
      abstract :value

      # @return [Array<AbstractState>]
      abstract :segment, :args => %w(name values)

      # @return [Boolean]
      def stuck?
        false
      end

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
        FailureState.new(explanation, self).cons
      end

      # @return [SegmentVal]
      def mksegment(segment_use, values, parent = nil)
        segment_def  = segment_use.definition
        segment_val  = segment_use.empty(parent)
        element_uses = segment_def.element_uses

        # @todo: Check for too many values
        element_vals = element_uses.zip(values).map do |use, value|
          mkelement(use, value)
        end

        segment_val.copy(:element_vals => element_vals)
      end

      # @return [SimpleElementVal, CompositeElementVal]
      def mkelement(use, values, parent = nil)
        if use.simple?
          use.value(values, parent)
        else
          composite_val  = use.empty(parent)
          component_uses = use.definition.element_uses

          component_vals = component_uses.zip(values || []).map do |use, value|
            use.value(value, composite_val)
          end

          composite_val.copy(:component_element_vals => component_vals)
        end
      end

    end

  end
end
