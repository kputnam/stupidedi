module Stupidedi
  module Builder

    class BuilderDsl # < (RUBY_VERSION <= "1.9") ? BlankSlate : BasicObject

      def initialize(config)
        @machine = StateMachine.build(config)
        @reader  = DslReader.new(Reader::Separators.empty,
                                 Reader::SegmentDict.empty)
      end

      def repeated(*values)
        :repeated.cons(element_toks.cons)
      end

      def composite(*element_toks)
        :composite.cons(element_toks.cons)
      end

    private

      # @return [Reader::SegmentTok]
      def segment_tok(id, elements)
        element_toks = []

        unless @reader.segment_dict.defined_at?(id)
          element_idx  = "00"
          elements.each do |e_tag, e_val|
            element_idx.succ!

            unless e_val.nil?
              raise ArgumentError,
                "#{id}#{element_idx} is a simple element"
            end

            element_toks << simple_tok(e_tag, nil)
          end
        else
          segment_def  = @reader.segment_dict.at(id)
          element_uses = segment_def.element_uses

          if elements.length > element_uses.length
            raise ArgumentError,
              "wrong number of arguments (#{elements.length} for 1..#{element_uses.length})"
          end

          element_idx  = "00"
          element_uses.zip(elements) do |e_use, (e_tag, e_val)|
            element_idx.succ!

            if e_use.repeatable?
              # repeatable composite or non-composite
              unless e_tag == :repeated or (e_tag.blank? and e_val.blank?)
                raise ArgumentError,
                  "#{id}#{element_idx} is a repeatable element"
              end

              element_toks << repeated_tok(e_val || [], e_use)
            elsif e_use.composite?
              # non-repeatable composite
              unless e_tag == :composite or (e_tag.blank? and e_val.blank?)
                raise ArgumentError,
                  "#{id}#{element_idx} is a composite element"
              end

              element_toks << composite_tok(e_val || [], e_use)
            else
              # non-repeatable non-composite
              unless e_val.nil?
                raise ArgumentError,
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
              raise "@todo is a composite element"
            end

            element_toks << composite_tok(e_val || [], element_use)
          end
        else
          elements.each do |e_tag, e_val|
            unless e_val.nil?
              raise "@todo is a simple element"
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
          raise ArgumentError,
            "wrong number of arguments (#{components.length} for 1..#{component_uses.length})"
        end

        component_idx  = "0"
        component_toks = []
        component_uses.zip(components) do |c_use, (c_tag, c_val)|
          component_idx.succ!

          unless c_val.nil?
            raise ArgumentError,
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

      def method_missing(name, *args)
        @reader = @machine.input!(segment_tok(name, args), @reader)

        if @machine.stuck?
          # ...
        end

        return self
      end

      if Kernel.respond_to?(:called_from)
        def caller(depth = 2)
          Kernel.called_from(depth)
        end
      else
        def caller(depth = 2)
          Kernel.caller.at(depth)
        end
      end

    end

    class DslReader

      # @return [Reader::Separators]
      attr_reader :separators

      # @return [Reader::SegmentDict]
      attr_reader :segment_dict

      def initialize(separators, segment_dict)
        @separators, @segment_dict = separators, segment_dict
      end

      def copy(changes = {})
        DslReader.new \
          changes.fetch(:separators, @separators),
          changes.fetch(:segment_dict, @segment_dict)
      end
    end

  end
end
