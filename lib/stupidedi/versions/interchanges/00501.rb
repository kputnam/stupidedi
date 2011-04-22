module Stupidedi
  module Versions
    module Interchanges

      #
      # @see FunctionalGroups::FiftyTen
      #
      module FiveOhOne

        autoload :ElementDefs,
          "stupidedi/versions/interchanges/00501/element_defs"

        autoload :SegmentDefs,
          "stupidedi/versions/interchanges/00501/segment_defs"

        autoload :InterchangeDef,
          "stupidedi/versions/interchanges/00501/interchange_def"

        autoload :InterchangeVal,
          "stupidedi/versions/interchanges/00501/interchange_val"

      end

    end
  end
end
