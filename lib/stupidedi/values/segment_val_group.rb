module Stupidedi
  module Values

    module SegmentGroup
      # @return [Array<SegmentVal>]
      abstract :segment_vals

      # @return [LoopDef, TableDef, ...]
      abstract :definition

      def empty?
        segment_vals.all?(&:empty?)
      end

      # @return [Array<SegmentVal>]
      def at(n)
        raise IndexError unless definiton.nil? or defined_at?(n)

        case n
        when Symbol, String
          segment_vals.select{|s| s.segment_use.segment_def.id == n.to_sym }
        when Integer
          segment_vals.select{|s| s.segment_use.position == n }
        when SegmentDef
          segment_vals.select{|s| s.segment_use == n }
        end or []
      end

      def defined_at?(n)
        return nil if definition.nil?

        case n
        when Symbol, String
          definition.segment_uses.any?{|s| s.segment_def.id == n.to_sym }
        when Integer
          definition.segment_uses.any?{|s| s.position == n }
        when SegmentDef
          definition.segment_uses.any?{|s| s == n }
        else
          raise TypeError
        end
      end
    end

  end
end
