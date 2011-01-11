module Stupidedi
  module Reader

    #
    # This is not the same as {Either::Failure}, though it is likely that values
    # of this type are wrapped in {Either::Failure}.
    #
    # This class simply wraps two values -- one being some error message or
    # object that explains the failure, and the other being the input stream
    # that caused the failure.
    #
    # This goes beyond an ordinary {Either.failure}(String) because it can
    # report the offset within the input stream that caused the failure (if the
    # input stream is wrapped).
    #
    class Failure
      attr_reader :message

      attr_reader :remainder

      def initialize(message, remainder)
        @message, @remainder = message, remainder
      end

      def offset
        @remainder.offset if @remainder and @remainder.respond_to?(:offset)
      end

      def line
        @remainder.line if @remainder and @remainder.respond_to?(:line)
      end

      def column
        @remainder.column if @remainder and @remainder.respond_to?(:column)
      end

      def ==(other)
        if self.class === other
          @message == other.message
        else
          @message == other
        end
      end
    end

  end
end
