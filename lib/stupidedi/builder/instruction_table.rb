module Stupidedi
  module Builder

    class InstructionTable
      include Inspect

      class NonEmpty < InstructionTable

        def initialize(instructions, pop)
          @instructions, @pop = instructions.freeze, pop

          @__push = Hash.new
          @__drop = Hash.new
        end

        # @return [InstructionTable]
        def copy(changes = {})
          NonEmpty.new \
            changes.fetch(:instructions, @instructions),
            changes.fetch(:pop, @pop)
        end

        # @return [Integer]
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
          # puts "#{object_id}.push(#{object_id})"
            offset = instructions.length
            bottom = @instructions.map{|x| x.copy(:pop_count => x.pop_count + 1) }

            NonEmpty.new(instructions + bottom, self)
          end
        end

        # @return [Array<Instruction>]
        def matches(segment_tok)
          @__matches ||= begin
          # puts "#{object_id}.constraints"
            constraints = Hash.new

            # Group instructions by segment identifier
            grouped = Hash.new{|h,k| h[k] = [] }
            @instructions.each{|x| grouped[x.segment_id] << x }

            # For each group of instructions that have the same segment
            # id, build a constraint table that can distinguish them
            grouped.each do |segment_id, instructions|
              constraints[segment_id] = ConstraintTable.build(instructions)
            end

            constraints
          end

          if @__matches.defined_at?(segment_tok.id)
            @__matches.at(segment_tok.id).matches(segment_tok)
          else
            []
          end
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
              # puts "#{object_id}.drop(#{count})"
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

                NonEmpty.new(result, @pop)
              else
              # puts "#{object_id}.drop(#{count} = drop(#{smallest}).drop(#{count - smallest})"
                drop(smallest).drop(count - smallest)
              end
            end
          end
        end

        # @return [void]
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
        # @return [Empty]
        def copy(changes = {})
          self
        end

        # @return [Integer]
        def length
          0
        end

        # @return nil
        def at(segment_use)
          nil
        end

        # @return [NonEmpty]
        def push(instructions)
          InstructionTable::NonEmpty.new(instructions, self)
        end

        def matches(segment_tok)
          raise "@todo"
        end

        # @return [Empty]
        def pop(count)
          if count.zero?
            self
          else
            raise "@todo"
          end
        end

        # @return [Empty]
        def drop(count)
          self
        end

        # @return [void]
        def pretty_print(q)
          q.text "InstructionTable.empty"
        end
      end.new

    end

    class << InstructionTable

      # @return [InstructionTable::Empty]
      def empty
        InstructionTable::Empty
      end

      # @return [InstructionTable::NonEmpty]
      def build(instructions)
        InstructionTable::Empty.push(instructions)
      end
    end
  end
end
