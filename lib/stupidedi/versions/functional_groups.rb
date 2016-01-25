# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Versions
    module FunctionalGroups
      autoload :TwoThousandOne, "stupidedi/versions/functional_groups/002001"
      autoload :ThirtyTen, 		"stupidedi/versions/functional_groups/003010"
      autoload :ThirtyForty, 	"stupidedi/versions/functional_groups/003040"
      autoload :ThirtyFifty, 	"stupidedi/versions/functional_groups/003050"
      autoload :FortyTen, 		"stupidedi/versions/functional_groups/004010"
      autoload :FiftyTen, 		"stupidedi/versions/functional_groups/005010"
    end
  end
end
