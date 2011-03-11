module Stupidedi
  module Builder_

    class AbstractState

      # Each {AbstractState} subclass is responsible for building up a syntax
      # tree node from the {Values} or {Envelope} namespace.
      abstract :value

      # The {AbstractState} whose {value} is the parent of this state's {value}.
      abstract :parent

    end

    class << AbstractState

      # This method constructs a new instance of (a subclass of) {AbstractState}
      # and pushes it above {parent} onto a nested stack-like structure. The
      # stack structure is implicit, and it can be iterated by following each
      # state's {parent}.
      #
      # @return [AbstractState]
      abstract :push, :args => %w(segment_tok segment_use parent)

      # @return [SegmentVal]
      def segment(segment_tok, segment_use, parent = nil)
        segment_def  = segment_use.definition
        element_uses = segment_def.element_uses
        element_toks = segment_tok.element_toks

        element_vals = element_uses.zip(element_toks).map do |use, tok|
          if tok.nil?
            use.empty
          else
            element(use, tok)
          end
        end

        segment_use.value(element_vals, parent)
      end

    private

      # @return [SimpleElementVal, CompositeElementVal]
      def element(element_use, element_tok, parent = nil)
        if element_use.simple?
          simple_element(element_use, element_tok, parent)
        else
          composite_element(element_use, element_tok, parent)
        end
      end

      # @return [CompositeElementVal]
      def composite_element(composite_use, composite_tok, parent = nil)
        composite_def  = composite_use.definition
        component_uses = composite_def.component_uses
        component_toks = composite_tok.component_toks

        component_vals = component_uses.zip(component_toks).map do |use, tok|
          if tok.nil?
            use.empty
          else
            simple_element(use, tok)
          end
        end

        composite_use.value(component_vals, parent)
      end

      # @return [SimpleElementVal]
      def simple_element(element_use, element_tok, parent = nil)
        # We don't validate that element_tok is simple because the TokenReader
        # will always produce a SimpleElementTok given a SimpleElementUse from
        # the SegmentDef. On the other hand, the public builder API will throw
        # an exception if the programmer constructs the wrong kind of element
        # according to the SegmentDef.
        element_use.value(element_tok.value, parent)
      end
    end

  end
end
