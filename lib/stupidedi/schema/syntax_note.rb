module Stupidedi
  module Schema

    # The 5010 X12 "condition code"s include
    #   P - Paired or Multiple (if one then all)
    #   R - Required (at least one)
    #   E - Exclusion (no more than one)
    #   C - Conditional (if first then all)
    #   L - List Conditional (if first than at least one more)
    #
    # @see X222.pdf B.1.1.3.5 Syntax Notes
    # @see X222.pdf B.1.1.3.9 Condition Designator
    #
    class SyntaxNote
      # @return [Array<SimpleElementUse, CompositeElementUse>]
      abstract :element_uses
    end

  end
end
