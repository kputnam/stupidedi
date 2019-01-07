# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Parser
    class AbstractState
      include Inspect

      # @return [Reader::Separators]
      abstract :separators

      # @return [Reader::SegmentDict]
      abstract :segment_dict

      # @return [Zipper::AbstractCursor<Values::SegmentVal>]
      abstract :zipper

      # @return [Array<AbstractState>]
      abstract :children

      # @return [InstructionTable]
      abstract :instructions

      def leaf?
        false
      end

      # @return [void]
      def pretty_print(q)
        q.text self.class.name.split("::").last
        q.group(2, "(", ")") do
          q.breakable ""

          children.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end
        end
      end
    end

    class << AbstractState
      # @group Constructors
      #########################################################################

      # @return [Zipper::AbstractCursor]
      abstract :push, :args => %w(zipper parent segment_tok segment_use config)

      # @group SegmentVal Construction
      #########################################################################

      # @return [Values::SegmentVal]
      def mksegment(segment_tok, segment_use)
        segment_def  = segment_use.definition
        element_uses = segment_def.element_uses
        element_toks = segment_tok.element_toks

        position     = segment_tok.position
        element_vals = []
        element_idx  = "00"
        element_uses.zip(element_toks) do |element_use, element_tok|
          # element_idx.succ!
          element_idx = element_idx.succ
          position = element_tok.position if element_tok

          element_vals <<
            if element_tok.nil?
              if element_use.repeatable?
                Values::RepeatedElementVal.empty(element_use)
              else
                element_use.empty(position)
              end
            else
              mkelement("#{segment_def.id}#{element_idx}", element_use, element_tok)
            end
        end

        segment_use.value(element_vals, segment_tok.position)
      end

      # @return [Values::SimpleElementVal, Values::CompositeElementVal, Values::RepeatedElementVal]
      def mkelement(designator, element_use, element_tok)
        if element_use.simple?
          if element_use.repeatable?
            element_toks = element_tok.element_toks
            element_vals = element_toks.map do |element_tok1|
              mksimple(designator, element_use, element_tok1)
            end

            mkrepeated(designator, element_use, element_vals)
          else
            mksimple(designator, element_use, element_tok)
          end
        else
          if element_use.repeatable?
            element_toks = element_tok.element_toks
            element_vals = element_toks.map do |element_tok1|
              mkcomposite(designator, element_use, element_tok1)
            end

            mkrepeated(designator, element_use, element_vals)
          else
            mkcomposite(designator, element_use, element_tok)
          end
        end
      end

      # @return [Values::RepeatedElementVal]
      def mkrepeated(designator, element_use, element_vals)
        # @todo: Position
        Values::RepeatedElementVal.build(element_vals, element_use)
      end

      # @return [Values::CompositeElementVal]
      def mkcomposite(designator, composite_use, composite_tok)
        composite_def  = composite_use.definition
        component_uses = composite_def.component_uses
        component_toks = composite_tok.component_toks

        position       = composite_tok.position
        component_vals = []
        component_idx  = "00"
        component_uses.zip(component_toks) do |component_use, component_tok|
          # component_idx.succ!
          component_idx = component_idx.succ
          position = component_tok.position if component_tok

          component_vals <<
            if component_tok.nil?
              component_use.empty(position)
            else
              mksimple("#{designator}-#{component_idx}", component_use, component_tok)
            end
        end

        composite_use.value(component_vals, composite_tok.position)
      end

      # @return [Values::SimpleElementVal]
      def mksimple(designator, element_use, element_tok)
        # We don't validate that element_tok is simple because the TokenReader
        # will always produce a SimpleElementTok given a SimpleElementUse from
        # the SegmentDef. On the other hand, the BuilderDsl API will throw an
        # exception if the programmer constructs the wrong kind of element
        # according to the SegmentDef.

        if element_tok.value == :default
          allowed_vals = element_use.allowed_values

          if element_use.requirement.forbidden?
            element_use.empty(element_tok.position)
          elsif allowed_vals.empty?
            element_use.empty(element_tok.position)
          elsif allowed_vals.size == 1
            element_use.value(allowed_vals.first, element_tok.position)
          else
            raise Exceptions::ParseError,
              "#{designator} cannot be inferred"
          end
        elsif element_tok.value == :not_used
          if element_use.requirement.forbidden?
            element_use.empty(element_tok.position)
          else
            raise Exceptions::ParseError,
              "#{designator} is not forbidden"
          end
        elsif element_tok.value == :blank
          element_use.empty(element_tok.position)
        else
          element_use.value(element_tok.value, element_tok.position)
        end
      end

      # @group Instruction Generation
      #########################################################################

      # Builds a sequence of {Instruction} values that corresponds to the given
      # sequence of `segment_uses`
      #
      # @return [Array<Instruction>]
      def sequence(segment_uses, offset = 0)
        instructions = []
        buffer       = []
        last         = nil

        segment_uses.each do |s|
          unless last.nil? or s.position == last.position
            drop_count =
              if buffer.length == 1 and not last.repeatable?
                offset
              else
                offset - buffer.length
              end

            buffer.each do |u|
              instructions << Instruction.new(nil, u, 0, drop_count, nil)
            end

            buffer.clear
          end

          buffer << s
          last    = s
          offset += 1
        end

        # Flush the buffer one last time
        unless buffer.empty?
          drop_count =
            if buffer.length == 1 and not last.repeatable?
              offset
            else
              offset - buffer.length
            end

          buffer.each do |u|
            instructions << Instruction.new(nil, u, 0, drop_count, nil)
          end
        end

        instructions
      end

      # Builds a sequence of {Instruction} values that corresponds to the given
      # sequence of `loop_defs`
      #
      # @return [Array<Instruction>]
      def lsequence(loop_defs, offset = 0)
        instructions = []
        buffer       = []
        last         = nil

        loop_defs.each do |l|
          unless last.nil? or l.entry_segment_use.position == last.entry_segment_use.position
            drop_count =
              if buffer.length == 1 and not last.repeatable?
                offset
              else
                offset - buffer.length
              end

            buffer.each do |u|
              instructions << Instruction.new(nil, u, 0, drop_count, LoopState)
            end
            buffer.clear
          end

          buffer << l.entry_segment_use
          last    = l
          offset += 1
        end

        # Flush the buffer one last time
        unless buffer.nil?
          drop_count =
            if buffer.length == 1 and not last.repeatable?
              offset
            else
              offset - buffer.length
            end

          buffer.each do |u|
            instructions << Instruction.new(nil, u, 0, drop_count, LoopState)
          end
        end

        instructions
      end

      # Builds a sequence of {Instruction} values that corresponds to the given
      # sequence of `table_defs`
      #
      # @return [Array<Instruction>]
      def tsequence(table_defs, offset = 0)
        instructions = []
        buffer       = []
        last         = nil

        table_defs.each do |t|
          unless last.nil? or t.position == last.position
            drop_count =
              if buffer.length == 1 and not last.repeatable?
                offset
              else
                offset - buffer.inject(0){|n,b| n + b.entry_segment_uses.length }
              end

            buffer.each do |b|
              if b.repeatable? and b.entry_segment_uses.length > 1
                raise Exceptions::InvalidSchemaError,
                  "@todo"
              end

              b.entry_segment_uses.each do |u|
                instructions << Instruction.new(nil, u, 0, drop_count, TableState)
              end
            end

            buffer.clear
          end

          last    = t
          offset += t.entry_segment_uses.length
          buffer << t
        end

        unless buffer.empty?
          drop_count =
            if buffer.length == 1 and not last.repeatable?
              offset
            else
              offset - buffer.inject(0){|n,b| n + b.entry_segment_uses.length }
            end

          buffer.each do |b|
            b.entry_segment_uses.each do |u|
              instructions << Instruction.new(nil, u, 0, drop_count, TableState)
            end
          end
        end

        instructions
      end

      # @endgroup
      #########################################################################
    end
  end
end
