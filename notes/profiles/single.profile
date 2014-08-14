Thread ID: -608087168
Total Time: 0.46

  %total   %self     total      self      wait     child            calls   Name
--------------------------------------------------------------------------------
 100.00%   0.00%      0.46      0.00      0.00      0.46                1     Global#[No method]
                      0.46      0.00      0.00      0.46              1/1     Stupidedi::Builder_::StateMachine#read!
--------------------------------------------------------------------------------
                      0.46      0.00      0.00      0.46              1/1     Global#[No method]
 100.00%   0.00%      0.46      0.00      0.00      0.46                1     Stupidedi::Builder_::StateMachine#read!
                      0.29      0.00      0.00      0.29           56/320     Stupidedi::Either::Success#map
                      0.17      0.00      0.00      0.17           57/778     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00             3/26     Kernel#send
                      0.00      0.00      0.00      0.00              1/2     Module#attr_accessor
                      0.00      0.00      0.00      0.00             4/48     Class#inherited
                      0.00      0.00      0.00      0.00            57/57     Stupidedi::Either::Success#defined?
                      0.00      0.00      0.00      0.00             8/11     Module#abstract
                      0.00      0.00      0.00      0.00             2/53     Kernel#singleton_method_added
                      0.00      0.00      0.00      0.00            58/58     Stupidedi::Builder_::StateMachine#stuck?
                      0.00      0.00      0.00      0.00            1/778     <Class::Stupidedi::Either>#success
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Either::Failure#defined?
                      0.00      0.00      0.00      0.00           25/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00             3/22     Object#eigenclass
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Either::Failure#map
--------------------------------------------------------------------------------
                      0.02      0.00      0.00      0.02          264/320     Stupidedi::Either::Success#flatmap
                      0.29      0.00      0.00      0.29           56/320     Stupidedi::Builder_::StateMachine#read!
  67.39%   0.00%      0.31      0.00      0.00      0.31              320     Stupidedi::Either::Success#map
                      0.29      0.00      0.00      0.29            56/56     Stupidedi::Builder_::StateMachine#input!
                      0.02      0.01      0.00      0.01          264/264     Stupidedi::Reader::Success#map
                      0.00      0.00      0.00      0.00        320/15961     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         131/1446     Integer#times
                      0.00      0.00      0.00      0.00          17/1446     Stupidedi::Builder_::ConstraintTable::ValueBased#matches
                      0.00      0.04      0.00      0.00         357/1446     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
                      0.00      0.00      0.00      0.00          70/1446     <Class::Stupidedi::Builder_::AbstractState>#sequence
                      0.00      0.01      0.00      0.00         288/1446     Array#each
                      0.00      0.00      0.00      0.00          20/1446     Stupidedi::Builder_::ConstraintTable::ValueBased#build_disjoint
                      0.00      0.00      0.00      0.00         114/1446     Range#each
                      0.00      0.00      0.00      0.00           4/1446     Module#delegate
                      0.00      0.00      0.00      0.00          17/1446     Stupidedi::Builder_::ConstraintTable::ValueBased#deepest
                      0.00      0.00      0.00      0.00           2/1446     <Class::Stupidedi::Builder_::AbstractState>#tsequence
                      0.00      0.00      0.00      0.00           1/1446     Enumerable#inject
                      0.00      0.00      0.00      0.00          50/1446     Stupidedi::Builder_::InstructionTable::NonEmpty#successors
                      0.00      0.01      0.00      0.00          44/1446     <Class::Stupidedi::Builder_::AbstractState>#lsequence
                      0.02      0.01      0.00      0.01         275/1446     Enumerable#any?
                      0.29      0.00      0.00      0.29          56/1446     Stupidedi::Builder_::StateMachine#input!
  67.39%  15.22%      0.31      0.07      0.00      0.30             1446     Array#each
                      0.12      0.00      0.00      0.12            45/45     Stupidedi::Builder_::LoopState#drop
                      0.05      0.00      0.00      0.05            56/56     Stupidedi::Builder_::InstructionTable::NonEmpty#successors
                      0.03      0.00      0.00      0.03            31/31     Stupidedi::Builder_::LoopState#add
                      0.03      0.00      0.00      0.03            49/63     Stupidedi::Builder_::LoopState#pop
                      0.02      0.00      0.00      0.02            16/18     <Class::Stupidedi::Builder_::LoopState>#push
                      0.02      0.02      0.00      0.00      17428/18317     Fixnum#>
                      0.01      0.00      0.00      0.01              1/1     Stupidedi::Builder_::TableState#add
                      0.01      0.00      0.00      0.01              1/1     <Class::Stupidedi::Builder_::TransactionSetState>#push
                      0.01      0.00      0.00      0.01        1233/2089     Hash#[]
                      0.01      0.00      0.00      0.01              3/4     <Class::Stupidedi::Builder_::TableState>#push
                      0.01      0.00      0.00      0.01              1/1     <Class::Stupidedi::Builder_::InterchangeState>#push
                      0.01      0.01      0.00      0.00       3266/10063     String#==
                      0.00      0.00      0.00      0.00             7/14     Stupidedi::Schema::LoopDef#repeatable?
                      0.00      0.00      0.00      0.00          34/3130     Fixnum#zero?
                      0.00      0.00      0.00      0.00          386/386     #<Class:0xb75eda14>#==
                      0.00      0.00      0.00      0.00            14/14     Stupidedi::Schema::TableDef#entry_segment_uses
                      0.00      0.00      0.00      0.00        2000/3364     Kernel#nil?
                      0.00      0.00      0.00      0.00            56/95     Stupidedi::Schema::SegmentUse#repeatable?
                      0.00      0.00      0.00      0.00              3/3     Stupidedi::Builder_::TableState#drop
                      0.00      0.00      0.00      0.00           79/138     Hash#defined_at?
                      0.00      0.00      0.00      0.00              2/6     Symbol#to_sym
                      0.00      0.00      0.00      0.00            17/17     Stupidedi::Builder_::ConstraintTable::ValueBased#select
                      0.00      0.00      0.00      0.00        3334/3358     Symbol#to_s
                      0.00      0.00      0.00      0.00          543/543     #<Class:0xb75eda14>#union
                      0.00      0.00      0.00      0.00            3/696     Stupidedi::Reader::TokenReader#copy
                      0.00      0.00      0.00      0.00         148/2203     Array#length
                      0.00      0.00      0.00      0.00            18/74     Hash#at
                      0.00      0.00      0.00      0.00              2/2     Stupidedi::Builder_::FunctionalGroupState#drop
                      0.00      0.01      0.00      0.00         288/1446     Array#each
                      0.00      0.00      0.00      0.00        3266/3543     String#to_s
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Builder_::TransmissionState#drop
                      0.00      0.00      0.00      0.00           23/108     Stupidedi::Builder_::AbstractState#separators
                      0.00      0.00      0.00      0.00         343/1331     Fixnum#==
                      0.00      0.00      0.00      0.00             3/62     Module#attr_reader
                      0.00      0.00      0.00      0.00            85/85     Stupidedi::AbsoluteSet#each
                      0.00      0.00      0.00      0.00           47/941     Kernel#eql?
                      0.00      0.00      0.00      0.00          59/6012     Fixnum#-
                      0.00      0.00      0.00      0.00          330/330     Stupidedi::AbsoluteSet#union
                      0.00      0.00      0.00      0.00            20/85     Stupidedi::Builder_::AbstractState#segment_dict
                      0.00      0.00      0.00      0.00          133/133     Stupidedi::AbsoluteSet#==
                      0.00      0.00      0.00      0.00            18/20     Stupidedi::Builder_::ConstraintTable::ValueBased#build_disjoint
                      0.00      0.00      0.00      0.00            17/43     String#to_i
                      0.00      0.00      0.00      0.00        282/13457     Fixnum#+
                      0.00      0.00      0.00      0.00        281/15961     Class#new
                      0.00      0.00      0.00      0.00        1300/1482     Array#at
                      0.00      0.00      0.00      0.00            17/28     Module#class_eval
                      0.00      0.00      0.00      0.00            7/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00          154/166     Stupidedi::Schema::LoopDef#entry_segment_use
                      0.00      0.00      0.00      0.00             2/53     Kernel#singleton_method_added
                      0.00      0.00      0.00      0.00              2/2     Stupidedi::Builder_::InterchangeState#drop
                      0.00      0.00      0.00      0.00              3/7     Stupidedi::Builder_::TableState#pop
                      0.00      0.00      0.00      0.00          535/535     Stupidedi::AbstractSet#disjoint?
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Builder_::InterchangeState#add
                      0.00      0.00      0.00      0.00            97/97     Array#clear
                      0.00      0.00      0.00      0.00         929/1284     NilClass#nil?
                      0.00      0.00      0.00      0.00          56/1253     Array#empty?
                      0.00      0.00      0.00      0.00            2/274     Kernel#==
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Builder_::FunctionalGroupState#add
                      0.00      0.00      0.00      0.00             1/48     Class#inherited
                      0.00      0.00      0.00      0.00            1/177     Enumerable#inject
                      0.00      0.00      0.00      0.00          78/1944     Hash#[]=
                      0.00      0.00      0.00      0.00        1865/1885     Array#<<
                      0.00      0.00      0.00      0.00              2/3     Stupidedi::Builder_::FunctionalGroupState#pop
                      0.00      0.00      0.00      0.00              1/2     Stupidedi::Builder_::InterchangeState#pop
                      0.00      0.00      0.00      0.00              3/5     Stupidedi::Schema::TableDef#repeatable?
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Builder_::TransmissionState#pop
                      0.00      0.00      0.00      0.00              1/1     <Class::Stupidedi::Builder_::FunctionalGroupState>#push
                      0.00      0.00      0.00      0.00              3/3     Stupidedi::Builder_::TransactionSetState#drop
--------------------------------------------------------------------------------
                      0.29      0.00      0.00      0.29            56/56     Stupidedi::Either::Success#map
  63.04%   0.00%      0.29      0.00      0.00      0.29               56     Stupidedi::Builder_::StateMachine#input!
                      0.29      0.00      0.00      0.29          56/1446     Array#each
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           30/778     Integer#times
                      0.00      0.00      0.00      0.00           12/778     Stupidedi::Reader::TokenReader#read_composite_element
                      0.00      0.00      0.00      0.00           55/778     Stupidedi::Reader::TokenReader#read_segment
                      0.00      0.01      0.00      0.00          250/778     Stupidedi::Reader::TokenReader#read_elements
                      0.00      0.00      0.00      0.00            1/778     Stupidedi::Reader::StreamReader#read_segment
                      0.00      0.00      0.00      0.00           26/778     Stupidedi::Reader::TokenReader#read_component_elements
                      0.00      0.00      0.00      0.00          347/778     Stupidedi::Either::Success#flatmap
                      0.17      0.00      0.00      0.17           57/778     Stupidedi::Builder_::StateMachine#read!
  36.96%   2.17%      0.17      0.01      0.00      0.17              778     Stupidedi::Either::Success#flatmap
                      0.16      0.00      0.00      0.16            56/56     Stupidedi::Reader::TokenReader#read_segment
                      0.11      0.00      0.00      0.11          250/250     Stupidedi::Reader::TokenReader#read_elements
                      0.05      0.01      0.00      0.04          343/343     Stupidedi::Reader::TokenReader#read_delimiter
                      0.02      0.00      0.00      0.02          264/320     Stupidedi::Either::Success#map
                      0.01      0.00      0.00      0.01            55/56     Stupidedi::Reader::SegmentDict::NonEmpty#defined_at?
                      0.01      0.00      0.00      0.01             1/18     Integer#times
                      0.01      0.01      0.00      0.00         778/2313     Kernel#is_a?
                      0.01      0.00      0.00      0.01              1/1     Stupidedi::Reader::StreamReader#read_segment
                      0.01      0.00      0.00      0.01            54/55     Stupidedi::Reader::SegmentDict::NonEmpty#at
                      0.00      0.00      0.00      0.00            12/12     Stupidedi::Reader::TokenReader#composite
                      0.00      0.00      0.00      0.00           15/116     Unknown#element
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Reader::TokenReader#read_character
                      0.00      0.00      0.00      0.00            14/26     Stupidedi::Reader::TokenReader#read_component_elements
                      0.00      0.00      0.00      0.00             6/62     Module#attr_reader
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Reader::TokenReader#stream
                      0.00      0.00      0.00      0.00              1/2     Module#attr_accessor
                      0.00      0.00      0.00      0.00           79/757     Stupidedi::Reader::TokenReader#result
                      0.00      0.00      0.00      0.00             2/48     Class#inherited
                      0.00      0.00      0.00      0.00          195/216     Array#tail
                      0.00      0.00      0.00      0.00          1/15794     <Class::Object>#allocate
                      0.00      0.00      0.00      0.00            15/15     Stupidedi::Reader::TokenReader#consume_prefix
                      0.00      0.00      0.00      0.00             1/53     Kernel#singleton_method_added
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Either::Success#or
                      0.00      0.00      0.00      0.00            15/15     Symbol#call
                      0.00      0.00      0.00      0.00           67/397     Object#cons
                      0.00      0.00      0.00      0.00          347/778     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00            2/274     OpenStruct#method_missing
                      0.00      0.00      0.00      0.00           31/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00          5/15961     Class#new
                      0.00      0.00      0.00      0.00          16/1885     Array#<<
                      0.00      0.00      0.00      0.00              1/3     Stupidedi::Reader::StreamReader#result
                      0.00      0.00      0.00      0.00          1/10063     String#==
                      0.00      0.00      0.00      0.00            1/778     <Class::Stupidedi::Either>#success
                      0.00      0.00      0.00      0.00              1/3     Module#private
                      0.00      0.00      0.00      0.00         602/4827     Kernel#===
                      0.00      0.00      0.00      0.00              2/2     Stupidedi::Reader::StreamReader#read_character
--------------------------------------------------------------------------------
                      0.16      0.00      0.00      0.16            56/56     Stupidedi::Either::Success#flatmap
  34.78%   0.00%      0.16      0.00      0.00      0.16               56     Stupidedi::Reader::TokenReader#read_segment
                      0.01      0.00      0.00      0.01            56/56     Stupidedi::Reader::TokenReader#read_segment_id
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Either::Failure#flatmap
                      0.00      0.00      0.00      0.00           55/778     Stupidedi::Either::Success#flatmap
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         189/1301     Stupidedi::Values::CompositeElementVal#initialize
                      0.00      0.00      0.00      0.00         343/1301     Stupidedi::Values::SegmentVal#initialize
                      0.00      0.00      0.00      0.00          12/1301     <Class::Stupidedi::Builder_::AbstractState>#composite_element
                      0.00      0.00      0.00      0.00         322/1301     <Class::Stupidedi::Builder_::ConstraintTable>#build
                      0.00      0.00      0.00      0.00           9/1301     Stupidedi::Values::TableVal#initialize
                      0.00      0.00      0.00      0.00          14/1301     Stupidedi::Schema::TableDef#entry_segment_uses
                      0.02      0.00      0.00      0.02          25/1301     Stupidedi::Builder_::InstructionTable::NonEmpty#push
                      0.04      0.00      0.00      0.04          56/1301     <Class::Stupidedi::Builder_::AbstractState>#segment
                      0.04      0.00      0.00      0.04         133/1301     Stupidedi::Values::LoopVal#initialize
                      0.05      0.00      0.00      0.05         198/1301     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
  32.61%   0.00%      0.15      0.00      0.00      0.15             1301     Array#map
                      0.06      0.02      0.00      0.04        4654/4654     Stupidedi::Builder_::Instruction#copy
                      0.04      0.01      0.00      0.03          343/343     Stupidedi::Values::SegmentVal#copy
                      0.02      0.00      0.00      0.02          266/266     <Class::Stupidedi::Builder_::AbstractState>#element
                      0.02      0.00      0.00      0.02          189/189     Stupidedi::Values::CompositeElementVal#copy
                      0.02      0.00      0.00      0.02          245/245     Stupidedi::Schema::ElementUse#empty
                      0.02      0.01      0.00      0.01        2076/2076     Stupidedi::Values::SimpleElementVal#copy
                      0.01      0.01      0.00      0.00        4372/6012     Fixnum#-
                      0.00      0.00      0.00      0.00              3/3     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal::Proper#copy
                      0.00      0.00      0.00      0.00         245/1284     NilClass#nil?
                      0.00      0.00      0.00      0.00           70/115     Stupidedi::Values::LoopVal#copy
                      0.00      0.00      0.00      0.00          392/392     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00           26/280     <Class::Stupidedi::Builder_::AbstractState>#simple_element
                      0.00      0.00      0.00      0.00         292/3364     Kernel#nil?
                      0.00      0.00      0.00      0.00              3/3     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00          130/130     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DecimalVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00            72/72     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00          705/705     Kernel#object_id
                      0.00      0.00      0.00      0.00          716/716     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00        282/13457     Fixnum#+
                      0.00      0.00      0.00      0.00           12/166     Stupidedi::Schema::LoopDef#entry_segment_use
--------------------------------------------------------------------------------
                      0.12      0.00      0.00      0.12            45/45     Array#each
  26.09%   0.00%      0.12      0.00      0.00      0.12               45     Stupidedi::Builder_::LoopState#drop
                      0.12      0.00      0.00      0.12           34/357     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
                      0.00      0.00      0.00      0.00            34/79     Stupidedi::Builder_::LoopState#copy
                      0.00      0.00      0.00      0.00          45/3130     Fixnum#zero?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            1/357     Stupidedi::Builder_::TableState#drop
                      0.00      0.00      0.00      0.00            1/357     Stupidedi::Builder_::FunctionalGroupState#drop
                      0.00      0.00      0.00      0.00            1/357     Stupidedi::Builder_::TransactionSetState#drop
                      0.00      0.00      0.00      0.00          318/357     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
                      0.00      0.00      0.00      0.00            2/357     Stupidedi::Builder_::InterchangeState#drop
                      0.12      0.00      0.00      0.12           34/357     Stupidedi::Builder_::LoopState#drop
  26.09%   0.00%      0.12      0.00      0.00      0.12              357     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
                      0.05      0.00      0.00      0.05         198/1301     Array#map
                      0.01      0.01      0.00      0.00          198/396     Array#drop
                      0.00      0.00      0.00      0.00         198/3364     Kernel#nil?
                      0.00      0.00      0.00      0.00          198/223     Stupidedi::Builder_::InstructionTable::NonEmpty#copy
                      0.00      0.00      0.00      0.00         357/2089     Hash#[]
                      0.00      0.00      0.00      0.00         357/6012     Fixnum#-
                      0.00      0.00      0.00      0.00         357/3130     Fixnum#zero?
                      0.00      0.00      0.00      0.00         357/1944     Hash#[]=
                      0.00      0.04      0.00      0.00         357/1446     Array#each
                      0.00      0.00      0.00      0.00          198/198     Array#split_at
                      0.00      0.00      0.00      0.00          318/357     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
                      0.00      0.00      0.00      0.00         357/1331     Fixnum#==
                      0.00      0.00      0.00      0.00         555/2203     Array#length
                      0.00      0.00      0.00      0.00          198/198     Stupidedi::Builder_::InstructionTable::NonEmpty#length
                      0.00      0.00      0.00      0.00          198/286     Array#concat
--------------------------------------------------------------------------------
                      0.11      0.00      0.00      0.11          250/250     Stupidedi::Either::Success#flatmap
  23.91%   0.00%      0.11      0.00      0.00      0.11              250     Stupidedi::Reader::TokenReader#read_elements
                      0.04      0.01      0.00      0.03          238/253     Stupidedi::Reader::TokenReader#read_simple_element
                      0.01      0.00      0.00      0.01            12/12     Stupidedi::Reader::TokenReader#read_composite_element
                      0.01      0.01      0.00      0.00          484/709     Array#head
                      0.00      0.01      0.00      0.00          250/778     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00          242/325     Stupidedi::Schema::RepeatCount::Bounded#include?
                      0.00      0.00      0.00      0.00          242/386     Stupidedi::Schema::ElementUse#composite?
                      0.00      0.00      0.00      0.00         250/1253     Array#empty?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         26/15961     <Class::Stupidedi::Reader::ComponentElementTok>#build
                      0.00      0.00      0.00      0.00          1/15961     <Class::Stupidedi::Builder_::FunctionalGroupState>#push
                      0.00      0.00      0.00      0.00          3/15961     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal::Proper#copy
                      0.00      0.00      0.00      0.00          3/15961     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal>#value
                      0.00      0.00      0.00      0.00          2/15961     Stupidedi::Schema::TableDef#value
                      0.00      0.00      0.00      0.00         18/15961     <Class::Stupidedi::Builder_::LoopState>#push
                      0.00      0.00      0.00      0.00        688/15961     <Class::Stupidedi::Builder_::ConstraintTable>#build
                      0.00      0.00      0.00      0.00          1/15961     Stupidedi::Reader::TokenReader#failure
                      0.00      0.00      0.00      0.00          3/15961     Stupidedi::Builder_::FunctionalGroupState#copy
                      0.00      0.00      0.00      0.00        223/15961     Stupidedi::Builder_::InstructionTable::NonEmpty#copy
                      0.00      0.00      0.00      0.00         55/15961     <Class::Stupidedi::Reader::SegmentTok>#build
                      0.00      0.01      0.00      0.00       2076/15961     Stupidedi::Values::SimpleElementVal#copy
                      0.00      0.00      0.00      0.00         12/15961     <Class::Stupidedi::Reader::CompositeElementTok>#build
                      0.00      0.00      0.00      0.00          2/15961     Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeVal#copy
                      0.00      0.00      0.00      0.00        130/15961     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DecimalVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00          2/15961     <Class::Stupidedi::Builder_::InterchangeState>#instructions
                      0.00      0.00      0.00      0.00         79/15961     Stupidedi::Builder_::LoopState#copy
                      0.00      0.00      0.00      0.00        320/15961     Stupidedi::Either::Success#map
                      0.00      0.00      0.00      0.00        392/15961     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00         72/15961     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00          3/15961     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00          1/15961     Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeVal#initialize
                      0.00      0.00      0.00      0.00        264/15961     Stupidedi::Reader::Success#copy
                      0.00      0.00      0.00      0.00          4/15961     Stupidedi::Envelope::TransactionSetVal#copy
                      0.00      0.00      0.00      0.00         20/15961     Stupidedi::Builder_::ConstraintTable::ValueBased#build_disjoint
                      0.00      0.00      0.00      0.00        105/15961     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal>#value
                      0.00      0.00      0.00      0.00          2/15961     Stupidedi::Schema::TableDef#empty
                      0.00      0.00      0.00      0.00          3/15961     Stupidedi::Reader::Separators#copy
                      0.00      0.00      0.00      0.00        253/15961     <Class::Stupidedi::Reader::SimpleElementTok>#build
                      0.00      0.00      0.00      0.00        111/15961     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal>#empty
                      0.00      0.00      0.00      0.00          2/15961     Stupidedi::Envelope::FunctionalGroupVal#copy
                      0.00      0.00      0.00      0.00          5/15961     Stupidedi::Values::TableVal#copy
                      0.00      0.00      0.00      0.00        716/15961     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00          2/15961     #<Class:0xb746a458>#push
                      0.00      0.00      0.00      0.00         17/15961     Stupidedi::Builder_::ConstraintTable::ValueBased#deepest
                      0.00      0.00      0.00      0.00        551/15961     Stupidedi::AbsoluteSet#copy
                      0.00      0.00      0.00      0.00          5/15961     Stupidedi::Builder_::TransactionSetState#copy
                      0.00      0.00      0.00      0.00        281/15961     Array#each
                      0.00      0.00      0.00      0.00         18/15961     Stupidedi::Schema::LoopDef#value
                      0.00      0.00      0.00      0.00          1/15961     <Class::Stupidedi::Either>#failure
                      0.00      0.00      0.00      0.00          2/15961     <Class::Stupidedi::Builder_::FunctionalGroupState>#instructions
                      0.00      0.00      0.00      0.00        757/15961     Stupidedi::Reader::TokenReader#result
                      0.00      0.00      0.00      0.00          1/15961     <Class::Stupidedi::Builder_::TransactionSetState>#push
                      0.00      0.00      0.00      0.00         73/15961     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal>#empty
                      0.00      0.00      0.00      0.00          2/15961     <Class::Stupidedi::Dictionaries::Interchanges::FiveOhOne::ElementDefs::SeparatorElementVal>#value
                      0.00      0.00      0.00      0.00         12/15961     Stupidedi::Schema::CompositeElementDef#value
                      0.00      0.00      0.00      0.00        100/15961     Stupidedi::Builder_::InstructionTable::NonEmpty#successors
                      0.00      0.00      0.00      0.00          1/15961     <Class::Stupidedi::Builder_::TransactionSetState>#instructions
                      0.00      0.00      0.00      0.00          1/15961     Stupidedi::Reader::TokenReader#stream
                      0.00      0.00      0.00      0.00          1/15961     Stupidedi::Reader::SegmentDict::NonEmpty#push
                      0.00      0.00      0.00      0.00        189/15961     Stupidedi::Values::CompositeElementVal#copy
                      0.00      0.00      0.00      0.00          4/15961     Stupidedi::Builder_::InterchangeState#copy
                      0.00      0.00      0.00      0.00          4/15961     <Class::Stupidedi::Builder_::TableState>#push
                      0.00      0.00      0.00      0.00          1/15961     #<Class:0xb77871b8>#value
                      0.00      0.00      0.00      0.00         25/15961     <Class::Rational>#new!
                      0.00      0.00      0.00      0.00          6/15961     Stupidedi::Builder_::TableState#copy
                      0.00      0.00      0.00      0.00         13/15961     Stupidedi::Schema::CompositeElementDef#empty
                      0.00      0.00      0.00      0.00          7/15961     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal>#empty
                      0.00      0.00      0.00      0.00        343/15961     Stupidedi::Values::SegmentVal#copy
                      0.00      0.00      0.00      0.00          1/15961     Stupidedi::Envelope::TransactionSetDef#empty
                      0.00      0.00      0.00      0.00          3/15961     Stupidedi::Reader::StreamReader#copy
                      0.00      0.00      0.00      0.00         17/15961     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal>#value
                      0.00      0.00      0.00      0.00          1/15961     <Class::Stupidedi::Builder_::InterchangeState>#push
                      0.00      0.00      0.00      0.00          1/15961     Stupidedi::Reader::SegmentDict::NonEmpty#copy
                      0.00      0.00      0.00      0.00         41/15961     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DecimalVal>#empty
                      0.00      0.00      0.00      0.00        696/15961     Stupidedi::Reader::TokenReader#copy
                      0.00      0.00      0.00      0.00          3/15961     Stupidedi::Reader::StreamReader#result
                      0.00      0.00      0.00      0.00          5/15961     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00         56/15961     Stupidedi::Schema::SegmentDef#value
                      0.00      0.00      0.00      0.00        446/15961     Stupidedi::Builder_::InstructionTable::NonEmpty#initialize
                      0.00      0.00      0.00      0.00        778/15961     <Class::Stupidedi::Either>#success
                      0.00      0.00      0.00      0.00        130/15961     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal>#value
                      0.00      0.00      0.00      0.00          1/15961     <Class::Stupidedi::Builder_::TableState>#instructions
                      0.00      0.00      0.00      0.00         20/15961     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DecimalVal>#value
                      0.01      0.00      0.00      0.01          1/15961     #<Class:0xb761e7a4>#value
                      0.01      0.00      0.00      0.01        975/15961     Stupidedi::Reader::FileInput#drop
                      0.01      0.00      0.00      0.01          3/15961     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal>#value
                      0.03      0.02      0.00      0.01       4654/15961     Stupidedi::Builder_::Instruction#copy
                      0.04      0.00      0.00      0.04        115/15961     Stupidedi::Values::LoopVal#copy
  21.74%   6.52%      0.10      0.03      0.00      0.08            15961     Class#new
                      0.04      0.00      0.00      0.04          133/133     Stupidedi::Values::LoopVal#initialize
                      0.02      0.00      0.00      0.02          214/214     Stupidedi::Values::CompositeElementVal#initialize
                      0.02      0.00      0.00      0.02          399/399     Stupidedi::Values::SegmentVal#initialize
                      0.01      0.01      0.00      0.00              3/3     Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeVal#initialize
                      0.01      0.00      0.00      0.01              5/5     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal::Proper#initialize
                      0.01      0.01      0.00      0.00        4935/4935     Stupidedi::Builder_::Instruction#initialize
                      0.01      0.01      0.00      0.00          975/975     Stupidedi::Reader::FileInput#initialize
                      0.00      0.00      0.00      0.00          146/146     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DecimalVal::NonEmpty#initialize
                      0.00      0.00      0.00      0.00          254/254     Stupidedi::Reader::SimpleElementTok#initialize
                      0.00      0.00      0.00      0.00          458/458     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal::NonEmpty#initialize
                      0.00      0.00      0.00      0.00              2/2     Stupidedi::Dictionaries::Interchanges::FiveOhOne::ElementDefs::SeparatorElementVal#initialize
                      0.00      0.00      0.00      0.00          223/223     Stupidedi::Builder_::InstructionTable::NonEmpty#initialize
                      0.00      0.00      0.00      0.00              2/2     Stupidedi::Reader::SegmentDict::NonEmpty#initialize
                      0.00      0.00      0.00      0.00              6/6     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal::NonEmpty#initialize
                      0.00      0.00      0.00      0.00        2366/3904     Stupidedi::Values::SimpleElementVal#initialize
                      0.00      0.00      0.00      0.00          161/161     Stupidedi::Builder_::ConstraintTable::ValueBased#initialize
                      0.00      0.00      0.00      0.00            26/26     Stupidedi::Reader::ComponentElementTok#initialize
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Reader::StreamReader#initialize
                      0.00      0.00      0.00      0.00              1/1     OpenStruct#initialize
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal::Improper#initialize
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Builder_::FunctionalGroupState#initialize
                      0.00      0.00      0.00      0.00              6/6     Stupidedi::Builder_::TransactionSetState#initialize
                      0.00      0.00      0.00      0.00            10/10     Stupidedi::Builder_::TableState#initialize
                      0.00      0.00      0.00      0.00              1/1     Class#initialize
                      0.00      0.00      0.00      0.00              9/9     Stupidedi::Values::TableVal#initialize
                      0.00      0.00      0.00      0.00        1098/1098     Stupidedi::Either::Success#initialize
                      0.00      0.00      0.00      0.00      15373/15794     <Class::Object>#allocate
                      0.00      0.00      0.00      0.00          587/587     <Class::Hash>#allocate
                      0.00      0.00      0.00      0.00              3/3     Stupidedi::Envelope::FunctionalGroupVal#initialize
                      0.00      0.00      0.00      0.00              1/1     #<Class:0xb73f3808>#initialize
                      0.00      0.00      0.00      0.00          551/551     Stupidedi::AbsoluteSet#initialize
                      0.00      0.00      0.00      0.00            12/12     Stupidedi::Reader::CompositeElementTok#initialize
                      0.00      0.00      0.00      0.00          831/831     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal::NonEmpty#initialize
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Reader::Separators#initialize
                      0.00      0.00      0.00      0.00              5/5     Stupidedi::Builder_::InterchangeState#initialize
                      0.00      0.00      0.00      0.00              1/1     <Class::Class>#allocate
                      0.00      0.00      0.00      0.00          587/587     Hash#initialize
                      0.00      0.00      0.00      0.00              5/5     Stupidedi::Envelope::TransactionSetVal#initialize
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Either::Failure#initialize
                      0.00      0.00      0.00      0.00          698/698     Stupidedi::Reader::TokenReader#initialize
                      0.00      0.00      0.00      0.00              2/2     Stupidedi::Reader::SegmentDict::Constants#initialize
                      0.00      0.00      0.00      0.00            97/97     Stupidedi::Builder_::LoopState#initialize
                      0.00      0.00      0.00      0.00              2/2     <Class::Stupidedi::Reader::SegmentDict>#empty
                      0.00      0.00      0.00      0.00            56/56     Stupidedi::Reader::SegmentTok#initialize
                      0.00      0.00      0.00      0.00          527/527     Stupidedi::Builder_::ConstraintTable::Stub#initialize
                      0.00      0.00      0.00      0.00            89/89     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal::NonEmpty#initialize
                      0.00      0.00      0.00      0.00        1024/1024     Stupidedi::Reader::Success#initialize
                      0.00      0.00      0.00      0.00            25/25     Rational#initialize
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Reader::Failure#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           26/975     Stupidedi::Reader::TokenReader#read_component_element
                      0.00      0.00      0.00      0.00            3/975     Stupidedi::Reader::StreamReader#advance
                      0.02      0.00      0.00      0.02          253/975     Stupidedi::Reader::TokenReader#read_simple_element
                      0.04      0.01      0.00      0.03          693/975     Stupidedi::Reader::TokenReader#advance
  13.04%   2.17%      0.06      0.01      0.00      0.05              975     Stupidedi::Reader::FileInput#drop
                      0.02      0.02      0.00      0.00          975/975     String#count
                      0.01      0.01      0.00      0.00          975/975     String#rindex
                      0.01      0.01      0.00      0.00        1950/2126     String#length
                      0.01      0.00      0.00      0.01        975/15961     Class#new
                      0.00      0.00      0.00      0.00          55/6012     Fixnum#-
                      0.00      0.00      0.00      0.00         975/2830     Fixnum#>=
                      0.00      0.00      0.00      0.00         975/2830     IO#read
                      0.00      0.00      0.00      0.00         975/2830     IO#seek
                      0.00      0.00      0.00      0.00       2870/13457     Fixnum#+
                      0.00      0.00      0.00      0.00        975/12203     Kernel#class
