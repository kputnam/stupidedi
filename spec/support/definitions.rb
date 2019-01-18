Definitions = Class.new do
  using Stupidedi::Refinements

  def collect(namespace, visited = Set.new, &block)
    namespace.constants.flat_map do |name|
      child = [namespace, name].join("::")
      visited.add(child)

      value, error =
        begin
          [namespace.const_get(name), nil]
        rescue => error
          [nil, error]
        end

      block.call(child, value, error, visited, block)
    end
  end

  # @return [Array<String, TransactionSetDef, Exception>]
  def transaction_set_defs(root = Stupidedi::TransactionSets)
    collect(root) do |name, value, error, visited, recurse|
      case error
      when Stupidedi::Exceptions::InvalidSchemaError
        [[name, value, error]]
      when Exception
        error.backtrace.reject!{|x| x =~ %r{spec/}}
        error.print(name: name)
        []
      else
        case value
        when Module
          collect(value, visited, &recurse)
        when Stupidedi::Schema::TransactionSetDef
          [[name, value, error]]
        else
          []
        end
      end
    end
  end

  def segments(root = Stupidedi::Versions)
  end

  def elements(root = Stupidedi::Versions)
  end

  def interchanges(root = Stupidedi::Interchanges)
  end

end.new
