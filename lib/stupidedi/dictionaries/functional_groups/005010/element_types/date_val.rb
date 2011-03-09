module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module ElementTypes

          class DateVal < Values::SimpleElementVal

            #
            # Empty date value. Shouldn't be directly instantiated -- instead,
            # use the {DateVal.empty} constructor.
            #
            class Empty < DateVal
              def empty?
                true
              end

              # @private
              def inspect
                id = definition.try{|d| "[#{'% 5s' % d.id}: #{d.name}]" }
                "DT.empty#{id}"
              end

              # @private
              def ==(other)
                other.is_a?(self.class)
              end
            end

            #
            # Date with a fully-specified year (with century). Shouldn't be
            # directly instantiated -- instead use the {DateVal.value} constructor
            #
            class Proper < DateVal
              attr_reader :year, :month, :day

              def initialize(year, month, day, definition, parent, usage)
                @year, @month, @day = year.to_i, month.to_i, day.to_i

                begin
                  # Check that date is valid
                  ::Date.civil(@year, @month, @day)
                rescue ArgumentError
                  raise ArgumentError,
                    "Invalid date year(#{year}) month(#{month}) day(#{day})"
                end

                super(definition, parent, usage)
              end

              # @return [Proper]
              def copy(changes = {})
                self.class.new \
                  changes.fetch(:year, @year),
                  changes.fetch(:month, @month),
                  changes.fetch(:day, @day),
                  changes.fetch(:definition, definition),
                  changes.fetch(:parent, parent),
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

                Time.utc(@year, @month, @day,
                         *[hour, minute, second].take_until(&:nil?).map(&:to_f))
              end

              # @return [Proper] self
              def cutoff(yy, century = nil)
                self
              end

              # @return [Proper] self
              def delta(nn, century = nil)
                self
              end

              # @private
              def inspect
                id = definition.try{|d| "[#{'% 5s' % d.id}: #{d.name}]" }
                "DT.value#{id}(#{'%02d' % @year}-#{'%02d' % @month}-#{'%02d' % @day})"
              end

              # @private
              # @note Not commutative
              def ==(other)
                @day   == other.day  and
                @year  == other.year and
                @month == other.month
              end
            end

            #
            # Date with a partially-specified year (two digits, missing century).
            # Shouldn't be directly instantiated -- instead, use the constuctor
            # method {DateVal.value}
            #
            class Improper < DateVal
              attr_reader :year, :month, :day

              def initialize(year, month, day, definition, parent, usage)
                @year, @month, @day = year.to_i, month.to_i, day.to_i

                # Check that date is reasonably valid
                unless @year.between?(0, 99) and @month.between?(1, 12) and @day.between?(1, 31)
                  raise ArgumentError,
                    "Invalid date year(#{year}) month(#{month}) day(#{day})"
                end

                super(definition, parent, usage)
              end

              # @return [Improper]
              def copy(changes = {})
                self.class.new \
                  changes.fetch(:year, @year),
                  changes.fetch(:month, @month),
                  changes.fetch(:day, @day),
                  changes.fetch(:definition, definition),
                  changes.fetch(:parent, parent),
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
              # @return [DateVal::Proper]
              def cutoff(yy, century = ::Date.today.year / 100)
                unless yy.between?(0, 99)
                  raise ArgumentError,
                    "Cutoff year must be between 0 and 99 inclusive but was #{yy}"
                end

                if @year < yy
                  century -= 1
                end

                Proper.new(100*century + @year, @month, @day, definition, parent, usage)
              end

              # Converts this to a proper date
              #
              # @return [DateVal::Proper]
              def delta(nn, century = ::Date.today.year / 100)
                unless nn.between?(0, 99)
                  raise ArgumentError,
                    "N must be between 0 and 99, inclusive but was #{nn}"
                end

                cutoff((::Date.today.year - nn).modulo(100), century)
              end

              # @private
              def inspect
                id = definition.try{|d| "[#{'% 5s' % d.id}: #{d.name}]" }
                "DT.value#{id}(XX#{'%02d' % @year}-#{'%02d' % @month}-#{'%02d' % @day})"
              end

              # @private
              # @note Not commutative
              def ==(other)
                @day   == other.day  and
                @year  == other.year and
                @month == other.month
              end
            end

          end

          class << DateVal
            # @group Constructors

            # Create an empty date value
            #
            # @return [DateVal::Empty]
            def empty(definition, parent, usage)
              DateVal::Empty.new(definition, parent, usage)
            end

            # @return [DateVal::Empty,  DateVal::Proper, DateVal::Improper]
            def value(object, definition, parent, usage)
              if object.nil?
                DateVal::Empty.new(definition, parent, usage)

              elsif object.is_a?(String) or object.is_a?(StringVal)
                return DateVal::Empty.new(definition, parent, usage) if object.empty?

                day   = object.to_s.slice(-2, 2)
                month = object.to_s.slice(-4, 2)
                year  = object.to_s.slice( 0..-5)

                if year.length < 4
                  DateVal::Improper.new(year, month, day, definition, parent, usage)
                else
                  DateVal::Proper.new(year, month, day, definition, parent, usage)
                end

              elsif object.is_a?(DateVal::Improper)
                DateVal::Improper.new(object.year, object.month, object.day, definition, parent, usage)

              elsif object.is_a?(DateVal::Empty)
                DateVal::Empty.new(definition, parent, usage)

              elsif object.respond_to?(:year) and object.respond_to?(:month) and object.respond_to?(:day)
                DateVal::Proper.new(object.year, object.month, object.day, definition, parent, usage)

              else
                raise ArgumentError, "Cannot convert #{object.class} to DateVal"
              end
            end

            # @endgroup
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
