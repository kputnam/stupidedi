module Stupidedi
  module Schema

    class SegmentUse
      # @see X222 B.1.1.3.12.7 Data Segment Position
      # @return [Integer]
      abstract :position

      # @return [SegmentDef]
      abstract :segment_def

      # @see X222 B.1.1.3.12.6 Data Segment Requirement Designators
      # @return [SegmentReq]
      abstract :segment_req

      # @see X222 B.1.3.12.3 Repeated Occurrences of Single Data Segments
      # @see X222 B.1.3.12.8 Data Segment Occurrence
      # @return [RepetitionMax]
      abstract :repetition_max

      # @return [LoopDef, TableDef]
      abstract :parent
    end

  end
end
