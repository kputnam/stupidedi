module Stupidedi
  module Guides

    #
    # @see Stupidedi::Versions::FunctionalGroups::FortyTen
    #
    module FortyTen

      autoload :SegmentReqs,  "stupidedi/guides/004010/segment_reqs"
      autoload :ElementReqs,  "stupidedi/guides/004010/element_reqs"
      autoload :GuideBuilder, "stupidedi/guides/004010/guide_builder"

      module X12
        autoload :SM204,  "stupidedi/guides/004010/X12-SM204"
      end

    end
  end
end
