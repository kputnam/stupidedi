class Module

  def abstract(name)
    define_method(name) do
      raise NoMethodError, "Method #{name} is abstract"
    end
  end

end
