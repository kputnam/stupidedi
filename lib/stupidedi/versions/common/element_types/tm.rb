# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Versions
    module Common
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

            # @return [TimeVal]
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

              ansi.element("TM.invalid#{id}") + "(#{ansi.invalid(@value.inspect)})"
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

            def copy(changes = {})
              self
            end
          end

          class Valid < TimeVal
            def valid?
              true
            end

            # @return [TimeVal]
            def map
              TimeVal.value(yield(value), usage, position)
            end

            def copy(changes = {})
              TimeVal.value \
                changes.fetch(:value, value),
                changes.fetch(:usage, usage),
                changes.fetch(:position, position)
            end

            def coerce(other)
              return TimeVal.value(other, usage, position), self
            end

            # @return [Boolean]
            def ==(other)
              other = TimeVal.value(other, usage, position)
              other.valid? and other.value == value
            end
          end

          class Empty < Valid
            def value
              nil
            end

            def empty?
              true
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

              ansi.element("TM.empty#{id}")
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
          end

          class NonEmpty < Valid
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

            def copy(changes = {})
              if [:hour, :minute, :second].any?{|x| changes.include?(x) }
                changes[:value] = [changes.fetch(:hour, @hour),
                                   changes.fetch(:minute, @minute),
                                   changes.fetch(:second, @second)]
              end

              super(changes)
            end

            def value
              [@hour, @minute, @second]
            end

            def empty?
              false
            end

            def too_short?
              to_x12(false).length < definition.min_length
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

              hh =   @hour.try{|h| "%02d" % h }  || "hh"
              mm = @minute.try{|m| "%02d" % m }  || "mm"
              ss = @second.try{|s| s.to_s("F") } || "ss"
              ss = ss.gsub(/^0*\.|\.0*$/, "")

              ansi.element("TM.value#{id}") + "(#{hh}:#{mm}:#{ss})"
            end
            # :nocov:

            # @return [String]
            def to_s(hh = "hh", mm = "mm", ss = "ss")
              hh =   @hour.try{|h| "%02d" % h } || hh
              mm = @minute.try{|m| "%02d" % m } || mm
              ss = @second.try{|s| "%02f" % s } || ss
              "#{hh}:#{mm}:#{ss}".gsub(/\.?0*$|:$/, "")
            end

            # @return [String]
            def to_x12(truncate = true)
              hh =   @hour.try{|h| "%02d" % h }
              mm = @minute.try{|m| "%02d" % m }
              ss = @second.try{|s| "%02d" % s }
              ff = @second.try{|s| s.frac.to_s("F").gsub(/^0*\.|0+$/, "") }

              x12 = "#{hh}#{mm}#{ss}#{ff}"

              truncate ? x12.take(definition.max_length) : x12
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
            if object.is_a?(TimeVal)
              object#.copy(:usage => usage, :position => position)
            elsif object.blank?
              self::Empty.new(usage, position)
            elsif object.is_a?(String) or object.is_a?(StringVal)
              return self::Invalid.new(object, usage, position) \
                unless object =~ /^\d{4,}$/

              hour   = object.to_s.slice(0, 2).to_i
              minute = object.to_s.slice(2, 2).try{|mm| mm.to_i unless mm.blank? }
              second = object.to_s.slice(4, 2).try{|ss| ss.to_d unless ss.blank? }

              if decimal = object.to_s.slice(6..-1)
                decimal = 0 if decimal.empty?
                second += "0.#{decimal}".to_d
              end

              self::NonEmpty.new(hour, minute, second, usage, position)
            elsif object.respond_to?(:hour) and
                  object.respond_to?(:min)  and
                  object.respond_to?(:sec)
              sec = object.sec.to_d

              if object.respond_to?(:usec)
                sec += object.usec.to_d / 1000000
              elsif object.respond_to?(:sec_fraction)
                sec += object.sec_fraction.to_d
              end

              self::NonEmpty.new(object.hour, object.min, sec, usage, position)
            elsif object.respond_to?(:hour)    and
                  object.respond_to?(:minute)  and
                  object.respond_to?(:second)
              self::NonEmpty.new(object.hour, object.minute, object.second.to_d, usage, position)
            elsif object.is_a?(Array) and object.length == 3
              self::NonEmpty.new(*object, usage, position)
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
