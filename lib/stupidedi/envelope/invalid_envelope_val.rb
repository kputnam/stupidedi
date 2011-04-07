module Stupidedi
  module Envelope

    class InvalidEnvelopeVal < Values::AbstractVal

      # @return [Array<Values::SegmentVal>]
      attr_reader :children

      def initialize(children)
        @children = children
      end

      # @return [SegmentVal]
      def copy(changes = {})
        InvalidEnvelopeVal.new(changes.fetch(:children, @children))
      end

      # @return false
      def leaf?
        false
      end

      def empty?
        @children.all?(&:empty?)
      end

      # @return [void]
      def pretty_print(q)
        q.text(ansi.segment("InvalidEnvelopeVal"))
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
        ansi.invalid("InvalidEnvelope") <<
          "(#{@children.map(&:inspect).join(', ')})"
      end
    end

  end
end
