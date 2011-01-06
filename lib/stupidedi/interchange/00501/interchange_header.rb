module Stupidedi
  module Interchange
    module FiveOhOne

      #
      # Comprises ISA, ISB, ISE, TA1, TA3 segments. Currently, only ISA is supported
      #
      class InterchangeHeader
        attr_reader :element_separator
        attr_reader :authorization_info_qualifier
        attr_reader :authorization_info
        attr_reader :security_info_qualifier
        attr_reader :security_info
        attr_reader :sender_id_qualifier
        attr_reader :sender_id
        attr_reader :receiver_id_qualifier
        attr_reader :receiver_id
        attr_reader :date
        attr_reader :time
        attr_reader :repetition_separator
        attr_reader :version_number
        attr_reader :control_number
        attr_reader :acknowledgment_requested
        attr_reader :usage_indicator
        attr_reader :component_separator
        attr_reader :segment_terminator

        def initialize(element_separator, segment_terminator, isa01, isa02, isa03, isa04, isa05, isa06, isa07, isa08, isa09, isa10, isa11, isa12, isa13, isa14, isa15, isa16)
          @element_separator            = element_separator
          @authorization_info_qualifier = isa01
          @authorization_info           = isa02
          @security_info_qualifier      = isa03
          @security_info                = isa04
          @sender_id_qualifier          = isa05
          @sender_id                    = isa06
          @receiver_id_qualifier        = isa07
          @receiver_id                  = isa08
          @date                         = isa09
          @time                         = isa10
          @repetition_separator         = isa11
          @version_number               = isa12
          @control_number               = isa13
          @acknowledgment_requested     = isa14
          @usage_indicator              = isa15
          @component_separator          = isa16
          @segment_terminator           = segment_terminator
        end

        def reader(input)
          Either.success(FunctionalGroupHeaderReader.new(input, self))
        end
      end

      #
      # Constructors
      #
      class << InterchangeHeader
        def default(*fields)
          defaults = Hash[:element_separator            => "*",
                          :segment_terminator           => "~",
                          :authorization_info_qualifier => "00",
                          :authorization_info           => "..........",
                          :security_info_qualifier      => "01",
                          :security_info                => "SECRET....",
                          :sender_id_qualifier          => "ZZ",
                          :sender_id                    => "SUBMITTERS.ID..",
                          :receiver_id_qualifier        => "ZZ",
                          :receiver_id                  => "RECEIVERS.ID...",
                          :date                         => "030101",
                          :time                         => "1253",
                          :repetition_separator         => "^",
                          :version_number               => "00501",
                          :control_number               => "000000905",
                          :acknowledgment_requested     => "1",
                          :usage_indicator              => "T",
                          :component_separator          => ":"]

          if fields.empty?
            fields = defaults
          else
            fields = defaults.merge(Hash[*fields])
          end

          new(fields[:element_separator],
              fields[:segment_terminator],
              fields[:authorization_info_qualifier],
              fields[:authorization_info],
              fields[:security_info_qualifier],
              fields[:security_info],
              fields[:sender_id_qualifier],
              fields[:sender_id],
              fields[:receiver_id_qualifier],
              fields[:receiver_id],
              fields[:date],
              fields[:time],
              fields[:repetition_separator],
              fields[:version_number],
              fields[:control_number],
              fields[:acknowledgment_requested],
              fields[:usage_indicator],
              fields[:component_separator])
        end
      end

    end
  end
end
