module Stupidedi
  module Contrib
    module FortyTen
      module Guides

        GuideBuilder = Stupidedi::Guides::FortyTen::GuideBuilder
        SegmentReqs  = Stupidedi::Guides::FortyTen::SegmentReqs
        ElementReqs  = Stupidedi::Guides::FortyTen::ElementReqs

        autoload :PO850, "stupidedi/contrib/004010/guides/PO850"
        autoload :OW940, "stupidedi/contrib/004010/guides/OW940"
        autoload :AR943, "stupidedi/contrib/004010/guides/AR943"
        autoload :RE944, "stupidedi/contrib/004010/guides/RE944"
        autoload :SW945, "stupidedi/contrib/004010/guides/SW945"
        autoload :SM204, "stupidedi/contrib/004010/guides/SM204"
        autoload :QM214, "stupidedi/contrib/004010/guides/QM214"
        autoload :GF990, "stupidedi/contrib/004010/guides/GF990"
        autoload :SS862, "stupidedi/contrib/004010/guides/SS862"
      end
    end
  end
end
