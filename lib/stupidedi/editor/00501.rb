module Stupidedi
  module Editor

    #
    # Validates (edits) interchanges (ISA/IEA) with version "00501", then
    # selects the appropriate editor, according to the config, and edits
    # each functional group (GS/GE)
    #
    class FiveOhOneEd < AbstractEd

      # @return [Config]
      attr_reader :config

      # @return [Time]
      attr_reader :received

      def initialize(config, received)
        @config, @received =
          config, received
      end

      # @return [ResultSet]
      def validate(isa, acc)
        # 000: No error

        # 002: This Standard as Noted in the Control Standards Identifier is Not Supported
        #   Check for InvalidEnvelope

        # 003: This Version of the Controls is Not Supported
        #   Check for InvalidEnvelope

        # 004: The Segment Terminator is Invalid
        #   We couldn't have produced a parse tree, StreamReader#next_segment
        #   would have returned an Either.failure<Result.failure>

        # 009: Unknown Interchange Receiver ID
        #   This isn't for Stupidedi to decide

        # 016: Invalid Interchange Standards Identifier Value
        #   Check for InvalidEnvelope

        # 022: Invalid Control Characters
        #   What does this mean? TokenReader ignores control characters anyway,
        #   so there will be no evidence of this in the parse tree

        # 025: Duplicate Interchange Control Numbers
        #   Need to validate the parent, TransmissionVal

        # 028: Invalid Date in Deferred Delivery Request
        # 029: Invalid Time in Deferred Delivery Request
        # 030: Invalid Delivery Time Code in Deferred Delivery Request
        # 031: Invalid Grade of Service
        #   It seems these elements should not be sent to a trading partner,
        #   they are used internally to schedule a delivery. Not sure what to do
        #   about validating them in a general way...

        acc.tap { edit_isa(isa, received, acc) }
      end

    private

      def edit_isa(isa, received, acc)
        # Authorization Information Qualifier
        edit(:ISA01) do
          isa.element(1).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "010", "must be present")
            elsif e.node.usage.allowed_values.exclude?(e.node.to_s)
              acc.ta105(e, "R", "010", "is not an allowed value")
            end
          end
        end

        # Authorization Information
        edit(:ISA02) do
          isa.element(2).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "011", "must be present")
            elsif e.node.invalid? or not config.editor.an?(e.node)
              acc.ta105(e, "R", "011", "is not a valid string")
            end
          end
        end

        # Security Information Qualifier
        edit(:ISA03) do
          isa.element(3).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "012", "must be present")
            elsif e.node.usage.allowed_values.exclude?(e.node.to_s)
              acc.ta105(e, "R", "012", "is not an allowed value")
            end
          end
        end

        # Security Information
        edit(:ISA04) do
          isa.element(4).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "013", "must be present")
            elsif e.node.invalid? or not config.editor.an?(e.node)
              acc.ta105(e, "R", "013", "is not a valid string")
            end
          end
        end

        # Interchange ID Qualifier
        edit(:ISA05) do
          isa.element(5).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "005", "must be present")
            elsif e.node.usage.allowed_values.exclude?(e.node.to_s)
              acc.ta105(e, "R", "005", "is not an allowed value")
            end
          end
        end

        # Interchange Sender ID
        edit(:ISA06) do
          isa.element(6).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "006", "must be present")
            elsif e.node.invalid? or not config.editor.an?(e.node)
              acc.ta105(e, "R", "006", "is not a valid string")
            end
          end
        end

        # Interchange ID Qualifier
        edit(:ISA07) do
          isa.element(7).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "007", "must be present")
            elsif e.node.usage.allowed_values.exclude?(e.node.to_s)
              acc.ta105(e, "R", "007", "is not an allowed value")
            end
          end
        end

        # Interchange Receiver ID
        edit(:ISA08) do
          isa.element(8).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "008", "must be present")
            end
          end
        end

        # Interchange Date
        edit(:ISA09) do
          isa.element(9).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "014", "must be present")
            elsif e.node.invalid?
              acc.ta105(e, "R", "014", "is not a valid date")
            else
              # Convert to a proper 4-digit year, by making the assumption
              # that the date is less than 30 years old. Note we have to use
              # Object#send to work around an incorrectly declared private
              # method that wasn't fixed until after Ruby 1.8
              date = e.node.oldest(received.send(:to_date) << 12*30)

              if date > received.utc.send(:to_date)
                acc.ta105(e, "R", "014", "must not be a future date")
              end
            end
          end
        end

        # Interchange Time
        edit(:ISA10) do
          isa.element(10).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "015", "must be present")
            elsif e.node.invalid?
              acc.ta105(e, "R", "015", "is not a valid time")
            else
              isa.element(9).reject{|f| f.node.invalid? }.tap do |f|
                date = f.node.oldest(received.send(:to_date) << 12*30)

                if e.node.to_time(date) > received.utc
                  acc.ta105(e, "R", "015", "must not be a future time")
                end
              end
            end
          end
        end

        # Repetition Separator
        edit(:ISA11) do
          isa.element(11).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "026", "must be present")
            end
          end
        end

        # Interchange Control Number
        edit(:ISA12) do
          isa.element(12).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "017", "must be present")
            end
          end
        end

        # Interchange Control Number
        edit(:ISA13) do
          isa.element(13).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "018", "must be present")
            elsif e.node.invalid?
              acc.ta105(e, "R", "018", "must be numeric")
            elsif e.node <= 0
              acc.ta105(e, "R", "018", "must be positive")
            end
          end
        end

        # Acknowledgment Requested
        edit(:ISA14) do
          isa.element(14).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "019", "must be present")
            elsif e.node.usage.allowed_values.exclude?(e.node.to_s)
              acc.ta105(e, "R", "019", "is not an allowed value")
            end
          end
        end

        # Interchange Usage Indicator
        edit(:ISA15) do
          isa.element(15).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "020", "must be present")
            elsif e.node.usage.allowed_values.exclude?(e.node.to_s)
              acc.ta105(e, "R", "020", "is not an allowed value")
            end
          end
        end

        # Component Element Separator
        edit(:ISA16) do
          isa.element(16).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "027", "must be present")
            elsif e.node.invalid? or not config.editor.an?(e.node)
              acc.ta105(e, "R", "027", "is not a valid string")
            else
              isa.element(11).tap do |f|
                if e.node == f.node
                  acc.ta105(e, "R", "027", "must be distinct from repetition separator")
                end
              end
            end
          end
        end

        m, gs06s = isa.find!(:GS), Hash.new{|h,k| h[k] = [] }
        # Collect all the GS06 elements within this interchange
        while m.defined?
          m = m.flatmap do |gs|
            edit_gs(gs, acc)

            gs.element(6).tap{|e| gs06s[e.node.to_s] << e }
            gs.find!(:GS)
          end
        end

        # Group Control Number
        edit(:GS06) do
          gs06s.each do |number, dupes|
            next if number.blank?
            dupes.tail.each do |e|
              acc.ak905(e, "R", "19", "must be unique within interchange")
            end
          end
        end

        edit(:IEA) do
          isa.find(:IEA).tap do |iea|
            edit_iea(iea, isa, gs06s.length, acc)
          end.explain do
            isa.segment.tap{|s| acc.ta105(s, "R", "023", "missing IEA segment") }
          end
        end
      end

      def edit_iea(iea, isa, gs_count, acc)
        # @todo: acc.ta105(s, "024", "only one IEA segment is allowed")

        # Number of Included Functional Groups
        edit(:IEA01) do
          iea.element(1).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "021", "must be present")
            elsif e.node.invalid?
              acc.ta105(e, "R", "021", "must be numeric")
            elsif e.node != gs_count
              acc.ta105(e, "R", "021", "must equal the number of functional groups")
            end
          end
        end

        # Interchange Control Number
        edit(:IEA02) do
          iea.element(2).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "001", "must be present")
            else
              isa.element(13).reject{|f| e.node == f.node }.tap do
                acc.ta105(e, "R", "001", "must match interchange header control number")
              end
            end
          end
        end
      end

      #
      # @see FiftyTenEd#validate
      #
      def edit_gs(gs, acc)
        gs.segment.tap do |x|
          unless x.node.invalid?
            envelope_def = x.node.definition.parent.parent

            # Invoke the version-specific functional group editor
            if config.editor.defined_at?(envelope_def)
              editor = config.editor.at(envelope_def)
              editor.new(config, received).validate(gs, acc)
            end
          else
            # Probably "unknown interchange version '...'"
            acc.ak905(x, "R", "2", x.node.reason)
          end
        end
      end
    end

  end
end
