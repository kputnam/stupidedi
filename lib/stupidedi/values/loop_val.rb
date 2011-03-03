module Stupidedi
  module Values

    class LoopVal < AbstractVal
      include SegmentValGroup

      attr_reader :definition

      # @return [Array<SegmentVal>]
      attr_reader :header_segment_vals

      # @return [Array<SegmentVal>]
      attr_reader :trailer_segment_vals

      # @return [Array<LoopVal>]
      attr_reader :loop_vals

      # @return [LoopVal, TableVal]
      attr_reader :parent

      def initialize(definition, header_segment_vals, loop_vals, trailer_segment_vals, parent)
        @definition, @header_segment_vals, @loop_vals, @trailer_segment_vals, @parent =
          definition, header_segment_vals, loop_vals, trailer_segment_vals, parent
      end

      # @return [LoopVal]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:header_segment_vals, @header_segment_vals),
          changes.fetch(:loop_vals, @loop_vals),
          changes.fetch(:trailer_segment_vals, @trailer_segment_vals),
          changes.fetch(:parent, @parent)
      end

      def segment_vals
        @header_segment_vals + @trailer_segment_vals
      end

      def empty?
        @header_segment_vals.all?(&:empty?) and
        @loop_vals.all(&:empty?)
        @trailer_segment_vals.all?(&:empty?) and
      end

      def append(val)
        if val.is_a?(LoopVal)
          copy(:loop_vals => val.snoc(@loop_vals))
        else
          if @loop_vals.empty?
            copy(:header_segment_vals => val.snoc(@header_segment_vals))
          else
            copy(:trailer_segment_vals => val.snoc(@trailer_segment_vals))
          end
        end
      end

      def prepend(val)
        if val.is_a?(LoopVal)
          copy(:loop_vals => val.snoc(@loop_vals))
        else
          if @loop_vals.empty?
            copy(:header_segment_vals => val.snoc(@header_segment_vals))
          else
            copy(:trailer_segment_vals => val.snoc(@trailer_segment_vals))
          end
        end
      end

      # @private
      def pretty_print(q)
        id = @definition.try{|l| "[#{l.id}]" }
        q.text("LoopVal#{id}")
        q.group(1, "(", ")") do
          q.breakable ""
          @header_segment_vals.each do |e|
            unless q.current_group.first?
              q.text ", "
              q.breakable
            end
            q.pp e
          end
          @loop_vals.each do |e|
            unless q.current_group.first?
              q.text ", "
              q.breakable
            end
            q.pp e
          end
          @trailer_segment_vals.each do |e|
            unless q.current_group.first?
              q.text ", "
              q.breakable
            end
            q.pp e
          end
        end
      end

      # @private
      def ==(other)
        other.definition           == @definition and
        other.header_segment_vals  == @header_segment_vals and
        other.trailer_segment_vals == @trailer_segment_vals and
        other.loop_vals            == @loop_vals
      end
    end

  end
end
