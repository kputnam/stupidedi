# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          IK5 = s::SegmentDef.build(:IK5, "Transaction Set Response Trailer",
            "To acknowledge acceptance or rejection and report implementation errors in a transaction set",
            e::E717 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E618 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E618 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E618 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E618 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E618 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end
