module Stupidedi
  module Builder

    class AbstractState
      include Inspect

      # @return [Zipper::AbstractCursor]
      abstract :zipper

      # @return [AbstractState]
      abstract :parent

      # @return [InstructionTable]
      abstract :instructions

      # @return [AbstractState]
      abstract :pop, :args => %w(count)

      # @return [AbstractState]
      abstract :drop, :args => %w(count)

      # @return [AbstractState]
      abstract :add, :args => %w(segment_tok segment_use)

      def pop(count)
        if count.zero?
          self
        else
          parent.copy(:zipper => zipper.up).pop(count - 1)
        end
      end

      # @return [Reader::Separators]
      def separators
        parent.separators
      end

      # @return [Reader::SegmentDict]
      def segment_dict
        parent.segment_dict
      end

      # @return [Config::RootConfig]
      def config
        parent.config
      end

      def failure?
        false
      end

      # @return [void]
      def pretty_print(q)
        q.text self.class.name.split('::').last
        q.group(2, "(", ")") do
          q.breakable ""
          q.pp zipper.node
        end
      end

    private

      # @return [Values::SegmentVal]
      def segment(segment_tok, segment_use)
        AbstractState.segment(segment_tok, segment_use)
      end
    end

    class << AbstractState

      # @group Constructor Methods
      #########################################################################

      # This method constructs a new instance of (a subclass of) {AbstractState}
      # and pushes it above {#parent} onto a nested stack-like structure. The
      # stack structure is implicit, and it can be iterated by following each
      # state's {#parent}.
      #
      # @return [AbstractState]
      abstract :push, :args => %w(segment_tok segment_use parent reader)

      # @endgroup
      #########################################################################

      #########################################################################
      # @group SegmentVal Construction

      # @return [Values::SegmentVal]
      def segment(segment_tok, segment_use)
        segment_def  = segment_use.definition
        element_uses = segment_def.element_uses
        element_toks = segment_tok.element_toks

        element_vals = []
        element_idx  = "00"
        element_uses.zip(element_toks) do |element_use, element_tok|
          element_idx.succ!

          element_vals <<
            if element_tok.nil?
              if element_use.repeatable?
                Values::RepeatedElementVal.empty(element_use.definition, element_use)
              else
                element_use.empty
              end
            else
              element("#{segment_def.id}#{element_idx}", element_use, element_tok)
            end
        end

        segment_use.value(element_vals)
      end

      # @return [Values::SimpleElementVal, Values::CompositeElementVal, Values::RepeatedElementVal]
      def element(designator, element_use, element_tok)
        if element_use.simple?
          if element_use.repeatable?
            element_toks = element_tok.element_toks
            element_vals = element_toks.map do |element_tok|
              simple_element(designator, element_use, element_tok)
            end

            repeated_element(designator, element_use, element_vals)
          else
            simple_element(designator, element_use, element_tok)
          end
        else
          if element_use.repeatable?
            element_toks = element_tok.element_toks
            element_vals = element_toks.map do |element_tok|
              composite_element(designator, element_use, element_tok)
            end

            repeated_element(designator, element_use, element_vals)
          else
            composite_element(designator, element_use, element_tok)
          end
        end
      end

      # @return [Values::RepeatedElementVal]
      def repeated_element(designator, element_use, element_vals)
        # @todo: Position
        Values::RepeatedElementVal.build(element_use.definition, element_vals, element_use)
      end

      # @return [Values::CompositeElementVal]
      def composite_element(designator, composite_use, composite_tok)
        composite_def  = composite_use.definition
        component_uses = composite_def.component_uses
        component_toks = composite_tok.component_toks

        component_vals = []
        component_idx  = "00"
        component_uses.zip(component_toks) do |component_use, component_tok|
          component_idx.succ!

          component_vals <<
            if component_tok.nil?
              component_use.empty
            else
              simple_element("#{designator}-#{component_idx}", component_use, component_tok)
            end
        end

        # @todo: Position
        composite_use.value(component_vals)
      end

      # @return [Values::SimpleElementVal]
      def simple_element(designator, element_use, element_tok)
        # We don't validate that element_tok is simple because the TokenReader
        # will always produce a SimpleElementTok given a SimpleElementUse from
        # the SegmentDef. On the other hand, the BuilderDsl API will throw an
        # exception if the programmer constructs the wrong kind of element
        # according to the SegmentDef.

        # @todo: Position
        if element_tok.value == :default
          allowed_vals = element_use.allowed_values

          if element_use.requirement.forbidden?
            element_use.empty
          elsif allowed_vals.empty?
            element_use.empty
          elsif allowed_vals.size == 1
            element_use.value(allowed_vals.first)
          else
            raise Exceptions::ParseError,
              "Element #{designator} cannot be inferred"
          end
        elsif element_tok.value == :not_used
          if element_use.requirement.forbidden?
            element_use.empty
          else
            raise Exceptions::ParseError,
              "Element #{designator} is not forbidden"
          end
        else
          element_use.value(element_tok.value)
        end
      end

      # @endgroup
      #########################################################################

      #########################################################################
      # @group Instruction Generation

      # @return [Array<Instruction>]
      def sequence(segment_uses, start = 0)
        instructions = []
        buffer       = []
        count        = start
        last         = nil

        segment_uses.each do |use|
          unless last.nil? or use.position == last.position
            d =
              if buffer.length == 1 and not last.repeatable?
                count
              else
                count - buffer.length
              end

            buffer.each{|u| instructions << Instruction.new(nil, u, 0, d, nil) }
            buffer.clear
          end

          last  = use
          count += 1
          buffer << use
        end

        unless buffer.empty?
          d =
            if buffer.length == 1 and not last.repeatable?
              count
            else
              count - buffer.length
            end

          buffer.each{|u| instructions << Instruction.new(nil, u, 0, d, nil) }
        end

        instructions
      end

      # @return [Array<Instruction>]
      def lsequence(loop_defs, start = 0)
        instructions = []
        buffer       = []
        count        = start
        last         = nil

        loop_defs.each do |l|
          unless last.nil? or l.entry_segment_use.position == last.entry_segment_use.position
            d =
              if buffer.length == 1 and not last.repeatable?
                count
              else
                count - buffer.length
              end

            buffer.each{|u| instructions << Instruction.new(nil, u, 0, d, LoopState) }
            buffer.clear
          end

          last = l
          count += 1
          buffer << l.entry_segment_use
        end

        unless buffer.nil?
          d =
            if buffer.length == 1 and not last.repeatable?
              count
            else
              count - buffer.length
            end

          buffer.each{|u| instructions << Instruction.new(nil, u, 0, d, LoopState) }
        end

        instructions
      end

      # @return [Array<Instruction>]
      def tsequence(table_defs, start = 0)
        instructions = []
        buffer       = []
        count        = start
        last         = nil

        table_defs.each do |t|
          unless last.nil? or t.position == last.position
            d =
              if buffer.length == 1 and not last.repeatable?
                count
              else
                count - buffer.inject(0){|n,b| n + b.entry_segment_uses.length }
              end

            buffer.each do |b|
              if b.repeatable? and b.entry_segment_uses.length > 1
                raise "@todo"
              end

              b.entry_segment_uses.each do |u|
                instructions << Instruction.new(nil, u, 0, d, TableState)
              end
            end

            buffer.clear
          end

          last    = t
          count  += t.entry_segment_uses.length
          buffer << t
        end

        unless buffer.empty?
          d =
            if buffer.length == 1 and not last.repeatable?
              count
            else
              count - buffer.inject(0){|n,b| n + b.entry_segment_uses.length }
            end

          buffer.each do |b|
            b.entry_segment_uses.each do |u|
              instructions << Instruction.new(nil, u, 0, d, TableState)
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
