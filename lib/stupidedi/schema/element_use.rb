module Stupidedi
  module Definitions

    class SimpleElementUse
      # @return [SimpleElementDef]
      abstract :simple_element_def

      # @return [ElementReq]
      abstract :element_req

      # @return [RepetitionMax]
      abstract :repetition_max
    end

    class CompositeElementUse
      # @return [CompositeElementDef]
      abstract :composite_element_def

      # @return [ElementReq]
      abstract :element_req

      # @return [RepetitionMax]
      abstract :repetition_max
    end

    class ComponentElementUse
      # @return [SimpleElementDef]
      abstract :simple_element_def

      # @return [ElementReq]
      abstract :element_req
    end

  end
end
