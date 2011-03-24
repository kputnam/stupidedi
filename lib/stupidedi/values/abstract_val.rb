module Stupidedi
  module Values

    class AbstractVal
      include Inspect
      include Color

      # @return [SimpleElementDef, CompositeElementDef, LoopDef, SegmentDef, TableDef]
      abstract :definition

      # @see X222.pdf B.1.3.10 Absence of Data
      abstract :empty?

      abstract :leaf?

      def present?
        not empty?
      end
    end

  end
end
