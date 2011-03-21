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
            "stupidedi/dictionaries/interchanges/00501/segment_defs/isa"

          autoload :IEA,
            "stupidedi/dictionaries/interchanges/00501/segment_defs/iea"

          autoload :ISB,
            "stupidedi/dictionaries/interchanges/00501/segment_defs/isb"

          autoload :ISE,
            "stupidedi/dictionaries/interchanges/00501/segment_defs/ise"

          autoload :TA1,
            "stupidedi/dictionaries/interchanges/00501/segment_defs/ta1"

          autoload :TA3,
            "stupidedi/dictionaries/interchanges/00501/segment_defs/ta3"

        end
      end
    end
  end
end
