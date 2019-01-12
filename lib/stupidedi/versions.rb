# frozen_string_literal: true
module Stupidedi
  module Versions
    # @todo Deprecated
    autoload :FunctionalGroups, "stupidedi/versions/functional_groups"
    autoload :Interchanges,     "stupidedi/versions/interchanges"

    autoload :Common,           "stupidedi/versions/common"
    autoload :TwoThousandOne,   "stupidedi/versions/002001"
    autoload :ThirtyTen,        "stupidedi/versions/003010"
    autoload :ThirtyForty,      "stupidedi/versions/003040"
    autoload :ThirtyFifty,      "stupidedi/versions/003050"
    autoload :FortyTen,         "stupidedi/versions/004010"
    autoload :FiftyTen,         "stupidedi/versions/005010"
  end
end
