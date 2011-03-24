module Stupidedi
  module Reader

    class Result
      include Inspect
    end

    class << Result
      # @group Constructor Methods
      #########################################################################

      # @return [Result::Success]
      def success(value, remainder)
        Result::Success.new(value, remainder)
      end

      # @return [Result::Failure]
      def failure(reason, remainder)
        Result::Failure.new(reason, remainder)
      end

      # @endgroup
      #########################################################################
    end

    #
    # This is not the same thing as {Either::Success}, but it is likely to be
    # wrapped by {Either::Success}. This simply wraps two values -- one is the
    # parsed value (which was constructed from some string input), the other
    # is the remaining input that hasn't yet been parsed. The remainder is
    # typically a {TokenReader}, but among other data types, it might also be
    # an ordinary `String`.
    #
    # In some situations, the remainder is computed from parts of the value.
    # For a contrived example, say we are writing a URL parser and we parse
    # the scheme ("http://" etc) in one step, and we choose a Reader that can
    # parse the rest of the URI as the remainder. We might have `UriHttpReader`,
    # `UriMailtoReader`, etc. But when we don't recognize the scheme, we can't
    # parse the rest of the URI. We *did* parse the scheme, so it doesn't make
    # sense to return an {Either::Failure}, but it *does* make sense for the
    # remainder to then be an {Either::Failure}. This can result in confusing
    # client code though:
    #
    #     x = UriSchemeReader.new("xmpp://user@example.com").read.map do |result|
    #       # assuming UriSchemeReader#read returns Success[String, String]
    #       remainder = case result.value
    #                   when "http"
    #                     Either.success(HttpUriReader.new(result.remainder))
    #                   when "mailto"
    #                     Either.success(MailToUriReader.new(result.remainder))
    #                   else
    #                     Either.failure("Unknown URI scheme #{result.value}")
    #                   end
    #       Success.new(result.value, remainder)
    #     end #=> Either[Success[String, Reader]]
    #
    #     x.map do |result|
    #       # Given that x wasn't Either.failure, then result is an instance of
    #       # Success, since that was the return type of the block written above.
    #
    #       result.remainder.flatmap do |remainder|
    #         # Now if result.remainder wasn't a Failure we arrive here
    #         # with remainder being an instance of HttpUriReader, et al
    #         remainder.read
    #       end
    #     end #=> Either< whatever-the-return-type-of-HttpUriReader#read is >
    #         #
    #         # Failure can happen as a result of the first call
    #         # UriSchemeReader#read not being able to parse the scheme, or
    #         # because the first block wasn't able to recognize the scheme (it
    #         # wasn't "http" or "mailto"), or finally because the call to
    #         # HttpUriReader#read in the second block failed.
    #
    #     # More breifly
    #     y = x.map{|r| r.remainder.flatmap{|s| s.read }}
    #         # Looking at this you can infer that x is an Either of something
    #         # with a #remainder method. That #remainder method is also an
    #         # Either, which wraps a value that responds to the #read method,
    #         # which returns an Either.
    #
    class Success < Result
      attr_reader :value

      attr_reader :remainder

      def initialize(value, remainder)
        @value, @remainder = value, remainder
      end

      # @return [Success]
      def copy(changes = {})
        Success.new \
          changes.fetch(:value, @value),
          changes.fetch(:remainder, @remainder)
      end

      # Transforms the value using the given block parameter
      #
      # @return [Success]
      def map
        Success.new(yield(@value), @remainder)
      end

      # @return [Boolean]
      def ==(other)
        if other.is_a?(self.class)
          @value == other.value and @remainder == other.remainder
        else
          @value == other
        end
      end

      # @return [void]
      def pretty_print(q)
        q.text "Result.success"
        q.group(2, "(", ")") do
          q.breakable ""
          q.pp @value
          q.text ","
          q.breakable
          q.pp @remainder
        end
      end

      # Override {Enumerable#blank?} since we're not really {Enumerable}
      def blank?
        false
      end

    private

      # This is only to enable splat assignments.
      #   value, remainder = *success
      include Enumerable

      def each
        yield value
        yield remainder
      end
    end

    #
    # This is not the same as {Either::Failure}, though it is likely that values
    # of this type are wrapped in {Either::Failure}.
    #
    # This class simply wraps two values -- one being some error message or
    # object that explains the failure, and the other being the input stream
    # that caused the failure.
    #
    # This goes beyond an ordinary {Either::Failure}`<String>` because it can
    # report the offset within the input stream that caused the failure (if the
    # input stream is an instance of {AbstractInput}).
    #
    class Failure < Result

      attr_reader :reason

      attr_reader :remainder

      def initialize(reason, remainder)
        @reason, @remainder = reason, remainder
      end

      # @return [Position]
      def position
        if @remainder.respond_to?(:position)
          @remainder.position
        end
      end

      # @return [Integer]
      def offset
        if @remainder.respond_to?(:offset)
          @remainder.offset
        end
      end

      # @return [Integer]
      def line
        if @remainder.respond_to?(:line)
          @remainder.line
        end
      end

      # @return [Integer]
      def column
        if @remainder.respond_to?(:column)
          @remainder.column
        end
      end

      # @return [Boolean]
      def ==(other)
        if other.is_a?(self.class)
          @reason == other.reason
        else
          @reason == other
        end
      end

      # @return [void]
      def pretty_print(q)
        q.text "Result.failure"
        q.group(2, "(", ")") do
          q.breakable ""
          q.pp @reason
          q.text ","
          q.breakable
          q.pp @remainder
        end
      end
    end

  end
end
