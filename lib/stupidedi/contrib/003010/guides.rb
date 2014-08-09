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
        autoload :PO850, "stupidedi/contrib/003010/guides/PO850"
        autoload :PC860, "stupidedi/contrib/003010/guides/PC860"
        autoload :PS830, "stupidedi/contrib/003010/guides/PS830"
      end
    end
  end
end
