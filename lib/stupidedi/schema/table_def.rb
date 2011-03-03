module Stupidedi
  module Definitions

    class TableDef
      # @return [String]
      abstract :name

      # @return [Array<SegmentUse>]
      abstract :segment_uses

      # @return [Array<LoopDef>]
      abstract :loop_defs
    end

  end
end
