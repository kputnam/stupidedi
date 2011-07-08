module Stupidedi
  module Writer

    class Default

      # @return [Reader::Separators]
      attr_reader :separators

      def initialize(zipper, separators)
        @zipper, @separators =
          zipper, separators

        raise Exceptions::OutputError,
          "separators.segment cannot be blank" if separators.segment.blank?

        raise Exceptions::OutputError,
          "separators.element cannot be blank" if separators.element.blank?
      end

      #
      # @return out
      def write(out = "")
        common  = @separators.characters & @zipper.node.characters
        message = common.to_a.map(&:inspect).join(", ")

        if common.present?
          raise Exceptions::OutputError,
            "separators #{message} occur as data"
        end

        recurse(@zipper.node, @separators, out)
        return out
      end

    private

      def recurse(value, separators, out)
        return if value.invalid?

        if value.segment?
          build(value, separators, out)
        else
          if value.interchange?
            separators = @separators.merge(value.separators)

            unless separators == @separators
              # We've inherited some separators from the interchange,
              # so we need to re-check this condition. Note that we
              # can't optimize this by caching @zipper.node.characters
              # the first time (in #write), because we're only interested
              # in conflicts between _this_ subtree (value) and the
              # separators... not the entire tree (@zipper.node)
              common  = separators.characters & @zipper.node.characters
              message = common.to_a.map(&:inspect).join(", ")

              if common.present?
                raise Exceptions::OutputError,
                  "separator characters #{message} occur as data"
              end
            end
          end

          value.children.each{|c| recurse(c, separators, out) }
        end
      end

      def build(segment, separators, out)
        out << segment.id.to_s

        # Trailing empty elements (including component elements) can be omitted,
        # so "NM1*XX*1:2::::*****~" should be abbreviated to "NM1*XX*1:2~".
        elements = segment.children.
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

        end

        out << separators.segment
      end

    end

  end
end
