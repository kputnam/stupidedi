class PpmAbstractMethodHandler < YARD::Handlers::Ruby::Base
  handles method_call(:abstract)
  namespace_only

  def process
    name = statement.parameters.first.jump(:symbol, :ident).source.slice(1..-1)
    args = statement.parameters.jump(:assoc)
    params = []

    unless args.eql?(statement.parameters)
      if args.first.jump(:symbol, :ident).source == ":args"
        # :args => (...)
        case args[1].type
        when :qwords_literal
          params = args[1].children.map(&:source)
        else
          raise YARD::Parser::UndocumentableError,
            "Need to add support for 'abstract :args => #{args[1].inspect}'"
        end
      end
    end

    object = register(YARD::CodeObjects::MethodObject.new(namespace, name, scope)) do |o|
      o.visibility = visibility
      o.source     = statement.source
      o.signature  = signature(name, params)
      o.explicit   = false
      o.parameters = parameters(params)
    end

    # Predicate methods return (Boolean), so automatically add the documentation
    if name =~ /\?$/
      if tag = object.tag(:return)
        if tag.types.nil? or tag.types.empty?
          tag.types = %w(Boolean)
        end
      else
        object.docstring.add_tag(YARD::Tags::Tag.new(:return, "", "Boolean"))
      end
    end

    # Ensure the method is marked abstract
    if object.tag(:abstract).nil?
      object.docstring.add_tag(YARD::Tags::Tag.new(:abstract, ""))
    end
  end

private

  def signature(name, params)
    if params.empty?
      "def #{name}"
    else
      "def #{name}(#{params.join(', ')})"
    end
  end

  def parameters(params)
    params.map do |p|
      name, default = p.split('=', 2)
      [name, default]
    end
  end

end

class PpmDelegateMethodHandler < YARD::Handlers::Ruby::MethodHandler
  handles method_call(:delegate)
  namespace_only

  def process
  end
end
