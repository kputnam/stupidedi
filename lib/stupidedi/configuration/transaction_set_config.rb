module Stupidedi
  module Configuration

    #
    # The implementation version specified in GS08 and ST03 indicates which
    # implementation guide governs the transaction. Because each guide may
    # define multiple transaction sets (eg X212 and X279), the functional code
    # and transaction set code are needed to lookup a definition.
    #
    # In english, we can't just look at ST01 and link "837" to our definition of
    # 837P from the HIPAA guide.
    #
    class TransactionSetConfig
      def initialize
        @table = Hash.new
      end

      # @example
      #   table = TransactionSetConfig.new(functional_group_implementation)
      #
      #   table.register(Hipaa::X212::HR276, "005010X212")#, "HR", "276")
      #   table.register(Hipaa::X212::HN277, "005010X212")#, "HN", "277")
      #
      #   table.register(Hipaa::X217::HI278, "005010X217")#, "HI", "278")
      #   table.register(Hipaa::X218::820RA, "005010X218")#, "RA", "820")
      #   table.register(Hipaa::X220::BE834, "005010X220")#, "BE", "834")
      #   table.register(Hipaa::X221::HP835, "005010X221")#, "HP", "835")
      #
      #   table.register(Hipaa::X222::HC837, "005010X222")#, "HC", "837")
      #   table.register(Hipaa::X223::HC837, "005010X223")#, "HC", "837")
      #   table.register(Hipaa::X224::HC837, "005010X224")#, "HC", "837")
      #
      #   table.register(Hipaa::X230::FA997, "005010X230")#, "FA", "997")
      #   table.register(Hipaa::X231::FA999, "005010X231")#, "FA", "999")
      #
      #   table.register(Hipaa::X279::HS270, "005010X279")#, "HS", "270")
      #   table.register(Hipaa::X279::HB271, "005010X279")#, "HB", "271")
      #
      #   table.register(Standards::HR276, "005010")#, "HR", "276")
      #   table.register(Standards::HS270, "005010")#, "HS", "270")
      #   table.register(Standards::HB271, "005010")#, "HB", "271")
      #   table.register(Standards::HN277, "005010")#, "HN", "277")
      #   table.register(Standards::HI278, "005010")#, "HI", "278")
      #   table.register(Standards::820RA, "005010")#, "RA", "820")
      #   table.register(Standards::BE834, "005010")#, "BE", "834")
      #   table.register(Standards::HP835, "005010")#, "HP", "835")
      #   table.register(Standards::HC837, "005010")#, "HC", "837")
      #   table.register(Standards::FA997, "005010")#, "FA", "997")
      #   table.register(Standards::FA999, "005010")#, "FA", "999")
      #
      def register(definition, version, function = definition.functional_group, transaction = definition.id)
        @table[Array[version, function, transaction]] = definition
      end

      # @param version      ST03 or GS08
      # @param function     GS01
      # @param transaction  ST01
      def at(version, function, transaction)
        @table[Array[version, function, transaction]]
      end

      def defined_at?(version, function, transaction)
        @table.defined_at?([version, function, transaction])
      end

      # @private
      def pretty_print(q)
        q.text "TransactionSetConfig"
        q.group 2, "(", ")" do
          q.breakable ""
          @table.keys.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end
        end
      end
    end

  end
end
