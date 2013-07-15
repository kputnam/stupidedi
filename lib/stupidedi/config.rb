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
          #x.register("00200") { Stupidedi::Versions::Interchanges::FourOhOne::InterchangeDef }
          x.register("00200") { Stupidedi::Versions::Interchanges::TwoHundred::InterchangeDef }
          x.register("00401") { Stupidedi::Versions::Interchanges::FourOhOne::InterchangeDef }
          x.register("00501") { Stupidedi::Versions::Interchanges::FiveOhOne::InterchangeDef }
        end

        c.functional_group.customize do |x|
          # x.register("002001") { Stupidedi::Versions::FunctionalGroups::FortyTen::FunctionalGroupDef }
          x.register("002001") { Stupidedi::Versions::FunctionalGroups::TwoThousandOne::FunctionalGroupDef }
          x.register("004010") { Stupidedi::Versions::FunctionalGroups::FortyTen::FunctionalGroupDef }
          x.register("005010") { Stupidedi::Versions::FunctionalGroups::FiftyTen::FunctionalGroupDef }
        end
      end
    end

    def hipaa(base = default)
      base.customize do |c|
        c.transaction_set.customize do |x|
          x.register("005010", "HN", "277") { Stupidedi::Versions::FunctionalGroups::FiftyTen::TransactionSetDefs::HN277 }
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

    def contrib(base = default)
      base.customize do |c|
        c.transaction_set.customize do |x|
          x.register("004010", "PO", "850") { Stupidedi::Contrib::FortyTen::TransactionSetDefs::PO850 }
          x.register("004010", "OW", "940") { Stupidedi::Contrib::FortyTen::TransactionSetDefs::OW940 }
          x.register("004010", "AR", "943") { Stupidedi::Contrib::FortyTen::TransactionSetDefs::AR943 }
          x.register("004010", "RE", "944") { Stupidedi::Contrib::FortyTen::TransactionSetDefs::RE944 }
          x.register("004010", "SW", "945") { Stupidedi::Contrib::FortyTen::TransactionSetDefs::SW945 }
          x.register("004010", "FA", "997") { Stupidedi::Contrib::FortyTen::TransactionSetDefs::FA997 }

          x.register("004010", "SM", "204") { Stupidedi::Contrib::FortyTen::TransactionSetDefs::SM204 }
          x.register("004010", "QM", "214") { Stupidedi::Contrib::FortyTen::TransactionSetDefs::QM214 }
          x.register("004010", "GF", "990") { Stupidedi::Contrib::FortyTen::TransactionSetDefs::GF990 }

          x.register("002001", "SH", "856") { Stupidedi::Contrib::TwoThousandOne::TransactionSetDefs::SH856 }
 
          # x.register("004010", "SM", "204") { Stupidedi::Contrib::FortyTen::Guides::SM204 }
          # x.register("004010", "QM", "214") { Stupidedi::Contrib::FortyTen::Guides::QM214 }
          # x.register("004010", "GF", "990") { Stupidedi::Contrib::FortyTen::Guides::GF990 }
        end
      end
    end

    # @endgroup
    ###########################################################################
  end

end
