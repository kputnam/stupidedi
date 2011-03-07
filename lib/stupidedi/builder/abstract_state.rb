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

      # @return [Configuration::RootConfig]
      def config
        predecessor.config
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
        successor.cons
      end

      # @return [Array<FailureState>]
      def failure(explanation)
        FailureState.new(explanation, self).cons
      end

      def match?(segment_use, name, elements)
        unless name == segment_use.definition.id
          return false
        end

        segment_use.definition.element_uses.zip(elements).all? do |u, e|
          # This is some rough logic, but basically we are using every
          # syntactically required element as a segment qualifier. This
          # isn't very efficient because in the context of the rest of
          # the grammar, we may not even need to look at the elements to
          # determine this -- or maybe we need only to look at one. That
          # knowledge would also prevent false matches, which can happen
          # when the single element value we need to exampine value isn't
          # present. Hopefully for now, the false positives get sorted out
          # by hitting a stuck state within a few more tokens.

          if u.composite?
            unless e.blank?
              u.definition.element_uses.zip(e).all? do |c, e|
                if c.requirement.required? and not e.blank?
                  c.allowed_values.include?(e)
                else
                  true
                end
              end
            else
              true
            end
          else
            if u.requirement.required? and not e.blank?
              u.allowed_values.include?(e)
            else
              true
            end
          end
        end
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
