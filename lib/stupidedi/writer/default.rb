module Stupidedi
  module Writer

    class Default

      # @return [Reader::Separators]
      attr_reader :separators

      def initialize(machine, separators = nil)
        @machine, @separators =
          machine, separators

        unless @machine.deterministic?
          raise Exceptions::OutputError,
            "cannot write non-deterministic parse tree"
        end

        if @separators.present?
          @machine.zipper.tap do |zipper|
            common  = @separators & zipper.node.characters
            message = common.to_a.map(&:inspect).join(", ")

            if common.present?
              raise Exceptions::OutputError,
                "separators #{message} occur as data"
            end
          end
        end
      end

      def write(out = "")
        recurse(@zipper.node, @separators, out)
      end

    private

      def recurse(value, separators, out)
        if value.segment?
          build(value, separators, out)
        else
          if value.interchange? and @separators.nil?
            separators = value.separators
          end

          value.children.each{|c| recurse(c, separators, out) }
        end
      end

      def build(segment, separators, out)
        out << segment.id.to_s

        # Trailing empty elements can be omitted, so "NM1*XX******~" should
        # be abbreviated to "NM1*XX~". The same idea applies to composite
        # elements, where "HI*BK:10101::::*BK:20202::::~" should be abbreviated 
        # to "HI*BK:10101*BK:20202"
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

          out << separators.segment
        end

        separators
      end

    end

  end
end
