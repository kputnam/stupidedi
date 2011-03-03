module Stupidedi
  module Values
    autoload :AbstractVal,          "stupidedi/values/abstract_val"
    autoload :CompositeElementVal,  "stupidedi/values/composite_element_val"
    autoload :LoopVal,              "stupidedi/values/loop_val"
    autoload :RepeatedElementVal,   "stupidedi/values/repeated_element_val"
    autoload :SegmentVal,           "stupidedi/values/segment_val"
    autoload :SegmentValGroup,      "stupidedi/values/segment_val_group"
    autoload :TableVal,             "stupidedi/values/table_val"

    autoload :SimpleElementVal, "stupidedi/values/simple_element_val"
    autoload :DateVal,          "stupidedi/values/date_val"
    autoload :DecimalVal,       "stupidedi/values/decimal_val"
    autoload :IdentifierVal,    "stupidedi/values/identifier_val"
    autoload :NumericVal,       "stupidedi/values/numeric_val"
    autoload :StringVal,        "stupidedi/values/string_val"
    autoload :TimeVal,          "stupidedi/values/time_val"
  end
end
