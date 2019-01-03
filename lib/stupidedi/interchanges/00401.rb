# frozen_string_literal: true
module Stupidedi
  module Interchanges
    module FourOhOne
      autoload :ElementDefs,    "stupidedi/interchanges/00401/element_defs"
      autoload :SegmentDefs,    "stupidedi/interchanges/00401/segment_defs"
      autoload :InterchangeDef, "stupidedi/interchanges/00401/interchange_def"

      ElementReqs = Versions::Common::ElementReqs
    end
  end
end
