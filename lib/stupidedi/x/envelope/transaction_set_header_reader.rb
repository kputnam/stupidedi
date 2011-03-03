module Stupidedi
  module Interchange

    class TransactionSetHeaderReader
      include Reader::TokenReader

      def read_transaction_set_header
        raise NoMethodError,
          "Method read_transaction_set_header must be implemented in subclass"
      end

      alias read read_transaction_set_header

    private

      def advance(n)
        unless input.defined_at?(n-1)
          raise IndexError, "Less than #{n} characters available"
        else
          self.class.new(input.drop(n), interchange_header)
        end
      end

    end

    class << TransactionSetHeaderReader
      def generic(input, interchange_header)
        GenericTransactionSetHeaderReader.new(input, interchange_header)
      end

      # Dispatches to the appropriate implementation guide, based on
      # the version from the functional group header's GS08. Note that
      # the value in ST03, which hasn't yet been parsed, takes precedence
      # over GS08, but we delegate the job of reading ST08, to a specific
      # implementation guide.
      def from_version(version, input, interchange_header)
        implementation(version).map do |guide|
          # When the implementation is recognized, construct the reader with it
          guide.new(input, interchange_header)
        end
      end

      # Returns either a Either.success(Module) if the given +version+ is
      # recognized and supported or a Either.failure(String) otherwise.
      def implementation(version)
        spec = version[:number].to_s +
               version[:release].to_s +
               version[:subrelease].to_s +
               version[:level].to_s +
               version[:industry_id].to_s

        # Find subclasses whose versions match, using ===, which does pattern
        # matching if m is a Regexp and just String comparison if m is a String.
        matches = subclasses.select{|s| Array(s.versions).find{|m| m === spec }}

        case matches.size
        when 1
          Either.success(matches.first)
        when 0
          Either.failure("Unrecognized implementation version #{spec.inspect}")
        else
          Either.failure("More than one class matches implementation version #{spec.inspect}: #{matches.join(', ')}")
        end
      end

    private

      def subclasses
        @subclasses ||= []
      end

      def inherited(base)
        subclasses << base
      end
    end

    class GenericTransactionSetHeaderReader < TransactionSetHeaderReader
      attr_reader :input, :interchange_header

      def initialize(input, interchange_header)
        @input, @interchange_header = input, interchange_header
      end

      def read_transaction_set_header
        consume_prefix("ST").flatmap{|rest|      rest.consume_prefix(interchange_header.element_separator).flatmap{|rest|
        rest.read_element.flatmap{|r| st01, c = *r; c.consume_prefix(interchange_header.element_separator).flatmap{|rest|
        rest.read_element.flatmap{|r| st02, c = *r; c.consume_prefix(interchange_header.element_separator).flatmap{|rest|
        rest.read_element.flatmap{|r| st03, c = *r; c.consume_prefix(interchange_header.segment).flatmap {|rest|
          TransactionSetHeaderReader.implementation(st03).map do |guide|
            header = guide.transaction_set_header(st01, st02, st03)
            Reader.Success.new(header, header.reader(rest.input))
          end.explain do |message|
            Reader::Failure.new(message, input)
          end
        }}}}}}}}
      end
    end

    class << GenericTransactionSetHeaderReader
      # Since this is a fallback, no versions should actually match this.
      def versions
        []
      end
    end

#   TransactionSetHeaderReader.eigenclass.send(:private, :new)
    GenericTransactionSetHeaderReader.eigenclass.send(:public, :new)

  end
end

