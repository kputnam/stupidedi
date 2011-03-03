module Stupidedi
  module Builder

    class InterchangeBuilder
      # @return [Array<FunctionalGroupVal>]
      attr_reader :functional_group_vals

      def initialize(position, interchange_val, functional_group_vals, parent)
        @position, @interchange_val, @functional_group_vals, @parent =
          position, interchange_val, functional_group_vals, parent
      end

      def copy(changes = {})
        self.class.new \
          changes.fetch(:position, @position),
          changes.fetch(:interchange_val, @interchange_val),
          changes.fetch(:functional_group_vals, @functional_group_vals),
          changes.fetch(:parent, @parent)
      end

      def append(functional_group_val)
        copy(:functional_group_vals => functional_group_val.scon(@functional_group_vals))
      end

      def router
        @parent.router
      end

      def segment(name, *elements)
        case name
        when :GS
          # GS08 Version / Release / Industry Identifier Code
          version = elements.at(7)
          envelope_def = @router.functional_groups.lookup(version)

          unless envelope_def
            fail "Unrecognized functional group version #{version.inspect}"
          end

          segment_def = envelope_def.header_segment_uses.head.definition
          segment_val = construct(segment_def, element)
          functional_group_val = envelope_def.value(segment_val.cons, [], [])

          branch FunctionalGroupBuilder.start(functional_group_val, functional_group_val)
        else
          d = @interchange_val.definition

          states = d.header_segment_uses.inject([]) do |list, u|
            if @position <= u.position and name == u.definition.id
              interchange_val = @interchange_val.append_header(construct(u, elements))

              states.push(copy(:position => u.position,
                               :interchange_val => interchange_val)
            else
              states
            end
          end

          states = d.trailer_segment_uses.inject(states) do |list, u|
            if @position <= u.position and name == u.definition.id
              interchange_val = @interchange_val.append_trailer(construct(u, elements))

              states.push(copy(:position => u.position,
                               :interchange_val => interchange_val))
            else
              states
            end
          end

          branch states
        end
      end
    end

    class << InterchangeBuilder
      def start(interchange_val, parent)
        position = interchange_val.definition.header_segment_uses.head.position

        new(position, interchange_val, [], parent)
      end
    end

  end
end
