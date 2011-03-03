#
# This performs tail call optimization on methods declared by the programmer
# to be in tail call form. It can't actually verify if they are, so be sure
# to write tests for your methods.
#
# Because the optimizations are done in pure Ruby, the benefits are somewhat
# limited -- the stack doesn't grow but it begins to outperform the unoptimized
# code only when we reach about 5000 stack frames. Before that threshold, it
# actually performs significantly worse -- about 70% slower at 50 stack frames,
# and nearly 100% slower at 10 stack frames.
#
# With 10000 stack frames the optimized version runs about 40% faster.
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
# More importantly, because it uses define_method, we can't tailcall optimize
# methods that take a block parameter. Maybe this could be done using an eval
# to define the method instead.
#
# It seems like this tradeoff makes sense only for methods we know are going to
# consistently generate thousands of stack frames. We're probably better off
# using Ruby YARV (1.9) in all cases though, since it performs faster in general
# and it supposedly implements tail call optimization in the interpreter.
#
# See http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/145593
#
module Tailcall
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def optimize_tailcall(*names)
      for name in names
        original = instance_method(name)

        define_method(name) do |*args|
          if Thread.current[name]
            throw(:tc_recurse, args)
          else
            Thread.current[name] = original.bind(self)

            result = catch(:tc_done) do
              while true
                args = catch(:tc_recurse) do
                  throw(:tc_done, Thread.current[name].call(*args))
                end
              end
            end

            Thread.current[name] = nil

            result
          end
        end
      end
    end
  end
end
