# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Guides

    #
    # @see Stupidedi::Versions::FunctionalGroups::FiftyTen
    #
    module FiftyTen

      autoload :SegmentReqs,  "stupidedi/guides/005010/segment_reqs"
      autoload :ElementReqs,  "stupidedi/guides/005010/element_reqs"
      autoload :GuideBuilder, "stupidedi/guides/005010/guide_builder"

      module X214
        autoload :HN277,  "stupidedi/guides/005010/X214-HN277"
      end

      module X220
        autoload :BE834,  "stupidedi/guides/005010/X220-BE834"
      end

      module X220A1
        autoload :BE834,  "stupidedi/guides/005010/X220A1-BE834"
      end

      module X221
        autoload :HP835,  "stupidedi/guides/005010/X221-HP835"
      end

      module X221A1
        autoload :HP835,  "stupidedi/guides/005010/X221A1-HP835"
      end

      module X222
        autoload :HC837P,  "stupidedi/guides/005010/X222-HC837P"
      end

      module X222A1
        autoload :HC837P,  "stupidedi/guides/005010/X222A1-HC837P"
      end

      module X223
        autoload :HC837I,  "stupidedi/guides/005010/X223-HC837I"
      end

    # module X223A1
    #   autoload :HC837I,  "stupidedi/guides/005010/X223A1-HC837I"
    # end

    # module X224
    #   autoload :HC837D,  "stupidedi/guides/005010/X224-HC837D"
    # end

    # module X224A1
    #   autoload :HC837D,  "stupidedi/guides/005010/X224A1-HC837D"
    # end

    # module X224A2
    #   autoload :HC837D,  "stupidedi/guides/005010/X224A2-HC837D"
    # end

      module X231
        autoload :FA999,  "stupidedi/guides/005010/X231-FA999"
      end

      module X231A1
        autoload :FA999,  "stupidedi/guides/005010/X231A1-FA999"
      end

    end
  end
end
