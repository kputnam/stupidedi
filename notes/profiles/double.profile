Thread ID: -608470138
Total Time: 0.82

  %total   %self     total      self      wait     child            calls   Name
--------------------------------------------------------------------------------
 100.00%   0.00%      0.82      0.00      0.00      0.82                1     Global#[No method]
                      0.82      0.00      0.00      0.82              1/1     Stupidedi::Builder_::StateMachine#read!
--------------------------------------------------------------------------------
                      0.82      0.00      0.00      0.82              1/1     Global#[No method]
 100.00%   0.00%      0.82      0.00      0.00      0.82                1     Stupidedi::Builder_::StateMachine#read!
                      0.59      0.00      0.00      0.59         225/3106     Stupidedi::Either::Success#flatmap
                      0.23      0.00      0.00      0.23         224/1328     Stupidedi::Either::Success#map
                      0.00      0.00      0.00      0.00             4/48     Class#inherited
                      0.00      0.00      0.00      0.00             2/53     Kernel#singleton_method_added
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Either::Failure#defined?
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Either::Failure#map
                      0.00      0.00      0.00      0.00             3/22     Object#eigenclass
                      0.00      0.00      0.00      0.00           25/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00           1/3106     <Class::Stupidedi::Either>#success
                      0.00      0.00      0.00      0.00              1/2     Module#attr_accessor
                      0.00      0.00      0.00      0.00             8/11     Module#abstract
                      0.00      0.00      0.00      0.00          225/225     Stupidedi::Either::Success#defined?
                      0.00      0.00      0.00      0.00             3/26     Kernel#send
                      0.00      0.00      0.00      0.00          226/226     Stupidedi::Builder_::StateMachine#stuck?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         104/3106     Stupidedi::Reader::TokenReader#read_component_elements
                      0.00      0.00      0.00      0.00        1427/3106     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00          48/3106     Stupidedi::Reader::TokenReader#read_composite_element
                      0.00      0.00      0.00      0.00        1048/3106     Stupidedi::Reader::TokenReader#read_elements
                      0.00      0.00      0.00      0.00           1/3106     Stupidedi::Reader::StreamReader#read_segment
                      0.00      0.00      0.00      0.00          30/3106     Integer#times
                      0.00      0.00      0.00      0.00         223/3106     Stupidedi::Reader::TokenReader#read_segment
                      0.59      0.00      0.00      0.59         225/3106     Stupidedi::Builder_::StateMachine#read!
  71.95%   0.00%      0.59      0.00      0.00      0.59             3106     Stupidedi::Either::Success#flatmap
                      0.57      0.00      0.00      0.57          224/224     Stupidedi::Reader::TokenReader#read_segment
                      0.39      0.00      0.00      0.39        1048/1048     Stupidedi::Reader::TokenReader#read_elements
                      0.13      0.03      0.00      0.10        1423/1423     Stupidedi::Reader::TokenReader#read_delimiter
                      0.06      0.00      0.00      0.06          223/233     Stupidedi::Reader::SegmentDict::NonEmpty#defined_at?
                      0.03      0.00      0.00      0.03        1104/1328     Stupidedi::Either::Success#map
                      0.03      0.00      0.00      0.03          219/223     Stupidedi::Reader::SegmentDict::NonEmpty#at
                      0.01      0.00      0.00      0.01              1/1     Stupidedi::Reader::StreamReader#read_segment
                      0.01      0.00      0.00      0.01            48/48     Stupidedi::Reader::TokenReader#composite
                      0.01      0.00      0.00      0.01            15/15     Symbol#call
                      0.01      0.00      0.00      0.01             1/16     Integer#times
                      0.01      0.01      0.00      0.00        3106/4712     Kernel#is_a?
                      0.01      0.01      0.00      0.00         319/3085     Stupidedi::Reader::TokenReader#result
                      0.00      0.00      0.00      0.00              1/3     Module#private
                      0.00      0.00      0.00      0.00              2/2     Stupidedi::Reader::StreamReader#read_character
                      0.00      0.00      0.00      0.00              1/3     Stupidedi::Reader::StreamReader#result
                      0.00      0.00      0.00      0.00          825/843     Array#tail
                      0.00      0.00      0.00      0.00            2/274     OpenStruct#method_missing
                      0.00      0.00      0.00      0.00       2504/19422     Kernel#===
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Reader::TokenReader#read_character
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Reader::TokenReader#stream
                      0.00      0.00      0.00      0.00            15/15     Stupidedi::Reader::TokenReader#consume_prefix
                      0.00      0.00      0.00      0.00          16/1462     Array#<<
                      0.00      0.00      0.00      0.00             1/53     Kernel#singleton_method_added
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Either::Success#or
                      0.00      0.00      0.00      0.00             2/48     Class#inherited
                      0.00      0.00      0.00      0.00           15/116     Unknown#element
                      0.00      0.00      0.00      0.00           31/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00             6/62     Module#attr_reader
                      0.00      0.00      0.00      0.00           1/3106     <Class::Stupidedi::Either>#success
                      0.00      0.00      0.00      0.00              1/2     Module#attr_accessor
                      0.00      0.00      0.00      0.00          5/23624     Class#new
                      0.00      0.00      0.00      0.00          1/41326     String#==
                      0.00      0.00      0.00      0.00          1/23479     <Class::Object>#allocate
                      0.00      0.00      0.00      0.00         271/1317     Object#cons
                      0.00      0.00      0.00      0.00        1427/3106     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00           56/104     Stupidedi::Reader::TokenReader#read_component_elements
--------------------------------------------------------------------------------
                      0.57      0.00      0.00      0.57          224/224     Stupidedi::Either::Success#flatmap
  69.51%   0.00%      0.57      0.00      0.00      0.57              224     Stupidedi::Reader::TokenReader#read_segment
                      0.06      0.00      0.00      0.06          224/224     Stupidedi::Reader::TokenReader#read_segment_id
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Either::Failure#flatmap
                      0.00      0.00      0.00      0.00         223/3106     Stupidedi::Either::Success#flatmap
--------------------------------------------------------------------------------
                      0.39      0.00      0.00      0.39        1048/1048     Stupidedi::Either::Success#flatmap
  47.56%   0.00%      0.39      0.00      0.00      0.39             1048     Stupidedi::Reader::TokenReader#read_elements
                      0.21      0.04      0.00      0.17        1000/1015     Stupidedi::Reader::TokenReader#read_simple_element
                      0.04      0.00      0.00      0.04            48/48     Stupidedi::Reader::TokenReader#read_composite_element
                      0.01      0.01      0.00      0.00        1016/1154     Stupidedi::Schema::ElementUse#composite?
                      0.00      0.00      0.00      0.00        1016/1080     Stupidedi::Schema::RepeatCount::Bounded#include?
                      0.00      0.00      0.00      0.00        2032/2256     Array#head
                      0.00      0.00      0.00      0.00        1048/3923     Array#empty?
                      0.00      0.00      0.00      0.00        1048/3106     Stupidedi::Either::Success#flatmap
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          38/1944     <Class::Stupidedi::Builder_::AbstractState>#lsequence
                      0.00      0.00      0.00      0.00         412/1944     Array#each
                      0.00      0.00      0.00      0.00          18/1944     Stupidedi::Builder_::ConstraintTable::ValueBased#build_disjoint
                      0.00      0.00      0.00      0.00           1/1944     Enumerable#inject
                      0.00      0.00      0.00      0.00          68/1944     Stupidedi::Builder_::ConstraintTable::ValueBased#matches
                      0.00      0.00      0.00      0.00           2/1944     <Class::Stupidedi::Builder_::AbstractState>#tsequence
                      0.00      0.02      0.00      0.00         245/1944     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
                      0.00      0.00      0.00      0.00         114/1944     Range#each
                      0.00      0.00      0.00      0.00          15/1944     Stupidedi::Builder_::ConstraintTable::ValueBased#deepest
                      0.00      0.00      0.00      0.00           4/1944     Module#delegate
                      0.00      0.00      0.00      0.00         125/1944     Integer#times
                      0.00      0.00      0.00      0.00          61/1944     <Class::Stupidedi::Builder_::AbstractState>#sequence
                      0.00      0.00      0.00      0.00          43/1944     Stupidedi::Builder_::InstructionTable::NonEmpty#successors
                      0.06      0.03      0.00      0.03         574/1944     Enumerable#any?
                      0.23      0.00      0.00      0.23         224/1944     Stupidedi::Builder_::StateMachine#input!
  35.37%   6.10%      0.29      0.05      0.00      0.26             1944     Array#each
                      0.09      0.00      0.00      0.09          180/180     Stupidedi::Builder_::LoopState#drop
                      0.05      0.00      0.00      0.05          224/224     Stupidedi::Builder_::InstructionTable::NonEmpty#successors
                      0.04      0.00      0.00      0.04            64/72     <Class::Stupidedi::Builder_::LoopState>#push
                      0.02      0.00      0.00      0.02              4/4     <Class::Stupidedi::Builder_::InterchangeState>#push
                      0.02      0.00      0.00      0.02            16/18     Stupidedi::Builder_::ConstraintTable::ValueBased#build_disjoint
                      0.02      0.02      0.00      0.00      13198/13222     Symbol#to_s
                      0.02      0.00      0.00      0.02            65/65     Stupidedi::AbsoluteSet#each
                      0.01      0.00      0.00      0.01              4/4     <Class::Stupidedi::Builder_::TransactionSetState>#push
                      0.01      0.01      0.00      0.00      13130/41326     String#==
                      0.01      0.00      0.00      0.01          511/511     Stupidedi::AbstractSet#disjoint?
                      0.01      0.00      0.00      0.01            38/71     Stupidedi::Schema::SegmentUse#repeatable?
                      0.01      0.01      0.00      0.00        1832/3102     Kernel#nil?
                      0.01      0.01      0.00      0.00           69/293     Hash#at
                      0.01      0.00      0.00      0.01            12/12     Stupidedi::Builder_::TransactionSetState#drop
                      0.00      0.00      0.00      0.00             7/11     Stupidedi::Builder_::InterchangeState#pop
                      0.00      0.00      0.00      0.00             8/18     Symbol#to_sym
                      0.00      0.00      0.00      0.00           92/432     Stupidedi::Builder_::AbstractState#separators
                      0.00      0.00      0.00      0.00      13130/13738     String#to_s
                      0.00      0.00      0.00      0.00          135/135     Stupidedi::AbsoluteSet#==
                      0.00      0.00      0.00      0.00        179/40586     Fixnum#+
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Builder_::TableState#add
                      0.00      0.00      0.00      0.00          368/368     #<Class:0xb7532b88>#==
                      0.00      0.00      0.00      0.00             8/12     Stupidedi::Builder_::FunctionalGroupState#pop
                      0.00      0.00      0.00      0.00         207/1510     Fixnum#==
                      0.00      0.00      0.00      0.00          290/290     Stupidedi::AbsoluteSet#union
                      0.00      0.00      0.00      0.00            12/16     <Class::Stupidedi::Builder_::TableState>#push
                      0.00      0.00      0.00      0.00              8/8     Stupidedi::Builder_::InterchangeState#drop
                      0.00      0.00      0.00      0.00        1442/1462     Array#<<
                      0.00      0.00      0.00      0.00          196/252     Stupidedi::Builder_::LoopState#pop
                      0.00      0.00      0.00      0.00         940/1360     NilClass#nil?
                      0.00      0.00      0.00      0.00            17/28     Module#class_eval
                      0.00      0.00      0.00      0.00            17/68     String#to_i
                      0.00      0.00      0.00      0.00              3/8     Stupidedi::Schema::LoopDef#repeatable?
                      0.00      0.00      0.00      0.00           59/295     Hash#defined_at?
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Builder_::TransmissionState#drop
                      0.00      0.00      0.00      0.00            7/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Builder_::InterchangeState#add
                      0.00      0.00      0.00      0.00             3/62     Module#attr_reader
                      0.00      0.00      0.00      0.00         412/1944     Array#each
                      0.00      0.00      0.00      0.00            1/169     Enumerable#inject
                      0.00      0.00      0.00      0.00              1/4     Stupidedi::Builder_::TransmissionState#pop
                      0.00      0.00      0.00      0.00              4/4     <Class::Stupidedi::Builder_::FunctionalGroupState>#push
                      0.00      0.00      0.00      0.00          58/1432     Hash#[]=
                      0.00      0.00      0.00      0.00            12/28     Stupidedi::Builder_::TableState#pop
                      0.00      0.00      0.00      0.00          124/124     Stupidedi::Builder_::LoopState#add
                      0.00      0.00      0.00      0.00         850/2113     Hash#[]
                      0.00      0.00      0.00      0.00            14/14     Stupidedi::Schema::TableDef#entry_segment_uses
                      0.00      0.00      0.00      0.00            8/286     Kernel#==
                      0.00      0.00      0.00      0.00            12/12     Stupidedi::Builder_::TableState#drop
                      0.00      0.00      0.00      0.00            59/59     Array#clear
                      0.00      0.00      0.00      0.00          40/7575     Fixnum#-
                      0.00      0.00      0.00      0.00           92/104     Stupidedi::Schema::LoopDef#entry_segment_use
                      0.00      0.00      0.00      0.00             2/53     Kernel#singleton_method_added
                      0.00      0.00      0.00      0.00              8/8     Stupidedi::Builder_::FunctionalGroupState#drop
                      0.00      0.00      0.00      0.00      11471/12115     Fixnum#>
                      0.00      0.00      0.00      0.00          91/1677     Array#length
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Builder_::FunctionalGroupState#add
                      0.00      0.00      0.00      0.00        178/23624     Class#new
                      0.00      0.00      0.00      0.00          12/2793     Stupidedi::Reader::TokenReader#copy
                      0.00      0.00      0.00      0.00            68/68     Stupidedi::Builder_::ConstraintTable::ValueBased#select
                      0.00      0.00      0.00      0.00          523/523     #<Class:0xb7532b88>#union
                      0.00      0.00      0.00      0.00         188/1014     Kernel#eql?
                      0.00      0.00      0.00      0.00         136/2974     Fixnum#zero?
                      0.00      0.00      0.00      0.00         224/3923     Array#empty?
                      0.00      0.00      0.00      0.00           80/340     Stupidedi::Builder_::AbstractState#segment_dict
                      0.00      0.00      0.00      0.00        1220/1471     Array#at
                      0.00      0.00      0.00      0.00             1/48     Class#inherited
                      0.00      0.00      0.00      0.00              3/5     Stupidedi::Schema::TableDef#repeatable?
--------------------------------------------------------------------------------
                      0.03      0.00      0.00      0.03        1104/1328     Stupidedi::Either::Success#flatmap
                      0.23      0.00      0.00      0.23         224/1328     Stupidedi::Builder_::StateMachine#read!
  31.71%   0.00%      0.26      0.00      0.00      0.26             1328     Stupidedi::Either::Success#map
                      0.23      0.00      0.00      0.23          224/224     Stupidedi::Builder_::StateMachine#input!
                      0.03      0.00      0.00      0.03        1104/1104     Stupidedi::Reader::Success#map
                      0.00      0.00      0.00      0.00       1328/23624     Class#new
--------------------------------------------------------------------------------
                      0.23      0.00      0.00      0.23          224/224     Stupidedi::Either::Success#map
  28.05%   0.00%      0.23      0.00      0.00      0.23              224     Stupidedi::Builder_::StateMachine#input!
                      0.23      0.00      0.00      0.23         224/1944     Array#each
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01          15/1015     Kernel#__send__
                      0.21      0.04      0.00      0.17        1000/1015     Stupidedi::Reader::TokenReader#read_elements
  26.83%   4.88%      0.22      0.04      0.00      0.18             1015     Stupidedi::Reader::TokenReader#read_simple_element
                      0.08      0.02      0.00      0.06        1015/2781     Stupidedi::Reader::TokenReader#advance
                      0.02      0.02      0.00      0.00      15212/19422     Kernel#===
                      0.02      0.02      0.00      0.00        1015/3903     Stupidedi::Reader::FileInput#drop
                      0.02      0.02      0.00      0.00        1015/1015     Stupidedi::Reader::TokenReader#simple
                      0.01      0.01      0.00      0.00        4366/7198     Stupidedi::Reader::TokenReader#is_control?
                      0.01      0.01      0.00      0.00        4366/7426     Stupidedi::Reader::FileInput#at
                      0.01      0.01      0.00      0.00       4366/10209     Stupidedi::Reader::FileInput#defined_at?
                      0.01      0.01      0.00      0.00        3351/4210     String#<<
                      0.00      0.00      0.00      0.00        1015/3085     Stupidedi::Reader::TokenReader#result
                      0.00      0.00      0.00      0.00        1015/7575     Fixnum#-
                      0.00      0.00      0.00      0.00          100/116     Unknown#element
                      0.00      0.00      0.00      0.00       4366/40586     Fixnum#+
                      0.00      0.00      0.00      0.00          270/274     OpenStruct#method_missing
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          15/2781     Stupidedi::Reader::TokenReader#consume_prefix
                      0.00      0.00      0.00      0.00           1/2781     Stupidedi::Reader::TokenReader#read_character
                      0.01      0.00      0.00      0.01         104/2781     Stupidedi::Reader::TokenReader#read_component_element
                      0.01      0.01      0.00      0.00         223/2781     Stupidedi::Reader::TokenReader#read_segment_id
                      0.05      0.01      0.00      0.04        1423/2781     Stupidedi::Reader::TokenReader#read_delimiter
                      0.08      0.02      0.00      0.06        1015/2781     Stupidedi::Reader::TokenReader#read_simple_element
  18.29%   4.88%      0.15      0.04      0.00      0.11             2781     Stupidedi::Reader::TokenReader#advance
                      0.07      0.01      0.00      0.06        2781/3903     Stupidedi::Reader::FileInput#drop
                      0.04      0.02      0.00      0.02        2781/2793     Stupidedi::Reader::TokenReader#copy
                      0.00      0.00      0.00      0.00       2781/10209     Stupidedi::Reader::FileInput#defined_at?
                      0.00      0.00      0.00      0.00        2781/7575     Fixnum#-
--------------------------------------------------------------------------------
                      0.13      0.03      0.00      0.10        1423/1423     Stupidedi::Either::Success#flatmap
  15.85%   3.66%      0.13      0.03      0.00      0.10             1423     Stupidedi::Reader::TokenReader#read_delimiter
                      0.05      0.01      0.00      0.04        1423/2781     Stupidedi::Reader::TokenReader#advance
                      0.02      0.00      0.00      0.02        1423/3085     Stupidedi::Reader::TokenReader#result
                      0.01      0.00      0.00      0.01        1423/7198     Stupidedi::Reader::TokenReader#is_control?
                      0.01      0.00      0.00      0.01        1423/3123     Stupidedi::Reader::TokenReader#is_delimiter?
                      0.01      0.00      0.00      0.01        1423/7426     Stupidedi::Reader::FileInput#at
                      0.00      0.00      0.00      0.00       1423/40586     Fixnum#+
                      0.00      0.00      0.00      0.00       1423/10209     Stupidedi::Reader::FileInput#defined_at?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           12/677     <Class::Stupidedi::Builder_::AbstractState>#composite_element
                      0.00      0.00      0.00      0.00           16/677     Stupidedi::Values::CompositeElementVal#initialize
                      0.00      0.00      0.00      0.00           16/677     Stupidedi::Values::TableVal#initialize
                      0.00      0.00      0.00      0.00           80/677     Stupidedi::Values::SegmentVal#initialize
                      0.00      0.00      0.00      0.00           14/677     Stupidedi::Schema::TableDef#entry_segment_uses
                      0.01      0.01      0.00      0.00          218/677     <Class::Stupidedi::Builder_::ConstraintTable>#build
                      0.01      0.00      0.00      0.01           72/677     Stupidedi::Values::LoopVal#initialize
                      0.02      0.00      0.00      0.02           88/677     <Class::Stupidedi::Builder_::AbstractState>#segment
                      0.02      0.00      0.00      0.02           22/677     Stupidedi::Builder_::InstructionTable::NonEmpty#push
                      0.05      0.00      0.00      0.05          139/677     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
  13.41%   1.22%      0.11      0.01      0.00      0.10              677     Array#map
                      0.07      0.03      0.00      0.04        2984/2984     Stupidedi::Builder_::Instruction#copy
                      0.02      0.00      0.00      0.02          572/572     <Class::Stupidedi::Builder_::AbstractState>#element
                      0.01      0.00      0.00      0.01            80/80     Stupidedi::Values::SegmentVal#copy
                      0.01      0.00      0.00      0.01          388/388     Stupidedi::Values::SimpleElementVal#copy
                      0.00      0.00      0.00      0.00           12/104     Stupidedi::Schema::LoopDef#entry_segment_use
                      0.00      0.00      0.00      0.00           28/588     <Class::Stupidedi::Builder_::AbstractState>#simple_element
                      0.00      0.00      0.00      0.00        244/40586     Fixnum#+
                      0.00      0.00      0.00      0.00          455/455     Kernel#object_id
                      0.00      0.00      0.00      0.00         232/1360     NilClass#nil?
                      0.00      0.00      0.00      0.00            16/16     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00          116/116     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00        2740/7575     Fixnum#-
                      0.00      0.00      0.00      0.00          180/180     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00         600/3102     Kernel#nil?
                      0.00      0.00      0.00      0.00          232/232     Stupidedi::Schema::ElementUse#empty
                      0.00      0.00      0.00      0.00            16/16     Stupidedi::Values::CompositeElementVal#copy
                      0.00      0.00      0.00      0.00            20/20     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DecimalVal::NonEmpty#copy
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          1/23624     <Class::Stupidedi::Either>#failure
                      0.00      0.00      0.00      0.00          4/23624     Stupidedi::Reader::Separators#copy
                      0.00      0.00      0.00      0.00         24/23624     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal>#value
                      0.00      0.00      0.00      0.00          8/23624     Stupidedi::Schema::TableDef#empty
                      0.00      0.00      0.00      0.00          1/23624     <Class::Stupidedi::Builder_::TableState>#instructions
                      0.00      0.00      0.00      0.00        280/23624     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal>#value
                      0.00      0.00      0.00      0.00        388/23624     Stupidedi::Values::SimpleElementVal#copy
                      0.00      0.00      0.00      0.00        491/23624     Stupidedi::AbsoluteSet#copy
                      0.00      0.00      0.00      0.00        503/23624     <Class::Stupidedi::Builder_::ConstraintTable>#build
                      0.00      0.00      0.00      0.00          3/23624     Stupidedi::Reader::StreamReader#result
                      0.00      0.00      0.00      0.00          4/23624     Stupidedi::Schema::CompositeElementDef#empty
                      0.00      0.00      0.00      0.00         15/23624     Stupidedi::Builder_::ConstraintTable::ValueBased#deepest
                      0.00      0.00      0.00      0.00          2/23624     #<Class:0xb73af3b0>#push
                      0.00      0.00      0.00      0.00          8/23624     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal>#value
                      0.00      0.00      0.00      0.00          1/23624     Stupidedi::Reader::TokenReader#stream
                      0.00      0.00      0.00      0.00          4/23624     #<Class:0xb7563918>#value
                      0.00      0.00      0.00      0.00          1/23624     Stupidedi::Reader::TokenReader#failure
                      0.00      0.00      0.00      0.00          4/23624     <Class::Stupidedi::Builder_::InterchangeState>#push
                      0.00      0.00      0.00      0.00          8/23624     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal>#empty
                      0.00      0.00      0.00      0.00        240/23624     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal>#value
                      0.00      0.00      0.00      0.00         18/23624     Stupidedi::Builder_::ConstraintTable::ValueBased#build_disjoint
                      0.00      0.00      0.00      0.00        136/23624     Stupidedi::Builder_::LoopState#copy
                      0.00      0.00      0.00      0.00          4/23624     Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeVal#initialize
                      0.00      0.00      0.00      0.00        108/23624     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal>#empty
                      0.00      0.00      0.00      0.00         16/23624     Stupidedi::Values::CompositeElementVal#copy
                      0.00      0.00      0.00      0.00          7/23624     Stupidedi::Reader::SegmentDict::NonEmpty#copy
                      0.00      0.00      0.00      0.00          3/23624     Stupidedi::Reader::StreamReader#copy
                      0.00      0.00      0.00      0.00         20/23624     <Class::Rational>#new!
                      0.00      0.00      0.00      0.00          2/23624     <Class::Stupidedi::Builder_::FunctionalGroupState>#instructions
                      0.00      0.00      0.00      0.00          5/23624     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00          4/23624     <Class::Stupidedi::Builder_::FunctionalGroupState>#push
                      0.00      0.00      0.00      0.00         20/23624     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DecimalVal>#value
                      0.00      0.00      0.00      0.00        223/23624     <Class::Stupidedi::Reader::SegmentTok>#build
                      0.00      0.00      0.00      0.00        178/23624     Array#each
                      0.00      0.00      0.00      0.00          4/23624     Stupidedi::Envelope::TransactionSetDef#empty
                      0.00      0.00      0.00      0.00          8/23624     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal>#value
                      0.00      0.00      0.00      0.00          7/23624     Stupidedi::Reader::SegmentDict::NonEmpty#push
                      0.00      0.00      0.00      0.00          4/23624     Stupidedi::Builder_::TableState#copy
                      0.00      0.00      0.00      0.00        322/23624     Stupidedi::Builder_::InstructionTable::NonEmpty#initialize
                      0.00      0.00      0.00      0.00         72/23624     <Class::Stupidedi::Builder_::LoopState>#push
                      0.00      0.00      0.00      0.00          1/23624     <Class::Stupidedi::Builder_::TransactionSetState>#instructions
                      0.00      0.00      0.00      0.00         80/23624     Stupidedi::Values::SegmentVal#copy
                      0.00      0.00      0.00      0.00         48/23624     <Class::Stupidedi::Reader::CompositeElementTok>#build
                      0.00      0.00      0.00      0.00         86/23624     Stupidedi::Builder_::InstructionTable::NonEmpty#successors
                      0.00      0.00      0.00      0.00        180/23624     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00          2/23624     <Class::Stupidedi::Builder_::InterchangeState>#instructions
                      0.00      0.00      0.00      0.00        161/23624     Stupidedi::Builder_::InstructionTable::NonEmpty#copy
                      0.00      0.00      0.00      0.00          8/23624     Stupidedi::Builder_::InterchangeState#copy
                      0.00      0.00      0.00      0.00       1328/23624     Stupidedi::Either::Success#map
                      0.00      0.00      0.00      0.00          4/23624     Stupidedi::Builder_::FunctionalGroupState#copy
                      0.00      0.00      0.00      0.00          4/23624     #<Class:0xb76cc41c>#value
                      0.00      0.00      0.00      0.00         20/23624     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DecimalVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00          4/23624     <Class::Stupidedi::Builder_::TransactionSetState>#push
                      0.00      0.00      0.00      0.00         88/23624     Stupidedi::Schema::SegmentDef#value
                      0.00      0.00      0.00      0.00          8/23624     Stupidedi::Schema::TableDef#value
                      0.00      0.00      0.00      0.00         16/23624     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00         16/23624     <Class::Stupidedi::Builder_::TableState>#push
                      0.00      0.00      0.00      0.00          8/23624     <Class::Stupidedi::Dictionaries::Interchanges::FiveOhOne::ElementDefs::SeparatorElementVal>#value
                      0.00      0.00      0.00      0.00          1/23624     <Class::Stupidedi::Builder_::LoopState>#instructions
                      0.00      0.00      0.00      0.00        104/23624     <Class::Stupidedi::Reader::ComponentElementTok>#build
                      0.00      0.00      0.00      0.00         12/23624     Stupidedi::Schema::CompositeElementDef#value
                      0.00      0.00      0.00      0.00        112/23624     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal>#empty
                      0.00      0.00      0.00      0.00        116/23624     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00       1015/23624     <Class::Stupidedi::Reader::SimpleElementTok>#build
                      0.01      0.01      0.00      0.00       1104/23624     Stupidedi::Reader::Success#copy
                      0.01      0.00      0.00      0.01         72/23624     Stupidedi::Schema::LoopDef#value
                      0.01      0.00      0.00      0.01          4/23624     Stupidedi::Builder_::TransactionSetState#copy
                      0.01      0.01      0.00      0.00       3903/23624     Stupidedi::Reader::FileInput#drop
                      0.01      0.00      0.00      0.01       2793/23624     Stupidedi::Reader::TokenReader#copy
                      0.01      0.01      0.00      0.00       3106/23624     <Class::Stupidedi::Either>#success
                      0.01      0.00      0.00      0.01       3085/23624     Stupidedi::Reader::TokenReader#result
                      0.02      0.01      0.00      0.01       2984/23624     Stupidedi::Builder_::Instruction#copy
  10.98%   4.88%      0.09      0.04      0.00      0.05            23624     Class#new
                      0.01      0.01      0.00      0.00              8/8     Stupidedi::Builder_::TransactionSetState#initialize
                      0.01      0.01      0.00      0.00        3162/3162     Stupidedi::Builder_::Instruction#initialize
                      0.01      0.01      0.00      0.00        4192/4192     Stupidedi::Reader::Success#initialize
                      0.01      0.00      0.00      0.01          168/168     Stupidedi::Values::SegmentVal#initialize
                      0.01      0.01      0.00      0.00        2795/2795     Stupidedi::Reader::TokenReader#initialize
                      0.01      0.00      0.00      0.01            72/72     Stupidedi::Values::LoopVal#initialize
                      0.00      0.00      0.00      0.00      23177/23479     <Class::Object>#allocate
                      0.00      0.00      0.00      0.00         776/1536     Stupidedi::Values::SimpleElementVal#initialize
                      0.00      0.00      0.00      0.00            48/48     Stupidedi::Reader::CompositeElementTok#initialize
                      0.00      0.00      0.00      0.00          224/224     Stupidedi::Reader::SegmentTok#initialize
                      0.00      0.00      0.00      0.00          446/446     Hash#initialize
                      0.00      0.00      0.00      0.00          161/161     Stupidedi::Builder_::InstructionTable::NonEmpty#initialize
                      0.00      0.00      0.00      0.00              1/1     Class#initialize
                      0.00      0.00      0.00      0.00          208/208     Stupidedi::Builder_::LoopState#initialize
                      0.00      0.00      0.00      0.00              8/8     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal::NonEmpty#initialize
                      0.00      0.00      0.00      0.00        1016/1016     Stupidedi::Reader::SimpleElementTok#initialize
                      0.00      0.00      0.00      0.00            40/40     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal::NonEmpty#initialize
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Envelope::FunctionalGroupVal#initialize
                      0.00      0.00      0.00      0.00              1/1     OpenStruct#initialize
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal::Improper#initialize
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeVal#initialize
                      0.00      0.00      0.00      0.00          491/491     Stupidedi::AbsoluteSet#initialize
                      0.00      0.00      0.00      0.00              8/8     Stupidedi::Builder_::FunctionalGroupState#initialize
                      0.00      0.00      0.00      0.00            12/12     Stupidedi::Builder_::InterchangeState#initialize
                      0.00      0.00      0.00      0.00              1/1     <Class::Class>#allocate
                      0.00      0.00      0.00      0.00          109/109     Stupidedi::Builder_::ConstraintTable::ValueBased#initialize
                      0.00      0.00      0.00      0.00          260/260     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal::NonEmpty#initialize
                      0.00      0.00      0.00      0.00              8/8     Stupidedi::Reader::SegmentDict::NonEmpty#initialize
                      0.00      0.00      0.00      0.00            40/40     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DecimalVal::NonEmpty#initialize
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Reader::StreamReader#initialize
                      0.00      0.00      0.00      0.00            20/20     Rational#initialize
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Envelope::TransactionSetVal#initialize
                      0.00      0.00      0.00      0.00            16/16     Stupidedi::Values::TableVal#initialize
                      0.00      0.00      0.00      0.00          104/104     Stupidedi::Reader::ComponentElementTok#initialize
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Reader::Failure#initialize
                      0.00      0.00      0.00      0.00          394/394     Stupidedi::Builder_::ConstraintTable::Stub#initialize
                      0.00      0.00      0.00      0.00            32/32     Stupidedi::Values::CompositeElementVal#initialize
                      0.00      0.00      0.00      0.00        4434/4434     Stupidedi::Either::Success#initialize
                      0.00      0.00      0.00      0.00              8/8     Stupidedi::Reader::Separators#initialize
                      0.00      0.00      0.00      0.00              2/2     <Class::Stupidedi::Reader::SegmentDict>#empty
                      0.00      0.00      0.00      0.00          446/446     <Class::Hash>#allocate
                      0.00      0.00      0.00      0.00              8/8     Stupidedi::Dictionaries::Interchanges::FiveOhOne::ElementDefs::SeparatorElementVal#initialize
                      0.00      0.00      0.00      0.00              8/8     Stupidedi::Reader::SegmentDict::Constants#initialize
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Either::Failure#initialize
                      0.00      0.00      0.00      0.00          396/396     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal::NonEmpty#initialize
                      0.00      0.00      0.00      0.00        3903/3903     Stupidedi::Reader::FileInput#initialize
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal::Proper#initialize
                      0.00      0.00      0.00      0.00            20/20     Stupidedi::Builder_::TableState#initialize
                      0.00      0.00      0.00      0.00              1/1     #<Class:0xb7339a34>#initialize
