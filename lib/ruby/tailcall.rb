module Tailcall
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def optimizetc(*names)
      for name in names
        original = instance_method(name)

        define_method(name) do |*args|
          if Thread.current[name].nil?
            Thread.current[name] = original.bind(self)

            result = catch(:done) do
              while true
                args = catch(:tailcall) do
                  throw(:done, Thread.current[name].call(*args))
                end
              end
            end

            Thread.current[name] = nil

            result
          else
            throw(:tailcall, args)
          end
        end
      end
    end
  end
end
