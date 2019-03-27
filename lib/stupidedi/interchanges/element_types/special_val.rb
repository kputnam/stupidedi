# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Interchanges
    module ElementTypes
      AN        = Versions::Common::ElementTypes::AN
      StringVal = Versions::Common::ElementTypes::StringVal

      #
      # The specifications declare ISA02 and ISA04 are required elements, but
      # they only have "meaningful information" when ISA01 and ISA03 qualifiers
      # aren't "00".
      #
      # Without specifications regarding what should be entered in these
      # required elements, our best option is to defer to convention, which
      # seems to be that these elements should have 10 spaces -- which means
      # they're blank. So we can't really make these elements required! Even
      # stupider, these are the only blank elements that should be written out
      # space-padded to the min_length -- every other element should be
      # collapsed to an empty string.
      #
      # So this "Special" class overrides to_x12 for empty values, but it
      # otherwise looks and acts like a normal AN and StringVal
      #
      class SpecialAN < AN
        def companion
          SpecialVal
        end
      end

      class SpecialVal < StringVal
        class Empty < StringVal::Empty
          # @return [String]
          def to_x12
            " " * definition.min_length
          end
        end

        class NonEmpty < StringVal::NonEmpty
          def too_short?
            false
          end
        end
      end
    end
  end
end
