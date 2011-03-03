class Module

  def abstract(name, *params)
    if params.last.is_a?(Hash)
      # abstract :method, :args => %w(a b c)
      params = params.last[:args]
    end

    if params.empty?
      define_method(name) do |*args|
        raise NoMethodError, "Method #{name} is abstract"
      end
    else
      define_method(name) do |*args|
        raise NoMethodError, "Method #{name}(#{params.join(', ')}) is abstract"
      end
    end
  end

  def delegate(*params)
    unless params.last.is_a?(Hash)
      raise ArgumentError, "Last argument must be :to => ..."
    end

    methods = params.init
    target  = params.last.fetch(:to) or
      raise ArgumentError, ":to cannot be nil"

    for m in methods
      if m.to_s =~ /=$/
        class_eval <<-RUBY
          def #{m}(value)
            #{target}.#{m}(value)
          end
        RUBY
      else
        class_eval <<-RUBY
          def #{m}(*args, &block)
            #{target}.#{m}(*args, &block)
          end
        RUBY
      end
    end
  end
end
