module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module ElementTypes

          class TimeVal < Values::SimpleElementVal

            #
            # Empty time value. Shouldn't be directly instantiated -- instead,
            # use the {TimeVal.empty} constructor.
            #
            class Empty < TimeVal
              def empty?
                true
              end

              # @private
              def inspect
                def_id = definition.try{|d| "[#{d.id}]" }
                "TimeVal.empty#{def_id}"
              end

              # @private
              def ==(other)
                other.is_a?(self.class)
              end
            end

            #
            # Non-empty time value. Unlike common models of time, this
            # encapsulates only an hour, minute, and second (with fractional
            # seconds) but not a date. Shouldn't be directly instantiated --
            # instead, use the {TimeVal.value} constructor.
            #
            class NonEmpty < TimeVal
              attr_reader :hour, :minute, :second

              def initialize(hour, minute, second, definition, parent)
                @hour, @minute, @second = hour, minute, second

                valid   = (  hour.nil? or hour.between?(0, 24))
                valid &&= (minute.nil? or not hour.nil?)
                valid &&= (minute.nil? or minute.between?(0, 60))
                valid &&= (second.nil? or not minute.nil?)
                valid &&= (second.nil? or second.between?(0, 60))

                unless valid
                  raise ArgumentError, "Invalid time #{inspect}"
                end

                super(definition, parent)
              end

              def copy(changes = {})
                self.class.new \
                  changes.fetch(:hour, @hour),
                  changes.fetch(:minute, @minute),
                  changes.fetch(:second, @second),
                  changes.fetch(:definition, definition),
                  changes.fetch(:parent, parent)
              end

              def empty?
                false
              end

              # @return [Time]
              def to_time(date)
                Time.utc(date.year,
                         date.month,
                         date.day,
                         *[@hour, @minute, @second].take_until(&:nil?))
              end

              # @private
              def inspect
                def_id = definition.try{|d| "[#{d.id}]" }
                hh =   @hour.try{|h| '%02d' % h } || 'hh'
                mm = @minute.try{|m| '%02d' % m } || 'mm'
                ss = @second.try(:to_s) || 'ss'
                "TimeVal.value#{def_id}(#{hh}:#{mm}:#{ss})"
              end

              # @private
              def ==(other)
                other.hour   == @hour   and
                other.minute == @minute and
                other.second == @second
              end
            end

          end

          class << TimeVal
            # @group Constructors

            # Creates an empty time value.
            def empty(definition, parent)
              TimeVal::Empty.new(definition, parent)
            end

            # @return [TimeVal::NonEmpty, TimeVal::Empty]
            def value(object, definition, parent)
              if object.nil?
                TimeVal::Empty.new(definition, parent)

              elsif object.is_a?(Time)
                TimeVal::NonEmpty.new(object.hour, object.min, object.sec + (object.usec / 1000000.0),
                                      definition, parent)

              elsif object.is_a?(DateTime)
                TimeVal::NonEmpty.new(object.hour, object.min, object.sec + object.sec_fraction.to_f,
                                      definition, parent)

              elsif object.is_a?(String) or object.is_a?(StringVal)
                if object.blank?
                  TimeVal::Empty.new(definition, parent)
                else
                  hour   = object.to_s.slice(0, 2).to_i
                  minute = object.to_s.slice(2, 2).try{|mm| mm.to_i unless mm.blank? }
                  second = object.to_s.slice(4, 2).try{|ss| ss.to_i unless ss.blank? }

                  if decimal = object.to_s.slice(6..-1)
                    second += "0.#{decimal}".to_f
                  end

                  TimeVal::NonEmpty.new(hour, minute, second, definition, parent)
                end
              else
                raise TypeError, "Cannot convert #{object.class} to #{self}"
              end
            end

            def reader(input, context)
              raise NoMethodError, "@todo"
            end

            # @endgroup
          end

          # Prevent direct instantiation of abstract class TimeVal
          TimeVal.eigenclass.send(:protected, :new)
          TimeVal::Empty.eigenclass.send(:public, :new)
          TimeVal::NonEmpty.eigenclass.send(:public, :new)
        end
      end
    end
  end
end
