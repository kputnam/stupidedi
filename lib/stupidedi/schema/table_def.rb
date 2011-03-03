module Stupidedi
  module Definitions

    class TableDef
      # @return [String]
      abstract :name

      # @return [Array<SegmentUse>]
      abstract :segment_uses

      # @return [Array<LoopDef>]
      abstract :loop_defs

      # @return [TransactionSetDef]
      abstract :parent
    end

  end
end
