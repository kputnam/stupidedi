module Stupidedi

  #
  # This performs tail call optimization on methods declared by the programmer
  # to be in tail call form. It can't actually verify if they are, so be sure
  # to write tests for your methods.
  #
  # Because the optimizations are done in pure Ruby, the benefits are somewhat
  # limited -- the stack doesn't grow but it only begins to outperform the
  # unoptimized code only when the stack reaches a depth of about 5000 frames.
  # Before that threshold, it actually performs significantly worse -- about 70%
  # slower at 50 stack frames, and nearly 100% slower at 10 stack frames.
  #
  # @example
  #   class Unoptimized
  #     def fact(n, accumulator = 1)
  #       (n < 2) ? accumulator : fact(n-1, n * accumulator)
  #     end
  #   end
  #
  #   class Optimized
  #     include TailCall
  #
  #     def fact(n, accumulator = 1)
  #       (n < 2) ? accumulator : fact(n-1, n * accumulator)
  #     end
  #
  #     optimize_tailcall :fact
  #   end
  #
  # =Benchmarks
  #
  #   o = Optimized.new
  #   u = Unoptimized.new
  #
  #   [10, 50, 100, 500, 1000, 5000, 10000, 50000].each do |n|
  #     Benchmark.bm do |x|
  #       x.report("#{n} optim = ") { puts(begin; o.fact(n).size; rescue; $! end) }
  #       x.report("#{n} plain = ") { puts(begin; u.fact(n).size; rescue; $! end) }
  #     end
  #   end
  #
  # With 10000 stack frames the optimized version runs about 40% faster. These
  # benchmark results were produced by Ruby Enterprise Edition 1.8.7
  #
  #          n       tco     plain    ratio
  #     ------------------------------------
  #         10    0.7918    0.0045    0.0056
  #         50    0.2476    0.0674    0.2723
  #        100    0.5207    0.2008    0.3856
  #        500    2.5064    1.0426    0.4160
  #       1000    5.8834    3.2413    0.5509
  #       5000   42.5210   41.7398    0.9816
  #      10000   14.5664   20.3000    1.3936
  #      25000    9.3729  (stack err)
  #
  # It seems like this tradeoff makes sense only for methods we know are going to
  # consistently generate thousands of stack frames. We're probably better off
  # using Ruby YARV (1.9) in all cases though, since it performs faster in general
  # and it supposedly implements tail call optimization in the interpreter.
  #
  #
  # @see http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/145593
  #
  module TailCall
    def self.included(base)
      base.extend(ClassMethods)
    end

    # @private
    module ClassMethods

      # @return [void]
      def optimize_tailcall(*names)
        @__tc ||= Hash.new

        for name in names
          @__tc[name.to_sym] = instance_method(name)

          module_eval <<-RUBY
            def #{name}(*args, &block)
              if Thread.current[:tc_#{name}]
                throw(:recurse_#{name}, [args, block])
              else
                Thread.current[:tc_#{name}] =
                  self.class.instance_variable_get(:@__tc)[:#{name}].bind(self)

                result = catch(:done_#{name}) do
                  while true
                    args, block =
                      catch(:recurse_#{name}) do
                        throw(:done_#{name},
                          Thread.current[:tc_#{name}].call(*args, &block))
                      end
                  end
                end

                Thread.current[:tc_#{name}] = nil

                result
              end
            end
          RUBY
        end
      end
    end

  end
end
