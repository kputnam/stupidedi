module Stupidedi
  module Builder

    class LoopBuilder < AbstractState

      # @return [LoopVal]
      attr_reader :value

      # @return [TableBuilder, LoopBuilder]
      attr_reader :predecessor

      def initialize(position, loop_val, predecessor)
        @position, @value, @predecessor =
          position, loop_val, predecessor
      end

      # @return [LoopBuilder]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:position, @position),
          changes.fetch(:value, @value),
          changes.fetch(:predecessor, @predecessor)
      end

      # @return [LoopBuilder]
      def merge(loop_val)
        copy(:value => @value.append_loop(loop_val))
      end

      # @return [Array<AbstractState>]
      def segment(name, elements, upward = true)
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

        # Try parsing this segment as the start segment of a child loop. Because
        # we check the segment constraints here, we can be sure it doesn't fail.
        d.loop_defs.each do |l|
          l.entry_segment_uses.each do |u|
            if @position <= u.position and match?(u, name, elements)
              states.push(LoopBuilder.start(mksegment(u, elements),
                                            copy(:position => u.position)))
            end
          end
        end

        d.trailer_segment_uses.each do |u|
          if @position <= u.position and match?(u, name, elements)
            value = @value.append_trailer_segment(mksegment(u, elements))
            states.push(copy(:position => u.position, :value => value))
          end
        end

        if upward
          uncles = @predecessor.merge(@value).segment(name, elements)
          states.concat(uncles.reject(&:stuck?))
        end

        if states.empty?
          failure("Unexpected segment #{name}")
        else
          branches(states)
        end
      end

      # @private
      def pretty_print(q)
        q.text("LoopBuilder[@#{@position}]")
        q.group(2, "(", ")") do
          q.breakable ""
          q.pp @value
        end
      end
    end

    class << LoopBuilder
      # @return [LoopBuilder]
      def start(segment_val, predecessor)
        position = segment_val.usage.position
        loop_def = segment_val.usage.parent
        loop_val = loop_def.value(segment_val, predecessor.value)
        new(position, loop_val, predecessor)
      end
    end

  end
end
