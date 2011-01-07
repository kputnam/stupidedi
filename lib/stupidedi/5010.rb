module Stupidedi
  module FiftyTen
    autoload :Industry, "stupidedi/5010/industry"
    autoload :Partners, "stupidedi/5010/partners"

    module Definitions
      autoload :ElementDef,   "stupidedi/5010/definitions/element_def"
      autoload :ElementUse,   "stupidedi/5010/definitions/element_use"
      autoload :ElementTypes, "stupidedi/5010/definitions/element_types"

      autoload :SimpleElementDef, "stupidedi/5010/definitions/element_def"
      autoload :SimpleElementUse, "stupidedi/5010/definitions/element_use"

      autoload :CompositeElementDef,  "stupidedi/5010/definitions/element_def"
      autoload :ComponentElementUse,  "stupidedi/5010/definitions/element_use"

      autoload :SegmentDef, "stupidedi/5010/definitions/segment_def"
      autoload :SegmentUse, "stupidedi/5010/definitions/segment_use"
      autoload :LoopDef,    "stupidedi/5010/definitions/loop_def"

      autoload :ElementRequirement, "stupidedi/5010/definitions/designations"
      autoload :ElementRepetition,  "stupidedi/5010/definitions/designations"
      autoload :SegmentRequirement, "stupidedi/5010/definitions/designations"
      autoload :SegmentRepetition,  "stupidedi/5010/definitions/designations"
      autoload :LoopRepetition,     "stupidedi/5010/definitions/designations"
    end

    module Dictionaries
      autoload :ElementDict,  "stupidedi/5010/dictionaries/element_dictionary"
      autoload :SegmentDict,  "stupidedi/5010/dictionaries/segment_dictionary"
    end

    module Readers
      autoload :ElementReader,          "stupidedi/5010/readers/element_reader"
      autoload :SimpleElementReader,    "stupidedi/5010/readers/element_reader"
      autoload :CompositeElementReader, "stupidedi/5010/readers/element_reader"
      autoload :SegmentReader,          "stupidedi/5010/readers/segment_reader"
      autoload :LoopReader,             "stupidedi/5010/readers/loop_reader"
      autoload :TableReader,            "stupidedi/5010/readers/table_reader"
    end

  end
end
