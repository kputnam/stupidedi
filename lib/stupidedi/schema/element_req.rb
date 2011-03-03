module Stupidedi
  module Schema

    # The 5010 X12 "condition designator"s include
    #   M - Mandatory
    #   O - Optional
    #   X - Relational
    #
    # Where "Relational" indicates this element is subject to relational
    # conditions between two or more elements (encoded as a SyntaxNote)
    #
    # @see X222 B.1.1.3.9 Condition Designator
    #
    # The "Implementation Usage" from the 5010 HIPAA implementation guides
    # have three descriptors:
    #   REQUIRED
    #   NOT USED
    #   SITUATIONAL
    #
    # @see X222 2.2.1 Industry Usage
    class ElementReq
      abstract :required?
      abstract :forbidden?

      def optional?
        not (required? or forbidden?)
      end
    end

  end
end
