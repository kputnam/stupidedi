module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          PWK = SegmentDef.new :PWK, "Paperwork",
            E::E755 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E756 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E757 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E98  .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E66  .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E67  .simple_use(Optional,   RepeatCount.bounded(1)),

            E::E352 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::C002 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1525.simple_use(Optional,   RepeatCount.bounded(1)),

            SyntaxNote::P.new(5, 6)

        end
      end
    end
  end
end
