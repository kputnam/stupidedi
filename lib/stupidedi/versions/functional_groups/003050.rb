# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Versions
    module FunctionalGroups

      #
      # @see Guides::FiftyTen
      # @see Interchanges::FiveOhOne
      #
      module ThirtyFifty

        autoload :ElementTypes,
          "stupidedi/versions/functional_groups/003050/element_types"

        autoload :ElementDefs,
          "stupidedi/versions/functional_groups/003050/element_defs"

        autoload :ElementReqs,
          "stupidedi/versions/functional_groups/003050/element_reqs"

        autoload :FunctionalGroupDef,
          "stupidedi/versions/functional_groups/003050/functional_group_def"

        autoload :SegmentDefs,
          "stupidedi/versions/functional_groups/003050/segment_defs"

        autoload :SegmentReqs,
          "stupidedi/versions/functional_groups/003050/segment_reqs"

        autoload :SyntaxNotes,
          "stupidedi/versions/functional_groups/003050/syntax_notes"

        autoload :TransactionSetDefs,
          "stupidedi/versions/functional_groups/003050/transaction_set_defs"
      end

    end
  end
end
