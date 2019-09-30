# frozen_string_literal: true
module Stupidedi
  module Interchanges
    module ThreeHundred
      autoload :ElementDefs,    "stupidedi/interchanges/00300/element_defs"
      autoload :SegmentDefs,    "stupidedi/interchanges/00300/segment_defs"
      autoload :InterchangeDef, "stupidedi/interchanges/00300/interchange_def"

      ElementReqs   = Versions::Common::ElementReqs
      ElementTypes  = Interchanges::Common::ElementTypes
    end
  end
end
