module Stupidedi
  module FiftyTen
    module Base

      class LoopReader < LoopReader
        include Reader::TokenReader

        attr_reader \
          :input,
          :interchange_header,
          :loop_def

        def initialize(input, interchange_header, loop_def)
          @input, @interchange_header, @loop_def = input, interchange_header, loop_def
        end

        def read_loop
          read_first
        end

        alias read read_loop

      protected

        def read_first
          head, *tail = @loop_def.segment_uses
          read_segment(head.segment_def).flatmap do |r|
            rest = self.class.from_reader(r.remainder, @loop_def.tail)
            rest.read_segments.map do |s|
              s.map{|ss| Values::LoopVal.new(self, r.value.cons(ss)) }
            end
          end
        end

        def read_segments
          if loop_def.segment_uses.empty?
            return result([], @input)
          end

          head, *tail = @loop_def.segment_uses
          read_segment(head.segment_def).flatmap do |r|
            rest = self.class.from_reader(r.remainder, @loop_def)
            rest.read_segments.map{|s| s.map{|ss| r.value.cons(ss) }}
          end.or do
            rest = self.class.from_reader(self, @loop_def.tail)
            rest.read_segments
          end
        end

      private

        def advance(n)
          unless @input.defined_at?(n-1)
            raise IndexError, "Less than #{n} characters available"
          else
            self.class.new(@input.drop(n), @interchange_header, @simple_element_def)
          end
        end
      end

      class << LoopReader
        def from_reader(reader, loop_def)
          LoopReader.new(reader.input, reader.interchange_header, loop_def)
        end
      end

    end
  end
end
