module Stupidedi

  class Config
    autoload :CodeListConfig,         "stupidedi/config/code_list_config"
    autoload :EditorConfig,           "stupidedi/config/editor_config"
    autoload :FunctionalGroupConfig,  "stupidedi/config/functional_group_config"
    autoload :InterchangeConfig,      "stupidedi/config/interchange_config"
    autoload :TransactionSetConfig,   "stupidedi/config/transaction_set_config"

    include Inspect

    # @return [InterchangeConfig]
    attr_reader :interchange

    # @return [FunctionalGroupConfig]
    attr_reader :functional_group

    # @return [TransactionSetConfig]
    attr_reader :transaction_set

    # @return [CodeListConfig]
    attr_reader :code_list

    # @return [EditorConfig]
    attr_reader :editor

    def initialize
      @interchange      = InterchangeConfig.new
      @functional_group = FunctionalGroupConfig.new
      @transaction_set  = TransactionSetConfig.new
      @code_list        = CodeListConfig.new
      @editor           = EditorConfig.new
    end

    alias customize tap

    # @return [void]
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
        q.text ","
        q.breakable

        q.pp @editor
      end
    end
  end

  class << Config
    ###########################################################################
    # @group Constructors

    # @return [Config]
    def default
      new.customize do |c|
        c.interchange.customize do |x|
          x.register("00501") { Stupidedi::Versions::Interchanges::FiveOhOne::InterchangeDef }
        end

        c.functional_group.customize do |x|
          x.register("005010") { Stupidedi::Versions::FunctionalGroups::FiftyTen::FunctionalGroupDef }
        end

        c.transaction_set.customize do |x|
          x.register("004010STP820", "RA", "820") { Stupidedi::Guides::FortyTen::STP::RA820 }

          x.register("005010", "HN", "277") { Stupidedi::Versions::FunctionalGroups::FiftyTen::TransactionSetDefs::HN277 }
          x.register("005010", "RA", "820") { Stupidedi::Versions::FunctionalGroups::FiftyTen::TransactionSetDefs::RA820 }
          x.register("005010", "HP", "835") { Stupidedi::Versions::FunctionalGroups::FiftyTen::TransactionSetDefs::HP835 }
          x.register("005010", "HC", "837") { Stupidedi::Versions::FunctionalGroups::FiftyTen::TransactionSetDefs::HC837 }
          x.register("005010", "FA", "999") { Stupidedi::Versions::FunctionalGroups::FiftyTen::TransactionSetDefs::FA999 }

          x.register("005010X214", "HN", "277") { Stupidedi::Guides::FiftyTen::X214::HN277  }
          x.register("005010X221", "HP", "835") { Stupidedi::Guides::FiftyTen::X221::HP835  }
          x.register("005010X222", "HC", "837") { Stupidedi::Guides::FiftyTen::X222::HC837P }
          x.register("005010X231", "FA", "999") { Stupidedi::Guides::FiftyTen::X231::FA999  }

          x.register("005010X221A1", "HP", "835") { Stupidedi::Guides::FiftyTen::X221A1::HP835  }
          x.register("005010X222A1", "HC", "837") { Stupidedi::Guides::FiftyTen::X222A1::HC837P }
          x.register("005010X231A1", "FA", "999") { Stupidedi::Guides::FiftyTen::X231A1::FA999  }
        end
      end
    end

    # @endgroup
    ###########################################################################
  end

end