--------------------------------------------------------------------------------
                      0.06      0.02      0.00      0.04        4654/4654     Array#map
  13.04%   4.35%      0.06      0.02      0.00      0.04             4654     Stupidedi::Builder_::Instruction#copy
                      0.03      0.02      0.00      0.01       4654/15961     Class#new
                      0.01      0.01      0.00      0.00      23270/41773     Hash#fetch
                      0.00      0.00      0.00      0.00       4654/12203     Kernel#class
--------------------------------------------------------------------------------
                      0.05      0.00      0.00      0.05            56/56     Array#each
  10.87%   0.00%      0.05      0.00      0.00      0.05               56     Stupidedi::Builder_::InstructionTable::NonEmpty#successors
                      0.02      0.00      0.00      0.02            17/17     Stupidedi::Builder_::ConstraintTable::ValueBased#matches
                      0.02      0.00      0.00      0.02           50/312     Hash#each
                      0.00      0.00      0.00      0.00        100/15961     Class#new
                      0.00      0.00      0.00      0.00          50/1446     Array#each
                      0.00      0.00      0.00      0.00            39/39     Stupidedi::Builder_::ConstraintTable::Stub#matches
                      0.00      0.00      0.00      0.00            56/74     Hash#at
                      0.00      0.00      0.00      0.00           56/138     Hash#defined_at?
--------------------------------------------------------------------------------
                      0.05      0.01      0.00      0.04          343/343     Stupidedi::Either::Success#flatmap
  10.87%   2.17%      0.05      0.01      0.00      0.04              343     Stupidedi::Reader::TokenReader#read_delimiter
                      0.02      0.00      0.00      0.02         343/1855     Stupidedi::Reader::FileInput#at
                      0.02      0.00      0.00      0.02          343/693     Stupidedi::Reader::TokenReader#advance
                      0.00      0.00      0.00      0.00         343/2550     Stupidedi::Reader::FileInput#defined_at?
                      0.00      0.00      0.00      0.00          343/757     Stupidedi::Reader::TokenReader#result
                      0.00      0.00      0.00      0.00          343/765     Stupidedi::Reader::TokenReader#is_delimiter?
                      0.00      0.00      0.00      0.00        343/13457     Fixnum#+
                      0.00      0.00      0.00      0.00         343/1795     Stupidedi::Reader::TokenReader#is_control?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           26/693     Stupidedi::Reader::TokenReader#read_component_element
                      0.00      0.00      0.00      0.00           15/693     Stupidedi::Reader::TokenReader#consume_prefix
                      0.00      0.00      0.00      0.00            1/693     Stupidedi::Reader::TokenReader#read_character
                      0.01      0.00      0.00      0.01          253/693     Stupidedi::Reader::TokenReader#read_simple_element
                      0.01      0.00      0.00      0.01           55/693     Stupidedi::Reader::TokenReader#read_segment_id
                      0.02      0.00      0.00      0.02          343/693     Stupidedi::Reader::TokenReader#read_delimiter
   8.70%   0.00%      0.04      0.00      0.00      0.04              693     Stupidedi::Reader::TokenReader#advance
                      0.04      0.01      0.00      0.03          693/975     Stupidedi::Reader::FileInput#drop
                      0.00      0.00      0.00      0.00         693/6012     Fixnum#-
                      0.00      0.00      0.00      0.00         693/2550     Stupidedi::Reader::FileInput#defined_at?
                      0.00      0.00      0.00      0.00          693/696     Stupidedi::Reader::TokenReader#copy
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             1/56     <Class::Stupidedi::Builder_::FunctionalGroupState>#push
                      0.00      0.00      0.00      0.00             2/56     <Class::Stupidedi::Builder_::TableState>#push
                      0.00      0.00      0.00      0.00             1/56     <Class::Stupidedi::Builder_::InterchangeState>#push
                      0.01      0.00      0.00      0.01            18/56     <Class::Stupidedi::Builder_::LoopState>#push
                      0.03      0.00      0.00      0.03            34/56     Stupidedi::Builder_::AbstractState#segment
   8.70%   0.00%      0.04      0.00      0.00      0.04               56     <Class::Stupidedi::Builder_::AbstractState>#segment
                      0.04      0.00      0.00      0.04          56/1301     Array#map
                      0.00      0.00      0.00      0.00            56/68     Array#zip
                      0.00      0.00      0.00      0.00            56/56     Stupidedi::Schema::SegmentUse#value
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           15/253     Kernel#__send__
                      0.04      0.01      0.00      0.03          238/253     Stupidedi::Reader::TokenReader#read_elements
   8.70%   2.17%      0.04      0.01      0.00      0.03              253     Stupidedi::Reader::TokenReader#read_simple_element
                      0.02      0.00      0.00      0.02          253/975     Stupidedi::Reader::FileInput#drop
                      0.01      0.00      0.00      0.01          253/693     Stupidedi::Reader::TokenReader#advance
                      0.00      0.00      0.00      0.00          253/757     Stupidedi::Reader::TokenReader#result
                      0.00      0.00      0.00      0.00          100/116     Unknown#element
                      0.00      0.00      0.00      0.00         837/1063     String#<<
                      0.00      0.00      0.00      0.00         253/6012     Fixnum#-
                      0.00      0.00      0.00      0.00          270/274     OpenStruct#method_missing
                      0.00      0.00      0.00      0.00          253/253     Stupidedi::Reader::TokenReader#simple
                      0.00      0.00      0.00      0.00        1090/2550     Stupidedi::Reader::FileInput#defined_at?
                      0.00      0.00      0.00      0.00        3800/4827     Kernel#===
                      0.00      0.00      0.00      0.00       1090/13457     Fixnum#+
                      0.00      0.00      0.00      0.00        1090/1855     Stupidedi::Reader::FileInput#at
                      0.00      0.00      0.00      0.00        1090/1795     Stupidedi::Reader::TokenReader#is_control?
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01            31/45     Stupidedi::Builder_::LoopState#add
                      0.03      0.00      0.00      0.03            14/45     Stupidedi::Builder_::LoopState#merge
   8.70%   0.00%      0.04      0.00      0.00      0.04               45     Stupidedi::Values::LoopVal#append
                      0.04      0.00      0.00      0.04           45/115     Stupidedi::Values::LoopVal#copy
                      0.00      0.00      0.00      0.00            45/58     Object#snoc
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           70/115     Array#map
                      0.04      0.00      0.00      0.04           45/115     Stupidedi::Values::LoopVal#append
   8.70%   0.00%      0.04      0.00      0.00      0.04              115     Stupidedi::Values::LoopVal#copy
                      0.04      0.00      0.00      0.04        115/15961     Class#new
                      0.00      0.00      0.00      0.00        345/41773     Hash#fetch
                      0.00      0.00      0.00      0.00        115/12203     Kernel#class
--------------------------------------------------------------------------------
                      0.04      0.00      0.00      0.04          133/133     Class#new
   8.70%   0.00%      0.04      0.00      0.00      0.04              133     Stupidedi::Values::LoopVal#initialize
                      0.04      0.00      0.00      0.04         133/1301     Array#map
                      0.00      0.00      0.00      0.00         133/3364     Kernel#nil?
--------------------------------------------------------------------------------
                      0.04      0.01      0.00      0.03          343/343     Array#map
   8.70%   2.17%      0.04      0.01      0.00      0.03              343     Stupidedi::Values::SegmentVal#copy
                      0.01      0.01      0.00      0.00        343/12203     Kernel#class
                      0.00      0.00      0.00      0.00        343/15961     Class#new
                      0.00      0.00      0.00      0.00       1372/41773     Hash#fetch
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01             1/18     Stupidedi::Either::Success#flatmap
                      0.02      0.00      0.00      0.02            17/18     Stupidedi::Builder_::ConstraintTable::ValueBased#basis
   6.52%   0.00%      0.03      0.00      0.00      0.03               18     Integer#times
                      0.01      0.01      0.00      0.00          13/6012     Fixnum#-
                      0.00      0.00      0.00      0.00         13/15794     <Class::Object>#allocate
                      0.00      0.00      0.00      0.00            15/15     Symbol#to_proc
                      0.00      0.00      0.00      0.00            13/13     Range#each
                      0.00      0.00      0.00      0.00          144/386     Stupidedi::Schema::ElementUse#composite?
                      0.00      0.00      0.00      0.00           30/778     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00         157/1482     Array#at
                      0.00      0.00      0.00      0.00         131/1446     Array#each
                      0.00      0.00      0.00      0.00          13/2203     Array#length
--------------------------------------------------------------------------------
                      0.03      0.00      0.00      0.03            31/31     Array#each
   6.52%   0.00%      0.03      0.00      0.00      0.03               31     Stupidedi::Builder_::LoopState#add
                      0.02      0.00      0.00      0.02            31/34     Stupidedi::Builder_::AbstractState#segment
                      0.01      0.00      0.00      0.01            31/45     Stupidedi::Values::LoopVal#append
                      0.00      0.00      0.00      0.00            31/79     Stupidedi::Builder_::LoopState#copy
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            14/63     Stupidedi::Builder_::LoopState#pop
                      0.03      0.00      0.00      0.03            49/63     Array#each
   6.52%   0.00%      0.03      0.00      0.00      0.03               63     Stupidedi::Builder_::LoopState#pop
                      0.03      0.00      0.00      0.03            14/14     Stupidedi::Builder_::LoopState#merge
                      0.00      0.00      0.00      0.00              4/7     Stupidedi::Builder_::TableState#pop
                      0.00      0.00      0.00      0.00          18/6012     Fixnum#-
                      0.00      0.00      0.00      0.00          63/3130     Fixnum#zero?
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Builder_::TableState#merge
                      0.00      0.00      0.00      0.00            14/63     Stupidedi::Builder_::LoopState#pop
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             1/34     Stupidedi::Builder_::InterchangeState#add
                      0.00      0.00      0.00      0.00             1/34     Stupidedi::Builder_::FunctionalGroupState#add
                      0.01      0.00      0.00      0.01             1/34     Stupidedi::Builder_::TableState#add
                      0.02      0.00      0.00      0.02            31/34     Stupidedi::Builder_::LoopState#add
   6.52%   0.00%      0.03      0.00      0.00      0.03               34     Stupidedi::Builder_::AbstractState#segment
                      0.03      0.00      0.00      0.03            34/56     <Class::Stupidedi::Builder_::AbstractState>#segment
--------------------------------------------------------------------------------
                      0.03      0.00      0.00      0.03            14/14     Stupidedi::Builder_::LoopState#pop
   6.52%   0.00%      0.03      0.00      0.00      0.03               14     Stupidedi::Builder_::LoopState#merge
                      0.03      0.00      0.00      0.03            14/45     Stupidedi::Values::LoopVal#append
                      0.00      0.00      0.00      0.00            14/79     Stupidedi::Builder_::LoopState#copy
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           1/6012     Stupidedi::Builder_::TransactionSetState#pop
                      0.00      0.00      0.00      0.00         357/6012     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
                      0.00      0.00      0.00      0.00          55/6012     Stupidedi::Reader::FileInput#drop
                      0.00      0.00      0.00      0.00           1/6012     Stupidedi::Builder_::FunctionalGroupState#pop
                      0.00      0.00      0.00      0.00         253/6012     Stupidedi::Reader::TokenReader#read_simple_element
                      0.00      0.00      0.00      0.00          11/6012     <Class::Date>#civil_to_jd
                      0.00      0.00      0.00      0.00           3/6012     Stupidedi::Reader::StreamReader#advance
                      0.00      0.00      0.00      0.00          18/6012     Stupidedi::Builder_::LoopState#pop
                      0.00      0.00      0.00      0.00          40/6012     <Class::Date>#jd_to_civil
                      0.00      0.00      0.00      0.00           5/6012     <Class::Stupidedi::Builder_::AbstractState>#sequence
                      0.00      0.00      0.00      0.00          55/6012     Stupidedi::Reader::TokenReader#read_segment_id
                      0.00      0.00      0.00      0.00         693/6012     Stupidedi::Reader::TokenReader#advance
                      0.00      0.00      0.00      0.00          20/6012     <Class::Stupidedi::Builder_::AbstractState>#lsequence
                      0.00      0.00      0.00      0.00           5/6012     Rational#-
                      0.00      0.00      0.00      0.00          10/6012     <Class::Date>#jd_to_ajd
                      0.00      0.00      0.00      0.00          11/6012     Module#abstract
                      0.00      0.00      0.00      0.00          26/6012     Stupidedi::Reader::TokenReader#read_component_element
                      0.00      0.00      0.00      0.00           4/6012     Stupidedi::Builder_::TableState#pop
                      0.00      0.00      0.00      0.00          59/6012     Array#each
                      0.01      0.01      0.00      0.00        4372/6012     Array#map
                      0.01      0.01      0.00      0.00          13/6012     Integer#times
   4.35%   4.35%      0.02      0.02      0.00      0.00             6012     Fixnum#-
                      0.00      0.00      0.00      0.00              5/5     Rational#-
                      0.00      0.00      0.00      0.00              5/5     Rational#coerce
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00        1090/1855     Stupidedi::Reader::TokenReader#read_simple_element
                      0.00      0.00      0.00      0.00          15/1855     Stupidedi::Reader::TokenReader#consume_prefix
                      0.00      0.00      0.00      0.00           1/1855     Stupidedi::Reader::TokenReader#read_character
                      0.00      0.00      0.00      0.00           3/1855     Stupidedi::Reader::StreamReader#consume_isa
                      0.00      0.00      0.00      0.00           2/1855     Stupidedi::Reader::StreamReader#read_character
                      0.00      0.00      0.00      0.00         310/1855     Stupidedi::Reader::TokenReader#read_segment_id
                      0.00      0.00      0.00      0.00          91/1855     Stupidedi::Reader::TokenReader#read_component_element
                      0.02      0.00      0.00      0.02         343/1855     Stupidedi::Reader::TokenReader#read_delimiter
   4.35%   0.00%      0.02      0.00      0.00      0.02             1855     Stupidedi::Reader::FileInput#at
                      0.02      0.02      0.00      0.00        1855/2830     IO#read
                      0.00      0.00      0.00      0.00        1855/2830     Fixnum#>=
                      0.00      0.00      0.00      0.00        1855/2830     IO#seek
                      0.00      0.00      0.00      0.00       1855/13457     Fixnum#+
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             2/18     <Class::Stupidedi::Builder_::TableState>#push
                      0.02      0.00      0.00      0.02            16/18     Array#each
   4.35%   0.00%      0.02      0.00      0.00      0.02               18     <Class::Stupidedi::Builder_::LoopState>#push
                      0.01      0.00      0.00      0.01            18/56     <Class::Stupidedi::Builder_::AbstractState>#segment
                      0.01      0.00      0.00      0.01            18/25     Stupidedi::Builder_::InstructionTable::NonEmpty#push
                      0.00      0.00      0.00      0.00            18/18     Stupidedi::Schema::LoopDef#value
                      0.00      0.00      0.00      0.00         18/15961     Class#new
                      0.00      0.00      0.00      0.00            18/18     <Class::Stupidedi::Builder_::LoopState>#instructions
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01              3/4     Array#each
                      0.01      0.00      0.00      0.01              1/4     <Class::Stupidedi::Builder_::TransactionSetState>#push
   4.35%   0.00%      0.02      0.00      0.00      0.02                4     <Class::Stupidedi::Builder_::TableState>#push
                      0.01      0.00      0.00      0.01             4/25     Stupidedi::Builder_::InstructionTable::NonEmpty#push
                      0.01      0.00      0.00      0.01              4/4     <Class::Stupidedi::Builder_::TableState>#instructions
                      0.00      0.00      0.00      0.00              2/2     Stupidedi::Schema::TableDef#empty
                      0.00      0.00      0.00      0.00             2/18     <Class::Stupidedi::Builder_::LoopState>#push
                      0.00      0.00      0.00      0.00             2/56     <Class::Stupidedi::Builder_::AbstractState>#segment
                      0.00      0.00      0.00      0.00             6/20     Module#===
                      0.00      0.00      0.00      0.00          4/15961     Class#new
                      0.00      0.00      0.00      0.00              2/2     Stupidedi::Schema::TableDef#value
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            1/312     OpenStruct#initialize
                      0.00      0.00      0.00      0.00          176/312     Enumerable#inject
                      0.00      0.00      0.00      0.00           85/312     Stupidedi::AbsoluteSet#each
                      0.02      0.00      0.00      0.02           50/312     Stupidedi::Builder_::InstructionTable::NonEmpty#successors
   4.35%   0.00%      0.02      0.00      0.00      0.02              312     Hash#each
                      0.02      0.02      0.00      0.00          688/688     <Class::Stupidedi::Builder_::ConstraintTable>#build
                      0.00      0.00      0.00      0.00              1/2     OpenStruct#new_ostruct_member
                      0.00      0.00      0.00      0.00             4/48     Class#inherited
                      0.00      0.00      0.00      0.00         788/1944     Hash#[]=
                      0.00      0.00      0.00      0.00             1/53     Kernel#singleton_method_added
                      0.00      0.00      0.00      0.00           99/397     Object#cons
                      0.00      0.00      0.00      0.00              1/6     Symbol#to_sym
                      0.00      0.00      0.00      0.00        2395/3130     Fixnum#zero?
                      0.00      0.00      0.00      0.00           10/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00              1/3     Module#private
                      0.00      0.00      0.00      0.00       3710/13457     Fixnum#+
                      0.00      0.00      0.00      0.00        3572/3572     Fixnum#[]
                      0.00      0.00      0.00      0.00        2533/2533     Bignum#[]
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         975/2830     Stupidedi::Reader::FileInput#drop
                      0.02      0.02      0.00      0.00        1855/2830     Stupidedi::Reader::FileInput#at
   4.35%   4.35%      0.02      0.02      0.00      0.00             2830     IO#read
--------------------------------------------------------------------------------
                      0.02      0.00      0.00      0.02            17/17     Stupidedi::Builder_::InstructionTable::NonEmpty#successors
   4.35%   0.00%      0.02      0.00      0.00      0.02               17     Stupidedi::Builder_::ConstraintTable::ValueBased#matches
                      0.02      0.00      0.00      0.02            17/17     Stupidedi::Builder_::ConstraintTable::ValueBased#basis
                      0.00      0.00      0.00      0.00           17/709     Array#head
                      0.00      0.00      0.00      0.00            17/17     Stupidedi::Builder_::ConstraintTable::ValueBased#deepest
                      0.00      0.00      0.00      0.00          17/1446     Array#each
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01           56/111     Stupidedi::Reader::SegmentDict::NonEmpty#defined_at?
                      0.01      0.00      0.00      0.01           55/111     Stupidedi::Reader::SegmentDict::NonEmpty#at
   4.35%   0.00%      0.02      0.00      0.00      0.02              111     Stupidedi::Reader::SegmentDict::Constants#defined_at?
                      0.02      0.00      0.00      0.02          111/275     Enumerable#any?
                      0.00      0.00      0.00      0.00          111/111     Module#constants
--------------------------------------------------------------------------------
                      0.02      0.02      0.00      0.00          688/688     Hash#each
   4.35%   4.35%      0.02      0.02      0.00      0.00              688     <Class::Stupidedi::Builder_::ConstraintTable>#build
                      0.00      0.00      0.00      0.00        849/18317     Fixnum#>
                      0.00      0.00      0.00      0.00          162/275     Enumerable#any?
                      0.00      0.00      0.00      0.00        688/15961     Class#new
                      0.00      0.00      0.00      0.00          161/161     Array#uniq
                      0.00      0.00      0.00      0.00         322/1301     Array#map
                      0.00      0.00      0.00      0.00         849/2203     Array#length
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          162/275     <Class::Stupidedi::Builder_::ConstraintTable>#build
                      0.00      0.00      0.00      0.00            2/275     Stupidedi::Values::SegmentValGroup#defined_at?
                      0.02      0.00      0.00      0.02          111/275     Stupidedi::Reader::SegmentDict::Constants#defined_at?
   4.35%   0.00%      0.02      0.00      0.00      0.02              275     Enumerable#any?
                      0.02      0.01      0.00      0.01         275/1446     Array#each
--------------------------------------------------------------------------------
                      0.02      0.02      0.00      0.00          975/975     Stupidedi::Reader::FileInput#drop
   4.35%   4.35%      0.02      0.02      0.00      0.00              975     String#count
--------------------------------------------------------------------------------
                      0.02      0.00      0.00      0.02            17/17     Stupidedi::Builder_::ConstraintTable::ValueBased#matches
   4.35%   0.00%      0.02      0.00      0.00      0.02               17     Stupidedi::Builder_::ConstraintTable::ValueBased#basis
                      0.02      0.00      0.00      0.02            17/18     Integer#times
                      0.00      0.00      0.00      0.00          17/2203     Array#length
                      0.00      0.00      0.00      0.00           17/709     Array#head
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             1/25     <Class::Stupidedi::Builder_::TransactionSetState>#push
                      0.00      0.00      0.00      0.00             1/25     <Class::Stupidedi::Builder_::FunctionalGroupState>#push
                      0.00      0.00      0.00      0.00             1/25     <Class::Stupidedi::Builder_::InterchangeState>#push
                      0.01      0.00      0.00      0.01             4/25     <Class::Stupidedi::Builder_::TableState>#push
                      0.01      0.00      0.00      0.01            18/25     <Class::Stupidedi::Builder_::LoopState>#push
   4.35%   0.00%      0.02      0.00      0.00      0.02               25     Stupidedi::Builder_::InstructionTable::NonEmpty#push
                      0.02      0.00      0.00      0.02          25/1301     Array#map
                      0.00      0.00      0.00      0.00          25/2089     Hash#[]
                      0.00      0.00      0.00      0.00           25/223     Stupidedi::Builder_::InstructionTable::NonEmpty#copy
                      0.00      0.00      0.00      0.00          25/1944     Hash#[]=
                      0.00      0.00      0.00      0.00           25/482     Array#+
                      0.00      0.00      0.00      0.00          25/2203     Array#length
--------------------------------------------------------------------------------
                      0.02      0.01      0.00      0.01          264/264     Stupidedi::Either::Success#map
   4.35%   2.17%      0.02      0.01      0.00      0.01              264     Stupidedi::Reader::Success#map
                      0.01      0.01      0.00      0.00          264/264     Stupidedi::Reader::Success#copy
                      0.00      0.00      0.00      0.00          209/397     Object#cons
                      0.00      0.00      0.00      0.00            55/55     Stupidedi::Reader::TokenReader#segment
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         40/18317     Integer#gcd
                      0.00      0.00      0.00      0.00        849/18317     <Class::Stupidedi::Builder_::ConstraintTable>#build
                      0.02      0.02      0.00      0.00      17428/18317     Array#each
   4.35%   4.35%      0.02      0.02      0.00      0.00            18317     Fixnum#>
--------------------------------------------------------------------------------
                      0.02      0.00      0.00      0.02          266/266     Array#map
   4.35%   0.00%      0.02      0.00      0.00      0.02              266     <Class::Stupidedi::Builder_::AbstractState>#element
                      0.02      0.00      0.00      0.02          254/280     <Class::Stupidedi::Builder_::AbstractState>#simple_element
                      0.00      0.00      0.00      0.00            12/12     <Class::Stupidedi::Builder_::AbstractState>#composite_element
                      0.00      0.00      0.00      0.00          254/615     Stupidedi::Schema::SimpleElementUse#simple?
                      0.00      0.00      0.00      0.00            12/37     Stupidedi::Schema::CompositeElementUse#simple?
--------------------------------------------------------------------------------
                      0.02      0.00      0.00      0.02          245/245     Array#map
   4.35%   0.00%      0.02      0.00      0.00      0.02              245     Stupidedi::Schema::ElementUse#empty
                      0.02      0.00      0.00      0.02          232/232     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#empty
                      0.00      0.00      0.00      0.00            13/13     Stupidedi::Schema::CompositeElementDef#empty
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           26/280     Array#map
                      0.02      0.00      0.00      0.02          254/280     <Class::Stupidedi::Builder_::AbstractState>#element
   4.35%   0.00%      0.02      0.00      0.00      0.02              280     <Class::Stupidedi::Builder_::AbstractState>#simple_element
                      0.02      0.00      0.00      0.02          280/292     Stupidedi::Schema::ElementUse#value
--------------------------------------------------------------------------------
                      0.02      0.00      0.00      0.02          232/232     Stupidedi::Schema::ElementUse#empty
   4.35%   0.00%      0.02      0.00      0.00      0.02              232     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#empty
                      0.02      0.02      0.00      0.00            41/61     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::R#companion
                      0.00      0.00      0.00      0.00            41/41     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DecimalVal>#empty
                      0.00      0.00      0.00      0.00           73/178     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::AN#companion
                      0.00      0.00      0.00      0.00          111/241     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::ID#companion
                      0.00      0.00      0.00      0.00          111/111     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal>#empty
                      0.00      0.00      0.00      0.00            73/73     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal>#empty
                      0.00      0.00      0.00      0.00              7/7     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal>#empty
                      0.00      0.00      0.00      0.00             7/24     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::Nn#companion
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           12/292     <Class::Stupidedi::Builder_::AbstractState>#composite_element
                      0.02      0.00      0.00      0.02          280/292     <Class::Stupidedi::Builder_::AbstractState>#simple_element
   4.35%   0.00%      0.02      0.00      0.00      0.02              292     Stupidedi::Schema::ElementUse#value
                      0.02      0.00      0.00      0.02          280/280     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
                      0.00      0.00      0.00      0.00            12/12     Stupidedi::Schema::CompositeElementDef#value
--------------------------------------------------------------------------------
                      0.02      0.00      0.00      0.02          399/399     Class#new
   4.35%   0.00%      0.02      0.00      0.00      0.02              399     Stupidedi::Values::SegmentVal#initialize
                      0.00      0.00      0.00      0.00          56/1284     NilClass#nil?
                      0.00      0.00      0.00      0.00         343/3364     Kernel#nil?
                      0.00      0.00      0.00      0.00         343/1301     Array#map
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            20/61     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
                      0.02      0.02      0.00      0.00            41/61     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#empty
   4.35%   4.35%      0.02      0.02      0.00      0.00               61     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::R#companion
                      0.00      0.00      0.00      0.00              1/4     Module#delegate
                      0.00      0.00      0.00      0.00             3/48     Class#inherited
                      0.00      0.00      0.00      0.00             1/62     Module#attr_reader
                      0.00      0.00      0.00      0.00             3/26     Kernel#send
                      0.00      0.00      0.00      0.00             2/53     Kernel#singleton_method_added
                      0.00      0.00      0.00      0.00           18/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00             3/22     Object#eigenclass
                      0.00      0.00      0.00      0.00              1/7     Module#include
--------------------------------------------------------------------------------
                      0.02      0.00      0.00      0.02          280/280     Stupidedi::Schema::ElementUse#value
   4.35%   0.00%      0.02      0.00      0.00      0.02              280     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
                      0.01      0.00      0.00      0.01              3/3     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal>#value
                      0.01      0.01      0.00      0.00          105/178     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::AN#companion
                      0.00      0.00      0.00      0.00            17/17     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal>#value
                      0.00      0.00      0.00      0.00          130/241     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::ID#companion
                      0.00      0.00      0.00      0.00              1/1     #<Class:0xb760531c>#companion
                      0.00      0.00      0.00      0.00              1/1     #<Class:0xb7604c14>#companion
                      0.00      0.00      0.00      0.00            20/61     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::R#companion
                      0.00      0.00      0.00      0.00          130/130     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal>#value
                      0.00      0.00      0.00      0.00              3/3     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal>#value
                      0.00      0.00      0.00      0.00            20/20     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DecimalVal>#value
                      0.00      0.00      0.00      0.00          105/105     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal>#value
                      0.00      0.00      0.00      0.00            17/24     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::Nn#companion
                      0.00      0.00      0.00      0.00              2/2     <Class::Stupidedi::Dictionaries::Interchanges::FiveOhOne::ElementDefs::SeparatorElementVal>#value
                      0.00      0.00      0.00      0.00              3/3     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TM#companion
                      0.00      0.00      0.00      0.00              3/3     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DT#companion
--------------------------------------------------------------------------------
                      0.02      0.00      0.00      0.02          214/214     Class#new
   4.35%   0.00%      0.02      0.00      0.00      0.02              214     Stupidedi::Values::CompositeElementVal#initialize
                      0.00      0.00      0.00      0.00          25/1284     NilClass#nil?
                      0.00      0.00      0.00      0.00         189/3364     Kernel#nil?
                      0.00      0.00      0.00      0.00         189/1301     Array#map
--------------------------------------------------------------------------------
                      0.02      0.00      0.00      0.02          189/189     Array#map
   4.35%   0.00%      0.02      0.00      0.00      0.02              189     Stupidedi::Values::CompositeElementVal#copy
                      0.00      0.00      0.00      0.00        756/41773     Hash#fetch
                      0.00      0.00      0.00      0.00        189/15961     Class#new
                      0.00      0.00      0.00      0.00        189/12203     Kernel#class
