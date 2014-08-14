require "support/quickcheck"

class QuickCheck

  #
  #
  #
  class SerializedEdi < ::QuickCheck

    #
    #
    #
    module Macro
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def property(*args, &setup)
          QuickCheck.property(self, *args, &setup)
        end
      end
    end

    has_parameter :separators,
      Stupidedi::Reader::Separators.new(":", "^", "*", "~")

    def is_delimiter?(c)
      separators.segment    == c or
      separators.element    == c or
      separators.component  == c or
      separators.repetition == c
    end

    # @return [Delegators::Char]
    def char
      Delegators::Char.new(self)
    end

    # @return [Delegators::Stream]
    def stream
      Delegators::Stream.new(self)
    end

    # @return [Delegators::SimpleElement]
    # @return [String]
    def element(element_def = nil)
      delegator = Delegators::SimpleElement.new(self)

      if element_def.respond_to?(:min_length)
        min = element_def.min_length
        max = element_def.max_length
      end

      case element_def
      when nil
        delegator
      when Stupidedi::FiftyTen::Definitions::ElementTypes::Nn
        with(:size, choose([min, max])) { delegator.nn }
      when Stupidedi::FiftyTen::Definitions::ElementTypes::R
        with(:size, choose([min, max])) { delegator.r  }
      when Stupidedi::FiftyTen::Definitions::ElementTypes::ID
        with(:size, choose([min, max])) { delegator.id }
      when Stupidedi::FiftyTen::Definitions::ElementTypes::AN
        with(:size, choose([min, max])) { delegator.an }
      when Stupidedi::FiftyTen::Definitions::ElementTypes::DT
        with(:size, choose([min, max])) { delegator.dt }
      when Stupidedi::FiftyTen::Definitions::ElementTypes::TM
        with(:size, choose([min, max])) { delegator.tm }
      when Stupidedi::FiftyTen::Definitions::ElementTypes::CompositeElementDef
        composite(element_def)
      else
        raise ArgumentError
      end
    end

    # @return [Delegators::CompositeElement]
    # @return [String]
    def composite(element_def = nil)
      case element_def
      when nil
        Delegators::CompositeElement.new(self)
      when Stupidedi::Schema::CompositeElementDef
        # Generate each component element
        elements = element_def.component_element_uses.map do |use|
          if use.required?
            value { element(use.definition) }
          else
            value { choose([element(use.definition), element.blank]) }
          end
        end

        # Collapse the suffix of blank elements
        suffix, elements = elements.reverse.split_until(&:empty?)
        elements.reverse.join(separators.component)
      else
        raise ArgumentError
      end
    end

    # @return [Delegators::Segment]
    def segment
      Delegators::Segment.new(self)
    end

    # @return [Delegators::Document]
    def document
      Delegators::Document.new(self)
    end

    # @return [Delegators::Current]
    def current
      Delegators::Current.new(self)
    end

    #
    #
    #
    class Delegator < Stupidedi::BlankSlate
      def initialize(quickcheck)
        @quickcheck = quickcheck
      end

    private

      def method_missing(name, *args, &block)
        @quickcheck.__send__(name, *args, &block)
      end
    end

    #
    #
    #
    module Delegators

      #
      #
      #
      class Char < Delegator

        # Generate a single basic character
        #
        # @return [Character]
        def basic
          choose(Stupidedi::Reader.basic_characters).tap{|c| guard(!is_delimiter?(c)) }
        end

        # Generate a single control character
        #
        # @return [Character]
        def control
          choose(Stupidedi::Reader.control_characters).tap{|c| guard(!is_delimiter?(c)) }
        end

        # Generate a single extended character
        #
        # @return [Character]
        def extended
          choose(Stupidedi::Reader.extended_characters).tap{|c| guard(!is_delimiter?(c)) }
        end

        # Generate a single delimiter character
        #
        # @return [Character]
        def delimiter
          choose [separators.segment,
                  separators.element,
                  separators.component,
                  separators.repetition]
        end
      end

      #
      #
      #
      class Stream < Delegator

        # Generate a sized string of control characters
        #
        # @return [String]
        def control
          (1..size).inject(""){|s,_| s << char.control }
        end

        # Generate a sized string of basic characters
        #
        # @return [String]
        def basic
          (1..size).inject(""){|s,_| s << char.basic }
        end

        # Generate a sized string of extended characters
        #
        # @return [String]
        def extended
          (1..size).inject(""){|s,_| s << char.extended }
        end

        # Generate a sized string of spaces
        #
        # @return [String]
        def space(length = size)
          " " * length
        end

        # Randomly insert control characters into the string
        #
        # @return [String]
        def agitate(string)
          cs = string.split(//)

          # Generate `cs.length + 1` control characters
          xs = (0..cs.length).inject([]){|s,_| s << choose(["", char.control]) }

          agitated = ""
          xs.zip(cs){|pad, c| agitated << pad << c.to_s }

          agitated
        end

        # Pad the ends of the string with sized random spaces. The combined
        # length of the left and right padding is `sized`
        #
        # @return [String]
        def pad(string)
          left  = space(between(0, size))
          right = space(between(0, size - left.length))
          left << string << right
        end
      end

      #
      #
      #
      class SimpleElement < Delegator

        # Generate a string representing a blank element
        #
        # @return [String]
        def blank
          ""
        end

        # Generate a sized string representing a non-empty numeric element (Nn).
        # The leading sign character is not counted against `size`
        #
        # @return [String]
        def nn
          choose(["", "+", "-"]) << string(:digit)
        end

        # Generate a sized string representing a non-empty decimal element (R).
        # The leading sign character, optional exponent (E) indicator and its
        # sign character are not counted against `size`
        #
        # @return [String]
        def r(length = size)
          decimal  = with(:size, between(0, length)) { string(:digit) }
          exponent = with(:size, between(0, decimal.length)) { string(:digit) }
          whole    = with(:size, length - decimal.length - exponent.length) { string(:digit) }

          decimal =
            if decimal.empty?
              choose(["", "."])
            else
              ".#{decimal}"
            end

          unless exponent.empty?
            exponent = "E#{choose(["", "-", "+"])}#{exponent}"
          end

          whole = "#{choose(["", "-", "+"])}#{whole}"

          "#{whole}#{decimal}#{exponent}"
        end

        # Generate a sized string representing an identifier element (ID)
        #
        # @return [String]
        def id
          (1..size).inject("") do |s,_|
            s << choose([char.basic, char.extended])
          end.tap{|s| guard(!s.blankness?) }
        end

        # Generate a sized string representing a string element (AN)
        #
        # @return [String]
        def an
          (1..size).inject("") do |s,_|
            s << choose([char.basic, char.extended])
          end.tap{|s| guard(!s.blankness?) }
        end

        # Generate a sized string representing a date (DT)
        #
        # @return [String]
        def dt
          year  = between(0, 9999)
          month = between(1, 12)
          day   = between(1, 31)

          # Ensure this is a valid date
          guard(begin Date.civil(year, month, day); rescue ArgumentError; false end)

          case size
          when 6 then "%02d%02d%02d" % [year.modulo(100), month, day]
          when 8 then "%04d%02d%02d" % [year, month, day]
          else raise "Size must be 6 or 8, but it is #{size}"
          end
        end

        # Generate a sized string representing a time (TM)
        #
        # @return [String]
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

      #
      #
      #
      class CompositeElement < Delegator
        # @todo
      end

      #
      #
      #
      class Segment < Delegator

        # @private
        SEGMENT_ID = /^[A-Z][A-Z0-9]{1,2}$/

        def generate(name, *elements)
          # @todo
        end

      private

        def method_missing(name, *arguments, &block)
          if SEGMENT_ID =~ name.to_s
            generate(name)
          else
            super
          end
        end
      end

      #
      #
      #
      class Document < Delegator

        # Generate four random delimiters with the restriction that they cannot
        # be control characters, spaces, tabs, numbers, letters, underscores, or
        # numerical symbols, and each delimiter must be unique.
        #
        # @return [Reader::Separators]
        def delimiters
          possible  = Stupidedi::Reader.basic_characters
          possible << Stupidedi::Reader.extended_characters
          possible -= QuickCheck::Characters.of(/[ \t0-9a-z_.+-]/i)

          delimiters = []

          4.times do
            delimiters << value do
              choose(possible).tap{|x| guard(!delimiters.include?(x)) }
            end
          end

          Stupidedi::Reader::Sepatarors.new(*delimiters)
        end
      end

      #
      #
      #
      class Current < Delegator
        # @todo
      end

    end

  end
end
