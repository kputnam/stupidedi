module Stupidedi
  using Refinements

  module Values

    #
    # @see X222.pdf B.1.1.3.12.2 Data Segment Groups
    #
    module SegmentValGroup

      # @return [LoopDef, TableDef]
      abstract :definition

      # (see AbstractVal#leaf?)
      # @return false
      def leaf?
        false
      end
    end

  end
end
