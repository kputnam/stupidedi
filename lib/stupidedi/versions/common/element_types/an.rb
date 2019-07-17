# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Versions
    module Common
      module ElementTypes
        class AN < SimpleElementDef
          DATE_FORMAT_SINGLE =
           {"CC"  => "%C",
           #"CD"  => "MMMYYYY",     # Month and Year Expressed in Format MMMYYYY
            "CM"  => "%Y%m",
           #"CQ"  => "CCYYQ",       # Date in Format CCYYQ
            "CY"  => "%Y",
            "D6"  => "%y%m%d",
            "D8"  => "%Y%m%d",
            "DB"  => "%m%d%Y",
            "DD"  => "%d",
            "DT"  => "%Y%m%d%H%M",
           #"EH"  => "YDDD",        # Last Digit of Year and Julian Date Expressed in Format YDDD
            "KA"  => "%y%m%d",
            "MD"  => "%m%d",
            "MM"  => "%m",
           #"TC"  => "DDD",         # Julian Date Expressed in Format DDD
            "TM"  => "%H%M",
            "TQ"  => "%m%y",
            "TR"  => "%d%m%y%H%M",
            "TS"  => "%H%M%S",
            "TT"  => "%m%d%y",
           #"TU"  => "YYDDD",
           #"UN"  => "",            # Unstructured
            "YM"  => "%y%m",
            "YY"  => "%Y",
            "RTS" => "%Y%m%d%H%M%S"}

          DATE_FORMAT_RANGE =
           {"DA"  => ["%d", "%d"],
            "DDT" => ["%Y%m%d", "%Y%m%d%H%M"],
            "DTD" => ["%Y%m%d%H%M", "%Y%m%d"],
            "DTS" => ["%Y%m%d%H%M%S", "%Y%m%d%H%M%S"],
            "RD"  => ["%m%d%Y", "%m%d%Y"],
            "RD2" => ["%y", "%y"],
            "RD4" => ["%Y", "%Y"],
            "RD5" => ["%Y%m", "%Y%m"],
            "RD6" => ["%y%m%d", "%y%m%d"],
            "RD8" => ["%Y%m%d", "%Y%m%d"],
            "RDM" => ["%y%m%d", "%m%d"],
            "RDT" => ["%Y%m%d%H%M", "%Y%m%d%H%M"],
            "RMD" => ["%m%d", "%m%d"],
            "RMY" => ["%y%m", "%y%m"],
            "RTM" => ["%H%M", "%H%M"]}
           #"YMM" => ["CCYYMMM", "MMM"]

          def companion
            StringVal
          end

          # (see AN.strftime)
          # def strftime(format, value)
          #   AN.strftime(format, value)
          # end

          # (see AN.stpftime)
          # def strptime(format, value)
          #   AN.strptime(format, value)
          # end
        end

        class << AN
          # Format date (Date), date time (Time), or a range of either into a
          # String, according to the given format specifier.
          #
          # See {AN::DATE_FORMAT_SINGLE} and {AN::DATE_FORMAT_RANGE} for a list
          # of recognized format specifiers.
          #
          # @return [String]
          def strftime(format, value)
            if AN::DATE_FORMAT_RANGE.defined_at?(format)
              unless value.kind_of?(Range)              and
                     value.end.respond_to?(:strftime)   and
                     value.begin.respond_to?(:strftime)
                raise TypeError,
                  "expected a Range (#strftime..#strftime) but got #{value.inspect}"
              end

              f, g = AN::DATE_FORMAT_RANGE.at(format)
              a, b = value.begin.strftime(f), value.end.strftime(g)
              "#{a}-#{b}"
            elsif AN::DATE_FORMAT_SINGLE.defined_at?(format)
              unless value.respond_to?(:strftime)
                raise TypeError,
                  "expected value to respond to #strftime, but got #{value.inspect}"
              end

              value.strftime(AN::DATE_FORMAT_SINGLE.at(format))

            else
              raise ArgumentError,
                "unrecognized format specifier #{format.inspect}"
            end
          end

          # @private
          THING_DASH_THING = /^[^-]+-[^-]+$/

          # Parse the string into a date (Date), date time (Time), or a range
          # of either according to the given format specifier.
          #
          # See {AN::DATE_FORMAT_SINGLE} and {AN::DATE_FORMAT_RANGE} for a list
          # of recognized format specifiers.
          #
          # @return [Time | Range<Time>]
          def strptime(format, value)
            if AN::DATE_FORMAT_RANGE.defined_at?(format)
              f, g = AN::DATE_FORMAT_RANGE.at(format)
              a, b = value.split("-", 2)

              unless THING_DASH_THING.match?(value)
                raise TypeError,
                  "expected a String with format #{f}-#{g}, but got #{value.inspect}"
              end

              Time.strptime("#{a} Z", "#{f} %z") .. Time.strptime("#{b} Z", "#{g} %z")
            elsif AN::DATE_FORMAT_SINGLE.defined_at?(format)
              Time.strptime("#{value} Z", "#{AN::DATE_FORMAT_SINGLE.at(format)} %z")
            else
              raise ArgumentError,
                "unrecognized format specifier #{format.inspect}"
            end
          end
        end

        #
        # @see X222.pdf B.1.1.3.1.4 String
        #
        class StringVal < Values::SimpleElementVal
          def string?
            true
          end

          def too_long?
            false
          end

          def too_short?
            false
          end

          class Invalid < StringVal
            # @return [Object]
            attr_reader :value

            def initialize(value, usage, position)
              @value = value
              super(usage, position)
            end

            def valid?
              false
            end

            def empty?
              false
            end

            # @return [Invalid]
            def map
              self
            end

            # @return [String]
            # :nocov:
            def inspect
              id = definition.bind do |d|
                "[#{"% 5s" % d.id}: #{d.name}]".bind do |s|
                  if usage.forbidden?
                    ansi.forbidden(s)
                  elsif usage.required?
                    ansi.required(s)
                  else
                    ansi.optional(s)
                  end
                end
              end

              ansi.element("AN.invalid#{id}") + "(#{ansi.invalid(@value.inspect)})"
            end
            # :nocov:

            # @return [String]
            def to_s
              ""
            end

            # @return [String]
            def to_x12(truncate = true)
              ""
            end

            # @return [Boolean]
            def ==(other)
              eql?(other)
            end

            # @return [Invalid]
            def copy(changes = {})
              self
            end
          end

          class Valid < StringVal
            include Comparable

            def_delegators :value, :to_d, :to_s, :to_f, :to_c, :to_r, :to_sym,
              :to_str, :hex, :oct, :ord, :sum, :length, :count, :index, :rindex,
              :lines, :bytes, :chars, :each, :upto, :split, :scan, :unpack, :=~,
              :match, :partition, :rpatition, :encoding, :valid_enocding?, :at,
              :empty?, :blank?

            if "".respond_to?(:match?)
              def_delegators :value, :match?
            end

            extend Operators::Wrappers
            wrappers :%, :+, :*, :slice, :take, :drop, :[], :capitalize,
              :center, :ljust, :rjust, :chomp, :delete, :tr, :tr_s,
              :sub, :gsub, :encode, :force_encoding, :squeeze

            extend Operators::Unary
            unary_operators :chr, :chop, :upcase, :downcase, :strip,
              :lstrip, :rstrip, :dump, :succ, :next, :reverse, :swapcase

            extend Operators::Relational
            relational_operators :<=>, :start_with?, :end_with?,
              :include?, :casecmp, :coerce => :to_str

            def ==(other)
              other = StringVal.value(other, usage, position)
              other.valid? and other.value == value
            end

            # @return [StringVal]
            def copy(changes = {})
              StringVal.value \
                changes.fetch(:value, value),
                changes.fetch(:usage, usage),
                changes.fetch(:position, position)
            end

            def coerce(other)
              return StringVal.value(other, usage, position), self
            end

            def valid?
              true
            end

            # @return [StringVal]
            def map
              StringVal.value(yield(value), usage, position)
            end
          end

          class Empty < Valid
            # @return [String]
            def value
              ""
            end

            # @return [String]
            # :nocov:
            def inspect
              id = definition.bind do |d|
                "[#{"% 5s" % d.id}: #{d.name}]".bind do |s|
                  if usage.forbidden?
                    ansi.forbidden(s)
                  elsif usage.required?
                    ansi.required(s)
                  else
                    ansi.optional(s)
                  end
                end
              end

              ansi.element("AN.empty#{id}")
            end
            # :nocov:

            # @return [String]
            def to_x12(truncate = true)
              ""
            end

            def to_date(format)
              nil
            end
          end

          class NonEmpty < Valid
            # @return [String]
            attr_reader :value

            def initialize(string, usage, position)
              @value = string
              super(usage, position)
            end

            def too_long?
              @value.lstrip.length > definition.max_length
            end

            def too_short?
              @value.lstrip.length < definition.min_length
            end

            # @return [String]
            def to_x12(truncate = true)
              x12 = @value.ljust(definition.min_length, " ")
              truncate ? x12.take(definition.max_length) : x12
            end

            # @return [String]
            # :nocov:
            def inspect
              id = definition.bind do |d|
                "[#{"% 5s" % d.id}: #{d.name}]".bind do |s|
                  if usage.forbidden?
                    ansi.forbidden(s)
                  elsif usage.required?
                    ansi.required(s)
                  else
                    ansi.optional(s)
                  end
                end
              end

              ansi.element("AN.value#{id}") + "(#{@value})"
            end
            # :nocov:

            # (see AN.stpftime)
            def to_date(format)
              AN.strptime(format, @value)
            end
          end
        end

        class << StringVal
          # @group Constructors
          ###################################################################

          # @return [StringVal]
          def empty(usage, position)
            self::Empty.new(usage, position)
          end

          # @return [StringVal]
          def value(object, usage, position)
            if object.is_a?(StringVal)
              object#.copy(:usage => usage, :position => position)
            elsif object.blank?
              self::Empty.new(usage, position)
            elsif object.kind_of?(Date) or object.kind_of?(Time)
              self::Invalid.new(object, usage, position)
            else
              # STRINGPTR: to_s + rstrip + new
              self::NonEmpty.new(object.to_s.rstrip, usage, position)
            end
          rescue
            self::Invalid.new(object, usage, position)
          end

          # Because this constructor is only called by a programmer (and not
          # when the parser is reading a file), we will throw an exception
          # rather than quietly returning an {StringVal::Invalid}.
          #
          # @return [StringVal]
          # def from_date(format, value, usage, position)
          #   self::NonEmpty.new(AN.strftime(format, value), usage, position)
          # end

          # @endgroup
          ###################################################################
        end

        # Prevent direct instantiation of abstract class StringVal
        StringVal.eigenclass.send(:protected, :new)
        StringVal::Empty.eigenclass.send(:public, :new)
        StringVal::Invalid.eigenclass.send(:public, :new)
        StringVal::NonEmpty.eigenclass.send(:public, :new)
      end
    end
  end
end
