# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Versions
    module FunctionalGroups
      module FiftyTen
        module ElementTypes

          #
          # Simple element definition for date elements
          #
          # @see DateVal
          # @see X222.pdf B.1.1.3.1.5 Date
          #
          class DT < SimpleElementDef
            def initialize(id, name, min_length, max_length, description = nil, parent = nil)
              super(id, name, min_length, max_length, description, parent)

              unless min_length == 6 or min_length == 8
                raise ArgumentError,
                  "min_length must be either 6 or 8"
              end

              unless max_length == 6 or max_length == 8
                raise ArgumentError,
                  "max_length must be either 6 or 8"
              end
            end

            def companion
              DateVal
            end
          end

          #
          # @see X222.pdf B.1.1.3.1.5 Date
          #
          class DateVal < Values::SimpleElementVal

            def date?
              true
            end

            def too_long?
              false
            end

            def too_short?
              false
            end

            #
            # Models invalid dates, either with a bad format or a date that
            # does not exist (eg Febuary 30th 2000)
            #
            class Invalid < DateVal

              # @return [Object]
              attr_reader :value

              def initialize(value, usage, position)
                super(usage, position)
                @value = value
              end

              def valid?
                false
              end

              def empty?
                false
              end

              # @return [DateVal]
              def map
                DateVal.value(yield(nil), usage, position)
              end

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

                ansi.element("DT.invalid#{id}") << "(#{ansi.invalid(@value.inspect)})"
              end

              # @return [String]
              def to_s
                ""
              end

              # @return [String]
              def to_x12(truncate = true)
                ""
              end

              def ==(other)
                eql?(other)
              end
            end

            #
            # Empty date value. Shouldn't be directly instantiated -- instead,
            # use the {DateVal.empty} constructor.
            #
            class Empty < DateVal

              def valid?
                true
              end

              def empty?
                true
              end

              # @return [DateVal]
              def map
                DateVal.value(yield(nil), usage, position)
              end

              # @return [String]
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

                ansi.element("DT.empty#{id}")
              end

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
                other.is_a?(Empty) or other.nil?
              end
            end

            #
            # Date with a fully-specified year (with century). Shouldn't be
            # directly instantiated -- instead use the {DateVal.value} constructor
            #
            class Proper < DateVal
              include Comparable

              # (date any* -> any)
              def_delegators :@value, :year, :month, :day, :cwday, :cweek, :downto, :upto,
                :step, :httpdate, :to_s, :to_i, :strftime, :iso8601, :rfc2822,
                :rfc3339, :rfc822, :leap?, :julian?, :gregorian?, :mday, :mon,
                :to_datetime, :to_int, :to_r, :to_c, :wday, :xmlschema, :yday,
                :start
                 
              # (date any* -> DateVal::Proper)
              extend Operators::Wrappers
              wrappers :+, :<<, :>>, :next_day, :next_month, :next_year,
                :prev_day, :prev_month, :prev_year

              # (date -> DateVal::Proper)
              extend Operators::Unary
              unary_operators :next, :succ, :prev

              # (date date -> any)
              extend Operators::Relational
              relational_operators :==, :<=>, :-, :coerce => :to_date

              attr_reader :value

              def initialize(value, usage, position)
                @value = value
                super(usage, position)
              end

              # @return [Proper]
              def copy(changes = {})
                Proper.new \
                  changes.fetch(:value, @value),
                  changes.fetch(:usage, usage),
                  changes.fetch(:position, position)
              end

              def coerce(other)
                # me, he = other.coerce(self)
                # me <OP> he
                return DateVal.value(other, usage, position), self
              end

              def valid?
                true
              end

              def empty?
                false
              end

              def proper?
                true
              end

              # @return [Date]
              def to_date
                @value
              end

              # @return [Time]
              def to_time(hour = nil, minute = nil, second = nil)
                if hour.is_a?(TimeVal) and not hour.empty?
                  hour, minute, second = hour.hour, hour.minute, hour.second
                end

                if not second.nil?
                  Time.utc(year, month, day, hour, minute, second)
                elsif not minute.nil?
                  Time.utc(year, month, day, hour, minute)
                elsif not hour.nil?
                  Time.utc(year, month, day, hour)
                else
                  Time.utc(year, month, day)
                end
              end

              # @return [Proper] self
              def oldest(date)
                self
              end

              # @return [Proper] self
              def newest(date)
                self
              end

              # @return [Proper] self
              def future
                self
              end

              # @return [Proper] self
              def past
                self
              end

              # @return [DateVal]
              def map
                DateVal.value(yield(@value), usage, position)
              end

              # @return [String]
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

                ansi.element("DT.value#{id}") + "(#{"%04d-%02d-%02d" % [year, month, day]})"
              end

              # @return [String]
              def to_x12(truncate = true)
                x12 =
                  if definition.max_length < 8
                    "%02d%02d%02d" % [year % 100, month, day]
                  else
                    "%04d%02d%02d" % [year, month, day]
                  end

                if truncate
                  # Drop the most significant digits... they are probably bogus?
                  overage = x12.length - definition.max_length
                  x12.drop(overage > 0 ? overage : 0)
                else
                  x12
                end
              end

              def too_long?
                if definition.max_length < 8
                  definition.max_length - 2 < year.to_s.length
                else
                  definition.max_length - 4 < year.to_s.length
                end
              end
            end

            #
            # Date with a partially-specified year (two digits, missing century).
            # Shouldn't be directly instantiated -- instead, use the constuctor
            # method {DateVal.value}
            #
            class Improper < DateVal

              # @return [Integer]
              attr_reader :year

              # @return [Integer]
              attr_reader :month

              # @return [Integer]
              attr_reader :day

              def initialize(year, month, day, usage, position)
                @year, @month, @day = year, month, day

                # Check that date is reasonably valid
                unless @year.between?(0, 99) and @month.between?(1, 12) and @day.between?(1, 31)
                  raise Exceptions::InvalidElementError,
                    "invalid date year: #{year}, month: #{month}, day: #{day}"
                end

                super(usage, position)
              end

              # @return [Improper]
              def copy(changes = {})
                Improper.new \
                  changes.fetch(:year, @year),
                  changes.fetch(:month, @month),
                  changes.fetch(:day, @day),
                  changes.fetch(:usage, usage),
                  changes.fetch(:position, position)
              end

              def valid?
                true
              end

              def empty?
                false
              end

              def proper?
                false
              end

              # Create a proper date using the given century `cc`
              #
              # @example
              #   DateVal.value("501015").century(19) #=> DateVal.value("19501230")
              #
              # @return [Proper]
              def century(cc)
                date = ::Date.civil(100 * cc + @year, @month, @day)
                Proper.new(date, usage, position)
              end

              # Create a proper date which cannot be older than the given `date`
              # and cannot be newer than one year after the given `date`.
              #
              # @example
              #   DateVal.value("501015").oldest(Date.civil(1950, 10, 20)) #=> DateVal.value("20501015")
              #   DateVal.value("501015").oldest(Date.civil(1950, 10, 15)) #=> DateVal.value("19501015")
              #   DateVal.value("501015").oldest(Date.civil(1950, 10, 10)) #=> DateVal.value("19501015")
              #
              # @return [Proper]
              def oldest(date)
                cc, yy = date.year.divmod(100)

                if @year < yy
                  century(cc + 1)
                elsif @year > yy
                  century(cc)
                else
                  if @month < date.month
                    century(cc + 1)
                  elsif @month > date.month
                    century(cc)
                  else
                    if @day < date.day
                      century(cc + 1)
                    else
                      century(cc)
                    end
                  end
                end
              end

              # Create a proper date which cannot be newer than the given `date`
              # and cannot be older than one year before the given `date`.
              #
              # @example
              #   DateVal.value("501015").newest(Date.civil(1950, 10, 20)) #=> DateVal.value("19501015")
              #   DateVal.value("501015").newest(Date.civil(1950, 10, 15)) #=> DateVal.value("19501015")
              #   DateVal.value("501015").newest(Date.civil(1950, 10, 10)) #=> DateVal.value("18501015")
              #
              # @return [Proper]
              def newest(date)
                cc, yy = date.year.divmod(100)

                if @year < yy
                  century(cc)
                elsif @year > yy
                  century(cc - 1)
                else
                  if @month < date.month
                    century(cc)
                  elsif @month > date.month
                    century(cc - 1)
                  else
                    if @day <= date.day
                      century(cc)
                    else
                      century(cc - 1)
                    end
                  end
                end
              end

              # Create a proper date which cannot be newer than the current date
              #
              # @return [Proper]
              def past
                newest(Date.today)
              end

              # Create a proper date which cannot be older than the current date
              #
              # @return [Proper]
              def future
                oldest(Date.today)
              end

              # @return [String]
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

                ansi.element("DT.value#{id}") + "(XX#{"%02d-%02d-%02d" % [@year, @month, @day]})"
              end

              # @return [String]
              def to_s
                "XX%02d%02d%02d" % [@year, @month, @day]
              end

              # @return [String]
              def to_x12(truncate = true)
                x12 = "%02d%02d%02d" % [@year, @month, @day]
                truncate ? x12.slice(0, definition.max_length) : x12
              end

              def too_short?
                # Less than a 4-digit year means our max length is 7, but in
                # practice the definition min/max lengths are either 6 or 8
                definition.min_length > 6
              end

              def too_long?
                # We know month and day occupy four characters, but year *could*
                # occupy either three or two characters. If the max_length can't
                # accomodate a three-digit year, make sure we don't have one
                definition.max_length < 7 and @year > 99
              end

              # @note Not commutative
              # @return [Boolean]
              def ==(other)
                eql?(other) or
                 (@day   == other.day  and
                  @year  == other.year and
                  @month == other.month)
              end
            end

          end

          class << DateVal
            # @group Constructors
            ###################################################################

            # @return [DateVal::Empty]
            def empty(usage, position)
              self::Empty.new(usage, position)
            end

            # @return [DateVal]
            def value(object, usage, position)
              if object.blank?
                self::Empty.new(usage, position)

              elsif object.is_a?(String) or object.is_a?(StringVal)
                string = object.to_s

                if string.length < 6
                  self::Invalid.new(object, usage, position)
                else
                  day   = string.slice(-2, 2).to_i
                  month = string.slice(-4, 2).to_i
                  year  = string.slice( 0..-5)

                  if year.length < 4
                    self::Improper.new(year.to_i, month, day, usage, position)
                  else
                    date = date(year, month, day)
                    self::Proper.new(date, usage, position)
                  end
                end

              elsif object.respond_to?(:year) and object.respond_to?(:month) and object.respond_to?(:day)
                date = date(object.year, object.month, object.day)
                self::Proper.new(date, usage, position)

              elsif object.is_a?(DateVal::Improper)
                self::Improper.new(object.year, object.month, object.day, usage, position)

              else
                self::Invalid.new(object, usage, position)
              end

            rescue Exceptions::InvalidElementError
              self::Invalid.new(object, usage, position)
            end

            # @endgroup
            ###################################################################

          private

            def date(year, month, day)
              ::Date.civil(year.to_i, month.to_i, day.to_i)
            rescue
              raise Exceptions::InvalidElementError,
                "invalid year(#{year}), month(#{month}), day(#{day})"
            end
          end

          # Prevent direct instantiation of abstract class DateVal
          DateVal.eigenclass.send(:protected, :new)
          DateVal::Empty.eigenclass.send(:public, :new)
          DateVal::Proper.eigenclass.send(:public, :new)
          DateVal::Invalid.eigenclass.send(:public, :new)
          DateVal::Improper.eigenclass.send(:public, :new)

        end
      end
    end
  end
end
