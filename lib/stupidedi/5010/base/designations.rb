module Stupidedi
  module FiftyTen
    module Base
      module Designations

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
          Unbounded = ElementRepetition.new

          class Max < ElementRepetition
            attr_reader :value

            def initialize(value)
              @value = value
            end
          end
        end

        class << ElementRepetition
          def Max(*args)
            Designations.element_repetition(*args)
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
          Unbounded = SegmentRepetition.new

          class Max < SegmentRepetition
            attr_reader :value

            def initialize(value)
              @value = value
            end
          end
        end

        class << SegmentRepetition
          def Max(*args)
            Designations.segment_repetition(*args)
          end
        end

        class LoopRepetition
          Once = LoopRepetition.new
          Unbounded = LoopRepetition.new

          class Max < LoopRepetition
            attr_reader :value

            def initialize(value)
              @value = value
            end
          end
        end

        class << LoopRepetition
          def Max(*args)
            Designations.loop_repetition(*args)
          end
        end

      end

      class << Designations
        def element_repetition(n)
          if n == 1
            Designations::ElementRepetition::Once
          else
            Designations::ElementRepetition::Max.new(n)
          end
        end

        def segment_repetition(n)
          if n == 1
            Designations::SegmentRepetition::Once
          else
            Designations::SegmentRepetition::Max.new(n)
          end
        end

        def loop_repetition(n)
          if n == 1
            Designations::LoopRepetition::Once
          else
            Designations::LoopRepetition::Max.new(n)
          end
        end
      end

    end
  end
end
