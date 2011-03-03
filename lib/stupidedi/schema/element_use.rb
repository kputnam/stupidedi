module Stupidedi
  module Schema

    class SimpleElementUse
      # @return [SimpleElementDef]
      abstract :simple_element_def

      # @return [ElementReq]
      abstract :element_req

      # @return [RepetitionMax]
      abstract :repetition_max

      # @return [SegmentDef]
      abstract :parent
    end

    class CompositeElementUse
      # @return [CompositeElementDef]
      abstract :composite_element_def

      # @return [ElementReq]
      abstract :element_req

      # @return [RepetitionMax]
      abstract :repetition_max

      # @return [SegmentDef]
      abstract :parent
    end

    class ComponentElementUse
      # @return [SimpleElementDef]
      abstract :component_element_def

      # @return [ElementReq]
      abstract :element_req

      # @return [CompositeElementDef]
      abstract :parent
    end

  end
end
