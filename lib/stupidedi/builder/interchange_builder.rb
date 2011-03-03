module Stupidedi
  module Builder

    class InterchangeBuilder
      def initialize(router, version)
        @router, @version = router, version
      end

      def segment(name, *elements)
        #=> Interchange(...)

        interchange = interchange.isa
        #=> Interchange(ISA, ...)

        interchange = interchange.isb
        #=> Interchange(ISA, ISB, ...)

        interchange = interchange.ise
        #=> Interchange(ISA, ISB, ISE, ...)

        interchange = interchange.ta1
        interchange = interchange.ta1
        interchange = interchange.ta1
        interchange = interchange.ta1
        #=> Interchange(ISA, ISB, ISE, TA1, TA1, TA1, TA1, ...)

        interchange = interchange.iea
        #=> Interchange(ISA, ISB, ISE, TA1, TA1, TA1, TA1, ..., IEA)
      end
    end

  end
end
