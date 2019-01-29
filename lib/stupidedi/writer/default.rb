module Stupidedi
  using Refinements

  module Writer
    class Default
      # @return [Reader::Separators]
      attr_reader :separators

      def initialize(zipper, separators = Reader::Separators.empty)
        @zipper, @separators =
          zipper, separators
      end

      # @return out
      def write(out = "")
        unless @zipper.node.transmission? or @zipper.node.interchange?
          common  = @separators.characters & @zipper.node.characters
          message = common.to_a.map(&:inspect).join(", ")

          if common.present?
            raise Exceptions::OutputError,
              "separator characters #{message} occur as data"
          end
        end

        recurse(@zipper.node, @separators, out)
      end

    private

      def recurse(value, separators, out)
        return if value.invalid?

        if value.segment?
          segment(value, separators, out)
        else
          if value.interchange?
            unless separators.merge(value.separators) == separators
              common  = separators.characters & value.characters
              message = common.to_a.map(&:inspect).join(", ")

              if common.present?
                raise Exceptions::OutputError,
                  "separator characters #{message} occur as data"
              end

              # Change ISA11 and ISA16
              value = value.replace_separators(separators)
            end

            separators = value.separators

            raise Exceptions::OutputError,
              "separators.segment cannot be blank" if separators.segment.blank?

            raise Exceptions::OutputError,
              "separators.element cannot be blank" if separators.element.blank?
          end

          value.children.each{|c| recurse(c, separators, out) }
        end
      end

      def segment(s, separators, out)
        # It's likely annoying for the user to need to check for at least
        # one non-blank element before generating a segment. Instead, we
        # can check that after the segment was generated and supress any
        # empty segments here.
        return if s.empty?

        out << s.id.to_s

        # Trailing empty elements (including component elements) can be omitted,
        # so "NM1*XX*1:2::::*****~" should be abbreviated to "NM1*XX*1:2~".
        elements = s.children.
          reverse.drop_while(&:empty?).reverse  # Remove the trailing empties

        elements.each do |e|
          out << separators.element
          element(e, separators, out)
        end

        out << separators.segment
      end

      def element(e, separators, out)
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
            element(occurrences.head, separators, out)
          end

          occurrences.tail.each do |o|
            out << separators.repetition
            element(o, separators, out)
          end
        end
      end
    end
  end
end
