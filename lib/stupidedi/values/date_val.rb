module Stupidedi
  module Values

    class DateVal < SimpleElementVal

      class Empty < DateVal
        def empty?
          true
        end

        def present?
          false
        end

        def inspect
          "DateVal.empty[#{element_def.try(:id)}]"
        end

        def ==(other)
          other.is_a?(self.class)
        end
      end

      #
      # Date with a fully-specified year (with century)
      #
      class Proper < DateVal
        attr_reader :year, :month, :day

        def initialize(year, month, day, element_def = nil)
          # Check that date is valid
          ::Date.civil(year.to_i, month.to_i, day.to_i)

          @year, @month, @day = year, month, day
          super(element_def)
        end

        def inspect
          def_id = element_def.try{|d| "[#{d.id}]" }
          "DateVal.value#{def_id}(#{year}-#{month}-#{day})"
        end

        def empty?
          false
        end

        def present?
          true
        end

        def proper?
          true
        end

        def to_date
          ::Date.civil(year.to_i, month.to_i, day.to_i)
        end

        def to_time(time)
          # TODO
          raise NoMethodError, "Not yet implemented"
        end

        def to_datetime(time)
          # TODO
          raise NoMethodError, "Not yet implemented"
        end

        def ==(other)
          year == other.year and month == other.month and day == other.day
        end
      end

      #
      # Date with a partially-specified year (missing century)
      #
      class Improper < DateVal
        attr_reader :year, :month, :day

        def initialize(year, month, day, element_def = nil)
          # Check that date is valid
          raise ArgumentError unless year.to_i.between?(0, 99)
          raise ArgumentError unless month.to_i.between?(1, 12)
          raise ArgumentError unless day.to_i.between?(1, 31)

          @year, @month, @day = year, month, day
          super(element_def)
        end

        def inspect
          def_id = element_def.try{|d| "[#{d.id}]" }
          "DateVal.value#{def_id}(XX#{year}-#{month}-#{day})"
        end

        def empty?
          false
        end

        def proper?
          false
        end

        # Converts this to a proper date
        def cutoff(yy, century = ::Date.today.year / 100)
          raise ArgumentError, "Y must be between 0 and 99, inclusive but was #{yy}" unless yy.between?(0, 99)

          if year.to_i < yy
            Proper.new("%d%02d" % [century - 1, year], month, day, element_def)
          else
            Proper.new("%d%02d" % [century, year], month, day, element_def)
          end
        end

        # Converts this to a proper date
        def delta(nn, century = ::Date.today.year / 100)
          raise ArgumentError, "N must be between 0 and 99, inclusive but was #{nn}" unless nn.between?(0, 99)
          cutoff((::Date.today.year - nn).modulo(100), century)
        end

        def ==(other)
          year == other.year and month == other.month and day == other.day
        end
      end

    end

    # Constructors
    class << DateVal
      def empty(element_def = nil)
        DateVal::Empty.new(element_def)
      end

      def value(year, month, day, element_def = nil)
        begin
          if year.length == 2
            DateVal::Improper.new(year, month, day, element_def)
          else
            DateVal::Proper.new(year, month, day, element_def)
          end
        rescue ArgumentError
          raise ArgumentError, "Not a valid date year(#{year}) month(#{month}) day(#{day})"
        end
      end

      def from_date(date, element_def = nil)
        # TODO
        raise NoMethodError, "Not yet implemented"
      end

      def from_time(time, element_def = nil)
        # TODO
        raise NoMethodError, "Not yet implemented"
      end

      def from_datetime(datetime, element_def = nil)
        # TODO
        raise NoMethodError, "Not yet implemented"
      end
    end

    # Prevent direct instantiation of abstract class DateVal
    DateVal.eigenclass.send(:protected, :new)
    DateVal::Empty.eigenclass.send(:public, :new)
    DateVal::Proper.eigenclass.send(:public, :new)
    DateVal::Improper.eigenclass.send(:public, :new)

  end
end
