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
        unless @remainder.nil? or not @remainder.respond_to?(:offset)
          @remainder.offset
        end
      end

      def line
        unless @remainder.nil? or not @remainder.respond_to?(:line)
          @remainder.line
        end
      end

      def column
        unless @remainder.nil? or not @remainder.respond_to?(:column)
          @remainder.column
        end
      end

      def ==(other)
        if other.is_a?(self.class)
          @message == other.message
        else
          @message == other
        end
      end
    end

  end
end
