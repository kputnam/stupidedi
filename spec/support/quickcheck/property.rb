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

    def initialize(base, qc, *args, &setup)
      @base, @qc, @args, @setup =
        base, qc, args, setup
    end

    # @return [void]
    def check(cases = 100, limit = 10, &block)
      property = self

      if @args.last.is_a?(Hash)
        args = @args.slice(0..-2)
        hash = @args.last
        hash[:random] = true

        args << hash
      else
        args = @args
        args << Hash[:random => true]
      end

      @base.it(*args) do
        begin
          count = 0
          input = nil

          if block.nil?
            property.qc.generate(cases, limit, property.setup) do
              count += 1
              property.progress(count, cases)
            end
          elsif block.arity == 1
            property.qc.generate(cases, limit, property.setup) do |input|
              instance_exec(input, &block)

              count += 1
              property.progress(count, cases)
            end
          else
            property.qc.generate(cases, limit, property.setup) do |input|
              instance_exec(*input, &block)

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
