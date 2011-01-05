module Stupidedi
  module Values
    autoload :DateVal,       "stupidedi/values/date_val"
    autoload :DecimalVal,    "stupidedi/values/decimal_val"
    autoload :IdentifierVal, "stupidedi/values/identifier_val"
    autoload :NumericVal,    "stupidedi/values/numeric_val"
    autoload :StringVal,     "stupidedi/values/string_val"
    autoload :TimeVal,       "stupidedi/values/time_val"

    autoload :SegmentVal,           "stupidedi/values/segment_val"
    autoload :SimpleElementVal,     "stupidedi/values/simple_element_val"
    autoload :CompositeElementVal,  "stupidedi/values/composite_element_val"
    autoload :RepeatedElementVal,   "stupidedi/values/repeated_element_val"
    autoload :LoopVal,              "stupidedi/values/loop_val"
  end
end
