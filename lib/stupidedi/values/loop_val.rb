module Stupidedi
  module Values

    class LoopVal

      def initialize(loop_def, *segment_vals)
        @loop_def, @segment_vals = loop_def, segment_vals
      end

      def empty?
        @segment_vals.all?(&:empty?)
      end

      def present?
        @segment_vals.any?(&:present?)
      end

      def [](n)
        @segment_vals[n]
      end
    end

    class << LoopVal
      def empty(loop_def)
        LoopVal.new(loop_def, loop_def.segment_uses.map{|u| u.segment_def.empty })
      end
    end

  end
end
