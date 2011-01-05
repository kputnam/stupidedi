module Stupidedi
  module FiftyTen
    module Base

      class SegmentDef
        attr_reader \
          :id,
          :name,
          :element_uses

        def initialize(id, name, *element_uses)
          @id, @name, @element_uses = id, name, element_uses
        end

        def tail
          self.class.new(@id, @name, *@element_uses.tail)
        end

        def empty
          Values::SegmentVal.empty(self)
        end

        def writer(interchange_header)
          # TODO
        end

        def reader(input, interchange_header)
          SegmentReader.new(input, interchange_header, self)
        end

        def segment_use(offset, requirement_designator, repetition_count)
          SegmentUse.new(offset, self, requirement_designator, repetition_count)
        end
      end

    end
  end
end
