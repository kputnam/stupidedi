module Stupidedi
  module HashOps
    refine Hash do
      def self.from_pairs(pairs, &op)
        pairs.inject({}){|h, (k,v)| h.merge(k => v, &op) }
      end

      def *(other)
        Hash[map{|k,v| [k, v*other] }]
      end

      def +(other)
        merge(other){|_,a,b| a + b }
      end

      def -(other)
        merge(other){|_,a,b| a - b }
      end

      def map_keys(&op)
        map{|k,v| [(yield k), v] }
      end

      def symbol_keys(&merge)
        self.class.from_pairs(map_keys(&:to_sym), &merge)
      end

      def string_keys(&merge)
        self.class.from_pairs(map_keys(&:to_s), &merge)
      end
    end
  end
end
