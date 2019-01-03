require "spec_helper"

describe Stupidedi::Schema::Auditor, :focus => true do

  def self.definitions
    ansi = Stupidedi::Color.ansi

    @definitions ||= lambda do |root|
      # Prevent walking in circles due to cycles in the graph
      history = Hash.new
      results = []

      f = lambda do |namespace, recurse|
        history[namespace] = true

        for child in namespace.constants
          begin
            name  = [namespace, child].join("::")
            value = namespace.const_get(child)

            if value.is_a?(Module)
              if not history[value]
                recurse.call(value, recurse)
              end
            elsif value.kind_of?(Stupidedi::Schema::TransactionSetDef)
              results << [name, value]
            end
          rescue Stupidedi::Exceptions::InvalidSchemaError
            $stderr.puts "warning: #{ansi.red("#{$!.class} #{$!.message}")}"
            $stderr.puts " module: #{name}"
            $stderr.puts "  trace: #{$!.backtrace[0..-30].map{|x| "  " + x}.join("\n")}"
            $stderr.puts
          rescue LoadError, NameError
            $stderr.puts "warning: #{ansi.red("#{$!.class} #{$!.message}")}"
            $stderr.puts " module: #{name}"
            $stderr.puts
          end
        end
      end

      f.call(root, f)
      results
    end.call(Stupidedi)
  end

  definitions.each do |name, transaction_set_def|
    it name do
      modules = name.split("::")
      if modules[0] == "Stupidedi" and modules[1] == "TransactionSets"
        version              = Stupidedi::Versions.const_get(modules[2])
        functional_group_def = version.const_get(:FunctionalGroupDef)
        Stupidedi::Schema::Auditor.build(transaction_set_def, functional_group_def).audit
      end
    end
  end

end
