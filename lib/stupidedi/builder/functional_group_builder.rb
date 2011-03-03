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

      # @return [FunctionalGroupBuilder]
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

          envelope_def = config.transaction_set.lookup(version, group, transaction)

          if envelope_def
            # Construct an empty TransactionSetVal
            transaction_set_val = envelope_def.empty(@value)
            transaction_builder = TransactionSetBuilder.start(transaction_set_val, self)

            # Let the TransactionSetBuilder figure out parsing the ST segment
            children = transaction_builder.segment(name, elements, false)
            states   = children.reject(&:stuck?)

            if states.empty?
              failure("Unexpected segment ST")
            else
              branches(states)
            end
          else
            failure("Unrecognized transaction set #{group.inspect} #{transaction.inspect} #{version.inspect}")
          end
        else
          d = @value.definition

          # @todo: Explain use of #tail
          states = d.header_segment_uses.tail.inject([]) do |list, u|
            if @position <= u.position and match?(u, name, elements)
              value = @value.append_header_segment(mksegment(u, elements))
              list.push(copy(:position => u.position, :value => value))
            else
              list
            end
          end

          d.trailer_segment_uses do |u|
            if @position <= u.position and match?(u, name, elements)
              value = @value.append_trailer_segment(mksegment(u, elements))
              states.push(copy(:position => u.position, :value => value))
            end
          end

          # Terminate this functional group and try parsing segemnt as a sibling
          # of @value's parent. Supress any stuck "uncle" states because they
          # won't say anything more than the single stuck state we create below.
          uncles = @predecessor.merge(@value).segment(name, elements)
          states.concat(uncles.reject(&:stuck?))

          if states.empty?
            failure("Unexpected segment #{name}")
          else
            branches(states)
          end
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
      # @return [FunctionalGroupBuilder]
      def start(functional_group_val, predecessor)
        position = functional_group_val.definition.header_segment_uses.head.position
        new(position, functional_group_val, predecessor)
      end
    end

  end
end
