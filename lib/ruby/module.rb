class Module

  def abstract(name, *params)
    if params.last.is_a?(Hash)
      # abstract :method, :args => %w(a b c)
      params = params.last[:args]
    end

    file, line = caller.first.split(':')

    if params.empty?
      class_eval(<<-RUBY, file, line.to_i - 1)
        def #{name}(*args)
          raise NoMethodError, "Method #{name} is declared abstract"
        end
      RUBY
    else
      class_eval(<<-RUBY, file, line.to_i - 1)
        def #{name}(*args)
          raise NoMethodError, "Method #{name}(#{params.join(', ')}) is declared abstract"
        end
      RUBY
    end
  end

  def delegate(*params)
    unless params.last.is_a?(Hash)
      raise ArgumentError, "Last argument must be :to => ..."
    end

    methods = params.init
    target  = params.last.fetch(:to) or
      raise ArgumentError, ":to cannot be nil"

    file, line = caller.first.split(':')

    for m in methods
      if m.to_s =~ /=$/
        class_eval(<<-RUBY, file, line.to_i - 1)
          def #{m}(value)
            #{target}.#{m}(value)
          end
        RUBY
      else
        class_eval(<<-RUBY, file, line.to_i - 1)
          def #{m}(*args, &block)
            #{target}.#{m}(*args, &block)
          end
        RUBY
      end
    end
  end
end
