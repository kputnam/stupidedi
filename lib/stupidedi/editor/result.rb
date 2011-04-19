module Stupidedi
  module Editor

    class Result
      def initialize(zipper, code, message)
      end
    end

    # TA1 Interchange Acknowledgement
    class TA105 < Result
    end

    # 999 Implementation Acknowledgement
    class AK905 < Result
    end

    # 999 Implementation Acknowledgement
    class IK304 < Result
    end

    # 999 Implementation Acknowledgement
    class IK403 < Result
    end

    # 999 Implementation Acknowledgement
    class IK502 < Result
    end

    # 277 Claim Acknowledgment
    class CSC < Result
    end

    # 277 Claim Acknowledgment
    class CSCC < Result
    end

    # 277 Claim Acknowledgment
    class EIC < Result
    end

  end
end
