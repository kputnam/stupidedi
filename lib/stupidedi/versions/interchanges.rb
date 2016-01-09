module Stupidedi
  using Refinements

  module Versions
    module Interchanges
      autoload :TwoHundred, "stupidedi/versions/interchanges/00200"
      autoload :ThreeHundred, "stupidedi/versions/interchanges/00300"
      autoload :FourHundred, "stupidedi/versions/interchanges/00400"
      autoload :FourOhOne, "stupidedi/versions/interchanges/00401"
      autoload :FiveOhOne, "stupidedi/versions/interchanges/00501"
    end
  end
end
