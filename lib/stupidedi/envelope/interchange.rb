module Stupidedi
  module Envelope

    # @see X12.5 3.2.1 Basic Interchange Service Request
    class InterchangeVal
      # @return [Array<FunctionalGroupVal>]
      abstract :functional_groups

      # %w(ISA05 ISA06 ISA07 ISA08 ISA13)
    end

  end
end
