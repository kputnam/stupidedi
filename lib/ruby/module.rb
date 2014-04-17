class Module

  # Creates an abstract method
  #
  # @example
  #   class Collection
  #     abstract :size
  #     abstract :add, :args => %w(item)
  #   end
  #
  # @return [void]
  def abstract(name, *params)
    if params.last.is_a?(Hash)
      # abstract :method, :args => %w(a b c)
      params = params.last[:args]
    end

    file, line, = Stupidedi.caller

    if params.empty?
      class_eval(<<-RUBY, file, line.to_i - 1)
        def #{name}(*args)
          raise NoMethodError,
            "method \#{self.class.name}.#{name} is abstract"
        end
      RUBY
    else
      class_eval(<<-RUBY, file, line.to_i - 1)
        def #{name}(*args)
          raise NoMethodError,
            "method \#{self.class.name}.#{name}(#{params.join(', ')}) is abstract"
        end
      RUBY
    end
  end

  # Creates a method (or methods) that delegates messages to an instance
  # variable or another instance method.
  #
  # @example
  #   class WrappedCollection
  #     delegate :size, :add, :to => :@wrapped
  #
  #     def initialize(wrapped)
  #       @wrapped = wrapped
  #     end
  #   end
  #
  # @return [void]

end
