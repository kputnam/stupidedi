module Stupidedi
  module Editor

    class TransmissionEd < AbstractEd

      # @return [Config]
      attr_reader :config

      # @return [Time]
      attr_reader :received

      def initialize(config, received)
        @config, @received =
          config, received
      end

      # @return [ResultSet]
      def critique(machine)
        ResultSet.new.tap do |acc|
          m, index = machine.first, Hash.new{|h,k| h[k] = [] }

          # Collect all the ISA13 elements within this transmission
          while m.defined?
            m = m.flatmap do |isa|
              critique_isa(isa, acc)

              # There isn't a well-defined constraint in the specs regarding
              # the uniqueness of control numbers, but one of the foundation
              # standards documents suggests the combination of ISA05, ISA06,
              # ISA07, ISA08, and ISA13 "shall be unique within a reasonably
              # extended time frame whose boundaries shall be defined by
              # trading partner agreement".
              isa.element(5).tap do |e5|
                isa.element(6).tap do |e6|
                  isa.element(7).tap do |e7|
                    isa.element(8).tap do |e8|
                      isa.element(13).tap do |e13|
                        key  = []
                        key <<  e5.node.to_s
                        key <<  e6.node.to_s
                        key <<  e7.node.to_s
                        key <<  e8.node.to_s
                        key << e13.node.to_s

                        isa.segment.tap{|s| index[key] << s }
                      end
                    end
                  end
                end
              end

              isa.find!(:ISA)
            end
          end

          edit(:ISA) do
            index.each do |key, dupes|
              dupes.tail.each do |s|
                acc.ta105(s, "R", "025",
                  "control number must be unique per sender and receiver")
              end
            end
          end
        end
      end

    private

      #
      # @see FiveOhOne#critique
      #
      def critique_isa(isa, acc)
        isa.segment.tap do |x|
          unless x.node.invalid?
            envelope_def = x.node.definition.parent.parent

            # Invoke the version-specific interchange editor
            if config.editor.defined_at?(envelope_def)
              editor = config.editor.at(envelope_def)
              editor.new(config, received).critique(isa, acc)
            end
          else
            acc.ta105(x, "R", "003", x.node.reason)
          end
        end
      end
    end

  end
end
