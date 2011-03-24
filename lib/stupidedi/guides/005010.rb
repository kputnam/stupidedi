module Stupidedi
  module Guides

    #
    # @see Stupidedi::Dictionaries::FunctionalGroups::FiftyTen
    #
    module FiftyTen

      autoload :SegmentReqs,  "stupidedi/guides/005010/segment_reqs"
      autoload :ElementReqs,  "stupidedi/guides/005010/element_reqs"

      autoload :GuideBuilder, "stupidedi/guides/005010/guide_builder"

      module X221
        autoload :HP835,  "stupidedi/guides/005010/X221-HP835"
      end

      module X222
        autoload :HC837,  "stupidedi/guides/005010/X222-HC837"
      end

      module X223
        autoload :HC837,  "stupidedi/guides/005010/X223-HC837"
      end

      module X224
        autoload :HC837,  "stupidedi/guides/005010/X224-HC837"
      end

      module X230
        autoload :FA997,  "stupidedi/guides/005010/X230-FA997"
      end

      module X231
        autoload :FA999,  "stupidedi/guides/005010/X221-FA999"
      end

    end
  end
end
