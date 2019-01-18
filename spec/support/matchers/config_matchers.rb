module ConfigMatchers
  def have_valid_interchanges
    HaveValidInterchanges.new
  end

  def have_valid_functional_groups
    HaveValidFunctionalGroups.new
  end

  def have_valid_transaction_sets
    HaveValidTransactionSets.new
  end

  class HaveValidEntries
    def matches?(config)
      @message = nil
      config   = config.__send__(@attr_name)

      config.table.keys.each do |k|
        unless config.defined_at?(*k)
          @message = "#{@attr_name} to be defined_at?(#{k.inspect})"
          return false
        end

        unless config.at(*k).is_a?(@expected_type)
          @message = "#{@attr_name}.at(#{k.inspect}) to be #{@expected_type}"
          return false
        end
      end

      true
    end

    def failure_message
      "expected #{@message}"
    end

    def failure_message_when_negated
      "did not expect #{@message}"
    end

    def description
      self.class.name.gsub(/[A-Z][a-z]+/){|m| m.downcase + " " }.strip
    end
  end

  class HaveValidInterchanges < HaveValidEntries
    def initialize
      @attr_name     = :interchange
      @expected_type = Stupidedi::Schema::InterchangeDef
    end
  end

  class HaveValidFunctionalGroups < HaveValidEntries
    def initialize
      @attr_name     = :functional_group
      @expected_type = Stupidedi::Schema::FunctionalGroupDef
    end
  end

  class HaveValidTransactionSets < HaveValidEntries
    def initialize
      @attr_name     = :transaction_set
      @expected_type = Stupidedi::Schema::TransactionSetDef
    end
  end
end
