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

        # @note Intended for use by LoopReader
        # @private
        def tail
          # This is a tricky way to avoid all the validations done if we called
          # the #initialize constructor. We create an empty instance and do the
          # initialization here instead.
          self.class.allocate.tap do |tail|
            tail.instance_variable_set(:@name, @name)
            tail.instance_variable_set(:@repetition_count, @repetition_count)

            if @segment_uses.empty?
              segment_uses = @segment_uses
              loop_defs    = @loop_defs.tail
            else
              segment_uses = @segment_uses.tail
              loop_defs    = @loop_defs
            end

            tail.instance_variable_set(:@segment_uses, segment_uses)
            tail.instance_variable_set(:@loop_defs, loop_defs)
          end
        end

        def flatten
          @segment_uses + @loop_defs.map(&:flatten).flatten
        end
      end

    end
  end
end
