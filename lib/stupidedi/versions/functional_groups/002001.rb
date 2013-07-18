module Stupidedi
  module Versions
    module FunctionalGroups

      #
      # @see Guides::FiftyTen
      # @see Interchanges::FiveOhOne
      #
      module TwoThousandOne

        autoload :ElementTypes,
          "stupidedi/versions/functional_groups/002001/element_types"

        autoload :ElementDefs,
          "stupidedi/versions/functional_groups/002001/element_defs"

        autoload :ElementReqs,
          "stupidedi/versions/functional_groups/002001/element_reqs"

        autoload :FunctionalGroupDef,
          "stupidedi/versions/functional_groups/002001/functional_group_def"

        autoload :SegmentDefs,
          "stupidedi/versions/functional_groups/002001/segment_defs"

        autoload :SegmentReqs,
          "stupidedi/versions/functional_groups/002001/segment_reqs"

        autoload :SyntaxNotes,
          "stupidedi/versions/functional_groups/002001/syntax_notes"

        autoload :TransactionSetDefs,
          "stupidedi/versions/functional_groups/002001/transaction_set_defs"
      end

    end
  end
end
