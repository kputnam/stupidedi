module Stupidedi
  module Contrib
    module TwoThousandOne
      module Guides

        # GuideBuilder = Stupidedi::Guides::TwoThousandOne::GuideBuilder
        # SegmentReqs  = Stupidedi::Guides::TwoThousandOne::SegmentReqs
        # ElementReqs  = Stupidedi::Guides::TwoThousandOne::ElementReqs

        GuideBuilder = Stupidedi::Guides::FortyTen::GuideBuilder
        SegmentReqs  = Stupidedi::Guides::FortyTen::SegmentReqs
        ElementReqs  = Stupidedi::Guides::FortyTen::ElementReqs
        
        autoload :SH856, "stupidedi/contrib/002001/guides/SH856"
        autoload :PO830, "stupidedi/contrib/002001/guides/PO830"
        autoload :FA997, "stupidedi/contrib/002001/guides/FA997"
      end
    end
  end
end
