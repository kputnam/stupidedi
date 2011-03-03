module Stupidedi
  module Definitions

    # The 5010 X12 "condition code"s include
    #   P - Paired or Multiple (if one then all)
    #   R - Required (at least one)
    #   E - Exclusion (no more than one)
    #   C - Conditional (if first then all)
    #   L - List Conditional (if first than at least one more)
    #
    # @see X222 B.1.1.3.9 Condition Designator
    class SyntaxNote
      # @return [Array<SimpleElementDef, CompositeElementDef>]
      abstract :element_defs
    end

  end
end
