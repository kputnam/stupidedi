module Stupidedi
  module Values
    autoload :AbstractVal,          "stupidedi/values/abstract_val"
    autoload :AbstractElementVal,   "stupidedi/values/abstract_element_val"
    autoload :CompositeElementVal,  "stupidedi/values/composite_element_val"
    autoload :LoopVal,              "stupidedi/values/loop_val"
    autoload :RepeatedElementVal,   "stupidedi/values/repeated_element_val"
    autoload :InvalidSegmentVal,    "stupidedi/values/segment_val"
    autoload :SegmentVal,           "stupidedi/values/segment_val"
    autoload :SegmentValGroup,      "stupidedi/values/segment_val_group"
    autoload :SimpleElementVal,     "stupidedi/values/simple_element_val"
    autoload :TableVal,             "stupidedi/values/table_val"
  end
end
