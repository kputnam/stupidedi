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
          @offset, @segment_def, @requirement_designator, @repetition_count =
            offset, segment_def, requirement_designator, repetition_count

          unless @offset.is_a?(Integer)
            raise TypeError, "First argument must be a kind of Integer"
          end

          unless @segment_def.is_a?(SegmentDef)
            raise TypeError, "Second argument must be a kind of SegmentDef"
          end

          unless @requirement_designator.is_a?(Designations::SegmentRequirement)
            raise TypeError, "Third argument must be a kind of SegmentRequirement"
          end

          unless @repetition_count.is_a?(Designations::SegmentRepetition)
            raise TypeError, "Fourth argument must be a kind of SegmentRepetition"
          end
        end
      end

    end
  end
end
