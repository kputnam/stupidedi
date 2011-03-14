module Stupidedi
  module Builder_

    class AbstractState

      # Each {AbstractState} subclass is responsible for building up a specific
      # type of node from the {Values} or {Envelope} namespace.
      #
      # @return [Values::AbstractVal]
      abstract :value

      # The {AbstractState} whose {value} is the parent of this state's {value}.
      #
      # @return [AbstractState]
      abstract :parent

      # @return [AbstractState]
      abstract :pop, :args => %w(count)

      # @return [AbstractState]
      abstract :add, :args => %w(segment_tok segment_use)

      # @return [Reader::Separators]
      def separators
        parent.separators
      end

      # @return [Reader::SegmentDict]
      def segment_dict
        parent.segment_dict
      end

    private

      # @return [Values::SegmentVal]
      def segment(segment_tok, segment_use, parent = nil)
        AbstractState.segment(segment_tok, segment_use, parent)
      end

      # @return [Configuration::RootConfig]
      def config
        parent.config
      end
    end

    class << AbstractState

      # This method constructs a new instance of (a subclass of) {AbstractState}
      # and pushes it above {parent} onto a nested stack-like structure. The
      # stack structure is implicit, and it can be iterated by following each
      # state's {parent}.
      #
      # @return [AbstractState]
      abstract :push, :args => %w(segment_tok segment_use parent reader)

      # @return [Values::SegmentVal]
      def segment(segment_tok, segment_use, parent = nil)
        segment_def  = segment_use.definition
        element_uses = segment_def.element_uses
        element_toks = segment_tok.element_toks

        element_vals = element_uses.zip(element_toks).map do |use, tok|
          if tok.nil?
            use.empty
          else
            element(use, tok)
          end
        end

        segment_use.value(element_vals, parent)
      end

    private

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

      # @return [Values::SimpleElementVal, Values::CompositeElementVal]
      def element(element_use, element_tok, parent = nil)
        if element_use.simple?
          simple_element(element_use, element_tok, parent)
        else
          composite_element(element_use, element_tok, parent)
        end
      end

      # @return [Values::CompositeElementVal]
      def composite_element(composite_use, composite_tok, parent = nil)
        composite_def  = composite_use.definition
        component_uses = composite_def.component_uses
        component_toks = composite_tok.component_toks

        component_vals = component_uses.zip(component_toks).map do |use, tok|
          if tok.nil?
            use.empty
          else
            simple_element(use, tok)
          end
        end

        composite_use.value(component_vals, parent)
      end

      # @return [Values::SimpleElementVal]
      def simple_element(element_use, element_tok, parent = nil)
        # We don't validate that element_tok is simple because the TokenReader
        # will always produce a SimpleElementTok given a SimpleElementUse from
        # the SegmentDef. On the other hand, the public builder API will throw
        # an exception if the programmer constructs the wrong kind of element
        # according to the SegmentDef.
        element_use.value(element_tok.value, parent)
      end
    end

  end
end
