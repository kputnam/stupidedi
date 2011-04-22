module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen

        #
        # @see X222.pdf B.1.1.3.9 Condition Designator
        #
        module ElementReqs
          Mandatory  = Schema::ElementReq.new(true,  false, "M")
          Optional   = Schema::ElementReq.new(false, false, "O")
          Relational = Schema::ElementReq.new(false, false, "X")
        end

      end
    end
  end
end
