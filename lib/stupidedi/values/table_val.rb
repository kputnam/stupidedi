module Stupidedi
  module Values

    class TableVal < AbstractVal
      include SegmentValGroup

      # @return [TableDef]
      attr_reader :definition

      # @return [Array<SegmentVal>]
      attr_reader :segment_vals

      # @return [Array<LoopVal>]
      attr_reader :loop_vals

      # @return [TransactionSetVal]
      attr_reader :parent

      def initialize(definition, segment_vals, loop_vals)
        @definition, @segment_vals, @loop_vals =
          definition, segment_vals, loop_vals
      end

      # @return [TableVal]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:segment_vals, @segment_vals),
          changes.fetch(:loop_vals, @loop_vals)
      end

      def append(val)
        if val.is_a?(LoopVal)
          copy(:loop_vals => val.snoc(@loop_vals))
        else
          copy(:segment_vals => val.snoc(@segment_vals))
        end
      end

      def prepend(val)
        if val.is_a?(LoopVal)
          copy(:loop_vals => val.cons(@loop_vals))
        else
          copy(:segment_vals => val.cons(@segment_vals))
        end
      end

      # @private
      def pretty_print(q)
        id = @definition.try{|t| "[#{t.id}]" }
        q.text("TableVal#{id}")
        q.group(1, "(", ")") do
          q.breakable ""
          @segment_vals.each do |e|
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
        other.definition == @definition and
        other.segment_vals == @segment_vals
      end
    end

  end
end
