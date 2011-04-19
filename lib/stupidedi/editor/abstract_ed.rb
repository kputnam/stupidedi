module Stupidedi
  module Editor

    class AbstractEd
      include Inspect

      abstract :config

      def edit(id)
        yield
      end

    # def rewrite(id)
    #   yield
    # end
    end

    class << AbstractEd
      def declare(*ids)
      end
    end

  end
end
