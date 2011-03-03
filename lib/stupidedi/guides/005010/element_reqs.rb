module Stupidedi
  module Guides
    module FiftyTen
      module ElementReqs

        Required = Class.new(Schema::ElementReq) do
          # @private
          def pretty_print(q)
            q.text "R"
          end

          def forbidden?
            false
          end

          def required?
            true
          end
        end.new

        Situational = Class.new(Schema::ElementReq) do
          # @private
          def pretty_print(q)
            q.text "S"
          end

          def forbidden?
            false
          end

          def required?
            false
          end
        end.new

        NotUsed = Class.new(Schema::ElementReq) do
          # @private
          def pretty_print(q)
            q.text "N"
          end

          def forbidden?
            true
          end

          def required?
            false
          end
        end.new

      end
    end
  end
end
