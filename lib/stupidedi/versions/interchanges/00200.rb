module Stupidedi
  using Refinements

  module Versions
    module Interchanges

      #
      # @see FunctionalGroups::FortyTen
      #
      module TwoHundred

        autoload :ElementDefs,
          "stupidedi/versions/interchanges/00200/element_defs"

        autoload :SegmentDefs,
          "stupidedi/versions/interchanges/00200/segment_defs"

        autoload :InterchangeDef,
          "stupidedi/versions/interchanges/00200/interchange_def"

      end

    end
  end
end
