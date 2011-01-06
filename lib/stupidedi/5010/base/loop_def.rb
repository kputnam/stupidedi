module Stupidedi
  module FiftyTen
    module Base

      class LoopDef
      end

      #
      # Loops are defined by a sequence of segments. The first SegmentUse
      # in the loop's definition is more significant than any others. Its
      # segment type (eg REF) may not appear elsewhere in the loop, because
      # that would ambiguously signal the start of a new loop. The requirement
      # designator of the first segment indicates if at least one occurence
      # of the loop is mandatory.
      #   See X12.6 Section 3.8.3.2.1 "Unbounded Loops"
      #
      class LoopDef
        attr_reader :name,

        attr_reader :repetition_count

        attr_reader :segment_uses

        attr_reader :loop_defs

        def initialize(name, repetition_count, *children)
          @name, @repetition_count  = name, repetition_count
          @segment_uses, @loop_defs = children.split_when{|c| c.is_a?(LoopDef) }

          unless @repetition_count.is_a?(Designations::LoopRepetition)
            raise TypeError, "Second argument must be a kind of LoopRepetition"
          end

          unless @segment_uses.all?{|c| c.is_a?(SegmentUse) }
            raise TypeError, "Only SegmentUse values may preceed LoopDef values"
          end

          unless @loop_defs.all?{|c| c.is_a?(LoopDef) }
            raise TypeError, "Only LoopDef values may follow LoopDef values"
          end
        end

        def tail
          self.class.new(@name, @repetition_count, *@segment_uses.tail)
        end

        def reader(input, interchange_header)
          LoopReader.new(input, interchange_header, self)
        end
      end

    end
  end
end
