module Stupidedi
  module Native

    #
    # https://github.com/lsegal/yard/issues/1281
    #
    class BitVector < Object
      include Enumerable

      def initialize(length, width=nil)
      end

      #
      def [](i, width=nil)
      end

      #
      def []=(i, width, value=nil)
      end

      #
      def size
      end

      #
      def width
      end

      #
      def memsize_bits
      end

      #
      def each(&block)
        if block_given?
          size.times{|n| yield self[n] }
        else
          to_enum(:each)
        end
      end
    end

    #
    #
    #
    class RRR < Object
      def initialize
      end

      #
      def [](i)
      end

      #
      def rank(symbol, i)
      end

      #
      def rank0(i)
        rank(0, i)
      end

      #
      def rank1(i)
        rank(1, i)
      end

      #
      def select(symbol, rank)
      end

      #
      def select0(rank)
        select(0, rank)
      end

      #
      def select1(rank)
        select(1, rank)
      end

      #
      def size
      end

      #
      def memsize_bits
      end

      #
      def inspect
      end
    end

    class RRR::Builder < Object
      #
      def initialize(block_size, marker_size, size)
      end

      #
      def append(width, value)
      end

      #
      def finish
      end

      #
      def inspect
      end
    end

    class WaveletTree < Object
      #
      def initialize
      end

      #
      def [](i)
      end

      #
      def rank(char, i)
      end

      #
      def select(char, rank)
      end

      #
      def size
      end

      #
      def memsize_bits
      end

      #
      def inspect
      end
    end

    #
    require "stupidedi/native/native"
  end
end
