module Stupidedi
  module FiftyTen
    module Definitions

      class ElementRequirement
        M = ElementRequirement.new # "Mandatory"
        O = ElementRequirement.new # "Optional"
        X = ElementRequirement.new # "Relational"

        M.eigenclass.send(:define_method, :required?) { true  }
        O.eigenclass.send(:define_method, :required?) { false }
        X.eigenclass.send(:define_method, :required?) { false }
      end

      class ElementRepetition
        Once = ElementRepetition.new
        Once.eigenclass.send(:define_method, :once?) { true }

        Unbounded = ElementRepetition.new
        Unbounded.eigenclass.send(:define_method, :once?) { false }

        class Max < ElementRepetition
          attr_reader :value

          def initialize(value)
            @value = value
          end

          def once?
            false
          end
        end
      end

      class << ElementRepetition
        def Max(*args)
          Definitions.element_repetition(*args)
        end
      end

      class SegmentRequirement
        M = SegmentRequirement.new # "Mandatory"
        O = SegmentRequirement.new # "Optional"

        M.eigenclass.send(:define_method, :required?) { true  }
        O.eigenclass.send(:define_method, :required?) { false }
      end

      class SegmentRepetition
        Once = SegmentRepetition.new
        Once.eigenclass.send(:define_method, :once?) { true }

        Unbounded = SegmentRepetition.new
        Unbounded.eigenclass.send(:define_method, :once?) { false }

        class Max < SegmentRepetition
          attr_reader :value

          def initialize(value)
            @value = value
          end
        end
      end

      class << SegmentRepetition
        def Max(*args)
          Definitions.segment_repetition(*args)
        end
      end

      class LoopRepetition
        Once = LoopRepetition.new
        Once.eigenclass.send(:define_method, :once?) { true }

        Unbounded = LoopRepetition.new
        Unbounded.eigenclass.send(:define_method, :once?) { false }

        class Max < LoopRepetition
          attr_reader :value

          def initialize(value)
            @value = value
          end
        end
      end

      class << LoopRepetition
        def Max(*args)
          Definitions.loop_repetition(*args)
        end
      end

    end

    class << Definitions
      def element_repetition(n)
        if n == 1
          Definitions::ElementRepetition::Once
        else
          Definitions::ElementRepetition::Max.new(n)
        end
      end

      def segment_repetition(n)
        if n == 1
          Definitions::SegmentRepetition::Once
        else
          Definitions::SegmentRepetition::Max.new(n)
        end
      end

      def loop_repetition(n)
        if n == 1
          Definitions::LoopRepetition::Once
        else
          Definitions::LoopRepetition::Max.new(n)
        end
      end
    end

  end
end
