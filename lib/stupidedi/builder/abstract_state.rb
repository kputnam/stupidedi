module Stupidedi
  module Builder

    class AbstractState

      # @return [AbstractState]
      abstract :predecessor

      # @return [InterchangeVal, FunctionalGroupVal, TransactionSetVal, TableVal, LoopVal, SegmentVal]
      abstract :value

      # @return [Array<AbstractState>]
      abstract :segment, :args => %w(name elements)

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
          # when the single element value we need to exampine valu`e isn't
          # present. Hopefully for now, the false positives get sorted out
          # by hitting a stuck state within a few more tokens.

          if e.blank?
            true
          elsif u.composite?
            tag, *components = e

            if tag != :composite
              raise "@todo: expected composite element but got #{e.inspect}"
            end

            if u.repeat_count.include?(2) or components.blank?
              # @todo: Not sure what to do with repeatable composite elements
              true
            else
              if components.head == :repeat
                raise "@todo: unexpected repeated element"
              end

              u.definition.element_uses.zip(components).all? do |c, e|
                tag, component = e

                if tag != :simple
                  raise "@todo: expected component element but got #{e.inspect}"
                end

                if c.requirement.required? and not e.blank?
                  c.allowed_values.include?(component)
                else
                  true
                end
              end
            end
          else
            tag, value = e

            if tag != :simple
              raise "@todo: expected simple element but got #{e.inspect}"
            end

            if u.requirement.required? and not value.blank?
              u.allowed_values.include?(value)
            else
              true
            end
          end
        end
      end

      # @return [SegmentVal]
      def mksegment(segment_use, elements, parent = nil)
        segment_def  = segment_use.definition
        segment_val  = segment_use.empty(parent)
        element_uses = segment_def.element_uses

        # @todo: Check for too many values
        element_vals = element_uses.zip(elements).map do |use, value|
          mkelement(use, value)
        end

        segment_val.copy(:element_vals => element_vals)
      end

      # @return [SimpleElementVal, CompositeElementVal]
      def mkelement(use, element, parent = nil)
        if use.simple?
          tag, value = element

          unless tag == :simple or (tag.nil? and value.nil?)
            raise "@todo: expected simple element but got #{element.inspect}"
          end

          tag, repeats = value

          if tag == :repeat
            raise "@todo: repeated simple element"
          end

          use.value(value, parent)
        else
          tag, *components = element

          unless tag == :composite or (tag.nil? and components.blank?)
            raise "@todo: expected composite element but got #{element.inspect}"
          end

          composite_val  = use.empty(parent)
          component_uses = use.definition.element_uses

          component_vals = component_uses.zip(components || []).map do |use, c|
            tag, component = c

            unless tag == :simple or (tag.nil? and component.nil?)
              raise "@todo: expected component element but got #{c.inspect}"
            end

            tag, repeats = value

            if tag == :repeat
              raise "@todo: repeated composite element"
            end

            use.value(component, composite_val)
          end

          composite_val.copy(:component_element_vals => component_vals)
        end
      end

    end

  end
end
