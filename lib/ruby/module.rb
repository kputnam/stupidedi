class Module

  def abstract(name, *params)
    define_method(name) do |*args|
      if params.empty?
        raise NoMethodError, "Method #{name} is abstract"
      else
        raise NoMethodError, "Method #{name}(#{params.join(', ')}) is abstract"
      end
    end
  end

end
