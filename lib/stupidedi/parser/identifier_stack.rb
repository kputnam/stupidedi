# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Parser
    # @todo: Documentation
    #
    class IdentifierStack
      def initialize(id)
        @state = Empty.new(id)
      end

      def id
        @state.id
      end

      # Creates a new interchange control number (ISA-XX) and pushes it onto
      # the internal identifier stack.
      #
      # @return [String]
      def isa
        @state = @state.isa
        @state.id
      end

      # Creates a new functional group control number (ISA-XX) and pushes it onto
      # the internal identifier stack.
      #
      # @return [String]
      def gs
        @state = @state.gs
        @state.id
      end

      def st
        @state = @state.st
        @state.id
      end

      def hl
        @state = @state.hl
        @state.id
      end

      def pop
        @state.id.tap { @state = @state.pop }
      end

      def method_missing(name, *args)
        @state.__send__(name, *args)
      end

      #########################################################################
      # State Representations

      class Empty
        def initialize(id)
          @count, @next, @id = 0, id, id
        end

        def isa
          ISA.new(self, @next).tap { @count += 1; @next += 1 }
        end

        # Number of Interchanges (ISA..IEA)
        def count
          @count
        end
      end

      class ISA
        attr_reader :id

        def initialize(parent, id)
          @count, @parent, @next, @id = 0, parent, id, id
        end

        def gs
          GS.new(self, @next).tap { @count += 1; @next += 1 }
        end

        # Number of Functional Groups (GS..GE)
        def count
          @count
        end

        def pop
          @parent
        end
      end

      class GS
        attr_reader :id

        def initialize(parent, id)
          @count, @parent, @next, @id = 0, parent, id, id
        end

        def st
          ST.new(self, @next).tap { @count += 1; @next += 1 }
        end

        # GE01 Number of Transaction Sets (within current functional group)
        #
        # @return [Integer]
        def count
          @count
        end

        def pop
          @parent
        end
      end

      class ST
        attr_writer :sequence

        def initialize(parent, id)
          @sequence, @parent, @id = 0, parent, id
        end

        def hl
          HL.new(self, @sequence += 1)
        end

        def id
          @id.to_s.rjust(4, "0")
        end

        # Number of segments (ST..SE)
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

        def pop
          @parent
        end
      end

      class HL
        attr_writer :sequence

        def initialize(parent, id)
          @parent, @id, @sequence = parent, id, id
        end

        def hl
          HL.new(self, @sequence += 1)
        end

        def id
          @id.to_s
        end

        # Parent HL number
        def parent
          case @parent
          when HL
            @parent.id
          end
        end

        def pop
          @parent.sequence = @sequence
          @parent
        end
      end
    end

  end
end
