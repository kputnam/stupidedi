module Stupidedi
  module FiftyTen
    module Base

      class SegmentUse
        attr_reader \
          :offset,
          :segment_def,
          :requirement_designator,
          :repetition_count

        def initialize(offset, segment_def, requirement_designator, repetition_count)
          @offset, @segment_def, @requirement_designator, @repetition_count = offset, segment_def, requirement_designator, repetition_count
        end
      end

    end
  end
end
