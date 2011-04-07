module Stupidedi
  module Builder

    class BuilderDsl
      include Inspect

      # @private
      SEGMENT_ID = /^[A-Z][A-Z0-9]{1,2}$/

      # @return [StateMachine]
      attr_reader :machine

      def initialize(config)
        @machine = StateMachine.build(config)
        @reader  = DslReader.new(Reader::Separators.empty,
                                 Reader::SegmentDict.empty)
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
      def segment!(name, *elements)
        segment_tok       = mksegment_tok(@reader.segment_dict, name, elements)
        @machine, @reader = @machine.input(segment_tok, @reader)

        self
      end

      # @return [void]
      def pretty_print(q)
        q.pp @machine
      end

    private

      def method_missing(name, *args)
        if SEGMENT_ID =~ name.to_s
          segment!(name, *args)
        else
          super
        end
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
