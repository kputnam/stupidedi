module Stupidedi
  module Envelope

    class Transmission

      # @return [Array<InterchangeVal>]
      attr_reader :children

      def initialize(children)
        @children = children
      end

      def copy(changes = {})
        Transmission.new(changes.fetch(:children, @children))
      end

      def leaf?
        false
      end
    end

  end
end
