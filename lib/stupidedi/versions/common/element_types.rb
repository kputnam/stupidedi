# frozen_string_literal: true
module Stupidedi
  module Versions
    module Common
      module ElementTypes
        autoload :DT,               "stupidedi/versions/common/element_types/date_val"
        autoload :DateVal,          "stupidedi/versions/common/element_types/date_val"

        autoload :R,                "stupidedi/versions/common/element_types/float_val"
        autoload :FloatVal,         "stupidedi/versions/common/element_types/float_val"

        autoload :ID,               "stupidedi/versions/common/element_types/identifier_val"
        autoload :IdentifierVal,    "stupidedi/versions/common/element_types/identifier_val"

        autoload :Nn,               "stupidedi/versions/common/element_types/fixnum_val"
        autoload :FixnumVal,        "stupidedi/versions/common/element_types/fixnum_val"

        autoload :AN,               "stupidedi/versions/common/element_types/string_val"
        autoload :StringVal,        "stupidedi/versions/common/element_types/string_val"

        autoload :TM,               "stupidedi/versions/common/element_types/time_val"
        autoload :TimeVal,          "stupidedi/versions/common/element_types/time_val"

        autoload :Operators,        "stupidedi/versions/common/element_types/operators"
        autoload :SimpleElementDef, "stupidedi/versions/common/element_types/simple_element"
      end
    end
  end
end
