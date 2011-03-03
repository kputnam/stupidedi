module Stupidedi
  module Envelope

    class FunctionalGroupVal < Values::AbstractVal
      include Values::SegmentValGroup

      # @return [FunctionalGroupDef]
      attr_reader :definition

      # @return [Array<SegmentVal>]
      attr_reader :header_segment_vals

      # @return [Array<SegmentVal>]
      attr_reader :trailer_segment_vals

      # @return [Array<TransactionSetVal>]
      attr_reader :transaction_set_vals

      # @return [InterchangeVal]
      attr_reader :parent

      def initialize(definition, header_segment_vals, transaction_set_vals, trailer_segment_vals, parent)
        @definition, @header_segment_vals, @transaction_set_vals, @trailer_segment_vals, @parent =
          definition, header_segment_vals, transaction_set_vals, trailer_segment_vals, parent

        @header_segment_vals  = header_segment_vals.map{|x| x.copy(:parent => self) }
        @trailer_segment_vals = trailer_segment_vals.map{|x| x.copy(:parent => self) }
        @transaction_set_vals = transaction_set_vals.map{|x| x.copy(:parent => self) }
      end

      # @return [FunctionalGroupVal]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:header_segment_vals, @header_segment_vals),
          changes.fetch(:transaction_set_vals, @transaction_set_vals),
          changes.fetch(:trailer_segment_vals, @trailer_segment_vals),
          changes.fetch(:parent, @parent)
      end

      # @return [Array<SegmentVal>]
      def segment_vals
        @header_segment_vals + @trailer_segment_vals
      end

      def empty?
        @header_segment_vals.all(&:empty?) and
        @trailer_segment_vals.all(&:empty?) and
        @transaction_set_vals.all(&:empty?)
      end

      def append_header(segment_val)
        copy(:header_segment_vals => segment_val.snoc(@header_segment_vals))
      end

      def append_transaction_set(transaction_set_val)
        copy(:transaction_set_val => transaction_set_val.snoc(@transaction_set_vals))
      end

      def append_trailer(segment_val)
        copy(:transaction_set_vals => segment_val.snoc(@transaction_set_vals))
      end

      def version
        if at(6) == "X"
          at(7).to_s.slice(0, 3)
        end
      end

      def release
        if at(6) == "X"
          at(7).to_s.slice(0, 4)
        end
      end

      def subrelease
        if at(6) == "X"
          at(7).to_s.slice(0, 5)
        end
      end

      def implementation
        if at(6) == "X"
          at(7).to_s.slice(6, 4)
        end
      end

      # @private
      def pretty_print(q)
        id = @definition.try{|d| "[#{d.id}]" }
        q.text "FunctionalGroupVal#{id}"
        q.group 2, "(", ")" do
          q.breakable ""
          @header_segment_vals.each do |e|
            unless q.current_group.first?
              q.text ", "
              q.breakable
            end
            q.pp e
          end
          @transaction_set_vals.each do |e|
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
    end

  end
end
