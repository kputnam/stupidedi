# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Parser
    # @todo: Documentation
    #
    class IdentifierStack
      def initialize(start)
        @state = Empty.new(Sequence.new(start))
      end

      # Returns a new interchange control number (ISA13, IEA02)
      #
      # @return [String]
      def isa(*args)
        @state = @state.isa(*args)
        @state.id
      end

      # Returns a new functional Group Control Number (GS06, GE02)
      #
      # @return [String]
      def gs(*args)
        @state = @state.gs(*args)
        @state.id
      end

      # Returns a new Transaction Set Control Number (ST02)
      #
      # @return [String]
      def st(*args)
        @state = @state.st(*args)
        @state.id
      end

      # Returns a new Hierarchical ID Number (HL01)
      #
      # @return [String]
      def hl(*args)
        @state = @state.hl(*args)
        @state.id
      end

      # Returns the last identifier created
      def pop
        @state.id.tap { @state = @state.pop }
      end

      def pop_isa
        @state.id.tap { @state = @state.pop_isa }
      end

      def pop_gs
        @state.id.tap { @state = @state.pop_gs }
      end

      def pop_st
        @state.id.tap { @state = @state.pop_st }
      end

      def pop_hl
        @state.id.tap { @state = @state.pop_hl }
      end

      def respond_to?(name)
        @state.respond_to?(name)
      end

      def method_missing(name, *args)
        @state.__send__(name, *args)
      end

      #########################################################################
      # State Representations

      class Sequence
        def initialize(start)
          @value = start
        end

        def succ!
          self.tap { @value += 1 }
        end

        def value
          @value
        end
      end

      class Empty
        def initialize(sequence)
          @count, @sequence = 0, sequence
        end

        def isa
          ISA.new(self, @sequence).tap { @count += 1; @sequence.succ! }
        end

        # Returns number of interchanges (@note this is not needed by X12)
        #
        # @return [Integer]
        def count
          @count
        end
      end

      class ISA
        attr_reader :id

        def initialize(parent, sequence)
          @count, @parent, @sequence, @id = 0, parent, sequence, sequence.value
        end

        def gs(start = nil)
          sequence = start.try{|n| Sequence.new(n) } || @sequence
          GS.new(self, sequence).tap { @count += 1; sequence.succ! }
        end

        # Number of Transaction Sets Included (IEA01)
        #
        # @return [Integer]
        def count
          @count
        end

        def pop_isa
          @parent
        end

        def pop
          warn "DEPRECATION WARNING: IdentifierStack#pop is deprecated, use pop_isa (when removing an ISA identifier from the stack)"
          pop_isa
        end
      end

      class GS
        attr_reader :id

        def initialize(parent, sequence)
          @count, @parent, @sequence, @id = 0, parent, sequence, sequence.value
        end

        def st(start = nil)
          sequence = start.try{|n| Sequence.new(n) } || @sequence
          ST.new(self, sequence).tap { @count += 1; sequence.succ! }
        end

        # Number of Transaction Sets Included (GE01)
        #
        # @return [Integer]
        def count
          @count
        end

        def pop_gs
          @parent
        end

        def pop
          warn "DEPRECATION WARNING: IdentifierStack#pop is deprecated, use pop_gs (when removing an GS identifier from the stack)"
          pop_gs
        end
      end

      class ST
        def initialize(parent, sequence)
          @parent, @id = parent, sequence.value
          @hl_sequence = Sequence.new(0)
          @lx_sequence = Sequence.new(0)
        end

        def id
          "%04d" % @id
        end

        def hl
          HL.new(self, @hl_sequence, @lx_sequence).tap { @hl_sequence.succ! }
        end

        def lx
          @lx_sequence.succ!.value
        end

        # Number of Included Segments (SE01)
        #
        # @return [Integer]
        def count(builder)
          m = Either.success(builder.machine)

          while m.defined?
            if m.flatmap(&:segment).map{|s| s.node.id == :ST }.fetch(false)
              return m.flatmap{|n| n.distance(builder.machine) }.fetch(0) + 2
            else
              m = m.flatmap(&:parent)
            end
          end
        end

        def pop_st
          @parent
        end

        def pop
          warn "DEPRECATION WARNING: IdentifierStack#pop is deprecated, use pop_st (when removing an ST identifier from the stack)"
          pop_st
        end
      end

      class HL
        attr_reader :id

        def initialize(parent, hl_sequence, lx_sequence)
          @parent, @id, @hl_sequence, @lx_sequence =
            parent, hl_sequence.value, hl_sequence, lx_sequence
        end

        def hl
          HL.new(self, @sequence.succ!, @lx_sequence)
        end

        def lx
          @lx_sequence.succ!.value
        end

        # Parent HL number (HL02)
        #
        # @return [Integer]
        def parent_id
          if @parent.is_a?(HL)
            @parent.id
          else
            raise RuntimeError, "this HL*#{@id} does not have a parent HL"
          end
        end

        def pop_hl
          @parent
        end

        def pop
          warn "DEPRECATION WARNING: IdentifierStack#pop is deprecated, use pop_ht (when removing an HL identifier from the stack)"
          pop_hl
        end
      end
    end
  end
end
