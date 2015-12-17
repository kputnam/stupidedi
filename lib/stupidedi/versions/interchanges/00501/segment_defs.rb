module Stupidedi
  using Refinements

  module Versions
    module Interchanges
      module FiveOhOne

        #
        # @see Schema::SegmentDef.build
        #
        module SegmentDefs

          s = Schema
          e = ElementDefs
          m = FunctionalGroups::FiftyTen::ElementReqs

          autoload :ISA,
            "stupidedi/versions/interchanges/00501/segment_defs/ISA"

          autoload :IEA,
            "stupidedi/versions/interchanges/00501/segment_defs/IEA"

        # autoload :ISB,
        #   "stupidedi/versions/interchanges/00501/segment_defs/ISB"

        # autoload :ISE,
        #   "stupidedi/versions/interchanges/00501/segment_defs/ISE"

          autoload :TA1,
            "stupidedi/versions/interchanges/00501/segment_defs/TA1"

        # autoload :TA3,
        #   "stupidedi/versions/interchanges/00501/segment_defs/TA3"

        end
      end
    end
  end
end
