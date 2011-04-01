module Stupidedi
  module Zipper

    class SegmentCursor

      def initialize(zipper)
        @zipper = zipper
      end

      # @return [SegmentVal]
      def node
        @zipper.node
      end

      def next(segment_id, *elements)
      end

      def prev(segment_id, *elements)
      end

      # @return [SegmentCursor]
      def forward(count)
        zipper = @zipper

        until count.zero?
          zipper = zipper.up while not zipper.root? and zipper.last?
          break if zipper.root?
          zipper = zipper.next
          zipper = zipper.down until zipper.node.segment?
          count -= 1
        end

        unless count.zero?
          raise Exceptions::ZipperError,
            "Reached the end of the tree expecting #{count.abs} more segments"
        end

        SegmentCursor.new(zipper)
      end

      # @return [SegmentCursor]
      def backward(count)
        zipper = @zipper

        until count.zero?
          zipper = zipper.up while not zipper.root? and zipper.first?
          break if zipper.root?
          zipper = zipper.prev
          zipper = zipper.down.last until zipper.node.segment?
          count -= 1
        end

        unless count.zero?
          raise Exceptions::ZipperError,
            "Reached the start of the tree expecting #{count.abs} more segments"
        end

        SegmentCursor.new(zipper)
      end
    end

    class << SegmentCursor
      # @group Constructors
      #########################################################################

      # @return [SegmentCursor]
      def build(zipper)
        zipper = zipper.down until zipper.node.segment?
        new(zipper)
      end
    end

  end
end
