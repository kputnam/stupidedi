module Stupidedi
  module Builder

    class TableBuilder < AbstractState
      
      # @return [TableVal]
      attr_reader :value

      # @return [TransactionSetBuilder]
      attr_reader :predecessor

      def initialize(position, table_val, predecessor)
        @position, @value, @predecessor =
          position, table_val, predecessor
      end

      # @return [TableBuilder]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:position, @position),
          changes.fetch(:value, @value),
          changes.fetch(:predecessor, @predecessor)
      end

      # @return [TableBuilder]
      def merge(loop_val)
        copy(:value => @value.append_loop(loop_val))
      end

      def terminate
        @predecessor.merge(@value).terminate
      end

      # @return [Array<AbstractState>]
      def successors(segment_tok, upward = true)
        d = @value.definition

        states = d.header_segment_uses.inject([]) do |list, u|
          if @position <= u.position and match?(u, segment_tok)
            value  = @value.append_header_segment(mksegment(u, segment_tok))
            list.push(copy(:position => u.position, :value => value))
          else
            list
          end
        end

        d.loop_defs.each do |l|
          u = l.entry_segment_use.each
          if @position <= u.position and match?(u, segment_tok)
            states.push(LoopBuilder.start(mksegment(u, segment_tok),
                                          copy(:position => u.position)))
          end
        end

        d.trailer_segment_uses do |u|
          if @position <= u.position and match?(u, segment_tok)
            value = @value.append_trailer_segment(mksegment(u, segment_tok))
            states.push(copy(:position => u.position, :value => value))
          end
        end

        # @todo: Highly unsatisfactory hack! When this table contains no header
        # segments but starts with a loop, reading the loop start tag could mean
        # the start of a new loop within the same table, or the start of a new
        # loop within a new table (because "detail" tables can repeat).
        #
        # The ambiguity can never be resolved, so this is one way to force the
        # loop repetitions to stay within a single table when possible.
        if upward and states.empty?
          uncles = @predecessor.merge(@value).successors(segment_tok, true)
          states.concat(uncles.reject(&:stuck?))
        end

        if states.empty?
          failure("Unexpected segment",  segment_tok)
        else
          branches(states)
        end
      end

      # @private
      def pretty_print(q)
        q.text("TableBuilder[@#{@position}]")
        q.group(2, "(", ")") do
          q.breakable ""
          q.pp @value
        end
      end
    end

    class << TableBuilder
      def start(table_def, predecessor)
        position = table_def.entry_segment_uses.head.position
        new(position, table_def.empty(predecessor.value), predecessor)
      end
    end

  end
end
