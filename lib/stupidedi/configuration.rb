module Stupidedi

  module Configuration
    autoload :CodeListConfig,         "stupidedi/configuration/code_list_config"
    autoload :FunctionalGroupConfig,  "stupidedi/configuration/functional_group_config"
    autoload :InterchangeConfig,      "stupidedi/configuration/interchange_config"
    autoload :TransactionSetConfig,   "stupidedi/configuration/transaction_set_config"

    class RootConfig
      # @return [InterchangeConfig]
      attr_reader :interchange

      # @return [FunctionalGroupConfig]
      attr_reader :functional_group

      # @return [TransactionSetConfig]
      attr_reader :transaction_set

      # @return [CodeListConfig]
      attr_reader :code_list

      def initialize
        @interchange      = InterchangeConfig.new
        @functional_group = FunctionalGroupConfig.new
        @transaction_set  = TransactionSetConfig.new
        @code_list        = CodeListConfig.new
      end

      # @private
      def pretty_print(q)
        q.text "Configuration"
        q.group 2, "(", ")" do
          q.breakable ""

          q.pp @interchange
          q.text ","
          q.breakable

          q.pp @functional_group
          q.text ","
          q.breakable

          q.pp @transaction_set
          q.text ","
          q.breakable

          q.pp @code_list
        end
      end
    end
  end

  class << Configuration
    def new
      Configuration::RootConfig.new
    end
  end

end
