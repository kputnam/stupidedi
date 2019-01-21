module Definitions
  def Header(*args)
    Stupidedi::Schema::TableDef.header(*args)
  end

  def Detail(*args)
    Stupidedi::Schema::TableDef.detail(*args)
  end

  def Summary(*args)
    Stupidedi::Schema::TableDef.summary(*args)
  end

  def Loop(*args)
    Stupidedi::Schema::LoopDef.build(*args)
  end

  def Segment(position, segment_id, *args)
    Stupidedi::Versions::FiftyTen::SegmentDefs.const_get(segment_id).use(position, *args)
  end

  def Segment_(position, segment_id, name, requirement, repeat, *args)
    Stupidedi::Schema::SegmentDef.build(segment_id, name, "", *args).use(position, requirement, repeat)
  end

  def Element(id, *args)
    Stupidedi::Versions::FiftyTen::ElementDefs.const_get(id).simple_use(*args)
  end

  def P(*args)
    Stupidedi::Versions::FiftyTen::SyntaxNotes::P.build(*args)
  end

  def R(*args)
    Stupidedi::Versions::FiftyTen::SyntaxNotes::R.build(*args)
  end

  def E(*args)
    Stupidedi::Versions::FiftyTen::SyntaxNotes::E.build(*args)
  end

  def C(*args)
    Stupidedi::Versions::FiftyTen::SyntaxNotes::C.build(*args)
  end

  def L(*args)
    Stupidedi::Versions::FiftyTen::SyntaxNotes::L.build(*args)
  end

  def bounded(n)
    Stupidedi::Schema::RepeatCount.bounded(n)
  end

  def unbounded
    Stupidedi::Schema::RepeatCount.unbounded
  end

  def s_mandatory
    Stupidedi::Versions::FiftyTen::SegmentReqs::Mandatory
  end

  def s_optional
    Stupidedi::Versions::FiftyTen::SegmentReqs::Optional
  end

  def s_required
    Stupidedi::TransactionSets::Common::Implementations::SegmentReqs::Required
  end

  def s_situational
    Stupidedi::TransactionSets::Common::Implementations::SegmentReqs::Situational
  end

  def e_mandatory
    Stupidedi::Versions::FiftyTen::ElementReqs::Mandatory
  end

  def e_relational
    Stupidedi::Versions::FiftyTen::ElementReqs::Relational
  end

  def e_optional
    Stupidedi::Versions::FiftyTen::ElementReqs::Optional
  end

  def e_required
    Stupidedi::TransactionSets::Common::Implementations::ElementReqs::Required
  end

  def e_situational
    Stupidedi::TransactionSets::Common::Implementations::ElementReqs::Situational
  end

  def e_not_used
    Stupidedi::TransactionSets::Common::Implementations::ElementReqs::NotUsed
  end
end

class << Definitions
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
end
