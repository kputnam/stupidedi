module Stupidedi
  using Refinements

  module Editor

    class AbstractEd
      include Inspect

      # @return [Config]
      abstract :config

      # @return [ResultSet]
      abstract :critique

      def edit(id)
        if config.editor.enabled?(id)
        # puts "#{self.class.name.split("::").last}.edit(#{id})"
          yield
        end
      end

      def rewrite(id)
        if config.editor.enabled?(id)
          yield
        end
      end
    end

    class << AbstractEd
      def edit(*args)
      end

      def rewrite(*args)
      end
    end

  end
end
