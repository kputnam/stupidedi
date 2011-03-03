require 'support/quickcheck'

class QuickCheck
  class SerializedEdi < ::QuickCheck

    has_parameter :element_separator,    "*"
    has_parameter :segment_terminator,   "~"
    has_parameter :component_separator,  ":"
    has_parameter :repetition_separator, "^"

    module Macro
      def property(&setup)
        SerializedEdi.property(&setup)
      end
    end

    def is_delimiter?(c)
      segment_terminator   == c or
      element_separator    == c or
      component_separator  == c or
      repetition_separator == c
    end

    def char
      Delegators::Char.new(self)
    end

    def stream
      Delegators::Stream.new(self)
    end

    def element(element_def = nil)
      delegator = Delegators::SimpleElement.new(self)

      case element_def
      when nil then delegator
      when Stupidedi::FiftyTen::Definitions::ElementTypes::Nn then delegator.nn
      when Stupidedi::FiftyTen::Definitions::ElementTypes::R  then delegator.r
      when Stupidedi::FiftyTen::Definitions::ElementTypes::ID then delegator.id
      when Stupidedi::FiftyTen::Definitions::ElementTypes::AN then delegator.an
      when Stupidedi::FiftyTen::Definitions::ElementTypes::DT then with(:size, choose([element_def.min_length, element_def.max_length])) { delegator.dt }
      when Stupidedi::FiftyTen::Definitions::ElementTypes::TM then with(:size, choose([element_def.min_length, element_def.max_length])) { delegator.tm }
      when Stupidedi::FiftyTen::Definitions::ElementTypes::CompositeElementDef then composite(element_def)
      else raise ArgumentError, "Expected nil or certain SimpleElementDefs but got #{element_def.inspect}"
      end
    end

    def composite(element_def = nil)
      case element_def
      when nil
        Delegators::CompositeElement.new(self)
      when Stupidedi::FiftyTen::Definitions::ElementTypes::CompositeElementDef
        # Generate each component element
        es = element_def.component_element_uses.map do |eu|
          if eu.required?
            value { element eu.element_def }
          else
            value { choose [element(eu.element_def), element.blank] }
          end
        end

        # Collapse the suffix of blank elements
        suffix, es = es.reverse.span(&:empty?)
        es.reverse.join(component_separator)
      else
        raise ArgumentError, "Expected nil or CompositeElementDef but got #{element_def.inspect}"
      end
    end

    def segment
      Delegators::Segment.new(self)
    end

    def document
      Delegators::Document.new(self)
    end

    def current
      Delegators::Current.new(self)
    end

    class Delegator < BlankSlate
      def initialize(quickcheck)
        @quickcheck = quickcheck
      end

      def method_missing(name, *args, &block)
        @quickcheck.send(name, *args, &block)
      end
    end

    module Delegators
      class Char < Delegator
        ##
        # Generate a single basic character
        def basic
          choose(Stupidedi::Reader.basic_characters).tap{|c| guard !is_delimiter?(c) }
        end

        ##
        # Generate a single control character
        def control
          choose(Stupidedi::Reader.control_characters).tap{|c| guard !is_delimiter?(c) }
        end

        ##
        # Generate a single extended character
        def extended
          choose(Stupidedi::Reader.extended_characters).tap{|c| guard !is_delimiter?(c) }
        end

        ##
        # Generate a single delimiter character
        def delimiter
          choose [segment_terminator,
                  element_separator,
                  component_separator,
                  repetition_separator]
        end
      end

      class Stream < Delegator
        ##
        # Generate a sized string of control characters
        def control
          array { char.control }.join
        end

        ##
        # Generate a sized string of basic characters
        def basic
          array { char.basic }.join
        end

        ##
        # Generate a sized string of extended characters
        def extended
          array { char.extended }.join
        end

        ##
        # Generate a sized string of spaces
        def space(length = size)
          " " * length
        end

        ##
        # Randomly insert control characters into the string
        #   OPTIMIZE: this seems slow, but profile it first
        def agitate(string)
          string.split(//).bind{|cs| map(cs.length + 1) { choose ["", char.control] }.zip(cs).flatten.join }
        end

        ##
        # Pad the ends of the string with random spaces
        def pad(string)
          with(:size, between(0, size)) { space } << string <<
          with(:size, between(0, size)) { space }
        end
      end

      class SimpleElement < Delegator
        def blank
          ""
        end

        ##
        # Generate a sized string representing a numeric value (Nn)
        def nn
          choose(["", "+", "-"]) + string(:digit)
        end

        ##
        # Generate a sized string representing a decimal value (R)
        def r(length = size)
          decimal  = with(:size, between(0, length)) { string :digit }
          exponent = with(:size, between(0, decimal.length)) { string :digit }
          whole    = with(:size, length - decimal.length - exponent.length) { string :digit }

          decimal  = (decimal.empty?) ? choose(["", "."]) : ".#{decimal}"
          exponent = "E#{choose ["", "-", "+"]}#{exponent}" unless exponent.empty?
          whole    = "#{choose ["", "-", "+"]}#{whole}"

          "#{whole}#{decimal}#{exponent}"
        end

        ##
        # Generate a sized string representing an identifier value (ID)
        def id
          array { choose [char.basic, char.extended] }.join.tap{|s| guard s !~ /^\s+$/ }
        end

        ##
        # Generate a sized string representing a string value (AN)
        def an
          array { choose [char.basic, char.extended, " "] }.join.tap{|s| guard s !~ /^\s+$/ }
        end

        ##
        # Generate a sized string representing a date (DT)
        def dt
          year  = between(0, 9999)
          month = between(1, 12)
          day   = between(1, 31)

          # Ensure this is a valid date
          guard begin Date.civil(year, month, day); rescue ArgumentError; false end

          case size
          when 6 then "%02d%02d%02d" % [year.modulo(100), month, day]
          when 8 then "%04d%02d%02d" % [year, month, day]
          else raise "Size must be 6 or 8, but it is #{size}"
          end
        end

        ##
        # Generate a sized string representing a time (TM)
        def tm
          case size
          when 2 then "%02d" % between(0, 23)
          when 4 then "%02d%02d" % [between(0, 23).abs, between(0, 59).abs]
          else
            raise "Size must be 2, 4, 6, or greater than 6, but it is #{size}" if size < 6
            hour   = between(0, 23)
            minute = between(0, 59)
            second = between(0, 59)
            fract  = with(:size, size - 6) { string(:digit) }
            "%02d%02d%02d%s" % [hour, minute, second, fract]
          end
        end
      end

      class CompositeElement < Delegator
      end

      class Segment < Delegator
        # Generate a functional header segment
        def gs
        end
      end

      class Document < Delegator
        ##
        # Generate four random delimiters with the restriction that they
        # cannot be control characters, spaces, tabs, numbers, letters,
        # underscores, or numerical symbols.
        def delimiters
          possible  = Stupidedi::Reader.basic_characters
          possible += Stupidedi::Reader.extended_characters
          possible -= QuickCheck::Characters.of(/[ \t0-9a-z_.+-]/i)

          chars = with(:size, 4) { array { choose(possible) }}
          guard chars.uniq.size == 4

          Hash[:element_separator    => chars[0],
               :segment_terminator   => chars[1],
               :component_separator  => chars[2],
               :repetition_separator => chars[3]]
        end

        def transaction_set
          choose [{:function_id => "HS", :industry_id => "005010X279", :transaction_set_id => "270", :name => "Eligibility Inquiry"          },
                  {:function_id => "HB", :industry_id => "005010X279", :transaction_set_id => "271", :name => "Eligibility Response"         },
                  {:function_id => "HR", :industry_id => "005010X212", :transaction_set_id => "276", :name => "Status Request"               },
                  {:function_id => "HN", :industry_id => "005010X212", :transaction_set_id => "277", :name => "Status Notification"          },
                  {:function_id => "HP", :industry_id => "005010X221", :transaction_set_id => "835", :name => "Remittance Advice"            },
                  {:function_id => "HC", :industry_id => "005010X222", :transaction_set_id => "837", :name => "Claim: Professional"          },
                  {:function_id => "HC", :industry_id => "005010X223", :transaction_set_id => "837", :name => "Claim: Institutional"         },
                  {:function_id => "HC", :industry_id => "005010X224", :transaction_set_id => "837", :name => "Claim: Dential"               },
                  {:function_id => "FA", :industry_id => "005010X230", :transaction_set_id => "997", :name => "Functional Acknowledgment"    },
                  {:function_id => "FA", :industry_id => "005010X231", :transaction_set_id => "999", :name => "Implementation Acknowledgment"}]
        end
      end

      class Current < Delegator
        def delimiters
          Hash[:element_separator    => element_separator,
               :segment_terminator   => segment_terminator,
               :component_separator  => component_separator,
               :repetition_separator => repetition_separator]
        end

        def isa
          Stupidedi::Interchange::FiveOhOne::InterchangeHeader.default(delimiters)
        end
      end

    end

  end
end
