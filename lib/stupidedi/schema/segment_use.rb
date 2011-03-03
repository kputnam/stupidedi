module Stupidedi
  module Schema

    class SegmentUse
      # @see X222 B.1.1.3.12.7 Data Segment Position
      # @return [Integer]
      abstract :position

      # @return [SegmentDef]
      abstract :definition

      # @see X222 B.1.1.3.12.6 Data Segment Requirement Designators
      # @return [SegmentReq]
      abstract :requirement

      # @see X222 B.1.3.12.3 Repeated Occurrences of Single Data Segments
      # @see X222 B.1.3.12.8 Data Segment Occurrence
      # @return [RepeatCount]
      abstract :repeat_count

      # @return [LoopDef, TableDef]
      abstract :parent

      # @private
      def pretty_print(q)
        q.text "SegmentUse"
        q.group(2, "(", ")") do
          q.breakable ""
          q.pp definition
          q.text ","

          q.breakable
          q.pp requirement
          q.text ","

          q.breakable
          q.pp repeat_count
        end
      end
    end

  end
end
