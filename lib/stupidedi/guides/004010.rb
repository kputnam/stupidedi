module Stupidedi
  module Guides

    #
    # @see Stupidedi::Versions::FunctionalGroups::FortyTen
    #
    module FortyTen

      # TODO! We don't have 4010 definitions yet
      autoload :SegmentReqs,  "stupidedi/guides/005010/segment_reqs"
      autoload :ElementReqs,  "stupidedi/guides/005010/element_reqs"
      autoload :GuideBuilder, "stupidedi/guides/005010/guide_builder"

      module STP
        autoload :RA820,  "stupidedi/guides/004010/STP-RA820"
      end

    end
  end
end
