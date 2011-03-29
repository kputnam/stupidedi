class QuickCheck
  class Property

    # @return [String]
    attr_reader :name

    # @return [Class<QuickCheck>]
    attr_reader :qc

    # @return [Class]
    attr_reader :base

    # @return [Proc]
    attr_reader :setup

    def initialize(name, base, qc, &setup)
      @name, @base, @qc, @setup =
        name, base, qc, setup
    end

    # @return [void]
    def check(cases = 100, limit = 10, &block)
      property = self

      @base.it(@name) do
        begin
          count = 0
          input = nil

          unless block.nil?
            property.qc.generate(cases, limit, property.setup) do
              count += 1
              property.progress(count, cases)
            end
          else
            property.qc.generate(cases, limit, property.setup) do |input|
              block.call(input)
              count += 1
              property.progress(count, cases)
            end
          end
        rescue
          seed = srand # Get the previous seed by setting it
          srand(seed)  # But immediately restore it

          $!.message << " -- with seed #{seed} after #{count} successes, on #{input.inspect}"
          raise $!
        end
      end
    end

    PROGRESS = %w(% $ @ # &)

    if $stdout.tty?
      def progress(completed, total)
        print((completed == total) ? "" : "#{PROGRESS[completed % 4]}\010")
      end
    else
      def progress(completed, total)
      end
    end
  end
end