--------------------------------------------------------------------------------
                      0.02      0.01      0.00      0.01        2076/2076     Array#map
   4.35%   2.17%      0.02      0.01      0.00      0.01             2076     Stupidedi::Values::SimpleElementVal#copy
                      0.00      0.00      0.00      0.00       6228/41773     Hash#fetch
                      0.00      0.01      0.00      0.00       2076/15961     Class#new
                      0.00      0.00      0.00      0.00       2076/12203     Kernel#class
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         176/2313     Stupidedi::AbsoluteSet#as_mask
                      0.00      0.00      0.00      0.00           1/2313     #<Class:0xb746a458>#push
                      0.00      0.00      0.00      0.00           3/2313     Stupidedi::Envelope::InterchangeVal#append
                      0.00      0.00      0.00      0.00           3/2313     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal>#value
                      0.00      0.00      0.00      0.00           4/2313     Stupidedi::Envelope::TransactionSetVal#append
                      0.00      0.00      0.00      0.00         133/2313     Stupidedi::AbsoluteSet#==
                      0.00      0.00      0.00      0.00           2/2313     Array#select
                      0.00      0.00      0.00      0.00          16/2313     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DecimalVal>#value
                      0.00      0.00      0.00      0.00          17/2313     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal>#value
                      0.00      0.00      0.00      0.00         221/2313     Stupidedi::AbsoluteSet#intersection
                      0.00      0.00      0.00      0.00           1/2313     Stupidedi::Reader::SegmentDict::NonEmpty#push
                      0.00      0.00      0.00      0.00           3/2313     Stupidedi::Envelope::FunctionalGroupVal#append
                      0.00      0.00      0.00      0.00         471/2313     #<Class:0xb75eda14>#intersection
                      0.00      0.00      0.00      0.00         330/2313     Stupidedi::AbsoluteSet#union
                      0.00      0.00      0.00      0.00          11/2313     Module#abstract
                      0.00      0.00      0.00      0.00         130/2313     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal>#value
                      0.00      0.00      0.00      0.00           4/2313     Module#delegate
                      0.00      0.00      0.00      0.00           9/2313     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal>#value
                      0.01      0.01      0.00      0.00         778/2313     Stupidedi::Either::Success#flatmap
   2.17%   2.17%      0.01      0.01      0.00      0.00             2313     Kernel#is_a?
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01              1/1     Stupidedi::Either::Success#flatmap
   2.17%   0.00%      0.01      0.00      0.00      0.01                1     Stupidedi::Reader::StreamReader#read_segment
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Reader::StreamReader#consume_isa
                      0.00      0.00      0.00      0.00            1/778     Stupidedi::Either::Success#flatmap
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01            56/56     Stupidedi::Reader::TokenReader#read_segment
   2.17%   0.00%      0.01      0.00      0.00      0.01               56     Stupidedi::Reader::TokenReader#read_segment_id
                      0.01      0.00      0.00      0.01           55/693     Stupidedi::Reader::TokenReader#advance
                      0.00      0.00      0.00      0.00           55/757     Stupidedi::Reader::TokenReader#result
                      0.00      0.00      0.00      0.00            55/58     String#upcase
                      0.00      0.00      0.00      0.00         143/2126     String#length
                      0.00      0.00      0.00      0.00         143/1063     String#<<
                      0.00      0.00      0.00      0.00          55/6012     Fixnum#-
                      0.00      0.00      0.00      0.00            55/56     String#to_sym
                      0.00      0.00      0.00      0.00         110/4827     Kernel#===
                      0.00      0.00      0.00      0.00         311/2550     Stupidedi::Reader::FileInput#defined_at?
                      0.00      0.00      0.00      0.00         310/1855     Stupidedi::Reader::FileInput#at
                      0.00      0.00      0.00      0.00          310/765     Stupidedi::Reader::TokenReader#is_delimiter?
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Reader::TokenReader#failure
                      0.00      0.00      0.00      0.00        310/13457     Fixnum#+
                      0.00      0.00      0.00      0.00         143/1331     Fixnum#==
                      0.00      0.00      0.00      0.00         255/1795     Stupidedi::Reader::TokenReader#is_control?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         357/1331     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
                      0.00      0.00      0.00      0.00         119/1331     Stupidedi::AbsoluteSet#==
                      0.00      0.00      0.00      0.00           5/1331     Rational#/
                      0.00      0.00      0.00      0.00          22/1331     <Class::Stupidedi::Builder_::AbstractState>#sequence
                      0.00      0.00      0.00      0.00         343/1331     Array#each
                      0.00      0.00      0.00      0.00         274/1331     OpenStruct#method_missing
                      0.00      0.00      0.00      0.00          15/1331     Stupidedi::Reader::TokenReader#consume_prefix
                      0.00      0.00      0.00      0.00           1/1331     <Class::Stupidedi::Builder_::AbstractState>#tsequence
                      0.00      0.00      0.00      0.00         143/1331     Stupidedi::Reader::TokenReader#read_segment_id
                      0.00      0.00      0.00      0.00          22/1331     <Class::Stupidedi::Builder_::AbstractState>#lsequence
                      0.01      0.01      0.00      0.00          30/1331     <Class::Rational>#reduce
   2.17%   2.17%      0.01      0.01      0.00      0.00             1331     Fixnum#==
                      0.00      0.00      0.00      0.00             2/29     Bignum#==
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00       4557/10063     Kernel#===
                      0.00      0.00      0.00      0.00          1/10063     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00       2221/10063     Stupidedi::Reader::TokenReader#is_delimiter?
                      0.00      0.00      0.00      0.00          3/10063     Stupidedi::Reader::StreamReader#consume_isa
                      0.00      0.00      0.00      0.00         15/10063     Stupidedi::Reader::TokenReader#consume_prefix
                      0.01      0.01      0.00      0.00       3266/10063     Array#each
   2.17%   2.17%      0.01      0.01      0.00      0.00            10063     String#==
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         143/2126     Stupidedi::Reader::TokenReader#read_segment_id
                      0.00      0.00      0.00      0.00           3/2126     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal>#value
                      0.00      0.00      0.00      0.00          30/2126     Stupidedi::Reader::TokenReader#consume_prefix
                      0.01      0.01      0.00      0.00        1950/2126     Stupidedi::Reader::FileInput#drop
   2.17%   2.17%      0.01      0.01      0.00      0.00             2126     String#length
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             1/55     Stupidedi::Reader::SegmentDict::NonEmpty#at
                      0.01      0.00      0.00      0.01            54/55     Stupidedi::Either::Success#flatmap
   2.17%   0.00%      0.01      0.00      0.00      0.01               55     Stupidedi::Reader::SegmentDict::NonEmpty#at
                      0.01      0.00      0.00      0.01           55/111     Stupidedi::Reader::SegmentDict::Constants#defined_at?
                      0.00      0.00      0.00      0.00            54/54     Stupidedi::Reader::SegmentDict::Constants#at
                      0.00      0.00      0.00      0.00             1/55     Stupidedi::Reader::SegmentDict::NonEmpty#at
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             1/56     Stupidedi::Reader::SegmentDict::NonEmpty#defined_at?
                      0.01      0.00      0.00      0.01            55/56     Stupidedi::Either::Success#flatmap
   2.17%   0.00%      0.01      0.00      0.00      0.01               56     Stupidedi::Reader::SegmentDict::NonEmpty#defined_at?
                      0.01      0.00      0.00      0.01           56/111     Stupidedi::Reader::SegmentDict::Constants#defined_at?
                      0.00      0.00      0.00      0.00              1/1     #<Class:0xb746a458>#defined_at?
                      0.00      0.00      0.00      0.00             1/56     Stupidedi::Reader::SegmentDict::NonEmpty#defined_at?
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01              1/1     Array#each
   2.17%   0.00%      0.01      0.00      0.00      0.01                1     <Class::Stupidedi::Builder_::InterchangeState>#push
                      0.01      0.00      0.00      0.01              1/1     #<Class:0xb761e7a4>#value
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Reader::Separators#merge
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Configuration::InterchangeConfig#defined_at?
                      0.00      0.00      0.00      0.00              1/1     <Class::Stupidedi::Builder_::InterchangeState>#instructions
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Envelope::InterchangeDef#entry_segment_use
                      0.00      0.00      0.00      0.00             1/25     Stupidedi::Builder_::InstructionTable::NonEmpty#push
                      0.00      0.00      0.00      0.00             1/56     <Class::Stupidedi::Builder_::AbstractState>#segment
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Configuration::InterchangeConfig#at
                      0.00      0.00      0.00      0.00           1/1482     Array#at
                      0.00      0.00      0.00      0.00            1/119     Object#try
                      0.00      0.00      0.00      0.00          1/15961     Class#new
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeVal#segment_dict
                      0.00      0.00      0.00      0.00              1/1     #<Class:0xb746a458>#push
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01              1/1     Array#each
   2.17%   0.00%      0.01      0.00      0.00      0.01                1     <Class::Stupidedi::Builder_::TransactionSetState>#push
                      0.01      0.00      0.00      0.01              1/4     <Class::Stupidedi::Builder_::TableState>#push
                      0.00      0.00      0.00      0.00              1/3     Stupidedi::Values::SegmentVal#at
                      0.00      0.00      0.00      0.00              1/1     <Class::Stupidedi::Builder_::TransactionSetState>#instructions
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Envelope::TransactionSetDef#empty
                      0.00      0.00      0.00      0.00             1/48     Class#inherited
                      0.00      0.00      0.00      0.00             1/64     String#blankness?
                      0.00      0.00      0.00      0.00             3/62     Module#attr_reader
                      0.00      0.00      0.00      0.00             2/53     Kernel#singleton_method_added
                      0.00      0.00      0.00      0.00              1/2     Stupidedi::Values::SegmentValGroup#at
                      0.00      0.00      0.00      0.00            1/709     Array#head
                      0.00      0.00      0.00      0.00             1/25     Stupidedi::Builder_::InstructionTable::NonEmpty#push
                      0.00      0.00      0.00      0.00           2/1482     Array#at
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Configuration::TransactionSetConfig#defined_at?
                      0.00      0.00      0.00      0.00            7/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00          1/15961     Class#new
                      0.00      0.00      0.00      0.00              2/6     Stupidedi::Builder_::AbstractState#config
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Envelope::TransactionSetDef#entry_segment_use
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal::NonEmpty#to_s
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Configuration::TransactionSetConfig#at
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01              1/1     Array#each
   2.17%   0.00%      0.01      0.00      0.00      0.01                1     Stupidedi::Builder_::TableState#add
                      0.01      0.00      0.00      0.01             1/34     Stupidedi::Builder_::AbstractState#segment
                      0.00      0.00      0.00      0.00              1/5     Stupidedi::Values::TableVal#append
                      0.00      0.00      0.00      0.00              1/6     Stupidedi::Builder_::TableState#copy
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01              1/1     <Class::Stupidedi::Builder_::InterchangeState>#push
   2.17%   0.00%      0.01      0.00      0.00      0.01                1     #<Class:0xb761e7a4>#value
                      0.01      0.00      0.00      0.01          1/15961     Class#new
                      0.00      0.00      0.00      0.00              3/5     Module#method_added
                      0.00      0.00      0.00      0.00             3/62     Module#attr_reader
                      0.00      0.00      0.00      0.00             2/48     Class#inherited
                      0.00      0.00      0.00      0.00            1/397     Object#cons
                      0.00      0.00      0.00      0.00            9/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00             3/11     Module#abstract
                      0.00      0.00      0.00      0.00              1/7     Module#include
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01              4/4     <Class::Stupidedi::Builder_::TableState>#push
   2.17%   0.00%      0.01      0.00      0.00      0.01                4     <Class::Stupidedi::Builder_::TableState>#instructions
                      0.01      0.00      0.00      0.01             4/22     <Class::Stupidedi::Builder_::AbstractState>#lsequence
                      0.00      0.00      0.00      0.00            8/286     Array#concat
                      0.00      0.00      0.00      0.00           4/2089     Hash#[]
                      0.00      0.00      0.00      0.00           4/1944     Hash#[]=
                      0.00      0.00      0.00      0.00             8/48     <Class::Stupidedi::Builder_::AbstractState>#sequence
                      0.00      0.00      0.00      0.00          1/15961     Class#new
                      0.00      0.00      0.00      0.00           8/2203     Array#length
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           18/709     <Class::Stupidedi::Builder_::LoopState>#instructions
                      0.00      0.00      0.00      0.00          166/709     Stupidedi::Schema::LoopDef#entry_segment_use
                      0.00      0.00      0.00      0.00           17/709     Stupidedi::Builder_::ConstraintTable::ValueBased#matches
                      0.00      0.00      0.00      0.00            2/709     Stupidedi::Envelope::TransactionSetDef#entry_segment_use
                      0.00      0.00      0.00      0.00            1/709     <Class::Stupidedi::Builder_::InterchangeState>#instructions
                      0.00      0.00      0.00      0.00            1/709     Stupidedi::Envelope::FunctionalGroupDef#entry_segment_use
                      0.00      0.00      0.00      0.00            1/709     Stupidedi::Envelope::InterchangeDef#entry_segment_use
                      0.00      0.00      0.00      0.00           17/709     Stupidedi::Builder_::ConstraintTable::ValueBased#basis
                      0.00      0.00      0.00      0.00            1/709     <Class::Stupidedi::Builder_::TransactionSetState>#instructions
                      0.00      0.00      0.00      0.00            1/709     <Class::Stupidedi::Builder_::TransactionSetState>#push
                      0.01      0.01      0.00      0.00          484/709     Stupidedi::Reader::TokenReader#read_elements
   2.17%   2.17%      0.01      0.01      0.00      0.00              709     Array#head
                      0.00      0.00      0.00      0.00         709/1253     Array#empty?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           1/2089     Stupidedi::Configuration::TransactionSetConfig#at
                      0.00      0.00      0.00      0.00           1/2089     Stupidedi::Configuration::FunctionalGroupConfig#at
                      0.00      0.00      0.00      0.00           1/2089     Unknown#segment
                      0.00      0.00      0.00      0.00           1/2089     Stupidedi::Configuration::InterchangeConfig#at
                      0.00      0.00      0.00      0.00          74/2089     Hash#at
                      0.00      0.00      0.00      0.00         357/2089     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
                      0.00      0.00      0.00      0.00           4/2089     <Class::Stupidedi::Builder_::TableState>#instructions
                      0.00      0.00      0.00      0.00         273/2089     OpenStruct#method_missing
                      0.00      0.00      0.00      0.00           1/2089     <Class::Stupidedi::Builder_::FunctionalGroupState>#instructions
                      0.00      0.00      0.00      0.00         116/2089     Unknown#element
                      0.00      0.00      0.00      0.00           1/2089     <Class::Stupidedi::Builder_::TransactionSetState>#instructions
                      0.00      0.00      0.00      0.00           1/2089     <Class::Stupidedi::Builder_::InterchangeState>#instructions
                      0.00      0.00      0.00      0.00          25/2089     Stupidedi::Builder_::InstructionTable::NonEmpty#push
                      0.01      0.00      0.00      0.01        1233/2089     Array#each
   2.17%   0.00%      0.01      0.00      0.00      0.01             2089     Hash#[]
                      0.01      0.00      0.00      0.01        1350/1350     Hash#default
                      0.00      0.00      0.00      0.00            26/52     Array#hash
                      0.00      0.00      0.00      0.00            8/734     Kernel#hash
                      0.00      0.00      0.00      0.00              1/2     Array#eql?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         788/1944     Hash#each
                      0.00      0.00      0.00      0.00          78/1944     Array#each
                      0.00      0.00      0.00      0.00           4/1944     <Class::Stupidedi::Builder_::TableState>#instructions
                      0.00      0.00      0.00      0.00          25/1944     Stupidedi::Builder_::InstructionTable::NonEmpty#push
                      0.00      0.00      0.00      0.00           1/1944     <Class::Stupidedi::Builder_::FunctionalGroupState>#instructions
                      0.00      0.00      0.00      0.00         357/1944     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
                      0.00      0.00      0.00      0.00           1/1944     <Class::Stupidedi::Builder_::InterchangeState>#instructions
                      0.00      0.00      0.00      0.00           1/1944     OpenStruct#method_missing
                      0.00      0.00      0.00      0.00           1/1944     <Class::Stupidedi::Builder_::TransactionSetState>#instructions
                      0.01      0.01      0.00      0.00         688/1944     Proc#call
   2.17%   2.17%      0.01      0.01      0.00      0.00             1944     Hash#[]=
                      0.00      0.00      0.00      0.00           85/734     Kernel#hash
                      0.00      0.00      0.00      0.00            25/52     Array#hash
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         12/41773     Stupidedi::Builder_::FunctionalGroupState#copy
                      0.00      0.00      0.00      0.00        756/41773     Stupidedi::Values::CompositeElementVal#copy
                      0.00      0.00      0.00      0.00        528/41773     Stupidedi::Reader::Success#copy
                      0.00      0.00      0.00      0.00        288/41773     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00        520/41773     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DecimalVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00         18/41773     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00          2/41773     Stupidedi::Reader::SegmentDict::NonEmpty#copy
                      0.00      0.00      0.00      0.00       6228/41773     Stupidedi::Values::SimpleElementVal#copy
                      0.00      0.00      0.00      0.00         18/41773     Stupidedi::Builder_::TableState#copy
                      0.00      0.00      0.00      0.00         15/41773     Stupidedi::Builder_::TransactionSetState#copy
                      0.00      0.00      0.00      0.00         12/41773     Stupidedi::Reader::Separators#copy
                      0.00      0.00      0.00      0.00          3/41773     Stupidedi::Reader::StreamReader#copy
                      0.00      0.00      0.00      0.00         12/41773     Stupidedi::Envelope::TransactionSetVal#copy
                      0.00      0.00      0.00      0.00       1102/41773     Stupidedi::AbsoluteSet#copy
                      0.00      0.00      0.00      0.00         20/41773     Stupidedi::Builder_::InterchangeState#copy
                      0.00      0.00      0.00      0.00        345/41773     Stupidedi::Values::LoopVal#copy
                      0.00      0.00      0.00      0.00         15/41773     Stupidedi::Values::TableVal#copy
                      0.00      0.00      0.00      0.00       1372/41773     Stupidedi::Values::SegmentVal#copy
                      0.00      0.00      0.00      0.00          6/41773     Stupidedi::Envelope::FunctionalGroupVal#copy
                      0.00      0.00      0.00      0.00        237/41773     Stupidedi::Builder_::LoopState#copy
                      0.00      0.00      0.00      0.00       1568/41773     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00       2088/41773     Stupidedi::Reader::TokenReader#copy
                      0.00      0.00      0.00      0.00        446/41773     Stupidedi::Builder_::InstructionTable::NonEmpty#copy
                      0.00      0.00      0.00      0.00          4/41773     Module#delegate
                      0.00      0.00      0.00      0.00          6/41773     Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeVal#copy
                      0.00      0.00      0.00      0.00       2864/41773     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00         18/41773     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal::Proper#copy
                      0.01      0.01      0.00      0.00      23270/41773     Stupidedi::Builder_::Instruction#copy
   2.17%   2.17%      0.01      0.01      0.00      0.00            41773     Hash#fetch
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00        975/12203     Stupidedi::Reader::FileInput#drop
                      0.00      0.00      0.00      0.00          3/12203     Stupidedi::Builder_::FunctionalGroupState#copy
                      0.00      0.00      0.00      0.00        189/12203     Stupidedi::Values::CompositeElementVal#copy
                      0.00      0.00      0.00      0.00       4654/12203     Stupidedi::Builder_::Instruction#copy
                      0.00      0.00      0.00      0.00         72/12203     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00        130/12203     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DecimalVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00        133/12203     Stupidedi::AbsoluteSet#==
                      0.00      0.00      0.00      0.00          3/12203     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00          1/12203     Stupidedi::Reader::SegmentDict::NonEmpty#copy
                      0.00      0.00      0.00      0.00       2076/12203     Stupidedi::Values::SimpleElementVal#copy
                      0.00      0.00      0.00      0.00          6/12203     Stupidedi::Builder_::TableState#copy
                      0.00      0.00      0.00      0.00          5/12203     Stupidedi::Builder_::TransactionSetState#copy
                      0.00      0.00      0.00      0.00          3/12203     Stupidedi::Reader::Separators#copy
                      0.00      0.00      0.00      0.00          3/12203     Stupidedi::Reader::StreamReader#copy
                      0.00      0.00      0.00      0.00          4/12203     Stupidedi::Envelope::TransactionSetVal#copy
                      0.00      0.00      0.00      0.00          4/12203     Stupidedi::Builder_::InterchangeState#copy
                      0.00      0.00      0.00      0.00          3/12203     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal::Proper#copy
                      0.00      0.00      0.00      0.00        115/12203     Stupidedi::Values::LoopVal#copy
                      0.00      0.00      0.00      0.00          5/12203     Stupidedi::Values::TableVal#copy
                      0.00      0.00      0.00      0.00        264/12203     Stupidedi::Reader::Success#copy
                      0.00      0.00      0.00      0.00          2/12203     Stupidedi::Envelope::FunctionalGroupVal#copy
                      0.00      0.00      0.00      0.00         79/12203     Stupidedi::Builder_::LoopState#copy
                      0.00      0.00      0.00      0.00        330/12203     Stupidedi::AbsoluteSet#union
                      0.00      0.00      0.00      0.00        392/12203     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00        696/12203     Stupidedi::Reader::TokenReader#copy
                      0.00      0.00      0.00      0.00        223/12203     Stupidedi::Builder_::InstructionTable::NonEmpty#copy
                      0.00      0.00      0.00      0.00          2/12203     Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeVal#copy
                      0.00      0.00      0.00      0.00        221/12203     Stupidedi::AbsoluteSet#intersection
                      0.00      0.00      0.00      0.00        716/12203     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00        551/12203     Stupidedi::AbsoluteSet#copy
                      0.01      0.01      0.00      0.00        343/12203     Stupidedi::Values::SegmentVal#copy
   2.17%   2.17%      0.01      0.01      0.00      0.00            12203     Kernel#class
--------------------------------------------------------------------------------
                      0.01      0.01      0.00      0.00          975/975     Stupidedi::Reader::FileInput#drop
   2.17%   2.17%      0.01      0.01      0.00      0.00              975     String#rindex
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01            12/12     Stupidedi::Reader::TokenReader#read_elements
   2.17%   0.00%      0.01      0.00      0.00      0.01               12     Stupidedi::Reader::TokenReader#read_composite_element
                      0.00      0.00      0.00      0.00            12/26     Stupidedi::Reader::TokenReader#read_component_elements
                      0.00      0.00      0.00      0.00           12/778     Stupidedi::Either::Success#flatmap
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            18/22     <Class::Stupidedi::Builder_::LoopState>#instructions
                      0.01      0.00      0.00      0.01             4/22     <Class::Stupidedi::Builder_::TableState>#instructions
   2.17%   0.00%      0.01      0.00      0.00      0.01               22     <Class::Stupidedi::Builder_::AbstractState>#lsequence
                      0.00      0.00      0.00      0.00          20/6012     Fixnum#-
                      0.00      0.00      0.00      0.00             7/14     Stupidedi::Schema::LoopDef#repeatable?
                      0.00      0.00      0.00      0.00          22/3364     Kernel#nil?
                      0.00      0.01      0.00      0.00          44/1446     Array#each
                      0.00      0.00      0.00      0.00          22/1331     Fixnum#==
                      0.00      0.00      0.00      0.00          42/2203     Array#length
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          198/396     Array#split_at
                      0.01      0.01      0.00      0.00          198/396     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
   2.17%   2.17%      0.01      0.01      0.00      0.00              396     Array#drop
                      0.00      0.00      0.00      0.00          396/598     Array#slice
                      0.00      0.00      0.00      0.00         396/3389     Fixnum#<
                      0.00      0.00      0.00      0.00        396/15794     <Class::Object>#allocate
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01        1350/1350     Hash#[]
   2.17%   0.00%      0.01      0.00      0.00      0.01             1350     Hash#default
                      0.01      0.00      0.00      0.01          688/688     Proc#call
--------------------------------------------------------------------------------
                      0.01      0.01      0.00      0.00          975/975     Class#new
   2.17%   2.17%      0.01      0.01      0.00      0.00              975     Stupidedi::Reader::FileInput#initialize
--------------------------------------------------------------------------------
                      0.01      0.01      0.00      0.00          264/264     Stupidedi::Reader::Success#map
   2.17%   2.17%      0.01      0.01      0.00      0.00              264     Stupidedi::Reader::Success#copy
                      0.00      0.00      0.00      0.00        528/41773     Hash#fetch
                      0.00      0.00      0.00      0.00        264/15961     Class#new
                      0.00      0.00      0.00      0.00        264/12203     Kernel#class
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01          688/688     Hash#default
   2.17%   0.00%      0.01      0.00      0.00      0.01              688     Proc#call
                      0.01      0.01      0.00      0.00         688/1944     Hash#[]=
--------------------------------------------------------------------------------
                      0.01      0.01      0.00      0.00        4935/4935     Class#new
   2.17%   2.17%      0.01      0.01      0.00      0.00             4935     Stupidedi::Builder_::Instruction#initialize
