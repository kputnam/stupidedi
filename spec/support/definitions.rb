module Definitions
  using Stupidedi::Refinements

  # Define a new header Table
  def Header(*args)
    Stupidedi::Schema::TableDef.header(*args)
  end

  # Define a new detail Table
  def Detail(*args)
    Stupidedi::Schema::TableDef.detail(*args)
  end

  # Define a new summary Table
  def Summary(*args)
    Stupidedi::Schema::TableDef.summary(*args)
  end

  # Define a new loop
  def Loop(*args)
    Stupidedi::Schema::LoopDef.build(*args)
  end

  # Declare that a segment is used (eg, in a Loop or Table)
  def Segment(position, segment, *args)
    case segment
    when Symbol
      Stupidedi::Versions::FiftyTen::SegmentDefs.const_get(segment).use(position, *args)
    when Stupidedi::Schema::SegmentDef
      segment.use(position, *args)
    else
      raise ArgumentError,
        "second argument must be a Symbol or a Stupidedi::Schema::SegmentDef"
    end
  end

  def Segment_(position, segment_id, name, requirement, repeat, *args)
    Stupidedi::Schema::SegmentDef.build(segment_id, name, "", *args).use(position, requirement, repeat)
  end

  def Element(element, *args)
    case element
    when Symbol
      Stupidedi::Versions::FiftyTen::ElementDefs.const_get(id).simple_use(*args)
    when Stupidedi::Schema::AbstractElementDef
      element.simple_use(*args)
    end
  end

  def CodeList(*args)
    Stupidedi::Schema::CodeList.external(*args)
  end

  RepeatCount   = Stupidedi::Schema::RepeatCount
  ElementReqs   = Stupidedi::Versions::Common::ElementReqs
  SegmentReqs   = Stupidedi::Versions::Common::SegmentReqs
  ElementReqs_  = Stupidedi::TransactionSets::Common::Implementations::ElementReqs
  SegmentReqs_  = Stupidedi::TransactionSets::Common::Implementations::SegmentReqs
  SyntaxNotes   = Stupidedi::Versions::FiftyTen::SyntaxNotes

  # Use this within `Segment` to declare "if any element specified in the relation
  # is present, then all elements must be present"
  def P(*args)
    SyntaxNotes::P.build(*args)
  end

  # Use this within `Segment` to declare "at least one of the elements specified
  # in this relation are required"
  def R(*args)
    SyntaxNotes::R.build(*args)
  end

  # Use this within `Segment` to declare "not more than one of the elements in
  # this relation may be present"
  def E(*args)
    SyntaxNotes::E.build(*args)
  end

  # Use this within `Segment` to declare "if the first element in the relation
  # is present, then all others must be present"
  def C(*args)
    SyntaxNotes::C.build(*args)
  end

  # Use this within `Segment` to declare "if the first element in the relation
  # is present, then at least one other must be present"
  def L(*args)
    SyntaxNotes::L.build(*args)
  end

  # Repetition designator for Loops, Segments, and Elements
  def bounded(n)
    RepeatCount.bounded(n)
  end

  # Repetition designator for Loops, Segments, and Elements
  def unbounded
    RepeatCount.unbounded
  end

  # Requirement designator for Segments (not Elements!)
  def s_mandatory
    SegmentReqs::Mandatory
  end

  # Requirement designator for Segments (not Elements!)
  def s_optional
    SegmentReqs::Optional
  end

  # Requirement designator for Segments (not Elements!)
  def s_required
    SegmentReqs_::Required
  end

  # Requirement designator for Segments (not Elements!)
  def s_situational
    SegmentReqs_::Situational
  end

  # Requirement designator for Elements (not Segments!)
  def e_mandatory
    ElementReqs::Mandatory
  end

  # Requirement designator for Elements (not Segments!)
  def e_relational
    ElementReqs::Relational
  end

  # Requirement designator for Elements (not Segments!)
  def e_optional
    ElementReqs::Optional
  end

  # Requirement designator for Elements (not Segments!)
  def e_required
    ElementReqs_::Required
  end

  # Requirement designator for Elements (not Segments!)
  def e_situational
    ElementReqs_::Situational
  end

  # Requirement designator for Elements (not Segments!)
  def e_not_used
    ElementReqs_::NotUsed
  end

  DE_ID   = Stupidedi::Versions::Common::ElementTypes::ID.new(:DE1, "DE1 (ID)",   1,  1, Stupidedi::Schema::CodeList.external(Hash[("A".."Z").map{|x| [x, "Meaning of #{x}"]}]))
  DE_AN   = Stupidedi::Versions::Common::ElementTypes::AN.new(:DE2, "DE2 (AN)",   1, 10)
  DE_DT6  = Stupidedi::Versions::Common::ElementTypes::DT.new(:DE3, "DE3 (DT/6)", 6,  6)
  DE_DT8  = Stupidedi::Versions::Common::ElementTypes::DT.new(:DE4, "DE4 (DT/8)", 8,  8)
  DE_TM   = Stupidedi::Versions::Common::ElementTypes::TM.new(:DE5, "DE5 (TM)",   4,  8)
  DE_R    = Stupidedi::Versions::Common::ElementTypes:: R.new(:DE6, "DE6 (R)",    1,  6)
  DE_N0   = Stupidedi::Versions::Common::ElementTypes::Nn.new(:DE7, "DE7 (N0)",   1,  6, 0)
  DE_N1   = Stupidedi::Versions::Common::ElementTypes::Nn.new(:DE8, "DE8 (N1)",   1,  6, 1)
  DE_N2   = Stupidedi::Versions::Common::ElementTypes::Nn.new(:DE9, "DE9 (N2)",   1,  6, 2)

  def de_ID ; DE_ID  end
  def de_AN ; DE_AN  end
  def de_DT6; DE_DT6 end
  def de_DT8; DE_DT8 end
  def de_TM ; DE_TM  end
  def de_R  ; DE_R   end
  def de_N0 ; DE_N0  end
  def de_N1 ; DE_N1  end
  def de_N2 ; DE_N2  end

  ANA =
    Stupidedi::Schema::SegmentDef.build(:ANA, "Example Segment", "",
      DE_AN.simple_use(ElementReqs::Mandatory, RepeatCount.bounded(1)),
      DE_AN.simple_use(ElementReqs::Optional,  RepeatCount.bounded(1)))

  def ANA(changes = {})
    if changes.empty?
      ANA
    else
      ANA.copy(:element_uses => ANB.element_uses.map do |u|
        u.copy(:definition => u.definition.copy(changes))
      end)
    end
  end

  ANB =
    Stupidedi::Schema::SegmentDef.build(:ANB, "Example Segment", "",
      DE_AN.simple_use(ElementReqs::Mandatory, RepeatCount.bounded(1)),
      DE_AN.simple_use(ElementReqs::Optional,  RepeatCount.bounded(1)))

  def ANB(changes = {})
    if changes.empty?
      ANB
    else
      ANB.copy(:element_uses => ANB.element_uses.map do |u|
        u.copy(:definition => u.definition.copy(changes))
      end)
    end
  end

  NNA =
    Stupidedi::Schema::SegmentDef.build(:NNA, "Example Segment", "",
      DE_N0.simple_use(ElementReqs::Mandatory, RepeatCount.bounded(1)),
      DE_AN.simple_use(ElementReqs::Optional,  RepeatCount.bounded(1)))

  def NNA; NNA; end

  NNB =
    Stupidedi::Schema::SegmentDef.build(:NNB, "Example Segment", "",
      DE_N0.simple_use(ElementReqs::Mandatory, RepeatCount.bounded(1)),
      DE_AN.simple_use(ElementReqs::Optional,  RepeatCount.bounded(1)))

  def NNB; NNB; end

  def IDA(qualifiers = [])
    Stupidedi::Schema::SegmentDef.build(:IDA, "Example Segment", "",
      DE_ID.simple_use(ElementReqs::Mandatory, RepeatCount.bounded(1)).bind{|u| if qualifiers.empty? then u else u.copy(:allowed_values => u.allowed_values.replace(qualifiers)) end },
      DE_AN.simple_use(ElementReqs::Optional,  RepeatCount.bounded(1)),
      DE_N0.simple_use(ElementReqs::Optional,  RepeatCount.bounded(1)))
  end

  def IDB(qualifiers = [])
    Stupidedi::Schema::SegmentDef.build(:IDB, "Example Segment", "",
      DE_ID.simple_use(ElementReqs::Mandatory, RepeatCount.bounded(1)).bind{|u| if qualifiers.empty? then u else u.copy(:allowed_values => u.allowed_values.replace(qualifiers)) end },
      DE_AN.simple_use(ElementReqs::Optional,  RepeatCount.bounded(1)),
      DE_N0.simple_use(ElementReqs::Optional,  RepeatCount.bounded(1)))
  end

  def IDC(qualifiers = [])
    Stupidedi::Schema::SegmentDef.build(:IDC, "Example Segment", "",
      DE_ID.simple_use(ElementReqs::Mandatory, RepeatCount.bounded(1)).bind{|u| if qualifiers.empty? then u else u.copy(:allowed_values => u.allowed_values.replace(qualifiers)) end },
      DE_AN.simple_use(ElementReqs::Optional,  RepeatCount.bounded(1)),
      DE_N0.simple_use(ElementReqs::Optional,  RepeatCount.bounded(1)))
  end
end

class << Definitions
  using Stupidedi::Refinements

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

private

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
    collect(namespace, visited) do |name, value, error, visited_, recurse|
      case error
      when Exception
        []
      else
        if value.is_a?(Module)
          select(type, value, visited_, &recurse)
        elsif value.is_a?(type)
          [[name, value]]
        else
          []
        end
      end
    end
  end
end
