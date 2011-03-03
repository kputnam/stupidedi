module Stupidedi
  module Schema

    class FunctionalGroupDef
      def value(segment_vals, transaction_set_vals, parent)
        FunctionalGroupVal.new(self, segment_vals, transaction_set_vals, parent)
      end

      def empty(parent)
        FunctionalGroupVal.new(self, [], [], parent)
      end
    end

  end
end
