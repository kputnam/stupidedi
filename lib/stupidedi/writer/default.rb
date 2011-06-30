module Stupidedi
  module Writer

    class Default

      # @return [Reader::Separators]
      attr_reader :separators

      def initialize(zipper, separators = nil)
        @zipper, @separators =
          zipper, separators
      end

      def write(out = "")
        recurse(@zipper, @separators, out)
      end

    private

      def build(zipper, separators, out)
        segment_val = zipper.node

        # When we don't have an override for the set of separators, they should
        # be picked up from the ISA segment.
        if @separators.blank? and segment_val.definition.id == :ISA
          separators = zipper.up.node.separators
        end

        out << segment_val.id.to_s

        # Trailing empty elements can be omitted, so "NM1*XX******~" should
        # be abbreviated to "NM1*XX~". The same idea applies to composite
        # elements, where "HI*BK:10101::::*BK:20202::::~" should be abbreviated 
        # to "HI*BK:10101*BK:20202"
        elements = segment_val.children.
          reverse.drop_while(&:empty?).reverse  # Remove the trailing empties

        elements.each do |e|
          out << separators.element

          if e.simple?
            out << e.to_x12

          elsif e.composite?
            components = e.children.
              reverse.drop_while(&:empty?).reverse

            unless components.empty?
              out << components.head.to_x12
            end

            components.tail.each do |c|
              out << separators.component
              out << c.to_x12
            end

          elsif e.repeated?
            occurrences = e.children.
              reverse.drop_while(&:empty?).reverse

            unless occurrences.empty?
              out << occurences.head.to_x12
            end

            occurences.tail.each do |o|
              out << separators.repetition
              out << o.to_x12
            end
          end

          out << separators.segment
        end

        separators
      end

    end

  end
end
