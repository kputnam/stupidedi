module Stupidedi
  module Builder

    class AbstractBuilder < (RUBY_VERSION <= "1.9" ? BlankSlate : BasicObject)
      abstract :inspect

      abstract :state

      abstract :header_segment_uses

      abstract :trailer_segment_uses

      abstract :child_segment_uses

      abstract :parent

      def construct(definition, elements)
        segment = definition.empty

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

      def branch(successors, elements)
      end

      def fail
      end

      def segment(name, *elements)
        # This segment may belong to the header
        uses = header_segment_uses.select do |u|
          @position <= u.position and u.definition.name == name
        end

        # .. or it may belong to the trailer
        uses = trailer_segment_uses.select do |u|
          @position <= u.position and u.definition.name == name
        end

        # ... or it may belong to a child
        uses = child_segment_uses.select do |u|
          @position <= u.position and u.definition.name == name
        end

        # ... or it may belong to the parent
        branch(header + footer + children, elements)
      end

    end

  end
end
