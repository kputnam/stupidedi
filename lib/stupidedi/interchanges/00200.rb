# frozen_string_literal: true
module Stupidedi
  module Interchanges
    module TwoHundred
      autoload :ElementDefs,    "stupidedi/interchanges/00200/element_defs"
      autoload :SegmentDefs,    "stupidedi/interchanges/00200/segment_defs"
      autoload :InterchangeDef, "stupidedi/interchanges/00200/interchange_def"

      ElementReqs   = Versions::Common::ElementReqs
      ElementTypes  = Interchanges::Common::ElementTypes
    end
  end
end
