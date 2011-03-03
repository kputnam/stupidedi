module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module ElementReqs

          Mandatory  = Class.new(Schema::ElementReq) do
            def inspect
              "M"
            end
          end.new

          Optional   = Class.new(Schema::ElementReq) do
            def inspect
              "O"
            end
          end.new

          Relational = Class.new(Schema::ElementReq) do
            def inspect
              "X"
            end
          end.new

        end
      end
    end
  end
end
