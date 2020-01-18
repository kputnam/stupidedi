module Stupidedi
  module Reader

    #
    # * - element separator
    # : - component separator
    # > - repetition separator
    # ~ - segment terminator
    #
    class WaveletTree
      def initialize(table)
        @table = table
      end

      # Access the symbol at the given position
      def access(position)
      end

      # Return the number of times the symbol occurs before given position
      def rank(symbol, position)
        @table.fetch(symbol).inject(0){|count, k| return count if k > position; count + 1 }
      end

      # Returns the position of the rank'th occurrence of the symbol
      def select(symbol, rank)
        @table.fetch(symbol)[rank]
      end

      def self.build(string, alphabet)
        table = Hash[alphabet.chars.map{|c| [c, []] }]

        string.chars.each_with_index do |c, k|
          if table.include?(c)
            table[c] << k
          # elsif NativeExt.graphic?(c)
          #   table[GRAPHIC] << k
          # else
          #   table[NONGRAPHIC] << k
          end
        end

        WaveletTree.new(table)
      end
    end
  end
end
