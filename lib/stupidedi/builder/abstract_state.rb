module Stupidedi
  module Builder

    class AbstractState

      # @return [AbstractState]
      abstract :predecessor

      # @return [InterchangeVal, FunctionalGroupVal, TransactionSetVal, TableVal, LoopVal, SegmentVal]
      abstract :value

      # @return [Array<AbstractState>]
      abstract :segment, :args => %w(segment_tok)

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

      def match?(segment_use, segment_tok)
        unless segment_tok.id == segment_use.definition.id
          return false
        end

        # @todo: We're assuming that if the segment identifier matches,
        # someone has ensured the elements are valid: that we didn't get a
        # composite or repeated element in violation of the SegmentDef. The
        # TokenReader will simply bulldoze over those delimiters, and whatever 
        # other API we will implement to generate tokens from Ruby will also
        # need to catch these errors.
        element_toks = segment_tok.element_toks

        segment_use.definition.element_uses.zip(element_toks).all? do |u, e|
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
          elsif u.repeat_count.include?(2) or e.repeated?
            # @todo: Not sure what to do with repeatable elements
            true
          elsif u.composite?
            u.definition.element_uses.zip(e.component_toks).all? do |c, e|
              if c.requirement.required? and not e.blank?
                c.allowed_values.include?(e.value)
              else
                true
              end
            end
          else
            if u.requirement.required? and not e.blank?
              u.allowed_values.include?(e.value)
            else
              true
            end
          end
        end
      end

      # @return [SegmentVal]
      def mksegment(segment_use, segment_tok, parent = nil)
        segment_def  = segment_use.definition
        element_uses = segment_def.element_uses
        element_toks = segment_tok.element_toks

        # @todo: Check for too many values
        element_vals = element_uses.zip(element_toks).map do |element_use, e|
          mkelement(element_use, e)
        end

        segment_use.value(element_vals, parent)
      end

      # @return [SimpleElementVal, CompositeElementVal]
      def mkelement(element_use, element_tok, parent = nil)
        if element_use.simple?
          if element_tok.nil?
            element_use.empty(parent)
          elsif element_tok.simple?
            element_use.value(element_tok.value, parent)
          else
            # @todo: This is a syntax error. The tokenizer won't have caused
            # this because it should have all the SegmentDefs and know which
            # elements are composite or simple.
            element_use.empty(parent)
          end
        else
          if element_tok.nil?
            element_use.empty(parent)
          else
            component_uses = element_use.definition.element_uses
            component_vals = component_uses.zip(element_tok.component_toks)
            component_vals.map! do |component_use, component_tok|
              if component_tok.nil?
                component_use.empty
              else
                component_use.value(component_tok.value)
              end
            end

            element_use.value(component_vals, parent)
          end
        end
      end

    end

  end
end
