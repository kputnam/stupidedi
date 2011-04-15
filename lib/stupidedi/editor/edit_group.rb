module Stupidedi
  module Editor

    class EditGroup

      def initialize(config)
      end

      def log(message)
      end

      # Performs an edit if the edit is enabled
      def edit(id)
        if enabled?(id)
          yield
        end
      end

      # Performs rewrite if the rewrite is enabled
      def rewrite(id)
        if enabled?(id)
          yield
        end
      end
    end

    class << EditGroup
      def declare(*ids)
      end

      def requires(edit_group)
      end
    end

    # class Medicare < EditGroup
    #
    #   class X222 < EditGroup
    #
    #     class Interchange < EditGroup
    #       declare "ISA01", "ISA02", ...
    #     end
    #
    #     class Loop1000A < EditGroup
    #     end
    #
    #     class Loop1000B < EditGroup
    #     end
    #
    #     class Loop2000A < EditGroup
    #     end
    #
    #     class Loop2000B < EditGroup
    #     end
    #
    #     class Balancing < EditGroup
    #     end
    #
    #     class CodeSets < EditGroup
    #     end
    #
    #     class Situations < EditGroup
    #     end
    #
    #   end
    #
    # end

  end
end
