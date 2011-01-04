module Stupidedi
  module Interchange
    module FiveOhOne

      # Comprises the GS segment
      class FunctionalGroupHeader
        attr_reader \
          :functional_id_code,
          :sender_code,
          :receiver_code,
          :date,
          :time,
          :control_number,
          :agency_code,
          :version_code

        def initialize(gs01, gs02, gs03, gs04, gs05, gs06, gs07, gs08)
          @functional_id_code = gs01
          @sender_code        = gs02
          @receiver_code      = gs03
          @date               = gs04
          @time               = gs05
          @control_number     = gs06
          @agency_code        = gs07
          @version_code       = gs08
        end

        ##
        # Decodes the GS08 version code
        def asc
          if agency_code == "X" and version_code.length > 5
            Either.success(:number      => version_code.slice(0, 3),
                           :release     => version_code.slice(3, 1),
                           :subrelease  => version_code.slice(4, 1),
                           :level       => version_code.slice(5, 1),
                           :industry_id => version_code.slice(6..-1),
                           :to_s        => version_code)
          else
            Either.failure("Expected agency code 'X' and version_code of at least 6 characters")
          end
        end

        def reader(input, interchange_header)
          asc.flatmap do |version|
            # The version code was "parsable", so if we recognize it the from_version call will
            # return a success-wrapped implementation guide specific transaction set header
            TransactionSetHeaderReader.from_version(version, input, interchange_header)
          end.or do
            # The version code wasn't specifically recognized, but there is a possibility the
            # version code in the transaction set header (ST03) will make more sense. So this
            # generic reader knows to grant a second chance
            Either.success(TransactionSetHeaderReader.generic(input, interchange_header))
          end
        end
      end

    end
  end
end
