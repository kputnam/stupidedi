# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Values
    class InvalidEnvelopeVal < AbstractVal
      # @return [Array<SegmentVal>]
      attr_reader :children

      def_delegators "@children.head", :descriptor, :position, :reason

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
      # :nocov:
      def pretty_print(q)
        q.text(ansi.segment("InvalidEnvelopeVal"))
        q.group(2, "(", ")") do
          if @children.present?
            q.breakable ""
            q.text @children.first.reason
            q.text ","
          end
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
      # :nocov:

      # @return [String]
      def inspect
        ansi.invalid("InvalidEnvelopeVal") <<
          "(#{@children.map(&:inspect).join(", ")})"
      end
    end
  end
end
