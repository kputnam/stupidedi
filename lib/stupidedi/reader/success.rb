module Stupidedi
  module Reader

    #
    # This is not the same thing as {Either::Success}, but it is likely to be
    # wrapped by {Either::Success}. This simply wraps two values -- one is the
    # parsed value (which was constructed from some string input), the other
    # is the remaining input that hasn't yet been parsed. The remainder is
    # typically a TokenReader, but among other data types, it might also be
    # an ordinary String.
    #
    # In some situations, the remainder is computed from parts of the value.
    # For a contrived example, say we are writing a URL parser and we parse
    # the scheme ("http://" etc) in one step, and we choose a Reader that can
    # parse the rest of the URI as the remainder. We might have UriHttpReader,
    # UriMailtoReader, etc. But when we don't recognize the scheme, we can't
    # parse the rest of the URI. We *did* parse the scheme, so it doesn't make
    # sense to return an {Either::Failure}, but it *does* make sense for the
    # remainder to then be an Either.failure. This does result in some confusing
    # client code though:
    #
    #   x = UriSchemeReader.new("jabber://user@example.com").read.map do |result|
    #     # assuming UriSchemeReader#read returns Success[String, String]
    #     remainder = case result.value
    #                 when "http"
    #                   Either.success(HttpUriReader.new(result.remainder))
    #                 when "mailto"
    #                   Either.success(MailToUriReader.new(result.remainder))
    #                 else
    #                   Either.failure("Unknown URI scheme #{result.value}")
    #                 end
    #     Success.new(result.value, remainder)
    #   end #=> Either[Success[String, Reader]]
    #
    #   x.map do |result|
    #     # Given that x wasn't a Failure, then result is an instance of Success,
    #     # since that was the return type of the block written above.
    #
    #     result.remainder.flatmap do |remainder|
    #       # Now if result.remainder wasn't a Failure we arrive here
    #       # with remainder being an instance of HttpUriReader, et al
    #       remainder.read
    #     end
    #   end #=> Either[ whatever-the-return-type-of-HttpUriReader#read is ]
    #       #
    #       # Failure can happen as a result of the first call UriSchemeReader#read not
    #       # being able to parse the scheme, or because the first block wasn't able to
    #       # recognize the scheme (it wasn't "http" or "mailto"), or finally because the
    #       # call to HttpUriReader#read in the second block failed.
    #
    #   # More breifly (the confusing to read part)
    #   y = x.map{|r| r.remainder.flatmap{|s| s.read }}
    #       # Looking at this you can guess that x is an Either of something with
    #       # a #remainder method. That #remainder method is also an Either, this
    #       # time of something with a #read method.
    #
    class Success
      attr_reader \
        :value,
        :remainder

      def initialize(value, remainder)
        @value, @remainder = value, remainder
      end

      ##
      # Transforms the value using the given block parameter
      def map
        self.class.new(yield(value), remainder)
      end

      ##
      # Compares two Success instances, or directly compares the value to
      # the given the argument
      def ==(other)
        if self.class === other
          @value == other.value and @remainder == other.remainder
        else
          @value == other
        end
      end

    private

      # This is only to enable splat assignments.
      include Enumerable

      def each
        yield value
        yield remainder
      end
    end

  end
end
