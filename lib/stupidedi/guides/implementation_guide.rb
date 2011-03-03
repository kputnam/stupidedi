module Stupidedi
  module Guides
    
    class ImplementationGuide
    end

    class << ImplementationGuide
      def build(transaction_set_def, *table_defs)
        pp table_defs
      end
    end

  end
end
