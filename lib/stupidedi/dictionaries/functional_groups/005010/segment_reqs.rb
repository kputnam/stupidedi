module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentReqs

          Mandatory = Class.new(Schema::SegmentReq) do
            # @private
            def pretty_print(q)
              q.text("M")
            end
          end.new

          Optional = Class.new(Schema::SegmentReq) do
            # @private
            def pretty_print(q)
              q.text("O")
            end
          end.new

        end
      end
    end
  end
end
