
# Recursively forces autoload-declared constants to be loaded, to make sure Rcov
# is aware of these files and reports coverage on them. Otherwise, code that is
# never run nor autoloaded won't even show up on the coverage report.
#
# @note: To avoid defining a method in the global namespace or having to create
# a new namespace in which to define the method, this is a defined as a lambda
# value instead of a method.
#
loader = lambda do |root|
  # Prevent walking in circles due to cycles in the graph
  # like Object.constants.include?("Object") #=> true
  history = Hash.new

  lambda do |namespace, recurse|
    history[namespace] = true

    for child in namespace.constants
      begin
        value = namespace.const_get(child)

        if value.is_a?(Module) and not history[value]
          recurse.call(value, recurse)
        end
      rescue LoadError, NameError
        $stderr.puts "#{$!.class}: #{$!.message}"
      end
    end
  end.bind do |recurse|
    recurse.call(root, recurse)
  end
end

if defined? Rcov
  loader.call(Stupidedi)
end
