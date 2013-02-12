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
        autoload :P0850,  "stupidedi/guides/004010/X12-PO850"
        autoload :OW940,  "stupidedi/guides/004010/X12-OW940"
        autoload :AR943,  "stupidedi/guides/004010/X12-AR943"
        autoload :SM204,  "stupidedi/guides/004010/X12-SM204"
        autoload :QM214,  "stupidedi/guides/004010/X12-QM214"
        autoload :GF990,  "stupidedi/guides/004010/X12-GF990"
      end

    end
  end
end
