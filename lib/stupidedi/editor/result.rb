module Stupidedi
  module Editor

    class Result

      # @return [Zipper::AbstractCursor]
      attr_reader :zipper

      # @return [String]
      attr_reader :action

      # @return [String]
      attr_reader :code

      # @return [String]
      attr_reader :reason

      def initialize(zipper, action, code, reason)
        @zipper, @action, @code, @reason =
          zipper, action, code, reason
      end

      # @return [String]
      def inspect
        name = self.class.name.split('::').last
        "#{name}(#{@reason}, #{@zipper.node.inspect})"
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
    class ClaimStatus < Result
    end

  end
end

