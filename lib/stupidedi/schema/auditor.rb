require "stupidedi"

module Stupidedi
  using Refinements

  module Schema

    class Auditor
      include Color
      include Builder::Tokenization

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

      # Throw an exception if the transaction set definition has any ambiguity
      # that could cause non-deterministic parser state.
      def audit
        while cursor = @queue.shift
          step(Stupidedi::Builder::StateMachine.new(@config, [cursor]))
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
        #     b::Segment(100, s::ST, "Transaction Set Header",
        #     b::Segment(200, s::BPR, "Financial Information",<Paste>
        #     b::Segment(400, s::TRN, "Reassociation Trace Number",
        #     b::Segment(500, s::CUR, "Foreign Currency Information",
        #     b::Segment(600, s::REF, "Receiver Identification",
        #     b::Segment(600, s::REF, "Version Identification",
        #     b::Segment(700, s::DTM, "Production Date",
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

        id = zipper.node.instructions.hash

        unless @queued.member?(id)
          @queued.add(id)
          @queue.push(zipper)
          # puts "Queued: #{pp_zipper(zipper)}: #{id}"
        end
      end

      # Starting from the given deterministic `StateMachine`, evaluate each of
      # its `#successors` to detect when an input could make it impossible to
      # choose only a single successor state, due to ambiguity in the definition
      # of the transaction set. If this situation is detected, an exception will
      # be thrown.
      #
      # Otherwise, for each successor, generate the corresponding segment and
      # add the resulting StateMachine to the queue to be checked recursively.
      def step(machine)
        # @todo: when segment_id is :ISA, :GS, or :ST, use the correct values?
        machine.successors.head.constraints.each do |segment_id, table|
          case table
          when Stupidedi::Builder::ConstraintTable::Shallowest,
               Stupidedi::Builder::ConstraintTable::Deepest
            segment_tok =
              mksegment_tok(@reader.segment_dict, segment_id, @elements[segment_id], nil)

            op = table.matches(segment_tok, false).head
            as = machine.execute(op, machine.active.head, @reader, segment_tok)
            enqueue(as)

          when Stupidedi::Builder::ConstraintTable::Stub
            if table.instructions.length == 1
              segment_tok =
                mksegment_tok(@reader.segment_dict, segment_id, @elements[segment_id], nil)

              op = table.matches(nil, false).head
              as = machine.execute(op, machine.active.head, @reader, segment_tok)
              enqueue(as)
            else
              raise Exceptions::InvalidSchemaError,
                "proceeding from [#{pp_machine(machine)}], there are no "   +
                "constraints on segment #{segment_id} to choose between:\n" +
                table.instructions.map{|x| pp_instruction(x) }.join
            end

          when Stupidedi::Builder::ConstraintTable::ValueBased
            disjoint, distinct = table.basis(table.instructions)

            if disjoint.empty?
              # We're definitely going to throw an error now, but we need to
              # get more information to make a useful error message. First
              # check that interesting elements are required
              designators = optional_elements(distinct, table.instructions)

              case designators.length
              when 0
              when 1
                raise Exceptions::InvalidSchemaError,
                  "proceeding from [#{pp_machine(machine)}], the element " +
                  "#{designators.join(", ")} is designated optional, but " +
                  "is necessary to choose between:\n" +
                  table.instructions.map{|x| pp_instruction(x) }.join
              else
                raise Exceptions::InvalidSchemaError,
                  "proceeding from [#{pp_machine(machine)}], the elements " +
                  "#{designators.join(", ")} are designated optional, but " +
                  "at least one is necessary to choose between:\n" +
                  table.instructions.map{|x| pp_instruction(x) }.join
              end

              # Next report cases of element values that cause ambiguity
              designators, ex_designator, ex_value, ex_instructions =
                distinct_elements(distinct, table.instructions)

              case designators.length
              when 0
                raise Exceptions::InvalidSchemaError,
                  "proceeding from [#{pp_machine(machine)}], there are no " +
                  "constraints on segment #{segment_id} to choose "         +
                  "between:\n" + table.instructions.map{|x| pp_instruction(x) }.join
              when 1
                raise Exceptions::InvalidSchemaError,
                  "proceeding from [#{pp_machine(machine)}], the element "  +
                  "#{ex_designator} has overlapping values among possible " +
                  "choices; for example when it has value the #{ex_value}, "+
                  "it is not possible to choose between:\n" +
                  ex_instructions.map{|x| pp_instruction(x) }.join
              else
                raise Exceptions::InvalidSchemaError,
                  "proceeding from [#{pp_machine(machine)}], the elements " +
                  "#{designators.join(", ")} each have overlapping values " +
                  "among choices; for example when #{ex_designator} has "   +
                  "the value #{ex_value}, it is not possible to choose "    +
                  "between:\n" + ex_instructions.map{|x| pp_instruction(x) }.join
              end
            else
              # It's possible there is no ambiguity here, but we need to check
              designators = optional_elements(disjoint, table.instructions)

              case designators.length
              when 0
              when 1
                raise Exceptions::InvalidSchemaError,
                  "proceeding from [#{pp_machine(machine)}], the element "  +
                  "#{designators.join(", ")} is designated optional in at " +
                  "least one case, but is necessary to choose between:\n"   +
                  table.instructions.map{|x| pp_instruction(x) }.join
              else
                raise Exceptions::InvalidSchemaError,
                  "proceeding from [#{pp_machine(machine)}], the elements "  +
                  "#{designators.join(", ")} are designated optional in at " +
                  "least one case each, but at least one is necessary to "   +
                  "choose between:\n" +
                  table.instructions.map{|x| pp_instruction(x) }.join
              end

              mksegments(table).each do |op, segment_tok|
                enqueue(machine.execute(op, machine.active.head, @reader, segment_tok))
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
        disjoint,   = table.basis(table.instructions)
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
            designators << "#{segment_id}-#{'%02d' % (m+1)}#{n.try{'-%02d' % (n+1)}}"
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
            "#{instructions.head.segment_use.id}-#{'%02d' % (m+1)}#{n.try{'-%02d' % (n+1)}}"

          if ex_designator.nil?
            ex_designator             = designators.last
            ex_value, ex_instructions = map.max_by{|_, v| v.length }
          end
        end

        return designators, ex_designator, ex_value, ex_instructions
      end

      # @return [String]
      def pp_machine(machine)
        pp_zipper(machine.active.head)
      end

      # @return [String]
      def pp_zipper(zipper)
        segment = zipper.node.zipper.node

        if segment.valid?
          id    = '% 3s' % segment.definition.id.to_s
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

          ansi.segment("SegmentVal[#{ansi.bold(id)}](#{args})")
        else
          segment.pretty_inspect
        end
      end

      # @return [String]
      def pp_instruction(op)
        id = '% 3s' % op.segment_id.to_s

        unless op.segment_use.nil?
          width = 30
          name  = op.segment_use.definition.name

          # Truncate the segment name to `width` characters
          if name.length > width - 2
            id = id + ": #{name.slice(0, width - 2)}.."
          else
            id = id + ": #{name.ljust(width)}"
          end
        end

        args = "position:%d, repeat:%s, pop:%d" %
          [op.segment_use.position,
           op.segment_use.repeat_count.inspect,
           op.pop_count]

        unless op.push.nil?
          args += ", push:#{op.push.try{|c| c.name.split('::').last}}"
        end

        "  Instruction[#{id}](#{args})\n"
      end
    end

    class << Auditor

      def build(definition)
        # Use dummy identifiers to link definition to the parser
        config  = mkconfig(definition, "ISA11", "GS01", "GS08", "ST01")
        builder = Builder::BuilderDsl.new(
          Builder::StateMachine.build(config, Zipper::Stack), false)

        # These lists of elements are re-used when Auditor needs to construct
        # an ISA, GS, or ST segment as it walks the definition.
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

      def mkconfig(definition, isa11, gs01, gs08, st01)
        segment = definition.table_defs.head.header_segment_uses.head.definition

        # Infer the FunctionalGroupDef based on the given `definition`
        element = segment.element_uses.head.definition
        version = element.class.name.split('::').slice(0..-3)
        grpdefn = Object.const_get("FunctionalGroupDef".snoc(version).join('::'))

        Config.new.customize do |c|
          c.interchange.customize do |x|
            # We can use whatever interchange version we like, it does not
            # have any bearing or relationship to the given `definition`
            x.register(isa11, Versions::Interchanges::FiveOhOne::InterchangeDef)
          end

          c.functional_group.customize do |x|
            x.register(gs08, grpdefn)
          end

          c.transaction_set.customize do |x|
            x.register(gs08, gs01, st01, definition)
          end
        end
      end
    end

  end
end
