module Stupidedi
  class Config

    class EditorConfig

      # Is the edit or rewrite rule enabled?
      def enabled?(id)
        true
      end

      # Is `value` a valid string (AN)?
      def an?(value)
        true
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
