module Stupidedi
  module Refinements

    refine Time do
      def to_date
        Date.civil(year, month, day)
      end

      public :to_date
    end

    refine String do
      def to_date
        Date.parse(self)
      end

      public :to_date
    end

    refine Date do
      def to_date
        self
      end

      public :to_date
    end

    class << Date
      public :parse
    end

  end
end
