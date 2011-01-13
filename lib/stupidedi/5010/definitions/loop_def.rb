module Stupidedi
  module FiftyTen
    module Definitions

      #
      # See X12.6 Section 3.8.3.2.1 "Unbounded Loops"
      #
      class LoopDef
        attr_reader :name

        attr_reader :repetition_count

        attr_reader :segment_uses

        # Nested loop definitions
        attr_reader :loop_defs

        def initialize(name, repetition_count, *children)
          @name, @repetition_count  = name, repetition_count
          @segment_uses, @loop_defs = children.split_when{|c| c.is_a?(LoopDef) }

          unless @repetition_count.is_a?(LoopRepetition)
            raise TypeError, "Second argument must be a kind of LoopRepetition"
          end

          unless @segment_uses.all?{|c| c.is_a?(SegmentUse) }
            raise TypeError, "Only SegmentUse values may preceed LoopDef values"
          end

          unless @loop_defs.all?{|c| c.is_a?(LoopDef) }
            raise TypeError, "Only LoopDef values may follow LoopDef values"
          end

          unless @segment_uses.head.repetition_count.once?
            raise ArgumentError, "First segment in a loop cannot be repeated"
          end

          offsets = @segment_uses.map(&:offset)

          unless offsets.uniq == offsets
            raise ArgumentError, "Segment offsets must be unique"
          end

          unless offsets == offsets.sort
            raise ArgumentError,
              "Segments must be given in order of increasing offsets"
          end

        end

        def required?
          @segment_uses.head.required?
        end

        def reader(input, interchange_header)
          Readers::LoopReader.new(input, interchange_header, self)
        end

        # @private
        def tail
          self.class.new(@name, @repetition_count,
                         *(@segment_uses + @loop_defs).tail)
        end

        def flatten
          @segment_uses + @loop_defs.map(&:flatten).flatten
        end
      end

    end
  end
end
