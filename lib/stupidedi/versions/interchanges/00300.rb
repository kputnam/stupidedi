module Stupidedi
  module Versions
    module Interchanges

      #
      # @see FunctionalGroups::FortyTen
      #
      module TwoHundred

        autoload :ElementDefs,
          "stupidedi/versions/interchanges/00300/element_defs"

        autoload :SegmentDefs,
          "stupidedi/versions/interchanges/00300/segment_defs"

        autoload :InterchangeDef,
          "stupidedi/versions/interchanges/00300/interchange_def"

      end

    end
  end
end
