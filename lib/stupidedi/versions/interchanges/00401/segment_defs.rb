module Stupidedi
  module Versions
    module Interchanges
      module FourOhOne

        #
        # @see Schema::SegmentDef.build
        #
        module SegmentDefs

          s = Schema
          e = ElementDefs
          m = FunctionalGroups::FortyTen::ElementReqs

          autoload :ISA,
            "stupidedi/versions/interchanges/00401/segment_defs/ISA"

          autoload :IEA,
            "stupidedi/versions/interchanges/00401/segment_defs/IEA"

          autoload :TA1,
            "stupidedi/versions/interchanges/00401/segment_defs/TA1"

        end
      end
    end
  end
end
