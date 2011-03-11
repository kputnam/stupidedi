module Stupidedi
  module Builder_

    #
    #
    #
    class InstructionTable

      def initialize(instructions, pop)
        @instructions, @pop = instructions, pop
      end

      # @return [InstructionTable]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:instructions, @instructions),
          changes.fetch(:pop, @pop)
      end

      # @return [InstructionTable]
      def push(instructions)
        @__push[instructions] ||= begin
          offset = instructions.length
          bottom = @instructions.map{|x| x.copy(:pop => x.pop + 1) }

          copy(:instructions => instructions + bottom, :pop => self)
        end
      end

      # @return [Array<Instruction>]
      def successors(segment_tok)
        @__successors ||= begin
          # @todo: Compute segment constraints when the segment identifier
          # alone does not identify a single state.

          @instructions.inject(Hash.new{|h,k| h[k] = [] }) do |hash, x|
            hash[x.segment_id] = x
            hash
          end
        end

        # @todo: Narrow the results down by evaluating segment constraints
        @__successors.fetch(segment_tok, [])
      end

      # @return [InstructionTable]
      def pop(count = 1)
        if count.zero?
          self
        else
          @pop.pop(count - 1)
        end
      end

      # @return [InstructionTable]
      def drop(count)
        if count.zero?
          self
        else
          @__drop[count] ||= begin
            if count > @instructions.length
              raise IndexError,
                "InstructionTable contains less than #{count} entries"
            end

            copy(:instructions =>
              @instructions.drop(count).
                map{|x| x.copy(:drop => x.drop - count) })
          end
        end
      end

      # @private
      def pretty_print(q)
        q.text("InstructionTable")
        q.group(2, "(", ")") do
          @instructions.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end
        end
      end

    end

  end
end
