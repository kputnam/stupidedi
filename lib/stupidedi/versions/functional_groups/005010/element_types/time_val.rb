# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Versions
    module FunctionalGroups
      module FiftyTen
        module ElementTypes

          class TM < SimpleElementDef
            def initialize(id, name, min_length, max_length, description = nil, parent = nil)
              super(id, name, min_length, max_length, description)

              unless min_length == 2 or min_length == 4 or min_length >= 6
                raise Exceptions::InvalidSchemaError,
                  "min_length must be either 2, 4, 6, or greater"
              end

              unless max_length == 2 or max_length == 4 or max_length >= 6
                raise Exceptions::InvalidSchemaError,
                  "max_length must be either 2, 4, 6, or greater"
              end
            end

            def companion
              TimeVal
            end
          end

          #
          # @see X222.pdf B.1.1.3.1.6 Time
          #
          class TimeVal < Values::SimpleElementVal

            def time?
              true
            end

            def too_short?
              false
            end

            def too_long?
              false
            end

            class Invalid < TimeVal

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

                ansi.element("TM.invalid#{id}") << "(#{ansi.invalid(@value.inspect)})"
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
                eql?(other)
              end
            end

            #
            # Empty time value. Shouldn't be directly instantiated -- instead,
            # use the {TimeVal.empty} constructor.
            #
            class Empty < TimeVal

              def valid?
                true
              end

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
            # Non-empty time value. Unlike common models of time, this
            # encapsulates only an hour, minute, and second (with fractional
            # seconds) but not a date. Shouldn't be directly instantiated --
            # instead, use the {TimeVal.value} constructor.
            #
            class NonEmpty < TimeVal

              # @return [Integer]
              attr_reader :hour

              # @return [Integer]
              attr_reader :minute

              # @return [Integer, BigDecimal]
              attr_reader :second

              def initialize(hour, minute, second, usage, position)
                @hour, @minute, @second = hour, minute, second

                valid   = (  hour.nil? or hour.between?(0, 24))
                valid &&= (minute.nil? or not hour.nil?)
                valid &&= (minute.nil? or minute.between?(0, 60))
                valid &&= (second.nil? or not minute.nil?)
                valid &&= (second.nil? or second.between?(0, 60))

                super(usage, position)

                unless valid
                  raise Exceptions::InvalidElementError,
                    "invalid time #{inspect}"
                end
              end

              # @return [NonEmpty]
              def copy(changes = {})
                NonEmpty.new \
                  changes.fetch(:hour, @hour),
                  changes.fetch(:minute, @minute),
                  changes.fetch(:second, @second),
                  changes.fetch(:usage, usage),
                  changes.fetch(:position, position)
              end

              def valid?
                true
              end

              def empty?
                false
              end

              # @return [Time]
              def to_time(date, minute = nil, second = nil)
                minute = @minute || minute
                second = @second || second

                if not second.nil?
                  Time.utc(date.year, date.month, date.day, @hour, minute, second.to_f)
                elsif not minute.nil?
                  Time.utc(date.year, date.month, date.day, @hour, minute)
                else
                  Time.utc(date.year, date.month, date.day, @hour)
                end
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

                hh =   @hour.try{|h| "%02d" % h }  || "hh"
                mm = @minute.try{|m| "%02d" % m }  || "mm"
                ss = @second.try{|s| s.to_s("F") } || "ss"

                ansi.element("TM.value#{id}") + "(#{hh}:#{mm}:#{ss})"
              end

              # @return [String]
              def to_s(hh = "hh", mm = "mm", ss = "ss")
                hh =   @hour.try{|h| "%02d" % h } || hh
                mm = @minute.try{|m| "%02d" % m } || mm
                ss = @second.try{|s| "%02f" % s } || ss
                "#{hh}#{mm}#{ss}"
              end

              # @return [String]
              def to_x12(truncate = true)
                hh =   @hour.try{|h| "%02d" % h }
                mm = @minute.try{|m| "%02d" % m }
                ss = @second.try{|s| "%02d" % s }
                ff = @second.try do |s|
                  s.frac.to_s("F").
                    gsub(/^0*\./, "").
                    gsub(/0+$/, "")
                end

                x12 = "#{hh}#{mm}#{ss}#{ff}"

                truncate ? x12.take(definition.max_length) : x12
              end

              def too_short?
                to_s(nil, nil, nil).length < definition.min_length
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
            # @group Constructors
            ###################################################################

            # @return [TimeVal]
            def empty(usage, position)
              self::Empty.new(usage, position)
            end

            # @return [TimeVal]
            def value(object, usage, position)
              if object.blank?
                self::Empty.new(usage, position)

              elsif object.is_a?(String) or object.is_a?(StringVal)
                return self::Invalid.new(object, usage, position) \
                  unless object =~ /^\d+$/

                hour   = object.to_s.slice(0, 2).to_i
                minute = object.to_s.slice(2, 2).try{|mm| mm.to_i unless mm.blank? }
                second = object.to_s.slice(4, 2).try{|ss| ss.to_d unless ss.blank? }
                decimal = object.to_s.slice(6..-1).try{|dd| dd.to_d unless dd.blank? }

                if decimal
                  second += "0.#{decimal}".to_d
                end

                self::NonEmpty.new(hour, minute, second, usage, position)

              elsif object.is_a?(Time)
                self::NonEmpty.new(object.hour, object.min,
                                      object.sec.to_d \
                                      + (object.usec.to_d / 1000000),
                                      usage, position)

              elsif object.is_a?(DateTime)
                self::NonEmpty.new(object.hour, object.min,
                                      object.sec.to_d \
                                      + object.sec_fraction.to_d,
                                      usage, position)
              else
                self::Invalid.new(object, usage, position)
              end
            rescue Exceptions::InvalidElementError
              self::Invalid.new(object, usage, position)
            end

            # @endgroup
            ###################################################################
          end

          # Prevent direct instantiation of abstract class TimeVal
          TimeVal.eigenclass.send(:protected, :new)
          TimeVal::Empty.eigenclass.send(:public, :new)
          TimeVal::Invalid.eigenclass.send(:public, :new)
          TimeVal::NonEmpty.eigenclass.send(:public, :new)
        end
      end
    end
  end
end
