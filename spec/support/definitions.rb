Definitions = Class.new do
  using Stupidedi::Refinements

  def collect(namespace, visited = Set.new, &block)
    namespace.constants.flat_map do |name|
      child = [namespace, name].join("::")

      if visited.include?(child)
        []
      else
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
  end

  # @return [Array<String, type>]
  def select(type, namespace, visited = Set.new, &block)
    collect(namespace, visited) do |name, value, error, visited, recurse|
      case error
      when Exception
        []
      else
        if value.is_a?(Module)
          select(type, value, visited, &recurse)
        elsif value.is_a?(type)
          [[name, value]]
        else
          []
        end
      end
    end
  end

  # @return [Array<String, InterchangeDef>]
  def interchange_defs(root = Stupidedi::Interchanges)
    select(Stupidedi::Schema::InterchangeDef, root)
  end

  # @return [Array<String, FunctionalGroupDef>]
  def functional_group_defs(root = Stupidedi::Versions)
    select(Stupidedi::Schema::FunctionalGroupDef, root)
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

  # @return [Array<String, SegmentDef>]
  def segment_defs(root = Stupidedi)
    select(Stupidedi::Schema::SegmentDef, root)
  end

  # @return [Array<String, AbstractElementDef>]
  def element_defs(root = Stupidedi)
    select(Stupidedi::Schema::AbstractElementDef, root)
  end
end.new
