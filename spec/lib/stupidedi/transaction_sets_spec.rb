describe "Stupidedi::TransactionSets" do
  # @return [Array<(String, TransactionSetDef)>]
  def self.transaction_set_defs
    lambda do |root|
      # Prevent walking in circles due to cycles in the graph
      history = Hash.new
      results = []
      ansi    = Stupidedi::Color.ansi

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
      results
    end.call(Stupidedi::TransactionSets)
  end

  transaction_set_defs.each do |name, transaction_set_def|
    names = name.split("::")

    describe names.slice(2..-1).join("::") do
      version              = Stupidedi::Versions.const_get(names[2])
      functional_group_def = version.const_get(:FunctionalGroupDef)

      it "is non-ambiguous" do
        Stupidedi::TransactionSets::Validation::Ambiguity.build(
          transaction_set_def, functional_group_def).audit
      end
    end
  end
end
