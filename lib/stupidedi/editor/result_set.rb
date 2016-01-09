module Stupidedi
  using Refinements

  module Editor

    class ResultSet
      include Inspect

      # @return [Array<Result>]
      attr_reader :results

      def initialize
        @results = []

        default  = lambda{|h,z| h[z] = [] }
        @ta105s  = [] # Hash.new(&default)
        @ak905s  = [] # Hash.new(&default)
        @ik304s  = [] # Hash.new(&default)
        @ik403s  = [] # Hash.new(&default)
        @ik502s  = [] # Hash.new(&default)
        @cscs    = [] # Hash.new(&default)
        @csccs   = [] # Hash.new(&default)
        @eics    = [] # Hash.new(&default)
        @warns   = []
      end

      def ta105(*args)
        result = TA105.new(*args)
        @results << result
        @ta105s  << result
      end

      def ak905(*args)
        result = AK905.new(*args)
        @results << result
        @ak905s  << result
      end

      def ik304(*args)
        result = IK304.new(*args)
        @results << result
        @ik304s  << result
      end

      def ik403(*args)
        result = IK403.new(*args)
        @results << result
        @ik403s  << result
      end

      def ik502(*args)
        result = IK502.new(*args)
        @results << result
        @ik502s  << result
      end

      def stc01(*args)
      # result = ClaimStatus.new(*args)
      # @results << result
      # @cscs    << result
      end

      def warn(zipper, message)
        result = Warning.new(zipper, message)
        @results << result
        @warns   << result
      end
    end

  end
end
