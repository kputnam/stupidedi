# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Parser
    module Tokenization
      #########################################################################
      # @group Element Constructors

      # Generates a repeated element (simple or composite)
      #
      # @return [void]
      def repeated(*elements)
        [:repeated, elements, Reader::StacktracePosition.build]
      end

      # Generates a composite element
      #
      # @return [void]
      def composite(*components)
        [:composite, components, Reader::StacktracePosition.build]
      end

      #########################################################################
      # @group Element Placeholders

      # Generates a blank element
      #
      # @return [void]
      def blank
        [:blank, nil, Reader::StacktracePosition.build]
      end

      # Generates a blank element and asserts that the element's usage
      # requirement is `NOT USED`
      #
      # @see Schema::ElementReq#forbidden?
      #
      # @return [void]
      def not_used
        [:not_used, nil, Reader::StacktracePosition.build]
      end

      # Generates the only possible value an element may have, which may
      # be blank. An exception is thrown if the element's usage requirement
      # is optional, or if there are more than one allowed non-blank values.
      #
      # @see Schema::SimpleElementUse#allowed_values
      # @see Schema::ElementReq#forbidden?
      #
      # @return [void]
      def default
            [:default, nil, Reader::StacktracePosition.build]
      end

      # @endgroup
      #########################################################################

    private

      # @return [Reader::SegmentTok]
      def mksegment_tok(segment_dict, id, elements, position)
        id = id.to_sym
        element_toks = []

        unless segment_dict.defined_at?(id)
          element_idx  = "00"
          elements.each do |e_tag, e_val, e_position|
            element_idx = element_idx.succ

            # If the element is a regular Ruby value "ABC", the way this
            # proc's arguments are assigned would be e_tag = "ABC", and
            # e_val and e_position are nil. If the argument is a placeholder
            # like #blank, #not_used, or #default is used, those methods return
            # a triple that is deconstructed such that e_val is also nil.
            #
            # However, for #composite or #repeated, the triple is deconstructed
            # such that e_val is an Array of other values, and isn't #nil?
            unless e_val.nil?
              raise ArgumentError,
                "#{id}#{element_idx} is assumed to be a simple element"
            end

            element_toks << mksimple_tok(e_tag, e_position || position)
          end
        else
          segment_def  = segment_dict.at(id)
          element_uses = segment_def.element_uses

          if elements.length > element_uses.length
            raise ArgumentError,
              "#{id} segment has only #{element_uses.length} elements"
          end

          element_idx  = "00"
          elements.zip(element_uses) do |(e_tag, e_val, e_position), e_use|
            element_idx = element_idx.succ
            designator = "#{id}#{element_idx}"

            if e_use.repeatable?
              # Repeatable composite or non-composite
              unless [:repeated, :blank, :not_used, nil].include?(e_tag)
                raise ArgumentError,
                  "#{designator} is a repeatable element"
              end

              element_toks << mkrepeated_tok(e_val || [], e_use, designator, e_position || position)
            elsif e_use.composite?
              unless [:composite, :not_used, :blank, nil].include?(e_tag)
                raise ArgumentError,
                  "#{id}#{element_idx} is a non-repeatable composite element"
              end

              element_toks << mkcomposite_tok(e_val || [], e_use, designator, e_position || position)
            else
              # The actual value is in e_tag
              unless e_val.nil?
                raise ArgumentError,
                  "#{id}#{element_idx} is a non-repeatable simple element"
              end

              element_toks << mksimple_tok(e_tag, e_position || position)
            end
          end
        end

        Reader::SegmentTok.build(id, element_toks, position)
      end

      # @return [Reader::RepeatedElementTok]
      def mkrepeated_tok(elements, element_use, designator, position)
        element_toks = []

        if element_use.composite?
          elements.each do |e_tag, e_val, e_position|
            unless [:composite, :not_used, :blank, nil].include?(e_tag)
              raise ArgumentError,
                "#{designator} is a composite element"
            end

            element_toks << mkcomposite_tok(e_val || [], element_use, designator, e_position || position)
          end
        else
          elements.each do |e_tag, e_val, e_position|
            unless e_val.nil?
              raise ArgumentError,
                "#{designator} is a simple element"
            end

            element_toks << mksimple_tok(e_tag, e_position || position)
          end
        end

        Reader::RepeatedElementTok.build(element_toks, position)
      end

      # @return [Reader::CompositeElementTok]
      def mkcomposite_tok(components, composite_use, designator, position)
        component_uses = composite_use.definition.component_uses

        if components.length > component_uses.length
          raise ArgumentError,
            "#{designator} has only #{component_uses.length} components"
        end

        component_idx  = "0"
        component_toks = []
        component_uses.zip(components) do |c_use, (c_tag, c_val, c_position)|
          component_idx = component_idx.succ
          unless c_val.nil?
            raise ArgumentError,
              "#{designator}-#{component_idx} is a component element"
          end

          component_toks << mkcomponent_tok(c_tag, c_position || position)
        end

        Reader::CompositeElementTok.build(component_toks, position)
      end

      # @return [Reader::ComponentElementTok]
      def mkcomponent_tok(value, position)
        Reader::ComponentElementTok.build(value, position)
      end

      # @return [Reader::SimpleElementTok]
      def mksimple_tok(value, position)
        Reader::SimpleElementTok.build(value, position)
      end

      # @endgroup
      #########################################################################
    end
  end
end
