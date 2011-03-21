module Stupidedi
  module Config
    autoload :CodeListConfig,         "stupidedi/config/code_list_config"
    autoload :FunctionalGroupConfig,  "stupidedi/config/functional_group_config"
    autoload :InterchangeConfig,      "stupidedi/config/interchange_config"
    autoload :TransactionSetConfig,   "stupidedi/config/transaction_set_config"

    class RootConfig
      include Inspect

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
        q.text "Config"
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

  class << Config
    def new
      Config::RootConfig.new
    end
  end

end
