module Stupidedi
  module Envelope

    class FunctionalGroupVal < Values::AbstractVal
      include Values::SegmentValGroup

      # @return [FunctionalGroupDef]
      attr_reader :definition

      # @return [Array<SegmentVal, TransactionSetVal>]
      attr_reader :child_vals

      # @return [InterchangeVal]
      attr_reader :parent

      def initialize(definition, child_vals, parent)
        @definition, @child_vals, @parent =
          definition, child_vals, parent
      end

      # @return [FunctionalGroupVal]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:child_vals, @child_vals),
          changes.fetch(:parent, @parent)
      end

      # @return [Array<SegmentVal>]
      def segment_vals
        @child_vals.select{|x| x.is_a?(Values::SegmentVal) }
      end

      def append(child_val)
        unless child_val.is_a?(TransactionSetVal) or child_val.is_a?(Values::SegmentVal)
          raise TypeError, child_val.class.name
        end

        copy(:child_vals => child_val.snoc(@child_vals))
      end

      # @return [String, nil]
      def version
        if at(6) == "X"
          at(7).to_s.slice(0, 3)
        end
      end

      # @return [String, nil]
      def release
        if at(6) == "X"
          at(7).to_s.slice(0, 4)
        end
      end

      # @return [String, nil]
      def subrelease
        if at(6) == "X"
          at(7).to_s.slice(0, 5)
        end
      end

      # @return [String, nil]
      def implementation
        if at(6) == "X"
          at(7).to_s.slice(6, 4)
        end
      end

      # @return [Module]
      def segment_dict
        @definition.segment_dict
      end

      # @return [void]
      def pretty_print(q)
        id = @definition.try{|d| "[#{d.id}]" }
        q.text "FunctionalGroupVal#{id}"
        q.group 2, "(", ")" do
          q.breakable ""
          @child_vals.each do |e|
            unless q.current_group.first?
              q.text ", "
              q.breakable
            end
            q.pp e
          end
        end
      end
    end

  end
end
