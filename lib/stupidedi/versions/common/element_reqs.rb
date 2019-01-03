# frozen_string_literal: true
module Stupidedi
  module Versions
    module Common
      module ElementReqs
        Mandatory  = Schema::ElementReq.new(true,  false, "M")
        Optional   = Schema::ElementReq.new(false, false, "O")
        Relational = Schema::ElementReq.new(false, false, "X")
        # Flexible = Schema::ElementReq.new(false, false, "F")
      end
    end
  end
end
