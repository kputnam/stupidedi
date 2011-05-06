module Stupidedi
  module Editor

    class Result

      # @return [Zipper::AbstractCursor]
      abstract :zipper

      # @return [String]
      abstract :reason

      def error?
        false
      end

      def warning?
        false
      end
    end

    class Warning < Result

      # @return [Zipper::AbstractCursor]
      attr_reader :zipper

      # @return [String]
      attr_reader :reason

      def initialize(zipper, reason)
        @zipper, @reason =
          zipper, reason
      end

      # @return [String]
      def inspect
        "Warning(#{@reason}, #{@zipper.node.inspect})"
      end

      def warning?
        true
      end
    end

    class Error < Result

      # @return [Zipper::AbstractCursor]
      attr_reader :zipper

      # @return [String]
      attr_reader :reason

      # @return [String]
      attr_reader :action

      # @return [String]
      attr_reader :code

      def initialize(zipper, action, code, reason)
        @zipper, @action, @code, @reason =
          zipper, action, code, reason
      end

      # @return [String]
      def inspect
        name = self.class.name.split('::').last
        "#{name}(#{zipper.node.position.inspect}, #{@reason}, #{@zipper.node.inspect})"
      end

      def error?
        true
      end
    end

    # TA1 Interchange Acknowledgement
    class TA105 < Error
    end

    # 999 Implementation Acknowledgement
    class AK905 < Error
    end

    # 999 Implementation Acknowledgement
    class IK304 < Error
    end

    # 999 Implementation Acknowledgement
    class IK403 < Error
    end

    # 999 Implementation Acknowledgement
    class IK502 < Error
    end

    # 277 Claim Acknowledgment
    class ClaimStatus < Error
    end

  end
end

