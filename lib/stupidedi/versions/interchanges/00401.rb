# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Versions
    module Interchanges

      #
      # @see FunctionalGroups::FortyTen
      #
      module FourOhOne

        autoload :ElementDefs,
          "stupidedi/versions/interchanges/00401/element_defs"

        autoload :SegmentDefs,
          "stupidedi/versions/interchanges/00401/segment_defs"

        autoload :InterchangeDef,
          "stupidedi/versions/interchanges/00401/interchange_def"

      end

    end
  end
end
