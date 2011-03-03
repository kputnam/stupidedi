module Stupidedi
  module Builder

    class FunctionalGroupBuilder < AbstractState

      # @return [FunctionalGroupVal]
      attr_reader :value

      # @return [InterchangeBuilder]
      attr_reader :predecessor

      def initialize(position, functional_group_val, predecessor)
         @position, @value, @predecessor =
           position, functional_group_val, predecessor
      end

      # @return [FunctionalGroupBuilder]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:position, @position),
          changes.fetch(:value, @value),
          changes.fetch(:predecessor, @predecessor)
      end

      def merge(transaction_set_val)
        copy(:value => @value.append_transaction_set(transaction_set_val))
      end

      # @return [Array<AbstractState>]
      def segment(name, elements)
        case name
        when :ST
          # ST01 Transaction Set Identifier Code
          transaction = elements.at(0).to_s # 835, 837, etc

          # ST03 Implementation Convention Reference
          version = elements.at(2).to_s # 005010X222, etc

          # GS01 Functional Identifier Code
          group = @value.at(:GS).first.at(0).to_s # HC, HP, etc

          if version.blank?
            # GS08 Version / Release / Industry Identifier Code
            version = @value.at(:GS).first.at(7).to_s
          end

          envelope_def = router.transaction_set.lookup(version, group, transaction)

          if envelope_def
            # Construct an empty TransactionSetVal
            transaction_set_val = envelope_def.empty(@value)
            transaction_builder = TransactionSetBuilder.start(transaction_set_val, self)

            # Let the TransactionSetBuilder figure out parsing the ST segment
            branches(transaction_builder.segment(name, elements, false))
          else
            failure("Unrecognized transaction set #{group.inspect} #{transaction.inspect} #{version.inspect}")
          end
        else
          d = @value.definition

          # @todo
          # We add one to the position to ensure if we read the start segment
          # again, it always creates a new InterchangeVal. Otherwise, the left
          # recursion would force branching -- one with the start segment in a
          # new InterchangeVal, the other with the segment repeated in the same
          # InterchangeVal.
          states = d.header_segment_uses.tail.inject([]) do |list, u|
            if @position <= u.position and name == u.definition.id
              value = @value.append_header_segment(construct(u, elements))
              list.push(copy(:position => u.position, :value => value))
            else
              list
            end
          end

          states = d.trailer_segment_uses.inject(states) do |list, u|
            if @position <= u.position and name == u.definition.id
              value = @value.append_trailer_segment(construct(u, elements))
              list.push(copy(:position => u.position, :value => value))
            else
              list
            end
          end

          states.concat(@predecessor.merge(@value).segment(name, elements))

          branches(states)
        end
      end

      # @private
      def pretty_print(q)
        q.text("FunctionalGroupBuilder[@#{@position}]")
        q.group(2, "(", ")") do
          q.breakable ""
          q.pp @value
        end
      end
    end

    class << FunctionalGroupBuilder
      def start(functional_group_val, predecessor)
        position = functional_group_val.definition.header_segment_uses.head.position
        new(position, functional_group_val, predecessor)
      end
    end

  end
end
