module Stupidedi
  module Interchange

    class TransactionSetHeaderReader
      include Reader::TokenReader

      def read_transaction_set_header
        raise NoMethodError, "Method read_transaction_set_header must be implemented in subclass"
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

      ##
      # Returns either a Either.success(Module) if the given +version+ is
      # recognized and supported or a Either.failure(String) otherwise.
      #   TODO: Move this to a base ImplementationGuide class that tracks
      #         its subclasses when it is inherited
      def implementation(version)
        spec = version[:number].to_s +
               version[:release].to_s +
               version[:subrelease].to_s +
               version[:level].to_s

        case spec
        when "005010"
          case version[:industry_id]
          when "X212", "X212A1"
            # 276 Status Request
            # 277 Status Notification
            Either.success(FiftyTen::Industry::Hipaa::X212)
          when "X221", "X221A1"
            # 835 Remittance Advice
            Either.success(FiftyTen::Industry::Hipaa::X221)
          when "X222", "X222A1"
            # 837 Claim Professional
            Either.success(FiftyTen::Industry::Hipaa::X222)
          when "X223", "X223A1"
            # 837 Claim Institutional
            Either.success(FiftyTen::Industry::Hipaa::X223)
          when "X224", "X224A1"
            # 837 Claim Detal
            Either.success(FiftyTen::Industry::Hipaa::X224)
          when "X230", "X230A1"
            # 997 Functional Acknowledgment
            Either.success(FiftyTen::Industry::Hipaa::X230)
          when "X231", "X231A1"
            # 999 Implementation Acknowledgment
            Either.success(FiftyTen::Industry::Hipaa::X231)
          when "X279", "X279A1"
            # 270 Eligibility Inquiry
            # 271 Eligibility Response
            Either.success(FiftyTen::Industry::Hipaa::X279)
          else
            Either.failure("Unrecognized industry identifier #{version[:industry_id].inspect}", input)
          end
        when "004010"
          Either.failure("Version 4010 is not supported")
        else
          Either.failure("Unrecognized X12 version #{spec.inspect}")
        end
      end

      ##
      # Dispatches to the appropriate implementation guide, based on
      # the version from the functional group header's GS08. Note that
      # the value in ST03, which hasn't yet been parsed, takes precedence
      # over GS08, but we delegate the job of reading ST08, to a specific
      # implementation guide.
      def from_version(version, input, interchange_header)
        implementation(version).map do |guide|
          # When the implementation is recognized, construct the reader with it
          guide.transaction_set_header_reader(input, interchange_header)
        end
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

    TransactionSetHeaderReader.eigenclass.send(:private, :new)
    GenericTransactionSetHeaderReader.eigenclass.send(:public, :new)

  end
end
