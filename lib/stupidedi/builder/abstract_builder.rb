module Stupidedi
  module Builder

    class AbstractBuilder
      Blank   = Object.new
      Default = Object.new

      def blank
        Blank
      end

      def default
        Default
      end

      abstract :segment

      def method_missing(name, *args)
        segment(name, *args)
      end
    end

  end
end
