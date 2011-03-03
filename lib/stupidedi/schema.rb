module Stupidedi
  module Schema

    autoload :CodeList,             "stupidedi/schema/code_list"

    autoload :ElementReq,           "stupidedi/schema/element_req"
    autoload :SimpleElementDef,     "stupidedi/schema/element_def"
    autoload :SimpleElementUse,     "stupidedi/schema/element_use"
    autoload :CompositeElementDef,  "stupidedi/schema/element_def"
    autoload :CompositeElementUse,  "stupidedi/schema/element_use"
    autoload :ComponentElementUse,  "stupidedi/schema/element_use"

    autoload :LoopDef,      "stupidedi/schema/loop_def"
    autoload :RepeatCount,  "stupidedi/schema/repeat_count"
    autoload :SegmentDef,   "stupidedi/schema/segment_def"
    autoload :SegmentReq,   "stupidedi/schema/segment_req"
    autoload :SegmentUse,   "stupidedi/schema/segment_use"
    autoload :SyntaxNote,   "stupidedi/schema/syntax_note"
    autoload :TableDef,     "stupidedi/schema/table_def"

  end
end
