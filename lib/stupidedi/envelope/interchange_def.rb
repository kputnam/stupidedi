module Stupidedi
  module Envelope

    class InterchangeDef
      # @return [String]
      attr_reader :id

      # @return [Array<SegmentUse>]
      attr_reader :header_segment_uses

      # @return [Array<SegmentUse>]
      attr_reader :footer_segment_uses

      # @return [InterchangeVal]
      abstract :empty

      # @return [InterchangeVal]
      abstract :value, :args => %w(header_segment_vals functional_group_vals trailer_segment_vals)

      def initialize(id, header_segment_uses, trailer_segment_uses)
        @id, @header_segment_uses, @trailer_segment_uses =
          id, header_segment_uses, trailer_segment_uses
      end

      def copy(changes = {})
        self.class.new \
          changes.fetch(:id, @id),
          changes.fetch(:header_segment_uses, @header_segment_uses),
          changes.fetch(:trailer_segment_uses, @trailer_segment_uses)
      end

      # @return [Array<SegmentUse>]
      def segment_uses
        @header_segment_uses + @trailer_segment_uses
      end
    end

  end
end
