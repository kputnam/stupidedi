# The SimpleCov.start must be issued before any of your application code is required!
begin
  require "simplecov"
  SimpleCov.start do
    add_filter %r{/segment_defs}
    add_filter %r{/element_defs}
    add_filter %r{/spec}
    add_filter %r{/transaction_sets/[0-9]+/[A-Z0-9-]+\.rb}

    add_group "Refinements",      "lib/ruby"
    add_group "Config",           "lib/stupidedi/config"
    add_group "Editor",           "lib/stupidedi/editor"
    add_group "Exceptions",       "lib/stupidedi/exceptions"
    add_group "Interchanges",     "lib/stupidedi/interchanges"
    add_group "Parser",           "lib/stupidedi/parser"
    add_group "Reader",           "lib/stupidedi/reader"
    add_group "Schema",           "lib/stupidedi/schema"
    add_group "TransactionSets",  "lib/stupidedi/transaction_sets"
    add_group "Values",           "lib/stupidedi/values"
    add_group "Versions",         "lib/stupidedi/versions"
    add_group "Writer",           "lib/stupidedi/writer"
    add_group "Zipper",           "lib/stupidedi/zipper"
  end
rescue LoadError
end

#
# Recursively forces autoload-declared constants to be loaded, to make sure Rcov
# is aware of these files and reports coverage on them. Otherwise, code that is
# never run nor autoloaded won't even show up on the coverage report.
#
# @note: To avoid defining a method in the global namespace or having to create
# a new namespace in which to define the method, this is a defined as a lambda
# value instead of a method.
#
lambda do |root|
  # Prevent walking in circles due to cycles in the graph
  history = Hash.new
  ansi    = Stupidedi::Color.ansi

  f = lambda do |namespace, recurse|
    history[namespace] = true

    for child in namespace.constants
      begin
        name  = [namespace, child].join("::")
        value = namespace.const_get(child)

        if value.is_a?(Module) and not history[value]
          recurse.call(value, recurse)
        end
      rescue Stupidedi::Exceptions::InvalidSchemaError
        $stderr.puts "warning: #{ansi.red("#{$!.class} #{$!.message}")}"
        $stderr.puts " module: #{name}"
        $stderr.puts $!.backtrace[0..-30].map{|x| "  " + x}.join("\n")
        $stderr.puts
      rescue LoadError, NameError
        $stderr.puts "warning: #{ansi.red("#{$!.class} #{$!.message}")}"
        $stderr.puts " module: #{name}"
        $stderr.puts
      end
    end
  end

  f.call(root, f)
end.call(Stupidedi)
