module Stupidedi
  using Refinements

  class Config

    class CodeListConfig
      include Inspect

      def initialize
        @table = Hash.new
      end

      def customize(&block)
        tap(&block)
      end

      def register(id, &constructor)
        @table[id] = constructor
      end

      def defined_at?(id)
        @table.defined_at?(id)
      end

      def at(id)
        @table[id].call
      end

      # @return [void]
      def pretty_print(q)
        q.text "CodeListConfig"
        q.group(2, "(", ")") do
          q.breakable ""
          @table.keys.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end
        end
      end
    end

  end
end
