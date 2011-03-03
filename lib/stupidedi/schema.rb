module Stupidedi
  module Schema

    autoload :SimpleElementDef,         "stupidedi/schema/element_def"
    autoload :SimpleElementReq,         "stupidedi/schema/element_req"
    autoload :SimpleElementUse,         "stupidedi/schema/element_use"
    autoload :CompositeElementDef,      "stupidedi/schema/element_def"
    autoload :CompositeElementReq,      "stupidedi/schema/element_req"
    autoload :CompositeElementUse,      "stupidedi/schema/element_use"
    autoload :ComponentElementUse,      "stupidedi/schema/element_use"

    autoload :FunctionalGroupDef, "stupidedi/schema/functional_group_def"
    autoload :InterchangeDef,     "stupidedi/schema/interchange_def"
    autoload :LoopDef,            "stupidedi/schema/loop_def"
    autoload :RepeatCount,        "stupidedi/schema/repeat_count"
    autoload :SegmentDef,         "stupidedi/schema/segment_def"
    autoload :SegmentReq,         "stupidedi/schema/segment_req"
    autoload :SegmentUse,         "stupidedi/schema/segment_use"
    autoload :SyntaxNote,         "stupidedi/schema/syntax_note"
    autoload :TableDef,           "stupidedi/schema/table_def"
    autoload :TransactionSetDef,  "stupidedi/schema/transaction_set_def"

  end
end
