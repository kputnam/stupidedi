module Stupidedi
  module Values

    class DateVal < SimpleElementVal

      #
      # Empty date value. Shouldn't be directly instantiated -- instead,
      # use the {DateVal.empty} and {DateVal.value} constructors.
      #
      class Empty < DateVal
        def empty?
          true
        end

        # @private
        def inspect
          "DateVal.empty[#{element_def.try(:id)}]"
        end

        # @private
        def ==(other)
          other.is_a?(self.class)
        end
      end

      #
      # Date with a fully-specified year (with century). Shouldn't be
      # directly instantiated -- instead use the {DateVal.value},
      # {DateVal.from_date} and {DateVal.from_time constructors}.
      #
      class Proper < DateVal
        attr_reader :year, :month, :day

        def initialize(year, month, day, element_def = nil)
          # Check that date is valid
          ::Date.civil(year.to_i, month.to_i, day.to_i)

          @year, @month, @day = year, month, day
          super(element_def)
        end

        def empty?
          false
        end

        def proper?
          true
        end

        # @return [Date]
        def to_date
          Date.civil(@year.to_i, @month.to_i, @day.to_i)
        end

        # @private
        def inspect
          def_id = element_def.try{|d| "[#{d.id}]" }
          "DateVal.value#{def_id}(#{@year}-#{@month}-#{@day})"
        end

        # @private
        def ==(other)
          @year == other.year and @month == other.month and @day == other.day
        end
      end

      #
      # Date with a partially-specified year (two digits, missing century).
      # Shouldn't be directly instantiated -- instead, use the {DateVal.value}
      # constructor.
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
              "Y must be between 0 and 99, inclusive but was #{yy}"
          end

          if @year.to_i < yy
            Proper.new("%d%02d" % [century - 1, @year], @month, @day, element_def)
          else
            Proper.new("%d%02d" % [century, @year], @month, @day, element_def)
          end
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
          def_id = element_def.try{|d| "[#{d.id}]" }
          "DateVal.value#{def_id}(XX#{@year}-#{@month}-#{@day})"
        end

        # @private
        def ==(other)
          @year == other.year and @month == other.month and @day == other.day
        end
      end

    end

    #
    # Constructors
    #
    class << DateVal
      # Create an empty date value
      #
      # @return [DateVal::Empty]
      def empty(element_def = nil)
        DateVal::Empty.new(element_def)
      end

      # Intended for use by ElementReader.
      #
      # @return [DateVal::Empty]
      # @return [DateVal::Proper]
      # @return [DateVal::Improper]
      def value(year, month, day, element_def = nil)
        if year !~ /\S/ and month !~ /\S/ and day !~ /\S/
          return DateVal::Empty.new(element_def)
        end

        begin
          if year.length == 2
            DateVal::Improper.new(year, month, day, element_def)
          else
            DateVal::Proper.new(year, month, day, element_def)
          end
        rescue ArgumentError
          raise ArgumentError,
            "Not a valid date year(#{year}) month(#{month}) day(#{day})"
        end
      end

      # Convert a ruby Date value.
      #
      # @return [DateVal::Proper]
      def from_date(date, element_def = nil)
        DateVal::Proper.new("%04d" % date.year,
                            "%02d" % date.month,
                            "%02d" % date.day,
                            element_def)
      end

      # Convert a ruby Time value.
      #
      # @return [DateVal::Proper]
      def from_time(time, element_def = nil)
        DateVal::Proper.new("%04d" % time.year,
                            "%02d" % time.month,
                            "%02d" % time.day,
                            element_def)
      end

      # Convert a ruby DateTime value.
      #
      # @return [DateVal::Proper]
      def from_datetime(dt, element_def = nil)
        DateVal::Proper.new("%04d" % dt.year,
                            "%02d" % dt.month,
                            "%02d" % dt.day,
                            element_def)
      end
    end

    # Prevent direct instantiation of abstract class DateVal
    DateVal.eigenclass.send(:protected, :new)
    DateVal::Empty.eigenclass.send(:public, :new)
    DateVal::Proper.eigenclass.send(:public, :new)
    DateVal::Improper.eigenclass.send(:public, :new)

  end
end
