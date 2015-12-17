module Stupidedi
  using Refinements

  module Versions
    module Interchanges

      #
      # @see FunctionalGroups::FortyTen
      #
      module ThreeHundred

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
