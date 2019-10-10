# frozen_string_literal: true
module Stupidedi
  using Refinements

  module TransactionSets
    module Validation
      #
      # @todo
      #
      class Ambiguity
        include Color
        include Parser::Tokenization

        attr_reader :config
        attr_reader :machine
        attr_reader :reader
        attr_reader :queue

        def initialize(machine, reader, isa_elements, gs_elements, st_elements)
          @config  = machine.config
          @reader  = reader
          @queue   = []
          @queued  = Set.new

          @elements       = Hash.new{|h,k| h[k] = [] }
          @elements[:ISA] = isa_elements
          @elements[:GS]  = gs_elements
          @elements[:ST]  = st_elements

          enqueue(machine.active.head)
        end

        def audit
          while cursor = @queue.shift
            step(Stupidedi::Parser::StateMachine.new(@config, [cursor]))
          end
        end

      private

        def enqueue(zipper)
          # Avoid unecessary traversal over instruction tables that we've already
          # queued. NOTE: This means some segments in the definition could be
          # skipped entirely, due to have the same #successors as another segment.
          #
          # For instance, consider HP835's Table 1:
          #
          #   d::TableDef.header("Table 1 - Header",
          #     b::Segment(100, s::ST, "Transaction Set Header", ...)
          #     b::Segment(200, s::BPR, "Financial Information", ...)
          #     b::Segment(400, s::TRN, "Reassociation Trace Number", ...)
          #     b::Segment(500, s::CUR, "Foreign Currency Information", ...)
          #     b::Segment(600, s::REF, "Receiver Identification", ...)
          #     b::Segment(600, s::REF, "Version Identification", ...)
          #     b::Segment(700, s::DTM, "Production Date", ...)
          #
          # It's important to know that two segments at the same position don't
          # come "before" or "after" each other, even though they might be listed
          # in a particular order.
          #
          # Starting at the CUR segment, its successors are the two REF segments
          # and some other stuff. If we generate the first REF segment, due to
          # having the same position (600) as the other REF segment, it also has
          # both REF segments as successors. The second REF segment also has the
          # same set of successors.
          #
          # Therefore, all three segments (CUR, REF, REF) have the same set of
          # successors and it doesn't matter which one we choose; we only need
          # to choose one.
          #
          id = zipper.node.instructions.hash
          unless @queued.member?(id)
            @queued.add(id)
            @queue.push(zipper)
          end
        end

        def step(machine)
          machine.successors.head.constraints.each do |segment_id, table|
            case table
            when Stupidedi::Parser::ConstraintTable::Shallowest,
                 Stupidedi::Parser::ConstraintTable::Deepest
              segment_tok =
                mksegment_tok(@reader.segment_dict, segment_id, @elements[segment_id], nil)

              instructions = table.matches(segment_tok, false, :insert)
              if instructions.length > 1
                raise Exceptions::InvalidSchemaError,
                  "proceeding from #{pp_machine(machine)}, there are no
                  constraints on segment #{segment_id} to choose between ".join +
                  table.pretty_inspect
              end

              op = instructions.head
              as = machine.execute(op, machine.active.head, @reader, segment_tok)
              enqueue(as)

            when Stupidedi::Parser::ConstraintTable::Stub
              if table.instructions.length == 1
                segment_tok =
                  mksegment_tok(@reader.segment_dict, segment_id, @elements[segment_id], nil)

                op = table.matches(nil, false, :insert).head
                as = machine.execute(op, machine.active.head, @reader, segment_tok)
                enqueue(as)
              else
                raise Exceptions::InvalidSchemaError,
                  "stub proceeding from #{pp_machine(machine)}, there are no
                  constraints on segment #{segment_id} to choose between ".join +
                  table.pretty_inspect
              end

            when Stupidedi::Parser::ConstraintTable::ValueBased
              disjoint, distinct = table.basis(table.instructions, :insert)

              if disjoint.empty?
                # We're definitely going to throw an error now, but we need to
                # get more information to make a useful error message. First
                # check that interesting elements are required
                designators = optional_elements(distinct, table.instructions)

                case designators.length
                when 0
                when 1
                  raise Exceptions::InvalidSchemaError,
                    "proceeding from #{pp_machine(machine)}, the element
                    #{designators.join(", ")} is designated optional, but
                    is necessary to choose between ".join + table.pretty_inspect
                else
                  raise Exceptions::InvalidSchemaError,
                    "proceeding from #{pp_machine(machine)}, the elements
                    #{designators.join(", ")} are designated optional, but
                    at least one is necessary to choose between ".join +
                    table.pretty_inspect
                end

                # Next report cases of element values that cause ambiguity
                designators, ex_designator, ex_value, ex_instructions =
                  distinct_elements(distinct, table.instructions)

                case designators.length
                when 0
                  raise Exceptions::InvalidSchemaError,
                    "proceeding from #{pp_machine(machine)}, there are no
                    constraints on segment #{segment_id} to choose
                    between ".join + table.pretty_inspect
                when 1
                  raise Exceptions::InvalidSchemaError,
                    "proceeding from #{pp_machine(machine)}, the element
                    #{ex_designator} has overlapping values among possible
                    choices; for example when it has value the #{ex_value},
                    it is not possible to choose between ".join +
                    table.copy(:instructions => ex_instructions).pretty_inspect
                else
                  raise Exceptions::InvalidSchemaError,
                    "proceeding from #{pp_machine(machine)}, the elements
                    #{designators.join(", ")} each have overlapping values
                    among choices; for example when #{ex_designator} has
                    the value #{ex_value}, it is not possible to choose
                    between ".join + table.copy(:instructions => ex_instructions).pretty_inspect
                end
              else
                # It's possible there is no ambiguity here, but we need to check
                designators = optional_elements(disjoint, table.instructions)

                case designators.length
                when 0
                when 1
                  raise Exceptions::InvalidSchemaError,
                    "proceeding from #{pp_machine(machine)}, the element
                    #{designators.join(", ")} is designated optional in at
                    least one case, but is necessary to choose between ".join +
                    table.pretty_inspect
                else
                  raise Exceptions::InvalidSchemaError,
                    "proceeding from #{pp_machine(machine)}, the elements
                    #{designators.join(", ")} are designated optional in at
                    least one case each, but at least one is necessary to
                    choose between ".join + table.pretty_inspect
                end

                mksegments(table).each do |op_, segment_tok_|
                  enqueue(machine.execute(op_, machine.active.head, @reader, segment_tok_))
                end
              end
            else
              raise "unexpected kind of constraint table: #{constraint_table.class}"
            end
          end
        end

        # For each instruction in the given ConstraintTable::ValueBased, return
        # the segment token which will be matched to that instruction.
        #
        # @return [Array<(Instruction, SegmentTok)>]
        def mksegments(table)
          disjoint,   = table.basis(table.instructions, :insert)
          remaining   = Set.new(table.instructions)
          segment_id  = table.instructions.head.segment_use.id
          segments    = []

          # Scan each interesting element location
          disjoint.each do |(m, n), map|
            if remaining.empty?
              # We've already generated results for each possible instruction
              break
            end

            # Likely many values are mapped to only a few unique keys; in this
            # case, `instructions` is a singleton array (that's what makes the
            # value non-ambiguous, there's only one possible instruction)
            map.each do |value, instructions|
              op,         = instructions
              repeatable  = op.segment_use.definition.element_uses.at(m).repeatable?
              elements    = Array.new(m)
              elements[m] =
                if n.nil?
                  if repeatable
                    repeated(value)
                  else
                    value
                  end
                else
                  components    = Array.new(n)
                  components[n] = value

                  if repeatable
                    repeated(composite(components))
                  else
                    composite(components)
                  end
                end

              if remaining.member?(op)
                remaining.delete(op)
                segments.push([op, mksegment_tok(@reader.segment_dict, segment_id, elements, nil)])
              end
            end
          end

          segments
        end

        # Return a list of element designators that are needed to choose a single
        # instruction, but are not #required? in the transaction set definition.
        #
        # @return [Array<String>]
        def optional_elements(disjoint, instructions)
          designators = []

          disjoint.each do |(m, n), map|
            required = true

            # Element must be required for all possible segment_uses
            instructions.each do |op|
              element_use = op.segment_use.definition.element_uses.at(m)

              if n.nil?
                required &&= element_use.required?
              else
                component_use = element_use.definition.component_uses.at(n)
                required    &&= element_use.required? and component_use.required?
              end
            end

            unless required
              segment_id   = instructions.head.segment_use.id
              designators << "#{segment_id}-#{"%02d" % (m+1)}#{n.try{"-%02d" % (n+1)}}"
            end
          end

          if designators.length < disjoint.length
            # This means at least one designator *was* required, therefore we can
            # be assured that valid input will not be ambiguous
            []
          else
            # None of the useful elements were required, so even valid input (that
            # has none of these elements present), will be ambiguous
            designators
          end
        end

        # Build a list of offending elements (eg, HL-03) and provide an example
        # value that resolves to conflicting instructions.
        #
        # @return [(Array<String>, String, String, Array<Instruction>)]
        def distinct_elements(distinct, instructions)
          designators     = []
          ex_designator   = nil
          ex_value        = nil
          ex_instructions = nil

          distinct.each do |(m, n), map|
            designators <<
              "#{instructions.head.segment_use.id}-#{"%02d" % (m+1)}#{n.try{"-%02d" % (n+1)}}"

            if ex_designator.nil?
              ex_designator             = designators.last
              ex_value, ex_instructions = map.max_by{|_, v| v.length }
            end
          end

          return designators, ex_designator, ex_value, ex_instructions
        end

        # @return [String]
        def pp_machine(machine)
          zipper  = machine.active.head
          segment = zipper.node.zipper.node

          if segment.valid?
            id    = "% 3s" % segment.definition.id.to_s
            name  = segment.definition.name
            width = 18

            if name.length > width - 2
              id = id + ": #{name.slice(0, width - 2)}.."
            else
              id = id + ": #{name}"
            end

            args = "position:%d, repeat:%s" %
              [segment.usage.position,
               segment.usage.repeat_count.inspect]

            ansi.segment("SegmentDef[#{ansi.bold(id)}](#{args})")
          else
            segment.pretty_inspect
          end
        end
      end

      class << Ambiguity
        def build(transaction_set_def, functional_group_def)
          # Use dummy identifiers to link transaction_set_def to the parser
          config  = mkconfig(transaction_set_def, functional_group_def,
                             "ISA11", "GS01", "GS08", "ST01")

          builder = Parser::BuilderDsl.new(Parser.build(config, Zipper::Stack), false)

          # These lists of elements are re-used when Ambiguity needs to construct
          # an ISA, GS, or ST segment as it walks the transaction_set_def
          isa_elements =
            [ "00", "AUTHORIZATION",
              "00", "PASSWORD",
              "ZZ", "SUBMITTER ID",
              "ZZ", "RECEIVER ID",
              "191225", "1230",
              "^",
              "ISA11",
              "123456789", "0", "T", ":" ]

          gs_elements =
            [ "GS01",
              "SENDER ID",
              "RECEIVER ID",
              "20191225", "1230", "1", "X",
              "GS08" ]

          st_elements =
            [ "ST01",
              "1234" ]

          builder.ISA(*isa_elements)
          builder.GS(*gs_elements)
          builder.ST(*st_elements)

          new(builder.machine, builder.reader, isa_elements, gs_elements, st_elements)
        end

        def mkconfig(definition, functional_group_def, isa11, gs01, gs08, st01)
          Config.new.customize do |c|
            c.interchange.customize do |x|
              # We can use whatever interchange version we like, it does not
              # have any bearing or relationship to the given `definition`
              x.register(isa11, Interchanges::FiveOhOne::InterchangeDef)
            end

            c.functional_group.customize do |x|
              x.register(gs08, functional_group_def)
            end

            c.transaction_set.customize do |x|
              x.register(gs08, gs01, st01, definition)
            end
          end
        end
      end
    end
  end
end
