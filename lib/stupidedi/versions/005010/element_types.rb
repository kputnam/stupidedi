# frozen_string_literal: true
module Stupidedi
  module Versions
    module FiftyTen
      module ElementTypes
        autoload :DT, "stupidedi/versions/005010/element_types/date_val"
        autoload :R,  "stupidedi/versions/005010/element_types/float_val"
        autoload :ID, "stupidedi/versions/005010/element_types/identifier_val"
        autoload :Nn, "stupidedi/versions/005010/element_types/fixnum_val"
        autoload :AN, "stupidedi/versions/005010/element_types/string_val"
        autoload :TM, "stupidedi/versions/005010/element_types/time_val"

        autoload :DateVal,        "stupidedi/versions/005010/element_types/date_val"
        autoload :FloatVal,       "stupidedi/versions/005010/element_types/float_val"
        autoload :IdentifierVal,  "stupidedi/versions/005010/element_types/identifier_val"
        autoload :FixnumVal,      "stupidedi/versions/005010/element_types/fixnum_val"
        autoload :StringVal,      "stupidedi/versions/005010/element_types/string_val"
        autoload :TimeVal,        "stupidedi/versions/005010/element_types/time_val"

        SimpleElementDef = Common::ElementTypes::SimpleElementDef
      end
    end
  end
end
