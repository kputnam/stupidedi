module Stupidedi
  module Builder

    class BuilderDsl
      include Inspect
      include Tokenization

      # @private
      SEGMENT_ID = /^[A-Z][A-Z0-9]{1,2}$/

      # @return [StateMachine]
      attr_reader :machine

      # @return [Boolean]
      attr_writer :strict

      delegate :pretty_print, :to => :@machine

      def initialize(machine, strict = true)
        @machine = machine
        @strict  = strict
        @reader  = DslReader.new(Reader::Separators.empty,
                                 Reader::SegmentDict.empty)
      end

      def strict?
        @strict
      end

      # (see Navigation#successors)
      def successors
        @machine.successors
      end

      # (see Navigation#zipper)
      def zipper
        @machine.zipper
      end

      # @return [BuilderDsl]
      def segment!(name, position, *elements)
        segment_tok     = mksegment_tok(@reader.segment_dict, name, elements, position)
        machine, reader = @machine.insert(segment_tok, @reader)

        if @strict
          machine.active.each do |m|
            critique(m.node.zipper)
          end
        end

        @machine = machine
        @reader  = reader

        self
      end

    private

      def method_missing(name, *args)
        if SEGMENT_ID =~ name.to_s
          segment!(name, Reader::Position.caller(2), *args)
        else
          super
        end
      end

      # The `zipper` argument should be a _completed_ syntax node, meaning all
      # children have already been added. This is invariably true for segments,
      # because the {StateMachine} does not accept smaller units of syntax.
      def critique(zipper, descriptor = "")
        if zipper.node.simple? or zipper.node.component?
          if zipper.node.invalid?
            raise "invalid #{descriptor}"
          elsif zipper.node.blank?
            if zipper.node.usage.required?
              raise "required #{descriptor} is blank"
            end
          elsif zipper.node.usage.forbidden?
            raise "forbidden #{descriptor} is present"
          elsif zipper.node.usage.allowed_values.exclude?(zipper.node.to_s)
            raise "value #{zipper.node.to_s} not allowed in #{descriptor}"
          elsif zipper.node.too_long?
            raise "value is too long in #{descriptor}"
          elsif zipper.node.too_short?
          # raise "value is too short in #{descriptor}"
          end

        elsif zipper.node.composite?
          if zipper.node.blank?
            if zipper.node.usage.required?
              raise "required #{descriptor} is blank"
            end
          elsif zipper.node.usage.forbidden?
            raise "forbidden #{descriptor} is present"
          else
            if zipper.node.present?
              zipper.children.each_with_index do |z, i|
                critique(z, "#{descriptor}-#{'%02d' % (i + 1)}")
              end

              d = zipper.node.definition
              d.syntax_notes.each do |s|
                raise "for #{descriptor}, #{s.reason(zipper)}" \
                  unless s.satisfied?(zipper)
              end
            end
          end

        elsif zipper.node.repeated?
          zipper.children.each{|z| critique(z) }

        elsif zipper.node.segment?
          descriptor = zipper.node.id

          if zipper.node.invalid?
            raise "invalid segment #{descriptor}"
          else
            zipper.children.each_with_index do |z, i|
              critique(z, "#{descriptor}-#{'%02d' % (i + 1)}")
            end

            d = zipper.node.definition
            d.syntax_notes.each do |s|
              raise "for #{descriptor}, #{s.reason(zipper)}" \
                unless s.satisfied?(zipper)
            end
          end

        elsif zipper.node.loop?
        elsif zipper.node.table?
        elsif zipper.node.transaction_set?
        elsif zipper.node.functional_group?
        elsif zipper.node.interchange?
        elsif zipper.node.transmission?
        end
      end

      # @endgroup
      #########################################################################
    end

    class << BuilderDsl
      # @group Constructors
      #########################################################################

      # @return [BuilderDsl]
      def build(config, strict = true)
        new(StateMachine.build(config), strict)
      end

      # @endgroup
      #########################################################################
    end

    # @private
    class DslReader

      # @return [Reader::Separators]
      attr_reader :separators

      # @return [Reader::SegmentDict]
      attr_reader :segment_dict

      def initialize(separators, segment_dict)
        @separators, @segment_dict = separators, segment_dict
      end

      # @return [DslReader]
      def copy(changes = {})
        @separators   = changes.fetch(:separators, @separators)
        @segment_dict = changes.fetch(:segment_dict, @segment_dict)
        self
      end
    end

  end
end
