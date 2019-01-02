# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Versions
    module Interchanges

      #
      # @see FunctionalGroups::FortyTen
      #
      module FourHundred

        autoload :ElementDefs,
          "stupidedi/versions/interchanges/00400/element_defs"

        autoload :SegmentDefs,
          "stupidedi/versions/interchanges/00400/segment_defs"

        autoload :InterchangeDef,
          "stupidedi/versions/interchanges/00400/interchange_def"

      end

    end
  end
end