--------------------------------------------------------------------------------
                      0.09      0.00      0.00      0.09          180/180     Array#each
  10.98%   0.00%      0.09      0.00      0.00      0.09              180     Stupidedi::Builder_::LoopState#drop
                      0.09      0.01      0.00      0.08          136/368     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
                      0.00      0.00      0.00      0.00          136/136     Stupidedi::Builder_::LoopState#copy
                      0.00      0.00      0.00      0.00         180/2974     Fixnum#zero?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         104/3903     Stupidedi::Reader::TokenReader#read_component_element
                      0.00      0.00      0.00      0.00           3/3903     Stupidedi::Reader::StreamReader#advance
                      0.02      0.02      0.00      0.00        1015/3903     Stupidedi::Reader::TokenReader#read_simple_element
                      0.07      0.01      0.00      0.06        2781/3903     Stupidedi::Reader::TokenReader#advance
  10.98%   3.66%      0.09      0.03      0.00      0.06             3903     Stupidedi::Reader::FileInput#drop
                      0.03      0.03      0.00      0.00       3903/11329     IO#read
                      0.01      0.01      0.00      0.00       3903/13048     Kernel#class
                      0.01      0.01      0.00      0.00       3903/23624     Class#new
                      0.01      0.01      0.00      0.00      11486/40586     Fixnum#+
                      0.00      0.00      0.00      0.00        3903/3903     String#count
                      0.00      0.00      0.00      0.00       3903/11329     IO#seek
                      0.00      0.00      0.00      0.00         223/7575     Fixnum#-
                      0.00      0.00      0.00      0.00        3903/3903     String#rindex
                      0.00      0.00      0.00      0.00        7806/8425     String#length
                      0.00      0.00      0.00      0.00       3903/11329     Fixnum#>=
--------------------------------------------------------------------------------
                      0.03      0.00      0.00      0.03          223/456     Stupidedi::Reader::SegmentDict::NonEmpty#at
                      0.06      0.00      0.00      0.06          233/456     Stupidedi::Reader::SegmentDict::NonEmpty#defined_at?
  10.98%   0.00%      0.09      0.00      0.00      0.09              456     Stupidedi::Reader::SegmentDict::Constants#defined_at?
                      0.06      0.00      0.00      0.06          456/574     Enumerable#any?
                      0.03      0.03      0.00      0.00          456/456     Module#constants
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            4/368     Stupidedi::Builder_::TransactionSetState#drop
                      0.00      0.00      0.00      0.00            4/368     Stupidedi::Builder_::TableState#drop
                      0.00      0.00      0.00      0.00          212/368     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
                      0.00      0.00      0.00      0.00            4/368     Stupidedi::Builder_::FunctionalGroupState#drop
                      0.00      0.00      0.00      0.00            8/368     Stupidedi::Builder_::InterchangeState#drop
                      0.09      0.01      0.00      0.08          136/368     Stupidedi::Builder_::LoopState#drop
  10.98%   1.22%      0.09      0.01      0.00      0.08              368     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
                      0.05      0.00      0.00      0.05          139/677     Array#map
                      0.01      0.00      0.00      0.01          139/139     Stupidedi::Builder_::InstructionTable::NonEmpty#length
                      0.00      0.00      0.00      0.00         245/1510     Fixnum#==
                      0.00      0.00      0.00      0.00          139/278     Array#drop
                      0.00      0.00      0.00      0.00          139/221     Array#concat
                      0.00      0.00      0.00      0.00          212/368     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
                      0.00      0.00      0.00      0.00         368/2974     Fixnum#zero?
                      0.00      0.00      0.00      0.00          139/139     Array#split_at
                      0.00      0.00      0.00      0.00          139/161     Stupidedi::Builder_::InstructionTable::NonEmpty#copy
                      0.00      0.00      0.00      0.00         245/7575     Fixnum#-
                      0.00      0.02      0.00      0.00         245/1944     Array#each
                      0.00      0.00      0.00      0.00         368/2113     Hash#[]
                      0.00      0.00      0.00      0.00         139/3102     Kernel#nil?
                      0.00      0.00      0.00      0.00         384/1677     Array#length
                      0.00      0.00      0.00      0.00         245/1432     Hash#[]=
--------------------------------------------------------------------------------
                      0.07      0.03      0.00      0.04        2984/2984     Array#map
   8.54%   3.66%      0.07      0.03      0.00      0.04             2984     Stupidedi::Builder_::Instruction#copy
                      0.02      0.02      0.00      0.00      14920/30212     Hash#fetch
                      0.02      0.01      0.00      0.01       2984/23624     Class#new
                      0.00      0.00      0.00      0.00       2984/13048     Kernel#class
--------------------------------------------------------------------------------
                      0.06      0.00      0.00      0.06          224/224     Stupidedi::Reader::TokenReader#read_segment
   7.32%   0.00%      0.06      0.00      0.00      0.06              224     Stupidedi::Reader::TokenReader#read_segment_id
                      0.02      0.01      0.00      0.01        1029/7198     Stupidedi::Reader::TokenReader#is_control?
                      0.02      0.01      0.00      0.01        1252/7426     Stupidedi::Reader::FileInput#at
                      0.01      0.01      0.00      0.00         223/2781     Stupidedi::Reader::TokenReader#advance
                      0.01      0.01      0.00      0.00        1252/3123     Stupidedi::Reader::TokenReader#is_delimiter?
                      0.00      0.00      0.00      0.00        446/19422     Kernel#===
                      0.00      0.00      0.00      0.00          223/224     String#to_sym
                      0.00      0.00      0.00      0.00       1252/40586     Fixnum#+
                      0.00      0.00      0.00      0.00       1253/10209     Stupidedi::Reader::FileInput#defined_at?
                      0.00      0.00      0.00      0.00         581/4210     String#<<
                      0.00      0.00      0.00      0.00         223/3085     Stupidedi::Reader::TokenReader#result
                      0.00      0.00      0.00      0.00         581/1510     Fixnum#==
                      0.00      0.00      0.00      0.00         223/7575     Fixnum#-
                      0.00      0.00      0.00      0.00          223/226     String#upcase
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Reader::TokenReader#failure
                      0.00      0.00      0.00      0.00         581/8425     String#length
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           10/233     Stupidedi::Reader::SegmentDict::NonEmpty#defined_at?
                      0.06      0.00      0.00      0.06          223/233     Stupidedi::Either::Success#flatmap
   7.32%   0.00%      0.06      0.00      0.00      0.06              233     Stupidedi::Reader::SegmentDict::NonEmpty#defined_at?
                      0.06      0.00      0.00      0.06          233/456     Stupidedi::Reader::SegmentDict::Constants#defined_at?
                      0.00      0.00      0.00      0.00           10/233     Stupidedi::Reader::SegmentDict::NonEmpty#defined_at?
                      0.00      0.00      0.00      0.00              4/4     #<Class:0xb73af3b0>#defined_at?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          110/574     <Class::Stupidedi::Builder_::ConstraintTable>#build
                      0.00      0.00      0.00      0.00            8/574     Stupidedi::Values::SegmentValGroup#defined_at?
                      0.06      0.00      0.00      0.06          456/574     Stupidedi::Reader::SegmentDict::Constants#defined_at?
   7.32%   0.00%      0.06      0.00      0.00      0.06              574     Enumerable#any?
                      0.06      0.03      0.00      0.03         574/1944     Array#each
--------------------------------------------------------------------------------
                      0.05      0.00      0.00      0.05          224/224     Array#each
   6.10%   0.00%      0.05      0.00      0.00      0.05              224     Stupidedi::Builder_::InstructionTable::NonEmpty#successors
                      0.04      0.00      0.00      0.04            68/68     Stupidedi::Builder_::ConstraintTable::ValueBased#matches
                      0.01      0.00      0.00      0.01           43/277     Hash#each
                      0.00      0.00      0.00      0.00          43/1944     Array#each
                      0.00      0.00      0.00      0.00          156/156     Stupidedi::Builder_::ConstraintTable::Stub#matches
                      0.00      0.00      0.00      0.00          224/293     Hash#at
                      0.00      0.00      0.00      0.00         86/23624     Class#new
                      0.00      0.00      0.00      0.00          224/295     Hash#defined_at?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         364/7426     Stupidedi::Reader::TokenReader#read_component_element
                      0.00      0.00      0.00      0.00           1/7426     Stupidedi::Reader::TokenReader#read_character
                      0.00      0.00      0.00      0.00           2/7426     Stupidedi::Reader::StreamReader#read_character
                      0.00      0.00      0.00      0.00           3/7426     Stupidedi::Reader::StreamReader#consume_isa
                      0.00      0.00      0.00      0.00          15/7426     Stupidedi::Reader::TokenReader#consume_prefix
                      0.01      0.00      0.00      0.01        1423/7426     Stupidedi::Reader::TokenReader#read_delimiter
                      0.01      0.01      0.00      0.00        4366/7426     Stupidedi::Reader::TokenReader#read_simple_element
                      0.02      0.01      0.00      0.01        1252/7426     Stupidedi::Reader::TokenReader#read_segment_id
   4.88%   2.44%      0.04      0.02      0.00      0.02             7426     Stupidedi::Reader::FileInput#at
                      0.01      0.01      0.00      0.00       7426/11329     IO#read
                      0.01      0.01      0.00      0.00       7426/11329     IO#seek
                      0.00      0.00      0.00      0.00       7426/40586     Fixnum#+
                      0.00      0.00      0.00      0.00       7426/11329     Fixnum#>=
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         364/7198     Stupidedi::Reader::TokenReader#read_component_element
                      0.00      0.00      0.00      0.00           1/7198     Stupidedi::Reader::TokenReader#read_character
                      0.00      0.00      0.00      0.00          15/7198     Stupidedi::Reader::TokenReader#consume_prefix
                      0.01      0.00      0.00      0.01        1423/7198     Stupidedi::Reader::TokenReader#read_delimiter
                      0.01      0.01      0.00      0.00        4366/7198     Stupidedi::Reader::TokenReader#read_simple_element
                      0.02      0.01      0.00      0.01        1029/7198     Stupidedi::Reader::TokenReader#read_segment_id
   4.88%   2.44%      0.04      0.02      0.00      0.02             7198     Stupidedi::Reader::TokenReader#is_control?
                      0.02      0.01      0.00      0.01        7198/7201     <Module::Stupidedi::Reader>#is_control_character?
                      0.00      0.00      0.00      0.00         448/3123     Stupidedi::Reader::TokenReader#is_delimiter?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             8/72     <Class::Stupidedi::Builder_::TableState>#push
                      0.04      0.00      0.00      0.04            64/72     Array#each
   4.88%   0.00%      0.04      0.00      0.00      0.04               72     <Class::Stupidedi::Builder_::LoopState>#push
                      0.02      0.00      0.00      0.02           72/100     Stupidedi::Builder_::InstructionTable::NonEmpty#push
                      0.01      0.00      0.00      0.01            72/72     <Class::Stupidedi::Builder_::LoopState>#instructions
                      0.01      0.00      0.00      0.01            72/72     Stupidedi::Schema::LoopDef#value
                      0.00      0.00      0.00      0.00            72/88     <Class::Stupidedi::Builder_::AbstractState>#segment
                      0.00      0.00      0.00      0.00         72/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            1/277     OpenStruct#initialize
                      0.01      0.01      0.00      0.00          168/277     Enumerable#inject
                      0.01      0.00      0.00      0.01           43/277     Stupidedi::Builder_::InstructionTable::NonEmpty#successors
                      0.02      0.02      0.00      0.00           65/277     Stupidedi::AbsoluteSet#each
   4.88%   3.66%      0.04      0.03      0.00      0.01              277     Hash#each
                      0.01      0.00      0.00      0.01          503/503     <Class::Stupidedi::Builder_::ConstraintTable>#build
                      0.00      0.00      0.00      0.00             1/53     Kernel#singleton_method_added
                      0.00      0.00      0.00      0.00       3570/40586     Fixnum#+
                      0.00      0.00      0.00      0.00        2838/2838     Fixnum#[]
                      0.00      0.00      0.00      0.00              1/3     Module#private
                      0.00      0.00      0.00      0.00        1735/2974     Fixnum#zero?
                      0.00      0.00      0.00      0.00             1/18     Symbol#to_sym
                      0.00      0.00      0.00      0.00              1/2     OpenStruct#new_ostruct_member
                      0.00      0.00      0.00      0.00             4/48     Class#inherited
                      0.00      0.00      0.00      0.00           10/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00          77/1317     Object#cons
                      0.00      0.00      0.00      0.00         581/1432     Hash#[]=
                      0.00      0.00      0.00      0.00        2467/2467     Bignum#[]
--------------------------------------------------------------------------------
                      0.01      0.01      0.00      0.00       7426/11329     Stupidedi::Reader::FileInput#at
                      0.03      0.03      0.00      0.00       3903/11329     Stupidedi::Reader::FileInput#drop
   4.88%   4.88%      0.04      0.04      0.00      0.00            11329     IO#read
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01             1/16     Stupidedi::Either::Success#flatmap
                      0.03      0.00      0.00      0.03            15/16     Stupidedi::Builder_::ConstraintTable::ValueBased#basis
   4.88%   0.00%      0.04      0.00      0.00      0.04               16     Integer#times
                      0.01      0.00      0.00      0.01            13/13     Range#each
                      0.00      0.00      0.00      0.00          13/7575     Fixnum#-
                      0.00      0.00      0.00      0.00            15/15     Symbol#to_proc
                      0.00      0.00      0.00      0.00         138/1154     Stupidedi::Schema::ElementUse#composite?
                      0.00      0.00      0.00      0.00         13/23479     <Class::Object>#allocate
                      0.00      0.00      0.00      0.00         125/1944     Array#each
                      0.00      0.00      0.00      0.00          30/3106     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00          13/1677     Array#length
                      0.00      0.00      0.00      0.00         151/1471     Array#at
--------------------------------------------------------------------------------
                      0.04      0.00      0.00      0.04            68/68     Stupidedi::Builder_::InstructionTable::NonEmpty#successors
   4.88%   0.00%      0.04      0.00      0.00      0.04               68     Stupidedi::Builder_::ConstraintTable::ValueBased#matches
                      0.03      0.00      0.00      0.03            15/15     Stupidedi::Builder_::ConstraintTable::ValueBased#basis
                      0.01      0.00      0.00      0.01            15/15     Stupidedi::Builder_::ConstraintTable::ValueBased#deepest
                      0.00      0.00      0.00      0.00          68/2256     Array#head
                      0.00      0.00      0.00      0.00          68/1944     Array#each
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          12/2793     Array#each
                      0.04      0.02      0.00      0.02        2781/2793     Stupidedi::Reader::TokenReader#advance
   4.88%   2.44%      0.04      0.02      0.00      0.02             2793     Stupidedi::Reader::TokenReader#copy
                      0.01      0.01      0.00      0.00       8379/30212     Hash#fetch
                      0.01      0.00      0.00      0.01       2793/23624     Class#new
                      0.00      0.00      0.00      0.00       2793/13048     Kernel#class
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         80/30212     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DecimalVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00         64/30212     Stupidedi::Values::CompositeElementVal#copy
                      0.00      0.00      0.00      0.00        982/30212     Stupidedi::AbsoluteSet#copy
                      0.00      0.00      0.00      0.00         12/30212     Stupidedi::Builder_::TransactionSetState#copy
                      0.00      0.00      0.00      0.00         12/30212     Stupidedi::Builder_::TableState#copy
                      0.00      0.00      0.00      0.00         40/30212     Stupidedi::Builder_::InterchangeState#copy
                      0.00      0.00      0.00      0.00         16/30212     Stupidedi::Builder_::FunctionalGroupState#copy
                      0.00      0.00      0.00      0.00        720/30212     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00        322/30212     Stupidedi::Builder_::InstructionTable::NonEmpty#copy
                      0.00      0.00      0.00      0.00        320/30212     Stupidedi::Values::SegmentVal#copy
                      0.00      0.00      0.00      0.00         14/30212     Stupidedi::Reader::SegmentDict::NonEmpty#copy
                      0.00      0.00      0.00      0.00         64/30212     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00        408/30212     Stupidedi::Builder_::LoopState#copy
                      0.00      0.00      0.00      0.00          4/30212     Module#delegate
                      0.00      0.00      0.00      0.00         16/30212     Stupidedi::Reader::Separators#copy
                      0.00      0.00      0.00      0.00       1164/30212     Stupidedi::Values::SimpleElementVal#copy
                      0.00      0.00      0.00      0.00        464/30212     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00          3/30212     Stupidedi::Reader::StreamReader#copy
                      0.01      0.01      0.00      0.00       2208/30212     Stupidedi::Reader::Success#copy
                      0.01      0.01      0.00      0.00       8379/30212     Stupidedi::Reader::TokenReader#copy
                      0.02      0.02      0.00      0.00      14920/30212     Stupidedi::Builder_::Instruction#copy
   4.88%   4.88%      0.04      0.04      0.00      0.00            30212     Hash#fetch
--------------------------------------------------------------------------------
                      0.04      0.00      0.00      0.04            48/48     Stupidedi::Reader::TokenReader#read_elements
   4.88%   0.00%      0.04      0.00      0.00      0.04               48     Stupidedi::Reader::TokenReader#read_composite_element
                      0.03      0.00      0.00      0.03           48/104     Stupidedi::Reader::TokenReader#read_component_elements
                      0.00      0.00      0.00      0.00          48/3106     Stupidedi::Either::Success#flatmap
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            4/223     Stupidedi::Reader::SegmentDict::NonEmpty#at
                      0.03      0.00      0.00      0.03          219/223     Stupidedi::Either::Success#flatmap
   3.66%   0.00%      0.03      0.00      0.00      0.03              223     Stupidedi::Reader::SegmentDict::NonEmpty#at
                      0.03      0.00      0.00      0.03          223/456     Stupidedi::Reader::SegmentDict::Constants#defined_at?
                      0.00      0.00      0.00      0.00          219/219     Stupidedi::Reader::SegmentDict::Constants#at
                      0.00      0.00      0.00      0.00            4/223     Stupidedi::Reader::SegmentDict::NonEmpty#at
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         104/3085     Stupidedi::Reader::TokenReader#read_component_element
                      0.00      0.00      0.00      0.00         223/3085     Stupidedi::Reader::TokenReader#read_segment_id
                      0.00      0.00      0.00      0.00           1/3085     Stupidedi::Reader::TokenReader#read_character
                      0.00      0.00      0.00      0.00        1015/3085     Stupidedi::Reader::TokenReader#read_simple_element
                      0.01      0.01      0.00      0.00         319/3085     Stupidedi::Either::Success#flatmap
                      0.02      0.00      0.00      0.02        1423/3085     Stupidedi::Reader::TokenReader#read_delimiter
   3.66%   1.22%      0.03      0.01      0.00      0.02             3085     Stupidedi::Reader::TokenReader#result
                      0.01      0.00      0.00      0.01        3085/3106     <Class::Stupidedi::Either>#success
                      0.01      0.00      0.00      0.01       3085/23624     Class#new
--------------------------------------------------------------------------------
                      0.03      0.03      0.00      0.00          456/456     Stupidedi::Reader::SegmentDict::Constants#defined_at?
   3.66%   3.66%      0.03      0.03      0.00      0.00              456     Module#constants
