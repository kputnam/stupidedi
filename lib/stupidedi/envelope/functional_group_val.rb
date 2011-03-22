module Stupidedi
  module Envelope

    #
    # @see X222.pdf B.1.1.3.13 Functional Group
    # @see X222.pdf B.1.1.4.2 Functional Groups
    #
    class FunctionalGroupVal < Values::AbstractVal
      include Values::SegmentValGroup
      include Inspect

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

      # @return [FunctionalGroupVal]
      def append(child_val)
        copy(:child_vals => child_val.snoc(@child_vals))
      end
      alias append_segment append
      alias append_transaction_set_val append

      # @return [FunctionalGroupVal]
      def append!(child_val)
        @child_vals = child_val.snoc(@child_vals)
        self
      end
      alias append_segment! append!
      alias append_transaction_set_val! append!

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
