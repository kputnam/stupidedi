module Stupidedi
  module FiftyTen
    module Base

      class LoopReader
        include Reader::TokenReader
      end

      class UnboundedLoopReader < LoopReader
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
          head, *tail = loop_def.segment_uses
          read_segment(head.segment_def).map do |r|
            r.remainder.read_segments.map do |s|
              s.map{|ss| Values::LoopVal.value(self, r.value.cons(ss)) }
            end
          end
          #.or do
          # result(Values::LoopVal.empty(self))
          #end
        end

        def read_segments
          if loop_def.segment_uses.empty?
            return result([])
          end

          head, *tail = loop_def.segment_uses
          read_segment(head.segment_def).map do |r|
            r.remainder.read_segments.map{|s| s.map{|ss| s.value.cons(ss) }}
          end.or do
            rest = self.class.from_reader(self, loop_def.tail)
            rest.read_segments.map{|s| s.map{|ss| head.segment_def.empty.cons(ss) }}
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

    end
  end
end
