module Stupidedi
  module Builder

    class BuilderDsl

      def initialize(config)
        @machine = StateMachine.build(config)
        @reader  = DslReader.new(Reader::Separators.empty,
                                 Reader::SegmentDict.empty)
      end

      # @return [Array<InstructionTable>]
      def successors
        @machine.states.inject([]) do |list, s|
          list << s.instructions
        end
      end

      #########################################################################
      # @group Element Constructors

      # Generates a repeated element (simple or composite)
      def repeated(*elements)
        :repeated.cons(elements.cons)
      end

      # Generates a composite element
      def composite(*components)
        :composite.cons(components.cons)
      end

      # Generates a blank element
      def blank
        nil
      end

      # @endgroup
      #########################################################################

      #########################################################################
      # @group Element Placeholders

      # @see Schema::ElementReq#forbidden?
      def notused
        @__notused ||= :notused.cons
      end

      # @see Schema::SimpleElementUse#allowed_values
      def default
        @__default ||= :default.cons
      end

      # @endgroup
      #########################################################################

      # @return [void]
      def pretty_print(q)
        q.pp @machine
      end

      # @return [BuilderDsl]
      def segment!(name, *args)
        @reader = @machine.input!(segment_tok(name, args), @reader)

        if @machine.stuck?
          raise Exceptions::ParseError,
            "Segment #{name} cannot occur here"
        end

        return self
      end

    private

      def method_missing(name, *args)
        if name.to_s.upcase =~ /^[A-Z][A-Z0-9]{1,2}$/
          segment!(name, *args)
        else
          super
        end
      end

      #########################################################################
      # @group TokenVal Constructors

      # @return [Reader::SegmentTok]
      def segment_tok(id, elements)
        element_toks = []

        unless @reader.segment_dict.defined_at?(id)
          element_idx  = "00"
          elements.each do |e_tag, e_val|
            element_idx.succ!

            unless e_val.nil?
              raise Exceptions::ParseError,
                "#{id}#{element_idx} is a simple element"
            end

            element_toks << simple_tok(e_tag, nil)
          end
        else
          segment_def  = @reader.segment_dict.at(id)
          element_uses = segment_def.element_uses

          if elements.length > element_uses.length
            raise Exceptions::ParseError,
              "wrong number of arguments (#{elements.length} for 1..#{element_uses.length})"
          end

          element_idx  = "00"
          element_uses.zip(elements) do |e_use, (e_tag, e_val)|
            element_idx.succ!

            if e_use.repeatable?
              # repeatable composite or non-composite
              unless e_tag == :repeated or (e_tag.blank? and e_val.blank?)
                raise Exceptions::ParseError,
                  "#{id}#{element_idx} is a repeatable element"
              end

              element_toks << repeated_tok(e_val || [], e_use)
            elsif e_use.composite?
              # non-repeatable composite
              unless e_tag == :composite or (e_tag.blank? and e_val.blank?)
                raise Exceptions::ParseError,
                  "#{id}#{element_idx} is a composite element"
              end

              element_toks << composite_tok(e_val || [], e_use)
            else
              # non-repeatable non-composite
              unless e_val.nil?
                raise Exceptions::ParseError,
                  "#{id}#{element_idx} is a simple element"
              end

              element_toks << simple_tok(e_tag, e_use)
            end
          end
        end

        Reader::SegmentTok.new(id, element_toks, nil, nil)
      end

      # @return [Reader::RepeatedElementTok]
      def repeated_tok(elements, element_use)
        element_toks = []

        if element_use.composite?
          elements.each do |e_tag, e_val|
            unless e_tag == :composite or (e_tag.blank? and e_val.blank?)
              raise Exceptions::ParseError,
                "@todo is a composite element"
            end

            element_toks << composite_tok(e_val || [], element_use)
          end
        else
          elements.each do |e_tag, e_val|
            unless e_val.nil?
              raise Exceptions::ParseError,
                "@todo is a simple element"
            end

            element_toks << simple_tok(e_tag, element_use)
          end
        end

        Reader::RepeatedElementTok.build(element_toks)
      end

      # @return [Reader::CompositeElementTok]
      def composite_tok(components, composite_use)
        component_uses = composite_use.definition.component_uses

        if components.length > component_uses.length
          raise Exceptions::ParseError,
            "wrong number of arguments (#{components.length} for 1..#{component_uses.length})"
        end

        component_idx  = "0"
        component_toks = []
        component_uses.zip(components) do |c_use, (c_tag, c_val)|
          component_idx.succ!

          unless c_val.nil?
            raise Exceptions::ParseError,
              "@todo is a component element"
          end

          component_toks << component_tok(c_tag, c_use)
        end

        Reader::CompositeElementTok.build(component_toks, nil, nil)
      end

      # @return [Reader::ComponentElementTok]
      def component_tok(value, composite_use)
        Reader::ComponentElementTok.build(value, nil, nil)
      end

      # @return [Reader::SimpleElementTok]
      def simple_tok(value, element_use)
        Reader::SimpleElementTok.build(value, nil, nil)
      end

      # @endgroup
      #########################################################################

      # We can use a much faster implementation provided by the "called_from"
      # gem, but this only compiles against Ruby 1.8. Use this implementation
      # when its available, but fall back to the slow Kernel.caller method if
      # we have to
      if ::Kernel.respond_to?(:called_from)
        def caller(depth = 2)
          ::Kernel.called_from(depth)
        end
      else
        def caller(depth = 2)
          ::Kernel.caller.at(depth)
        end
      end

      private :caller
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
        @element_dict = changes.fetch(:segment_dict, @segment_dict)
        self
      end
    end

  end
end
