module Stupidedi
  module Dictionaries
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
            "stupidedi/dictionaries/interchanges/00501/segment_defs/ISA"

          autoload :IEA,
            "stupidedi/dictionaries/interchanges/00501/segment_defs/IEA"

          autoload :ISB,
            "stupidedi/dictionaries/interchanges/00501/segment_defs/ISB"

          autoload :ISE,
            "stupidedi/dictionaries/interchanges/00501/segment_defs/ISE"

          autoload :TA1,
            "stupidedi/dictionaries/interchanges/00501/segment_defs/TA1"

          autoload :TA3,
            "stupidedi/dictionaries/interchanges/00501/segment_defs/TA3"

        end
      end
    end
  end
end
