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
      def segment(segment_tok)
        case segment_tok.id
        when :ST
          # ST01 Transaction Set Identifier Code
          # ST03 Implementation Convention Reference
          transaction = segment_tok.element_toks.at(0).value
          version     = segment_tok.element_toks.at(2).value

          # GS01 Functional Identifier Code
          group = @value.at(:GS).first.at(0) # HC, HP, etc

          if version.blank?
            # GS08 Version / Release / Industry Identifier Code
            version = @value.at(:GS).first.at(7)
          end

          envelope_def = config.transaction_set.lookup(version, group, transaction)

          if envelope_def
            # Construct an empty TransactionSetVal
            transaction_set_val = envelope_def.empty(@value)
            transaction_builder = TransactionSetBuilder.start(transaction_set_val, self)

            # Let the TransactionSetBuilder figure out parsing the ST segment
            children = transaction_builder.segment(segment_tok, false)
            states   = children.reject(&:stuck?)

            if states.empty?
              failure("Unexpected segment #{segment_tok.inspect}")
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
            if @position <= u.position and match?(u, segment_tok)
              # @todo: Optimize for deterministic transitions
              value = @value.append_header_segment(mksegment(u, segment_tok))
              list.push(copy(:position => u.position, :value => value))
            else
              list
            end
          end

          d.trailer_segment_uses.each do |u|
            if @position <= u.position and match?(u, segment_tok)
              # @todo: Optimize for deterministic transitions
              value = @value.append_trailer_segment(mksegment(u, segment_tok))
              states.push(copy(:position => u.position, :value => value))
            end
          end

          # Terminate this functional group and try parsing segemnt as a sibling
          # of @value's parent. Supress any stuck "uncle" states because they
          # won't say anything more than the single stuck state we create below.
          # @todo: Optimize for deterministic transitions
          uncles = @predecessor.merge(@value).segment(segment_tok)
          states.concat(uncles.reject(&:stuck?))

          if states.empty?
            failure("Unexpected segment #{segment_tok.inspect}")
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
