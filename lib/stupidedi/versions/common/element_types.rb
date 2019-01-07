# frozen_string_literal: true
module Stupidedi
  module Versions
    module Common
      module ElementTypes
        autoload :DT,               "stupidedi/versions/common/element_types/dt"
        autoload :DateVal,          "stupidedi/versions/common/element_types/dt"

        autoload :R,                "stupidedi/versions/common/element_types/r"
        autoload :FloatVal,         "stupidedi/versions/common/element_types/r"

        autoload :ID,               "stupidedi/versions/common/element_types/id"
        autoload :IdentifierVal,    "stupidedi/versions/common/element_types/id"

        autoload :Nn,               "stupidedi/versions/common/element_types/nn"
        autoload :FixnumVal,        "stupidedi/versions/common/element_types/nn"

        autoload :AN,               "stupidedi/versions/common/element_types/an"
        autoload :StringVal,        "stupidedi/versions/common/element_types/an"

        autoload :TM,               "stupidedi/versions/common/element_types/tm"
        autoload :TimeVal,          "stupidedi/versions/common/element_types/tm"

        autoload :Operators,        "stupidedi/versions/common/element_types/operators"
        autoload :SimpleElementDef, "stupidedi/versions/common/element_types/simple_element"
      end
    end
  end
end
