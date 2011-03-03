module Stupidedi
  module Builder

    class InterchangeBuilder < AbstractState

      # @return [InterchangeVal]
      attr_reader :interchange_val

      def initialize(position, interchange_val, predecessor)
        @position, @interchange_val, @predecessor =
          position, interchange_val, predecessor
      end

      def stuck?
        false
      end

      def copy(changes = {})
        self.class.new \
          changes.fetch(:position, @position),
          changes.fetch(:interchange_val, @interchange_val),
          changes.fetch(:predecessor, @predecessor)
      end

      def router
        @predecessor.router
      end

      def segment(name, elements)
        case name
        when :GS
          # GS08 Version / Release / Industry Identifier Code
          version = elements.at(7).slice(0, 6)
          envelope_def = router.functional_group.lookup(version)

          if envelope_def
            segment_use = envelope_def.header_segment_uses.head
            segment_val = construct(segment_use, elements)
            functional_group_val = envelope_def.value(segment_val.cons, [], [])

            step(FunctionalGroupBuilder.start(functional_group_val, self))
          else
            failure("Unrecognized functional group version #{version.inspect}")
          end
        else
          d = @interchange_val.definition

          # We add one to the position to ensure if we read the start segment
          # again, it always creates a new InterchangeVal. Otherwise, the left
          # recursion would force branching -- one with the start segment in a
          # new InterchangeVal, the other with the segment repeated in the same
          # InterchangeVal.
          states = d.header_segment_uses.tail.inject([]) do |list, u|
            if @position <= u.position and name == u.definition.id
              interchange_val = @interchange_val.
                append_header(construct(u, elements))

              list.push(copy(:position => u.position,
                             :interchange_val => interchange_val))
            else
              list
            end
          end

          # ... or the InterchangeVal's footer
          states = d.trailer_segment_uses.inject(states) do |list, u|
            if @position <= u.position and name == u.definition.id
              interchange_val = @interchange_val.
                append_trailer(construct(u, elements))

              list.push(copy(:position => u.position,
                             :interchange_val => interchange_val))
            else
              list
            end
          end

          # ... or a new InterchangeVal
          terminated = @predecessor.append(@interchange_val)
          successors = terminated.segment(name, elements)
          states.concat(successors.reject(&:stuck?))

          if states.empty?
            states.push(failure("Unexpected segment #{name}"))
          end

          branches(states)
        end
      end

      # @private
      def pretty_print(q)
        q.text("InterchangeBuilder[@#{@position}]")
        q.group(2, "(", ")") do
          q.breakable ""
          q.pp @interchange_val
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
