module Stupidedi
  module FiftyTen
    module Definitions

      class TableDef
        attr_reader :name

        attr_reader :segment_uses

        attr_reader :loop_defs

        def initialize(name, *children)
          @name = name
          @segment_uses, @loop_defs = children.split_when{|c| c.is_a?(LoopDef) }

          unless @segment_uses.all?{|c| c.is_a?(SegmentUse) }
            raise TypeError, "Only SegmentUse values may preceed LoopDef values"
          end

          unless @loop_defs.all?{|c| c.is_a?(LoopDef) }
            raise TypeError, "Only LoopDef values may follow LoopDef values"
          end
        end

        def reader(input, interchange_header)
          # TODO
        end
      end

    end
  end
end