--------------------------------------------------------------------------------
                      0.03      0.00      0.00      0.03            15/15     Stupidedi::Builder_::ConstraintTable::ValueBased#matches
   3.66%   0.00%      0.03      0.00      0.00      0.03               15     Stupidedi::Builder_::ConstraintTable::ValueBased#basis
                      0.03      0.00      0.00      0.03            15/16     Integer#times
                      0.00      0.00      0.00      0.00          15/2256     Array#head
                      0.00      0.00      0.00      0.00          15/1677     Array#length
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            4/100     <Class::Stupidedi::Builder_::InterchangeState>#push
                      0.00      0.00      0.00      0.00            4/100     <Class::Stupidedi::Builder_::TransactionSetState>#push
                      0.00      0.00      0.00      0.00            4/100     <Class::Stupidedi::Builder_::FunctionalGroupState>#push
                      0.01      0.00      0.00      0.01           16/100     <Class::Stupidedi::Builder_::TableState>#push
                      0.02      0.00      0.00      0.02           72/100     <Class::Stupidedi::Builder_::LoopState>#push
   3.66%   0.00%      0.03      0.00      0.00      0.03              100     Stupidedi::Builder_::InstructionTable::NonEmpty#push
                      0.02      0.00      0.00      0.02           22/677     Array#map
                      0.01      0.00      0.00      0.01         100/2113     Hash#[]
                      0.00      0.00      0.00      0.00           22/161     Stupidedi::Builder_::InstructionTable::NonEmpty#copy
                      0.00      0.00      0.00      0.00          22/1341     Array#+
                      0.00      0.00      0.00      0.00          22/1677     Array#length
                      0.00      0.00      0.00      0.00          22/1432     Hash#[]=
--------------------------------------------------------------------------------
                      0.03      0.00      0.00      0.03        1104/1104     Stupidedi::Either::Success#map
   3.66%   0.00%      0.03      0.00      0.00      0.03             1104     Stupidedi::Reader::Success#map
                      0.02      0.00      0.00      0.02        1104/1104     Stupidedi::Reader::Success#copy
                      0.01      0.00      0.00      0.01          223/223     Stupidedi::Reader::TokenReader#segment
                      0.00      0.00      0.00      0.00         881/1317     Object#cons
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           56/104     Stupidedi::Either::Success#flatmap
                      0.03      0.00      0.00      0.03           48/104     Stupidedi::Reader::TokenReader#read_composite_element
   3.66%   0.00%      0.03      0.00      0.00      0.03              104     Stupidedi::Reader::TokenReader#read_component_elements
                      0.02      0.00      0.00      0.02          104/104     Stupidedi::Reader::TokenReader#read_component_element
                      0.00      0.00      0.00      0.00         104/3106     Stupidedi::Either::Success#flatmap
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         22/13222     Module#abstract
                      0.00      0.00      0.00      0.00          2/13222     OpenStruct#new_ostruct_member
                      0.02      0.02      0.00      0.00      13198/13222     Array#each
   2.44%   2.44%      0.02      0.02      0.00      0.00            13222     Symbol#to_s
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           3/7201     Stupidedi::Reader::StreamReader#consume_isa
                      0.02      0.01      0.00      0.01        7198/7201     Stupidedi::Reader::TokenReader#is_control?
   2.44%   1.22%      0.02      0.01      0.00      0.01             7201     <Module::Stupidedi::Reader>#is_control_character?
                      0.01      0.01      0.00      0.00        7201/7201     String#=~
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00       1260/19422     Stupidedi::Reader::TokenReader#read_component_element
                      0.00      0.00      0.00      0.00       2504/19422     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00        446/19422     Stupidedi::Reader::TokenReader#read_segment_id
                      0.02      0.02      0.00      0.00      15212/19422     Stupidedi::Reader::TokenReader#read_simple_element
   2.44%   2.44%      0.02      0.02      0.00      0.00            19422     Kernel#===
                      0.00      0.00      0.00      0.00          270/286     Kernel#==
                      0.00      0.00      0.00      0.00      19152/41326     String#==
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          1/41326     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00         15/41326     Stupidedi::Reader::TokenReader#consume_prefix
                      0.00      0.00      0.00      0.00          3/41326     Stupidedi::Reader::StreamReader#consume_isa
                      0.00      0.00      0.00      0.00      19152/41326     Kernel#===
                      0.01      0.01      0.00      0.00       9025/41326     Stupidedi::Reader::TokenReader#is_delimiter?
                      0.01      0.01      0.00      0.00      13130/41326     Array#each
   2.44%   2.44%      0.02      0.02      0.00      0.00            41326     String#==
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         448/3123     Stupidedi::Reader::TokenReader#is_control?
                      0.01      0.00      0.00      0.01        1423/3123     Stupidedi::Reader::TokenReader#read_delimiter
                      0.01      0.01      0.00      0.00        1252/3123     Stupidedi::Reader::TokenReader#read_segment_id
   2.44%   1.22%      0.02      0.01      0.00      0.01             3123     Stupidedi::Reader::TokenReader#is_delimiter?
                      0.01      0.01      0.00      0.00       9025/41326     String#==
--------------------------------------------------------------------------------
                      0.02      0.00      0.00      0.02              4/4     Array#each
   2.44%   0.00%      0.02      0.00      0.00      0.02                4     <Class::Stupidedi::Builder_::InterchangeState>#push
                      0.02      0.00      0.00      0.02             4/88     <Class::Stupidedi::Builder_::AbstractState>#segment
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Envelope::InterchangeDef#entry_segment_use
                      0.00      0.00      0.00      0.00            4/111     Object#try
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Reader::Separators#merge
                      0.00      0.00      0.00      0.00              4/4     <Class::Stupidedi::Builder_::InterchangeState>#instructions
                      0.00      0.00      0.00      0.00              4/4     #<Class:0xb7563918>#value
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Configuration::InterchangeConfig#defined_at?
                      0.00      0.00      0.00      0.00            4/100     Stupidedi::Builder_::InstructionTable::NonEmpty#push
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Configuration::InterchangeConfig#at
                      0.00      0.00      0.00      0.00              3/7     Stupidedi::Reader::SegmentDict::NonEmpty#push
                      0.00      0.00      0.00      0.00              1/1     #<Class:0xb73af3b0>#push
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeVal#segment_dict
                      0.00      0.00      0.00      0.00          4/23624     Class#new
                      0.00      0.00      0.00      0.00           4/1471     Array#at
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            72/88     <Class::Stupidedi::Builder_::LoopState>#push
                      0.00      0.00      0.00      0.00             8/88     <Class::Stupidedi::Builder_::TableState>#push
                      0.00      0.00      0.00      0.00             4/88     <Class::Stupidedi::Builder_::FunctionalGroupState>#push
                      0.02      0.00      0.00      0.02             4/88     <Class::Stupidedi::Builder_::InterchangeState>#push
   2.44%   0.00%      0.02      0.00      0.00      0.02               88     <Class::Stupidedi::Builder_::AbstractState>#segment
                      0.02      0.00      0.00      0.02           88/677     Array#map
                      0.00      0.00      0.00      0.00            88/88     Stupidedi::Schema::SegmentUse#value
                      0.00      0.00      0.00      0.00           88/100     Array#zip
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         20/13048     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DecimalVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00        290/13048     Stupidedi::AbsoluteSet#union
                      0.00      0.00      0.00      0.00         16/13048     Stupidedi::Values::CompositeElementVal#copy
                      0.00      0.00      0.00      0.00        491/13048     Stupidedi::AbsoluteSet#copy
                      0.00      0.00      0.00      0.00          4/13048     Stupidedi::Builder_::TransactionSetState#copy
                      0.00      0.00      0.00      0.00        135/13048     Stupidedi::AbsoluteSet#==
                      0.00      0.00      0.00      0.00          4/13048     Stupidedi::Builder_::TableState#copy
                      0.00      0.00      0.00      0.00          8/13048     Stupidedi::Builder_::InterchangeState#copy
                      0.00      0.00      0.00      0.00          4/13048     Stupidedi::Builder_::FunctionalGroupState#copy
                      0.00      0.00      0.00      0.00        180/13048     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00        161/13048     Stupidedi::Builder_::InstructionTable::NonEmpty#copy
                      0.00      0.00      0.00      0.00       2984/13048     Stupidedi::Builder_::Instruction#copy
                      0.00      0.00      0.00      0.00       1104/13048     Stupidedi::Reader::Success#copy
                      0.00      0.00      0.00      0.00         16/13048     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00       2793/13048     Stupidedi::Reader::TokenReader#copy
                      0.00      0.00      0.00      0.00          4/13048     Stupidedi::Reader::Separators#copy
                      0.00      0.00      0.00      0.00         80/13048     Stupidedi::Values::SegmentVal#copy
                      0.00      0.00      0.00      0.00        201/13048     Stupidedi::AbsoluteSet#intersection
                      0.00      0.00      0.00      0.00        136/13048     Stupidedi::Builder_::LoopState#copy
                      0.00      0.00      0.00      0.00        116/13048     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00          7/13048     Stupidedi::Reader::SegmentDict::NonEmpty#copy
                      0.00      0.00      0.00      0.00          3/13048     Stupidedi::Reader::StreamReader#copy
                      0.01      0.01      0.00      0.00       3903/13048     Stupidedi::Reader::FileInput#drop
                      0.01      0.01      0.00      0.00        388/13048     Stupidedi::Values::SimpleElementVal#copy
   2.44%   2.44%      0.02      0.02      0.00      0.00            13048     Kernel#class
--------------------------------------------------------------------------------
                      0.02      0.00      0.00      0.02        1104/1104     Stupidedi::Reader::Success#map
   2.44%   0.00%      0.02      0.00      0.00      0.02             1104     Stupidedi::Reader::Success#copy
                      0.01      0.01      0.00      0.00       2208/30212     Hash#fetch
                      0.01      0.01      0.00      0.00       1104/23624     Class#new
                      0.00      0.00      0.00      0.00       1104/13048     Kernel#class
--------------------------------------------------------------------------------
                      0.02      0.02      0.00      0.00        1015/1015     Stupidedi::Reader::TokenReader#read_simple_element
   2.44%   2.44%      0.02      0.02      0.00      0.00             1015     Stupidedi::Reader::TokenReader#simple
                      0.00      0.00      0.00      0.00        1015/1015     <Class::Stupidedi::Reader::SimpleElementTok>#build
                      0.00      0.00      0.00      0.00             1/53     Kernel#singleton_method_added
                      0.00      0.00      0.00      0.00             1/48     Class#inherited
                      0.00      0.00      0.00      0.00            6/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00             3/62     Module#attr_reader
--------------------------------------------------------------------------------
                      0.02      0.00      0.00      0.02          572/572     Array#map
   2.44%   0.00%      0.02      0.00      0.00      0.02              572     <Class::Stupidedi::Builder_::AbstractState>#element
                      0.02      0.01      0.00      0.01          560/588     <Class::Stupidedi::Builder_::AbstractState>#simple_element
                      0.00      0.00      0.00      0.00            12/12     <Class::Stupidedi::Builder_::AbstractState>#composite_element
                      0.00      0.00      0.00      0.00         560/1653     Stupidedi::Schema::SimpleElementUse#simple?
                      0.00      0.00      0.00      0.00            12/73     Stupidedi::Schema::CompositeElementUse#simple?
--------------------------------------------------------------------------------
                      0.02      0.00      0.00      0.02          104/104     Stupidedi::Reader::TokenReader#read_component_elements
   2.44%   0.00%      0.02      0.00      0.00      0.02              104     Stupidedi::Reader::TokenReader#read_component_element
                      0.01      0.00      0.00      0.01          104/104     Stupidedi::Reader::TokenReader#component
                      0.01      0.00      0.00      0.01         104/2781     Stupidedi::Reader::TokenReader#advance
                      0.00      0.00      0.00      0.00         104/3903     Stupidedi::Reader::FileInput#drop
                      0.00      0.00      0.00      0.00        364/10209     Stupidedi::Reader::FileInput#defined_at?
                      0.00      0.00      0.00      0.00        364/40586     Fixnum#+
                      0.00      0.00      0.00      0.00       1260/19422     Kernel#===
                      0.00      0.00      0.00      0.00         260/4210     String#<<
                      0.00      0.00      0.00      0.00         104/3085     Stupidedi::Reader::TokenReader#result
                      0.00      0.00      0.00      0.00         104/7575     Fixnum#-
                      0.00      0.00      0.00      0.00         364/7426     Stupidedi::Reader::FileInput#at
                      0.00      0.00      0.00      0.00         364/7198     Stupidedi::Reader::TokenReader#is_control?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           28/588     Array#map
                      0.02      0.01      0.00      0.01          560/588     <Class::Stupidedi::Builder_::AbstractState>#element
   2.44%   1.22%      0.02      0.01      0.00      0.01              588     <Class::Stupidedi::Builder_::AbstractState>#simple_element
                      0.01      0.00      0.00      0.01          588/600     Stupidedi::Schema::ElementUse#value
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             2/18     Range#each
                      0.02      0.00      0.00      0.02            16/18     Array#each
   2.44%   0.00%      0.02      0.00      0.00      0.02               18     Stupidedi::Builder_::ConstraintTable::ValueBased#build_disjoint
                      0.00      0.00      0.00      0.00          18/1944     Array#each
                      0.00      0.00      0.00      0.00         18/23624     Class#new
                      0.00      0.00      0.00      0.00            18/18     Stupidedi::AbsoluteSet#finite?
--------------------------------------------------------------------------------
                      0.02      0.00      0.00      0.02            65/65     Array#each
   2.44%   0.00%      0.02      0.00      0.00      0.02               65     Stupidedi::AbsoluteSet#each
                      0.02      0.02      0.00      0.00           65/277     Hash#each
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           1/3106     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00           1/3106     Stupidedi::Builder_::StateMachine#read!
                      0.00      0.00      0.00      0.00           1/3106     Stupidedi::Reader::StreamReader#success
                      0.00      0.00      0.00      0.00           3/3106     Stupidedi::Reader::StreamReader#result
                      0.00      0.00      0.00      0.00          15/3106     Stupidedi::Reader::TokenReader#success
                      0.01      0.00      0.00      0.01        3085/3106     Stupidedi::Reader::TokenReader#result
   1.22%   0.00%      0.01      0.00      0.00      0.01             3106     <Class::Stupidedi::Either>#success
                      0.01      0.01      0.00      0.00       3106/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             1/48     Stupidedi::Schema::TableDef#value
                      0.00      0.00      0.00      0.00             2/48     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00             1/48     Stupidedi::Schema::LoopDef#value
                      0.00      0.00      0.00      0.00             1/48     <Class::Stupidedi::Builder_::FunctionalGroupState>#instructions
                      0.00      0.00      0.00      0.00             1/48     Stupidedi::Schema::CompositeElementDef#value
                      0.00      0.00      0.00      0.00             1/48     Array#each
                      0.00      0.00      0.00      0.00             4/48     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DT#companion
                      0.00      0.00      0.00      0.00             3/48     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::AN#companion
                      0.00      0.00      0.00      0.00             4/48     Stupidedi::Builder_::StateMachine#read!
                      0.00      0.00      0.00      0.00             4/48     Hash#each
                      0.00      0.00      0.00      0.00             3/48     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::R#companion
                      0.00      0.00      0.00      0.00             1/48     Stupidedi::Envelope::TransactionSetDef#empty
                      0.00      0.00      0.00      0.00             1/48     Stupidedi::Schema::SegmentDef#value
                      0.00      0.00      0.00      0.00             2/48     #<Class:0xb7563918>#value
                      0.00      0.00      0.00      0.00             3/48     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::ID#companion
                      0.00      0.00      0.00      0.00             3/48     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::Nn#companion
                      0.00      0.00      0.00      0.00             3/48     Stupidedi::Reader::StreamReader#result
                      0.00      0.00      0.00      0.00             3/48     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TM#companion
                      0.00      0.00      0.00      0.00             1/48     Stupidedi::Reader::TokenReader#simple
                      0.00      0.00      0.00      0.00             1/48     Class#initialize
                      0.00      0.00      0.00      0.00             1/48     <Class::Stupidedi::Builder_::TransactionSetState>#push
                      0.00      0.00      0.00      0.00             1/48     #<Class:0xb76cc41c>#value
                      0.00      0.00      0.00      0.00             1/48     Stupidedi::Reader::TokenReader#component
                      0.00      0.00      0.00      0.00             1/48     <Class::Stupidedi::Builder_::InterchangeState>#instructions
                      0.01      0.01      0.00      0.00             1/48     Stupidedi::Reader::TokenReader#composite
   1.22%   1.22%      0.01      0.01      0.00      0.00               48     Class#inherited
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         290/4712     Stupidedi::AbsoluteSet#union
                      0.00      0.00      0.00      0.00         240/4712     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal>#value
                      0.00      0.00      0.00      0.00           1/4712     #<Class:0xb73af3b0>#push
                      0.00      0.00      0.00      0.00          24/4712     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal>#value
                      0.00      0.00      0.00      0.00         135/4712     Stupidedi::AbsoluteSet#==
                      0.00      0.00      0.00      0.00           7/4712     Stupidedi::Reader::SegmentDict::NonEmpty#push
                      0.00      0.00      0.00      0.00         465/4712     #<Class:0xb7532b88>#intersection
                      0.00      0.00      0.00      0.00           8/4712     Array#select
                      0.00      0.00      0.00      0.00           8/4712     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal>#value
                      0.00      0.00      0.00      0.00          24/4712     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal>#value
                      0.00      0.00      0.00      0.00           4/4712     Module#delegate
                      0.00      0.00      0.00      0.00         201/4712     Stupidedi::AbsoluteSet#intersection
                      0.00      0.00      0.00      0.00          11/4712     Module#abstract
                      0.00      0.00      0.00      0.00          20/4712     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DecimalVal>#value
                      0.00      0.00      0.00      0.00         168/4712     Stupidedi::AbsoluteSet#as_mask
                      0.01      0.01      0.00      0.00        3106/4712     Stupidedi::Either::Success#flatmap
   1.22%   1.22%      0.01      0.01      0.00      0.00             4712     Kernel#is_a?
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01              1/1     Stupidedi::Either::Success#flatmap
   1.22%   0.00%      0.01      0.00      0.00      0.01                1     Stupidedi::Reader::StreamReader#read_segment
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Reader::StreamReader#consume_isa
                      0.00      0.00      0.00      0.00           1/3106     Stupidedi::Either::Success#flatmap
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00        364/40586     Stupidedi::Reader::TokenReader#read_component_element
                      0.00      0.00      0.00      0.00        244/40586     Array#map
                      0.00      0.00      0.00      0.00        179/40586     Array#each
                      0.00      0.00      0.00      0.00       7426/40586     Stupidedi::Reader::FileInput#at
                      0.00      0.00      0.00      0.00       3570/40586     Hash#each
                      0.00      0.00      0.00      0.00         12/40586     <Class::Date>#jd_to_civil
                      0.00      0.00      0.00      0.00          4/40586     <Class::Date>#jd_to_ajd
                      0.00      0.00      0.00      0.00          1/40586     Stupidedi::Reader::TokenReader#read_character
                      0.00      0.00      0.00      0.00          4/40586     Array#init
                      0.00      0.00      0.00      0.00       4366/40586     Stupidedi::Reader::TokenReader#read_simple_element
                      0.00      0.00      0.00      0.00          3/40586     Stupidedi::Reader::StreamReader#consume_isa
                      0.00      0.00      0.00      0.00         15/40586     Stupidedi::Reader::TokenReader#consume_prefix
                      0.00      0.00      0.00      0.00         28/40586     <Class::Date>#civil_to_jd
                      0.00      0.00      0.00      0.00       1423/40586     Stupidedi::Reader::TokenReader#read_delimiter
                      0.00      0.00      0.00      0.00       1252/40586     Stupidedi::Reader::TokenReader#read_segment_id
                      0.00      0.00      0.00      0.00      10209/40586     Stupidedi::Reader::FileInput#defined_at?
                      0.01      0.01      0.00      0.00      11486/40586     Stupidedi::Reader::FileInput#drop
   1.22%   1.22%      0.01      0.01      0.00      0.00            40586     Fixnum#+
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         260/4210     Stupidedi::Reader::TokenReader#read_component_element
                      0.00      0.00      0.00      0.00           3/4210     Stupidedi::Reader::StreamReader#consume_isa
                      0.00      0.00      0.00      0.00         581/4210     Stupidedi::Reader::TokenReader#read_segment_id
                      0.00      0.00      0.00      0.00          15/4210     Stupidedi::Reader::TokenReader#consume_prefix
                      0.01      0.01      0.00      0.00        3351/4210     Stupidedi::Reader::TokenReader#read_simple_element
   1.22%   1.22%      0.01      0.01      0.00      0.00             4210     String#<<
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00        364/10209     Stupidedi::Reader::TokenReader#read_component_element
                      0.00      0.00      0.00      0.00       2781/10209     Stupidedi::Reader::TokenReader#advance
                      0.00      0.00      0.00      0.00          3/10209     Stupidedi::Reader::StreamReader#advance
                      0.00      0.00      0.00      0.00          1/10209     Stupidedi::Reader::TokenReader#read_character
                      0.00      0.00      0.00      0.00       1253/10209     Stupidedi::Reader::TokenReader#read_segment_id
                      0.00      0.00      0.00      0.00         15/10209     Stupidedi::Reader::TokenReader#consume_prefix
                      0.00      0.00      0.00      0.00       1423/10209     Stupidedi::Reader::TokenReader#read_delimiter
                      0.00      0.00      0.00      0.00          3/10209     Stupidedi::Reader::StreamReader#consume_isa
                      0.01      0.01      0.00      0.00       4366/10209     Stupidedi::Reader::TokenReader#read_simple_element
   1.22%   1.22%      0.01      0.01      0.00      0.00            10209     Stupidedi::Reader::FileInput#defined_at?
                      0.00      0.00      0.00      0.00      10209/40586     Fixnum#+
                      0.00      0.00      0.00      0.00      10209/10874     Fixnum#<
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            12/16     Array#each
                      0.01      0.00      0.00      0.01             4/16     <Class::Stupidedi::Builder_::TransactionSetState>#push
   1.22%   0.00%      0.01      0.00      0.00      0.01               16     <Class::Stupidedi::Builder_::TableState>#push
                      0.01      0.00      0.00      0.01           16/100     Stupidedi::Builder_::InstructionTable::NonEmpty#push
                      0.00      0.00      0.00      0.00              8/8     Stupidedi::Schema::TableDef#empty
                      0.00      0.00      0.00      0.00             8/72     <Class::Stupidedi::Builder_::LoopState>#push
                      0.00      0.00      0.00      0.00            24/48     Module#===
                      0.00      0.00      0.00      0.00             8/88     <Class::Stupidedi::Builder_::AbstractState>#segment
                      0.00      0.00      0.00      0.00            16/16     <Class::Stupidedi::Builder_::TableState>#instructions
                      0.00      0.00      0.00      0.00         16/23624     Class#new
                      0.00      0.00      0.00      0.00              8/8     Stupidedi::Schema::TableDef#value
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01              4/4     Array#each
   1.22%   0.00%      0.01      0.00      0.00      0.01                4     <Class::Stupidedi::Builder_::TransactionSetState>#push
                      0.01      0.00      0.00      0.01             4/16     <Class::Stupidedi::Builder_::TableState>#push
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Envelope::TransactionSetDef#empty
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Configuration::TransactionSetConfig#defined_at?
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Envelope::TransactionSetDef#entry_segment_use
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Configuration::TransactionSetConfig#at
                      0.00      0.00      0.00      0.00              4/8     Stupidedi::Values::SegmentValGroup#at
                      0.00      0.00      0.00      0.00            4/100     Stupidedi::Builder_::InstructionTable::NonEmpty#push
                      0.00      0.00      0.00      0.00            4/140     String#blankness?
                      0.00      0.00      0.00      0.00             4/12     Stupidedi::Values::SegmentVal#at
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal::NonEmpty#to_s
                      0.00      0.00      0.00      0.00             2/53     Kernel#singleton_method_added
                      0.00      0.00      0.00      0.00             1/48     Class#inherited
                      0.00      0.00      0.00      0.00             8/24     Stupidedi::Builder_::AbstractState#config
                      0.00      0.00      0.00      0.00              4/4     <Class::Stupidedi::Builder_::TransactionSetState>#instructions
                      0.00      0.00      0.00      0.00           4/2256     Array#head
                      0.00      0.00      0.00      0.00            7/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00             3/62     Module#attr_reader
                      0.00      0.00      0.00      0.00          4/23624     Class#new
                      0.00      0.00      0.00      0.00           8/1471     Array#at
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          224/293     Stupidedi::Builder_::InstructionTable::NonEmpty#successors
                      0.01      0.01      0.00      0.00           69/293     Array#each
   1.22%   1.22%      0.01      0.01      0.00      0.00              293     Hash#at
                      0.00      0.00      0.00      0.00         293/2113     Hash#[]
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00       3903/11329     Stupidedi::Reader::FileInput#drop
                      0.01      0.01      0.00      0.00       7426/11329     Stupidedi::Reader::FileInput#at
   1.22%   1.22%      0.01      0.01      0.00      0.00            11329     IO#seek
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          19/3102     <Class::Stupidedi::Builder_::AbstractState>#lsequence
                      0.00      0.00      0.00      0.00           8/3102     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal>#value
                      0.00      0.00      0.00      0.00         600/3102     Array#map
                      0.00      0.00      0.00      0.00          16/3102     Stupidedi::Values::CompositeElementVal#initialize
                      0.00      0.00      0.00      0.00         240/3102     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal>#value
                      0.00      0.00      0.00      0.00          16/3102     Stupidedi::Values::TableVal#initialize
                      0.00      0.00      0.00      0.00           4/3102     Stupidedi::Envelope::TransactionSetVal#initialize
                      0.00      0.00      0.00      0.00          80/3102     Stupidedi::Values::SegmentVal#initialize
                      0.00      0.00      0.00      0.00         139/3102     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
                      0.00      0.00      0.00      0.00           8/3102     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal>#value
                      0.00      0.00      0.00      0.00          72/3102     Stupidedi::Values::LoopVal#initialize
                      0.00      0.00      0.00      0.00           4/3102     Stupidedi::Envelope::FunctionalGroupVal#initialize
                      0.00      0.00      0.00      0.00          32/3102     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal::NonEmpty#initialize
                      0.00      0.00      0.00      0.00           4/3102     Stupidedi::Builder_::ConstraintTable::ValueBased#select
                      0.00      0.00      0.00      0.00           8/3102     Stupidedi::Values::SegmentValGroup#defined_at?
                      0.00      0.00      0.00      0.00           8/3102     Stupidedi::Values::SegmentValGroup#at
                      0.00      0.00      0.00      0.00          12/3102     Stupidedi::Values::SegmentVal#at
                      0.01      0.01      0.00      0.00        1832/3102     Array#each
   1.22%   1.22%      0.01      0.01      0.00      0.00             3102     Kernel#nil?
