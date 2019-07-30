#
# Recursively forces autoload-declared constants to be loaded, to make sure Rcov
# is aware of these files and reports coverage on them. Otherwise, code that is
# never run nor autoloaded won't even show up on the coverage report.
#
# NOTE: To avoid defining a method in the global namespace or having to create
# a new namespace in which to define the method, this is a defined as a lambda
# value instead of a method.
#
lambda do |root|
  # Prevent walking in circles due to cycles in the graph
  history = Hash.new

  f = lambda do |namespace, recurse|
    history[namespace] = true

    for child in namespace.constants
      value = namespace.const_get(child)

      if value.is_a?(Module) and not history.include?(value)
        recurse.call(value, recurse)
      end
    end
  end

  f.call(root, f)
end.call(Stupidedi)
