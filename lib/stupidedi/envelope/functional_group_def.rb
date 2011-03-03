module Stupidedi
  module Envelope

    class FunctionalGroupDef
      def value(segment_vals, transaction_set_vals, parent)
        FunctionalGroupVal.new(self, segment_vals, transaction_set_vals, parent)
      end

      def empty(parent)
        FunctionalGroupVal.new(self, [], [], parent)
      end

      abstract :reader, :args => %w(input context)
    end

  end
end
