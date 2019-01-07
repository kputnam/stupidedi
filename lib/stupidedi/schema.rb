# frozen_string_literal: true
module Stupidedi
  module Schema
    autoload :AbstractElementUse,   "stupidedi/schema/element_use"
    autoload :AbstractUse,          "stupidedi/schema/abstract_use"
    autoload :ComponentElementUse,  "stupidedi/schema/element_use"
    autoload :CompositeElementUse,  "stupidedi/schema/element_use"
    autoload :SegmentUse,           "stupidedi/schema/segment_use"
    autoload :SimpleElementUse,     "stupidedi/schema/element_use"

    autoload :AbstractDef,          "stupidedi/schema/abstract_def"
    autoload :AbstractElementDef,   "stupidedi/schema/element_def"
    autoload :CompositeElementDef,  "stupidedi/schema/element_def"
    autoload :FunctionalGroupDef,   "stupidedi/schema/functional_group_def"
    autoload :InterchangeDef,       "stupidedi/schema/interchange_def"
    autoload :LoopDef,              "stupidedi/schema/loop_def"
    autoload :SegmentDef,           "stupidedi/schema/segment_def"
    autoload :SimpleElementDef,     "stupidedi/schema/element_def"
    autoload :TableDef,             "stupidedi/schema/table_def"
    autoload :TransactionSetDef,    "stupidedi/schema/transaction_set_def"

    autoload :ElementReq,           "stupidedi/schema/element_req"
    autoload :SegmentReq,           "stupidedi/schema/segment_req"
    autoload :RepeatCount,          "stupidedi/schema/repeat_count"
    autoload :SyntaxNote,           "stupidedi/schema/syntax_note"
    autoload :CodeList,             "stupidedi/schema/code_list"
  end
end
