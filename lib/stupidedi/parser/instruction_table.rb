# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Parser
    class InstructionTable
      include Inspect

      class NonEmpty < InstructionTable
        # @return [Array<Instruction>]
        attr_reader :instructions

        def_delegators :@instructions, :length, :empty?

        def initialize(instructions, pop)
          @instructions, @pop = instructions.freeze, pop

          @__push = Hash.new
          @__drop = Hash.new
        end

        def hash
          [NonEmpty, state].hash
        end

        # @return [InstructionTable]
        def copy(changes = {})
          NonEmpty.new \
            changes.fetch(:instructions, @instructions),
            changes.fetch(:pop, @pop)
        end

        # @return [Instruction]
        def at(segment_use)
          @instructions.find{|op| op.segment_use.eql?(segment_use) }
        end

        # @return [InstructionTable]
        def push(instructions)
          @__push[instructions] ||= begin
            bottom = @instructions.map do |op|
              op.copy(:pop_count => op.pop_count + 1)
            end

            NonEmpty.new(instructions + bottom, self)
          end
        end

        # @return [Array<Instruction>]
        def matches(segment_tok, strict = false, mode = :insert)
          if constraints.defined_at?(segment_tok.id)
            constraints.at(segment_tok.id).matches(segment_tok, strict, mode)
          else
            []
          end
        end

        def constraints
          @__constraints ||= begin
            constraints = Hash.new

            # Group instructions by segment identifier
            grouped = Hash.new{|h,k| h[k] = [] }
            @instructions.each{|op| grouped[op.segment_id] << op }

            # For each group of instructions that have the same segment
            # id, build a constraint table that can distinguish them
            grouped.each do |segment_id, instructions|
              constraints[segment_id] = ConstraintTable.build(instructions)
            end

            constraints
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
              # Calculate the fewest number of instructions we can drop. We
              # drop this many to construct the next InstructionTable, from
              # which we drop the remaining number of instructions.
              smallest = @instructions.length
              top = @instructions.take(@instructions.length - @pop.length)
              top.each do |i|
                unless i.drop_count.zero? or smallest < i.drop_count
                  smallest = i.drop_count
                end
              end

              if smallest == count
                # There are no intermediate steps to take, because we can't drop
                # any fewer than the given number of instructions.
                remaining = @instructions.drop(count)

                # Adjust the drop_count for each remaining instruction except
                # those that belong to the parent InstructionTable @pop
                top, pop = remaining.split_at(remaining.length - @pop.length)

                top.map!{|op| op.copy(:drop_count => op.drop_count - count) }
                top.concat(pop)

                NonEmpty.new(top, @pop)
              else
                drop(smallest).drop(count - smallest)
              end
            end
          end
        end

        # @return [void]
        # :nocov:
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

              q.text "#{"% 2s" % index}: "
              q.pp e
            end
          end
        end
        # :nocov:

      private

        def state
          [@instructions, @pop]
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

        def empty?
          true
        end

        # @return nil
        def at(segment_use)
          nil
        end

        # @return [NonEmpty]
        def push(instructions)
          InstructionTable::NonEmpty.new(instructions, self)
        end

        def matches(segment_tok, strict = false, mode = :insert)
          raise Exceptions::ParseError,
            "empty stack"
        end

        # @return [Empty]
        def pop(count)
          if count.zero?
            self
          else
            "empty stack"
          end
        end

        # @return [Empty]
        def drop(count)
          self
        end

        # @return [void]
        # :nocov:
        def pretty_print(q)
          q.text "InstructionTable.empty"
        end
        # :nocov:
      end.new
    end

    class << InstructionTable
      # @group Constructors
      #########################################################################

      # @return [InstructionTable::Empty]
      def empty
        InstructionTable::Empty
      end

      # @return [InstructionTable::NonEmpty]
      def build(instructions)
        empty.push(instructions)
      end

      # @endgroup
      #########################################################################
    end
  end
end
