module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module ElementTypes

          #
          # @see X222.pdf B.1.1.3.1.5 Date
          #
          class DateVal < Values::SimpleElementVal

            #
            # Empty date value. Shouldn't be directly instantiated -- instead,
            # use the {DateVal.empty} constructor.
            #
            class Empty < DateVal
              def empty?
                true
              end

              # @return [String]
              def inspect
                id = definition.bind do |d|
                  "[#{'% 5s' % d.id}: #{d.name}]".bind do |s|
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

              # @return [Boolean]
              def ==(other)
                other.is_a?(Empty)
              end
            end

            #
            # Date with a fully-specified year (with century). Shouldn't be
            # directly instantiated -- instead use the {DateVal.value} constructor
            #
            class Proper < DateVal

              # @return [Integer]
              attr_reader :year

              # @return [Integer]
              attr_reader :month

              # @return [Integer]
              attr_reader :day

              def initialize(year, month, day, usage)
                @year, @month, @day = year, month, day

                begin
                  # Check that date is valid
                  ::Date.civil(@year, @month, @day)
                rescue ArgumentError
                  raise ArgumentError,
                    "Invalid date year(#{year}) month(#{month}) day(#{day})"
                end

                super(usage)
              end

              # @return [Proper]
              def copy(changes = {})
                Proper.new \
                  changes.fetch(:year, @year),
                  changes.fetch(:month, @month),
                  changes.fetch(:day, @day),
                  changes.fetch(:usage, usage)
              end

              def empty?
                false
              end

              def proper?
                true
              end

              # @return [Date]
              def to_date
                Date.civil(@year, @month, @day)
              end

              # @return [Time]
              def to_time(hour = nil, minute = nil, second = nil)
                if hour.is_a?(TimeVal) and not hour.empty?
                  hour, minute, second = hour.hour, hour.minute, hour.second
                end

                if not second.nil?
                  Time.utc(@year, @month, @day, hour, minute, second)
                elsif not minute.nil?
                  Time.utc(@year, @month, @day, hour, minute)
                elsif not hour.nil?
                  Time.utc(@year, @month, @day, hour)
                else
                  Time.utc(@year, @month, @day)
                end
              end

              # @return [Proper] self
              def cutoff(yy, century = nil)
                self
              end

              # @return [Proper] self
              def delta(nn, century = nil)
                self
              end

              # @return [String]
              def inspect
                id = definition.bind do |d|
                  "[#{'% 5s' % d.id}: #{d.name}]".bind do |s|
                    if usage.forbidden?
                      ansi.forbidden(s)
                    elsif usage.required?
                      ansi.required(s)
                    else
                      ansi.optional(s)
                    end
                  end
                end

                ansi.element("DT.value#{id}") << "(#{'%02d' % @year}-#{'%02d' % @month}-#{'%02d' % @day})"
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

              def initialize(year, month, day, usage)
                @year, @month, @day = year, month, day

                # Check that date is reasonably valid
                unless @year.between?(0, 99) and @month.between?(1, 12) and @day.between?(1, 31)
                  raise ArgumentError,
                    "Invalid date year(#{year}) month(#{month}) day(#{day})"
                end

                super(usage)
              end

              # @return [Improper]
              def copy(changes = {})
                Improper.new \
                  changes.fetch(:year, @year),
                  changes.fetch(:month, @month),
                  changes.fetch(:day, @day),
                  changes.fetch(:usage, usage)
              end

              def empty?
                false
              end

              def proper?
                false
              end

              # Converts this to a proper date
              #
              # @return [Proper]
              def cutoff(yy, century = ::Date.today.year / 100)
                unless yy.between?(0, 99)
                  raise ArgumentError,
                    "Cutoff year must be between 0 and 99 inclusive but was #{yy}"
                end

                if @year < yy
                  century -= 1
                end

                Proper.new(100*century + @year, @month, @day, usage)
              end

              # Converts this to a proper date
              #
              # @return [Proper]
              def delta(nn, century = ::Date.today.year / 100)
                unless nn.between?(0, 99)
                  raise ArgumentError,
                    "N must be between 0 and 99, inclusive but was #{nn}"
                end

                cutoff((::Date.today.year - nn).modulo(100), century)
              end

              # @return [String]
              def inspect
                id = definition.bind do |d|
                  "[#{'% 5s' % d.id}: #{d.name}]".bind do |s|
                    if usage.forbidden?
                      ansi.forbidden(s)
                    elsif usage.required?
                      ansi.required(s)
                    else
                      ansi.optional(s)
                    end
                  end
                end

                ansi.element("DT.value#{id}") << "(XX#{'%02d' % @year}-#{'%02d' % @month}-#{'%02d' % @day})"
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
            # @group Constructor Methods
            ###################################################################

            # @return [DateVal::Empty]
            def empty(usage)
              DateVal::Empty.new(usage)
            end

            # @return [DateVal::Empty, DateVal::Proper, DateVal::Improper]
            def value(object, usage)
              if object.blank?
                DateVal::Empty.new(usage)

              elsif object.is_a?(String) or object.is_a?(StringVal)
                day   = object.to_s.slice(-2, 2).to_i
                month = object.to_s.slice(-4, 2).to_i
                year  = object.to_s.slice( 0..-5)

                if year.length < 4
                  DateVal::Improper.new(year.to_i, month, day, usage)
                else
                  DateVal::Proper.new(year.to_i, month, day, usage)
                end

              elsif object.respond_to?(:year) and object.respond_to?(:month) and object.respond_to?(:day)
                DateVal::Proper.new(object.year, object.month, object.day, usage)

              elsif object.is_a?(DateVal::Improper)
                DateVal::Improper.new(object.year, object.month, object.day, usage)

              else
                raise ArgumentError, "Cannot convert #{object.class} to DateVal"
              end
            end

            # @endgroup
            ###################################################################
          end

          # Prevent direct instantiation of abstract class DateVal
          DateVal.eigenclass.send(:protected, :new)
          DateVal::Empty.eigenclass.send(:public, :new)
          DateVal::Proper.eigenclass.send(:public, :new)
          DateVal::Improper.eigenclass.send(:public, :new)

        end
      end
    end
  end
end
