module Stupidedi
  module FiftyTen
    module Base
      autoload :Designations,           "stupidedi/5010/base/designations"

      autoload :ElementDef,             "stupidedi/5010/base/element_def"
      autoload :SimpleElementDef,       "stupidedi/5010/base/element_def"
      autoload :CompositeElementDef,    "stupidedi/5010/base/element_def"

      autoload :ElementReader,          "stupidedi/5010/base/element_reader"
      autoload :SimpleElementReader,    "stupidedi/5010/base/element_reader"
      autoload :CompositeElementReader, "stupidedi/5010/base/element_reader"
      autoload :SegmentReader,          "stupidedi/5010/base/segment_reader"

      autoload :ElementTypes,           "stupidedi/5010/base/element_types"
      autoload :ElementDictionary,      "stupidedi/5010/base/element_dictionary"

      autoload :ElementUse,             "stupidedi/5010/base/element_use"
      autoload :SimpleElementUse,       "stupidedi/5010/base/element_use"
      autoload :ComponentElementUse,    "stupidedi/5010/base/element_use"

      autoload :SegmentDef,             "stupidedi/5010/base/segment_def"
      autoload :SegmentDictionary,      "stupidedi/5010/base/segment_dictionary"
      autoload :TransactionSets,        "stupidedi/5010/base/transaction_sets"
    end
  end
end
