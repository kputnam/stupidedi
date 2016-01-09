module Stupidedi
  using Refinements

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

      end

    end
  end
end
