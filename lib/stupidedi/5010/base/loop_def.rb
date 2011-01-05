module Stupidedi
  module FiftyTen
    module Base

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
        attr_reader \
          :name,
          :repetition_count,
          :segment_uses

        def initialize(name, repetition_count, *segment_uses)
          @name, @repetition_count, @segment_uses = name, repetition_count, segment_uses
        end

        def tail
          self.class.new(@name, @repetition_count, *@segment_uses.tail)
        end

        def reader(input, interchange_header)
          LoopReader.new(input, interchange_header, self)
        end

        def at(offset)
          # TODO
        end

        def replace(offset, segment_use)
          # TODO
        end
      end

    end
  end
end
