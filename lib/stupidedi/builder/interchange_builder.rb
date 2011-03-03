module Stupidedi
  module Builder

    class InterchangeBuilder < AbstractState

      # @return [InterchangeVal]
      attr_reader :value

      # @return [TransmissionBuilder]
      attr_reader :predecessor

      def initialize(position, interchange_val, predecessor)
        @position, @value, @predecessor =
          position, interchange_val, predecessor
      end

      def copy(changes = {})
        self.class.new \
          changes.fetch(:position, @position),
          changes.fetch(:value, @value),
          changes.fetch(:predecessor, @predecessor)
      end

      def merge(functional_group_val)
        copy(:value => @value.append_functional_group(functional_group_val))
      end

      def stuck?
        false
      end

      def segment(name, elements)
        case name
        when :GS
          # GS08 Version / Release / Industry Identifier Code
          version = elements.at(7).to_s.slice(0, 6)
          envelope_def = router.functional_group.lookup(version)

          if envelope_def
            # Construct a GS segment
            segment_use = envelope_def.header_segment_uses.head
            segment_val = construct(segment_use, elements)

            # Construct a FunctionalGroupVal containing the GS segment
            functional_group_val = envelope_def.value(segment_val.cons, [], [], @value)

            step(FunctionalGroupBuilder.start(functional_group_val, self))
          else
            failure("Unrecognized functional group version #{version.inspect}")
          end
        else
          d = @value.definition

          # @todo
          # We add one to the position to ensure if we read the start segment
          # again, it always creates a new InterchangeVal. Otherwise, the left
          # recursion would force branching -- one with the start segment in a
          # new InterchangeVal, the other with the segment repeated in the same
          # InterchangeVal.
          states = d.header_segment_uses.tail.inject([]) do |list, u|
            if @position <= u.position and name == u.definition.id
              value = @value.append_header_segment(construct(u, elements))
              list.push(copy(:position => u.position, :value => value))
            else
              list
            end
          end

          states = d.trailer_segment_uses.inject(states) do |list, u|
            if @position <= u.position and name == u.definition.id
              value = @value.append_trailer_segment(construct(u, elements))
              list.push(copy(:position => u.position, :value => value))
            else
              list
            end
          end

          states.concat(@predecessor.merge(@value).segment(name, elements))

          branches(states)
        end
      end

      # @private
      def pretty_print(q)
        q.text("InterchangeBuilder[@#{@position}]")
        q.group(2, "(", ")") do
          q.breakable ""
          q.pp @value
        end
      end
    end

    class << InterchangeBuilder
      def start(interchange_val, predecessor)
        position = interchange_val.definition.header_segment_uses.head.position
        new(position, interchange_val, predecessor)
      end
    end

  end
end
