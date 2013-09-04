module Stupidedi
  module Contrib
    module ThirtyTen
      module Guides

        # GuideBuilder = Stupidedi::Guides::TwoThousandOne::GuideBuilder
        # SegmentReqs  = Stupidedi::Guides::TwoThousandOne::SegmentReqs
        # ElementReqs  = Stupidedi::Guides::TwoThousandOne::ElementReqs

        GuideBuilder = Stupidedi::Guides::FortyTen::GuideBuilder
        SegmentReqs  = Stupidedi::Guides::FortyTen::SegmentReqs
        ElementReqs  = Stupidedi::Guides::FortyTen::ElementReqs
        
        autoload :RA820, "stupidedi/contrib/003010/guides/RA820"
      end
    end
  end
end
