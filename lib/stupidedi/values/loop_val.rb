module Stupidedi
  module Values

    class LoopVal
      attr_reader :loop_def
      alias_method :definition, :loop_def

      attr_reader :segment_vals

      def initialize(loop_def, *segment_vals)
        @loop_def, @segment_vals = loop_def, segment_vals
      end

      def empty?
        @segment_vals.all?(&:empty?)
      end

      def present?
        not empty?
      end

      def [](n)
        @segment_vals[n]
      end

      # @private
      def ==(other)
        other.definition == @loop_def and
        other.segment_vals == @segment_vals
      end

      # @private
      def pretty_print(q)
        q.text("LoopVal[#]")
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
    end

    #
    # Constructors
    #
    class << LoopVal
      def empty(loop_def)
        LoopVal.new(loop_def, loop_def.segment_uses.map{|u| u.segment_def.empty })
      end
    end

  end
end
