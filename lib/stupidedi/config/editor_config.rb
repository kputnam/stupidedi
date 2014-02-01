module Stupidedi
  class Config

    class EditorConfig
      include Inspect

      def initialize
        @table = Hash.new
      end

      alias customize tap

      # Is the edit or rewrite rule enabled?
      def enabled?(id)
        true
      end

      # Is `value` a valid string (AN)?
      def an?(value)
        true # @todo
      end

      # @param [Class, String] definition
      def register(definition, &constructor)
        @table[definition] = constructor
      end

      # @param [Class] definition
      def defined_at?(definition)
        @table.defined_at?(definition) or
        @table.defined_at?(definition.class.name)
      end

      # @param [Class] definition
      def at(definition)
        (@table.at(definition) || @table.at(definition.class.name)).call
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
