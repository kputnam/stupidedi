module Stupidedi
  class Config

    class EditorConfig
      include Inspect

      def initialize
        @table = Hash.new
      end

      # Is the edit or rewrite rule enabled?
      def enabled?(id)
        true
      end

      # Is `value` a valid string (AN)?
      def an?(value)
        true
      end

      def register(definition, &constructor)
        @table[definition] = constructor
      end

      def defined_at?(definition)
        @table.defined_at?(definition)
      end

      def at(definition)
        @table.at(definition).call
      end

      # @return [void]
      def pretty_print(q)
        q.text "EditorConfig"
        q.group(2, "(", ")") do
          q.breakable ""
          # ...
        end
      end
    end

  end
end
