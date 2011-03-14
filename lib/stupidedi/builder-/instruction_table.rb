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
        # @__successors = Hash.new
          @__constraints = Hash.new
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
            print "#{object_id}.push(#{instructions.object_id})"
            offset = instructions.length
            bottom = @instructions.map{|x| x.copy(:pop_count => x.pop_count + 1) }

            x = copy(:instructions => instructions + bottom, :pop => self)
            puts " = #{x.object_id}"
            x
          end
        end

      # # @return [InstructionTable]
      # def reverse(onto = InstructionTable.empty)
      #   @pop.reverse(onto.push(@instructions.init(@pop.length)))
      # end

      # # @return [InstructionTable]
      # def concat(other)
      #   other.reverse.reverse(self)
      # end

        # @return [Array<Instruction>]
        def successors(segment_tok)
          @__successors ||= begin
            puts "#{object_id}.successors"
            hash = Hash.new{|h,k| h[k] = [] }

            @instructions.each{|x| hash[x.segment_id] << x }

            hash.each do |segment_id, instructions|
              unless instructions.length > 1
                next
              end

              # When one of the instructions has a nil segment_use, it means
              # the SegmentUse is determined when pushing the new state. There
              # isn't a way to know the segment constraints from here.
              if instructions.any?{|i| i.segment_use.nil? }
                next
              end

              # The same SegmentUse may appear more than once, because the
              # segment can be placed at different levels in the tree. If
              # all the instructions have the same SegmentUse, we can't use
              # segment constraints to narrow down the instruction list.
              segment_uses = instructions.map{|i| i.segment_use }

              unless segment_uses.map{|u| u.object_id }.uniq.length > 1
                next
              end

              # @todo: Build segment constraints
            end

            hash
          end

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

              # @todo: Explain
              smallest = @instructions.length
              @instructions.each do |i|
                if smallest > i.drop_count and i.drop_count > 0
                  smallest = i.drop_count
                end
              end

              if smallest == count
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

                x = copy(:instructions => result)
                puts "#{object_id}.drop(#{count}) = #{x.object_id}"
                x
              else
                puts "#{object_id}.drop(#{count}) = drop(#{smallest}).drop(#{count - smallest})"
                drop(smallest).drop(count - smallest)
              end
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
        InstructionTable::Empty.push(instructions)
      end
    end
  end
end
