module Stupidedi
  module Builder_

    #
    #
    #
    class InstructionTable

      class NonEmpty < InstructionTable
        def initialize(instructions, pop)
          @instructions, @pop = instructions.freeze, pop

          @__push = Hash.new
          @__drop = Hash.new
          @__successors = Hash.new
        end

        # @return [InstructionTable]
        def copy(changes = {})
          self.class.new \
            changes.fetch(:instructions, @instructions),
            changes.fetch(:pop, @pop)
        end

        def length
          @instructions.length
        end

        # @return [Instruction]
        def at(segment_use)
          @instructions.find{|x| x.segment_use.eql?(segment_use) }
        end

        # @return [InstructionTable]
        def push(instructions)
          @__push[instructions] ||= begin
            offset = instructions.length
            bottom = @instructions.map{|x| x.copy(:pop_count => x.pop_count + 1) }

            copy(:instructions => instructions + bottom, :pop => self)
          end
        end

        # @return [InstructionTable]
        def reverse(onto = InstructionTable.empty)
          @pop.reverse(onto.push(@instructions.init(@pop.length)))
        end

        # @return [InstructionTable]
        def concat(other)
          other.reverse.reverse(self)
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
          @__successors.fetch(segment_tok.id, [])
        end

        # @return [InstructionTable]
        def pop(count)
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

              if @pop.nil?
                drop   = @instructions.drop(count)
                result =
                  drop.map{|x| x.copy(:drop_count => x.drop_count - count) }
              else
                drop     = @instructions.drop(count)
                top, pop = drop.split_at(drop.length - @pop.length)
                result   =
                  top.map{|x| x.copy(:drop_count => x.drop_count - count) }.
                      concat(pop)
              end

              copy(:instructions => result)
            end
          end
        end

        # @private
        def pretty_print(q)
          q.text("InstructionTable")
          q.group(2, "(", ")") do
            q.breakable ""

            index = 0
            @instructions.each do |e|
              index += 1
              unless q.current_group.first?
                q.text ","
                q.breakable
              end

              q.text "#{'% 2s' % index}: "
              q.pp e
            end
          end
        end
      end

      Empty = Class.new(InstructionTable) do
        def copy(changes = {})
          self
        end

        def length
          0
        end

        def at(segment_use)
          nil
        end

        def push(instructions)
          InstructionTable::NonEmpty.new(instructions, self)
        end

        def reverse(onto = self)
          onto
        end

        def concat(other)
          other
        end

        def successors(segment_tok)
          raise
        end

        def pop(count)
          if count.zero?
            self
          else
            raise
          end
        end

        def drop(count)
          self
        end

        def pretty_print(q)
          q.text "InstructionTable.empty"
        end
      end.new

    end

    class << InstructionTable
      def empty
        InstructionTable::Empty
      end

      def build(instructions)
        InstructionTable::NonEmpty.new(instructions, InstructionTable::Empty)
      end
    end
  end
end
