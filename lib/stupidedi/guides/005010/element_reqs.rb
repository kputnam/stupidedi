module Stupidedi
  module Guides
    module FiftyTen
      module ElementReqs

        Required    = Schema::ElementReq.new(true,  false, "R")
        Situational = Schema::ElementReq.new(false, false, "S")
        NotUsed     = Schema::ElementReq.new(false, true,  "N")

      end
    end
  end
end