--------------------------------------------------------------------------------
                      0.01      0.01      0.00      0.00        7201/7201     <Module::Stupidedi::Reader>#is_control_character?
   1.22%   1.22%      0.01      0.01      0.00      0.00             7201     String#=~
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01            12/12     Array#each
   1.22%   0.00%      0.01      0.00      0.00      0.01               12     Stupidedi::Builder_::TransactionSetState#drop
                      0.01      0.00      0.00      0.01              4/4     Stupidedi::Builder_::TransactionSetState#copy
                      0.00      0.00      0.00      0.00          12/2974     Fixnum#zero?
                      0.00      0.00      0.00      0.00            4/368     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01          503/503     Hash#each
   1.22%   0.00%      0.01      0.00      0.00      0.01              503     <Class::Stupidedi::Builder_::ConstraintTable>#build
                      0.01      0.01      0.00      0.00          218/677     Array#map
                      0.00      0.00      0.00      0.00          109/109     Array#uniq
                      0.00      0.00      0.00      0.00          110/574     Enumerable#any?
                      0.00      0.00      0.00      0.00        612/12115     Fixnum#>
                      0.00      0.00      0.00      0.00        503/23624     Class#new
                      0.00      0.00      0.00      0.00         612/1677     Array#length
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01            72/72     <Class::Stupidedi::Builder_::LoopState>#push
   1.22%   0.00%      0.01      0.00      0.00      0.01               72     <Class::Stupidedi::Builder_::LoopState>#instructions
                      0.01      0.00      0.00      0.01            30/42     <Class::Stupidedi::Builder_::AbstractState>#sequence
                      0.00      0.00      0.00      0.00          15/2256     Array#head
                      0.00      0.00      0.00      0.00           30/221     Array#concat
                      0.00      0.00      0.00      0.00            15/71     Stupidedi::Schema::SegmentUse#repeatable?
                      0.00      0.00      0.00      0.00           15/843     Array#tail
                      0.00      0.00      0.00      0.00          72/2113     Hash#[]
                      0.00      0.00      0.00      0.00            15/19     <Class::Stupidedi::Builder_::AbstractState>#lsequence
                      0.00      0.00      0.00      0.00          1/23624     Class#new
                      0.00      0.00      0.00      0.00          30/1677     Array#length
                      0.00      0.00      0.00      0.00          15/1432     Hash#[]=
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           4/2113     <Class::Stupidedi::Builder_::FunctionalGroupState>#instructions
                      0.00      0.00      0.00      0.00         293/2113     Hash#at
                      0.00      0.00      0.00      0.00         850/2113     Array#each
                      0.00      0.00      0.00      0.00          16/2113     <Class::Stupidedi::Builder_::TableState>#instructions
                      0.00      0.00      0.00      0.00           4/2113     <Class::Stupidedi::Builder_::TransactionSetState>#instructions
                      0.00      0.00      0.00      0.00           4/2113     Stupidedi::Configuration::FunctionalGroupConfig#at
                      0.00      0.00      0.00      0.00           4/2113     Stupidedi::Configuration::InterchangeConfig#at
                      0.00      0.00      0.00      0.00         273/2113     OpenStruct#method_missing
                      0.00      0.00      0.00      0.00           1/2113     Unknown#segment
                      0.00      0.00      0.00      0.00          72/2113     <Class::Stupidedi::Builder_::LoopState>#instructions
                      0.00      0.00      0.00      0.00         368/2113     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
                      0.00      0.00      0.00      0.00           4/2113     <Class::Stupidedi::Builder_::InterchangeState>#instructions
                      0.00      0.00      0.00      0.00           4/2113     Stupidedi::Configuration::TransactionSetConfig#at
                      0.00      0.00      0.00      0.00         116/2113     Unknown#element
                      0.01      0.00      0.00      0.01         100/2113     Stupidedi::Builder_::InstructionTable::NonEmpty#push
   1.22%   0.00%      0.01      0.00      0.00      0.01             2113     Hash#[]
                      0.01      0.01      0.00      0.00          104/130     Array#hash
                      0.00      0.00      0.00      0.00         101/1542     Kernel#hash
                      0.00      0.00      0.00      0.00              4/8     Array#eql?
                      0.00      0.00      0.00      0.00        1065/1065     Hash#default
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           16/111     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal>#value
                      0.00      0.00      0.00      0.00            4/111     <Class::Stupidedi::Builder_::InterchangeState>#push
                      0.00      0.00      0.00      0.00           12/111     Stupidedi::Values::SegmentVal#defined_at?
                      0.00      0.00      0.00      0.00            8/111     Stupidedi::Schema::LoopDef#repeatable?
                      0.01      0.00      0.00      0.01           71/111     Stupidedi::Schema::SegmentUse#repeatable?
   1.22%   0.00%      0.01      0.00      0.00      0.01              111     Object#try
                      0.01      0.01      0.00      0.00          64/1080     Stupidedi::Schema::RepeatCount::Bounded#include?
                      0.00      0.00      0.00      0.00            13/13     Array#include?
                      0.00      0.00      0.00      0.00             4/19     Kernel#__send__
                      0.00      0.00      0.00      0.00             8/68     String#to_i
                      0.00      0.00      0.00      0.00           16/140     String#blankness?
                      0.00      0.00      0.00      0.00         111/3923     Array#empty?
                      0.00      0.00      0.00      0.00              2/2     #<Class:0xb7544748>#include?
                      0.00      0.00      0.00      0.00            12/24     Array#defined_at?
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01            15/15     Stupidedi::Builder_::ConstraintTable::ValueBased#matches
   1.22%   0.00%      0.01      0.00      0.00      0.01               15     Stupidedi::Builder_::ConstraintTable::ValueBased#deepest
                      0.00      0.00      0.00      0.00            15/15     Hash#values
                      0.00      0.00      0.00      0.00          15/1944     Array#each
                      0.00      0.00      0.00      0.00         15/23624     Class#new
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01              4/4     Stupidedi::Builder_::TransactionSetState#drop
   1.22%   0.00%      0.01      0.00      0.00      0.01                4     Stupidedi::Builder_::TransactionSetState#copy
                      0.01      0.00      0.00      0.01          4/23624     Class#new
                      0.00      0.00      0.00      0.00          4/13048     Kernel#class
                      0.00      0.00      0.00      0.00         12/30212     Hash#fetch
--------------------------------------------------------------------------------
                      0.01      0.01      0.00      0.00        4192/4192     Class#new
   1.22%   1.22%      0.01      0.01      0.00      0.00             4192     Stupidedi::Reader::Success#initialize
--------------------------------------------------------------------------------
                      0.01      0.01      0.00      0.00        2795/2795     Class#new
   1.22%   1.22%      0.01      0.01      0.00      0.00             2795     Stupidedi::Reader::TokenReader#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         138/1154     Integer#times
                      0.01      0.01      0.00      0.00        1016/1154     Stupidedi::Reader::TokenReader#read_elements
   1.22%   1.22%      0.01      0.01      0.00      0.00             1154     Stupidedi::Schema::ElementUse#composite?
                      0.00      0.00      0.00      0.00        1093/1653     Stupidedi::Schema::SimpleElementUse#simple?
                      0.00      0.00      0.00      0.00            61/73     Stupidedi::Schema::CompositeElementUse#simple?
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01            72/72     <Class::Stupidedi::Builder_::LoopState>#push
   1.22%   0.00%      0.01      0.00      0.00      0.01               72     Stupidedi::Schema::LoopDef#value
                      0.01      0.00      0.00      0.01         72/23624     Class#new
                      0.00      0.00      0.00      0.00            9/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00             1/48     Class#inherited
                      0.00      0.00      0.00      0.00             3/62     Module#attr_reader
                      0.00      0.00      0.00      0.00          72/1317     Object#cons
                      0.00      0.00      0.00      0.00              1/7     Module#include
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00        1016/1080     Stupidedi::Reader::TokenReader#read_elements
                      0.01      0.01      0.00      0.00          64/1080     Object#try
   1.22%   1.22%      0.01      0.01      0.00      0.00             1080     Stupidedi::Schema::RepeatCount::Bounded#include?
                      0.00      0.00      0.00      0.00        1080/1088     Fixnum#<=
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             2/42     <Class::Stupidedi::Builder_::FunctionalGroupState>#instructions
                      0.00      0.00      0.00      0.00             8/42     <Class::Stupidedi::Builder_::TableState>#instructions
                      0.00      0.00      0.00      0.00             2/42     <Class::Stupidedi::Builder_::InterchangeState>#instructions
                      0.01      0.00      0.00      0.01            30/42     <Class::Stupidedi::Builder_::LoopState>#instructions
   1.22%   0.00%      0.01      0.00      0.00      0.01               42     <Class::Stupidedi::Builder_::AbstractState>#sequence
                      0.00      0.00      0.00      0.00          42/3923     Array#empty?
                      0.00      0.00      0.00      0.00            17/71     Stupidedi::Schema::SegmentUse#repeatable?
                      0.00      0.00      0.00      0.00          19/1510     Fixnum#==
                      0.00      0.00      0.00      0.00           5/7575     Fixnum#-
                      0.00      0.00      0.00      0.00          61/1944     Array#each
                      0.00      0.00      0.00      0.00          24/1677     Array#length
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         612/1677     <Class::Stupidedi::Builder_::ConstraintTable>#build
                      0.00      0.00      0.00      0.00          36/1677     <Class::Stupidedi::Builder_::AbstractState>#lsequence
                      0.00      0.00      0.00      0.00           2/1677     <Class::Stupidedi::Builder_::FunctionalGroupState>#instructions
                      0.00      0.00      0.00      0.00          91/1677     Array#each
                      0.00      0.00      0.00      0.00          24/1677     Array#defined_at?
                      0.00      0.00      0.00      0.00           8/1677     <Class::Stupidedi::Builder_::TableState>#instructions
                      0.00      0.00      0.00      0.00          30/1677     <Class::Stupidedi::Builder_::LoopState>#instructions
                      0.00      0.00      0.00      0.00           1/1677     <Class::Stupidedi::Builder_::AbstractState>#tsequence
                      0.00      0.00      0.00      0.00          24/1677     <Class::Stupidedi::Builder_::AbstractState>#sequence
                      0.00      0.00      0.00      0.00           2/1677     <Class::Stupidedi::Builder_::InterchangeState>#instructions
                      0.00      0.00      0.00      0.00          13/1677     Integer#times
                      0.00      0.00      0.00      0.00          15/1677     Stupidedi::Builder_::ConstraintTable::ValueBased#basis
                      0.00      0.00      0.00      0.00         274/1677     OpenStruct#method_missing
                      0.00      0.00      0.00      0.00          22/1677     Stupidedi::Builder_::InstructionTable::NonEmpty#push
                      0.00      0.00      0.00      0.00         384/1677     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
                      0.01      0.01      0.00      0.00         139/1677     Stupidedi::Builder_::InstructionTable::NonEmpty#length
   1.22%   1.22%      0.01      0.01      0.00      0.00             1677     Array#length
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             4/19     Object#try
                      0.01      0.00      0.00      0.01            15/19     Symbol#call
   1.22%   0.00%      0.01      0.00      0.00      0.01               19     Kernel#__send__
                      0.01      0.00      0.00      0.01          15/1015     Stupidedi::Reader::TokenReader#read_simple_element
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01          139/139     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
   1.22%   0.00%      0.01      0.00      0.00      0.01              139     Stupidedi::Builder_::InstructionTable::NonEmpty#length
                      0.01      0.01      0.00      0.00         139/1677     Array#length
--------------------------------------------------------------------------------
                      0.01      0.01      0.00      0.00              8/8     Class#new
   1.22%   1.22%      0.01      0.01      0.00      0.00                8     Stupidedi::Builder_::TransactionSetState#initialize
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01          223/223     Stupidedi::Reader::Success#map
   1.22%   0.00%      0.01      0.00      0.00      0.01              223     Stupidedi::Reader::TokenReader#segment
                      0.01      0.01      0.00      0.00          223/223     <Class::Stupidedi::Reader::SegmentTok>#build
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            17/71     <Class::Stupidedi::Builder_::AbstractState>#sequence
                      0.00      0.00      0.00      0.00            15/71     <Class::Stupidedi::Builder_::LoopState>#instructions
                      0.00      0.00      0.00      0.00             1/71     <Class::Stupidedi::Builder_::InterchangeState>#instructions
                      0.01      0.00      0.00      0.01            38/71     Array#each
   1.22%   0.00%      0.01      0.00      0.00      0.01               71     Stupidedi::Schema::SegmentUse#repeatable?
                      0.01      0.00      0.00      0.01           71/111     Object#try
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01            15/15     Stupidedi::Either::Success#flatmap
   1.22%   0.00%      0.01      0.00      0.00      0.01               15     Symbol#call
                      0.01      0.00      0.00      0.01            15/19     Kernel#__send__
--------------------------------------------------------------------------------
                      0.01      0.01      0.00      0.00          223/223     Stupidedi::Reader::TokenReader#segment
   1.22%   1.22%      0.01      0.01      0.00      0.00              223     <Class::Stupidedi::Reader::SegmentTok>#build
                      0.00      0.00      0.00      0.00        223/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           22/130     Hash#[]=
                      0.00      0.00      0.00      0.00            4/130     Hash#include?
                      0.01      0.01      0.00      0.00          104/130     Hash#[]
   1.22%   1.22%      0.01      0.01      0.00      0.00              130     Array#hash
                      0.00      0.00      0.00      0.00        1302/1542     Kernel#hash
                      0.00      0.00      0.00      0.00            24/24     String#hash
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01            13/13     Integer#times
   1.22%   0.00%      0.01      0.00      0.00      0.01               13     Range#each
                      0.00      0.00      0.00      0.00             2/18     Stupidedi::Builder_::ConstraintTable::ValueBased#build_disjoint
                      0.00      0.00      0.00      0.00           2/1462     Array#<<
                      0.00      0.00      0.00      0.00         114/1944     Array#each
--------------------------------------------------------------------------------
                      0.01      0.01      0.00      0.00        3162/3162     Class#new
   1.22%   1.22%      0.01      0.01      0.00      0.00             3162     Stupidedi::Builder_::Instruction#initialize
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01            48/48     Stupidedi::Either::Success#flatmap
   1.22%   0.00%      0.01      0.00      0.00      0.01               48     Stupidedi::Reader::TokenReader#composite
                      0.01      0.01      0.00      0.00             1/48     Class#inherited
                      0.00      0.00      0.00      0.00            48/48     <Class::Stupidedi::Reader::CompositeElementTok>#build
                      0.00      0.00      0.00      0.00             1/53     Kernel#singleton_method_added
                      0.00      0.00      0.00      0.00            6/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00             3/62     Module#attr_reader
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01            72/72     Class#new
   1.22%   0.00%      0.01      0.00      0.00      0.01               72     Stupidedi::Values::LoopVal#initialize
                      0.01      0.00      0.00      0.01           72/677     Array#map
                      0.00      0.00      0.00      0.00          72/3102     Kernel#nil?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            1/169     Array#each
                      0.01      0.00      0.00      0.01          168/169     Stupidedi::AbsoluteSet#size
   1.22%   0.00%      0.01      0.00      0.00      0.01              169     Enumerable#inject
                      0.01      0.01      0.00      0.00          168/277     Hash#each
                      0.00      0.00      0.00      0.00           1/1944     Array#each
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01          104/104     Stupidedi::Reader::TokenReader#read_component_element
   1.22%   0.00%      0.01      0.00      0.00      0.01              104     Stupidedi::Reader::TokenReader#component
                      0.01      0.01      0.00      0.00          104/104     <Class::Stupidedi::Reader::ComponentElementTok>#build
                      0.00      0.00      0.00      0.00             1/48     Class#inherited
                      0.00      0.00      0.00      0.00             1/53     Kernel#singleton_method_added
                      0.00      0.00      0.00      0.00            4/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00             3/62     Module#attr_reader
--------------------------------------------------------------------------------
                      0.01      0.01      0.00      0.00          104/104     Stupidedi::Reader::TokenReader#component
   1.22%   1.22%      0.01      0.01      0.00      0.00              104     <Class::Stupidedi::Reader::ComponentElementTok>#build
                      0.00      0.00      0.00      0.00        104/23624     Class#new
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01          511/511     Array#each
   1.22%   0.00%      0.01      0.00      0.00      0.01              511     Stupidedi::AbstractSet#disjoint?
                      0.01      0.00      0.00      0.01          201/201     Stupidedi::AbsoluteSet#intersection
                      0.00      0.00      0.00      0.00          201/201     Stupidedi::AbsoluteSet#empty?
                      0.00      0.00      0.00      0.00          155/155     #<Class:0xb7532b88>#empty?
                      0.00      0.00      0.00      0.00          155/155     #<Class:0xb7339a34>#empty?
                      0.00      0.00      0.00      0.00          310/310     #<Class:0xb7532b88>#intersection
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           12/600     <Class::Stupidedi::Builder_::AbstractState>#composite_element
                      0.01      0.00      0.00      0.01          588/600     <Class::Stupidedi::Builder_::AbstractState>#simple_element
   1.22%   0.00%      0.01      0.00      0.00      0.01              600     Stupidedi::Schema::ElementUse#value
                      0.01      0.00      0.00      0.01          588/588     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
                      0.00      0.00      0.00      0.00            12/12     Stupidedi::Schema::CompositeElementDef#value
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01            80/80     Array#map
   1.22%   0.00%      0.01      0.00      0.00      0.01               80     Stupidedi::Values::SegmentVal#copy
                      0.00      0.00      0.00      0.00        320/30212     Hash#fetch
                      0.00      0.00      0.00      0.00         80/13048     Kernel#class
                      0.00      0.00      0.00      0.00         80/23624     Class#new
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01          168/168     Class#new
   1.22%   0.00%      0.01      0.00      0.00      0.01              168     Stupidedi::Values::SegmentVal#initialize
                      0.00      0.00      0.00      0.00          88/1360     NilClass#nil?
                      0.00      0.00      0.00      0.00          80/3102     Kernel#nil?
                      0.00      0.00      0.00      0.00           80/677     Array#map
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           84/168     Stupidedi::AbsoluteSet#union
                      0.01      0.00      0.00      0.01           84/168     Stupidedi::AbsoluteSet#intersection
   1.22%   0.00%      0.01      0.00      0.00      0.01              168     Stupidedi::AbsoluteSet#as_mask
                      0.01      0.00      0.00      0.01          168/168     Stupidedi::AbsoluteSet#size
                      0.00      0.00      0.00      0.00         168/4712     Kernel#is_a?
                      0.00      0.00      0.00      0.00          168/168     Stupidedi::AbstractSet#infinite?
                      0.00      0.00      0.00      0.00          168/168     #<Class:0xb7339a34>#each
                      0.00      0.00      0.00      0.00        168/10874     Fixnum#<
                      0.00      0.00      0.00      0.00          168/168     #<Class:0xb7339a34>#size
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01          201/201     Stupidedi::AbstractSet#disjoint?
   1.22%   0.00%      0.01      0.00      0.00      0.01              201     Stupidedi::AbsoluteSet#intersection
                      0.01      0.00      0.00      0.01           84/168     Stupidedi::AbsoluteSet#as_mask
                      0.00      0.00      0.00      0.00            33/33     Bignum#&
                      0.00      0.00      0.00      0.00        201/13048     Kernel#class
                      0.00      0.00      0.00      0.00         201/4712     Kernel#is_a?
                      0.00      0.00      0.00      0.00         117/1014     Kernel#eql?
                      0.00      0.00      0.00      0.00          168/168     Fixnum#&
                      0.00      0.00      0.00      0.00          201/491     Stupidedi::AbsoluteSet#copy
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01          588/588     Stupidedi::Schema::ElementUse#value
   1.22%   0.00%      0.01      0.00      0.00      0.01              588     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
                      0.01      0.01      0.00      0.00              8/8     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DT#companion
                      0.00      0.00      0.00      0.00            24/24     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal>#value
                      0.00      0.00      0.00      0.00          240/240     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal>#value
                      0.00      0.00      0.00      0.00            20/20     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DecimalVal>#value
                      0.00      0.00      0.00      0.00              4/4     #<Class:0xb754a490>#companion
                      0.00      0.00      0.00      0.00              8/8     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TM#companion
                      0.00      0.00      0.00      0.00            24/32     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::Nn#companion
                      0.00      0.00      0.00      0.00          240/352     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::ID#companion
                      0.00      0.00      0.00      0.00              8/8     <Class::Stupidedi::Dictionaries::Interchanges::FiveOhOne::ElementDefs::SeparatorElementVal>#value
                      0.00      0.00      0.00      0.00            20/20     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::R#companion
                      0.00      0.00      0.00      0.00              4/4     #<Class:0xb7549d88>#companion
                      0.00      0.00      0.00      0.00          280/388     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::AN#companion
                      0.00      0.00      0.00      0.00              8/8     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal>#value
                      0.00      0.00      0.00      0.00          280/280     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal>#value
                      0.00      0.00      0.00      0.00              8/8     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal>#value
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01          168/168     Stupidedi::AbsoluteSet#as_mask
   1.22%   0.00%      0.01      0.00      0.00      0.01              168     Stupidedi::AbsoluteSet#size
                      0.01      0.00      0.00      0.01          168/169     Enumerable#inject
--------------------------------------------------------------------------------
                      0.01      0.01      0.00      0.00              8/8     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
   1.22%   1.22%      0.01      0.01      0.00      0.00                8     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DT#companion
                      0.00      0.00      0.00      0.00          1/23479     <Class::Object>#allocate
                      0.00      0.00      0.00      0.00             4/26     Kernel#send
                      0.00      0.00      0.00      0.00             4/22     Object#eigenclass
                      0.00      0.00      0.00      0.00             2/53     Kernel#singleton_method_added
                      0.00      0.00      0.00      0.00             4/48     Class#inherited
                      0.00      0.00      0.00      0.00           21/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00             2/62     Module#attr_reader
