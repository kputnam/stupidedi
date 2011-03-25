module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module ElementTypes

          #
          # @see X222.pdf B.1.1.3.1.6 Time
          #
          class TimeVal < Values::SimpleElementVal

            #
            # Empty time value. Shouldn't be directly instantiated -- instead,
            # use the {TimeVal.empty} constructor.
            #
            class Empty < TimeVal
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

                ansi.element("TM.empty#{id}")
              end

              # @return [Boolean]
              def ==(other)
                other.is_a?(Empty)
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

              def initialize(hour, minute, second, usage)
                @hour, @minute, @second = hour, minute, second

                valid   = (  hour.nil? or hour.between?(0, 24))
                valid &&= (minute.nil? or not hour.nil?)
                valid &&= (minute.nil? or minute.between?(0, 60))
                valid &&= (second.nil? or not minute.nil?)
                valid &&= (second.nil? or second.between?(0, 60))

                unless valid
                  raise ArgumentError, "Invalid time #{inspect}"
                end

                super(usage)
              end

              # @return [NonEmpty]
              def copy(changes = {})
                NonEmpty.new \
                  changes.fetch(:hour, @hour),
                  changes.fetch(:minute, @minute),
                  changes.fetch(:second, @second),
                  changes.fetch(:usage, usage)
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

                hh =   @hour.try{|h| '%02d' % h } || 'hh'
                mm = @minute.try{|m| '%02d' % m } || 'mm'
                ss = @second.try(:to_s) || 'ss'

                ansi.element("TM.value#{id}") << "(#{hh}:#{mm}:#{ss})"
              end

              # @return [Boolean]
              def ==(other)
                eql?(other) or
                 (other.hour   == @hour   and
                  other.minute == @minute and
                  other.second == @second)
              end
            end

          end

          class << TimeVal
            # @group Constructor Methods
            ###################################################################

            # Creates an empty time value.
            def empty(usage)
              TimeVal::Empty.new(usage)
            end

            # @return [TimeVal::NonEmpty, TimeVal::Empty]
            def value(object, usage)
              if object.blank?
                TimeVal::Empty.new(usage)

              elsif object.is_a?(String) or object.is_a?(StringVal)
                hour   = object.to_s.slice(0, 2).to_i
                minute = object.to_s.slice(2, 2).try{|mm| mm.to_i unless mm.blank? }
                second = object.to_s.slice(4, 2).try{|ss| ss.to_i unless ss.blank? }

                if decimal = object.to_s.slice(6..-1)
                  second += "0.#{decimal}".to_f
                end

                TimeVal::NonEmpty.new(hour, minute, second, usage)

              elsif object.is_a?(Time)
                TimeVal::NonEmpty.new(object.hour, object.min,
                                      object.sec + (object.usec / 1000000.0),
                                      usage)

              elsif object.is_a?(DateTime)
                TimeVal::NonEmpty.new(object.hour, object.min,
                                      object.sec + object.sec_fraction.to_f,
                                      usage)
              else
                raise TypeError, "Cannot convert #{object.class} to #{self}"
              end
            end

            # @endgroup
            ###################################################################
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
