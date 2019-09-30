unless defined? SimpleDelegator
  require "delegate"
end

module Definitions
  using Stupidedi::Refinements

  class FunctionalGroupDelegator < SimpleDelegator
    def empty
      Stupidedi::Values::FunctionalGroupVal.new(self, [])
    end

    def segment_dict
      SegmentDefs
    end
  end

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
    Stupidedi::Schema::CodeList.internal(*args)
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

  module ElementDefs
    DE_ID   = Stupidedi::Versions::Common::ElementTypes::ID.new(:DE1, "DE1 (ID)",   1,  1,
      Stupidedi::Schema::CodeList.internal(Hash[("A".."Z").map{|x| [x, "Meaning of #{x}"]}]))
    DE_AN   = Stupidedi::Versions::Common::ElementTypes::AN.new(:DE2, "DE2 (AN)",   1, 10)
    DE_DT6  = Stupidedi::Versions::Common::ElementTypes::DT.new(:DE3, "DE3 (DT/6)", 6,  6)
    DE_DT8  = Stupidedi::Versions::Common::ElementTypes::DT.new(:DE4, "DE4 (DT/8)", 8,  8)
    DE_TM   = Stupidedi::Versions::Common::ElementTypes::TM.new(:DE5, "DE5 (TM)",   4,  8)
    DE_R    = Stupidedi::Versions::Common::ElementTypes:: R.new(:DE6, "DE6 (R)",    1,  6)
    DE_N0   = Stupidedi::Versions::Common::ElementTypes::Nn.new(:DE7, "DE7 (N0)",   1,  6, 0)
    DE_N1   = Stupidedi::Versions::Common::ElementTypes::Nn.new(:DE8, "DE8 (N1)",   1,  6, 1)
    DE_N2   = Stupidedi::Versions::Common::ElementTypes::Nn.new(:DE9, "DE9 (N2)",   1,  6, 2)
    DE_CON  = Stupidedi::Schema::CompositeElementDef.build(:DE_CON, "CE NNN", "",
      DE_N0.component_use(ElementReqs::Mandatory),
      DE_N0.component_use(ElementReqs::Mandatory),
      DE_N0.component_use(ElementReqs::Optional))
    DE_COI  = Stupidedi::Schema::CompositeElementDef.build(:DE_COI, "CE COI", "",
      DE_ID.component_use(ElementReqs::Optional))
  end

  def de_ID ; ElementDefs::DE_ID  end
  def de_AN ; ElementDefs::DE_AN  end
  def de_DT6; ElementDefs::DE_DT6 end
  def de_DT8; ElementDefs::DE_DT8 end
  def de_TM ; ElementDefs::DE_TM  end
  def de_R  ; ElementDefs::DE_R   end
  def de_N0 ; ElementDefs::DE_N0  end
  def de_N1 ; ElementDefs::DE_N1  end
  def de_N2 ; ElementDefs::DE_N2  end
  def de_CON; ElementDefs::DE_CON end
  def de_COI; ElementDefs::DE_COI end

  module SegmentDefs
    ANA =
      Stupidedi::Schema::SegmentDef.build(:ANA, "Example Segment", "",
        ElementDefs::DE_AN.simple_use(ElementReqs::Mandatory, RepeatCount.bounded(1)),
        ElementDefs::DE_AN.simple_use(ElementReqs::Optional,  RepeatCount.bounded(1)))

    ANB =
      Stupidedi::Schema::SegmentDef.build(:ANB, "Example Segment", "",
        ElementDefs::DE_AN.simple_use(ElementReqs::Mandatory, RepeatCount.bounded(1)),
        ElementDefs::DE_AN.simple_use(ElementReqs::Optional,  RepeatCount.bounded(1)))

    IDA =
      Stupidedi::Schema::SegmentDef.build(:IDA, "Example Segment", "",
        ElementDefs::DE_ID.simple_use(ElementReqs::Mandatory, RepeatCount.bounded(1)),
        ElementDefs::DE_AN.simple_use(ElementReqs::Optional,  RepeatCount.bounded(1)),
        ElementDefs::DE_N0.simple_use(ElementReqs::Optional,  RepeatCount.bounded(1)))

    IDB =
      Stupidedi::Schema::SegmentDef.build(:IDB, "Example Segment", "",
        ElementDefs::DE_ID.simple_use(ElementReqs::Mandatory, RepeatCount.bounded(1)),
        ElementDefs::DE_AN.simple_use(ElementReqs::Optional,  RepeatCount.bounded(1)),
        ElementDefs::DE_N0.simple_use(ElementReqs::Optional,  RepeatCount.bounded(1)))

    IDC =
      Stupidedi::Schema::SegmentDef.build(:IDC, "Example Segment", "",
        ElementDefs::DE_ID.simple_use(ElementReqs::Mandatory, RepeatCount.bounded(1)),
        ElementDefs::DE_AN.simple_use(ElementReqs::Optional,  RepeatCount.bounded(1)),
        ElementDefs::DE_N0.simple_use(ElementReqs::Optional,  RepeatCount.bounded(1)))

    NNA =
      Stupidedi::Schema::SegmentDef.build(:NNA, "Example Segment", "",
        ElementDefs::DE_N0.simple_use(ElementReqs::Mandatory, RepeatCount.bounded(1)),
        ElementDefs::DE_AN.simple_use(ElementReqs::Optional,  RepeatCount.bounded(1)))

    NNB =
      Stupidedi::Schema::SegmentDef.build(:NNB, "Example Segment", "",
        ElementDefs::DE_N0.simple_use(ElementReqs::Mandatory, RepeatCount.bounded(1)),
        ElementDefs::DE_AN.simple_use(ElementReqs::Optional,  RepeatCount.bounded(1)))

    COM =
      Stupidedi::Schema::SegmentDef.build(:COM, "Example Segment", "",
        ElementDefs::DE_CON.simple_use(ElementReqs::Optional, RepeatCount.bounded(1)))

    COI =
      Stupidedi::Schema::SegmentDef.build(:COI, "Example Segment", "",
        ElementDefs::DE_COI.simple_use(ElementReqs::Optional, RepeatCount.bounded(1)))

    COJ =
      Stupidedi::Schema::SegmentDef.build(:COJ, "Example Segment", "",
        ElementDefs::DE_COI.simple_use(ElementReqs::Optional, RepeatCount.bounded(1)))

    COK =
      Stupidedi::Schema::SegmentDef.build(:COK, "Example Segment", "",
        ElementDefs::DE_COI.simple_use(ElementReqs::Optional, RepeatCount.bounded(1)))

    COR =
      Stupidedi::Schema::SegmentDef.build(:COR, "Example Segment", "",
        ElementDefs::DE_CON.simple_use(ElementReqs::Optional, RepeatCount.bounded(3)))

    COS =
      Stupidedi::Schema::SegmentDef.build(:COS, "Example Segment", "",
        ElementDefs::DE_CON.simple_use(ElementReqs::Mandatory, RepeatCount.bounded(1)))

    REP =
      Stupidedi::Schema::SegmentDef.build(:REP, "Example Segment", "",
        ElementDefs::DE_N0.simple_use(ElementReqs::Optional, RepeatCount.bounded(3)))
  end

  def NNA; SegmentDefs::NNA end
  def NNB; SegmentDefs::NNB end
  def COM; SegmentDefs::COM end
  def COR; SegmentDefs::COR end
  def COS; SegmentDefs::COS end
  def REP; SegmentDefs::REP end

  def ANA(*args) AN_(SegmentDefs::ANA, *args) end
  def ANB(*args) AN_(SegmentDefs::ANB, *args) end
  def AN_(segment_def, changes = {})
    segment_def.then do |s|
      return s if changes.empty?
      s.copy(:element_uses => s.element_uses.map{|u| u.copy(:definition => u.definition.copy(changes))})
    end
  end

  def IDA(*args) ID_(SegmentDefs::IDA, *args) end
  def IDB(*args) ID_(SegmentDefs::IDB, *args) end
  def IDC(*args) ID_(SegmentDefs::IDC, *args) end
  def ID_(segment_def, allowed_values = [], name = nil)
    segment_def.then do |s|
      return s if allowed_values.empty? and name.nil?
      s.copy(
        :name         => name || s.name,
        :element_uses => s.element_uses.head.then do |u|
          u.copy(:allowed_values => u.allowed_values.replace(allowed_values))
        end.cons(s.element_uses.tail))
    end
  end

  def COI(*args) CO_(SegmentDefs::COI, *args) end
  def COJ(*args) CO_(SegmentDefs::COJ, *args) end
  def COK(*args) CO_(SegmentDefs::COK, *args) end
  def CO_(segment_def, allowed_values = [], name = nil)
    segment_def.then do |s|
      return s if allowed_values.empty? and name.nil?
      s.copy(
        :name         => name || s.name,
        :element_uses => s.element_uses.head.then do |u|
          u.copy(:definition => u.definition.then do |c|
            c.copy(:component_uses => c.component_uses.head.then do |x|
              x.copy(:allowed_values => x.allowed_values.replace(allowed_values))
            end.cons(c.component_uses.tail))
          end)
        end.cons(s.element_uses.tail))
    end
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
      when Stupidedi::Exceptions::InvalidSchemaError, Exception
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
