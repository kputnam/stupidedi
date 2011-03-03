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

      # @return [InterchangeBuilder]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:position, @position),
          changes.fetch(:value, @value),
          changes.fetch(:predecessor, @predecessor)
      end

      # @return [InterchangeBuilder]
      def merge(functional_group_val)
        copy(:value => @value.append_functional_group(functional_group_val))
      end

      # @return [Array<AbstractState>]
      def segment(name, elements)
        case name
        when :GS
          # @todo: Explain why GS is a special case

          # GS08 Version / Release / Industry Identifier Code
          version = elements.at(7).to_s.slice(0, 6)
          envelope_def = config.functional_group.lookup(version)

          if envelope_def
            # Construct a GS segment
            segment_use = envelope_def.header_segment_uses.head
            segment_val = mksegment(segment_use, elements, @value)

            # Construct a FunctionalGroupVal containing the GS segment
            functional_group_val = envelope_def.value(segment_val.cons, [], [], @value)

            step(FunctionalGroupBuilder.start(functional_group_val, self))
          else
            failure("Unrecognized functional group version #{version.inspect}")
          end
        else
          d = @value.definition

          # @todo: Explain use of #tail
          states = d.header_segment_uses.tail.inject([]) do |list, u|
            if @position <= u.position and match?(u, name, elements)
              value = @value.append_header_segment(mksegment(u, elements))
              list.push(copy(:position => u.position, :value => value))
            else
              list
            end
          end

          states = d.trailer_segment_uses.inject(states) do |list, u|
            if @position <= u.position and match?(u, name, elements)
              value = @value.append_trailer_segment(mksegment(u, elements))
              list.push(copy(:position => u.position, :value => value))
            else
              list
            end
          end

          # Terminate this functional group and try parsing segment as a sibling
          # of @value's parent. Supress any stuck "uncle" states because they
          # won't say anything more than the single stuck state we create below.
          uncles = @predecessor.merge(@value).segment(name, elements)
          states.concat(uncles.reject(&:stuck?))

          if states.empty?
            failure("Unexpected segment #{name}")
          else
            branches(states)
          end
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
      # @return [InterchangeBuilder]
      def start(interchange_val, predecessor)
        position = interchange_val.definition.header_segment_uses.head.position
        new(position, interchange_val, predecessor)
      end
    end

  end
end
