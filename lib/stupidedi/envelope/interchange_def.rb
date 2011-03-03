module Stupidedi
  module Schema

    class InterchangeDef
      # @return [String]
      attr_reader :id

      # @return [Array<SegmentUse>]
      attr_reader :segment_uses

      def initialize(id, segment_uses)
        @id, @segment_uses = id, segment_uses
      end

      def copy(changes = {})
        self.class.new \
          changes.fetch(:id, @id),
          changes.fetch(:segment_uses, @segment_uses)
      end

      # @return [InterchangeVal]
      def value(segment_vals, functional_group_vals)
        InterchangeVal.new(self, segment_vals, functional_group_vals)
      end

      # @return [InterchangeVal]
      def empty
        InterchangeVal.new(self, [], [])
      end

      abstract :reader, :args => %w(input context)
    end

  end
end
