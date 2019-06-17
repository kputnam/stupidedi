# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Parser
    class BuilderDsl
      include Inspect
      include Tokenization

      # @private
      SEGMENT_ID = /^[A-Z][A-Z0-9]{1,2}$/

      # @return [StateMachine]
      attr_reader :machine

      # @return [Boolean]
      attr_writer :strict

      # @return [DslReader]
      attr_reader :reader

      def_delegators :@machine, :pretty_print, :segment, :element, :zipper, :successors, :empty?, :first?, :last?, :deterministic?

      def initialize(machine, strict = true)
        @machine = machine
        @strict  = strict
        @reader  = DslReader.new(Reader::Separators.empty,
                                 Reader::SegmentDict.empty)
      end

      def respond_to_missing?(name, include_private = false)
        SEGMENT_ID.match?(name.to_s) || super
      end

      def strict?
        @strict
      end

      # @return [BuilderDsl]
      def segment!(name, position, *elements)
        segment_tok     = mksegment_tok(@reader.segment_dict, name, elements, position)
        machine, reader = @machine.insert(segment_tok, @strict, @reader)

        if @strict
          unless machine.deterministic?
            matches = machine.active.map do |m|
              segment_def = m.node.zipper.node.definition
              "#{segment_def.id} #{segment_def.name}"
            end.join(", ")

            raise Exceptions::ParseError,
              "non-deterministic machine state: #{matches}"
          end

          # Validate the new segment (recursively, including its children)
          machine.active.each{|m| critique(m.node.zipper) }

          # We want to detect when we've ended a syntax node (or more), like
          # starting a new interchange will end all previously "open" syntax
          # nodes. So we compare the state before adding `segment_tok` to the
          # corresponding state after we've added `segment_tok`.

          machine.prev.tap do |prev|
            prev.active.zip(machine.active) do |p, q|
              # If the new state `q` is a descendent of `p`, we know that `p`
              # and all of its ancestors are unterminated. However, if `q` is
              # not a descendent of `p`, but is a descendent of one of `p`s
              # descendents, then `p` and perhaps some of its ancestors were
              # terminated when the state transitioned to `q`.
              qancestors = Set.new

              # Operate on the syntax tree (instead of the state tree)
              q = q.node.zipper
              p = p.node.zipper

              while q.respond_to?(:parent)
                qancestors << q.parent
                q = q.parent
              end

              while p.respond_to?(:parent)
                break if qancestors.include?(p)

                # Now that we're sure that this syntax node (loop, table, etc)
                # is done being constructed, we can perform more validations.
                critique(p)
                p = p.parent
              end
            end
          end
        end

        @machine = machine
        @reader  = reader

        self
      end

    private

      def method_missing(name, *args)
        if SEGMENT_ID.match?(name.to_s)
          segment!(name, Reader::Position.caller(2), *args)
        else
          super
        end
      end

      # The `zipper` argument should be a _completed_ syntax node, meaning all
      # children have already been added. This is invariably true for segments,
      # because the {StateMachine} does not accept smaller units of syntax.
      def critique(zipper, recursive = false, position = false)
        if zipper.node.simple? or zipper.node.component?
          if zipper.node.invalid?
            raise Exceptions::ParseError,
              "invalid #{zipper.node.descriptor} at #{zipper.node.position.inspect}"
          elsif zipper.node.blank?
            if zipper.node.usage.required?
              raise Exceptions::ParseError,
                "required #{zipper.node.descriptor} is blank at #{zipper.node.position.inspect}"
            end
          elsif zipper.node.usage.forbidden?
            raise Exceptions::ParseError,
              "forbidden #{zipper.node.descriptor} is present at #{zipper.node.position.inspect}"
          elsif not zipper.node.allowed?
            raise Exceptions::ParseError,
              "value #{zipper.node.to_s} is not allowed in #{zipper.node.descriptor} at #{zipper.node.position.inspect}"
          elsif zipper.node.too_long?
            raise Exceptions::ParseError,
              "value is too long in #{zipper.node.descriptor} at #{zipper.node.position.inspect}"
          elsif zipper.node.too_short?
            raise Exceptions::ParseError,
              "value is too short in #{zipper.node.descriptor} at #{zipper.node.position.inspect}"
          end

        elsif zipper.node.composite?
          if zipper.node.blank?
            if zipper.node.usage.required?
              # GH-194: Normally the position of a composit element is the
              # position of it's first child; but an empty composit element
              # doesn't have children. So the closest position is of the parent
              raise Exceptions::ParseError,
                "required #{zipper.node.descriptor} is blank at #{zipper.parent.node.position.inspect}"
            end
          elsif zipper.node.usage.forbidden?
            raise Exceptions::ParseError,
              "forbidden #{zipper.node.descriptor} is present at #{zipper.node.position.inspect}"
          else
            if zipper.node.present?
              zipper.children.each_with_index do |z, i|
                critique(z)
              end

              d = zipper.node.definition
              d.syntax_notes.each do |s|
                unless s.satisfied?(zipper)
                  raise Exceptions::ParseError,
                    "for #{zipper.node.descriptor}, #{s.reason(zipper)} at #{zipper.node.position.inspect}"
                end
              end
            end
          end

        elsif zipper.node.repeated?
          unless zipper.node.usage.repeat_count.include?(zipper.node.children.length)
            raise Exceptions::ParseError,
              "repeating #{zipper.node.descriptor} occurs too many times at #{zipper.node.position.inspect}"
          end

          zipper.children.each{|z| critique(z) }

        elsif zipper.node.segment?
          if zipper.node.invalid?
            if zipper.up.node.invalid?
              # parent is an InvalidEnvelopeVal
              raise Exceptions::ParseError,
                "#{zipper.first.node.reason} at #{zipper.first.node.position.inspect}"
            else
              raise Exceptions::ParseError,
                "#{zipper.node.descriptor} at #{zipper.node.position.inspect}"
            end
          else
            zipper.children.each_with_index do |z, i|
              critique(z)
            end

            d = zipper.node.definition
            d.syntax_notes.each do |s|
              raise Exceptions::ParseError,
                "for #{zipper.node.descriptor}, #{s.reason(zipper)} at #{zipper.node.position.inspect}" \
                unless s.satisfied?(zipper)
            end
          end

        elsif zipper.node.loop?
          critique_occurences zipper, recursive

        elsif zipper.node.table?
          critique_occurences zipper, recursive

        elsif zipper.node.transaction_set?
          critique_occurences zipper, recursive

        elsif zipper.node.functional_group?
          critique_occurences zipper, recursive

        elsif zipper.node.interchange?
          critique_occurences zipper, recursive

        elsif zipper.node.transmission?
          if recursive
            zipper.children.each_with_index do |z, i|
              critique(z, recursive)
            end
          end
        end
      end

      def critique_occurences(zipper, recursive)
        occurences = Hash.new{|h,k| h[k] = 0 }

        zipper.children.each do |child|
          if child.node.respond_to?(:usage)
            occurences[child.node.usage] += 1
          elsif child.node.invalid?
            raise Exceptions::ParseError,
              "#{child.node.descriptor} at #{child.node.position.inspect}"
          else
            occurences[child.node.definition] += 1
          end

          if recursive
            critique(child, "", recursive)
          end
        end

        zipper.node.definition.children.each do |child|
          bound = child.repeat_count
          count = occurences.at(child)

          if count.zero? and child.required?
            raise Exceptions::ParseError,
              "required #{child.descriptor} is missing from #{zipper.node.descriptor} at #{zipper.node.position.inspect}"
          elsif bound < count
            raise Exceptions::ParseError,
              "#{child.descriptor} occurs too many times in #{zipper.node.descriptor} at #{zipper.node.position.inspect}"
          end
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

      def stream?
        false
      end
    end
  end
end
