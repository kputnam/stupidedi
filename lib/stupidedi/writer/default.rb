# frozen_string_literal: true
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
          segment(value, separators, out)
        else
          if value.interchange?
            value      = value.replace_separators(@separators)
            separators = value.separators#merge(@separators)

            raise Exceptions::OutputError,
              "separators.segment cannot be blank" if separators.segment.blank?

            raise Exceptions::OutputError,
              "separators.element cannot be blank" if separators.element.blank?

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

      def segment(s, separators, out)
        # It's likely annoying for the user to need to check for at least
        # one non-blank element before generating a segment. Instead, we
        # can check that after the segment was generated and supress any
        # empty segments here.
        return if s.empty?

        out = out + s.id.to_s

        # Trailing empty elements (including component elements) can be omitted,
        # so "NM1*XX*1:2::::*****~" should be abbreviated to "NM1*XX*1:2~".
        elements = s.children.
          reverse.drop_while(&:empty?).reverse  # Remove the trailing empties

        elements.each do |e|
          out = out + separators.element
          element(e, separators, out)
        end

        out = out + separators.segment
      end

      def element(e, separators, out)
        if e.simple?
          out = out + e.to_x12

        elsif e.composite?
          components = e.children.
            reverse.drop_while(&:empty?).reverse

          unless components.empty?
            out = out + components.head.to_x12
          end

          components.tail.each do |c|
            out = out + separators.component
            out = out + c.to_x12
          end

        elsif e.repeated?
          occurrences = e.children.
            reverse.drop_while(&:empty?).reverse

          unless occurrences.empty?
            element(occurrences.head, separators, out)
          end

          occurrences.tail.each do |o|
            out = out + separators.repetition
            element(o, separators, out)
          end
        end
      end

    end

  end
end
