module Stupidedi
  using Refinements

  module Values

    class InvalidEnvelopeVal < AbstractVal

      # @return [Array<SegmentVal>]
      attr_reader :children

      def_delegators "@children.head", :position

      def initialize(children)
        @children = children
      end

      # @return [SegmentVal]
      def copy(changes = {})
        InvalidEnvelopeVal.new(changes.fetch(:children, @children))
      end

      # (see AbstractVal#size)
      def size
        0
      end

      # @return false
      def leaf?
        false
      end

      def valid?
        false
      end

      # @return [void]
      def pretty_print(q)
        q.text(ansi.segment("InvalidEnvelopeVal"))
        q.group(2, "(", ")") do
          q.breakable ""
          q.text @children.first.reason
          q.text ","
          q.breakable

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
        ansi.invalid("InvalidEnvelopeVal") <<
          "(#{@children.map(&:inspect).join(', ')})"
      end
    end

  end
end
