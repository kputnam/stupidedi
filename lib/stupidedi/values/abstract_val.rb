module Stupidedi
  module Values

    class AbstractVal
      # @return [SimpleElementDef,
      #          CompositeElementDef,
      #          LoopDef,
      #          SegmentDef,
      #          TableDef]
      abstract :definition

      # @see X222 B.1.3.10 Absence of Data
      # @return [Boolean]
      abstract :empty?

      def present?
        not empty?
      end
    end

  end
end
