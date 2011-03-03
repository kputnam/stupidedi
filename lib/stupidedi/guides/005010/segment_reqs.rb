module Stupidedi
  module Guides
    module FiftyTen
      module SegmentReqs

        Required = Class.new(Schema::SegmentReq) do
          # @private
          def pretty_print(q)
            q.text "R"
          end

          def required?
            true
          end

          def forbidden?
            false
          end
        end.new

        Situational = Class.new(Schema::SegmentReq) do
          # @private
          def pretty_print(q)
            q.text "S"
          end

          def required?
            false
          end

          def forbidden?
            false
          end
        end.new

      end
    end
  end
end