--------------------------------------------------------------------------------
                      0.01      0.01      0.00      0.00              3/3     Class#new
   2.17%   2.17%      0.01      0.01      0.00      0.00                3     Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeVal#initialize
                      0.00      0.00      0.00      0.00             1/16     Array#first
                      0.00      0.00      0.00      0.00           1/1284     NilClass#nil?
                      0.00      0.00      0.00      0.00              3/3     Stupidedi::Envelope::InterchangeVal#initialize
                      0.00      0.00      0.00      0.00              2/3     Stupidedi::Reader::Separators#copy
                      0.00      0.00      0.00      0.00              1/2     Stupidedi::Values::SegmentValGroup#at
                      0.00      0.00      0.00      0.00              2/3     Stupidedi::Values::SegmentVal#at
                      0.00      0.00      0.00      0.00              2/2     Stupidedi::Dictionaries::Interchanges::FiveOhOne::ElementDefs::SeparatorElementVal#to_s
                      0.00      0.00      0.00      0.00           2/3364     Kernel#nil?
                      0.00      0.00      0.00      0.00          1/15961     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           73/178     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#empty
                      0.01      0.01      0.00      0.00          105/178     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
   2.17%   2.17%      0.01      0.01      0.00      0.00              178     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::AN#companion
                      0.00      0.00      0.00      0.00              1/4     Module#delegate
                      0.00      0.00      0.00      0.00             3/48     Class#inherited
                      0.00      0.00      0.00      0.00             1/62     Module#attr_reader
                      0.00      0.00      0.00      0.00             3/26     Kernel#send
                      0.00      0.00      0.00      0.00             2/53     Kernel#singleton_method_added
                      0.00      0.00      0.00      0.00            8/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00             3/22     Object#eigenclass
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01              3/3     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
   2.17%   0.00%      0.01      0.00      0.00      0.01                3     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal>#value
                      0.01      0.00      0.00      0.01          3/15961     Class#new
                      0.00      0.00      0.00      0.00           9/3543     String#to_s
                      0.00      0.00      0.00      0.00           3/3389     Fixnum#<
                      0.00      0.00      0.00      0.00           3/2126     String#length
                      0.00      0.00      0.00      0.00           3/3364     Kernel#nil?
                      0.00      0.00      0.00      0.00           3/2313     Kernel#is_a?
                      0.00      0.00      0.00      0.00             9/22     String#slice
                      0.00      0.00      0.00      0.00            3/253     String#empty?
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01              5/5     Class#new
   2.17%   0.00%      0.01      0.00      0.00      0.01                5     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal::Proper#initialize
                      0.01      0.00      0.00      0.01              5/5     <Class::Date>#civil
                      0.00      0.00      0.00      0.00             6/43     String#to_i
                      0.00      0.00      0.00      0.00              9/9     Integer#to_i
                      0.00      0.00      0.00      0.00           5/3904     Stupidedi::Values::SimpleElementVal#initialize
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01              5/5     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal::Proper#initialize
   2.17%   0.00%      0.01      0.00      0.00      0.01                5     <Class::Date>#civil
                      0.01      0.00      0.00      0.01              5/5     <Class::Date>#jd_to_ajd
                      0.00      0.00      0.00      0.00              5/5     Class#new!
                      0.00      0.00      0.00      0.00              5/5     <Class::Date>#valid_civil?
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01              5/5     <Class::Date>#civil
   2.17%   0.00%      0.01      0.00      0.00      0.01                5     <Class::Date>#jd_to_ajd
                      0.01      0.00      0.00      0.01              5/5     Integer#to_r
                      0.00      0.00      0.00      0.00          10/6012     Fixnum#-
                      0.00      0.00      0.00      0.00             5/10     Rational#/
                      0.00      0.00      0.00      0.00          5/13457     Fixnum#+
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01              5/5     <Class::Date>#jd_to_ajd
   2.17%   0.00%      0.01      0.00      0.00      0.01                5     Integer#to_r
                      0.01      0.00      0.00      0.01             5/15     Object#Rational
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             5/15     Rational#/
                      0.00      0.00      0.00      0.00             5/15     Rational#-
                      0.01      0.00      0.00      0.01             5/15     Integer#to_r
   2.17%   0.00%      0.01      0.00      0.00      0.01               15     Object#Rational
                      0.01      0.00      0.00      0.01            15/15     <Class::Rational>#reduce
                      0.00      0.00      0.00      0.00            15/95     Kernel#kind_of?
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01            15/15     Object#Rational
   2.17%   0.00%      0.01      0.00      0.00      0.01               15     <Class::Rational>#reduce
                      0.01      0.01      0.00      0.00          30/1331     Fixnum#==
                      0.00      0.00      0.00      0.00            15/15     Integer#gcd
                      0.00      0.00      0.00      0.00            15/25     <Class::Rational>#new!
                      0.00      0.00      0.00      0.00          15/3389     Fixnum#<
                      0.00      0.00      0.00      0.00            30/30     Fixnum#div
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            8/377     Stupidedi::Schema::SegmentDef#value
                      0.00      0.00      0.00      0.00            9/377     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TM#companion
                      0.00      0.00      0.00      0.00           21/377     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DT#companion
                      0.00      0.00      0.00      0.00           10/377     Hash#each
                      0.00      0.00      0.00      0.00            8/377     Stupidedi::Schema::CompositeElementDef#empty
                      0.00      0.00      0.00      0.00            9/377     Stupidedi::Schema::TableDef#value
                      0.00      0.00      0.00      0.00           18/377     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::Nn#companion
                      0.00      0.00      0.00      0.00           10/377     Stupidedi::Reader::StreamReader#result
                      0.00      0.00      0.00      0.00            9/377     Stupidedi::Schema::LoopDef#value
                      0.00      0.00      0.00      0.00            7/377     Array#each
                      0.00      0.00      0.00      0.00           31/377     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00           25/377     Stupidedi::Builder_::StateMachine#read!
                      0.00      0.00      0.00      0.00            7/377     <Class::Stupidedi::Builder_::TransactionSetState>#push
                      0.00      0.00      0.00      0.00           10/377     #<Class:0xb77871b8>#value
                      0.00      0.00      0.00      0.00            6/377     Stupidedi::Reader::TokenReader#simple
                      0.00      0.00      0.00      0.00            6/377     Stupidedi::Reader::TokenReader#composite
                      0.00      0.00      0.00      0.00           18/377     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::R#companion
                      0.00      0.00      0.00      0.00           18/377     Class#initialize
                      0.00      0.00      0.00      0.00           68/377     Module#attr_reader
                      0.00      0.00      0.00      0.00           26/377     Module#class_eval
                      0.00      0.00      0.00      0.00            7/377     <Class::Stupidedi::Builder_::FunctionalGroupState>#instructions
                      0.00      0.00      0.00      0.00            9/377     #<Class:0xb761e7a4>#value
                      0.00      0.00      0.00      0.00            4/377     Module#attr_accessor
                      0.00      0.00      0.00      0.00            4/377     Stupidedi::Reader::TokenReader#component
                      0.00      0.00      0.00      0.00            8/377     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::AN#companion
                      0.00      0.00      0.00      0.00            8/377     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::ID#companion
                      0.00      0.00      0.00      0.00            7/377     <Class::Stupidedi::Builder_::InterchangeState>#instructions
                      0.00      0.00      0.00      0.00            6/377     Stupidedi::Envelope::TransactionSetDef#empty
   0.00%   0.00%      0.00      0.00      0.00      0.00              377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00          377/377     Module#blank_slate_method_added
                      0.00      0.00      0.00      0.00          377/384     Module#==
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           15/778     Stupidedi::Reader::TokenReader#success
                      0.00      0.00      0.00      0.00            3/778     Stupidedi::Reader::StreamReader#result
                      0.00      0.00      0.00      0.00            1/778     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00            1/778     Stupidedi::Reader::StreamReader#success
                      0.00      0.00      0.00      0.00            1/778     Stupidedi::Builder_::StateMachine#read!
                      0.00      0.00      0.00      0.00          757/778     Stupidedi::Reader::TokenReader#result
   0.00%   0.00%      0.00      0.00      0.00      0.00              778     <Class::Stupidedi::Either>#success
                      0.00      0.00      0.00      0.00        778/15961     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             1/48     Stupidedi::Schema::SegmentDef#value
                      0.00      0.00      0.00      0.00             3/48     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TM#companion
                      0.00      0.00      0.00      0.00             4/48     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DT#companion
                      0.00      0.00      0.00      0.00             4/48     Hash#each
                      0.00      0.00      0.00      0.00             1/48     Stupidedi::Schema::CompositeElementDef#empty
                      0.00      0.00      0.00      0.00             1/48     Stupidedi::Schema::TableDef#value
                      0.00      0.00      0.00      0.00             3/48     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::Nn#companion
                      0.00      0.00      0.00      0.00             3/48     Stupidedi::Reader::StreamReader#result
                      0.00      0.00      0.00      0.00             1/48     Stupidedi::Schema::LoopDef#value
                      0.00      0.00      0.00      0.00             1/48     Array#each
                      0.00      0.00      0.00      0.00             2/48     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00             4/48     Stupidedi::Builder_::StateMachine#read!
                      0.00      0.00      0.00      0.00             1/48     <Class::Stupidedi::Builder_::TransactionSetState>#push
                      0.00      0.00      0.00      0.00             1/48     #<Class:0xb77871b8>#value
                      0.00      0.00      0.00      0.00             1/48     Stupidedi::Reader::TokenReader#simple
                      0.00      0.00      0.00      0.00             1/48     Stupidedi::Reader::TokenReader#composite
                      0.00      0.00      0.00      0.00             3/48     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::R#companion
                      0.00      0.00      0.00      0.00             1/48     Class#initialize
                      0.00      0.00      0.00      0.00             1/48     <Class::Stupidedi::Builder_::FunctionalGroupState>#instructions
                      0.00      0.00      0.00      0.00             2/48     #<Class:0xb761e7a4>#value
                      0.00      0.00      0.00      0.00             1/48     Stupidedi::Reader::TokenReader#component
                      0.00      0.00      0.00      0.00             3/48     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::AN#companion
                      0.00      0.00      0.00      0.00             3/48     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::ID#companion
                      0.00      0.00      0.00      0.00             1/48     <Class::Stupidedi::Builder_::InterchangeState>#instructions
                      0.00      0.00      0.00      0.00             1/48     Stupidedi::Envelope::TransactionSetDef#empty
   0.00%   0.00%      0.00      0.00      0.00      0.00               48     Class#inherited
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             3/26     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TM#companion
                      0.00      0.00      0.00      0.00             4/26     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DT#companion
                      0.00      0.00      0.00      0.00             3/26     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::Nn#companion
                      0.00      0.00      0.00      0.00             4/26     OpenStruct#new_ostruct_member
                      0.00      0.00      0.00      0.00             3/26     Stupidedi::Builder_::StateMachine#read!
                      0.00      0.00      0.00      0.00             3/26     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::R#companion
                      0.00      0.00      0.00      0.00             3/26     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::AN#companion
                      0.00      0.00      0.00      0.00             3/26     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::ID#companion
   0.00%   0.00%      0.00      0.00      0.00      0.00               26     Kernel#send
                      0.00      0.00      0.00      0.00              7/7     Module#protected
                      0.00      0.00      0.00      0.00              4/4     Module#define_method
                      0.00      0.00      0.00      0.00            15/15     Module#public
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             2/53     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TM#companion
                      0.00      0.00      0.00      0.00             2/53     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DT#companion
                      0.00      0.00      0.00      0.00             1/53     Hash#each
                      0.00      0.00      0.00      0.00             2/53     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::Nn#companion
                      0.00      0.00      0.00      0.00            15/53     Module#public
                      0.00      0.00      0.00      0.00             2/53     Array#each
                      0.00      0.00      0.00      0.00             1/53     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00             2/53     Stupidedi::Builder_::StateMachine#read!
                      0.00      0.00      0.00      0.00             2/53     <Class::Stupidedi::Builder_::TransactionSetState>#push
                      0.00      0.00      0.00      0.00             1/53     Stupidedi::Reader::TokenReader#simple
                      0.00      0.00      0.00      0.00             1/53     Stupidedi::Reader::TokenReader#composite
                      0.00      0.00      0.00      0.00             2/53     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::R#companion
                      0.00      0.00      0.00      0.00             2/53     <Class::Stupidedi::Builder_::FunctionalGroupState>#instructions
                      0.00      0.00      0.00      0.00             1/53     Stupidedi::Reader::TokenReader#component
                      0.00      0.00      0.00      0.00             2/53     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::AN#companion
                      0.00      0.00      0.00      0.00             2/53     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::ID#companion
                      0.00      0.00      0.00      0.00             2/53     <Class::Stupidedi::Builder_::InterchangeState>#instructions
                      0.00      0.00      0.00      0.00             4/53     Module#define_method
                      0.00      0.00      0.00      0.00             7/53     Module#protected
   0.00%   0.00%      0.00      0.00      0.00      0.00               53     Kernel#singleton_method_added
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             8/11     Stupidedi::Builder_::StateMachine#read!
                      0.00      0.00      0.00      0.00             3/11     #<Class:0xb761e7a4>#value
   0.00%   0.00%      0.00      0.00      0.00      0.00               11     Module#abstract
                      0.00      0.00      0.00      0.00            11/15     Kernel#caller
                      0.00      0.00      0.00      0.00          11/2313     Kernel#is_a?
                      0.00      0.00      0.00      0.00            11/19     Array#last
                      0.00      0.00      0.00      0.00            11/16     Array#first
                      0.00      0.00      0.00      0.00            11/28     Module#class_eval
                      0.00      0.00      0.00      0.00          11/6012     Fixnum#-
                      0.00      0.00      0.00      0.00            11/43     String#to_i
                      0.00      0.00      0.00      0.00          22/3358     Symbol#to_s
                      0.00      0.00      0.00      0.00              7/7     Array#join
                      0.00      0.00      0.00      0.00          11/1253     Array#empty?
                      0.00      0.00      0.00      0.00            11/15     String#split
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/2     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00              1/2     Stupidedi::Builder_::StateMachine#read!
   0.00%   0.00%      0.00      0.00      0.00      0.00                2     Module#attr_accessor
                      0.00      0.00      0.00      0.00            4/377     <Class::Object>#method_added
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             3/22     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TM#companion
                      0.00      0.00      0.00      0.00             4/22     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DT#companion
                      0.00      0.00      0.00      0.00             3/22     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::Nn#companion
                      0.00      0.00      0.00      0.00             3/22     Stupidedi::Builder_::StateMachine#read!
                      0.00      0.00      0.00      0.00             3/22     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::R#companion
                      0.00      0.00      0.00      0.00             3/22     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::AN#companion
                      0.00      0.00      0.00      0.00             3/22     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::ID#companion
   0.00%   0.00%      0.00      0.00      0.00      0.00               22     Object#eigenclass
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            58/58     Stupidedi::Builder_::StateMachine#read!
   0.00%   0.00%      0.00      0.00      0.00      0.00               58     Stupidedi::Builder_::StateMachine#stuck?
                      0.00      0.00      0.00      0.00          58/1253     Array#empty?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Builder_::StateMachine#read!
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Either::Failure#defined?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Builder_::StateMachine#read!
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Either::Failure#map
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            57/57     Stupidedi::Builder_::StateMachine#read!
   0.00%   0.00%      0.00      0.00      0.00      0.00               57     Stupidedi::Either::Success#defined?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           1/1253     Enumerable#blankness?
                      0.00      0.00      0.00      0.00         250/1253     Stupidedi::Reader::TokenReader#read_elements
                      0.00      0.00      0.00      0.00          48/1253     <Class::Stupidedi::Builder_::AbstractState>#sequence
                      0.00      0.00      0.00      0.00         119/1253     Object#try
                      0.00      0.00      0.00      0.00          56/1253     Array#each
                      0.00      0.00      0.00      0.00          58/1253     Stupidedi::Builder_::StateMachine#stuck?
                      0.00      0.00      0.00      0.00           1/1253     <Class::Stupidedi::Builder_::AbstractState>#tsequence
                      0.00      0.00      0.00      0.00          11/1253     Module#abstract
                      0.00      0.00      0.00      0.00         709/1253     Array#head
   0.00%   0.00%      0.00      0.00      0.00      0.00             1253     Array#empty?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             1/16     Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeVal#initialize
                      0.00      0.00      0.00      0.00            11/16     Module#abstract
                      0.00      0.00      0.00      0.00             4/16     Module#delegate
   0.00%   0.00%      0.00      0.00      0.00      0.00               16     Array#first
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              7/7     Module#abstract
   0.00%   0.00%      0.00      0.00      0.00      0.00                7     Array#join
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            11/19     Module#abstract
                      0.00      0.00      0.00      0.00             8/19     Module#delegate
   0.00%   0.00%      0.00      0.00      0.00      0.00               19     Array#last
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            11/15     Module#abstract
                      0.00      0.00      0.00      0.00             4/15     Module#delegate
   0.00%   0.00%      0.00      0.00      0.00      0.00               15     Kernel#caller
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          377/384     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00            7/384     Module#append_features
   0.00%   0.00%      0.00      0.00      0.00      0.00              384     Module#==
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          377/377     <Class::Object>#method_added
   0.00%   0.00%      0.00      0.00      0.00      0.00              377     Module#blank_slate_method_added
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            17/28     Array#each
                      0.00      0.00      0.00      0.00            11/28     Module#abstract
   0.00%   0.00%      0.00      0.00      0.00      0.00               28     Module#class_eval
                      0.00      0.00      0.00      0.00              2/5     Module#method_added
                      0.00      0.00      0.00      0.00           26/377     <Class::Object>#method_added
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              7/7     Kernel#send
   0.00%   0.00%      0.00      0.00      0.00      0.00                7     Module#protected
                      0.00      0.00      0.00      0.00             7/53     Kernel#singleton_method_added
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            15/15     Kernel#send
   0.00%   0.00%      0.00      0.00      0.00      0.00               15     Module#public
                      0.00      0.00      0.00      0.00            15/53     Kernel#singleton_method_added
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            11/15     Module#abstract
                      0.00      0.00      0.00      0.00             4/15     Module#delegate
   0.00%   0.00%      0.00      0.00      0.00      0.00               15     String#split
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             6/43     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal::Proper#initialize
                      0.00      0.00      0.00      0.00             3/43     Object#try
                      0.00      0.00      0.00      0.00            17/43     Array#each
                      0.00      0.00      0.00      0.00             3/43     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal>#value
                      0.00      0.00      0.00      0.00             3/43     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal::Improper#initialize
                      0.00      0.00      0.00      0.00            11/43     Module#abstract
   0.00%   0.00%      0.00      0.00      0.00      0.00               43     String#to_i
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00        3334/3358     Array#each
                      0.00      0.00      0.00      0.00           2/3358     OpenStruct#new_ostruct_member
                      0.00      0.00      0.00      0.00          22/3358     Module#abstract
   0.00%   0.00%      0.00      0.00      0.00      0.00             3358     Symbol#to_s
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         13/15794     Integer#times
                      0.00      0.00      0.00      0.00        396/15794     Array#drop
                      0.00      0.00      0.00      0.00          1/15794     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TM#companion
                      0.00      0.00      0.00      0.00          1/15794     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DT#companion
                      0.00      0.00      0.00      0.00      15373/15794     Class#new
                      0.00      0.00      0.00      0.00          1/15794     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00          5/15794     Class#new!
                      0.00      0.00      0.00      0.00          4/15794     Array#init
   0.00%   0.00%      0.00      0.00      0.00      0.00            15794     <Class::Object>#allocate
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Reader::TokenReader#read_segment
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Either::Failure#flatmap
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00        1098/1098     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00             1098     Stupidedi::Either::Success#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Reader::StreamReader#read_segment
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Reader::StreamReader#consume_isa
                      0.00      0.00      0.00      0.00           3/1855     Stupidedi::Reader::FileInput#at
                      0.00      0.00      0.00      0.00             3/58     String#upcase
                      0.00      0.00      0.00      0.00           3/1063     String#<<
                      0.00      0.00      0.00      0.00           3/2550     Stupidedi::Reader::FileInput#defined_at?
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Reader::StreamReader#success
                      0.00      0.00      0.00      0.00          3/10063     String#==
                      0.00      0.00      0.00      0.00              1/3     Stupidedi::Reader::StreamReader#advance
                      0.00      0.00      0.00      0.00              3/3     String#slice!
                      0.00      0.00      0.00      0.00          3/13457     Fixnum#+
                      0.00      0.00      0.00      0.00           3/1798     <Module::Stupidedi::Reader>#is_control_character?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00        1795/1798     Stupidedi::Reader::TokenReader#is_control?
                      0.00      0.00      0.00      0.00           3/1798     Stupidedi::Reader::StreamReader#consume_isa
   0.00%   0.00%      0.00      0.00      0.00      0.00             1798     <Module::Stupidedi::Reader>#is_control_character?
                      0.00      0.00      0.00      0.00        1798/1798     String#=~
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00       2870/13457     Stupidedi::Reader::FileInput#drop
                      0.00      0.00      0.00      0.00       3710/13457     Hash#each
                      0.00      0.00      0.00      0.00       1090/13457     Stupidedi::Reader::TokenReader#read_simple_element
                      0.00      0.00      0.00      0.00        282/13457     Array#map
                      0.00      0.00      0.00      0.00         15/13457     <Class::Date>#jd_to_civil
                      0.00      0.00      0.00      0.00        282/13457     Array#each
                      0.00      0.00      0.00      0.00         15/13457     Stupidedi::Reader::TokenReader#consume_prefix
                      0.00      0.00      0.00      0.00       2550/13457     Stupidedi::Reader::FileInput#defined_at?
                      0.00      0.00      0.00      0.00          1/13457     Stupidedi::Reader::TokenReader#read_character
                      0.00      0.00      0.00      0.00          5/13457     <Class::Date>#jd_to_ajd
                      0.00      0.00      0.00      0.00          3/13457     Stupidedi::Reader::StreamReader#consume_isa
                      0.00      0.00      0.00      0.00         91/13457     Stupidedi::Reader::TokenReader#read_component_element
                      0.00      0.00      0.00      0.00        310/13457     Stupidedi::Reader::TokenReader#read_segment_id
                      0.00      0.00      0.00      0.00         31/13457     <Class::Date>#civil_to_jd
                      0.00      0.00      0.00      0.00        343/13457     Stupidedi::Reader::TokenReader#read_delimiter
                      0.00      0.00      0.00      0.00          4/13457     Array#init
                      0.00      0.00      0.00      0.00       1855/13457     Stupidedi::Reader::FileInput#at
   0.00%   0.00%      0.00      0.00      0.00      0.00            13457     Fixnum#+
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00        3800/4827     Stupidedi::Reader::TokenReader#read_simple_element
                      0.00      0.00      0.00      0.00         602/4827     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00         315/4827     Stupidedi::Reader::TokenReader#read_component_element
                      0.00      0.00      0.00      0.00         110/4827     Stupidedi::Reader::TokenReader#read_segment_id
   0.00%   0.00%      0.00      0.00      0.00      0.00             4827     Kernel#===
                      0.00      0.00      0.00      0.00          270/274     Kernel#==
                      0.00      0.00      0.00      0.00       4557/10063     String#==
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         837/1063     Stupidedi::Reader::TokenReader#read_simple_element
                      0.00      0.00      0.00      0.00          15/1063     Stupidedi::Reader::TokenReader#consume_prefix
                      0.00      0.00      0.00      0.00           3/1063     Stupidedi::Reader::StreamReader#consume_isa
                      0.00      0.00      0.00      0.00          65/1063     Stupidedi::Reader::TokenReader#read_component_element
                      0.00      0.00      0.00      0.00         143/1063     Stupidedi::Reader::TokenReader#read_segment_id
   0.00%   0.00%      0.00      0.00      0.00      0.00             1063     String#<<
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              3/3     Stupidedi::Reader::StreamReader#consume_isa
   0.00%   0.00%      0.00      0.00      0.00      0.00                3     String#slice!
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             1/56     OpenStruct#new_ostruct_member
                      0.00      0.00      0.00      0.00            55/56     Stupidedi::Reader::TokenReader#read_segment_id
   0.00%   0.00%      0.00      0.00      0.00      0.00               56     String#to_sym
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             3/58     Stupidedi::Reader::StreamReader#consume_isa
                      0.00      0.00      0.00      0.00            55/58     Stupidedi::Reader::TokenReader#read_segment_id
   0.00%   0.00%      0.00      0.00      0.00      0.00               58     String#upcase
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Either::Success#flatmap
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Either::Success#or
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00        1090/2550     Stupidedi::Reader::TokenReader#read_simple_element
                      0.00      0.00      0.00      0.00           3/2550     Stupidedi::Reader::StreamReader#advance
                      0.00      0.00      0.00      0.00         693/2550     Stupidedi::Reader::TokenReader#advance
                      0.00      0.00      0.00      0.00          15/2550     Stupidedi::Reader::TokenReader#consume_prefix
                      0.00      0.00      0.00      0.00           1/2550     Stupidedi::Reader::TokenReader#read_character
                      0.00      0.00      0.00      0.00           3/2550     Stupidedi::Reader::StreamReader#consume_isa
                      0.00      0.00      0.00      0.00          91/2550     Stupidedi::Reader::TokenReader#read_component_element
                      0.00      0.00      0.00      0.00         311/2550     Stupidedi::Reader::TokenReader#read_segment_id
                      0.00      0.00      0.00      0.00         343/2550     Stupidedi::Reader::TokenReader#read_delimiter
   0.00%   0.00%      0.00      0.00      0.00      0.00             2550     Stupidedi::Reader::FileInput#defined_at?
                      0.00      0.00      0.00      0.00        2550/3389     Fixnum#<
                      0.00      0.00      0.00      0.00       2550/13457     Fixnum#+
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/3     Stupidedi::Reader::StreamReader#consume_isa
                      0.00      0.00      0.00      0.00              2/3     Stupidedi::Reader::StreamReader#read_character
   0.00%   0.00%      0.00      0.00      0.00      0.00                3     Stupidedi::Reader::StreamReader#advance
                      0.00      0.00      0.00      0.00           3/6012     Fixnum#-
                      0.00      0.00      0.00      0.00           3/2550     Stupidedi::Reader::FileInput#defined_at?
                      0.00      0.00      0.00      0.00              3/3     Stupidedi::Reader::StreamReader#copy
                      0.00      0.00      0.00      0.00            3/975     Stupidedi::Reader::FileInput#drop
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              2/2     Stupidedi::Either::Success#flatmap
   0.00%   0.00%      0.00      0.00      0.00      0.00                2     Stupidedi::Reader::StreamReader#read_character
                      0.00      0.00      0.00      0.00           2/1855     Stupidedi::Reader::FileInput#at
                      0.00      0.00      0.00      0.00              2/2     Stupidedi::Reader::FileInput#empty?
                      0.00      0.00      0.00      0.00              2/3     Stupidedi::Reader::StreamReader#result
                      0.00      0.00      0.00      0.00              2/3     Stupidedi::Reader::StreamReader#advance
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Reader::StreamReader#consume_isa
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Reader::StreamReader#success
                      0.00      0.00      0.00      0.00            1/778     <Class::Stupidedi::Either>#success
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Reader::TokenReader#read_segment_id
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Reader::TokenReader#failure
                      0.00      0.00      0.00      0.00              1/1     <Class::Stupidedi::Either>#failure
                      0.00      0.00      0.00      0.00          1/15961     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00        1090/1795     Stupidedi::Reader::TokenReader#read_simple_element
                      0.00      0.00      0.00      0.00          15/1795     Stupidedi::Reader::TokenReader#consume_prefix
                      0.00      0.00      0.00      0.00           1/1795     Stupidedi::Reader::TokenReader#read_character
                      0.00      0.00      0.00      0.00          91/1795     Stupidedi::Reader::TokenReader#read_component_element
                      0.00      0.00      0.00      0.00         255/1795     Stupidedi::Reader::TokenReader#read_segment_id
                      0.00      0.00      0.00      0.00         343/1795     Stupidedi::Reader::TokenReader#read_delimiter
   0.00%   0.00%      0.00      0.00      0.00      0.00             1795     Stupidedi::Reader::TokenReader#is_control?
                      0.00      0.00      0.00      0.00          112/765     Stupidedi::Reader::TokenReader#is_delimiter?
                      0.00      0.00      0.00      0.00        1795/1798     <Module::Stupidedi::Reader>#is_control_character?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          112/765     Stupidedi::Reader::TokenReader#is_control?
                      0.00      0.00      0.00      0.00          310/765     Stupidedi::Reader::TokenReader#read_segment_id
                      0.00      0.00      0.00      0.00          343/765     Stupidedi::Reader::TokenReader#read_delimiter
   0.00%   0.00%      0.00      0.00      0.00      0.00              765     Stupidedi::Reader::TokenReader#is_delimiter?
                      0.00      0.00      0.00      0.00       2221/10063     String#==
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          253/757     Stupidedi::Reader::TokenReader#read_simple_element
                      0.00      0.00      0.00      0.00           79/757     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00            1/757     Stupidedi::Reader::TokenReader#read_character
                      0.00      0.00      0.00      0.00           26/757     Stupidedi::Reader::TokenReader#read_component_element
                      0.00      0.00      0.00      0.00           55/757     Stupidedi::Reader::TokenReader#read_segment_id
                      0.00      0.00      0.00      0.00          343/757     Stupidedi::Reader::TokenReader#read_delimiter
   0.00%   0.00%      0.00      0.00      0.00      0.00              757     Stupidedi::Reader::TokenReader#result
                      0.00      0.00      0.00      0.00          757/778     <Class::Stupidedi::Either>#success
                      0.00      0.00      0.00      0.00        757/15961     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Reader::SegmentDict::NonEmpty#defined_at?
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     #<Class:0xb746a458>#defined_at?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     <Class::Stupidedi::Builder_::FunctionalGroupState>#push
                      0.00      0.00      0.00      0.00             1/56     <Class::Stupidedi::Builder_::AbstractState>#segment
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Envelope::FunctionalGroupDef#entry_segment_use
                      0.00      0.00      0.00      0.00              1/1     <Class::Stupidedi::Builder_::FunctionalGroupState>#instructions
                      0.00      0.00      0.00      0.00              1/1     #<Class:0xb77871b8>#value
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Reader::SegmentDict::NonEmpty#push
                      0.00      0.00      0.00      0.00             1/25     Stupidedi::Builder_::InstructionTable::NonEmpty#push
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Configuration::FunctionalGroupConfig#defined_at?
                      0.00      0.00      0.00      0.00           1/1482     Array#at
                      0.00      0.00      0.00      0.00          1/15961     Class#new
                      0.00      0.00      0.00      0.00              2/6     Stupidedi::Builder_::AbstractState#config
                      0.00      0.00      0.00      0.00             1/22     String#slice
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Configuration::FunctionalGroupConfig#at
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Envelope::FunctionalGroupVal#segment_dict
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Reader::TokenReader#failure
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     <Class::Stupidedi::Either>#failure
                      0.00      0.00      0.00      0.00          1/15961     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00        1865/1885     Array#each
                      0.00      0.00      0.00      0.00          16/1885     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00           2/1885     Range#each
                      0.00      0.00      0.00      0.00           1/1885     <Class::Stupidedi::Builder_::FunctionalGroupState>#instructions
                      0.00      0.00      0.00      0.00           1/1885     <Class::Stupidedi::Builder_::InterchangeState>#instructions
   0.00%   0.00%      0.00      0.00      0.00      0.00             1885     Array#<<
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         176/3389     Stupidedi::AbsoluteSet#as_mask
                      0.00      0.00      0.00      0.00          25/3389     Rational#initialize
                      0.00      0.00      0.00      0.00         396/3389     Array#drop
                      0.00      0.00      0.00      0.00          15/3389     <Class::Rational>#reduce
                      0.00      0.00      0.00      0.00           3/3389     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal>#value
                      0.00      0.00      0.00      0.00          10/3389     <Class::Date>#valid_civil?
                      0.00      0.00      0.00      0.00         198/3389     Array#take
                      0.00      0.00      0.00      0.00           6/3389     Array#defined_at?
                      0.00      0.00      0.00      0.00        2550/3389     Stupidedi::Reader::FileInput#defined_at?
                      0.00      0.00      0.00      0.00          10/3389     <Class::Date>#julian?
   0.00%   0.00%      0.00      0.00      0.00      0.00             3389     Fixnum#<
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         975/2830     Stupidedi::Reader::FileInput#drop
                      0.00      0.00      0.00      0.00        1855/2830     Stupidedi::Reader::FileInput#at
   0.00%   0.00%      0.00      0.00      0.00      0.00             2830     Fixnum#>=
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           4/3130     Stupidedi::Builder_::TransactionSetState#pop
                      0.00      0.00      0.00      0.00           2/3130     Stupidedi::Builder_::InterchangeState#pop
                      0.00      0.00      0.00      0.00        2395/3130     Hash#each
                      0.00      0.00      0.00      0.00           3/3130     Stupidedi::Builder_::FunctionalGroupState#pop
                      0.00      0.00      0.00      0.00          63/3130     Stupidedi::Builder_::LoopState#pop
                      0.00      0.00      0.00      0.00          34/3130     Array#each
                      0.00      0.00      0.00      0.00           3/3130     Stupidedi::Builder_::TableState#drop
                      0.00      0.00      0.00      0.00         208/3130     Stupidedi::AbsoluteSet#empty?
                      0.00      0.00      0.00      0.00           1/3130     Stupidedi::Builder_::TransmissionState#pop
                      0.00      0.00      0.00      0.00           2/3130     Stupidedi::Builder_::FunctionalGroupState#drop
                      0.00      0.00      0.00      0.00           1/3130     Stupidedi::Builder_::TransmissionState#drop
                      0.00      0.00      0.00      0.00           3/3130     Stupidedi::Builder_::TransactionSetState#drop
                      0.00      0.00      0.00      0.00           2/3130     Stupidedi::Builder_::InterchangeState#drop
                      0.00      0.00      0.00      0.00           7/3130     Stupidedi::Builder_::TableState#pop
                      0.00      0.00      0.00      0.00          45/3130     Stupidedi::Builder_::LoopState#drop
                      0.00      0.00      0.00      0.00         357/3130     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
   0.00%   0.00%      0.00      0.00      0.00      0.00             3130     Fixnum#zero?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            18/74     Array#each
                      0.00      0.00      0.00      0.00            56/74     Stupidedi::Builder_::InstructionTable::NonEmpty#successors
   0.00%   0.00%      0.00      0.00      0.00      0.00               74     Hash#at
                      0.00      0.00      0.00      0.00          74/2089     Hash#[]
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           79/138     Array#each
                      0.00      0.00      0.00      0.00            1/138     Stupidedi::Configuration::TransactionSetConfig#defined_at?
                      0.00      0.00      0.00      0.00            1/138     Stupidedi::Configuration::FunctionalGroupConfig#defined_at?
                      0.00      0.00      0.00      0.00           56/138     Stupidedi::Builder_::InstructionTable::NonEmpty#successors
                      0.00      0.00      0.00      0.00            1/138     Stupidedi::Configuration::InterchangeConfig#defined_at?
   0.00%   0.00%      0.00      0.00      0.00      0.00              138     Hash#defined_at?
                      0.00      0.00      0.00      0.00          138/138     Hash#include?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         975/2830     Stupidedi::Reader::FileInput#drop
                      0.00      0.00      0.00      0.00        1855/2830     Stupidedi::Reader::FileInput#at
   0.00%   0.00%      0.00      0.00      0.00      0.00             2830     IO#seek
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          133/941     Stupidedi::AbsoluteSet#==
                      0.00      0.00      0.00      0.00           47/941     Array#each
                      0.00      0.00      0.00      0.00          386/941     #<Class:0xb75eda14>#==
                      0.00      0.00      0.00      0.00          242/941     Stupidedi::AbsoluteSet#union
                      0.00      0.00      0.00      0.00          133/941     Stupidedi::AbsoluteSet#intersection
   0.00%   0.00%      0.00      0.00      0.00      0.00              941     Kernel#eql?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         189/3364     Stupidedi::Values::CompositeElementVal#initialize
                      0.00      0.00      0.00      0.00           5/3364     Stupidedi::Envelope::TransactionSetVal#initialize
                      0.00      0.00      0.00      0.00           3/3364     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal>#value
                      0.00      0.00      0.00      0.00         292/3364     Array#map
                      0.00      0.00      0.00      0.00           2/3364     Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeVal#initialize
                      0.00      0.00      0.00      0.00        2000/3364     Array#each
                      0.00      0.00      0.00      0.00           3/3364     Stupidedi::Values::SegmentVal#at
                      0.00      0.00      0.00      0.00           2/3364     Stupidedi::Values::SegmentValGroup#at
                      0.00      0.00      0.00      0.00           3/3364     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal>#value
                      0.00      0.00      0.00      0.00          22/3364     <Class::Stupidedi::Builder_::AbstractState>#lsequence
                      0.00      0.00      0.00      0.00           3/3364     Stupidedi::Envelope::FunctionalGroupVal#initialize
                      0.00      0.00      0.00      0.00           2/3364     Stupidedi::Values::SegmentValGroup#defined_at?
                      0.00      0.00      0.00      0.00           1/3364     Stupidedi::Builder_::ConstraintTable::ValueBased#select
                      0.00      0.00      0.00      0.00         133/3364     Stupidedi::Values::LoopVal#initialize
                      0.00      0.00      0.00      0.00         343/3364     Stupidedi::Values::SegmentVal#initialize
                      0.00      0.00      0.00      0.00         130/3364     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal>#value
                      0.00      0.00      0.00      0.00           9/3364     Stupidedi::Values::TableVal#initialize
                      0.00      0.00      0.00      0.00         198/3364     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
                      0.00      0.00      0.00      0.00          24/3364     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal::NonEmpty#initialize
   0.00%   0.00%      0.00      0.00      0.00      0.00             3364     Kernel#nil?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             4/62     Stupidedi::Schema::SegmentDef#value
                      0.00      0.00      0.00      0.00             1/62     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TM#companion
                      0.00      0.00      0.00      0.00             2/62     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DT#companion
                      0.00      0.00      0.00      0.00             4/62     Stupidedi::Schema::CompositeElementDef#empty
                      0.00      0.00      0.00      0.00             3/62     Stupidedi::Schema::TableDef#value
                      0.00      0.00      0.00      0.00             1/62     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::Nn#companion
                      0.00      0.00      0.00      0.00             4/62     Stupidedi::Reader::StreamReader#result
                      0.00      0.00      0.00      0.00             3/62     Stupidedi::Schema::LoopDef#value
                      0.00      0.00      0.00      0.00             3/62     Array#each
                      0.00      0.00      0.00      0.00             6/62     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00             3/62     <Class::Stupidedi::Builder_::TransactionSetState>#push
                      0.00      0.00      0.00      0.00             3/62     #<Class:0xb77871b8>#value
                      0.00      0.00      0.00      0.00             3/62     Stupidedi::Reader::TokenReader#simple
                      0.00      0.00      0.00      0.00             3/62     Stupidedi::Reader::TokenReader#composite
                      0.00      0.00      0.00      0.00             1/62     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::R#companion
                      0.00      0.00      0.00      0.00             3/62     <Class::Stupidedi::Builder_::FunctionalGroupState>#instructions
                      0.00      0.00      0.00      0.00             3/62     #<Class:0xb761e7a4>#value
                      0.00      0.00      0.00      0.00             3/62     Stupidedi::Reader::TokenReader#component
                      0.00      0.00      0.00      0.00             1/62     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::AN#companion
                      0.00      0.00      0.00      0.00             1/62     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::ID#companion
                      0.00      0.00      0.00      0.00             4/62     <Class::Stupidedi::Builder_::InterchangeState>#instructions
                      0.00      0.00      0.00      0.00             3/62     Stupidedi::Envelope::TransactionSetDef#empty
   0.00%   0.00%      0.00      0.00      0.00      0.00               62     Module#attr_reader
                      0.00      0.00      0.00      0.00           68/377     <Class::Object>#method_added
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/3     Hash#each
                      0.00      0.00      0.00      0.00              1/3     Stupidedi::Reader::StreamReader#result
                      0.00      0.00      0.00      0.00              1/3     Stupidedi::Either::Success#flatmap
   0.00%   0.00%      0.00      0.00      0.00      0.00                3     Module#private
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          25/1284     Stupidedi::Values::CompositeElementVal#initialize
                      0.00      0.00      0.00      0.00         245/1284     Array#map
                      0.00      0.00      0.00      0.00         929/1284     Array#each
                      0.00      0.00      0.00      0.00           1/1284     Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeVal#initialize
                      0.00      0.00      0.00      0.00          16/1284     Stupidedi::Builder_::ConstraintTable::ValueBased#select
                      0.00      0.00      0.00      0.00          56/1284     Stupidedi::Values::SegmentVal#initialize
                      0.00      0.00      0.00      0.00          12/1284     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal::NonEmpty#initialize
   0.00%   0.00%      0.00      0.00      0.00      0.00             1284     NilClass#nil?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00        1798/1798     <Module::Stupidedi::Reader>#is_control_character?
   0.00%   0.00%      0.00      0.00      0.00      0.00             1798     String#=~
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            20/85     Array#each
                      0.00      0.00      0.00      0.00            65/85     Stupidedi::Builder_::AbstractState#segment_dict
   0.00%   0.00%      0.00      0.00      0.00      0.00               85     Stupidedi::Builder_::AbstractState#segment_dict
                      0.00      0.00      0.00      0.00            65/85     Stupidedi::Builder_::AbstractState#segment_dict
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           23/108     Array#each
                      0.00      0.00      0.00      0.00           85/108     Stupidedi::Builder_::AbstractState#separators
   0.00%   0.00%      0.00      0.00      0.00      0.00              108     Stupidedi::Builder_::AbstractState#separators
                      0.00      0.00      0.00      0.00           85/108     Stupidedi::Builder_::AbstractState#separators
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            39/39     Stupidedi::Builder_::InstructionTable::NonEmpty#successors
   0.00%   0.00%      0.00      0.00      0.00      0.00               39     Stupidedi::Builder_::ConstraintTable::Stub#matches
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Builder_::FunctionalGroupState#add
                      0.00      0.00      0.00      0.00             1/34     Stupidedi::Builder_::AbstractState#segment
                      0.00      0.00      0.00      0.00              1/2     Stupidedi::Envelope::FunctionalGroupVal#append
                      0.00      0.00      0.00      0.00              1/3     Stupidedi::Builder_::FunctionalGroupState#copy
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              2/2     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00                2     Stupidedi::Builder_::FunctionalGroupState#drop
                      0.00      0.00      0.00      0.00            1/357     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
                      0.00      0.00      0.00      0.00           2/3130     Fixnum#zero?
                      0.00      0.00      0.00      0.00              1/3     Stupidedi::Builder_::FunctionalGroupState#copy
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/3     Stupidedi::Builder_::TransactionSetState#pop
                      0.00      0.00      0.00      0.00              2/3     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00                3     Stupidedi::Builder_::FunctionalGroupState#pop
                      0.00      0.00      0.00      0.00           1/6012     Fixnum#-
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Builder_::InterchangeState#merge
                      0.00      0.00      0.00      0.00           3/3130     Fixnum#zero?
                      0.00      0.00      0.00      0.00              1/2     Stupidedi::Builder_::InterchangeState#pop
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Builder_::InterchangeState#add
                      0.00      0.00      0.00      0.00              1/4     Stupidedi::Builder_::InterchangeState#copy
                      0.00      0.00      0.00      0.00             1/34     Stupidedi::Builder_::AbstractState#segment
                      0.00      0.00      0.00      0.00              1/2     Stupidedi::Envelope::InterchangeVal#append
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              2/2     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00                2     Stupidedi::Builder_::InterchangeState#drop
                      0.00      0.00      0.00      0.00              2/4     Stupidedi::Builder_::InterchangeState#copy
                      0.00      0.00      0.00      0.00            2/357     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
                      0.00      0.00      0.00      0.00           2/3130     Fixnum#zero?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/2     Stupidedi::Builder_::FunctionalGroupState#pop
                      0.00      0.00      0.00      0.00              1/2     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00                2     Stupidedi::Builder_::InterchangeState#pop
                      0.00      0.00      0.00      0.00           2/3130     Fixnum#zero?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              3/3     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00                3     Stupidedi::Builder_::TableState#drop
                      0.00      0.00      0.00      0.00            1/357     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
                      0.00      0.00      0.00      0.00              1/6     Stupidedi::Builder_::TableState#copy
                      0.00      0.00      0.00      0.00           3/3130     Fixnum#zero?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/7     Stupidedi::Builder_::LoopState#pop
                      0.00      0.00      0.00      0.00              3/7     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00                7     Stupidedi::Builder_::TableState#pop
                      0.00      0.00      0.00      0.00           4/6012     Fixnum#-
                      0.00      0.00      0.00      0.00           7/3130     Fixnum#zero?
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Builder_::TransactionSetState#pop
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Builder_::TransactionSetState#merge
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              3/3     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00                3     Stupidedi::Builder_::TransactionSetState#drop
                      0.00      0.00      0.00      0.00            1/357     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
                      0.00      0.00      0.00      0.00              1/5     Stupidedi::Builder_::TransactionSetState#copy
                      0.00      0.00      0.00      0.00           3/3130     Fixnum#zero?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Builder_::TransmissionState#drop
                      0.00      0.00      0.00      0.00           1/3130     Fixnum#zero?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Builder_::TransmissionState#pop
                      0.00      0.00      0.00      0.00           1/3130     Fixnum#zero?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              2/2     Stupidedi::Reader::StreamReader#read_character
   0.00%   0.00%      0.00      0.00      0.00      0.00                2     Stupidedi::Reader::FileInput#empty?
                      0.00      0.00      0.00      0.00              2/2     IO#eof?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            54/54     Stupidedi::Reader::SegmentDict::NonEmpty#at
   0.00%   0.00%      0.00      0.00      0.00      0.00               54     Stupidedi::Reader::SegmentDict::Constants#at
                      0.00      0.00      0.00      0.00            54/54     Module#const_get
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              3/3     Stupidedi::Reader::StreamReader#advance
   0.00%   0.00%      0.00      0.00      0.00      0.00                3     Stupidedi::Reader::StreamReader#copy
                      0.00      0.00      0.00      0.00          3/41773     Hash#fetch
                      0.00      0.00      0.00      0.00          3/15961     Class#new
                      0.00      0.00      0.00      0.00          3/12203     Kernel#class
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/3     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00              2/3     Stupidedi::Reader::StreamReader#read_character
   0.00%   0.00%      0.00      0.00      0.00      0.00                3     Stupidedi::Reader::StreamReader#result
                      0.00      0.00      0.00      0.00            3/778     <Class::Stupidedi::Either>#success
                      0.00      0.00      0.00      0.00             3/48     Class#inherited
                      0.00      0.00      0.00      0.00             4/62     Module#attr_reader
                      0.00      0.00      0.00      0.00           10/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00          3/15961     Class#new
                      0.00      0.00      0.00      0.00              1/3     Module#private
                      0.00      0.00      0.00      0.00              1/7     Module#include
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            3/696     Array#each
                      0.00      0.00      0.00      0.00          693/696     Stupidedi::Reader::TokenReader#advance
   0.00%   0.00%      0.00      0.00      0.00      0.00              696     Stupidedi::Reader::TokenReader#copy
                      0.00      0.00      0.00      0.00       2088/41773     Hash#fetch
                      0.00      0.00      0.00      0.00        696/15961     Class#new
                      0.00      0.00      0.00      0.00        696/12203     Kernel#class
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     <Class::Stupidedi::Builder_::InterchangeState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     #<Class:0xb746a458>#push
                      0.00      0.00      0.00      0.00           1/2313     Kernel#is_a?
                      0.00      0.00      0.00      0.00          2/15961     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     <Class::Stupidedi::Builder_::FunctionalGroupState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     #<Class:0xb77871b8>#value
                      0.00      0.00      0.00      0.00             1/48     Class#inherited
                      0.00      0.00      0.00      0.00             3/62     Module#attr_reader
                      0.00      0.00      0.00      0.00            1/397     Object#cons
                      0.00      0.00      0.00      0.00           10/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00          1/15961     Class#new
                      0.00      0.00      0.00      0.00              1/7     Module#include
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          587/587     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00              587     <Class::Hash>#allocate
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     <Class::Stupidedi::Builder_::FunctionalGroupState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     <Class::Stupidedi::Builder_::FunctionalGroupState>#instructions
                      0.00      0.00      0.00      0.00            1/286     Array#concat
                      0.00      0.00      0.00      0.00           1/1944     Hash#[]=
                      0.00      0.00      0.00      0.00            1/216     Array#tail
                      0.00      0.00      0.00      0.00           1/2089     Hash#[]
                      0.00      0.00      0.00      0.00             1/48     Class#inherited
                      0.00      0.00      0.00      0.00             3/62     Module#attr_reader
                      0.00      0.00      0.00      0.00             2/53     Kernel#singleton_method_added
                      0.00      0.00      0.00      0.00             2/48     <Class::Stupidedi::Builder_::AbstractState>#sequence
                      0.00      0.00      0.00      0.00            7/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00          2/15961     Class#new
                      0.00      0.00      0.00      0.00           1/1885     Array#<<
                      0.00      0.00      0.00      0.00           2/2203     Array#length
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     <Class::Stupidedi::Builder_::InterchangeState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     <Class::Stupidedi::Builder_::InterchangeState>#instructions
                      0.00      0.00      0.00      0.00            1/286     Array#concat
                      0.00      0.00      0.00      0.00           1/1944     Hash#[]=
                      0.00      0.00      0.00      0.00            1/709     Array#head
                      0.00      0.00      0.00      0.00            1/216     Array#tail
                      0.00      0.00      0.00      0.00           1/2089     Hash#[]
                      0.00      0.00      0.00      0.00             1/48     Class#inherited
                      0.00      0.00      0.00      0.00             4/62     Module#attr_reader
                      0.00      0.00      0.00      0.00             2/53     Kernel#singleton_method_added
                      0.00      0.00      0.00      0.00             2/48     <Class::Stupidedi::Builder_::AbstractState>#sequence
                      0.00      0.00      0.00      0.00             1/95     Stupidedi::Schema::SegmentUse#repeatable?
                      0.00      0.00      0.00      0.00            7/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00          2/15961     Class#new
                      0.00      0.00      0.00      0.00           1/1885     Array#<<
                      0.00      0.00      0.00      0.00           2/2203     Array#length
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            18/18     <Class::Stupidedi::Builder_::LoopState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00               18     <Class::Stupidedi::Builder_::LoopState>#instructions
                      0.00      0.00      0.00      0.00           36/286     Array#concat
                      0.00      0.00      0.00      0.00           18/709     Array#head
                      0.00      0.00      0.00      0.00           18/216     Array#tail
                      0.00      0.00      0.00      0.00            18/22     <Class::Stupidedi::Builder_::AbstractState>#lsequence
                      0.00      0.00      0.00      0.00            36/48     <Class::Stupidedi::Builder_::AbstractState>#sequence
                      0.00      0.00      0.00      0.00            18/95     Stupidedi::Schema::SegmentUse#repeatable?
                      0.00      0.00      0.00      0.00          36/2203     Array#length
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     <Class::Stupidedi::Builder_::TransactionSetState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     <Class::Stupidedi::Builder_::TransactionSetState>#instructions
                      0.00      0.00      0.00      0.00           1/1944     Hash#[]=
                      0.00      0.00      0.00      0.00            1/709     Array#head
                      0.00      0.00      0.00      0.00            1/216     Array#tail
                      0.00      0.00      0.00      0.00           1/2089     Hash#[]
                      0.00      0.00      0.00      0.00              1/1     <Class::Stupidedi::Builder_::AbstractState>#tsequence
                      0.00      0.00      0.00      0.00          1/15961     Class#new
                      0.00      0.00      0.00      0.00              1/5     Stupidedi::Schema::TableDef#repeatable?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              2/2     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                2     <Class::Stupidedi::Reader::SegmentDict>#empty
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         157/1482     Integer#times
                      0.00      0.00      0.00      0.00        1300/1482     Array#each
                      0.00      0.00      0.00      0.00           3/1482     Stupidedi::Values::SegmentVal#at
                      0.00      0.00      0.00      0.00           2/1482     <Class::Stupidedi::Builder_::TransactionSetState>#push
                      0.00      0.00      0.00      0.00           1/1482     <Class::Stupidedi::Builder_::FunctionalGroupState>#push
                      0.00      0.00      0.00      0.00          18/1482     Stupidedi::Builder_::ConstraintTable::ValueBased#select
                      0.00      0.00      0.00      0.00           1/1482     <Class::Stupidedi::Builder_::InterchangeState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00             1482     Array#at
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          138/138     Hash#defined_at?
   0.00%   0.00%      0.00      0.00      0.00      0.00              138     Hash#include?
                      0.00      0.00      0.00      0.00           79/734     Kernel#hash
                      0.00      0.00      0.00      0.00             1/52     Array#hash
                      0.00      0.00      0.00      0.00              1/2     Array#eql?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          587/587     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00              587     Hash#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              2/2     Stupidedi::Reader::FileInput#empty?
   0.00%   0.00%      0.00      0.00      0.00      0.00                2     IO#eof?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             2/20     Stupidedi::Values::SegmentValGroup#at
                      0.00      0.00      0.00      0.00             2/20     Stupidedi::Values::SegmentValGroup#defined_at?
                      0.00      0.00      0.00      0.00             6/20     <Class::Stupidedi::Builder_::TableState>#push
                      0.00      0.00      0.00      0.00            10/20     <Class::Date>#julian?
   0.00%   0.00%      0.00      0.00      0.00      0.00               20     Module#===
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            54/54     Stupidedi::Reader::SegmentDict::Constants#at
   0.00%   0.00%      0.00      0.00      0.00      0.00               54     Module#const_get
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          111/111     Stupidedi::Reader::SegmentDict::Constants#defined_at?
   0.00%   0.00%      0.00      0.00      0.00      0.00              111     Module#constants
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/7     Stupidedi::Schema::TableDef#value
                      0.00      0.00      0.00      0.00              1/7     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::Nn#companion
                      0.00      0.00      0.00      0.00              1/7     Stupidedi::Reader::StreamReader#result
                      0.00      0.00      0.00      0.00              1/7     Stupidedi::Schema::LoopDef#value
                      0.00      0.00      0.00      0.00              1/7     #<Class:0xb77871b8>#value
                      0.00      0.00      0.00      0.00              1/7     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::R#companion
                      0.00      0.00      0.00      0.00              1/7     #<Class:0xb761e7a4>#value
   0.00%   0.00%      0.00      0.00      0.00      0.00                7     Module#include
                      0.00      0.00      0.00      0.00              7/7     Module#append_features
                      0.00      0.00      0.00      0.00              7/7     Module#included
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            3/119     Stupidedi::Values::SegmentVal#defined_at?
                      0.00      0.00      0.00      0.00           95/119     Stupidedi::Schema::SegmentUse#repeatable?
                      0.00      0.00      0.00      0.00            6/119     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal>#value
                      0.00      0.00      0.00      0.00           14/119     Stupidedi::Schema::LoopDef#repeatable?
                      0.00      0.00      0.00      0.00            1/119     <Class::Stupidedi::Builder_::InterchangeState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00              119     Object#try
                      0.00      0.00      0.00      0.00             1/16     Kernel#__send__
                      0.00      0.00      0.00      0.00           83/325     Stupidedi::Schema::RepeatCount::Bounded#include?
                      0.00      0.00      0.00      0.00            22/22     Array#include?
                      0.00      0.00      0.00      0.00             6/64     String#blankness?
                      0.00      0.00      0.00      0.00             3/43     String#to_i
                      0.00      0.00      0.00      0.00              3/6     Array#defined_at?
                      0.00      0.00      0.00      0.00              4/4     #<Class:0xb75ff5d4>#include?
                      0.00      0.00      0.00      0.00         119/1253     Array#empty?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     OpenStruct#initialize
                      0.00      0.00      0.00      0.00            1/312     Hash#each
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             6/64     Object#try
                      0.00      0.00      0.00      0.00            20/64     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DecimalVal>#value
                      0.00      0.00      0.00      0.00            17/64     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal>#value
                      0.00      0.00      0.00      0.00             3/64     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal>#value
                      0.00      0.00      0.00      0.00             1/64     Stupidedi::Reader::ComponentElementTok#blankness?
                      0.00      0.00      0.00      0.00            16/64     Stupidedi::Reader::SimpleElementTok#blankness?
                      0.00      0.00      0.00      0.00             1/64     <Class::Stupidedi::Builder_::TransactionSetState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00               64     String#blankness?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             9/22     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal>#value
                      0.00      0.00      0.00      0.00            12/22     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal>#value
                      0.00      0.00      0.00      0.00             1/22     <Class::Stupidedi::Builder_::FunctionalGroupState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00               22     String#slice
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              2/6     Stupidedi::Builder_::AbstractState#config
                      0.00      0.00      0.00      0.00              2/6     <Class::Stupidedi::Builder_::TransactionSetState>#push
                      0.00      0.00      0.00      0.00              2/6     <Class::Stupidedi::Builder_::FunctionalGroupState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                6     Stupidedi::Builder_::AbstractState#config
                      0.00      0.00      0.00      0.00              2/6     Stupidedi::Builder_::AbstractState#config
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            17/17     Stupidedi::Builder_::ConstraintTable::ValueBased#matches
   0.00%   0.00%      0.00      0.00      0.00      0.00               17     Stupidedi::Builder_::ConstraintTable::ValueBased#deepest
                      0.00      0.00      0.00      0.00            17/17     Hash#values
                      0.00      0.00      0.00      0.00          17/1446     Array#each
                      0.00      0.00      0.00      0.00         17/15961     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/3     Stupidedi::Builder_::FunctionalGroupState#merge
                      0.00      0.00      0.00      0.00              1/3     Stupidedi::Builder_::FunctionalGroupState#add
                      0.00      0.00      0.00      0.00              1/3     Stupidedi::Builder_::FunctionalGroupState#drop
   0.00%   0.00%      0.00      0.00      0.00      0.00                3     Stupidedi::Builder_::FunctionalGroupState#copy
                      0.00      0.00      0.00      0.00         12/41773     Hash#fetch
                      0.00      0.00      0.00      0.00          3/15961     Class#new
                      0.00      0.00      0.00      0.00          3/12203     Kernel#class
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/4     Stupidedi::Builder_::InterchangeState#add
                      0.00      0.00      0.00      0.00              1/4     Stupidedi::Builder_::InterchangeState#merge
                      0.00      0.00      0.00      0.00              2/4     Stupidedi::Builder_::InterchangeState#drop
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Builder_::InterchangeState#copy
                      0.00      0.00      0.00      0.00         20/41773     Hash#fetch
                      0.00      0.00      0.00      0.00          4/15961     Class#new
                      0.00      0.00      0.00      0.00          4/12203     Kernel#class
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Builder_::FunctionalGroupState#pop
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Builder_::InterchangeState#merge
                      0.00      0.00      0.00      0.00              1/4     Stupidedi::Builder_::InterchangeState#copy
                      0.00      0.00      0.00      0.00              1/2     Stupidedi::Envelope::InterchangeVal#append
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            14/79     Stupidedi::Builder_::LoopState#merge
                      0.00      0.00      0.00      0.00            31/79     Stupidedi::Builder_::LoopState#add
                      0.00      0.00      0.00      0.00            34/79     Stupidedi::Builder_::LoopState#drop
   0.00%   0.00%      0.00      0.00      0.00      0.00               79     Stupidedi::Builder_::LoopState#copy
                      0.00      0.00      0.00      0.00        237/41773     Hash#fetch
                      0.00      0.00      0.00      0.00         79/15961     Class#new
                      0.00      0.00      0.00      0.00         79/12203     Kernel#class
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/6     Stupidedi::Builder_::TableState#merge
                      0.00      0.00      0.00      0.00              1/6     Stupidedi::Builder_::TableState#drop
                      0.00      0.00      0.00      0.00              1/6     Stupidedi::Builder_::TableState#add
   0.00%   0.00%      0.00      0.00      0.00      0.00                6     Stupidedi::Builder_::TableState#copy
                      0.00      0.00      0.00      0.00         18/41773     Hash#fetch
                      0.00      0.00      0.00      0.00          6/15961     Class#new
                      0.00      0.00      0.00      0.00          6/12203     Kernel#class
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Builder_::LoopState#pop
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Builder_::TableState#merge
                      0.00      0.00      0.00      0.00              4/5     Stupidedi::Values::TableVal#append
                      0.00      0.00      0.00      0.00              4/6     Stupidedi::Builder_::TableState#copy
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/5     Stupidedi::Builder_::TransactionSetState#merge
                      0.00      0.00      0.00      0.00              1/5     Stupidedi::Builder_::TransactionSetState#drop
   0.00%   0.00%      0.00      0.00      0.00      0.00                5     Stupidedi::Builder_::TransactionSetState#copy
                      0.00      0.00      0.00      0.00         15/41773     Hash#fetch
                      0.00      0.00      0.00      0.00          5/15961     Class#new
                      0.00      0.00      0.00      0.00          5/12203     Kernel#class
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Builder_::TableState#pop
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Builder_::TransactionSetState#merge
                      0.00      0.00      0.00      0.00              4/5     Stupidedi::Builder_::TransactionSetState#copy
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Envelope::TransactionSetVal#append
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Builder_::TableState#pop
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Builder_::TransactionSetState#pop
                      0.00      0.00      0.00      0.00           1/6012     Fixnum#-
                      0.00      0.00      0.00      0.00           4/3130     Fixnum#zero?
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Builder_::FunctionalGroupState#merge
                      0.00      0.00      0.00      0.00              1/3     Stupidedi::Builder_::FunctionalGroupState#pop
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     <Class::Stupidedi::Builder_::FunctionalGroupState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Configuration::FunctionalGroupConfig#at
                      0.00      0.00      0.00      0.00           1/2089     Hash#[]
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     <Class::Stupidedi::Builder_::FunctionalGroupState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Configuration::FunctionalGroupConfig#defined_at?
                      0.00      0.00      0.00      0.00            1/138     Hash#defined_at?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     <Class::Stupidedi::Builder_::InterchangeState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Configuration::InterchangeConfig#at
                      0.00      0.00      0.00      0.00           1/2089     Hash#[]
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     <Class::Stupidedi::Builder_::InterchangeState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Configuration::InterchangeConfig#defined_at?
                      0.00      0.00      0.00      0.00            1/138     Hash#defined_at?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     <Class::Stupidedi::Builder_::TransactionSetState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Configuration::TransactionSetConfig#at
                      0.00      0.00      0.00      0.00           1/2089     Hash#[]
                      0.00      0.00      0.00      0.00              1/1     <Class::Array>#[]
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     <Class::Stupidedi::Builder_::TransactionSetState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Configuration::TransactionSetConfig#defined_at?
                      0.00      0.00      0.00      0.00            1/138     Hash#defined_at?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     <Class::Stupidedi::Builder_::TransactionSetState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal::NonEmpty#to_s
                      0.00      0.00      0.00      0.00           1/3543     String#to_s
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     <Class::Stupidedi::Builder_::InterchangeState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeVal#segment_dict
                      0.00      0.00      0.00      0.00              1/1     #<Class:0xb761e7a4>#segment_dict
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     <Class::Stupidedi::Builder_::FunctionalGroupState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Envelope::FunctionalGroupDef#entry_segment_use
                      0.00      0.00      0.00      0.00            1/709     Array#head
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/2     Stupidedi::Builder_::FunctionalGroupState#merge
                      0.00      0.00      0.00      0.00              1/2     Stupidedi::Builder_::FunctionalGroupState#add
   0.00%   0.00%      0.00      0.00      0.00      0.00                2     Stupidedi::Envelope::FunctionalGroupVal#append
                      0.00      0.00      0.00      0.00           3/2313     Kernel#is_a?
                      0.00      0.00      0.00      0.00              2/2     Stupidedi::Envelope::FunctionalGroupVal#copy
                      0.00      0.00      0.00      0.00             2/58     Object#snoc
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     <Class::Stupidedi::Builder_::FunctionalGroupState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Envelope::FunctionalGroupVal#segment_dict
                      0.00      0.00      0.00      0.00              1/1     #<Class:0xb77871b8>#segment_dict
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     <Class::Stupidedi::Builder_::InterchangeState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Envelope::InterchangeDef#entry_segment_use
                      0.00      0.00      0.00      0.00            1/709     Array#head
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/2     Stupidedi::Builder_::InterchangeState#add
                      0.00      0.00      0.00      0.00              1/2     Stupidedi::Builder_::InterchangeState#merge
   0.00%   0.00%      0.00      0.00      0.00      0.00                2     Stupidedi::Envelope::InterchangeVal#append
                      0.00      0.00      0.00      0.00              2/2     Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeVal#copy
                      0.00      0.00      0.00      0.00           3/2313     Kernel#is_a?
                      0.00      0.00      0.00      0.00             2/58     Object#snoc
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     <Class::Stupidedi::Builder_::TransactionSetState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Envelope::TransactionSetDef#empty
                      0.00      0.00      0.00      0.00             1/48     Class#inherited
                      0.00      0.00      0.00      0.00             3/62     Module#attr_reader
                      0.00      0.00      0.00      0.00            6/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00          1/15961     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     <Class::Stupidedi::Builder_::TransactionSetState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Envelope::TransactionSetDef#entry_segment_use
                      0.00      0.00      0.00      0.00            2/709     Array#head
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Reader::Failure#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     <Class::Stupidedi::Builder_::FunctionalGroupState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Reader::SegmentDict::NonEmpty#push
                      0.00      0.00      0.00      0.00           1/2313     Kernel#is_a?
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Reader::SegmentDict::NonEmpty#copy
                      0.00      0.00      0.00      0.00          1/15961     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     <Class::Stupidedi::Builder_::InterchangeState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Reader::Separators#merge
                      0.00      0.00      0.00      0.00            2/274     OpenStruct#method_missing
                      0.00      0.00      0.00      0.00            1/116     Unknown#element
                      0.00      0.00      0.00      0.00              1/3     Stupidedi::Reader::Separators#copy
                      0.00      0.00      0.00      0.00              1/1     Unknown#segment
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00        1024/1024     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00             1024     Stupidedi::Reader::Success#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          698/698     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00              698     Stupidedi::Reader::TokenReader#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Either::Success#flatmap
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Reader::TokenReader#read_character
                      0.00      0.00      0.00      0.00           1/1855     Stupidedi::Reader::FileInput#at
                      0.00      0.00      0.00      0.00            1/757     Stupidedi::Reader::TokenReader#result
                      0.00      0.00      0.00      0.00           1/2550     Stupidedi::Reader::FileInput#defined_at?
                      0.00      0.00      0.00      0.00            1/693     Stupidedi::Reader::TokenReader#advance
                      0.00      0.00      0.00      0.00          1/13457     Fixnum#+
                      0.00      0.00      0.00      0.00           1/1795     Stupidedi::Reader::TokenReader#is_control?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          144/386     Integer#times
                      0.00      0.00      0.00      0.00          242/386     Stupidedi::Reader::TokenReader#read_elements
   0.00%   0.00%      0.00      0.00      0.00      0.00              386     Stupidedi::Schema::ElementUse#composite?
                      0.00      0.00      0.00      0.00          361/615     Stupidedi::Schema::SimpleElementUse#simple?
                      0.00      0.00      0.00      0.00            25/37     Stupidedi::Schema::CompositeElementUse#simple?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            18/18     <Class::Stupidedi::Builder_::LoopState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00               18     Stupidedi::Schema::LoopDef#value
                      0.00      0.00      0.00      0.00             1/48     Class#inherited
                      0.00      0.00      0.00      0.00             3/62     Module#attr_reader
                      0.00      0.00      0.00      0.00           18/397     Object#cons
                      0.00      0.00      0.00      0.00            9/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00         18/15961     Class#new
                      0.00      0.00      0.00      0.00              1/7     Module#include
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          242/325     Stupidedi::Reader::TokenReader#read_elements
                      0.00      0.00      0.00      0.00           83/325     Object#try
   0.00%   0.00%      0.00      0.00      0.00      0.00              325     Stupidedi::Schema::RepeatCount::Bounded#include?
                      0.00      0.00      0.00      0.00          325/335     Fixnum#<=
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              2/2     <Class::Stupidedi::Builder_::TableState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                2     Stupidedi::Schema::TableDef#empty
                      0.00      0.00      0.00      0.00          2/15961     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              2/2     <Class::Stupidedi::Builder_::TableState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                2     Stupidedi::Schema::TableDef#value
                      0.00      0.00      0.00      0.00             1/48     Class#inherited
                      0.00      0.00      0.00      0.00             3/62     Module#attr_reader
                      0.00      0.00      0.00      0.00            2/397     Object#cons
                      0.00      0.00      0.00      0.00            9/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00          2/15961     Class#new
                      0.00      0.00      0.00      0.00              1/7     Module#include
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              2/3     Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeVal#initialize
                      0.00      0.00      0.00      0.00              1/3     <Class::Stupidedi::Builder_::TransactionSetState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                3     Stupidedi::Values::SegmentVal#at
                      0.00      0.00      0.00      0.00              3/6     Array#defined_at?
                      0.00      0.00      0.00      0.00           3/1482     Array#at
                      0.00      0.00      0.00      0.00           3/3364     Kernel#nil?
                      0.00      0.00      0.00      0.00              3/3     Stupidedi::Values::SegmentVal#defined_at?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/2     Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeVal#initialize
                      0.00      0.00      0.00      0.00              1/2     <Class::Stupidedi::Builder_::TransactionSetState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                2     Stupidedi::Values::SegmentValGroup#at
                      0.00      0.00      0.00      0.00              2/4     Array#select
                      0.00      0.00      0.00      0.00             2/20     Module#===
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Envelope::FunctionalGroupVal#segment_vals
                      0.00      0.00      0.00      0.00              2/2     Stupidedi::Values::SegmentValGroup#defined_at?
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Envelope::InterchangeVal#segment_vals
                      0.00      0.00      0.00      0.00           2/3364     Kernel#nil?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/5     Stupidedi::Builder_::TableState#merge
                      0.00      0.00      0.00      0.00              1/5     Stupidedi::Builder_::TableState#add
   0.00%   0.00%      0.00      0.00      0.00      0.00                5     Stupidedi::Values::TableVal#append
                      0.00      0.00      0.00      0.00              5/5     Stupidedi::Values::TableVal#copy
                      0.00      0.00      0.00      0.00             5/58     Object#snoc
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            15/15     Integer#times
   0.00%   0.00%      0.00      0.00      0.00      0.00               15     Symbol#to_proc
                      0.00      0.00      0.00      0.00            15/15     Kernel#lambda
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeVal#segment_dict
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     #<Class:0xb761e7a4>#segment_dict
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Envelope::FunctionalGroupVal#segment_dict
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     #<Class:0xb77871b8>#segment_dict
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Configuration::TransactionSetConfig#at
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     <Class::Array>#[]
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            36/48     <Class::Stupidedi::Builder_::LoopState>#instructions
                      0.00      0.00      0.00      0.00             8/48     <Class::Stupidedi::Builder_::TableState>#instructions
                      0.00      0.00      0.00      0.00             2/48     <Class::Stupidedi::Builder_::FunctionalGroupState>#instructions
                      0.00      0.00      0.00      0.00             2/48     <Class::Stupidedi::Builder_::InterchangeState>#instructions
   0.00%   0.00%      0.00      0.00      0.00      0.00               48     <Class::Stupidedi::Builder_::AbstractState>#sequence
                      0.00      0.00      0.00      0.00           5/6012     Fixnum#-
                      0.00      0.00      0.00      0.00            20/95     Stupidedi::Schema::SegmentUse#repeatable?
                      0.00      0.00      0.00      0.00          70/1446     Array#each
                      0.00      0.00      0.00      0.00          22/1331     Fixnum#==
                      0.00      0.00      0.00      0.00          27/2203     Array#length
                      0.00      0.00      0.00      0.00          48/1253     Array#empty?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     <Class::Stupidedi::Builder_::TransactionSetState>#instructions
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     <Class::Stupidedi::Builder_::AbstractState>#tsequence
                      0.00      0.00      0.00      0.00           2/1446     Array#each
                      0.00      0.00      0.00      0.00           1/1331     Fixnum#==
                      0.00      0.00      0.00      0.00              1/5     Stupidedi::Schema::TableDef#repeatable?
                      0.00      0.00      0.00      0.00           1/2203     Array#length
                      0.00      0.00      0.00      0.00           1/1253     Array#empty?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           58/482     Object#snoc
                      0.00      0.00      0.00      0.00            1/482     Stupidedi::Envelope::FunctionalGroupDef#segment_uses
                      0.00      0.00      0.00      0.00           25/482     Stupidedi::Builder_::InstructionTable::NonEmpty#push
                      0.00      0.00      0.00      0.00          397/482     Object#cons
                      0.00      0.00      0.00      0.00            1/482     Stupidedi::Envelope::InterchangeDef#segment_uses
   0.00%   0.00%      0.00      0.00      0.00      0.00              482     Array#+
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           36/286     <Class::Stupidedi::Builder_::LoopState>#instructions
                      0.00      0.00      0.00      0.00            8/286     <Class::Stupidedi::Builder_::TableState>#instructions
                      0.00      0.00      0.00      0.00           42/286     Stupidedi::Schema::TableDef#entry_segment_uses
                      0.00      0.00      0.00      0.00            1/286     <Class::Stupidedi::Builder_::FunctionalGroupState>#instructions
                      0.00      0.00      0.00      0.00            1/286     <Class::Stupidedi::Builder_::InterchangeState>#instructions
                      0.00      0.00      0.00      0.00          198/286     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
   0.00%   0.00%      0.00      0.00      0.00      0.00              286     Array#concat
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              3/6     Object#try
                      0.00      0.00      0.00      0.00              3/6     Stupidedi::Values::SegmentVal#at
   0.00%   0.00%      0.00      0.00      0.00      0.00                6     Array#defined_at?
                      0.00      0.00      0.00      0.00           6/3389     Fixnum#<
                      0.00      0.00      0.00      0.00           6/2203     Array#length
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          13/2203     Integer#times
                      0.00      0.00      0.00      0.00          36/2203     <Class::Stupidedi::Builder_::LoopState>#instructions
                      0.00      0.00      0.00      0.00         198/2203     Stupidedi::Builder_::InstructionTable::NonEmpty#length
                      0.00      0.00      0.00      0.00          27/2203     <Class::Stupidedi::Builder_::AbstractState>#sequence
                      0.00      0.00      0.00      0.00         148/2203     Array#each
                      0.00      0.00      0.00      0.00           8/2203     <Class::Stupidedi::Builder_::TableState>#instructions
                      0.00      0.00      0.00      0.00          25/2203     Stupidedi::Builder_::InstructionTable::NonEmpty#push
                      0.00      0.00      0.00      0.00          42/2203     <Class::Stupidedi::Builder_::AbstractState>#lsequence
                      0.00      0.00      0.00      0.00           6/2203     Array#defined_at?
                      0.00      0.00      0.00      0.00          17/2203     Stupidedi::Builder_::ConstraintTable::ValueBased#basis
                      0.00      0.00      0.00      0.00           1/2203     <Class::Stupidedi::Builder_::AbstractState>#tsequence
                      0.00      0.00      0.00      0.00           2/2203     <Class::Stupidedi::Builder_::FunctionalGroupState>#instructions
                      0.00      0.00      0.00      0.00         849/2203     <Class::Stupidedi::Builder_::ConstraintTable>#build
                      0.00      0.00      0.00      0.00           2/2203     <Class::Stupidedi::Builder_::InterchangeState>#instructions
                      0.00      0.00      0.00      0.00         274/2203     OpenStruct#method_missing
                      0.00      0.00      0.00      0.00         555/2203     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
   0.00%   0.00%      0.00      0.00      0.00      0.00             2203     Array#length
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              2/4     Stupidedi::Values::SegmentValGroup#at
                      0.00      0.00      0.00      0.00              1/4     Stupidedi::Envelope::InterchangeVal#segment_vals
                      0.00      0.00      0.00      0.00              1/4     Stupidedi::Envelope::FunctionalGroupVal#segment_vals
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Array#select
                      0.00      0.00      0.00      0.00           2/2313     Kernel#is_a?
                      0.00      0.00      0.00      0.00              2/6     Symbol#to_sym
                      0.00      0.00      0.00      0.00            2/274     Kernel#==
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          198/198     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
   0.00%   0.00%      0.00      0.00      0.00      0.00              198     Array#split_at
                      0.00      0.00      0.00      0.00          198/198     Array#take
                      0.00      0.00      0.00      0.00          198/396     Array#drop
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           18/216     <Class::Stupidedi::Builder_::LoopState>#instructions
                      0.00      0.00      0.00      0.00          195/216     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00            1/216     <Class::Stupidedi::Builder_::FunctionalGroupState>#instructions
                      0.00      0.00      0.00      0.00            1/216     <Class::Stupidedi::Builder_::TransactionSetState>#instructions
                      0.00      0.00      0.00      0.00            1/216     <Class::Stupidedi::Builder_::InterchangeState>#instructions
   0.00%   0.00%      0.00      0.00      0.00      0.00              216     Array#tail
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          161/161     <Class::Stupidedi::Builder_::ConstraintTable>#build
   0.00%   0.00%      0.00      0.00      0.00      0.00              161     Array#uniq
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            12/68     <Class::Stupidedi::Builder_::AbstractState>#composite_element
                      0.00      0.00      0.00      0.00            56/68     <Class::Stupidedi::Builder_::AbstractState>#segment
   0.00%   0.00%      0.00      0.00      0.00      0.00               68     Array#zip
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            5/335     <Class::Date>#jd_to_civil
                      0.00      0.00      0.00      0.00          325/335     Stupidedi::Schema::RepeatCount::Bounded#include?
                      0.00      0.00      0.00      0.00            5/335     <Class::Date>#civil_to_jd
   0.00%   0.00%      0.00      0.00      0.00      0.00              335     Fixnum#<=
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            17/17     Stupidedi::Builder_::ConstraintTable::ValueBased#deepest
   0.00%   0.00%      0.00      0.00      0.00      0.00               17     Hash#values
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             1/16     Object#try
                      0.00      0.00      0.00      0.00            15/16     Symbol#call
   0.00%   0.00%      0.00      0.00      0.00      0.00               16     Kernel#__send__
                      0.00      0.00      0.00      0.00           15/253     Stupidedi::Reader::TokenReader#read_simple_element
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            15/15     Symbol#to_proc
   0.00%   0.00%      0.00      0.00      0.00      0.00               15     Kernel#lambda
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              7/7     Module#include
   0.00%   0.00%      0.00      0.00      0.00      0.00                7     Module#append_features
                      0.00      0.00      0.00      0.00            7/384     Module#==
                      0.00      0.00      0.00      0.00              7/7     Module#blankslate_original_append_features
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              7/7     Module#include
   0.00%   0.00%      0.00      0.00      0.00      0.00                7     Module#included
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              2/5     Module#class_eval
                      0.00      0.00      0.00      0.00              3/5     #<Class:0xb761e7a4>#value
   0.00%   0.00%      0.00      0.00      0.00      0.00                5     Module#method_added
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           99/397     Hash#each
                      0.00      0.00      0.00      0.00            2/397     Stupidedi::Schema::TableDef#value
                      0.00      0.00      0.00      0.00           18/397     Stupidedi::Schema::LoopDef#value
                      0.00      0.00      0.00      0.00           67/397     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00            1/397     #<Class:0xb77871b8>#value
                      0.00      0.00      0.00      0.00            1/397     #<Class:0xb761e7a4>#value
                      0.00      0.00      0.00      0.00          209/397     Stupidedi::Reader::Success#map
   0.00%   0.00%      0.00      0.00      0.00      0.00              397     Object#cons
                      0.00      0.00      0.00      0.00          397/482     Array#+
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             2/58     Stupidedi::Envelope::InterchangeVal#append
                      0.00      0.00      0.00      0.00             4/58     Stupidedi::Envelope::TransactionSetVal#append
                      0.00      0.00      0.00      0.00            45/58     Stupidedi::Values::LoopVal#append
                      0.00      0.00      0.00      0.00             5/58     Stupidedi::Values::TableVal#append
                      0.00      0.00      0.00      0.00             2/58     Stupidedi::Envelope::FunctionalGroupVal#append
   0.00%   0.00%      0.00      0.00      0.00      0.00               58     Object#snoc
                      0.00      0.00      0.00      0.00           58/482     Array#+
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          270/274     Stupidedi::Reader::TokenReader#read_simple_element
                      0.00      0.00      0.00      0.00            2/274     Stupidedi::Reader::Separators#merge
                      0.00      0.00      0.00      0.00            2/274     Stupidedi::Either::Success#flatmap
   0.00%   0.00%      0.00      0.00      0.00      0.00              274     OpenStruct#method_missing
                      0.00      0.00      0.00      0.00              1/1     Array#[]
                      0.00      0.00      0.00      0.00          274/274     Symbol#id2name
                      0.00      0.00      0.00      0.00           1/1944     Hash#[]=
                      0.00      0.00      0.00      0.00         273/2089     Hash#[]
                      0.00      0.00      0.00      0.00              1/1     String#intern
                      0.00      0.00      0.00      0.00              1/2     OpenStruct#new_ostruct_member
                      0.00      0.00      0.00      0.00              1/1     String#chop!
                      0.00      0.00      0.00      0.00         274/1331     Fixnum#==
                      0.00      0.00      0.00      0.00         274/2203     Array#length
                      0.00      0.00      0.00      0.00              1/1     Kernel#frozen?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           1/3543     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal::NonEmpty#to_s
                      0.00      0.00      0.00      0.00           9/3543     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal>#value
                      0.00      0.00      0.00      0.00        3266/3543     Array#each
                      0.00      0.00      0.00      0.00           2/3543     Stupidedi::Dictionaries::Interchanges::FiveOhOne::ElementDefs::SeparatorElementVal#to_s
                      0.00      0.00      0.00      0.00          33/3543     String#to_d
                      0.00      0.00      0.00      0.00          12/3543     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal>#value
                      0.00      0.00      0.00      0.00         115/3543     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal>#value
                      0.00      0.00      0.00      0.00         105/3543     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal>#value
   0.00%   0.00%      0.00      0.00      0.00      0.00             3543     String#to_s
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            17/17     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00               17     Stupidedi::Builder_::ConstraintTable::ValueBased#select
                      0.00      0.00      0.00      0.00          16/1284     NilClass#nil?
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Reader::ComponentElementTok#blankness?
                      0.00      0.00      0.00      0.00            16/16     Stupidedi::Reader::SimpleElementTok#blankness?
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Reader::CompositeElementTok#blankness?
                      0.00      0.00      0.00      0.00          18/1482     Array#at
                      0.00      0.00      0.00      0.00           1/3364     Kernel#nil?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Builder_::FunctionalGroupState#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Builder_::TransactionSetState#pop
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Builder_::FunctionalGroupState#merge
                      0.00      0.00      0.00      0.00              1/2     Stupidedi::Envelope::FunctionalGroupVal#append
                      0.00      0.00      0.00      0.00              1/3     Stupidedi::Builder_::FunctionalGroupState#copy
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           25/223     Stupidedi::Builder_::InstructionTable::NonEmpty#push
                      0.00      0.00      0.00      0.00          198/223     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
   0.00%   0.00%      0.00      0.00      0.00      0.00              223     Stupidedi::Builder_::InstructionTable::NonEmpty#copy
                      0.00      0.00      0.00      0.00        446/41773     Hash#fetch
                      0.00      0.00      0.00      0.00        223/15961     Class#new
                      0.00      0.00      0.00      0.00        223/12203     Kernel#class
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          198/198     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
   0.00%   0.00%      0.00      0.00      0.00      0.00              198     Stupidedi::Builder_::InstructionTable::NonEmpty#length
                      0.00      0.00      0.00      0.00         198/2203     Array#length
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              5/5     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                5     Stupidedi::Builder_::InterchangeState#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            97/97     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00               97     Stupidedi::Builder_::LoopState#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            10/10     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00               10     Stupidedi::Builder_::TableState#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              6/6     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                6     Stupidedi::Builder_::TransactionSetState#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              2/2     Stupidedi::Envelope::InterchangeVal#append
   0.00%   0.00%      0.00      0.00      0.00      0.00                2     Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeVal#copy
                      0.00      0.00      0.00      0.00          6/41773     Hash#fetch
                      0.00      0.00      0.00      0.00          2/15961     Class#new
                      0.00      0.00      0.00      0.00          2/12203     Kernel#class
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Either::Failure#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              2/2     Stupidedi::Envelope::FunctionalGroupVal#append
   0.00%   0.00%      0.00      0.00      0.00      0.00                2     Stupidedi::Envelope::FunctionalGroupVal#copy
                      0.00      0.00      0.00      0.00          6/41773     Hash#fetch
                      0.00      0.00      0.00      0.00          2/15961     Class#new
                      0.00      0.00      0.00      0.00          2/12203     Kernel#class
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Values::SegmentValGroup#at
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Envelope::FunctionalGroupVal#segment_vals
                      0.00      0.00      0.00      0.00              1/4     Array#select
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Builder_::TransactionSetState#merge
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Envelope::TransactionSetVal#append
                      0.00      0.00      0.00      0.00           4/2313     Kernel#is_a?
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Envelope::TransactionSetVal#copy
                      0.00      0.00      0.00      0.00             4/58     Object#snoc
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Reader::SegmentDict::NonEmpty#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Reader::SegmentDict::NonEmpty#copy
                      0.00      0.00      0.00      0.00          2/41773     Hash#fetch
                      0.00      0.00      0.00      0.00          1/15961     Class#new
                      0.00      0.00      0.00      0.00          1/12203     Kernel#class
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              2/3     Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeVal#initialize
                      0.00      0.00      0.00      0.00              1/3     Stupidedi::Reader::Separators#merge
   0.00%   0.00%      0.00      0.00      0.00      0.00                3     Stupidedi::Reader::Separators#copy
                      0.00      0.00      0.00      0.00         12/41773     Hash#fetch
                      0.00      0.00      0.00      0.00          3/15961     Class#new
                      0.00      0.00      0.00      0.00          3/12203     Kernel#class
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Reader::StreamReader#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            15/15     Stupidedi::Either::Success#flatmap
   0.00%   0.00%      0.00      0.00      0.00      0.00               15     Stupidedi::Reader::TokenReader#consume_prefix
                      0.00      0.00      0.00      0.00          15/1855     Stupidedi::Reader::FileInput#at
                      0.00      0.00      0.00      0.00          30/2126     String#length
                      0.00      0.00      0.00      0.00          15/1063     String#<<
                      0.00      0.00      0.00      0.00          15/2550     Stupidedi::Reader::FileInput#defined_at?
                      0.00      0.00      0.00      0.00           15/693     Stupidedi::Reader::TokenReader#advance
                      0.00      0.00      0.00      0.00            15/15     Stupidedi::Reader::TokenReader#success
                      0.00      0.00      0.00      0.00         15/10063     String#==
                      0.00      0.00      0.00      0.00         15/13457     Fixnum#+
                      0.00      0.00      0.00      0.00          15/1331     Fixnum#==
                      0.00      0.00      0.00      0.00           15/253     String#empty?
                      0.00      0.00      0.00      0.00          15/1795     Stupidedi::Reader::TokenReader#is_control?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            12/26     Stupidedi::Reader::TokenReader#read_composite_element
                      0.00      0.00      0.00      0.00            14/26     Stupidedi::Either::Success#flatmap
   0.00%   0.00%      0.00      0.00      0.00      0.00               26     Stupidedi::Reader::TokenReader#read_component_elements
                      0.00      0.00      0.00      0.00            26/26     Stupidedi::Reader::TokenReader#read_component_element
                      0.00      0.00      0.00      0.00           26/778     Stupidedi::Either::Success#flatmap
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            55/55     Stupidedi::Reader::Success#map
   0.00%   0.00%      0.00      0.00      0.00      0.00               55     Stupidedi::Reader::TokenReader#segment
                      0.00      0.00      0.00      0.00            55/55     <Class::Stupidedi::Reader::SegmentTok>#build
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          253/253     Stupidedi::Reader::TokenReader#read_simple_element
   0.00%   0.00%      0.00      0.00      0.00      0.00              253     Stupidedi::Reader::TokenReader#simple
                      0.00      0.00      0.00      0.00             1/48     Class#inherited
                      0.00      0.00      0.00      0.00             3/62     Module#attr_reader
                      0.00      0.00      0.00      0.00             1/53     Kernel#singleton_method_added
                      0.00      0.00      0.00      0.00            6/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00          253/253     <Class::Stupidedi::Reader::SimpleElementTok>#build
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Either::Success#flatmap
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Reader::TokenReader#stream
                      0.00      0.00      0.00      0.00          1/15961     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            12/37     <Class::Stupidedi::Builder_::AbstractState>#element
                      0.00      0.00      0.00      0.00            25/37     Stupidedi::Schema::ElementUse#composite?
   0.00%   0.00%      0.00      0.00      0.00      0.00               37     Stupidedi::Schema::CompositeElementUse#simple?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            18/95     <Class::Stupidedi::Builder_::LoopState>#instructions
                      0.00      0.00      0.00      0.00            20/95     <Class::Stupidedi::Builder_::AbstractState>#sequence
                      0.00      0.00      0.00      0.00            56/95     Array#each
                      0.00      0.00      0.00      0.00             1/95     <Class::Stupidedi::Builder_::InterchangeState>#instructions
   0.00%   0.00%      0.00      0.00      0.00      0.00               95     Stupidedi::Schema::SegmentUse#repeatable?
                      0.00      0.00      0.00      0.00           95/119     Object#try
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            56/56     <Class::Stupidedi::Builder_::AbstractState>#segment
   0.00%   0.00%      0.00      0.00      0.00      0.00               56     Stupidedi::Schema::SegmentUse#value
                      0.00      0.00      0.00      0.00            56/56     Stupidedi::Schema::SegmentDef#value
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          361/615     Stupidedi::Schema::ElementUse#composite?
                      0.00      0.00      0.00      0.00          254/615     <Class::Stupidedi::Builder_::AbstractState>#element
   0.00%   0.00%      0.00      0.00      0.00      0.00              615     Stupidedi::Schema::SimpleElementUse#simple?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              3/5     Array#each
                      0.00      0.00      0.00      0.00              1/5     <Class::Stupidedi::Builder_::AbstractState>#tsequence
                      0.00      0.00      0.00      0.00              1/5     <Class::Stupidedi::Builder_::TransactionSetState>#instructions
   0.00%   0.00%      0.00      0.00      0.00      0.00                5     Stupidedi::Schema::TableDef#repeatable?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              3/3     Stupidedi::Values::SegmentVal#at
   0.00%   0.00%      0.00      0.00      0.00      0.00                3     Stupidedi::Values::SegmentVal#defined_at?
                      0.00      0.00      0.00      0.00            3/119     Object#try
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              2/2     Stupidedi::Values::SegmentValGroup#at
   0.00%   0.00%      0.00      0.00      0.00      0.00                2     Stupidedi::Values::SegmentValGroup#defined_at?
                      0.00      0.00      0.00      0.00             2/20     Module#===
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Envelope::InterchangeDef#segment_uses
                      0.00      0.00      0.00      0.00           2/3364     Kernel#nil?
                      0.00      0.00      0.00      0.00            2/275     Enumerable#any?
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Envelope::FunctionalGroupDef#segment_uses
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              5/5     Stupidedi::Values::TableVal#append
   0.00%   0.00%      0.00      0.00      0.00      0.00                5     Stupidedi::Values::TableVal#copy
                      0.00      0.00      0.00      0.00         15/41773     Hash#fetch
                      0.00      0.00      0.00      0.00          5/15961     Class#new
                      0.00      0.00      0.00      0.00          5/12203     Kernel#class
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            15/15     Stupidedi::Either::Success#flatmap
   0.00%   0.00%      0.00      0.00      0.00      0.00               15     Symbol#call
                      0.00      0.00      0.00      0.00            15/16     Kernel#__send__
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          100/116     Stupidedi::Reader::TokenReader#read_simple_element
                      0.00      0.00      0.00      0.00            1/116     Stupidedi::Reader::Separators#merge
                      0.00      0.00      0.00      0.00           15/116     Stupidedi::Either::Success#flatmap
   0.00%   0.00%      0.00      0.00      0.00      0.00              116     Unknown#element
                      0.00      0.00      0.00      0.00         116/2089     Hash#[]
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Reader::Separators#merge
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Unknown#segment
                      0.00      0.00      0.00      0.00           1/2089     Hash#[]
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            55/55     Stupidedi::Reader::TokenReader#segment
   0.00%   0.00%      0.00      0.00      0.00      0.00               55     <Class::Stupidedi::Reader::SegmentTok>#build
                      0.00      0.00      0.00      0.00         55/15961     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          253/253     Stupidedi::Reader::TokenReader#simple
   0.00%   0.00%      0.00      0.00      0.00      0.00              253     <Class::Stupidedi::Reader::SimpleElementTok>#build
                      0.00      0.00      0.00      0.00        253/15961     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/2     Hash#include?
                      0.00      0.00      0.00      0.00              1/2     Hash#[]
   0.00%   0.00%      0.00      0.00      0.00      0.00                2     Array#eql?
                      0.00      0.00      0.00      0.00              6/6     String#eql?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             1/52     Hash#include?
                      0.00      0.00      0.00      0.00            26/52     Hash#[]
                      0.00      0.00      0.00      0.00            25/52     Hash#[]=
   0.00%   0.00%      0.00      0.00      0.00      0.00               52     Array#hash
                      0.00      0.00      0.00      0.00          562/734     Kernel#hash
                      0.00      0.00      0.00      0.00              6/6     String#hash
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          396/598     Array#drop
                      0.00      0.00      0.00      0.00          198/598     Array#take
                      0.00      0.00      0.00      0.00            4/598     Array#init
   0.00%   0.00%      0.00      0.00      0.00      0.00              598     Array#slice
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          198/198     Array#split_at
   0.00%   0.00%      0.00      0.00      0.00      0.00              198     Array#take
                      0.00      0.00      0.00      0.00          198/598     Array#slice
                      0.00      0.00      0.00      0.00         198/3389     Fixnum#<
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            2/274     Array#each
                      0.00      0.00      0.00      0.00            2/274     Array#select
                      0.00      0.00      0.00      0.00          270/274     Kernel#===
   0.00%   0.00%      0.00      0.00      0.00      0.00              274     Kernel#==
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           79/734     Hash#include?
                      0.00      0.00      0.00      0.00          562/734     Array#hash
                      0.00      0.00      0.00      0.00            8/734     Hash#[]
                      0.00      0.00      0.00      0.00           85/734     Hash#[]=
   0.00%   0.00%      0.00      0.00      0.00      0.00              734     Kernel#hash
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          705/705     Array#map
   0.00%   0.00%      0.00      0.00      0.00      0.00              705     Kernel#object_id
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              7/7     Module#append_features
   0.00%   0.00%      0.00      0.00      0.00      0.00                7     Module#blankslate_original_append_features
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/2     Hash#each
                      0.00      0.00      0.00      0.00              1/2     OpenStruct#method_missing
   0.00%   0.00%      0.00      0.00      0.00      0.00                2     OpenStruct#new_ostruct_member
                      0.00      0.00      0.00      0.00              1/6     Symbol#to_sym
                      0.00      0.00      0.00      0.00             1/56     String#to_sym
                      0.00      0.00      0.00      0.00             4/26     Kernel#send
                      0.00      0.00      0.00      0.00           2/3358     Symbol#to_s
                      0.00      0.00      0.00      0.00            2/140     Kernel#respond_to?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            13/13     Integer#times
   0.00%   0.00%      0.00      0.00      0.00      0.00               13     Range#each
                      0.00      0.00      0.00      0.00             2/20     Stupidedi::Builder_::ConstraintTable::ValueBased#build_disjoint
                      0.00      0.00      0.00      0.00         114/1446     Array#each
                      0.00      0.00      0.00      0.00           2/1885     Array#<<
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            3/253     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal>#value
                      0.00      0.00      0.00      0.00           15/253     Stupidedi::Reader::TokenReader#consume_prefix
                      0.00      0.00      0.00      0.00          130/253     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal>#value
                      0.00      0.00      0.00      0.00          105/253     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal>#value
   0.00%   0.00%      0.00      0.00      0.00      0.00              253     String#empty?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          527/527     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00              527     Stupidedi::Builder_::ConstraintTable::Stub#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          161/161     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00              161     Stupidedi::Builder_::ConstraintTable::ValueBased#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Values::SegmentValGroup#defined_at?
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Envelope::FunctionalGroupDef#segment_uses
                      0.00      0.00      0.00      0.00            1/482     Array#+
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              3/3     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                3     Stupidedi::Envelope::FunctionalGroupVal#initialize
                      0.00      0.00      0.00      0.00           3/3364     Kernel#nil?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Envelope::TransactionSetVal#append
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Envelope::TransactionSetVal#copy
                      0.00      0.00      0.00      0.00         12/41773     Hash#fetch
                      0.00      0.00      0.00      0.00          4/15961     Class#new
                      0.00      0.00      0.00      0.00          4/12203     Kernel#class
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              5/5     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                5     Stupidedi::Envelope::TransactionSetVal#initialize
                      0.00      0.00      0.00      0.00           5/3364     Kernel#nil?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Builder_::ConstraintTable::ValueBased#select
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Reader::ComponentElementTok#blankness?
                      0.00      0.00      0.00      0.00             1/64     String#blankness?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Builder_::ConstraintTable::ValueBased#select
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Reader::CompositeElementTok#blankness?
                      0.00      0.00      0.00      0.00              1/1     Enumerable#blankness?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              2/2     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                2     Stupidedi::Reader::SegmentDict::Constants#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              2/2     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                2     Stupidedi::Reader::SegmentDict::NonEmpty#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            16/16     Stupidedi::Builder_::ConstraintTable::ValueBased#select
   0.00%   0.00%      0.00      0.00      0.00      0.00               16     Stupidedi::Reader::SimpleElementTok#blankness?
                      0.00      0.00      0.00      0.00            16/64     String#blankness?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          254/254     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00              254     Stupidedi::Reader::SimpleElementTok#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            12/12     Stupidedi::Either::Success#flatmap
   0.00%   0.00%      0.00      0.00      0.00      0.00               12     Stupidedi::Reader::TokenReader#composite
                      0.00      0.00      0.00      0.00            12/12     <Class::Stupidedi::Reader::CompositeElementTok>#build
                      0.00      0.00      0.00      0.00             1/48     Class#inherited
                      0.00      0.00      0.00      0.00             3/62     Module#attr_reader
                      0.00      0.00      0.00      0.00             1/53     Kernel#singleton_method_added
                      0.00      0.00      0.00      0.00            6/377     <Class::Object>#method_added
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            26/26     Stupidedi::Reader::TokenReader#read_component_elements
   0.00%   0.00%      0.00      0.00      0.00      0.00               26     Stupidedi::Reader::TokenReader#read_component_element
                      0.00      0.00      0.00      0.00          91/1855     Stupidedi::Reader::FileInput#at
                      0.00      0.00      0.00      0.00         315/4827     Kernel#===
                      0.00      0.00      0.00      0.00            26/26     Stupidedi::Reader::TokenReader#component
                      0.00      0.00      0.00      0.00          65/1063     String#<<
                      0.00      0.00      0.00      0.00          26/6012     Fixnum#-
                      0.00      0.00      0.00      0.00           26/757     Stupidedi::Reader::TokenReader#result
                      0.00      0.00      0.00      0.00          91/2550     Stupidedi::Reader::FileInput#defined_at?
                      0.00      0.00      0.00      0.00           26/693     Stupidedi::Reader::TokenReader#advance
                      0.00      0.00      0.00      0.00         91/13457     Fixnum#+
                      0.00      0.00      0.00      0.00           26/975     Stupidedi::Reader::FileInput#drop
                      0.00      0.00      0.00      0.00          91/1795     Stupidedi::Reader::TokenReader#is_control?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            15/15     Stupidedi::Reader::TokenReader#consume_prefix
   0.00%   0.00%      0.00      0.00      0.00      0.00               15     Stupidedi::Reader::TokenReader#success
                      0.00      0.00      0.00      0.00           15/778     <Class::Stupidedi::Either>#success
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             7/14     Array#each
                      0.00      0.00      0.00      0.00             7/14     <Class::Stupidedi::Builder_::AbstractState>#lsequence
   0.00%   0.00%      0.00      0.00      0.00      0.00               14     Stupidedi::Schema::LoopDef#repeatable?
                      0.00      0.00      0.00      0.00           14/119     Object#try
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            56/56     Stupidedi::Schema::SegmentUse#value
   0.00%   0.00%      0.00      0.00      0.00      0.00               56     Stupidedi::Schema::SegmentDef#value
                      0.00      0.00      0.00      0.00             1/48     Class#inherited
                      0.00      0.00      0.00      0.00             4/62     Module#attr_reader
                      0.00      0.00      0.00      0.00            8/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00         56/15961     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              9/9     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                9     Stupidedi::Values::TableVal#initialize
                      0.00      0.00      0.00      0.00           9/3364     Kernel#nil?
                      0.00      0.00      0.00      0.00           9/1301     Array#map
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          274/274     OpenStruct#method_missing
   0.00%   0.00%      0.00      0.00      0.00      0.00              274     Symbol#id2name
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/6     Hash#each
                      0.00      0.00      0.00      0.00              2/6     Array#each
                      0.00      0.00      0.00      0.00              1/6     OpenStruct#new_ostruct_member
                      0.00      0.00      0.00      0.00              2/6     Array#select
   0.00%   0.00%      0.00      0.00      0.00      0.00                6     Symbol#to_sym
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            12/12     <Class::Stupidedi::Builder_::AbstractState>#element
   0.00%   0.00%      0.00      0.00      0.00      0.00               12     <Class::Stupidedi::Builder_::AbstractState>#composite_element
                      0.00      0.00      0.00      0.00           12/292     Stupidedi::Schema::ElementUse#value
                      0.00      0.00      0.00      0.00            12/68     Array#zip
                      0.00      0.00      0.00      0.00          12/1301     Array#map
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            12/12     Stupidedi::Reader::TokenReader#composite
   0.00%   0.00%      0.00      0.00      0.00      0.00               12     <Class::Stupidedi::Reader::CompositeElementTok>#build
                      0.00      0.00      0.00      0.00         12/15961     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     OpenStruct#method_missing
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Array#[]
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            97/97     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00               97     Array#clear
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            22/22     Object#try
   0.00%   0.00%      0.00      0.00      0.00      0.00               22     Array#include?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Reader::CompositeElementTok#blankness?
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Enumerable#blankness?
                      0.00      0.00      0.00      0.00           1/1253     Array#empty?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          176/177     Stupidedi::AbsoluteSet#size
                      0.00      0.00      0.00      0.00            1/177     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00              177     Enumerable#inject
                      0.00      0.00      0.00      0.00           1/1446     Array#each
                      0.00      0.00      0.00      0.00          176/312     Hash#each
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     OpenStruct#method_missing
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Kernel#frozen?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            2/140     OpenStruct#new_ostruct_member
                      0.00      0.00      0.00      0.00           16/140     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DecimalVal>#value
                      0.00      0.00      0.00      0.00           17/140     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal>#value
                      0.00      0.00      0.00      0.00          105/140     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal>#value
   0.00%   0.00%      0.00      0.00      0.00      0.00              140     Kernel#respond_to?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     OpenStruct#method_missing
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     String#chop!
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              6/6     Array#eql?
   0.00%   0.00%      0.00      0.00      0.00      0.00                6     String#eql?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              6/6     Array#hash
   0.00%   0.00%      0.00      0.00      0.00      0.00                6     String#hash
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     OpenStruct#method_missing
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     String#intern
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            18/20     Array#each
                      0.00      0.00      0.00      0.00             2/20     Range#each
   0.00%   0.00%      0.00      0.00      0.00      0.00               20     Stupidedi::Builder_::ConstraintTable::ValueBased#build_disjoint
                      0.00      0.00      0.00      0.00            20/20     Stupidedi::AbsoluteSet#finite?
                      0.00      0.00      0.00      0.00          20/1446     Array#each
                      0.00      0.00      0.00      0.00         20/15961     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          223/223     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00              223     Stupidedi::Builder_::InstructionTable::NonEmpty#initialize
                      0.00      0.00      0.00      0.00        446/15961     Class#new
                      0.00      0.00      0.00      0.00          223/774     Kernel#freeze
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              2/2     Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeVal#initialize
   0.00%   0.00%      0.00      0.00      0.00      0.00                2     Stupidedi::Dictionaries::Interchanges::FiveOhOne::ElementDefs::SeparatorElementVal#to_s
                      0.00      0.00      0.00      0.00           2/3543     String#to_s
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              3/3     Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeVal#initialize
   0.00%   0.00%      0.00      0.00      0.00      0.00                3     Stupidedi::Envelope::InterchangeVal#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            56/56     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00               56     Stupidedi::Reader::SegmentTok#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Reader::Separators#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            26/26     Stupidedi::Reader::TokenReader#read_component_element
   0.00%   0.00%      0.00      0.00      0.00      0.00               26     Stupidedi::Reader::TokenReader#component
                      0.00      0.00      0.00      0.00             1/48     Class#inherited
                      0.00      0.00      0.00      0.00             3/62     Module#attr_reader
                      0.00      0.00      0.00      0.00             1/53     Kernel#singleton_method_added
                      0.00      0.00      0.00      0.00            4/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00            26/26     <Class::Stupidedi::Reader::ComponentElementTok>#build
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            13/13     Stupidedi::Schema::ElementUse#empty
   0.00%   0.00%      0.00      0.00      0.00      0.00               13     Stupidedi::Schema::CompositeElementDef#empty
                      0.00      0.00      0.00      0.00             1/48     Class#inherited
                      0.00      0.00      0.00      0.00             4/62     Module#attr_reader
                      0.00      0.00      0.00      0.00            8/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00         13/15961     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           12/166     Array#map
                      0.00      0.00      0.00      0.00          154/166     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00              166     Stupidedi::Schema::LoopDef#entry_segment_use
                      0.00      0.00      0.00      0.00          166/709     Array#head
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            14/14     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00               14     Stupidedi::Schema::TableDef#entry_segment_uses
                      0.00      0.00      0.00      0.00           42/286     Array#concat
                      0.00      0.00      0.00      0.00          14/1301     Array#map
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     #<Class:0xb73f3808>#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          386/386     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00              386     #<Class:0xb75eda14>#==
                      0.00      0.00      0.00      0.00          386/941     Kernel#eql?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          543/543     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00              543     #<Class:0xb75eda14>#union
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Object#try
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     #<Class:0xb75ff5d4>#include?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     <Class::Class>#allocate
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          111/111     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#empty
   0.00%   0.00%      0.00      0.00      0.00      0.00              111     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal>#empty
                      0.00      0.00      0.00      0.00        111/15961     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              7/7     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#empty
   0.00%   0.00%      0.00      0.00      0.00      0.00                7     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal>#empty
                      0.00      0.00      0.00      0.00          7/15961     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            73/73     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#empty
   0.00%   0.00%      0.00      0.00      0.00      0.00               73     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal>#empty
                      0.00      0.00      0.00      0.00         73/15961     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            26/26     Stupidedi::Reader::TokenReader#component
   0.00%   0.00%      0.00      0.00      0.00      0.00               26     <Class::Stupidedi::Reader::ComponentElementTok>#build
                      0.00      0.00      0.00      0.00         26/15961     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Class#initialize
                      0.00      0.00      0.00      0.00             1/48     Class#inherited
                      0.00      0.00      0.00      0.00           18/377     <Class::Object>#method_added
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          551/774     Stupidedi::AbsoluteSet#initialize
                      0.00      0.00      0.00      0.00          223/774     Stupidedi::Builder_::InstructionTable::NonEmpty#initialize
   0.00%   0.00%      0.00      0.00      0.00      0.00              774     Kernel#freeze
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Kernel#send
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Module#define_method
                      0.00      0.00      0.00      0.00             4/53     Kernel#singleton_method_added
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          133/133     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00              133     Stupidedi::AbsoluteSet#==
                      0.00      0.00      0.00      0.00          133/941     Kernel#eql?
                      0.00      0.00      0.00      0.00         133/2313     Kernel#is_a?
                      0.00      0.00      0.00      0.00         119/1331     Fixnum#==
                      0.00      0.00      0.00      0.00        133/12203     Kernel#class
                      0.00      0.00      0.00      0.00            14/29     Bignum#==
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            20/20     Stupidedi::Builder_::ConstraintTable::ValueBased#build_disjoint
   0.00%   0.00%      0.00      0.00      0.00      0.00               20     Stupidedi::AbsoluteSet#finite?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          330/330     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00              330     Stupidedi::AbsoluteSet#union
                      0.00      0.00      0.00      0.00          242/941     Kernel#eql?
                      0.00      0.00      0.00      0.00         330/2313     Kernel#is_a?
                      0.00      0.00      0.00      0.00            45/45     Bignum#|
                      0.00      0.00      0.00      0.00          330/551     Stupidedi::AbsoluteSet#copy
                      0.00      0.00      0.00      0.00          285/285     Fixnum#|
                      0.00      0.00      0.00      0.00           88/176     Stupidedi::AbsoluteSet#as_mask
                      0.00      0.00      0.00      0.00        330/12203     Kernel#class
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          535/535     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00              535     Stupidedi::AbstractSet#disjoint?
                      0.00      0.00      0.00      0.00          221/221     Stupidedi::AbsoluteSet#intersection
                      0.00      0.00      0.00      0.00          157/157     #<Class:0xb75eda14>#empty?
                      0.00      0.00      0.00      0.00          314/314     #<Class:0xb75eda14>#intersection
                      0.00      0.00      0.00      0.00          221/221     Stupidedi::AbsoluteSet#empty?
                      0.00      0.00      0.00      0.00          157/157     #<Class:0xb73f3808>#empty?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          111/241     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#empty
                      0.00      0.00      0.00      0.00          130/241     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
   0.00%   0.00%      0.00      0.00      0.00      0.00              241     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::ID#companion
                      0.00      0.00      0.00      0.00              1/4     Module#delegate
                      0.00      0.00      0.00      0.00             3/48     Class#inherited
                      0.00      0.00      0.00      0.00             1/62     Module#attr_reader
                      0.00      0.00      0.00      0.00             3/26     Kernel#send
                      0.00      0.00      0.00      0.00             2/53     Kernel#singleton_method_added
                      0.00      0.00      0.00      0.00            8/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00             3/22     Object#eigenclass
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             7/24     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#empty
                      0.00      0.00      0.00      0.00            17/24     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
   0.00%   0.00%      0.00      0.00      0.00      0.00               24     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::Nn#companion
                      0.00      0.00      0.00      0.00              1/4     Module#delegate
                      0.00      0.00      0.00      0.00             3/48     Class#inherited
                      0.00      0.00      0.00      0.00             1/62     Module#attr_reader
                      0.00      0.00      0.00      0.00             3/26     Kernel#send
                      0.00      0.00      0.00      0.00             2/53     Kernel#singleton_method_added
                      0.00      0.00      0.00      0.00           18/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00             3/22     Object#eigenclass
                      0.00      0.00      0.00      0.00              1/7     Module#include
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Values::SegmentValGroup#at
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Envelope::InterchangeVal#segment_vals
                      0.00      0.00      0.00      0.00              1/4     Array#select
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          157/157     Stupidedi::AbstractSet#disjoint?
   0.00%   0.00%      0.00      0.00      0.00      0.00              157     #<Class:0xb73f3808>#empty?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          157/157     Stupidedi::AbstractSet#disjoint?
   0.00%   0.00%      0.00      0.00      0.00      0.00              157     #<Class:0xb75eda14>#empty?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          314/314     Stupidedi::AbstractSet#disjoint?
   0.00%   0.00%      0.00      0.00      0.00      0.00              314     #<Class:0xb75eda14>#intersection
                      0.00      0.00      0.00      0.00         471/2313     Kernel#is_a?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            41/41     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#empty
   0.00%   0.00%      0.00      0.00      0.00      0.00               41     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DecimalVal>#empty
                      0.00      0.00      0.00      0.00         41/15961     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             2/29     Fixnum#==
                      0.00      0.00      0.00      0.00            14/29     Stupidedi::AbsoluteSet#==
                      0.00      0.00      0.00      0.00            13/29     Numeric#zero?
   0.00%   0.00%      0.00      0.00      0.00      0.00               29     Bignum#==
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            45/45     Stupidedi::AbsoluteSet#union
   0.00%   0.00%      0.00      0.00      0.00      0.00               45     Bignum#|
                      0.00      0.00      0.00      0.00           45/120     Integer#to_int
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          285/285     Stupidedi::AbsoluteSet#union
   0.00%   0.00%      0.00      0.00      0.00      0.00              285     Fixnum#|
                      0.00      0.00      0.00      0.00           20/120     Integer#to_int
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           88/176     Stupidedi::AbsoluteSet#union
                      0.00      0.00      0.00      0.00           88/176     Stupidedi::AbsoluteSet#intersection
   0.00%   0.00%      0.00      0.00      0.00      0.00              176     Stupidedi::AbsoluteSet#as_mask
                      0.00      0.00      0.00      0.00          176/176     Stupidedi::AbstractSet#infinite?
                      0.00      0.00      0.00      0.00         176/2313     Kernel#is_a?
                      0.00      0.00      0.00      0.00         176/3389     Fixnum#<
                      0.00      0.00      0.00      0.00          176/176     #<Class:0xb73f3808>#size
                      0.00      0.00      0.00      0.00          176/176     #<Class:0xb73f3808>#each
                      0.00      0.00      0.00      0.00          176/176     Stupidedi::AbsoluteSet#size
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          330/551     Stupidedi::AbsoluteSet#union
                      0.00      0.00      0.00      0.00          221/551     Stupidedi::AbsoluteSet#intersection
   0.00%   0.00%      0.00      0.00      0.00      0.00              551     Stupidedi::AbsoluteSet#copy
                      0.00      0.00      0.00      0.00       1102/41773     Hash#fetch
                      0.00      0.00      0.00      0.00        551/15961     Class#new
                      0.00      0.00      0.00      0.00        551/12203     Kernel#class
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            85/85     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00               85     Stupidedi::AbsoluteSet#each
                      0.00      0.00      0.00      0.00           85/312     Hash#each
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          221/221     Stupidedi::AbstractSet#disjoint?
   0.00%   0.00%      0.00      0.00      0.00      0.00              221     Stupidedi::AbsoluteSet#empty?
                      0.00      0.00      0.00      0.00            13/13     Numeric#zero?
                      0.00      0.00      0.00      0.00         208/3130     Fixnum#zero?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          221/221     Stupidedi::AbstractSet#disjoint?
   0.00%   0.00%      0.00      0.00      0.00      0.00              221     Stupidedi::AbsoluteSet#intersection
                      0.00      0.00      0.00      0.00          133/941     Kernel#eql?
                      0.00      0.00      0.00      0.00          186/186     Fixnum#&
                      0.00      0.00      0.00      0.00         221/2313     Kernel#is_a?
                      0.00      0.00      0.00      0.00          221/551     Stupidedi::AbsoluteSet#copy
                      0.00      0.00      0.00      0.00            35/35     Bignum#&
                      0.00      0.00      0.00      0.00           88/176     Stupidedi::AbsoluteSet#as_mask
                      0.00      0.00      0.00      0.00        221/12203     Kernel#class
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Values::SegmentValGroup#defined_at?
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Envelope::InterchangeDef#segment_uses
                      0.00      0.00      0.00      0.00            1/482     Array#+
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            12/12     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00               12     Stupidedi::Reader::CompositeElementTok#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            12/12     Stupidedi::Schema::ElementUse#value
   0.00%   0.00%      0.00      0.00      0.00      0.00               12     Stupidedi::Schema::CompositeElementDef#value
                      0.00      0.00      0.00      0.00         12/15961     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          176/176     Stupidedi::AbsoluteSet#as_mask
   0.00%   0.00%      0.00      0.00      0.00      0.00              176     #<Class:0xb73f3808>#each
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          176/176     Stupidedi::AbsoluteSet#as_mask
   0.00%   0.00%      0.00      0.00      0.00      0.00              176     #<Class:0xb73f3808>#size
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     #<Class:0xb7604c14>#companion
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     #<Class:0xb760531c>#companion
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            20/20     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
   0.00%   0.00%      0.00      0.00      0.00      0.00               20     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DecimalVal>#value
                      0.00      0.00      0.00      0.00          16/2313     Kernel#is_a?
                      0.00      0.00      0.00      0.00            20/64     String#blankness?
                      0.00      0.00      0.00      0.00            16/33     String#to_d
                      0.00      0.00      0.00      0.00         20/15961     Class#new
                      0.00      0.00      0.00      0.00           16/140     Kernel#respond_to?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          130/130     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
   0.00%   0.00%      0.00      0.00      0.00      0.00              130     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal>#value
                      0.00      0.00      0.00      0.00         130/2313     Kernel#is_a?
                      0.00      0.00      0.00      0.00         115/3543     String#to_s
                      0.00      0.00      0.00      0.00         130/3364     Kernel#nil?
                      0.00      0.00      0.00      0.00        130/15961     Class#new
                      0.00      0.00      0.00      0.00          130/253     String#empty?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            17/17     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
   0.00%   0.00%      0.00      0.00      0.00      0.00               17     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal>#value
                      0.00      0.00      0.00      0.00          17/2313     Kernel#is_a?
                      0.00      0.00      0.00      0.00            17/64     String#blankness?
                      0.00      0.00      0.00      0.00            17/33     String#to_d
                      0.00      0.00      0.00      0.00         17/15961     Class#new
                      0.00      0.00      0.00      0.00           17/140     Kernel#respond_to?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          105/105     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
   0.00%   0.00%      0.00      0.00      0.00      0.00              105     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal>#value
                      0.00      0.00      0.00      0.00         105/3543     String#to_s
                      0.00      0.00      0.00      0.00        105/15961     Class#new
                      0.00      0.00      0.00      0.00          105/140     Kernel#respond_to?
                      0.00      0.00      0.00      0.00          105/253     String#empty?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              3/3     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
   0.00%   0.00%      0.00      0.00      0.00      0.00                3     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal>#value
                      0.00      0.00      0.00      0.00           9/2313     Kernel#is_a?
                      0.00      0.00      0.00      0.00             3/64     String#blankness?
                      0.00      0.00      0.00      0.00             3/43     String#to_i
                      0.00      0.00      0.00      0.00          12/3543     String#to_s
                      0.00      0.00      0.00      0.00            6/119     Object#try
                      0.00      0.00      0.00      0.00           3/3364     Kernel#nil?
                      0.00      0.00      0.00      0.00          3/15961     Class#new
                      0.00      0.00      0.00      0.00            12/22     String#slice
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              2/2     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
   0.00%   0.00%      0.00      0.00      0.00      0.00                2     <Class::Stupidedi::Dictionaries::Interchanges::FiveOhOne::ElementDefs::SeparatorElementVal>#value
                      0.00      0.00      0.00      0.00          2/15961     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            35/35     Stupidedi::AbsoluteSet#intersection
   0.00%   0.00%      0.00      0.00      0.00      0.00               35     Bignum#&
                      0.00      0.00      0.00      0.00           35/120     Integer#to_int
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          186/186     Stupidedi::AbsoluteSet#intersection
   0.00%   0.00%      0.00      0.00      0.00      0.00              186     Fixnum#&
                      0.00      0.00      0.00      0.00           20/120     Integer#to_int
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           20/120     Fixnum#|
                      0.00      0.00      0.00      0.00           35/120     Bignum#&
                      0.00      0.00      0.00      0.00           45/120     Bignum#|
                      0.00      0.00      0.00      0.00           20/120     Fixnum#&
   0.00%   0.00%      0.00      0.00      0.00      0.00              120     Integer#to_int
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/4     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::Nn#companion
                      0.00      0.00      0.00      0.00              1/4     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::R#companion
                      0.00      0.00      0.00      0.00              1/4     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::AN#companion
                      0.00      0.00      0.00      0.00              1/4     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::ID#companion
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Module#delegate
                      0.00      0.00      0.00      0.00              4/4     Array#init
                      0.00      0.00      0.00      0.00             4/15     Kernel#caller
                      0.00      0.00      0.00      0.00           4/2313     Kernel#is_a?
                      0.00      0.00      0.00      0.00             8/19     Array#last
                      0.00      0.00      0.00      0.00             4/16     Array#first
                      0.00      0.00      0.00      0.00          4/41773     Hash#fetch
                      0.00      0.00      0.00      0.00           4/1446     Array#each
                      0.00      0.00      0.00      0.00             4/15     String#split
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            13/13     Stupidedi::AbsoluteSet#empty?
   0.00%   0.00%      0.00      0.00      0.00      0.00               13     Numeric#zero?
                      0.00      0.00      0.00      0.00            13/29     Bignum#==
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          176/176     Stupidedi::AbsoluteSet#as_mask
   0.00%   0.00%      0.00      0.00      0.00      0.00              176     Stupidedi::AbsoluteSet#size
                      0.00      0.00      0.00      0.00          176/177     Enumerable#inject
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          176/176     Stupidedi::AbsoluteSet#as_mask
   0.00%   0.00%      0.00      0.00      0.00      0.00              176     Stupidedi::AbstractSet#infinite?
                      0.00      0.00      0.00      0.00          176/176     #<Class:0xb73f3808>#finite?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              3/3     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
   0.00%   0.00%      0.00      0.00      0.00      0.00                3     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DT#companion
                      0.00      0.00      0.00      0.00             4/48     Class#inherited
                      0.00      0.00      0.00      0.00             2/62     Module#attr_reader
                      0.00      0.00      0.00      0.00          1/15794     <Class::Object>#allocate
                      0.00      0.00      0.00      0.00             4/26     Kernel#send
                      0.00      0.00      0.00      0.00             2/53     Kernel#singleton_method_added
                      0.00      0.00      0.00      0.00           21/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00             4/22     Object#eigenclass
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              3/3     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
   0.00%   0.00%      0.00      0.00      0.00      0.00                3     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TM#companion
                      0.00      0.00      0.00      0.00             3/48     Class#inherited
                      0.00      0.00      0.00      0.00             1/62     Module#attr_reader
                      0.00      0.00      0.00      0.00          1/15794     <Class::Object>#allocate
                      0.00      0.00      0.00      0.00             3/26     Kernel#send
                      0.00      0.00      0.00      0.00             2/53     Kernel#singleton_method_added
                      0.00      0.00      0.00      0.00            9/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00             3/22     Object#eigenclass
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            26/26     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00               26     Stupidedi::Reader::ComponentElementTok#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          89/3904     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal::NonEmpty#initialize
                      0.00      0.00      0.00      0.00        2366/3904     Class#new
                      0.00      0.00      0.00      0.00           5/3904     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal::Proper#initialize
                      0.00      0.00      0.00      0.00         146/3904     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DecimalVal::NonEmpty#initialize
                      0.00      0.00      0.00      0.00           1/3904     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal::Improper#initialize
                      0.00      0.00      0.00      0.00           2/3904     Stupidedi::Dictionaries::Interchanges::FiveOhOne::ElementDefs::SeparatorElementVal#initialize
                      0.00      0.00      0.00      0.00         458/3904     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal::NonEmpty#initialize
                      0.00      0.00      0.00      0.00           6/3904     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal::NonEmpty#initialize
                      0.00      0.00      0.00      0.00         831/3904     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal::NonEmpty#initialize
   0.00%   0.00%      0.00      0.00      0.00      0.00             3904     Stupidedi::Values::SimpleElementVal#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          176/176     Stupidedi::AbstractSet#infinite?
   0.00%   0.00%      0.00      0.00      0.00      0.00              176     #<Class:0xb73f3808>#finite?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Module#delegate
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Array#init
                      0.00      0.00      0.00      0.00            4/598     Array#slice
                      0.00      0.00      0.00      0.00          4/15794     <Class::Object>#allocate
                      0.00      0.00      0.00      0.00              4/4     Fixnum#-@
                      0.00      0.00      0.00      0.00          4/13457     Fixnum#+
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00        2533/2533     Hash#each
   0.00%   0.00%      0.00      0.00      0.00      0.00             2533     Bignum#[]
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00        3572/3572     Hash#each
   0.00%   0.00%      0.00      0.00      0.00      0.00             3572     Fixnum#[]
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            16/33     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DecimalVal>#value
                      0.00      0.00      0.00      0.00            17/33     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal>#value
   0.00%   0.00%      0.00      0.00      0.00      0.00               33     String#to_d
                      0.00      0.00      0.00      0.00            33/33     Regexp#=~
                      0.00      0.00      0.00      0.00            33/33     Kernel#BigDecimal
                      0.00      0.00      0.00      0.00          33/3543     String#to_s
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          551/551     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00              551     Stupidedi::AbsoluteSet#initialize
                      0.00      0.00      0.00      0.00          551/774     Kernel#freeze
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Array#init
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Fixnum#-@
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            33/33     String#to_d
   0.00%   0.00%      0.00      0.00      0.00      0.00               33     Kernel#BigDecimal
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            33/33     String#to_d
   0.00%   0.00%      0.00      0.00      0.00      0.00               33     Regexp#=~
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal::Improper#initialize
                      0.00      0.00      0.00      0.00           1/3904     Stupidedi::Values::SimpleElementVal#initialize
                      0.00      0.00      0.00      0.00             3/43     String#to_i
                      0.00      0.00      0.00      0.00             3/15     Comparable#between?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          130/130     Array#map
   0.00%   0.00%      0.00      0.00      0.00      0.00              130     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DecimalVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00        520/41773     Hash#fetch
                      0.00      0.00      0.00      0.00        130/15961     Class#new
                      0.00      0.00      0.00      0.00        130/12203     Kernel#class
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          146/146     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00              146     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DecimalVal::NonEmpty#initialize
                      0.00      0.00      0.00      0.00         146/3904     Stupidedi::Values::SimpleElementVal#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          716/716     Array#map
   0.00%   0.00%      0.00      0.00      0.00      0.00              716     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00       2864/41773     Hash#fetch
                      0.00      0.00      0.00      0.00        716/15961     Class#new
                      0.00      0.00      0.00      0.00        716/12203     Kernel#class
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          831/831     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00              831     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal::NonEmpty#initialize
                      0.00      0.00      0.00      0.00         831/3904     Stupidedi::Values::SimpleElementVal#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            72/72     Array#map
   0.00%   0.00%      0.00      0.00      0.00      0.00               72     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00        288/41773     Hash#fetch
                      0.00      0.00      0.00      0.00         72/15961     Class#new
                      0.00      0.00      0.00      0.00         72/12203     Kernel#class
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            89/89     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00               89     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal::NonEmpty#initialize
                      0.00      0.00      0.00      0.00          89/3904     Stupidedi::Values::SimpleElementVal#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          392/392     Array#map
   0.00%   0.00%      0.00      0.00      0.00      0.00              392     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00       1568/41773     Hash#fetch
                      0.00      0.00      0.00      0.00        392/15961     Class#new
                      0.00      0.00      0.00      0.00        392/12203     Kernel#class
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          458/458     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00              458     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal::NonEmpty#initialize
                      0.00      0.00      0.00      0.00         458/3904     Stupidedi::Values::SimpleElementVal#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              6/6     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                6     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal::NonEmpty#initialize
                      0.00      0.00      0.00      0.00           6/3904     Stupidedi::Values::SimpleElementVal#initialize
                      0.00      0.00      0.00      0.00          12/1284     NilClass#nil?
                      0.00      0.00      0.00      0.00            12/15     Comparable#between?
                      0.00      0.00      0.00      0.00          24/3364     Kernel#nil?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              2/2     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                2     Stupidedi::Dictionaries::Interchanges::FiveOhOne::ElementDefs::SeparatorElementVal#initialize
                      0.00      0.00      0.00      0.00           2/3904     Stupidedi::Values::SimpleElementVal#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             3/15     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal::Improper#initialize
                      0.00      0.00      0.00      0.00            12/15     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal::NonEmpty#initialize
   0.00%   0.00%      0.00      0.00      0.00      0.00               15     Comparable#between?
                      0.00      0.00      0.00      0.00            30/30     Fixnum#<=>
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              3/3     Array#map
   0.00%   0.00%      0.00      0.00      0.00      0.00                3     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal::Proper#copy
                      0.00      0.00      0.00      0.00         18/41773     Hash#fetch
                      0.00      0.00      0.00      0.00          3/15961     Class#new
                      0.00      0.00      0.00      0.00          3/12203     Kernel#class
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              3/3     Array#map
   0.00%   0.00%      0.00      0.00      0.00      0.00                3     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00         18/41773     Hash#fetch
                      0.00      0.00      0.00      0.00          3/15961     Class#new
                      0.00      0.00      0.00      0.00          3/12203     Kernel#class
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              5/5     <Class::Date>#civil
   0.00%   0.00%      0.00      0.00      0.00      0.00                5     <Class::Date>#valid_civil?
                      0.00      0.00      0.00      0.00              5/5     <Class::Date>#civil_to_jd
                      0.00      0.00      0.00      0.00          10/3389     Fixnum#<
                      0.00      0.00      0.00      0.00              5/5     Array#==
                      0.00      0.00      0.00      0.00              5/5     <Class::Date>#jd_to_civil
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              5/5     <Class::Date>#civil
   0.00%   0.00%      0.00      0.00      0.00      0.00                5     Class#new!
                      0.00      0.00      0.00      0.00          5/15794     <Class::Object>#allocate
                      0.00      0.00      0.00      0.00              5/5     Date#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            30/30     Comparable#between?
   0.00%   0.00%      0.00      0.00      0.00      0.00               30     Fixnum#<=>
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              5/5     <Class::Date>#valid_civil?
   0.00%   0.00%      0.00      0.00      0.00      0.00                5     <Class::Date>#civil_to_jd
                      0.00      0.00      0.00      0.00             5/10     <Class::Date>#julian?
                      0.00      0.00      0.00      0.00            10/20     Fixnum#/
                      0.00      0.00      0.00      0.00          11/6012     Fixnum#-
                      0.00      0.00      0.00      0.00            5/335     Fixnum#<=
                      0.00      0.00      0.00      0.00            10/20     Float#*
                      0.00      0.00      0.00      0.00            20/50     Float#floor
                      0.00      0.00      0.00      0.00         31/13457     Fixnum#+
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              5/5     <Class::Date>#valid_civil?
   0.00%   0.00%      0.00      0.00      0.00      0.00                5     <Class::Date>#jd_to_civil
                      0.00      0.00      0.00      0.00             5/10     <Class::Date>#julian?
                      0.00      0.00      0.00      0.00            10/30     Float#/
                      0.00      0.00      0.00      0.00            10/20     Fixnum#/
                      0.00      0.00      0.00      0.00          40/6012     Fixnum#-
                      0.00      0.00      0.00      0.00            5/335     Fixnum#<=
                      0.00      0.00      0.00      0.00            10/20     Float#*
                      0.00      0.00      0.00      0.00            30/50     Float#floor
                      0.00      0.00      0.00      0.00         15/13457     Fixnum#+
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              5/5     <Class::Date>#valid_civil?
   0.00%   0.00%      0.00      0.00      0.00      0.00                5     Array#==
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              5/5     Class#new!
   0.00%   0.00%      0.00      0.00      0.00      0.00                5     Date#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             5/10     Rational#/
                      0.00      0.00      0.00      0.00             5/10     <Class::Date>#jd_to_ajd
   0.00%   0.00%      0.00      0.00      0.00      0.00               10     Rational#/
                      0.00      0.00      0.00      0.00            10/25     Fixnum#*
                      0.00      0.00      0.00      0.00            15/95     Kernel#kind_of?
                      0.00      0.00      0.00      0.00             5/25     <Class::Rational>#new!
                      0.00      0.00      0.00      0.00             5/10     Rational#/
                      0.00      0.00      0.00      0.00           5/1331     Fixnum#==
                      0.00      0.00      0.00      0.00             5/15     Object#Rational
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             5/10     <Class::Date>#jd_to_civil
                      0.00      0.00      0.00      0.00             5/10     <Class::Date>#civil_to_jd
   0.00%   0.00%      0.00      0.00      0.00      0.00               10     <Class::Date>#julian?
                      0.00      0.00      0.00      0.00            10/20     Module#===
                      0.00      0.00      0.00      0.00          10/3389     Fixnum#<
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            15/25     <Class::Rational>#reduce
                      0.00      0.00      0.00      0.00             5/25     Rational#/
                      0.00      0.00      0.00      0.00             5/25     Rational#coerce
   0.00%   0.00%      0.00      0.00      0.00      0.00               25     <Class::Rational>#new!
                      0.00      0.00      0.00      0.00         25/15961     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            10/20     <Class::Date>#jd_to_civil
                      0.00      0.00      0.00      0.00            10/20     <Class::Date>#civil_to_jd
   0.00%   0.00%      0.00      0.00      0.00      0.00               20     Fixnum#/
                      0.00      0.00      0.00      0.00            20/30     Float#/
                      0.00      0.00      0.00      0.00            20/20     Float#coerce
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            10/20     <Class::Date>#jd_to_civil
                      0.00      0.00      0.00      0.00            10/20     <Class::Date>#civil_to_jd
   0.00%   0.00%      0.00      0.00      0.00      0.00               20     Float#*
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            10/30     <Class::Date>#jd_to_civil
                      0.00      0.00      0.00      0.00            20/30     Fixnum#/
   0.00%   0.00%      0.00      0.00      0.00      0.00               30     Float#/
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            30/50     <Class::Date>#jd_to_civil
                      0.00      0.00      0.00      0.00            20/50     <Class::Date>#civil_to_jd
   0.00%   0.00%      0.00      0.00      0.00      0.00               50     Float#floor
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              9/9     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal::Proper#initialize
   0.00%   0.00%      0.00      0.00      0.00      0.00                9     Integer#to_i
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            50/95     Rational#initialize
                      0.00      0.00      0.00      0.00            15/95     Object#Rational
                      0.00      0.00      0.00      0.00            15/95     Rational#/
                      0.00      0.00      0.00      0.00            10/95     Rational#coerce
                      0.00      0.00      0.00      0.00             5/95     Rational#-
   0.00%   0.00%      0.00      0.00      0.00      0.00               95     Kernel#kind_of?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              5/5     Fixnum#-
   0.00%   0.00%      0.00      0.00      0.00      0.00                5     Rational#-
                      0.00      0.00      0.00      0.00            15/25     Fixnum#*
                      0.00      0.00      0.00      0.00           5/6012     Fixnum#-
                      0.00      0.00      0.00      0.00             5/95     Kernel#kind_of?
                      0.00      0.00      0.00      0.00             5/15     Object#Rational
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              5/5     Fixnum#-
   0.00%   0.00%      0.00      0.00      0.00      0.00                5     Rational#coerce
                      0.00      0.00      0.00      0.00            10/95     Kernel#kind_of?
                      0.00      0.00      0.00      0.00             5/25     <Class::Rational>#new!
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            10/25     Rational#/
                      0.00      0.00      0.00      0.00            15/25     Rational#-
   0.00%   0.00%      0.00      0.00      0.00      0.00               25     Fixnum#*
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            20/20     Fixnum#/
   0.00%   0.00%      0.00      0.00      0.00      0.00               20     Float#coerce
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            30/30     <Class::Rational>#reduce
   0.00%   0.00%      0.00      0.00      0.00      0.00               30     Fixnum#div
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            15/15     <Class::Rational>#reduce
   0.00%   0.00%      0.00      0.00      0.00      0.00               15     Integer#gcd
                      0.00      0.00      0.00      0.00         40/18317     Fixnum#>
                      0.00      0.00      0.00      0.00            25/25     Fixnum#%
                      0.00      0.00      0.00      0.00            30/30     Fixnum#abs
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            25/25     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00               25     Rational#initialize
                      0.00      0.00      0.00      0.00          25/3389     Fixnum#<
                      0.00      0.00      0.00      0.00            50/95     Kernel#kind_of?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            25/25     Integer#gcd
   0.00%   0.00%      0.00      0.00      0.00      0.00               25     Fixnum#%
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            30/30     Integer#gcd
   0.00%   0.00%      0.00      0.00      0.00      0.00               30     Fixnum#abs


