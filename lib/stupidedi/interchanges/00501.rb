# frozen_string_literal: true
module Stupidedi
  module Interchanges
    module FiveOhOne
      autoload :ElementDefs,    "stupidedi/interchanges/00501/element_defs"
      autoload :SegmentDefs,    "stupidedi/interchanges/00501/segment_defs"
      autoload :InterchangeDef, "stupidedi/interchanges/00501/interchange_def"

      ElementReqs = Versions::Common::ElementReqs
    end
  end
end
