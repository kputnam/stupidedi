module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module ElementReqs

          Mandatory  = Schema::ElementReq.new(true,  false, "M")
          Optional   = Schema::ElementReq.new(false, false, "O")
          Relational = Schema::ElementReq.new(false, false, "X")

        end
      end
    end
  end
end