#<Stupidedi::Builder_::StateMachine:0xb74577f4
 @errors=[],
 @states=
  [InterchangeState(
     InterchangeVal[00501](
       SegmentVal[ISA: Interchange Control Header](
         ID.value[  I01: Authorization Information Qualifier](00), 
         AN.value[  I02: Authorization Information](          ), 
         ID.value[  I03: Security Information Qualifier](00), 
         AN.value[  I04: Security Information](          ), 
         ID.value[  I05: Interchange ID Qualifier](ZZ), 
         AN.value[  I06: Interchange Sender ID](SUBMITTERS ID  ), 
         ID.value[  I05: Interchange ID Qualifier](ZZ), 
         AN.value[  I07: Interchange Receiver ID](RECEIVERS ID   ), 
         DT.value[  I08: Interchange Date](XX01-01-22), 
         TM.value[  I09: Interchange Time](12:53:ss), 
         SeparatorElementVal.value[I65](^), 
         ID.value[  I11: Interchange Control Version Number](00501), 
         Nn.value[  I12: Interchange Control Number](905.0), 
         ID.value[  I13: Acknowledgment Requested](1), 
         ID.value[  I14: Interchange Usage Indicator](T), 
         SeparatorElementVal.value[I15](:)), 
       FunctionalGroupVal[005010](
         SegmentVal[GS: Functional Group Header](
           ID.value[ E479: Functional Identifier Code](HC), 
           AN.value[ E142: Application's Sender Code](SENDERID), 
           AN.value[ E124: Application Receiver's Code](RECEIVERID), 
           DT.value[ E373: Date](2001-01-22), 
           TM.value[ E337: Time](13:10:ss), 
           Nn.value[  E28: Group Control Number](1.0), 
           ID.value[ E455: Responsible Agency Code](X), 
           AN.value[ E480: Version / Release / Identifier Code](005010X222)), 
         TransactionSetVal[HC837](
           TableVal[Table 1 - Header](
             SegmentVal[ST: Transaction Set Header](
               ID.value[ E143: Transaction Set Identifier Code](837), 
               ID.value[ E329: Transaction Set Control Number](1234), 
               AN.value[E1705: Implementation Guide Version Name](005010X222)),
             SegmentVal[BHT: Beginning of Hierarchical Transaction](
               ID.value[E1005: Hierarchical Structure Code](0019), 
               ID.value[ E353: Transaction Set Purpose Code](00), 
               AN.value[ E127: Originator Application Transaction Identifier](0123), 
               DT.value[ E373: Transaction Set Creation Date](1998-10-15), 
               TM.value[ E337: Transaction Set Creation Time](10:23:ss), 
               ID.value[ E640: Claim or Encounter Identifier](CH)),
             LoopVal[1000A SUBMITTER NAME](
               SegmentVal[NM1: Submitter Name](
                 ID.value[  E98: Entity Identifier Code](41), 
                 ID.value[E1065: Entity Type Qualifier](2), 
                 AN.value[E1035: Submitter Last or Organization Name](PREMIER BILLING SERVICE), 
                 AN.empty[E1036: Submitter First Name], 
                 AN.empty[E1037: Submitter Middle Name or Initial], 
                 AN.empty[E1038: Name Prefix], 
                 AN.empty[E1039: Name Suffix], 
                 ID.value[  E66: Identification Qualifier Code](46), 
                 AN.value[  E67: Submitter Identifier](12EEER000TY), 
                 ID.empty[ E706: Entity Relationship Code], 
                 ID.empty[  E98: Entity Identifier Code], 
                 AN.empty[E1035: Name Last or Organization Name]),
               SegmentVal[PER: Submitter EDI Contact Information](
                 ID.value[ E366: Contact Function Code](IC), 
                 AN.value[  E93: Submitter Contact Name](JERRY), 
                 ID.value[ E365: Communication Number Qualifier](TE), 
                 AN.value[ E364: Communication Number](3055552222), 
                 ID.empty[ E365: Communication Number Qualifier], 
                 AN.empty[ E364: Communication Number], 
                 ID.empty[ E365: Communication Number Qualifier], 
                 AN.empty[ E364: Communication Number], 
                 AN.empty[ E443: Contact Inquiry Reference])),
             LoopVal[1000B RECEIVER NAME](
               SegmentVal[NM1: Receiver Name](
                 ID.value[  E98: Entity Identifier Code](40), 
                 ID.value[E1065: Entity Type Qualifier](2), 
                 AN.value[E1035: Receiver Name](REPRICER XYZ), 
                 AN.empty[E1036: Name First], 
                 AN.empty[E1037: Name Last], 
                 AN.empty[E1038: Name Prefix], 
                 AN.empty[E1039: Name Suffix], 
                 ID.value[  E66: Identification Code Qualifier](46), 
                 AN.value[  E67: Receiver Primary Identifier](66783JJT), 
                 ID.empty[ E706: Entity Relationship Code], 
                 ID.empty[  E98: Entity Identifier Code], 
                 AN.empty[E1035: Name Last or Organization Name]))),
           TableVal[Table 2 - Billing Provider Detail](
             LoopVal[2000A BILLING PROVIDER HIERARCHICAL LEVEL](
               SegmentVal[HL: Billing Provider Hierarchical Level](
                 AN.value[ E628: Hierarchical ID Number](1), 
                 AN.empty[ E734: Hierarchical Parent ID Number], 
                 ID.value[ E735: Hierarchical Level Code](20), 
                 ID.value[ E736: Hierachical Child Code](1)),
               LoopVal[2010AA BILLING PROVIDER NAME](
                 SegmentVal[NM1: Billing Provider Name](
                   ID.value[  E98: Entity Identifier Code](85), 
                   ID.value[E1065: Entity Type Qualifier](2), 
                   AN.value[E1035: Billing Provider Last or Organizational Name](PREMIER BILLING SERVICE), 
                   AN.empty[E1036: Billing Provider First Name], 
                   AN.empty[E1037: Billing Provider Middle Name or Initial], 
                   AN.empty[E1038: Name Prefix], 
                   AN.empty[E1039: Billing Provider Name Suffix], 
                   ID.value[  E66: Identification Code Qualifier](XX), 
                   AN.value[  E67: Billing Provider Identifier](1232343560), 
                   ID.empty[ E706: Entity Relationship Code], 
                   ID.empty[  E98: Entity Identifier Code], 
                   AN.empty[E1035: Name Last or Organization Name]),
                 SegmentVal[N3: Billing Provider Address](
                   AN.value[ E166: Billing Provider Address Line](1234 SEAWAY ST), 
                   AN.empty[ E166: Billing Provider Address Line]),
                 SegmentVal[N4: Billing Provider City, State, ZIP Code](
                   AN.value[  E19: Billing Provider City Name](MIAMI), 
                   ID.value[ E156: Billing Provider State or Province Code](FL), 
                   ID.value[ E116: Billing Provider Postal Zone or ZIP Code](331111234), 
                   ID.empty[  E26: Country Code], 
                   ID.empty[ E309: Location Qualifier], 
                   ID.empty[ E310: Location Identifier], 
                   ID.empty[E1715: Country Subdivision Code]),
                 SegmentVal[REF: Billing Provider Tax Identification](
                   ID.value[ E128: Reference Identification Qualifier](EI), 
                   AN.value[ E127: Billing Provider Tax Identification Number](123667894), 
                   AN.empty[ E352: Description], 
                   CompositeElementVal[C040: REFERENCE IDENTIFIER].empty),
                 SegmentVal[PER: Billing Provider Contact Information](
                   ID.value[ E366: Contact Function Code](IC), 
                   AN.value[  E93: Billing Provider Contact Name](CONNIE), 
                   ID.value[ E365: Communication Number Qualifier](TE), 
                   AN.value[ E364: Communication Number](3055551234), 
                   ID.empty[ E365: Communication Number Qualifier], 
                   AN.empty[ E364: Communication Number], 
                   ID.empty[ E365: Communication Number Qualifier], 
                   AN.empty[ E364: Communication Number], 
                   AN.empty[ E443: Contact Inquiry Reference])),
               LoopVal[2010AB PAY-TO ADDRESS NAME](
                 SegmentVal[NM1: Pay-to Address Name](
                   ID.value[  E98: Entity Identifier Code](87), 
                   ID.value[E1065: Entity Type Qualifier](2), 
                   AN.empty[E1035: Name Last or Organizational Name], 
                   AN.empty[E1036: Name First], 
                   AN.empty[E1037: Name Middle], 
                   AN.empty[E1038: Name Prefix], 
                   AN.empty[E1039: Name Suffix], 
                   ID.empty[  E66: Identification Code Qualifier], 
                   AN.empty[  E67: Identifier Code], 
                   ID.empty[ E706: Entity Relationship Code], 
                   ID.empty[  E98: Entity Identifier Code], 
                   AN.empty[E1035: Name Last or Organization Name]),
                 SegmentVal[N3: Pay-to Address - ADDRESS](
                   AN.value[ E166: Pay-To Address Line](2345 OCEAN BLVD), 
                   AN.empty[ E166: Pay-To Address Line]),
                 SegmentVal[N4: Pay-To Address City, State, ZIP Code](
                   AN.value[  E19: Pay-to City Name](MIAMI), 
                   ID.value[ E156: Pay-to State or Province Code](FL), 
                   ID.value[ E116: Pay-to Postal Zone or ZIP Code](33111), 
                   ID.empty[  E26: Country Code], 
                   ID.empty[ E309: Location Qualifier], 
                   ID.empty[ E310: Location Identifier], 
                   ID.empty[E1715: Country Subdivision Code])))),
           TableVal[Table 2 - Subscriber Detail](
             LoopVal[2000B SUBSCRIBER HIERARCHICAL LEVEL](
               SegmentVal[HL: Subscriber Hierarchical Level](
                 AN.value[ E628: Hierarchical ID Number](2), 
                 AN.value[ E734: Hierarchical Parent ID Number](1), 
                 ID.value[ E735: Hierarchical Level Code](22), 
                 ID.value[ E736: Hierachical Child values](0)),
               SegmentVal[SBR: Subscriber Information](
                 ID.value[E1138: Payer Responsibility Sequence Number](S), 
                 ID.value[E1069: Individual Relationship Code](18), 
                 AN.empty[ E127: Subscriber Group or Policy Number], 
                 AN.empty[  E93: Subscriber Group Name], 
                 ID.value[E1336: Insurance Type Code](12), 
                 ID.empty[E1143: Coordination of Benefits Code], 
                 ID.empty[E1073: Yes/No Condition or Response Code], 
                 ID.empty[ E584: Employment Status Code], 
                 ID.value[E1032: Claim Filing Indicator Code](MB)),
               LoopVal[2010BA SUBSCRIBER NAME](
                 SegmentVal[NM1: Subscriber Name](
                   ID.value[  E98: Entity Identifier Code](IL), 
                   ID.value[E1065: Entity Type Qualifier](1), 
                   AN.value[E1035: Subscriber Last Name](SMITH), 
                   AN.value[E1036: Subscriber First Name](JACK), 
                   AN.empty[E1037: Subscriber Middle Name or Initial], 
                   AN.empty[E1038: Name Prefix], 
                   AN.empty[E1039: Subscriber Name Suffix], 
                   ID.value[  E66: Identification Code Qualifier](MI), 
                   AN.value[  E67: Subscriber Primary Identifier](222334444), 
                   ID.empty[ E706: Entity Relationship Code], 
                   ID.empty[  E98: Entity Identifier Code], 
                   AN.empty[E1035: Name Last or Organization Name]),
                 SegmentVal[N3: Subscriber Address](
                   AN.value[ E166: Subscriber Address Line](236 N MAIN ST), 
                   AN.empty[ E166: Subscriber Address Line]),
                 SegmentVal[N4: Subscriber City, State, ZIP Code](
                   AN.value[  E19: Subscriber City Name](MIAMI), 
                   ID.value[ E156: Subscriber State Code](FL), 
                   ID.value[ E116: Subscriber Postal Zone or ZIP Code](33413), 
                   ID.empty[  E26: Country Code], 
                   ID.empty[ E309: Location Qualifier], 
                   ID.empty[ E310: Location Identifier], 
                   ID.empty[E1715: Country Subdivision Code]),
                 SegmentVal[DMG: Subscriber Demographic Information](
                   ID.value[E1250: Date Time Period Format Qualifier](D8), 
                   AN.value[E1251: Subscriber Birth Date](19431022), 
                   ID.value[E1068: Subscriber Gender Code](M), 
                   ID.empty[E1067: Marital Status Code], 
                   CompositeElementVal[C056: COMPOSITE RACE OR ETHNICITY INFORMATION].empty, 
                   ID.empty[E1066: Citizenship Status Code], 
                   ID.empty[  E26: Country Code], 
                   ID.empty[ E659: Basis of Verification Code], 
                    R.empty[ E380: Quantity], 
                   ID.empty[E1270: Code List Qualifier Code], 
                   AN.empty[E1271: Industry Code])),
               LoopVal[2010BB PAYER NAME](
                 SegmentVal[NM1: Payer Name](
                   ID.value[  E98: Entity Identifier Code](PR), 
                   ID.value[E1065: Entity Type Qualifier](2), 
                   AN.value[E1035: Payer Name](MEDICARE), 
                   AN.empty[E1036: Name Last], 
                   AN.empty[E1037: Name Middle], 
                   AN.empty[E1038: Name Prefix], 
                   AN.empty[E1039: Name Suffix], 
                   ID.value[  E66: Identification Code Qualifier](PI), 
                   AN.value[  E67: Payer Identification](111223333), 
                   ID.empty[ E706: Entity Relationship Code], 
                   ID.empty[  E98: Entity Identifier Code], 
                   AN.empty[E1035: Name Last or Organization Name]),
                 SegmentVal[N3: Payer Address](
                   AN.value[ E166: Payer Address Line](4456 SOUTH SHORE BLVD), 
                   AN.empty[ E166: Payer Address Line]),
                 SegmentVal[N4: Payer City, State, ZIP Code](
                   AN.value[  E19: Payer City Name](CHICAGO), 
                   ID.value[ E156: Payer State or Province Code](IL), 
                   ID.value[ E116: Payer Postal Zone or ZIP Code](60601), 
                   ID.empty[  E26: Country Code], 
                   ID.empty[ E309: Location Qualifier], 
                   ID.empty[ E310: Location Identifier], 
                   ID.empty[E1715: Country Subdivision Code])),
               LoopVal[2300 CLAIM INFORMATION](
                 SegmentVal[CLM: Claim Information](
                   AN.value[E1028: Patient Control Number](26407789), 
                    R.value[ E782: Total Claim Charge Amount](79.04), 
                   ID.empty[E1032: Claim Filing Indicator Code], 
                   ID.empty[E1343: Non-Institutional Claim Type Code], 
                   CompositeElementVal[C023: HEALTH CARE SERVICE LOCATION INFORMATION](
                     AN.value[E1331: Place of Service Code](11), 
                     ID.value[E1332: Facility Code Qualifier](B), 
                     ID.value[E1325: Claim Frequency Code](1)), 
                   ID.value[E1073: Provider or Supplier Signature Indicator](Y), 
                   ID.value[E1359: Assignment or Plan Participation Code](A), 
                   ID.value[E1073: Benefits Assignment Certification Indicator](Y), 
                   ID.value[E1363: Release of Information Code](Y), 
                   ID.value[E1351: Patient Signature Source Code](P), 
                   CompositeElementVal[C024: RELATED CAUSES INFORMATION].empty, 
                   ID.empty[E1366: Special Program Indicator], 
                   ID.empty[E1073: Yes/No Condition or Response Code], 
                   ID.empty[E1338: Level of Service Code], 
                   ID.empty[E1073: Yes/No Condition or Response Code], 
                   ID.empty[E1360: Provider Agreement Code], 
                   ID.empty[E1029: Claim Status Code], 
                   ID.empty[E1073: Yes/No Condition or Response Code], 
                   ID.empty[E1383: Claim Submission Reason Code], 
                   ID.empty[E1514: Delay Reason Code]),
                 SegmentVal[HI: Health Care Diagnosis Code](
                   CompositeElementVal[C022: HEALTH CARE CODE INFORMATION](
                     ID.value[E1270: Code List Qualifier](BK), 
                     AN.value[E1271: Diagnosis Code](4779), 
                     ID.empty[E1250: Date Time Period Format Qualifier], 
                     AN.empty[E1251: Date Time Period], 
                      R.empty[ E782: Monetary Amount], 
                      R.empty[ E380: Quantity], 
                     AN.empty[ E799: Version Identifier], 
                     AN.empty[E1271: Industry Code], 
                     ID.empty[E1073: Yes/No Condition or Response Code]), 
                   CompositeElementVal[C022: HEALTH CARE CODE INFORMATION](
                     ID.value[E1270: Code List Qualifier](BF), 
                     AN.value[E1271: Diagnosis Code](2724), 
                     ID.empty[E1250: Date Time Period Format Qualifier], 
                     AN.empty[E1251: Date Time Period], 
                      R.empty[ E782: Monetary Amount], 
                      R.empty[ E380: Quantity], 
                     AN.empty[ E799: Version Identifier], 
                     AN.empty[E1271: Industry Code], 
                     ID.empty[E1073: Yes/No Condition or Response Code]), 
                   CompositeElementVal[C022: HEALTH CARE CODE INFORMATION](
                     ID.value[E1270: Code List Qualifier](BF), 
                     AN.value[E1271: Diagnosis Code](53081), 
                     ID.empty[E1250: Date Time Period Format Qualifier], 
                     AN.empty[E1251: Date Time Period], 
                      R.empty[ E782: Monetary Amount], 
                      R.empty[ E380: Quantity], 
                     AN.empty[ E799: Version Identifier], 
                     AN.empty[E1271: Industry Code], 
                     ID.empty[E1073: Yes/No Condition or Response Code]), 
                   CompositeElementVal[C022: HEALTH CARE CODE INFORMATION].empty, 
                   CompositeElementVal[C022: HEALTH CARE CODE INFORMATION].empty, 
                   CompositeElementVal[C022: HEALTH CARE CODE INFORMATION].empty, 
                   CompositeElementVal[C022: HEALTH CARE CODE INFORMATION].empty, 
                   CompositeElementVal[C022: HEALTH CARE CODE INFORMATION].empty, 
                   CompositeElementVal[C022: HEALTH CARE CODE INFORMATION].empty, 
                   CompositeElementVal[C022: HEALTH CARE CODE INFORMATION].empty, 
                   CompositeElementVal[C022: HEALTH CARE CODE INFORMATION].empty, 
                   CompositeElementVal[C022: HEALTH CARE CODE INFORMATION].empty),
                 LoopVal[2310B RENDERING PROVIDER NAME](
                   SegmentVal[NM1: Rendering Provider Name](
                     ID.value[  E98: Entity Identifier Code](82), 
                     ID.value[E1065: Entity Type Qualifier](1), 
                     AN.value[E1035: Rendering Provider Last Name](KILDARE), 
                     AN.value[E1036: Rendering Provider First Name](BEN), 
                     AN.empty[E1037: Rendering Provider Middle Name or Initial], 
                     AN.empty[E1038: Name Prefix], 
                     AN.empty[E1039: Rendering Provider Name Suffix], 
                     ID.value[  E66: Identification Code Qualifier](XX), 
                     AN.value[  E67: Rendering Provider Identifier](1999996667), 
                     ID.empty[ E706: Entity Relationship Code], 
                     ID.empty[  E98: Entity Identifier Code], 
                     AN.empty[E1035: Name Last or Organization Name]),
                   SegmentVal[PRV: Rendering Provider Specialty Information](
                     ID.value[E1221: Provider Code](PE), 
                     ID.value[ E128: Reference Identification Qualifier](PXC), 
                     AN.value[ E127: Provider Taxonomy Code](364SP2800X), 
                     ID.empty[ E156: State or Province Code], 
                     CompositeElementVal[C035: PROVIDER SPECIALTY INFORMATION].empty, 
                     ID.empty[E1223: Provider Organization Code])),
                 LoopVal[2320 OTHER SUBSCRIBER INFORMATION](
                   SegmentVal[SBR: Other Subscriber Information](
                     ID.value[E1138: Payer Responsibility Sequence Number](P), 
                     ID.value[E1069: Individual Relationship Code](G8), 
                     AN.empty[ E127: Insured Group or Policy Number], 
                     AN.empty[  E93: Other Insured Group Name], 
                     ID.empty[E1336: Insurance Type Code], 
                     ID.empty[E1143: Coordination of Benefits Code], 
                     ID.empty[E1073: Yes/No Condition or Response Code], 
                     ID.empty[ E584: Employment Status Code], 
                     ID.value[E1032: Claim Filing Indicator Code](CI)),
                   SegmentVal[CAS: Claim Level Adjustments](
                     ID.value[E1033: Claim Adjustment Group Code](PR), 
                     ID.value[E1034: Adjustment Reason Code](1), 
                      R.value[ E782: Adjustment Amount](21.89), 
                      R.empty[ E380: Adjustment Quantity], 
                     ID.value[E1034: Adjustment Reason Code](3), 
                      R.value[ E782: Adjustment Amount](15.0), 
                      R.empty[ E380: Adjustment Quantity], 
                     ID.empty[E1034: Adjustment Reason Code], 
                      R.empty[ E782: Adjustment Amount], 
                      R.empty[ E380: Adjustment Quantity], 
                     ID.empty[E1034: Adjustment Reason Code], 
                      R.empty[ E782: Adjustment Amount], 
                      R.empty[ E380: Adjustment Quantity], 
                     ID.empty[E1034: Adjustment Reason Code], 
                      R.empty[ E782: Adjustment Amount], 
                      R.empty[ E380: Adjustment Quantity], 
                     ID.empty[E1034: Adjustment Reason Code], 
                      R.empty[ E782: Adjustment Amount], 
                      R.empty[ E380: Adjustment Quantity]),
                   SegmentVal[AMT: Coordination of Benefits (COB) Payer Paid Amount](
                     ID.value[ E522: Amount Qualifier Code](D), 
                      R.value[ E782: Payer Paid Amount](34.15), 
                     ID.empty[ E478: Credit/Debit Flag]),
                   SegmentVal[OI: Other Insurance Coverage Information](
                     ID.empty[E1032: Claim Filing Indicator Code], 
                     ID.empty[E1383: Claim Submission Reason Code], 
                     ID.value[E1073: Benefits Assignment Certification Indicator](Y), 
                     ID.value[E1351: Patient Signature Source Code](P), 
                     ID.empty[E1360: Provider Agreement Code], 
                     ID.value[E1363: Release of Information Code](Y)),
                   LoopVal[2330A OTHER SUBSCRIBER NAME](
                     SegmentVal[NM1: Other Subscriber Name](
                       ID.value[  E98: Entity Identifier Code](IL), 
                       ID.value[E1065: Entity Type Qualifier](1), 
                       AN.value[E1035: Other Insured Last Name](SMITH), 
                       AN.value[E1036: Other Insured First Name](JANE), 
                       AN.empty[E1037: Other Insured Middle Name], 
                       AN.empty[E1038: Name Prefix], 
                       AN.empty[E1039: Other Insured Name Suffix], 
                       ID.value[  E66: Identification Code Qualifier](MI), 
                       AN.value[  E67: Other Insured Identifier](JS00111223333), 
                       ID.empty[ E706: Entity Relationship Code], 
                       ID.empty[  E98: Entity Identifier Code], 
                       AN.empty[E1035: Name Last or Organization Name]),
                     SegmentVal[N3: Other Subscriber Address](
                       AN.value[ E166: Other Subscriber Address Line](236 N MAIN ST), 
                       AN.empty[ E166: Other Subscriber Address Line]),
                     SegmentVal[N4: Other Subscriber City, State, ZIP Code](
                       AN.value[  E19: Other Subscriber City Name](MIAMI), 
                       ID.value[ E156: Other Subscriber State or Province Code](FL), 
                       ID.value[ E116: Other Subscriber Postal Zone or ZIP Code](33111), 
                       ID.empty[  E26: Country Code], 
                       ID.empty[ E309: Location Qualifier], 
                       ID.empty[ E310: Location Identifier], 
                       ID.empty[E1715: Country Subdivision Code])),
                   LoopVal[2330B OTHER PAYER NAME](
                     SegmentVal[NM1: Other Payer Name](
                       ID.value[  E98: Entity Identifier Code](PR), 
                       ID.value[E1065: Entity Type Qualifier](2), 
                       AN.value[E1035: Other Payer Organization Name](KEY INSURANCE COMPANY), 
                       AN.empty[E1036: Name First], 
                       AN.empty[E1037: Name Middle], 
                       AN.empty[E1038: Name Prefix], 
                       AN.empty[E1039: Name Suffix], 
                       ID.value[  E66: Identification Code Qualifier](PI), 
                       AN.value[  E67: Other Payer Primary Identifier](999996666), 
                       ID.empty[ E706: Entity Relationship Code], 
                       ID.empty[  E98: Entity Identifier Code], 
                       AN.empty[E1035: Name Last or Organization Name]),
                     SegmentVal[N4: Other Payer City, State, ZIP Code](
                       AN.value[  E19: Other Payer City Name](MIAMI), 
                       ID.value[ E156: Other Payer State or Province Code](FL), 
                       ID.value[ E116: Other Payer Postal Zone or ZIP Code](33111), 
                       ID.empty[  E26: Country Code], 
                       ID.empty[ E309: Location Qualifier], 
                       ID.empty[ E310: Location Identifier], 
                       ID.empty[E1715: Country Subdivision Code]))),
                 LoopVal[2400 SERVICE LINE NUMBER](
                   SegmentVal[LX: Service Line Number](
                     Nn.value[ E554: Assigned Number](1.0)),
                   SegmentVal[SV1: Professional Service](
                     CompositeElementVal[C003: COMPOSITE MEDICAL PROCEDURE IDENTIFIER](
                       ID.value[ E235: Product or Service ID Qualifier](HC), 
                       AN.value[ E234: Procedure Code](99213), 
                       AN.empty[E1339: Procedure Modifier], 
                       AN.empty[E1339: Procedure Modifier], 
                       AN.empty[E1339: Procedure Modifier], 
                       AN.empty[E1339: Procedure Modifier], 
                       AN.empty[ E352: Description], 
                       AN.empty[ E234: Product/Service ID]), 
                      R.value[ E782: Line Item Charge Amount](43.0), 
                     ID.value[ E355: Unit or Basis for Measurement Code](UN), 
                      R.value[ E380: Service Unit Count](1.0), 
                     AN.empty[E1331: Place of Service Code], 
                     ID.empty[E1365: Service Type Code], 
                     CompositeElementVal[C004: COMPOSITE DIAGNOSIS CODE POINTER](
                       Nn.value[E1328: Diagnosis Code Pointer](1.0), 
                       Nn.value[E1328: Diagnosis Code Pointer](2.0), 
                       Nn.value[E1328: Diagnosis Code Pointer](3.0), 
                       Nn.empty[E1328: Diagnosis Code Pointer]), 
                      R.empty[ E782: Monetary Amount], 
                     ID.value[E1073: Emergency Indicator](Y), 
                     ID.empty[E1340: Multiple Procedure Code], 
                     ID.empty[E1073: EPSDT Indicator], 
                     ID.empty[E1073: Family Planning Indicator], 
                     ID.empty[E1364: Review Code], 
                     AN.empty[E1341: National or Local Assigned Review Value], 
                     ID.empty[E1327: Co-Pay Status Code], 
                     ID.empty[E1334: Health Care Professional Shortage Area Code], 
                     AN.empty[ E127: Reference Identification], 
                     ID.empty[ E116: Postal Code], 
                      R.empty[ E782: Monetary Amount], 
                     ID.empty[E1337: Level of Care Code], 
                     ID.empty[E1360: Provider Agreement Code]),
                   SegmentVal[DTP: Service Date](
                     ID.value[ E374: Date Time Qualifier](472), 
                     ID.value[E1250: Date Time Period Qualifier](D8), 
                     AN.value[E1251: Service Date](19981003)),
                   LoopVal[2430 LINE ADJUDICATION INFORMATION](
                     SegmentVal[SVD: Line Adjudication Information](
                       AN.value[  E67: Other Payer Primary Identifier](999996666), 
                        R.value[ E782: Service Line Paid Amount](40.0), 
                       CompositeElementVal[C003: COMPOSITE MEDICAL PROCEDURE IDENTIFIER](
                         ID.value[ E235: Product or Service ID Qualifier](HC), 
                         AN.value[ E234: Procedure Code](99213), 
                         AN.empty[E1339: Procedure Modifier], 
                         AN.empty[E1339: Procedure Modifier], 
                         AN.empty[E1339: Procedure Modifier], 
                         AN.empty[E1339: Procedure Modifier], 
                         AN.empty[ E352: Procedure Code Description], 
                         AN.empty[ E234: Product/Service ID]), 
                       AN.empty[ E234: Product/Service ID], 
                        R.value[ E380: Paid Service Unit Count](1.0), 
                       Nn.empty[ E554: Bundled or Unbundled Line Number]),
                     SegmentVal[CAS: Line Adjustment](
                       ID.value[E1033: Claim Adjustment Group Code](CO), 
                       ID.value[E1034: Adjustment Reason Code](42), 
                        R.value[ E782: Adjustment Amount](3.0), 
                        R.empty[ E380: Adjustment Quantity], 
                       ID.empty[E1034: Adjustment Reason Code], 
                        R.empty[ E782: Adjustment Amount], 
                        R.empty[ E380: Adjustment Quantity], 
                       ID.empty[E1034: Adjustment Reason Code], 
                        R.empty[ E782: Adjustment Amount], 
                        R.empty[ E380: Adjustment Quantity], 
                       ID.empty[E1034: Adjustment Reason Code], 
                        R.empty[ E782: Adjustment Amount], 
                        R.empty[ E380: Adjustment Quantity], 
                       ID.empty[E1034: Adjustment Reason Code], 
                        R.empty[ E782: Adjustment Amount], 
                        R.empty[ E380: Adjustment Quantity], 
                       ID.empty[E1034: Adjustment Reason Code], 
                        R.empty[ E782: Adjustment Amount], 
                        R.empty[ E380: Adjustment Quantity]),
                     SegmentVal[DTP: Line Check or Remittance Date](
                       ID.value[ E374: Date Time Qualifier](573), 
                       ID.value[E1250: Date Time Period Format Qualifier](D8), 
                       AN.value[E1251: Adjudication or Payment Date](19981015)))),
                 LoopVal[2400 SERVICE LINE NUMBER](
                   SegmentVal[LX: Service Line Number](
                     Nn.value[ E554: Assigned Number](2.0)),
                   SegmentVal[SV1: Professional Service](
                     CompositeElementVal[C003: COMPOSITE MEDICAL PROCEDURE IDENTIFIER](
                       ID.value[ E235: Product or Service ID Qualifier](HC), 
                       AN.value[ E234: Procedure Code](90782), 
                       AN.empty[E1339: Procedure Modifier], 
                       AN.empty[E1339: Procedure Modifier], 
                       AN.empty[E1339: Procedure Modifier], 
                       AN.empty[E1339: Procedure Modifier], 
                       AN.empty[ E352: Description], 
                       AN.empty[ E234: Product/Service ID]), 
                      R.value[ E782: Line Item Charge Amount](15.0), 
                     ID.value[ E355: Unit or Basis for Measurement Code](UN), 
                      R.value[ E380: Service Unit Count](1.0), 
                     AN.empty[E1331: Place of Service Code], 
                     ID.empty[E1365: Service Type Code], 
                     CompositeElementVal[C004: COMPOSITE DIAGNOSIS CODE POINTER](
                       Nn.value[E1328: Diagnosis Code Pointer](1.0), 
                       Nn.value[E1328: Diagnosis Code Pointer](2.0), 
                       Nn.empty[E1328: Diagnosis Code Pointer], 
                       Nn.empty[E1328: Diagnosis Code Pointer]), 
                      R.empty[ E782: Monetary Amount], 
                     ID.value[E1073: Emergency Indicator](Y), 
                     ID.empty[E1340: Multiple Procedure Code], 
                     ID.empty[E1073: EPSDT Indicator], 
                     ID.empty[E1073: Family Planning Indicator], 
                     ID.empty[E1364: Review Code], 
                     AN.empty[E1341: National or Local Assigned Review Value], 
                     ID.empty[E1327: Co-Pay Status Code], 
                     ID.empty[E1334: Health Care Professional Shortage Area Code], 
                     AN.empty[ E127: Reference Identification], 
                     ID.empty[ E116: Postal Code], 
                      R.empty[ E782: Monetary Amount], 
                     ID.empty[E1337: Level of Care Code], 
                     ID.empty[E1360: Provider Agreement Code]),
                   SegmentVal[DTP: Service Date](
                     ID.value[ E374: Date Time Qualifier](472), 
                     ID.value[E1250: Date Time Period Qualifier](D8), 
                     AN.value[E1251: Service Date](19971003)),
                   LoopVal[2430 LINE ADJUDICATION INFORMATION](
                     SegmentVal[SVD: Line Adjudication Information](
                       AN.value[  E67: Other Payer Primary Identifier](999996666), 
                        R.value[ E782: Service Line Paid Amount](10.0), 
                       CompositeElementVal[C003: COMPOSITE MEDICAL PROCEDURE IDENTIFIER](
                         ID.value[ E235: Product or Service ID Qualifier](HC), 
                         AN.value[ E234: Procedure Code](99213), 
                         AN.empty[E1339: Procedure Modifier], 
                         AN.empty[E1339: Procedure Modifier], 
                         AN.empty[E1339: Procedure Modifier], 
                         AN.empty[E1339: Procedure Modifier], 
                         AN.empty[ E352: Procedure Code Description], 
                         AN.empty[ E234: Product/Service ID]), 
                       AN.empty[ E234: Product/Service ID], 
                        R.value[ E380: Paid Service Unit Count](1.0), 
                       Nn.empty[ E554: Bundled or Unbundled Line Number]),
                     SegmentVal[CAS: Line Adjustment](
                       ID.value[E1033: Claim Adjustment Group Code](CO), 
                       ID.value[E1034: Adjustment Reason Code](42), 
                        R.value[ E782: Adjustment Amount](5.0), 
                        R.empty[ E380: Adjustment Quantity], 
                       ID.empty[E1034: Adjustment Reason Code], 
                        R.empty[ E782: Adjustment Amount], 
                        R.empty[ E380: Adjustment Quantity], 
                       ID.empty[E1034: Adjustment Reason Code], 
                        R.empty[ E782: Adjustment Amount], 
                        R.empty[ E380: Adjustment Quantity], 
                       ID.empty[E1034: Adjustment Reason Code], 
                        R.empty[ E782: Adjustment Amount], 
                        R.empty[ E380: Adjustment Quantity], 
                       ID.empty[E1034: Adjustment Reason Code], 
                        R.empty[ E782: Adjustment Amount], 
                        R.empty[ E380: Adjustment Quantity], 
                       ID.empty[E1034: Adjustment Reason Code], 
                        R.empty[ E782: Adjustment Amount], 
                        R.empty[ E380: Adjustment Quantity]),
                     SegmentVal[DTP: Line Check or Remittance Date](
                       ID.value[ E374: Date Time Qualifier](573), 
                       ID.value[E1250: Date Time Period Format Qualifier](D8), 
                       AN.value[E1251: Adjudication or Payment Date](19981014)))),
                 LoopVal[2400 SERVICE LINE NUMBER](
                   SegmentVal[LX: Service Line Number](
                     Nn.value[ E554: Assigned Number](3.0)),
                   SegmentVal[SV1: Professional Service](
                     CompositeElementVal[C003: COMPOSITE MEDICAL PROCEDURE IDENTIFIER](
                       ID.value[ E235: Product or Service ID Qualifier](HC), 
                       AN.value[ E234: Procedure Code](J3301), 
                       AN.empty[E1339: Procedure Modifier], 
                       AN.empty[E1339: Procedure Modifier], 
                       AN.empty[E1339: Procedure Modifier], 
                       AN.empty[E1339: Procedure Modifier], 
                       AN.empty[ E352: Description], 
                       AN.empty[ E234: Product/Service ID]), 
                      R.value[ E782: Line Item Charge Amount](21.04), 
                     ID.value[ E355: Unit or Basis for Measurement Code](UN), 
                      R.value[ E380: Service Unit Count](1.0), 
                     AN.empty[E1331: Place of Service Code], 
                     ID.empty[E1365: Service Type Code], 
                     CompositeElementVal[C004: COMPOSITE DIAGNOSIS CODE POINTER](
                       Nn.value[E1328: Diagnosis Code Pointer](1.0), 
                       Nn.value[E1328: Diagnosis Code Pointer](2.0), 
                       Nn.empty[E1328: Diagnosis Code Pointer], 
                       Nn.empty[E1328: Diagnosis Code Pointer]), 
                      R.empty[ E782: Monetary Amount], 
                     ID.value[E1073: Emergency Indicator](Y), 
                     ID.empty[E1340: Multiple Procedure Code], 
                     ID.empty[E1073: EPSDT Indicator], 
                     ID.empty[E1073: Family Planning Indicator], 
                     ID.empty[E1364: Review Code], 
                     AN.empty[E1341: National or Local Assigned Review Value], 
                     ID.empty[E1327: Co-Pay Status Code], 
                     ID.empty[E1334: Health Care Professional Shortage Area Code], 
                     AN.empty[ E127: Reference Identification], 
                     ID.empty[ E116: Postal Code], 
                      R.empty[ E782: Monetary Amount], 
                     ID.empty[E1337: Level of Care Code], 
                     ID.empty[E1360: Provider Agreement Code]),
                   SegmentVal[DTP: Service Date](
                     ID.value[ E374: Date Time Qualifier](472), 
                     ID.value[E1250: Date Time Period Qualifier](D8), 
                     AN.value[E1251: Service Date](19971003)))))),
           TableVal[Table 3 - Summary](
             SegmentVal[SE: Transaction Set Trailer](
               Nn.value[  E96: Number of Included Segments](52.0), 
               ID.value[ E329: Transaction Set Control Number](1234)))), 
         SegmentVal[GE: Functional Group Trailer](
           Nn.value[  E97: Number of Transaction Sets Included](1.0), 
           Nn.value[  E28: Group Control Number](1.0))), 
       SegmentVal[IEA: Interchange Control Trailer](
         Nn.value[  I16: Number of Included Functional Groups](1.0), 
         Nn.value[  I12: Interchange Control Number](905.0))))]>
