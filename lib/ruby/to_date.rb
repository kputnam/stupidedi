# frozen_string_literal: true
module Stupidedi
  module Refinements
    refine Time do
      def to_date
        Date.civil(year, month, day)
      end
    end

    refine String do
      def to_date
        Date.parse(self)
      end
    end

    refine Date do
      def to_date
        self
      end
    end

    class << Date
      public :parse
    end
  end
end
