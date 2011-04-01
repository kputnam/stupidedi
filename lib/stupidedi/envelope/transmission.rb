module Stupidedi
  module Envelope

    class Transmission < Values::AbstractVal
      include Color

      # @return [Array<InterchangeVal>]
      attr_reader :children

      def initialize(children = [])
        @children = children
      end

      def copy(changes = {})
        Transmission.new(changes.fetch(:children, @children))
      end

      def leaf?
        false
      end

      # @return [Boolean]
      def ==(other)
        eql?(other) or other.children == @children
      end

      # @return [void]
      def pretty_print(q)
        q.text(ansi.envelope("Transmission"))
        q.group(2, "(", ")") do
          q.breakable ""
          @children.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end
        end
      end

      # @return [String]
      def inspect
        ansi.envelope("Transmission") << "(#{@children.map(&:inspect).join(', ')})"
      end
    end

  end
end
