module Stupidedi
  module Editor

    class AbstractEd
      include Inspect

      abstract :config

      def edit(id)
        if config.enabled?(id)
          yield
        end
      end

      def rewrite(id)
        if config.enabled?(id)
          yield
        end
      end
    end

    class << AbstractEd
      def declare(*ids)
      end
    end

  end
end
