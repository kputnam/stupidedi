class LegacyAbstractMethodHandler < YARD::Handlers::Ruby::Legacy::Base
  MATCH_A = /\Aabstract\s+:([^, ]+)(:?,\s+:args\s+=>\s+)(.+)/
  MATCH_B = /\Aabstract\s+:([^, ]+)$/
  handles MATCH_A
  handles MATCH_B
  namespace_only

  def process
    params = []

    if m = MATCH_A.match(statement.tokens.to_s)
      name = m.captures.first
      args = m.captures.at(2)

      if m = /%w\(([^)]+)\)/.match(args)
        params = args.split(/\s+/)
      else
        params = args.split(/\s*,\s*/)
      end
    elsif m = MATCH_B.match(statement.tokens.to_s)
      name = m.captures.first
    end

    object = register(YARD::CodeObjects::MethodObject.new(namespace, name, scope)) do |o|
      o.visibility = visibility
      o.source     = statement.source
      o.explicit   = false
      o.signature  = signature(name, params)
      o.parameters = parameters(params)
    end

    if name =~ /\?$/
      if object.has_tag?(:return)
        tag = object.tag(:return)
        if tag.types.nil? or tag.types.empty?
          tag.types = %w(Boolean)
        end
      else
        object.docstring.add_tag(YARD::Tags::Tag.new(:return, "", "Boolean"))
      end
    end

    unless object.has_tag?(:abstract)
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
      name, default = p.split("=", 2)
      [name, default]
    end
  end
end

class LegacyDelegateMethodHandler < YARD::Handlers::Ruby::Legacy::Base
  MATCH = /\Adelegate\s+((:?:[^,]+,\s+)+)\s*:to\s*=>\s*([^ ]+)$/
  handles MATCH
  namespace_only

  def process
    return unless m = MATCH.match(statement.tokens.to_s)

    methods = m.captures.at(0).split(/\s*,\s*/)
    target  = m.captures.at(2).slice(2..-1)

    methods.each do |name|
      name = name.slice(1..-1)

      object = register(YARD::CodeObjects::MethodObject.new(namespace, name, scope)) do |o|
        o.visibility = visibility
        o.source     = statement.source
        o.explicit   = false
        o.group      = (scope == :instance) ?
          "Delegated Instance Methods" :
          "Delegated Class Methods"
        o.namespace.groups |= [o.group]
      end
    end
  end

end
