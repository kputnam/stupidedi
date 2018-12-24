require "spec_helper"

describe Stupidedi::Schema::Auditor do

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

  definitions.each do |name, definition|
    next if name =~ /FiftyTen::X223::HC837I/

    it name do
      Stupidedi::Schema::Auditor.build(definition).audit
    end
  end

  pending "Stupidedi::Schema::Auditor Stupidedi::Guides::FiftyTen::X223::HC837I" do
    Stupidedi::Schema::Auditor.build(Stupidedi::Guides::FiftyTen::X223::HC837I).audit
  end

end
