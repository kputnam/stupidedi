module Stupidedi
  module Versions
    module FunctionalGroups

      #
      # @see Guides::FiftyTen
      # @see Interchanges::FiveOhOne
      #
      module ThirtyTen

        autoload :ElementTypes,
          "stupidedi/versions/functional_groups/003010/element_types"

        autoload :ElementDefs,
          "stupidedi/versions/functional_groups/003010/element_defs"

        autoload :ElementReqs,
          "stupidedi/versions/functional_groups/003010/element_reqs"

        autoload :FunctionalGroupDef,
          "stupidedi/versions/functional_groups/003010/functional_group_def"

        autoload :SegmentDefs,
          "stupidedi/versions/functional_groups/003010/segment_defs"

        autoload :SegmentReqs,
          "stupidedi/versions/functional_groups/003010/segment_reqs"

        autoload :SyntaxNotes,
          "stupidedi/versions/functional_groups/003010/syntax_notes"

        autoload :TransactionSetDefs,
          "stupidedi/versions/functional_groups/003010/transaction_set_defs"
      end

    end
  end
end
