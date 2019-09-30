# frozen_string_literal: true
module Stupidedi
  module Interchanges
    module FourHundred
      autoload :ElementDefs,    "stupidedi/interchanges/00400/element_defs"
      autoload :SegmentDefs,    "stupidedi/interchanges/00400/segment_defs"
      autoload :InterchangeDef, "stupidedi/interchanges/00400/interchange_def"

      ElementReqs   = Versions::Common::ElementReqs
      ElementTypes  = Interchanges::Common::ElementTypes
    end
  end
end
