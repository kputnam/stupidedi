module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentReqs

          # Singleton
          Mandatory = Class.new(Schema::SegmentReq) do
            # @return [void]
            def pretty_print(q)
              q.text("M")
            end

            def required?
              true
            end

            def forbidden?
              false
            end
          end.new

          # Singleton
          Optional = Class.new(Schema::SegmentReq) do
            # @return [void]
            def pretty_print(q)
              q.text("O")
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
end
