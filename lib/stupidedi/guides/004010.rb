module Stupidedi
  using Refinements

  module Guides

    #
    # @see Stupidedi::Versions::FunctionalGroups::FortyTen
    #
    module FortyTen

      autoload :SegmentReqs,  "stupidedi/guides/004010/segment_reqs"
      autoload :ElementReqs,  "stupidedi/guides/004010/element_reqs"
      autoload :GuideBuilder, "stupidedi/guides/004010/guide_builder"

      module X091A1
        autoload :HP835,  "stupidedi/guides/004010/X091A1-HP835"
      end

    end
  end
end