--------------------------------------------------------------------------------
                      0.01      0.00      0.00      0.01          388/388     Array#map
   1.22%   0.00%      0.01      0.00      0.00      0.01              388     Stupidedi::Values::SimpleElementVal#copy
                      0.01      0.01      0.00      0.00        388/13048     Kernel#class
                      0.00      0.00      0.00      0.00       1164/30212     Hash#fetch
                      0.00      0.00      0.00      0.00        388/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            9/377     Stupidedi::Schema::TableDef#value
                      0.00      0.00      0.00      0.00           31/377     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00            9/377     Stupidedi::Schema::LoopDef#value
                      0.00      0.00      0.00      0.00            7/377     <Class::Stupidedi::Builder_::FunctionalGroupState>#instructions
                      0.00      0.00      0.00      0.00            4/377     Module#attr_accessor
                      0.00      0.00      0.00      0.00           26/377     Module#class_eval
                      0.00      0.00      0.00      0.00            8/377     Stupidedi::Schema::CompositeElementDef#value
                      0.00      0.00      0.00      0.00            7/377     Array#each
                      0.00      0.00      0.00      0.00           21/377     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DT#companion
                      0.00      0.00      0.00      0.00           68/377     Module#attr_reader
                      0.00      0.00      0.00      0.00            8/377     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::AN#companion
                      0.00      0.00      0.00      0.00           25/377     Stupidedi::Builder_::StateMachine#read!
                      0.00      0.00      0.00      0.00           10/377     Hash#each
                      0.00      0.00      0.00      0.00           18/377     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::R#companion
                      0.00      0.00      0.00      0.00            6/377     Stupidedi::Envelope::TransactionSetDef#empty
                      0.00      0.00      0.00      0.00            7/377     <Class::Stupidedi::Builder_::InterchangeState>#instructions
                      0.00      0.00      0.00      0.00            9/377     #<Class:0xb7563918>#value
                      0.00      0.00      0.00      0.00            6/377     Stupidedi::Reader::TokenReader#composite
                      0.00      0.00      0.00      0.00           18/377     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::Nn#companion
                      0.00      0.00      0.00      0.00           10/377     Stupidedi::Reader::StreamReader#result
                      0.00      0.00      0.00      0.00            9/377     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TM#companion
                      0.00      0.00      0.00      0.00            6/377     Stupidedi::Reader::TokenReader#simple
                      0.00      0.00      0.00      0.00           18/377     Class#initialize
                      0.00      0.00      0.00      0.00            7/377     <Class::Stupidedi::Builder_::TransactionSetState>#push
                      0.00      0.00      0.00      0.00           10/377     #<Class:0xb76cc41c>#value
                      0.00      0.00      0.00      0.00            4/377     Stupidedi::Reader::TokenReader#component
                      0.00      0.00      0.00      0.00            8/377     Stupidedi::Schema::SegmentDef#value
                      0.00      0.00      0.00      0.00            8/377     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::ID#companion
   0.00%   0.00%      0.00      0.00      0.00      0.00              377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00          377/384     Module#==
                      0.00      0.00      0.00      0.00          377/377     Module#blank_slate_method_added
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             4/26     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DT#companion
                      0.00      0.00      0.00      0.00             3/26     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::AN#companion
                      0.00      0.00      0.00      0.00             4/26     OpenStruct#new_ostruct_member
                      0.00      0.00      0.00      0.00             3/26     Stupidedi::Builder_::StateMachine#read!
                      0.00      0.00      0.00      0.00             3/26     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::R#companion
                      0.00      0.00      0.00      0.00             3/26     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::Nn#companion
                      0.00      0.00      0.00      0.00             3/26     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TM#companion
                      0.00      0.00      0.00      0.00             3/26     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::ID#companion
   0.00%   0.00%      0.00      0.00      0.00      0.00               26     Kernel#send
                      0.00      0.00      0.00      0.00              7/7     Module#protected
                      0.00      0.00      0.00      0.00            15/15     Module#public
                      0.00      0.00      0.00      0.00              4/4     Module#define_method
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             1/53     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00             4/53     Module#define_method
                      0.00      0.00      0.00      0.00             2/53     <Class::Stupidedi::Builder_::FunctionalGroupState>#instructions
                      0.00      0.00      0.00      0.00             2/53     Array#each
                      0.00      0.00      0.00      0.00             2/53     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DT#companion
                      0.00      0.00      0.00      0.00             2/53     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::AN#companion
                      0.00      0.00      0.00      0.00             2/53     Stupidedi::Builder_::StateMachine#read!
                      0.00      0.00      0.00      0.00             1/53     Hash#each
                      0.00      0.00      0.00      0.00             2/53     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::R#companion
                      0.00      0.00      0.00      0.00             2/53     <Class::Stupidedi::Builder_::InterchangeState>#instructions
                      0.00      0.00      0.00      0.00             1/53     Stupidedi::Reader::TokenReader#composite
                      0.00      0.00      0.00      0.00             2/53     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::Nn#companion
                      0.00      0.00      0.00      0.00             2/53     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TM#companion
                      0.00      0.00      0.00      0.00             1/53     Stupidedi::Reader::TokenReader#simple
                      0.00      0.00      0.00      0.00            15/53     Module#public
                      0.00      0.00      0.00      0.00             2/53     <Class::Stupidedi::Builder_::TransactionSetState>#push
                      0.00      0.00      0.00      0.00             7/53     Module#protected
                      0.00      0.00      0.00      0.00             1/53     Stupidedi::Reader::TokenReader#component
                      0.00      0.00      0.00      0.00             2/53     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::ID#companion
   0.00%   0.00%      0.00      0.00      0.00      0.00               53     Kernel#singleton_method_added
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             8/11     Stupidedi::Builder_::StateMachine#read!
                      0.00      0.00      0.00      0.00             3/11     #<Class:0xb7563918>#value
   0.00%   0.00%      0.00      0.00      0.00      0.00               11     Module#abstract
                      0.00      0.00      0.00      0.00          11/4712     Kernel#is_a?
                      0.00      0.00      0.00      0.00            11/68     String#to_i
                      0.00      0.00      0.00      0.00              7/7     Array#join
                      0.00      0.00      0.00      0.00          11/3923     Array#empty?
                      0.00      0.00      0.00      0.00            11/19     Array#last
                      0.00      0.00      0.00      0.00         22/13222     Symbol#to_s
                      0.00      0.00      0.00      0.00          11/7575     Fixnum#-
                      0.00      0.00      0.00      0.00            11/19     Array#first
                      0.00      0.00      0.00      0.00            11/15     String#split
                      0.00      0.00      0.00      0.00            11/15     Kernel#caller
                      0.00      0.00      0.00      0.00            11/28     Module#class_eval
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/2     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00              1/2     Stupidedi::Builder_::StateMachine#read!
   0.00%   0.00%      0.00      0.00      0.00      0.00                2     Module#attr_accessor
                      0.00      0.00      0.00      0.00            4/377     <Class::Object>#method_added
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             4/22     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DT#companion
                      0.00      0.00      0.00      0.00             3/22     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::AN#companion
                      0.00      0.00      0.00      0.00             3/22     Stupidedi::Builder_::StateMachine#read!
                      0.00      0.00      0.00      0.00             3/22     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::R#companion
                      0.00      0.00      0.00      0.00             3/22     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::Nn#companion
                      0.00      0.00      0.00      0.00             3/22     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TM#companion
                      0.00      0.00      0.00      0.00             3/22     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::ID#companion
   0.00%   0.00%      0.00      0.00      0.00      0.00               22     Object#eigenclass
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          226/226     Stupidedi::Builder_::StateMachine#read!
   0.00%   0.00%      0.00      0.00      0.00      0.00              226     Stupidedi::Builder_::StateMachine#stuck?
                      0.00      0.00      0.00      0.00         226/3923     Array#empty?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Builder_::StateMachine#read!
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Either::Failure#defined?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Builder_::StateMachine#read!
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Either::Failure#map
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          225/225     Stupidedi::Builder_::StateMachine#read!
   0.00%   0.00%      0.00      0.00      0.00      0.00              225     Stupidedi::Either::Success#defined?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           4/3923     Enumerable#blankness?
                      0.00      0.00      0.00      0.00         226/3923     Stupidedi::Builder_::StateMachine#stuck?
                      0.00      0.00      0.00      0.00         224/3923     Array#each
                      0.00      0.00      0.00      0.00        2256/3923     Array#head
                      0.00      0.00      0.00      0.00           1/3923     <Class::Stupidedi::Builder_::AbstractState>#tsequence
                      0.00      0.00      0.00      0.00         111/3923     Object#try
                      0.00      0.00      0.00      0.00          42/3923     <Class::Stupidedi::Builder_::AbstractState>#sequence
                      0.00      0.00      0.00      0.00          11/3923     Module#abstract
                      0.00      0.00      0.00      0.00        1048/3923     Stupidedi::Reader::TokenReader#read_elements
   0.00%   0.00%      0.00      0.00      0.00      0.00             3923     Array#empty?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             4/19     Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeVal#initialize
                      0.00      0.00      0.00      0.00             4/19     Module#delegate
                      0.00      0.00      0.00      0.00            11/19     Module#abstract
   0.00%   0.00%      0.00      0.00      0.00      0.00               19     Array#first
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              7/7     Module#abstract
   0.00%   0.00%      0.00      0.00      0.00      0.00                7     Array#join
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             8/19     Module#delegate
                      0.00      0.00      0.00      0.00            11/19     Module#abstract
   0.00%   0.00%      0.00      0.00      0.00      0.00               19     Array#last
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           3/7575     Stupidedi::Builder_::InterchangeState#pop
                      0.00      0.00      0.00      0.00           4/7575     Stupidedi::Builder_::FunctionalGroupState#pop
                      0.00      0.00      0.00      0.00         104/7575     Stupidedi::Reader::TokenReader#read_component_element
                      0.00      0.00      0.00      0.00          17/7575     <Class::Stupidedi::Builder_::AbstractState>#lsequence
                      0.00      0.00      0.00      0.00        2740/7575     Array#map
                      0.00      0.00      0.00      0.00          40/7575     Array#each
                      0.00      0.00      0.00      0.00        2781/7575     Stupidedi::Reader::TokenReader#advance
                      0.00      0.00      0.00      0.00          32/7575     <Class::Date>#jd_to_civil
                      0.00      0.00      0.00      0.00           3/7575     Stupidedi::Reader::StreamReader#advance
                      0.00      0.00      0.00      0.00           8/7575     <Class::Date>#jd_to_ajd
                      0.00      0.00      0.00      0.00         245/7575     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
                      0.00      0.00      0.00      0.00          13/7575     Integer#times
                      0.00      0.00      0.00      0.00          16/7575     Stupidedi::Builder_::TableState#pop
                      0.00      0.00      0.00      0.00          72/7575     Stupidedi::Builder_::LoopState#pop
                      0.00      0.00      0.00      0.00           4/7575     Rational#-
                      0.00      0.00      0.00      0.00         223/7575     Stupidedi::Reader::FileInput#drop
                      0.00      0.00      0.00      0.00           5/7575     <Class::Stupidedi::Builder_::AbstractState>#sequence
                      0.00      0.00      0.00      0.00          11/7575     Module#abstract
                      0.00      0.00      0.00      0.00           4/7575     Stupidedi::Builder_::TransactionSetState#pop
                      0.00      0.00      0.00      0.00          12/7575     <Class::Date>#civil_to_jd
                      0.00      0.00      0.00      0.00         223/7575     Stupidedi::Reader::TokenReader#read_segment_id
                      0.00      0.00      0.00      0.00        1015/7575     Stupidedi::Reader::TokenReader#read_simple_element
   0.00%   0.00%      0.00      0.00      0.00      0.00             7575     Fixnum#-
                      0.00      0.00      0.00      0.00              4/4     Rational#coerce
                      0.00      0.00      0.00      0.00              4/4     Rational#-
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             4/15     Module#delegate
                      0.00      0.00      0.00      0.00            11/15     Module#abstract
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
                      0.00      0.00      0.00      0.00             4/15     Module#delegate
                      0.00      0.00      0.00      0.00            11/15     Module#abstract
   0.00%   0.00%      0.00      0.00      0.00      0.00               15     String#split
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            12/68     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal::Proper#initialize
                      0.00      0.00      0.00      0.00             8/68     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal>#value
                      0.00      0.00      0.00      0.00            17/68     Array#each
                      0.00      0.00      0.00      0.00            12/68     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal::Improper#initialize
                      0.00      0.00      0.00      0.00             8/68     Object#try
                      0.00      0.00      0.00      0.00            11/68     Module#abstract
   0.00%   0.00%      0.00      0.00      0.00      0.00               68     String#to_i
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          1/23479     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00      23177/23479     Class#new
                      0.00      0.00      0.00      0.00          1/23479     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DT#companion
                      0.00      0.00      0.00      0.00         13/23479     Integer#times
                      0.00      0.00      0.00      0.00          4/23479     Class#new!
                      0.00      0.00      0.00      0.00        278/23479     Array#drop
                      0.00      0.00      0.00      0.00          1/23479     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TM#companion
                      0.00      0.00      0.00      0.00          4/23479     Array#init
   0.00%   0.00%      0.00      0.00      0.00      0.00            23479     <Class::Object>#allocate
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Reader::TokenReader#read_segment
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Either::Failure#flatmap
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00        4434/4434     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00             4434     Stupidedi::Either::Success#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Reader::StreamReader#read_segment
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Reader::StreamReader#consume_isa
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Reader::StreamReader#success
                      0.00      0.00      0.00      0.00            3/226     String#upcase
                      0.00      0.00      0.00      0.00          3/10209     Stupidedi::Reader::FileInput#defined_at?
                      0.00      0.00      0.00      0.00          3/40586     Fixnum#+
                      0.00      0.00      0.00      0.00           3/4210     String#<<
                      0.00      0.00      0.00      0.00              3/3     String#slice!
                      0.00      0.00      0.00      0.00           3/7201     <Module::Stupidedi::Reader>#is_control_character?
                      0.00      0.00      0.00      0.00              1/3     Stupidedi::Reader::StreamReader#advance
                      0.00      0.00      0.00      0.00           3/7426     Stupidedi::Reader::FileInput#at
                      0.00      0.00      0.00      0.00          3/41326     String#==
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          24/1510     <Class::Rational>#reduce
                      0.00      0.00      0.00      0.00          19/1510     <Class::Stupidedi::Builder_::AbstractState>#lsequence
                      0.00      0.00      0.00      0.00         121/1510     Stupidedi::AbsoluteSet#==
                      0.00      0.00      0.00      0.00         207/1510     Array#each
                      0.00      0.00      0.00      0.00           1/1510     <Class::Stupidedi::Builder_::AbstractState>#tsequence
                      0.00      0.00      0.00      0.00         245/1510     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
                      0.00      0.00      0.00      0.00           4/1510     Rational#/
                      0.00      0.00      0.00      0.00          19/1510     <Class::Stupidedi::Builder_::AbstractState>#sequence
                      0.00      0.00      0.00      0.00          15/1510     Stupidedi::Reader::TokenReader#consume_prefix
                      0.00      0.00      0.00      0.00         274/1510     OpenStruct#method_missing
                      0.00      0.00      0.00      0.00         581/1510     Stupidedi::Reader::TokenReader#read_segment_id
   0.00%   0.00%      0.00      0.00      0.00      0.00             1510     Fixnum#==
                      0.00      0.00      0.00      0.00             2/29     Bignum#==
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00        7806/8425     Stupidedi::Reader::FileInput#drop
                      0.00      0.00      0.00      0.00          30/8425     Stupidedi::Reader::TokenReader#consume_prefix
                      0.00      0.00      0.00      0.00         581/8425     Stupidedi::Reader::TokenReader#read_segment_id
                      0.00      0.00      0.00      0.00           8/8425     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal>#value
   0.00%   0.00%      0.00      0.00      0.00      0.00             8425     String#length
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              3/3     Stupidedi::Reader::StreamReader#consume_isa
   0.00%   0.00%      0.00      0.00      0.00      0.00                3     String#slice!
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            1/224     OpenStruct#new_ostruct_member
                      0.00      0.00      0.00      0.00          223/224     Stupidedi::Reader::TokenReader#read_segment_id
   0.00%   0.00%      0.00      0.00      0.00      0.00              224     String#to_sym
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            3/226     Stupidedi::Reader::StreamReader#consume_isa
                      0.00      0.00      0.00      0.00          223/226     Stupidedi::Reader::TokenReader#read_segment_id
   0.00%   0.00%      0.00      0.00      0.00      0.00              226     String#upcase
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Either::Success#flatmap
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Either::Success#or
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              2/3     Stupidedi::Reader::StreamReader#read_character
                      0.00      0.00      0.00      0.00              1/3     Stupidedi::Reader::StreamReader#consume_isa
   0.00%   0.00%      0.00      0.00      0.00      0.00                3     Stupidedi::Reader::StreamReader#advance
                      0.00      0.00      0.00      0.00           3/3903     Stupidedi::Reader::FileInput#drop
                      0.00      0.00      0.00      0.00          3/10209     Stupidedi::Reader::FileInput#defined_at?
                      0.00      0.00      0.00      0.00              3/3     Stupidedi::Reader::StreamReader#copy
                      0.00      0.00      0.00      0.00           3/7575     Fixnum#-
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              2/2     Stupidedi::Either::Success#flatmap
   0.00%   0.00%      0.00      0.00      0.00      0.00                2     Stupidedi::Reader::StreamReader#read_character
                      0.00      0.00      0.00      0.00              2/3     Stupidedi::Reader::StreamReader#result
                      0.00      0.00      0.00      0.00              2/3     Stupidedi::Reader::StreamReader#advance
                      0.00      0.00      0.00      0.00           2/7426     Stupidedi::Reader::FileInput#at
                      0.00      0.00      0.00      0.00              2/2     Stupidedi::Reader::FileInput#empty?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Reader::StreamReader#consume_isa
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Reader::StreamReader#success
                      0.00      0.00      0.00      0.00           1/3106     <Class::Stupidedi::Either>#success
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Reader::TokenReader#read_segment_id
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Reader::TokenReader#failure
                      0.00      0.00      0.00      0.00              1/1     <Class::Stupidedi::Either>#failure
                      0.00      0.00      0.00      0.00          1/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Reader::SegmentDict::NonEmpty#defined_at?
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     #<Class:0xb73af3b0>#defined_at?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     <Class::Stupidedi::Builder_::FunctionalGroupState>#push
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Envelope::FunctionalGroupDef#entry_segment_use
                      0.00      0.00      0.00      0.00              4/4     #<Class:0xb76cc41c>#value
                      0.00      0.00      0.00      0.00             4/60     String#slice
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Configuration::FunctionalGroupConfig#defined_at?
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Envelope::FunctionalGroupVal#segment_dict
                      0.00      0.00      0.00      0.00            4/100     Stupidedi::Builder_::InstructionTable::NonEmpty#push
                      0.00      0.00      0.00      0.00             4/88     <Class::Stupidedi::Builder_::AbstractState>#segment
                      0.00      0.00      0.00      0.00             8/24     Stupidedi::Builder_::AbstractState#config
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Configuration::FunctionalGroupConfig#at
                      0.00      0.00      0.00      0.00              4/7     Stupidedi::Reader::SegmentDict::NonEmpty#push
                      0.00      0.00      0.00      0.00              4/4     <Class::Stupidedi::Builder_::FunctionalGroupState>#instructions
                      0.00      0.00      0.00      0.00          4/23624     Class#new
                      0.00      0.00      0.00      0.00           4/1471     Array#at
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Reader::TokenReader#failure
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     <Class::Stupidedi::Either>#failure
                      0.00      0.00      0.00      0.00          1/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          16/1462     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00           1/1462     <Class::Stupidedi::Builder_::FunctionalGroupState>#instructions
                      0.00      0.00      0.00      0.00        1442/1462     Array#each
                      0.00      0.00      0.00      0.00           1/1462     <Class::Stupidedi::Builder_::InterchangeState>#instructions
                      0.00      0.00      0.00      0.00           2/1462     Range#each
   0.00%   0.00%      0.00      0.00      0.00      0.00             1462     Array#<<
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         12/10874     <Class::Rational>#reduce
                      0.00      0.00      0.00      0.00          8/10874     <Class::Date>#valid_civil?
                      0.00      0.00      0.00      0.00        139/10874     Array#take
                      0.00      0.00      0.00      0.00         24/10874     Array#defined_at?
                      0.00      0.00      0.00      0.00         20/10874     Rational#initialize
                      0.00      0.00      0.00      0.00        168/10874     Stupidedi::AbsoluteSet#as_mask
                      0.00      0.00      0.00      0.00        278/10874     Array#drop
                      0.00      0.00      0.00      0.00      10209/10874     Stupidedi::Reader::FileInput#defined_at?
                      0.00      0.00      0.00      0.00          8/10874     <Class::Date>#julian?
                      0.00      0.00      0.00      0.00          8/10874     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal>#value
   0.00%   0.00%      0.00      0.00      0.00      0.00            10874     Fixnum#<
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00       7426/11329     Stupidedi::Reader::FileInput#at
                      0.00      0.00      0.00      0.00       3903/11329     Stupidedi::Reader::FileInput#drop
   0.00%   0.00%      0.00      0.00      0.00      0.00            11329     Fixnum#>=
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          12/2974     Stupidedi::Builder_::FunctionalGroupState#pop
                      0.00      0.00      0.00      0.00          11/2974     Stupidedi::Builder_::InterchangeState#pop
                      0.00      0.00      0.00      0.00           4/2974     Stupidedi::Builder_::TransmissionState#drop
                      0.00      0.00      0.00      0.00          12/2974     Stupidedi::Builder_::TransactionSetState#drop
                      0.00      0.00      0.00      0.00         136/2974     Array#each
                      0.00      0.00      0.00      0.00         180/2974     Stupidedi::Builder_::LoopState#drop
                      0.00      0.00      0.00      0.00        1735/2974     Hash#each
                      0.00      0.00      0.00      0.00           4/2974     Stupidedi::Builder_::TransmissionState#pop
                      0.00      0.00      0.00      0.00         368/2974     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
                      0.00      0.00      0.00      0.00           8/2974     Stupidedi::Builder_::InterchangeState#drop
                      0.00      0.00      0.00      0.00         252/2974     Stupidedi::Builder_::LoopState#pop
                      0.00      0.00      0.00      0.00          28/2974     Stupidedi::Builder_::TableState#pop
                      0.00      0.00      0.00      0.00           8/2974     Stupidedi::Builder_::FunctionalGroupState#drop
                      0.00      0.00      0.00      0.00         188/2974     Stupidedi::AbsoluteSet#empty?
                      0.00      0.00      0.00      0.00          12/2974     Stupidedi::Builder_::TableState#drop
                      0.00      0.00      0.00      0.00          16/2974     Stupidedi::Builder_::TransactionSetState#pop
   0.00%   0.00%      0.00      0.00      0.00      0.00             2974     Fixnum#zero?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           59/295     Array#each
                      0.00      0.00      0.00      0.00            4/295     Stupidedi::Configuration::InterchangeConfig#defined_at?
                      0.00      0.00      0.00      0.00            4/295     Stupidedi::Configuration::FunctionalGroupConfig#defined_at?
                      0.00      0.00      0.00      0.00            4/295     Stupidedi::Configuration::TransactionSetConfig#defined_at?
                      0.00      0.00      0.00      0.00          224/295     Stupidedi::Builder_::InstructionTable::NonEmpty#successors
   0.00%   0.00%      0.00      0.00      0.00      0.00              295     Hash#defined_at?
                      0.00      0.00      0.00      0.00          295/295     Hash#include?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         206/1014     Stupidedi::AbsoluteSet#union
                      0.00      0.00      0.00      0.00         135/1014     Stupidedi::AbsoluteSet#==
                      0.00      0.00      0.00      0.00         188/1014     Array#each
                      0.00      0.00      0.00      0.00         117/1014     Stupidedi::AbsoluteSet#intersection
                      0.00      0.00      0.00      0.00         368/1014     #<Class:0xb7532b88>#==
   0.00%   0.00%      0.00      0.00      0.00      0.00             1014     Kernel#eql?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             3/62     Stupidedi::Schema::TableDef#value
                      0.00      0.00      0.00      0.00             6/62     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00             3/62     Stupidedi::Schema::LoopDef#value
                      0.00      0.00      0.00      0.00             3/62     <Class::Stupidedi::Builder_::FunctionalGroupState>#instructions
                      0.00      0.00      0.00      0.00             4/62     Stupidedi::Schema::CompositeElementDef#value
                      0.00      0.00      0.00      0.00             3/62     Array#each
                      0.00      0.00      0.00      0.00             2/62     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DT#companion
                      0.00      0.00      0.00      0.00             1/62     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::AN#companion
                      0.00      0.00      0.00      0.00             1/62     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::R#companion
                      0.00      0.00      0.00      0.00             3/62     Stupidedi::Envelope::TransactionSetDef#empty
                      0.00      0.00      0.00      0.00             4/62     <Class::Stupidedi::Builder_::InterchangeState>#instructions
                      0.00      0.00      0.00      0.00             3/62     #<Class:0xb7563918>#value
                      0.00      0.00      0.00      0.00             3/62     Stupidedi::Reader::TokenReader#composite
                      0.00      0.00      0.00      0.00             1/62     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::Nn#companion
                      0.00      0.00      0.00      0.00             4/62     Stupidedi::Reader::StreamReader#result
                      0.00      0.00      0.00      0.00             1/62     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TM#companion
                      0.00      0.00      0.00      0.00             3/62     Stupidedi::Reader::TokenReader#simple
                      0.00      0.00      0.00      0.00             3/62     <Class::Stupidedi::Builder_::TransactionSetState>#push
                      0.00      0.00      0.00      0.00             3/62     #<Class:0xb76cc41c>#value
                      0.00      0.00      0.00      0.00             3/62     Stupidedi::Reader::TokenReader#component
                      0.00      0.00      0.00      0.00             4/62     Stupidedi::Schema::SegmentDef#value
                      0.00      0.00      0.00      0.00             1/62     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::ID#companion
   0.00%   0.00%      0.00      0.00      0.00      0.00               62     Module#attr_reader
                      0.00      0.00      0.00      0.00           68/377     <Class::Object>#method_added
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/3     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00              1/3     Hash#each
                      0.00      0.00      0.00      0.00              1/3     Stupidedi::Reader::StreamReader#result
   0.00%   0.00%      0.00      0.00      0.00      0.00                3     Module#private
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         232/1360     Array#map
                      0.00      0.00      0.00      0.00          16/1360     Stupidedi::Values::CompositeElementVal#initialize
                      0.00      0.00      0.00      0.00         940/1360     Array#each
                      0.00      0.00      0.00      0.00          88/1360     Stupidedi::Values::SegmentVal#initialize
                      0.00      0.00      0.00      0.00           4/1360     Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeVal#initialize
                      0.00      0.00      0.00      0.00          16/1360     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal::NonEmpty#initialize
                      0.00      0.00      0.00      0.00          64/1360     Stupidedi::Builder_::ConstraintTable::ValueBased#select
   0.00%   0.00%      0.00      0.00      0.00      0.00             1360     NilClass#nil?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           80/340     Array#each
                      0.00      0.00      0.00      0.00          260/340     Stupidedi::Builder_::AbstractState#segment_dict
   0.00%   0.00%      0.00      0.00      0.00      0.00              340     Stupidedi::Builder_::AbstractState#segment_dict
                      0.00      0.00      0.00      0.00          260/340     Stupidedi::Builder_::AbstractState#segment_dict
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           92/432     Array#each
                      0.00      0.00      0.00      0.00          340/432     Stupidedi::Builder_::AbstractState#separators
   0.00%   0.00%      0.00      0.00      0.00      0.00              432     Stupidedi::Builder_::AbstractState#separators
                      0.00      0.00      0.00      0.00          340/432     Stupidedi::Builder_::AbstractState#separators
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          156/156     Stupidedi::Builder_::InstructionTable::NonEmpty#successors
   0.00%   0.00%      0.00      0.00      0.00      0.00              156     Stupidedi::Builder_::ConstraintTable::Stub#matches
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Builder_::FunctionalGroupState#add
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              8/8     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00                8     Stupidedi::Builder_::FunctionalGroupState#drop
                      0.00      0.00      0.00      0.00            4/368     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
                      0.00      0.00      0.00      0.00           8/2974     Fixnum#zero?
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Builder_::FunctionalGroupState#copy
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             8/12     Array#each
                      0.00      0.00      0.00      0.00             4/12     Stupidedi::Builder_::TransactionSetState#pop
   0.00%   0.00%      0.00      0.00      0.00      0.00               12     Stupidedi::Builder_::FunctionalGroupState#pop
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Builder_::InterchangeState#merge
                      0.00      0.00      0.00      0.00          12/2974     Fixnum#zero?
                      0.00      0.00      0.00      0.00           4/7575     Fixnum#-
                      0.00      0.00      0.00      0.00             4/11     Stupidedi::Builder_::InterchangeState#pop
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Builder_::InterchangeState#add
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              8/8     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00                8     Stupidedi::Builder_::InterchangeState#drop
                      0.00      0.00      0.00      0.00            8/368     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
                      0.00      0.00      0.00      0.00           8/2974     Fixnum#zero?
                      0.00      0.00      0.00      0.00              8/8     Stupidedi::Builder_::InterchangeState#copy
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             4/11     Stupidedi::Builder_::FunctionalGroupState#pop
                      0.00      0.00      0.00      0.00             7/11     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00               11     Stupidedi::Builder_::InterchangeState#pop
                      0.00      0.00      0.00      0.00              3/3     Stupidedi::Builder_::TransmissionState#merge
                      0.00      0.00      0.00      0.00          11/2974     Fixnum#zero?
                      0.00      0.00      0.00      0.00              3/4     Stupidedi::Builder_::TransmissionState#pop
                      0.00      0.00      0.00      0.00           3/7575     Fixnum#-
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          124/124     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00              124     Stupidedi::Builder_::LoopState#add
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          196/252     Array#each
                      0.00      0.00      0.00      0.00           56/252     Stupidedi::Builder_::LoopState#pop
   0.00%   0.00%      0.00      0.00      0.00      0.00              252     Stupidedi::Builder_::LoopState#pop
                      0.00      0.00      0.00      0.00            56/56     Stupidedi::Builder_::LoopState#merge
                      0.00      0.00      0.00      0.00            16/28     Stupidedi::Builder_::TableState#pop
                      0.00      0.00      0.00      0.00           56/252     Stupidedi::Builder_::LoopState#pop
                      0.00      0.00      0.00      0.00            16/16     Stupidedi::Builder_::TableState#merge
                      0.00      0.00      0.00      0.00         252/2974     Fixnum#zero?
                      0.00      0.00      0.00      0.00          72/7575     Fixnum#-
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Builder_::TableState#add
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            12/12     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00               12     Stupidedi::Builder_::TableState#drop
                      0.00      0.00      0.00      0.00            4/368     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
                      0.00      0.00      0.00      0.00          12/2974     Fixnum#zero?
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Builder_::TableState#copy
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            12/28     Array#each
                      0.00      0.00      0.00      0.00            16/28     Stupidedi::Builder_::LoopState#pop
   0.00%   0.00%      0.00      0.00      0.00      0.00               28     Stupidedi::Builder_::TableState#pop
                      0.00      0.00      0.00      0.00            16/16     Stupidedi::Builder_::TransactionSetState#pop
                      0.00      0.00      0.00      0.00            16/16     Stupidedi::Builder_::TransactionSetState#merge
                      0.00      0.00      0.00      0.00          28/2974     Fixnum#zero?
                      0.00      0.00      0.00      0.00          16/7575     Fixnum#-
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Builder_::TransmissionState#drop
                      0.00      0.00      0.00      0.00           4/2974     Fixnum#zero?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              3/4     Stupidedi::Builder_::InterchangeState#pop
                      0.00      0.00      0.00      0.00              1/4     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Builder_::TransmissionState#pop
                      0.00      0.00      0.00      0.00           4/2974     Fixnum#zero?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              2/2     Stupidedi::Reader::StreamReader#read_character
   0.00%   0.00%      0.00      0.00      0.00      0.00                2     Stupidedi::Reader::FileInput#empty?
                      0.00      0.00      0.00      0.00              2/2     IO#eof?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          219/219     Stupidedi::Reader::SegmentDict::NonEmpty#at
   0.00%   0.00%      0.00      0.00      0.00      0.00              219     Stupidedi::Reader::SegmentDict::Constants#at
                      0.00      0.00      0.00      0.00          219/219     Module#const_get
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              3/3     Stupidedi::Reader::StreamReader#advance
   0.00%   0.00%      0.00      0.00      0.00      0.00                3     Stupidedi::Reader::StreamReader#copy
                      0.00      0.00      0.00      0.00          3/30212     Hash#fetch
                      0.00      0.00      0.00      0.00          3/13048     Kernel#class
                      0.00      0.00      0.00      0.00          3/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/3     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00              2/3     Stupidedi::Reader::StreamReader#read_character
   0.00%   0.00%      0.00      0.00      0.00      0.00                3     Stupidedi::Reader::StreamReader#result
                      0.00      0.00      0.00      0.00              1/7     Module#include
                      0.00      0.00      0.00      0.00              1/3     Module#private
                      0.00      0.00      0.00      0.00             3/48     Class#inherited
                      0.00      0.00      0.00      0.00           10/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00             4/62     Module#attr_reader
                      0.00      0.00      0.00      0.00           3/3106     <Class::Stupidedi::Either>#success
                      0.00      0.00      0.00      0.00          3/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     <Class::Stupidedi::Builder_::InterchangeState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     #<Class:0xb73af3b0>#push
                      0.00      0.00      0.00      0.00           1/4712     Kernel#is_a?
                      0.00      0.00      0.00      0.00          2/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     <Class::Stupidedi::Builder_::InterchangeState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     #<Class:0xb7563918>#value
                      0.00      0.00      0.00      0.00             3/11     Module#abstract
                      0.00      0.00      0.00      0.00              1/7     Module#include
                      0.00      0.00      0.00      0.00              3/5     Module#method_added
                      0.00      0.00      0.00      0.00             2/48     Class#inherited
                      0.00      0.00      0.00      0.00            9/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00             3/62     Module#attr_reader
                      0.00      0.00      0.00      0.00           4/1317     Object#cons
                      0.00      0.00      0.00      0.00          4/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     <Class::Stupidedi::Builder_::FunctionalGroupState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     #<Class:0xb76cc41c>#value
                      0.00      0.00      0.00      0.00              1/7     Module#include
                      0.00      0.00      0.00      0.00             1/48     Class#inherited
                      0.00      0.00      0.00      0.00           10/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00             3/62     Module#attr_reader
                      0.00      0.00      0.00      0.00           4/1317     Object#cons
                      0.00      0.00      0.00      0.00          4/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          446/446     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00              446     <Class::Hash>#allocate
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     <Class::Stupidedi::Builder_::FunctionalGroupState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     <Class::Stupidedi::Builder_::FunctionalGroupState>#instructions
                      0.00      0.00      0.00      0.00           1/1462     Array#<<
                      0.00      0.00      0.00      0.00            1/843     Array#tail
                      0.00      0.00      0.00      0.00             2/42     <Class::Stupidedi::Builder_::AbstractState>#sequence
                      0.00      0.00      0.00      0.00            1/221     Array#concat
                      0.00      0.00      0.00      0.00             2/53     Kernel#singleton_method_added
                      0.00      0.00      0.00      0.00             1/48     Class#inherited
                      0.00      0.00      0.00      0.00            7/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00           4/2113     Hash#[]
                      0.00      0.00      0.00      0.00             3/62     Module#attr_reader
                      0.00      0.00      0.00      0.00          2/23624     Class#new
                      0.00      0.00      0.00      0.00           2/1677     Array#length
                      0.00      0.00      0.00      0.00           1/1432     Hash#[]=
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     <Class::Stupidedi::Builder_::InterchangeState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     <Class::Stupidedi::Builder_::InterchangeState>#instructions
                      0.00      0.00      0.00      0.00           1/1462     Array#<<
                      0.00      0.00      0.00      0.00            1/843     Array#tail
                      0.00      0.00      0.00      0.00             2/42     <Class::Stupidedi::Builder_::AbstractState>#sequence
                      0.00      0.00      0.00      0.00            1/221     Array#concat
                      0.00      0.00      0.00      0.00             1/71     Stupidedi::Schema::SegmentUse#repeatable?
                      0.00      0.00      0.00      0.00             2/53     Kernel#singleton_method_added
                      0.00      0.00      0.00      0.00             1/48     Class#inherited
                      0.00      0.00      0.00      0.00           1/2256     Array#head
                      0.00      0.00      0.00      0.00            7/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00           4/2113     Hash#[]
                      0.00      0.00      0.00      0.00             4/62     Module#attr_reader
                      0.00      0.00      0.00      0.00          2/23624     Class#new
                      0.00      0.00      0.00      0.00           2/1677     Array#length
                      0.00      0.00      0.00      0.00           1/1432     Hash#[]=
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            16/16     <Class::Stupidedi::Builder_::TableState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00               16     <Class::Stupidedi::Builder_::TableState>#instructions
                      0.00      0.00      0.00      0.00             8/42     <Class::Stupidedi::Builder_::AbstractState>#sequence
                      0.00      0.00      0.00      0.00            8/221     Array#concat
                      0.00      0.00      0.00      0.00          16/2113     Hash#[]
                      0.00      0.00      0.00      0.00             4/19     <Class::Stupidedi::Builder_::AbstractState>#lsequence
                      0.00      0.00      0.00      0.00          1/23624     Class#new
                      0.00      0.00      0.00      0.00           8/1677     Array#length
                      0.00      0.00      0.00      0.00           4/1432     Hash#[]=
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     <Class::Stupidedi::Builder_::TransactionSetState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     <Class::Stupidedi::Builder_::TransactionSetState>#instructions
                      0.00      0.00      0.00      0.00            1/843     Array#tail
                      0.00      0.00      0.00      0.00              1/1     <Class::Stupidedi::Builder_::AbstractState>#tsequence
                      0.00      0.00      0.00      0.00              1/5     Stupidedi::Schema::TableDef#repeatable?
                      0.00      0.00      0.00      0.00           1/2256     Array#head
                      0.00      0.00      0.00      0.00           4/2113     Hash#[]
                      0.00      0.00      0.00      0.00          1/23624     Class#new
                      0.00      0.00      0.00      0.00           1/1432     Hash#[]=
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              2/2     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                2     <Class::Stupidedi::Reader::SegmentDict>#empty
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00        1220/1471     Array#each
                      0.00      0.00      0.00      0.00          12/1471     Stupidedi::Values::SegmentVal#at
                      0.00      0.00      0.00      0.00         151/1471     Integer#times
                      0.00      0.00      0.00      0.00          72/1471     Stupidedi::Builder_::ConstraintTable::ValueBased#select
                      0.00      0.00      0.00      0.00           8/1471     <Class::Stupidedi::Builder_::TransactionSetState>#push
                      0.00      0.00      0.00      0.00           4/1471     <Class::Stupidedi::Builder_::FunctionalGroupState>#push
                      0.00      0.00      0.00      0.00           4/1471     <Class::Stupidedi::Builder_::InterchangeState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00             1471     Array#at
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           1/2256     <Class::Stupidedi::Builder_::TransactionSetState>#instructions
                      0.00      0.00      0.00      0.00          15/2256     <Class::Stupidedi::Builder_::LoopState>#instructions
                      0.00      0.00      0.00      0.00          68/2256     Stupidedi::Builder_::ConstraintTable::ValueBased#matches
                      0.00      0.00      0.00      0.00         104/2256     Stupidedi::Schema::LoopDef#entry_segment_use
                      0.00      0.00      0.00      0.00           1/2256     <Class::Stupidedi::Builder_::InterchangeState>#instructions
                      0.00      0.00      0.00      0.00           4/2256     Stupidedi::Envelope::InterchangeDef#entry_segment_use
                      0.00      0.00      0.00      0.00          15/2256     Stupidedi::Builder_::ConstraintTable::ValueBased#basis
                      0.00      0.00      0.00      0.00           4/2256     <Class::Stupidedi::Builder_::TransactionSetState>#push
                      0.00      0.00      0.00      0.00        2032/2256     Stupidedi::Reader::TokenReader#read_elements
                      0.00      0.00      0.00      0.00           8/2256     Stupidedi::Envelope::TransactionSetDef#entry_segment_use
                      0.00      0.00      0.00      0.00           4/2256     Stupidedi::Envelope::FunctionalGroupDef#entry_segment_use
   0.00%   0.00%      0.00      0.00      0.00      0.00             2256     Array#head
                      0.00      0.00      0.00      0.00        2256/3923     Array#empty?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           1/1432     <Class::Stupidedi::Builder_::FunctionalGroupState>#instructions
                      0.00      0.00      0.00      0.00          58/1432     Array#each
                      0.00      0.00      0.00      0.00           4/1432     <Class::Stupidedi::Builder_::TableState>#instructions
                      0.00      0.00      0.00      0.00           1/1432     <Class::Stupidedi::Builder_::TransactionSetState>#instructions
                      0.00      0.00      0.00      0.00         581/1432     Hash#each
                      0.00      0.00      0.00      0.00          15/1432     <Class::Stupidedi::Builder_::LoopState>#instructions
                      0.00      0.00      0.00      0.00         245/1432     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
                      0.00      0.00      0.00      0.00           1/1432     <Class::Stupidedi::Builder_::InterchangeState>#instructions
                      0.00      0.00      0.00      0.00         503/1432     Proc#call
                      0.00      0.00      0.00      0.00          22/1432     Stupidedi::Builder_::InstructionTable::NonEmpty#push
                      0.00      0.00      0.00      0.00           1/1432     OpenStruct#method_missing
   0.00%   0.00%      0.00      0.00      0.00      0.00             1432     Hash#[]=
                      0.00      0.00      0.00      0.00          80/1542     Kernel#hash
                      0.00      0.00      0.00      0.00           22/130     Array#hash
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          295/295     Hash#defined_at?
   0.00%   0.00%      0.00      0.00      0.00      0.00              295     Hash#include?
                      0.00      0.00      0.00      0.00          59/1542     Kernel#hash
                      0.00      0.00      0.00      0.00              4/8     Array#eql?
                      0.00      0.00      0.00      0.00            4/130     Array#hash
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          446/446     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00              446     Hash#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              2/2     Stupidedi::Reader::FileInput#empty?
   0.00%   0.00%      0.00      0.00      0.00      0.00                2     IO#eof?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             8/48     Stupidedi::Values::SegmentValGroup#defined_at?
                      0.00      0.00      0.00      0.00            24/48     <Class::Stupidedi::Builder_::TableState>#push
                      0.00      0.00      0.00      0.00             8/48     <Class::Date>#julian?
                      0.00      0.00      0.00      0.00             8/48     Stupidedi::Values::SegmentValGroup#at
   0.00%   0.00%      0.00      0.00      0.00      0.00               48     Module#===
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          219/219     Stupidedi::Reader::SegmentDict::Constants#at
   0.00%   0.00%      0.00      0.00      0.00      0.00              219     Module#const_get
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/7     Stupidedi::Schema::TableDef#value
                      0.00      0.00      0.00      0.00              1/7     Stupidedi::Schema::LoopDef#value
                      0.00      0.00      0.00      0.00              1/7     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::R#companion
                      0.00      0.00      0.00      0.00              1/7     #<Class:0xb7563918>#value
                      0.00      0.00      0.00      0.00              1/7     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::Nn#companion
                      0.00      0.00      0.00      0.00              1/7     Stupidedi::Reader::StreamReader#result
                      0.00      0.00      0.00      0.00              1/7     #<Class:0xb76cc41c>#value
   0.00%   0.00%      0.00      0.00      0.00      0.00                7     Module#include
                      0.00      0.00      0.00      0.00              7/7     Module#append_features
                      0.00      0.00      0.00      0.00              7/7     Module#included
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     OpenStruct#initialize
                      0.00      0.00      0.00      0.00            1/277     Hash#each
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            8/140     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal>#value
                      0.00      0.00      0.00      0.00           64/140     Stupidedi::Reader::SimpleElementTok#blankness?
                      0.00      0.00      0.00      0.00           24/140     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal>#value
                      0.00      0.00      0.00      0.00            4/140     Stupidedi::Reader::ComponentElementTok#blankness?
                      0.00      0.00      0.00      0.00           16/140     Object#try
                      0.00      0.00      0.00      0.00            4/140     <Class::Stupidedi::Builder_::TransactionSetState>#push
                      0.00      0.00      0.00      0.00           20/140     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DecimalVal>#value
   0.00%   0.00%      0.00      0.00      0.00      0.00              140     String#blankness?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00        3903/3903     Stupidedi::Reader::FileInput#drop
   0.00%   0.00%      0.00      0.00      0.00      0.00             3903     String#count
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00        3903/3903     Stupidedi::Reader::FileInput#drop
   0.00%   0.00%      0.00      0.00      0.00      0.00             3903     String#rindex
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            32/60     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal>#value
                      0.00      0.00      0.00      0.00             4/60     <Class::Stupidedi::Builder_::FunctionalGroupState>#push
                      0.00      0.00      0.00      0.00            24/60     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal>#value
   0.00%   0.00%      0.00      0.00      0.00      0.00               60     String#slice
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             8/24     Stupidedi::Builder_::AbstractState#config
                      0.00      0.00      0.00      0.00             8/24     <Class::Stupidedi::Builder_::TransactionSetState>#push
                      0.00      0.00      0.00      0.00             8/24     <Class::Stupidedi::Builder_::FunctionalGroupState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00               24     Stupidedi::Builder_::AbstractState#config
                      0.00      0.00      0.00      0.00             8/24     Stupidedi::Builder_::AbstractState#config
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Builder_::FunctionalGroupState#drop
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Builder_::FunctionalGroupState#copy
                      0.00      0.00      0.00      0.00         16/30212     Hash#fetch
                      0.00      0.00      0.00      0.00          4/13048     Kernel#class
                      0.00      0.00      0.00      0.00          4/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              8/8     Stupidedi::Builder_::InterchangeState#drop
   0.00%   0.00%      0.00      0.00      0.00      0.00                8     Stupidedi::Builder_::InterchangeState#copy
                      0.00      0.00      0.00      0.00         40/30212     Hash#fetch
                      0.00      0.00      0.00      0.00          8/13048     Kernel#class
                      0.00      0.00      0.00      0.00          8/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Builder_::FunctionalGroupState#pop
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Builder_::InterchangeState#merge
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          136/136     Stupidedi::Builder_::LoopState#drop
   0.00%   0.00%      0.00      0.00      0.00      0.00              136     Stupidedi::Builder_::LoopState#copy
                      0.00      0.00      0.00      0.00        408/30212     Hash#fetch
                      0.00      0.00      0.00      0.00        136/13048     Kernel#class
                      0.00      0.00      0.00      0.00        136/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            56/56     Stupidedi::Builder_::LoopState#pop
   0.00%   0.00%      0.00      0.00      0.00      0.00               56     Stupidedi::Builder_::LoopState#merge
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Builder_::TableState#drop
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Builder_::TableState#copy
                      0.00      0.00      0.00      0.00         12/30212     Hash#fetch
                      0.00      0.00      0.00      0.00          4/13048     Kernel#class
                      0.00      0.00      0.00      0.00          4/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            16/16     Stupidedi::Builder_::LoopState#pop
   0.00%   0.00%      0.00      0.00      0.00      0.00               16     Stupidedi::Builder_::TableState#merge
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            16/16     Stupidedi::Builder_::TableState#pop
   0.00%   0.00%      0.00      0.00      0.00      0.00               16     Stupidedi::Builder_::TransactionSetState#merge
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            16/16     Stupidedi::Builder_::TableState#pop
   0.00%   0.00%      0.00      0.00      0.00      0.00               16     Stupidedi::Builder_::TransactionSetState#pop
                      0.00      0.00      0.00      0.00          16/2974     Fixnum#zero?
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Builder_::FunctionalGroupState#merge
                      0.00      0.00      0.00      0.00           4/7575     Fixnum#-
                      0.00      0.00      0.00      0.00             4/12     Stupidedi::Builder_::FunctionalGroupState#pop
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              3/3     Stupidedi::Builder_::InterchangeState#pop
   0.00%   0.00%      0.00      0.00      0.00      0.00                3     Stupidedi::Builder_::TransmissionState#merge
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     <Class::Stupidedi::Builder_::FunctionalGroupState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Configuration::FunctionalGroupConfig#at
                      0.00      0.00      0.00      0.00           4/2113     Hash#[]
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     <Class::Stupidedi::Builder_::FunctionalGroupState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Configuration::FunctionalGroupConfig#defined_at?
                      0.00      0.00      0.00      0.00            4/295     Hash#defined_at?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     <Class::Stupidedi::Builder_::InterchangeState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Configuration::InterchangeConfig#at
                      0.00      0.00      0.00      0.00           4/2113     Hash#[]
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     <Class::Stupidedi::Builder_::InterchangeState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Configuration::InterchangeConfig#defined_at?
                      0.00      0.00      0.00      0.00            4/295     Hash#defined_at?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     <Class::Stupidedi::Builder_::TransactionSetState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Configuration::TransactionSetConfig#at
                      0.00      0.00      0.00      0.00              4/4     <Class::Array>#[]
                      0.00      0.00      0.00      0.00           4/2113     Hash#[]
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     <Class::Stupidedi::Builder_::TransactionSetState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Configuration::TransactionSetConfig#defined_at?
                      0.00      0.00      0.00      0.00            4/295     Hash#defined_at?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     <Class::Stupidedi::Builder_::TransactionSetState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal::NonEmpty#to_s
                      0.00      0.00      0.00      0.00          4/13738     String#to_s
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     <Class::Stupidedi::Builder_::InterchangeState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeVal#segment_dict
                      0.00      0.00      0.00      0.00              4/4     #<Class:0xb7563918>#segment_dict
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     <Class::Stupidedi::Builder_::FunctionalGroupState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Envelope::FunctionalGroupDef#entry_segment_use
                      0.00      0.00      0.00      0.00           4/2256     Array#head
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     <Class::Stupidedi::Builder_::FunctionalGroupState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Envelope::FunctionalGroupVal#segment_dict
                      0.00      0.00      0.00      0.00              4/4     #<Class:0xb76cc41c>#segment_dict
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     <Class::Stupidedi::Builder_::InterchangeState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Envelope::InterchangeDef#entry_segment_use
                      0.00      0.00      0.00      0.00           4/2256     Array#head
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     <Class::Stupidedi::Builder_::TransactionSetState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Envelope::TransactionSetDef#empty
                      0.00      0.00      0.00      0.00             1/48     Class#inherited
                      0.00      0.00      0.00      0.00            6/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00             3/62     Module#attr_reader
                      0.00      0.00      0.00      0.00          4/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     <Class::Stupidedi::Builder_::TransactionSetState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Envelope::TransactionSetDef#entry_segment_use
                      0.00      0.00      0.00      0.00           8/2256     Array#head
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Reader::Failure#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              3/7     <Class::Stupidedi::Builder_::InterchangeState>#push
                      0.00      0.00      0.00      0.00              4/7     <Class::Stupidedi::Builder_::FunctionalGroupState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                7     Stupidedi::Reader::SegmentDict::NonEmpty#push
                      0.00      0.00      0.00      0.00              7/7     Stupidedi::Reader::SegmentDict::NonEmpty#copy
                      0.00      0.00      0.00      0.00           7/4712     Kernel#is_a?
                      0.00      0.00      0.00      0.00          7/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     <Class::Stupidedi::Builder_::InterchangeState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Reader::Separators#merge
                      0.00      0.00      0.00      0.00            2/274     OpenStruct#method_missing
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Reader::Separators#copy
                      0.00      0.00      0.00      0.00              1/1     Unknown#segment
                      0.00      0.00      0.00      0.00            1/116     Unknown#element
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Either::Success#flatmap
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Reader::TokenReader#read_character
                      0.00      0.00      0.00      0.00          1/10209     Stupidedi::Reader::FileInput#defined_at?
                      0.00      0.00      0.00      0.00          1/40586     Fixnum#+
                      0.00      0.00      0.00      0.00           1/7198     Stupidedi::Reader::TokenReader#is_control?
                      0.00      0.00      0.00      0.00           1/3085     Stupidedi::Reader::TokenReader#result
                      0.00      0.00      0.00      0.00           1/7426     Stupidedi::Reader::FileInput#at
                      0.00      0.00      0.00      0.00           1/2781     Stupidedi::Reader::TokenReader#advance
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              8/8     <Class::Stupidedi::Builder_::TableState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                8     Stupidedi::Schema::TableDef#empty
                      0.00      0.00      0.00      0.00          8/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              8/8     <Class::Stupidedi::Builder_::TableState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                8     Stupidedi::Schema::TableDef#value
                      0.00      0.00      0.00      0.00              1/7     Module#include
                      0.00      0.00      0.00      0.00             1/48     Class#inherited
                      0.00      0.00      0.00      0.00            9/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00             3/62     Module#attr_reader
                      0.00      0.00      0.00      0.00           8/1317     Object#cons
                      0.00      0.00      0.00      0.00          8/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             8/12     Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeVal#initialize
                      0.00      0.00      0.00      0.00             4/12     <Class::Stupidedi::Builder_::TransactionSetState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00               12     Stupidedi::Values::SegmentVal#at
                      0.00      0.00      0.00      0.00          12/3102     Kernel#nil?
                      0.00      0.00      0.00      0.00            12/12     Stupidedi::Values::SegmentVal#defined_at?
                      0.00      0.00      0.00      0.00            12/24     Array#defined_at?
                      0.00      0.00      0.00      0.00          12/1471     Array#at
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/8     Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeVal#initialize
                      0.00      0.00      0.00      0.00              4/8     <Class::Stupidedi::Builder_::TransactionSetState>#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                8     Stupidedi::Values::SegmentValGroup#at
                      0.00      0.00      0.00      0.00           8/3102     Kernel#nil?
                      0.00      0.00      0.00      0.00              8/8     Stupidedi::Values::SegmentValGroup#defined_at?
                      0.00      0.00      0.00      0.00             8/48     Module#===
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Envelope::FunctionalGroupVal#segment_vals
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Envelope::InterchangeVal#segment_vals
                      0.00      0.00      0.00      0.00             8/16     Array#select
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            15/15     Integer#times
   0.00%   0.00%      0.00      0.00      0.00      0.00               15     Symbol#to_proc
                      0.00      0.00      0.00      0.00            15/15     Kernel#lambda
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeVal#segment_dict
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     #<Class:0xb7563918>#segment_dict
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Envelope::FunctionalGroupVal#segment_dict
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     #<Class:0xb76cc41c>#segment_dict
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Configuration::TransactionSetConfig#at
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     <Class::Array>#[]
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             4/19     <Class::Stupidedi::Builder_::TableState>#instructions
                      0.00      0.00      0.00      0.00            15/19     <Class::Stupidedi::Builder_::LoopState>#instructions
   0.00%   0.00%      0.00      0.00      0.00      0.00               19     <Class::Stupidedi::Builder_::AbstractState>#lsequence
                      0.00      0.00      0.00      0.00          19/3102     Kernel#nil?
                      0.00      0.00      0.00      0.00              5/8     Stupidedi::Schema::LoopDef#repeatable?
                      0.00      0.00      0.00      0.00          19/1510     Fixnum#==
                      0.00      0.00      0.00      0.00          17/7575     Fixnum#-
                      0.00      0.00      0.00      0.00          38/1944     Array#each
                      0.00      0.00      0.00      0.00          36/1677     Array#length
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     <Class::Stupidedi::Builder_::TransactionSetState>#instructions
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     <Class::Stupidedi::Builder_::AbstractState>#tsequence
                      0.00      0.00      0.00      0.00           1/3923     Array#empty?
                      0.00      0.00      0.00      0.00              1/5     Stupidedi::Schema::TableDef#repeatable?
                      0.00      0.00      0.00      0.00           1/1510     Fixnum#==
                      0.00      0.00      0.00      0.00           2/1944     Array#each
                      0.00      0.00      0.00      0.00           1/1677     Array#length
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00        1317/1341     Object#cons
                      0.00      0.00      0.00      0.00           1/1341     Stupidedi::Envelope::InterchangeDef#segment_uses
                      0.00      0.00      0.00      0.00           1/1341     Stupidedi::Envelope::FunctionalGroupDef#segment_uses
                      0.00      0.00      0.00      0.00          22/1341     Stupidedi::Builder_::InstructionTable::NonEmpty#push
   0.00%   0.00%      0.00      0.00      0.00      0.00             1341     Array#+
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            1/221     <Class::Stupidedi::Builder_::FunctionalGroupState>#instructions
                      0.00      0.00      0.00      0.00            8/221     <Class::Stupidedi::Builder_::TableState>#instructions
                      0.00      0.00      0.00      0.00           30/221     <Class::Stupidedi::Builder_::LoopState>#instructions
                      0.00      0.00      0.00      0.00           42/221     Stupidedi::Schema::TableDef#entry_segment_uses
                      0.00      0.00      0.00      0.00          139/221     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
                      0.00      0.00      0.00      0.00            1/221     <Class::Stupidedi::Builder_::InterchangeState>#instructions
   0.00%   0.00%      0.00      0.00      0.00      0.00              221     Array#concat
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            12/24     Stupidedi::Values::SegmentVal#at
                      0.00      0.00      0.00      0.00            12/24     Object#try
   0.00%   0.00%      0.00      0.00      0.00      0.00               24     Array#defined_at?
                      0.00      0.00      0.00      0.00         24/10874     Fixnum#<
                      0.00      0.00      0.00      0.00          24/1677     Array#length
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          139/278     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
                      0.00      0.00      0.00      0.00          139/278     Array#split_at
   0.00%   0.00%      0.00      0.00      0.00      0.00              278     Array#drop
                      0.00      0.00      0.00      0.00        278/23479     <Class::Object>#allocate
                      0.00      0.00      0.00      0.00          278/421     Array#slice
                      0.00      0.00      0.00      0.00        278/10874     Fixnum#<
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             4/16     Stupidedi::Envelope::InterchangeVal#segment_vals
                      0.00      0.00      0.00      0.00             4/16     Stupidedi::Envelope::FunctionalGroupVal#segment_vals
                      0.00      0.00      0.00      0.00             8/16     Stupidedi::Values::SegmentValGroup#at
   0.00%   0.00%      0.00      0.00      0.00      0.00               16     Array#select
                      0.00      0.00      0.00      0.00           8/4712     Kernel#is_a?
                      0.00      0.00      0.00      0.00             8/18     Symbol#to_sym
                      0.00      0.00      0.00      0.00            8/286     Kernel#==
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          139/139     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
   0.00%   0.00%      0.00      0.00      0.00      0.00              139     Array#split_at
                      0.00      0.00      0.00      0.00          139/278     Array#drop
                      0.00      0.00      0.00      0.00          139/139     Array#take
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          825/843     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00            1/843     <Class::Stupidedi::Builder_::FunctionalGroupState>#instructions
                      0.00      0.00      0.00      0.00            1/843     <Class::Stupidedi::Builder_::TransactionSetState>#instructions
                      0.00      0.00      0.00      0.00           15/843     <Class::Stupidedi::Builder_::LoopState>#instructions
                      0.00      0.00      0.00      0.00            1/843     <Class::Stupidedi::Builder_::InterchangeState>#instructions
   0.00%   0.00%      0.00      0.00      0.00      0.00              843     Array#tail
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          109/109     <Class::Stupidedi::Builder_::ConstraintTable>#build
   0.00%   0.00%      0.00      0.00      0.00      0.00              109     Array#uniq
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           88/100     <Class::Stupidedi::Builder_::AbstractState>#segment
                      0.00      0.00      0.00      0.00           12/100     <Class::Stupidedi::Builder_::AbstractState>#composite_element
   0.00%   0.00%      0.00      0.00      0.00      0.00              100     Array#zip
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           4/1088     <Class::Date>#jd_to_civil
                      0.00      0.00      0.00      0.00        1080/1088     Stupidedi::Schema::RepeatCount::Bounded#include?
                      0.00      0.00      0.00      0.00           4/1088     <Class::Date>#civil_to_jd
   0.00%   0.00%      0.00      0.00      0.00      0.00             1088     Fixnum#<=
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00        612/12115     <Class::Stupidedi::Builder_::ConstraintTable>#build
                      0.00      0.00      0.00      0.00      11471/12115     Array#each
                      0.00      0.00      0.00      0.00         32/12115     Integer#gcd
   0.00%   0.00%      0.00      0.00      0.00      0.00            12115     Fixnum#>
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00        1065/1065     Hash#[]
   0.00%   0.00%      0.00      0.00      0.00      0.00             1065     Hash#default
                      0.00      0.00      0.00      0.00          503/503     Proc#call
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            15/15     Stupidedi::Builder_::ConstraintTable::ValueBased#deepest
   0.00%   0.00%      0.00      0.00      0.00      0.00               15     Hash#values
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
                      0.00      0.00      0.00      0.00              3/5     #<Class:0xb7563918>#value
   0.00%   0.00%      0.00      0.00      0.00      0.00                5     Module#method_added
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           8/1317     Stupidedi::Schema::TableDef#value
                      0.00      0.00      0.00      0.00         271/1317     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00          72/1317     Stupidedi::Schema::LoopDef#value
                      0.00      0.00      0.00      0.00          77/1317     Hash#each
                      0.00      0.00      0.00      0.00           4/1317     #<Class:0xb7563918>#value
                      0.00      0.00      0.00      0.00           4/1317     #<Class:0xb76cc41c>#value
                      0.00      0.00      0.00      0.00         881/1317     Stupidedi::Reader::Success#map
   0.00%   0.00%      0.00      0.00      0.00      0.00             1317     Object#cons
                      0.00      0.00      0.00      0.00        1317/1341     Array#+
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            2/274     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00            2/274     Stupidedi::Reader::Separators#merge
                      0.00      0.00      0.00      0.00          270/274     Stupidedi::Reader::TokenReader#read_simple_element
   0.00%   0.00%      0.00      0.00      0.00      0.00              274     OpenStruct#method_missing
                      0.00      0.00      0.00      0.00              1/1     Array#[]
                      0.00      0.00      0.00      0.00              1/1     String#intern
                      0.00      0.00      0.00      0.00         274/1510     Fixnum#==
                      0.00      0.00      0.00      0.00              1/2     OpenStruct#new_ostruct_member
                      0.00      0.00      0.00      0.00         273/2113     Hash#[]
                      0.00      0.00      0.00      0.00              1/1     Kernel#frozen?
                      0.00      0.00      0.00      0.00              1/1     String#chop!
                      0.00      0.00      0.00      0.00         274/1677     Array#length
                      0.00      0.00      0.00      0.00          274/274     Symbol#id2name
                      0.00      0.00      0.00      0.00           1/1432     Hash#[]=
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          8/13738     Stupidedi::Dictionaries::Interchanges::FiveOhOne::ElementDefs::SeparatorElementVal#to_s
                      0.00      0.00      0.00      0.00         32/13738     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal>#value
                      0.00      0.00      0.00      0.00      13130/13738     Array#each
                      0.00      0.00      0.00      0.00        280/13738     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal>#value
                      0.00      0.00      0.00      0.00         44/13738     String#to_d
                      0.00      0.00      0.00      0.00          4/13738     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal::NonEmpty#to_s
                      0.00      0.00      0.00      0.00         24/13738     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal>#value
                      0.00      0.00      0.00      0.00        216/13738     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal>#value
   0.00%   0.00%      0.00      0.00      0.00      0.00            13738     String#to_s
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            68/68     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00               68     Stupidedi::Builder_::ConstraintTable::ValueBased#select
                      0.00      0.00      0.00      0.00           4/3102     Kernel#nil?
                      0.00      0.00      0.00      0.00          64/1360     NilClass#nil?
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Reader::ComponentElementTok#blankness?
                      0.00      0.00      0.00      0.00            64/64     Stupidedi::Reader::SimpleElementTok#blankness?
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Reader::CompositeElementTok#blankness?
                      0.00      0.00      0.00      0.00          72/1471     Array#at
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              8/8     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                8     Stupidedi::Builder_::FunctionalGroupState#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Builder_::TransactionSetState#pop
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Builder_::FunctionalGroupState#merge
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          139/161     Stupidedi::Builder_::InstructionTable::NonEmpty#drop
                      0.00      0.00      0.00      0.00           22/161     Stupidedi::Builder_::InstructionTable::NonEmpty#push
   0.00%   0.00%      0.00      0.00      0.00      0.00              161     Stupidedi::Builder_::InstructionTable::NonEmpty#copy
                      0.00      0.00      0.00      0.00        322/30212     Hash#fetch
                      0.00      0.00      0.00      0.00        161/13048     Kernel#class
                      0.00      0.00      0.00      0.00        161/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            12/12     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00               12     Stupidedi::Builder_::InterchangeState#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          208/208     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00              208     Stupidedi::Builder_::LoopState#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            20/20     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00               20     Stupidedi::Builder_::TableState#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Either::Failure#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Values::SegmentValGroup#at
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Envelope::FunctionalGroupVal#segment_vals
                      0.00      0.00      0.00      0.00             4/16     Array#select
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00        3903/3903     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00             3903     Stupidedi::Reader::FileInput#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              7/7     Stupidedi::Reader::SegmentDict::NonEmpty#push
   0.00%   0.00%      0.00      0.00      0.00      0.00                7     Stupidedi::Reader::SegmentDict::NonEmpty#copy
                      0.00      0.00      0.00      0.00         14/30212     Hash#fetch
                      0.00      0.00      0.00      0.00          7/13048     Kernel#class
                      0.00      0.00      0.00      0.00          7/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Reader::Separators#merge
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Reader::Separators#copy
                      0.00      0.00      0.00      0.00         16/30212     Hash#fetch
                      0.00      0.00      0.00      0.00          4/13048     Kernel#class
                      0.00      0.00      0.00      0.00          4/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Reader::StreamReader#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            15/15     Stupidedi::Either::Success#flatmap
   0.00%   0.00%      0.00      0.00      0.00      0.00               15     Stupidedi::Reader::TokenReader#consume_prefix
                      0.00      0.00      0.00      0.00         15/10209     Stupidedi::Reader::FileInput#defined_at?
                      0.00      0.00      0.00      0.00            15/15     Stupidedi::Reader::TokenReader#success
                      0.00      0.00      0.00      0.00         15/40586     Fixnum#+
                      0.00      0.00      0.00      0.00          15/7198     Stupidedi::Reader::TokenReader#is_control?
                      0.00      0.00      0.00      0.00          15/4210     String#<<
                      0.00      0.00      0.00      0.00           15/543     String#empty?
                      0.00      0.00      0.00      0.00          15/1510     Fixnum#==
                      0.00      0.00      0.00      0.00          15/7426     Stupidedi::Reader::FileInput#at
                      0.00      0.00      0.00      0.00          15/2781     Stupidedi::Reader::TokenReader#advance
                      0.00      0.00      0.00      0.00         15/41326     String#==
                      0.00      0.00      0.00      0.00          30/8425     String#length
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Either::Success#flatmap
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Stupidedi::Reader::TokenReader#stream
                      0.00      0.00      0.00      0.00          1/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            12/73     <Class::Stupidedi::Builder_::AbstractState>#element
                      0.00      0.00      0.00      0.00            61/73     Stupidedi::Schema::ElementUse#composite?
   0.00%   0.00%      0.00      0.00      0.00      0.00               73     Stupidedi::Schema::CompositeElementUse#simple?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            88/88     <Class::Stupidedi::Builder_::AbstractState>#segment
   0.00%   0.00%      0.00      0.00      0.00      0.00               88     Stupidedi::Schema::SegmentUse#value
                      0.00      0.00      0.00      0.00            88/88     Stupidedi::Schema::SegmentDef#value
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00         560/1653     <Class::Stupidedi::Builder_::AbstractState>#element
                      0.00      0.00      0.00      0.00        1093/1653     Stupidedi::Schema::ElementUse#composite?
   0.00%   0.00%      0.00      0.00      0.00      0.00             1653     Stupidedi::Schema::SimpleElementUse#simple?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              3/5     Array#each
                      0.00      0.00      0.00      0.00              1/5     <Class::Stupidedi::Builder_::TransactionSetState>#instructions
                      0.00      0.00      0.00      0.00              1/5     <Class::Stupidedi::Builder_::AbstractState>#tsequence
   0.00%   0.00%      0.00      0.00      0.00      0.00                5     Stupidedi::Schema::TableDef#repeatable?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            12/12     Stupidedi::Values::SegmentVal#at
   0.00%   0.00%      0.00      0.00      0.00      0.00               12     Stupidedi::Values::SegmentVal#defined_at?
                      0.00      0.00      0.00      0.00           12/111     Object#try
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              8/8     Stupidedi::Values::SegmentValGroup#at
   0.00%   0.00%      0.00      0.00      0.00      0.00                8     Stupidedi::Values::SegmentValGroup#defined_at?
                      0.00      0.00      0.00      0.00           8/3102     Kernel#nil?
                      0.00      0.00      0.00      0.00             8/48     Module#===
                      0.00      0.00      0.00      0.00            8/574     Enumerable#any?
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Envelope::FunctionalGroupDef#segment_uses
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Envelope::InterchangeDef#segment_uses
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           15/116     Stupidedi::Either::Success#flatmap
                      0.00      0.00      0.00      0.00            1/116     Stupidedi::Reader::Separators#merge
                      0.00      0.00      0.00      0.00          100/116     Stupidedi::Reader::TokenReader#read_simple_element
   0.00%   0.00%      0.00      0.00      0.00      0.00              116     Unknown#element
                      0.00      0.00      0.00      0.00         116/2113     Hash#[]
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Stupidedi::Reader::Separators#merge
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Unknown#segment
                      0.00      0.00      0.00      0.00           1/2113     Hash#[]
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00        1015/1015     Stupidedi::Reader::TokenReader#simple
   0.00%   0.00%      0.00      0.00      0.00      0.00             1015     <Class::Stupidedi::Reader::SimpleElementTok>#build
                      0.00      0.00      0.00      0.00       1015/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/8     Hash#[]
                      0.00      0.00      0.00      0.00              4/8     Hash#include?
   0.00%   0.00%      0.00      0.00      0.00      0.00                8     Array#eql?
                      0.00      0.00      0.00      0.00            24/24     String#eql?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          139/421     Array#take
                      0.00      0.00      0.00      0.00          278/421     Array#drop
                      0.00      0.00      0.00      0.00            4/421     Array#init
   0.00%   0.00%      0.00      0.00      0.00      0.00              421     Array#slice
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          139/139     Array#split_at
   0.00%   0.00%      0.00      0.00      0.00      0.00              139     Array#take
                      0.00      0.00      0.00      0.00          139/421     Array#slice
                      0.00      0.00      0.00      0.00        139/10874     Fixnum#<
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            8/286     Array#each
                      0.00      0.00      0.00      0.00            8/286     Array#select
                      0.00      0.00      0.00      0.00          270/286     Kernel#===
   0.00%   0.00%      0.00      0.00      0.00      0.00              286     Kernel#==
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00        1302/1542     Array#hash
                      0.00      0.00      0.00      0.00          80/1542     Hash#[]=
                      0.00      0.00      0.00      0.00         101/1542     Hash#[]
                      0.00      0.00      0.00      0.00          59/1542     Hash#include?
   0.00%   0.00%      0.00      0.00      0.00      0.00             1542     Kernel#hash
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          455/455     Array#map
   0.00%   0.00%      0.00      0.00      0.00      0.00              455     Kernel#object_id
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              7/7     Module#append_features
   0.00%   0.00%      0.00      0.00      0.00      0.00                7     Module#blankslate_original_append_features
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/2     Hash#each
                      0.00      0.00      0.00      0.00              1/2     OpenStruct#method_missing
   0.00%   0.00%      0.00      0.00      0.00      0.00                2     OpenStruct#new_ostruct_member
                      0.00      0.00      0.00      0.00             4/26     Kernel#send
                      0.00      0.00      0.00      0.00             1/18     Symbol#to_sym
                      0.00      0.00      0.00      0.00            1/224     String#to_sym
                      0.00      0.00      0.00      0.00          2/13222     Symbol#to_s
                      0.00      0.00      0.00      0.00            2/326     Kernel#respond_to?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          503/503     Hash#default
   0.00%   0.00%      0.00      0.00      0.00      0.00              503     Proc#call
                      0.00      0.00      0.00      0.00         503/1432     Hash#[]=
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          280/543     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal>#value
                      0.00      0.00      0.00      0.00           15/543     Stupidedi::Reader::TokenReader#consume_prefix
                      0.00      0.00      0.00      0.00            8/543     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal>#value
                      0.00      0.00      0.00      0.00          240/543     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal>#value
   0.00%   0.00%      0.00      0.00      0.00      0.00              543     String#empty?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          394/394     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00              394     Stupidedi::Builder_::ConstraintTable::Stub#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          109/109     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00              109     Stupidedi::Builder_::ConstraintTable::ValueBased#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeVal#initialize
                      0.00      0.00      0.00      0.00              4/8     Stupidedi::Values::SegmentValGroup#at
                      0.00      0.00      0.00      0.00           4/1360     NilClass#nil?
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Envelope::InterchangeVal#initialize
                      0.00      0.00      0.00      0.00             8/12     Stupidedi::Values::SegmentVal#at
                      0.00      0.00      0.00      0.00             4/19     Array#first
                      0.00      0.00      0.00      0.00          4/23624     Class#new
                      0.00      0.00      0.00      0.00              8/8     Stupidedi::Dictionaries::Interchanges::FiveOhOne::ElementDefs::SeparatorElementVal#to_s
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Values::SegmentValGroup#defined_at?
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Envelope::FunctionalGroupDef#segment_uses
                      0.00      0.00      0.00      0.00           1/1341     Array#+
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Envelope::FunctionalGroupVal#initialize
                      0.00      0.00      0.00      0.00           4/3102     Kernel#nil?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Envelope::TransactionSetVal#initialize
                      0.00      0.00      0.00      0.00           4/3102     Kernel#nil?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Builder_::ConstraintTable::ValueBased#select
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Reader::ComponentElementTok#blankness?
                      0.00      0.00      0.00      0.00            4/140     String#blankness?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Builder_::ConstraintTable::ValueBased#select
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Reader::CompositeElementTok#blankness?
                      0.00      0.00      0.00      0.00              4/4     Enumerable#blankness?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              8/8     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                8     Stupidedi::Reader::SegmentDict::Constants#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              8/8     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                8     Stupidedi::Reader::SegmentDict::NonEmpty#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            64/64     Stupidedi::Builder_::ConstraintTable::ValueBased#select
   0.00%   0.00%      0.00      0.00      0.00      0.00               64     Stupidedi::Reader::SimpleElementTok#blankness?
                      0.00      0.00      0.00      0.00           64/140     String#blankness?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00        1016/1016     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00             1016     Stupidedi::Reader::SimpleElementTok#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            15/15     Stupidedi::Reader::TokenReader#consume_prefix
   0.00%   0.00%      0.00      0.00      0.00      0.00               15     Stupidedi::Reader::TokenReader#success
                      0.00      0.00      0.00      0.00          15/3106     <Class::Stupidedi::Either>#success
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          232/232     Array#map
   0.00%   0.00%      0.00      0.00      0.00      0.00              232     Stupidedi::Schema::ElementUse#empty
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Schema::CompositeElementDef#empty
                      0.00      0.00      0.00      0.00          228/228     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#empty
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              5/8     <Class::Stupidedi::Builder_::AbstractState>#lsequence
                      0.00      0.00      0.00      0.00              3/8     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00                8     Stupidedi::Schema::LoopDef#repeatable?
                      0.00      0.00      0.00      0.00            8/111     Object#try
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            88/88     Stupidedi::Schema::SegmentUse#value
   0.00%   0.00%      0.00      0.00      0.00      0.00               88     Stupidedi::Schema::SegmentDef#value
                      0.00      0.00      0.00      0.00             1/48     Class#inherited
                      0.00      0.00      0.00      0.00            8/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00             4/62     Module#attr_reader
                      0.00      0.00      0.00      0.00         88/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            16/16     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00               16     Stupidedi::Values::TableVal#initialize
                      0.00      0.00      0.00      0.00          16/3102     Kernel#nil?
                      0.00      0.00      0.00      0.00           16/677     Array#map
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          274/274     OpenStruct#method_missing
   0.00%   0.00%      0.00      0.00      0.00      0.00              274     Symbol#id2name
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             8/18     Array#each
                      0.00      0.00      0.00      0.00             8/18     Array#select
                      0.00      0.00      0.00      0.00             1/18     OpenStruct#new_ostruct_member
                      0.00      0.00      0.00      0.00             1/18     Hash#each
   0.00%   0.00%      0.00      0.00      0.00      0.00               18     Symbol#to_sym
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            12/12     <Class::Stupidedi::Builder_::AbstractState>#element
   0.00%   0.00%      0.00      0.00      0.00      0.00               12     <Class::Stupidedi::Builder_::AbstractState>#composite_element
                      0.00      0.00      0.00      0.00           12/100     Array#zip
                      0.00      0.00      0.00      0.00           12/600     Stupidedi::Schema::ElementUse#value
                      0.00      0.00      0.00      0.00           12/677     Array#map
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            48/48     Stupidedi::Reader::TokenReader#composite
   0.00%   0.00%      0.00      0.00      0.00      0.00               48     <Class::Stupidedi::Reader::CompositeElementTok>#build
                      0.00      0.00      0.00      0.00         48/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     OpenStruct#method_missing
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Array#[]
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            59/59     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00               59     Array#clear
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            13/13     Object#try
   0.00%   0.00%      0.00      0.00      0.00      0.00               13     Array#include?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Reader::CompositeElementTok#blankness?
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Enumerable#blankness?
                      0.00      0.00      0.00      0.00           4/3923     Array#empty?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     OpenStruct#method_missing
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Kernel#frozen?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          280/326     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal>#value
                      0.00      0.00      0.00      0.00            2/326     OpenStruct#new_ostruct_member
                      0.00      0.00      0.00      0.00           24/326     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal>#value
                      0.00      0.00      0.00      0.00           20/326     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DecimalVal>#value
   0.00%   0.00%      0.00      0.00      0.00      0.00              326     Kernel#respond_to?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     OpenStruct#method_missing
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     String#chop!
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            24/24     Array#eql?
   0.00%   0.00%      0.00      0.00      0.00      0.00               24     String#eql?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            24/24     Array#hash
   0.00%   0.00%      0.00      0.00      0.00      0.00               24     String#hash
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     OpenStruct#method_missing
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     String#intern
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          161/161     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00              161     Stupidedi::Builder_::InstructionTable::NonEmpty#initialize
                      0.00      0.00      0.00      0.00          161/652     Kernel#freeze
                      0.00      0.00      0.00      0.00        322/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          228/228     Stupidedi::Schema::ElementUse#empty
   0.00%   0.00%      0.00      0.00      0.00      0.00              228     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#empty
                      0.00      0.00      0.00      0.00          112/352     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::ID#companion
                      0.00      0.00      0.00      0.00              8/8     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal>#empty
                      0.00      0.00      0.00      0.00             8/32     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::Nn#companion
                      0.00      0.00      0.00      0.00          108/108     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal>#empty
                      0.00      0.00      0.00      0.00          108/388     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::AN#companion
                      0.00      0.00      0.00      0.00          112/112     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal>#empty
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              8/8     Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeVal#initialize
   0.00%   0.00%      0.00      0.00      0.00      0.00                8     Stupidedi::Dictionaries::Interchanges::FiveOhOne::ElementDefs::SeparatorElementVal#to_s
                      0.00      0.00      0.00      0.00          8/13738     String#to_s
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeVal#initialize
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Envelope::InterchangeVal#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          224/224     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00              224     Stupidedi::Reader::SegmentTok#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              8/8     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                8     Stupidedi::Reader::Separators#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Schema::ElementUse#empty
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Schema::CompositeElementDef#empty
                      0.00      0.00      0.00      0.00          4/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           12/104     Array#map
                      0.00      0.00      0.00      0.00           92/104     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00              104     Stupidedi::Schema::LoopDef#entry_segment_use
                      0.00      0.00      0.00      0.00         104/2256     Array#head
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            14/14     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00               14     Stupidedi::Schema::TableDef#entry_segment_uses
                      0.00      0.00      0.00      0.00           42/221     Array#concat
                      0.00      0.00      0.00      0.00           14/677     Array#map
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     #<Class:0xb7339a34>#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          368/368     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00              368     #<Class:0xb7532b88>#==
                      0.00      0.00      0.00      0.00         368/1014     Kernel#eql?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          523/523     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00              523     #<Class:0xb7532b88>#union
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              2/2     Object#try
   0.00%   0.00%      0.00      0.00      0.00      0.00                2     #<Class:0xb7544748>#include?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     <Class::Class>#allocate
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          112/112     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#empty
   0.00%   0.00%      0.00      0.00      0.00      0.00              112     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal>#empty
                      0.00      0.00      0.00      0.00        112/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              8/8     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#empty
   0.00%   0.00%      0.00      0.00      0.00      0.00                8     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal>#empty
                      0.00      0.00      0.00      0.00          8/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          108/108     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#empty
   0.00%   0.00%      0.00      0.00      0.00      0.00              108     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal>#empty
                      0.00      0.00      0.00      0.00        108/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/1     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                1     Class#initialize
                      0.00      0.00      0.00      0.00             1/48     Class#inherited
                      0.00      0.00      0.00      0.00           18/377     <Class::Object>#method_added
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          491/652     Stupidedi::AbsoluteSet#initialize
                      0.00      0.00      0.00      0.00          161/652     Stupidedi::Builder_::InstructionTable::NonEmpty#initialize
   0.00%   0.00%      0.00      0.00      0.00      0.00              652     Kernel#freeze
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Kernel#send
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Module#define_method
                      0.00      0.00      0.00      0.00             4/53     Kernel#singleton_method_added
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          135/135     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00              135     Stupidedi::AbsoluteSet#==
                      0.00      0.00      0.00      0.00         135/4712     Kernel#is_a?
                      0.00      0.00      0.00      0.00        135/13048     Kernel#class
                      0.00      0.00      0.00      0.00         121/1510     Fixnum#==
                      0.00      0.00      0.00      0.00         135/1014     Kernel#eql?
                      0.00      0.00      0.00      0.00            14/29     Bignum#==
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            18/18     Stupidedi::Builder_::ConstraintTable::ValueBased#build_disjoint
   0.00%   0.00%      0.00      0.00      0.00      0.00               18     Stupidedi::AbsoluteSet#finite?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          290/290     Array#each
   0.00%   0.00%      0.00      0.00      0.00      0.00              290     Stupidedi::AbsoluteSet#union
                      0.00      0.00      0.00      0.00         290/4712     Kernel#is_a?
                      0.00      0.00      0.00      0.00           84/168     Stupidedi::AbsoluteSet#as_mask
                      0.00      0.00      0.00      0.00        290/13048     Kernel#class
                      0.00      0.00      0.00      0.00            43/43     Bignum#|
                      0.00      0.00      0.00      0.00         206/1014     Kernel#eql?
                      0.00      0.00      0.00      0.00          290/491     Stupidedi::AbsoluteSet#copy
                      0.00      0.00      0.00      0.00          247/247     Fixnum#|
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          108/388     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#empty
                      0.00      0.00      0.00      0.00          280/388     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
   0.00%   0.00%      0.00      0.00      0.00      0.00              388     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::AN#companion
                      0.00      0.00      0.00      0.00             3/26     Kernel#send
                      0.00      0.00      0.00      0.00              1/4     Module#delegate
                      0.00      0.00      0.00      0.00             3/22     Object#eigenclass
                      0.00      0.00      0.00      0.00             2/53     Kernel#singleton_method_added
                      0.00      0.00      0.00      0.00             3/48     Class#inherited
                      0.00      0.00      0.00      0.00            8/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00             1/62     Module#attr_reader
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          112/352     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#empty
                      0.00      0.00      0.00      0.00          240/352     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
   0.00%   0.00%      0.00      0.00      0.00      0.00              352     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::ID#companion
                      0.00      0.00      0.00      0.00             3/26     Kernel#send
                      0.00      0.00      0.00      0.00              1/4     Module#delegate
                      0.00      0.00      0.00      0.00             3/22     Object#eigenclass
                      0.00      0.00      0.00      0.00             2/53     Kernel#singleton_method_added
                      0.00      0.00      0.00      0.00             3/48     Class#inherited
                      0.00      0.00      0.00      0.00            8/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00             1/62     Module#attr_reader
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             8/32     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#empty
                      0.00      0.00      0.00      0.00            24/32     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
   0.00%   0.00%      0.00      0.00      0.00      0.00               32     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::Nn#companion
                      0.00      0.00      0.00      0.00             3/26     Kernel#send
                      0.00      0.00      0.00      0.00              1/7     Module#include
                      0.00      0.00      0.00      0.00              1/4     Module#delegate
                      0.00      0.00      0.00      0.00             3/22     Object#eigenclass
                      0.00      0.00      0.00      0.00             2/53     Kernel#singleton_method_added
                      0.00      0.00      0.00      0.00             3/48     Class#inherited
                      0.00      0.00      0.00      0.00           18/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00             1/62     Module#attr_reader
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Values::SegmentValGroup#at
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Envelope::InterchangeVal#segment_vals
                      0.00      0.00      0.00      0.00             4/16     Array#select
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          155/155     Stupidedi::AbstractSet#disjoint?
   0.00%   0.00%      0.00      0.00      0.00      0.00              155     #<Class:0xb7339a34>#empty?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          155/155     Stupidedi::AbstractSet#disjoint?
   0.00%   0.00%      0.00      0.00      0.00      0.00              155     #<Class:0xb7532b88>#empty?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          310/310     Stupidedi::AbstractSet#disjoint?
   0.00%   0.00%      0.00      0.00      0.00      0.00              310     #<Class:0xb7532b88>#intersection
                      0.00      0.00      0.00      0.00         465/4712     Kernel#is_a?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            13/29     Numeric#zero?
                      0.00      0.00      0.00      0.00            14/29     Stupidedi::AbsoluteSet#==
                      0.00      0.00      0.00      0.00             2/29     Fixnum#==
   0.00%   0.00%      0.00      0.00      0.00      0.00               29     Bignum#==
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            43/43     Stupidedi::AbsoluteSet#union
   0.00%   0.00%      0.00      0.00      0.00      0.00               43     Bignum#|
                      0.00      0.00      0.00      0.00            43/84     Integer#to_int
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          247/247     Stupidedi::AbsoluteSet#union
   0.00%   0.00%      0.00      0.00      0.00      0.00              247     Fixnum#|
                      0.00      0.00      0.00      0.00             4/84     Integer#to_int
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          290/491     Stupidedi::AbsoluteSet#union
                      0.00      0.00      0.00      0.00          201/491     Stupidedi::AbsoluteSet#intersection
   0.00%   0.00%      0.00      0.00      0.00      0.00              491     Stupidedi::AbsoluteSet#copy
                      0.00      0.00      0.00      0.00        982/30212     Hash#fetch
                      0.00      0.00      0.00      0.00        491/13048     Kernel#class
                      0.00      0.00      0.00      0.00        491/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          201/201     Stupidedi::AbstractSet#disjoint?
   0.00%   0.00%      0.00      0.00      0.00      0.00              201     Stupidedi::AbsoluteSet#empty?
                      0.00      0.00      0.00      0.00         188/2974     Fixnum#zero?
                      0.00      0.00      0.00      0.00            13/13     Numeric#zero?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Values::SegmentValGroup#defined_at?
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Envelope::InterchangeDef#segment_uses
                      0.00      0.00      0.00      0.00           1/1341     Array#+
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            48/48     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00               48     Stupidedi::Reader::CompositeElementTok#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            12/12     Stupidedi::Schema::ElementUse#value
   0.00%   0.00%      0.00      0.00      0.00      0.00               12     Stupidedi::Schema::CompositeElementDef#value
                      0.00      0.00      0.00      0.00             1/48     Class#inherited
                      0.00      0.00      0.00      0.00            8/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00             4/62     Module#attr_reader
                      0.00      0.00      0.00      0.00         12/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            32/32     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00               32     Stupidedi::Values::CompositeElementVal#initialize
                      0.00      0.00      0.00      0.00          16/1360     NilClass#nil?
                      0.00      0.00      0.00      0.00          16/3102     Kernel#nil?
                      0.00      0.00      0.00      0.00           16/677     Array#map
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          168/168     Stupidedi::AbsoluteSet#as_mask
   0.00%   0.00%      0.00      0.00      0.00      0.00              168     #<Class:0xb7339a34>#each
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          168/168     Stupidedi::AbsoluteSet#as_mask
   0.00%   0.00%      0.00      0.00      0.00      0.00              168     #<Class:0xb7339a34>#size
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     #<Class:0xb7549d88>#companion
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     #<Class:0xb754a490>#companion
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              8/8     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
   0.00%   0.00%      0.00      0.00      0.00      0.00                8     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal>#value
                      0.00      0.00      0.00      0.00           8/3102     Kernel#nil?
                      0.00      0.00      0.00      0.00            24/60     String#slice
                      0.00      0.00      0.00      0.00           8/4712     Kernel#is_a?
                      0.00      0.00      0.00      0.00          8/10874     Fixnum#<
                      0.00      0.00      0.00      0.00            8/543     String#empty?
                      0.00      0.00      0.00      0.00         24/13738     String#to_s
                      0.00      0.00      0.00      0.00          8/23624     Class#new
                      0.00      0.00      0.00      0.00           8/8425     String#length
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            20/20     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
   0.00%   0.00%      0.00      0.00      0.00      0.00               20     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DecimalVal>#value
                      0.00      0.00      0.00      0.00          20/4712     Kernel#is_a?
                      0.00      0.00      0.00      0.00           20/140     String#blankness?
                      0.00      0.00      0.00      0.00            20/44     String#to_d
                      0.00      0.00      0.00      0.00           20/326     Kernel#respond_to?
                      0.00      0.00      0.00      0.00         20/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          240/240     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
   0.00%   0.00%      0.00      0.00      0.00      0.00              240     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal>#value
                      0.00      0.00      0.00      0.00         240/3102     Kernel#nil?
                      0.00      0.00      0.00      0.00         240/4712     Kernel#is_a?
                      0.00      0.00      0.00      0.00          240/543     String#empty?
                      0.00      0.00      0.00      0.00        216/13738     String#to_s
                      0.00      0.00      0.00      0.00        240/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            24/24     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
   0.00%   0.00%      0.00      0.00      0.00      0.00               24     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal>#value
                      0.00      0.00      0.00      0.00          24/4712     Kernel#is_a?
                      0.00      0.00      0.00      0.00           24/140     String#blankness?
                      0.00      0.00      0.00      0.00            24/44     String#to_d
                      0.00      0.00      0.00      0.00           24/326     Kernel#respond_to?
                      0.00      0.00      0.00      0.00         24/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          280/280     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
   0.00%   0.00%      0.00      0.00      0.00      0.00              280     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal>#value
                      0.00      0.00      0.00      0.00          280/543     String#empty?
                      0.00      0.00      0.00      0.00        280/13738     String#to_s
                      0.00      0.00      0.00      0.00          280/326     Kernel#respond_to?
                      0.00      0.00      0.00      0.00        280/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              8/8     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
   0.00%   0.00%      0.00      0.00      0.00      0.00                8     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal>#value
                      0.00      0.00      0.00      0.00           8/3102     Kernel#nil?
                      0.00      0.00      0.00      0.00            32/60     String#slice
                      0.00      0.00      0.00      0.00          24/4712     Kernel#is_a?
                      0.00      0.00      0.00      0.00             8/68     String#to_i
                      0.00      0.00      0.00      0.00            8/140     String#blankness?
                      0.00      0.00      0.00      0.00           16/111     Object#try
                      0.00      0.00      0.00      0.00         32/13738     String#to_s
                      0.00      0.00      0.00      0.00          8/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              8/8     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
   0.00%   0.00%      0.00      0.00      0.00      0.00                8     <Class::Stupidedi::Dictionaries::Interchanges::FiveOhOne::ElementDefs::SeparatorElementVal>#value
                      0.00      0.00      0.00      0.00          8/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            33/33     Stupidedi::AbsoluteSet#intersection
   0.00%   0.00%      0.00      0.00      0.00      0.00               33     Bignum#&
                      0.00      0.00      0.00      0.00            33/84     Integer#to_int
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          168/168     Stupidedi::AbsoluteSet#intersection
   0.00%   0.00%      0.00      0.00      0.00      0.00              168     Fixnum#&
                      0.00      0.00      0.00      0.00             4/84     Integer#to_int
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             4/84     Fixnum#|
                      0.00      0.00      0.00      0.00             4/84     Fixnum#&
                      0.00      0.00      0.00      0.00            43/84     Bignum#|
                      0.00      0.00      0.00      0.00            33/84     Bignum#&
   0.00%   0.00%      0.00      0.00      0.00      0.00               84     Integer#to_int
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            13/13     Stupidedi::AbsoluteSet#empty?
   0.00%   0.00%      0.00      0.00      0.00      0.00               13     Numeric#zero?
                      0.00      0.00      0.00      0.00            13/29     Bignum#==
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          168/168     Stupidedi::AbsoluteSet#as_mask
   0.00%   0.00%      0.00      0.00      0.00      0.00              168     Stupidedi::AbstractSet#infinite?
                      0.00      0.00      0.00      0.00          168/168     #<Class:0xb7339a34>#finite?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            20/20     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
   0.00%   0.00%      0.00      0.00      0.00      0.00               20     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::R#companion
                      0.00      0.00      0.00      0.00             3/26     Kernel#send
                      0.00      0.00      0.00      0.00              1/7     Module#include
                      0.00      0.00      0.00      0.00              1/4     Module#delegate
                      0.00      0.00      0.00      0.00             3/22     Object#eigenclass
                      0.00      0.00      0.00      0.00             2/53     Kernel#singleton_method_added
                      0.00      0.00      0.00      0.00             3/48     Class#inherited
                      0.00      0.00      0.00      0.00           18/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00             1/62     Module#attr_reader
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              8/8     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::SimpleElementDef#value
   0.00%   0.00%      0.00      0.00      0.00      0.00                8     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TM#companion
                      0.00      0.00      0.00      0.00          1/23479     <Class::Object>#allocate
                      0.00      0.00      0.00      0.00             3/26     Kernel#send
                      0.00      0.00      0.00      0.00             3/22     Object#eigenclass
                      0.00      0.00      0.00      0.00             2/53     Kernel#singleton_method_added
                      0.00      0.00      0.00      0.00             3/48     Class#inherited
                      0.00      0.00      0.00      0.00            9/377     <Class::Object>#method_added
                      0.00      0.00      0.00      0.00             1/62     Module#attr_reader
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          104/104     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00              104     Stupidedi::Reader::ComponentElementTok#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00           4/1536     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal::Proper#initialize
                      0.00      0.00      0.00      0.00         396/1536     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal::NonEmpty#initialize
                      0.00      0.00      0.00      0.00         776/1536     Class#new
                      0.00      0.00      0.00      0.00           8/1536     Stupidedi::Dictionaries::Interchanges::FiveOhOne::ElementDefs::SeparatorElementVal#initialize
                      0.00      0.00      0.00      0.00          40/1536     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DecimalVal::NonEmpty#initialize
                      0.00      0.00      0.00      0.00         260/1536     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal::NonEmpty#initialize
                      0.00      0.00      0.00      0.00           4/1536     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal::Improper#initialize
                      0.00      0.00      0.00      0.00          40/1536     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal::NonEmpty#initialize
                      0.00      0.00      0.00      0.00           8/1536     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal::NonEmpty#initialize
   0.00%   0.00%      0.00      0.00      0.00      0.00             1536     Stupidedi::Values::SimpleElementVal#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          168/168     Stupidedi::AbstractSet#infinite?
   0.00%   0.00%      0.00      0.00      0.00      0.00              168     #<Class:0xb7339a34>#finite?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00        2467/2467     Hash#each
   0.00%   0.00%      0.00      0.00      0.00      0.00             2467     Bignum#[]
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00        2838/2838     Hash#each
   0.00%   0.00%      0.00      0.00      0.00      0.00             2838     Fixnum#[]
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              1/4     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::AN#companion
                      0.00      0.00      0.00      0.00              1/4     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::R#companion
                      0.00      0.00      0.00      0.00              1/4     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::Nn#companion
                      0.00      0.00      0.00      0.00              1/4     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::ID#companion
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Module#delegate
                      0.00      0.00      0.00      0.00          4/30212     Hash#fetch
                      0.00      0.00      0.00      0.00              4/4     Array#init
                      0.00      0.00      0.00      0.00           4/4712     Kernel#is_a?
                      0.00      0.00      0.00      0.00             8/19     Array#last
                      0.00      0.00      0.00      0.00             4/19     Array#first
                      0.00      0.00      0.00      0.00           4/1944     Array#each
                      0.00      0.00      0.00      0.00             4/15     String#split
                      0.00      0.00      0.00      0.00             4/15     Kernel#caller
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            24/44     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal>#value
                      0.00      0.00      0.00      0.00            20/44     <Class::Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DecimalVal>#value
   0.00%   0.00%      0.00      0.00      0.00      0.00               44     String#to_d
                      0.00      0.00      0.00      0.00            44/44     Regexp#=~
                      0.00      0.00      0.00      0.00         44/13738     String#to_s
                      0.00      0.00      0.00      0.00            44/44     Kernel#BigDecimal
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          491/491     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00              491     Stupidedi::AbsoluteSet#initialize
                      0.00      0.00      0.00      0.00          491/652     Kernel#freeze
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Module#delegate
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Array#init
                      0.00      0.00      0.00      0.00          4/23479     <Class::Object>#allocate
                      0.00      0.00      0.00      0.00          4/40586     Fixnum#+
                      0.00      0.00      0.00      0.00            4/421     Array#slice
                      0.00      0.00      0.00      0.00              4/4     Fixnum#-@
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            44/44     String#to_d
   0.00%   0.00%      0.00      0.00      0.00      0.00               44     Kernel#BigDecimal
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            44/44     String#to_d
   0.00%   0.00%      0.00      0.00      0.00      0.00               44     Regexp#=~
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal::Improper#initialize
                      0.00      0.00      0.00      0.00           4/1536     Stupidedi::Values::SimpleElementVal#initialize
                      0.00      0.00      0.00      0.00            12/68     String#to_i
                      0.00      0.00      0.00      0.00            12/28     Comparable#between?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal::Proper#initialize
                      0.00      0.00      0.00      0.00           4/1536     Stupidedi::Values::SimpleElementVal#initialize
                      0.00      0.00      0.00      0.00            12/68     String#to_i
                      0.00      0.00      0.00      0.00              4/4     <Class::Date>#civil
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            20/20     Array#map
   0.00%   0.00%      0.00      0.00      0.00      0.00               20     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DecimalVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00         80/30212     Hash#fetch
                      0.00      0.00      0.00      0.00         20/13048     Kernel#class
                      0.00      0.00      0.00      0.00         20/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            40/40     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00               40     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DecimalVal::NonEmpty#initialize
                      0.00      0.00      0.00      0.00          40/1536     Stupidedi::Values::SimpleElementVal#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          180/180     Array#map
   0.00%   0.00%      0.00      0.00      0.00      0.00              180     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00        720/30212     Hash#fetch
                      0.00      0.00      0.00      0.00        180/13048     Kernel#class
                      0.00      0.00      0.00      0.00        180/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          396/396     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00              396     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::IdentifierVal::NonEmpty#initialize
                      0.00      0.00      0.00      0.00         396/1536     Stupidedi::Values::SimpleElementVal#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            16/16     Array#map
   0.00%   0.00%      0.00      0.00      0.00      0.00               16     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00         64/30212     Hash#fetch
                      0.00      0.00      0.00      0.00         16/13048     Kernel#class
                      0.00      0.00      0.00      0.00         16/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            40/40     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00               40     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::NumericVal::NonEmpty#initialize
                      0.00      0.00      0.00      0.00          40/1536     Stupidedi::Values::SimpleElementVal#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          116/116     Array#map
   0.00%   0.00%      0.00      0.00      0.00      0.00              116     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal::NonEmpty#copy
                      0.00      0.00      0.00      0.00        464/30212     Hash#fetch
                      0.00      0.00      0.00      0.00        116/13048     Kernel#class
                      0.00      0.00      0.00      0.00        116/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00          260/260     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00              260     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::StringVal::NonEmpty#initialize
                      0.00      0.00      0.00      0.00         260/1536     Stupidedi::Values::SimpleElementVal#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              8/8     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                8     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal::NonEmpty#initialize
                      0.00      0.00      0.00      0.00           8/1536     Stupidedi::Values::SimpleElementVal#initialize
                      0.00      0.00      0.00      0.00          32/3102     Kernel#nil?
                      0.00      0.00      0.00      0.00          16/1360     NilClass#nil?
                      0.00      0.00      0.00      0.00            16/28     Comparable#between?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              8/8     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00                8     Stupidedi::Dictionaries::Interchanges::FiveOhOne::ElementDefs::SeparatorElementVal#initialize
                      0.00      0.00      0.00      0.00           8/1536     Stupidedi::Values::SimpleElementVal#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            16/16     Array#map
   0.00%   0.00%      0.00      0.00      0.00      0.00               16     Stupidedi::Values::CompositeElementVal#copy
                      0.00      0.00      0.00      0.00         64/30212     Hash#fetch
                      0.00      0.00      0.00      0.00         16/13048     Kernel#class
                      0.00      0.00      0.00      0.00         16/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal::Proper#initialize
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     <Class::Date>#civil
                      0.00      0.00      0.00      0.00              4/4     Class#new!
                      0.00      0.00      0.00      0.00              4/4     <Class::Date>#jd_to_ajd
                      0.00      0.00      0.00      0.00              4/4     <Class::Date>#valid_civil?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            12/28     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::DateVal::Improper#initialize
                      0.00      0.00      0.00      0.00            16/28     Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::ElementTypes::TimeVal::NonEmpty#initialize
   0.00%   0.00%      0.00      0.00      0.00      0.00               28     Comparable#between?
                      0.00      0.00      0.00      0.00            56/56     Fixnum#<=>
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Array#init
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Fixnum#-@
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     <Class::Date>#civil
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     <Class::Date>#jd_to_ajd
                      0.00      0.00      0.00      0.00          4/40586     Fixnum#+
                      0.00      0.00      0.00      0.00              4/8     Rational#/
                      0.00      0.00      0.00      0.00              4/4     Integer#to_r
                      0.00      0.00      0.00      0.00           8/7575     Fixnum#-
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     <Class::Date>#civil
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     <Class::Date>#valid_civil?
                      0.00      0.00      0.00      0.00              4/4     <Class::Date>#civil_to_jd
                      0.00      0.00      0.00      0.00          8/10874     Fixnum#<
                      0.00      0.00      0.00      0.00              4/4     <Class::Date>#jd_to_civil
                      0.00      0.00      0.00      0.00              4/4     Array#==
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     <Class::Date>#civil
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Class#new!
                      0.00      0.00      0.00      0.00          4/23479     <Class::Object>#allocate
                      0.00      0.00      0.00      0.00              4/4     Date#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            56/56     Comparable#between?
   0.00%   0.00%      0.00      0.00      0.00      0.00               56     Fixnum#<=>
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     <Class::Date>#valid_civil?
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     <Class::Date>#civil_to_jd
                      0.00      0.00      0.00      0.00              4/8     <Class::Date>#julian?
                      0.00      0.00      0.00      0.00             8/16     Fixnum#/
                      0.00      0.00      0.00      0.00             8/16     Float#*
                      0.00      0.00      0.00      0.00            16/40     Float#floor
                      0.00      0.00      0.00      0.00         28/40586     Fixnum#+
                      0.00      0.00      0.00      0.00           4/1088     Fixnum#<=
                      0.00      0.00      0.00      0.00          12/7575     Fixnum#-
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     <Class::Date>#valid_civil?
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     <Class::Date>#jd_to_civil
                      0.00      0.00      0.00      0.00              4/8     <Class::Date>#julian?
                      0.00      0.00      0.00      0.00             8/24     Float#/
                      0.00      0.00      0.00      0.00             8/16     Fixnum#/
                      0.00      0.00      0.00      0.00             8/16     Float#*
                      0.00      0.00      0.00      0.00            24/40     Float#floor
                      0.00      0.00      0.00      0.00         12/40586     Fixnum#+
                      0.00      0.00      0.00      0.00           4/1088     Fixnum#<=
                      0.00      0.00      0.00      0.00          32/7575     Fixnum#-
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     <Class::Date>#valid_civil?
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Array#==
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Class#new!
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Date#initialize
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     <Class::Date>#jd_to_ajd
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Integer#to_r
                      0.00      0.00      0.00      0.00             4/12     Object#Rational
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/8     <Class::Date>#jd_to_ajd
                      0.00      0.00      0.00      0.00              4/8     Rational#/
   0.00%   0.00%      0.00      0.00      0.00      0.00                8     Rational#/
                      0.00      0.00      0.00      0.00             4/12     Object#Rational
                      0.00      0.00      0.00      0.00              4/8     Rational#/
                      0.00      0.00      0.00      0.00             8/20     Fixnum#*
                      0.00      0.00      0.00      0.00           4/1510     Fixnum#==
                      0.00      0.00      0.00      0.00            12/76     Kernel#kind_of?
                      0.00      0.00      0.00      0.00             4/20     <Class::Rational>#new!
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/8     <Class::Date>#jd_to_civil
                      0.00      0.00      0.00      0.00              4/8     <Class::Date>#civil_to_jd
   0.00%   0.00%      0.00      0.00      0.00      0.00                8     <Class::Date>#julian?
                      0.00      0.00      0.00      0.00             8/48     Module#===
                      0.00      0.00      0.00      0.00          8/10874     Fixnum#<
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            12/20     <Class::Rational>#reduce
                      0.00      0.00      0.00      0.00             4/20     Rational#/
                      0.00      0.00      0.00      0.00             4/20     Rational#coerce
   0.00%   0.00%      0.00      0.00      0.00      0.00               20     <Class::Rational>#new!
                      0.00      0.00      0.00      0.00         20/23624     Class#new
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             8/16     <Class::Date>#jd_to_civil
                      0.00      0.00      0.00      0.00             8/16     <Class::Date>#civil_to_jd
   0.00%   0.00%      0.00      0.00      0.00      0.00               16     Fixnum#/
                      0.00      0.00      0.00      0.00            16/24     Float#/
                      0.00      0.00      0.00      0.00            16/16     Float#coerce
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             8/16     <Class::Date>#jd_to_civil
                      0.00      0.00      0.00      0.00             8/16     <Class::Date>#civil_to_jd
   0.00%   0.00%      0.00      0.00      0.00      0.00               16     Float#*
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             8/24     <Class::Date>#jd_to_civil
                      0.00      0.00      0.00      0.00            16/24     Fixnum#/
   0.00%   0.00%      0.00      0.00      0.00      0.00               24     Float#/
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            24/40     <Class::Date>#jd_to_civil
                      0.00      0.00      0.00      0.00            16/40     <Class::Date>#civil_to_jd
   0.00%   0.00%      0.00      0.00      0.00      0.00               40     Float#floor
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            40/76     Rational#initialize
                      0.00      0.00      0.00      0.00            12/76     Rational#/
                      0.00      0.00      0.00      0.00             4/76     Rational#-
                      0.00      0.00      0.00      0.00             8/76     Rational#coerce
                      0.00      0.00      0.00      0.00            12/76     Object#Rational
   0.00%   0.00%      0.00      0.00      0.00      0.00               76     Kernel#kind_of?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             4/12     Integer#to_r
                      0.00      0.00      0.00      0.00             4/12     Rational#/
                      0.00      0.00      0.00      0.00             4/12     Rational#-
   0.00%   0.00%      0.00      0.00      0.00      0.00               12     Object#Rational
                      0.00      0.00      0.00      0.00            12/76     Kernel#kind_of?
                      0.00      0.00      0.00      0.00            12/12     <Class::Rational>#reduce
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Fixnum#-
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Rational#-
                      0.00      0.00      0.00      0.00             4/12     Object#Rational
                      0.00      0.00      0.00      0.00            12/20     Fixnum#*
                      0.00      0.00      0.00      0.00           4/7575     Fixnum#-
                      0.00      0.00      0.00      0.00             4/76     Kernel#kind_of?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00              4/4     Fixnum#-
   0.00%   0.00%      0.00      0.00      0.00      0.00                4     Rational#coerce
                      0.00      0.00      0.00      0.00             8/76     Kernel#kind_of?
                      0.00      0.00      0.00      0.00             4/20     <Class::Rational>#new!
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            12/12     Object#Rational
   0.00%   0.00%      0.00      0.00      0.00      0.00               12     <Class::Rational>#reduce
                      0.00      0.00      0.00      0.00            24/24     Fixnum#div
                      0.00      0.00      0.00      0.00            12/12     Integer#gcd
                      0.00      0.00      0.00      0.00         12/10874     Fixnum#<
                      0.00      0.00      0.00      0.00          24/1510     Fixnum#==
                      0.00      0.00      0.00      0.00            12/20     <Class::Rational>#new!
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00             8/20     Rational#/
                      0.00      0.00      0.00      0.00            12/20     Rational#-
   0.00%   0.00%      0.00      0.00      0.00      0.00               20     Fixnum#*
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            16/16     Fixnum#/
   0.00%   0.00%      0.00      0.00      0.00      0.00               16     Float#coerce
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            24/24     <Class::Rational>#reduce
   0.00%   0.00%      0.00      0.00      0.00      0.00               24     Fixnum#div
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            12/12     <Class::Rational>#reduce
   0.00%   0.00%      0.00      0.00      0.00      0.00               12     Integer#gcd
                      0.00      0.00      0.00      0.00         32/12115     Fixnum#>
                      0.00      0.00      0.00      0.00            24/24     Fixnum#abs
                      0.00      0.00      0.00      0.00            20/20     Fixnum#%
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            20/20     Class#new
   0.00%   0.00%      0.00      0.00      0.00      0.00               20     Rational#initialize
                      0.00      0.00      0.00      0.00         20/10874     Fixnum#<
                      0.00      0.00      0.00      0.00            40/76     Kernel#kind_of?
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            20/20     Integer#gcd
   0.00%   0.00%      0.00      0.00      0.00      0.00               20     Fixnum#%
--------------------------------------------------------------------------------
                      0.00      0.00      0.00      0.00            24/24     Integer#gcd
   0.00%   0.00%      0.00      0.00      0.00      0.00               24     Fixnum#abs


#<Stupidedi::Builder_::StateMachine:0xb739c918
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
         SeparatorElementVal.value[I15](:))))]>
