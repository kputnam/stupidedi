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

  all = Fixtures.passing +
        Fixtures.failing +
        Fixtures.skipping

  all.group_by{|_, _, name| name }.sort.each do |name, group|
    # describe name.split("::").slice(2..-1).join("::") do
      if Object.const_defined?(name)
        group.each do |path, config, name|
          case path
          when %r{/pass/}
            it path do
              expect(lambda do
                machine, result = Fixtures.parse!(path, config)
                builder         = Stupidedi::Parser::BuilderDsl.new(nil)
                machine.__send__(:roots).each do |z|
                  builder.__send__(:critique, z.node.zipper, "", true)
                end
              end).not_to raise_error
            end
          when %r{/skip/}
            pending path do
              expect(lambda do
                machine, result = Fixtures.parse!(path, config)
                builder         = Stupidedi::Parser::BuilderDsl.new(nil)
                machine.__send__(:roots).each do |z|
                  builder.__send__(:critique, z.node.zipper, "", true)
                end
              end).not_to raise_error
            end
          when %r{/fail/}
            it path do
              expect(lambda do
                machine, result = Fixtures.parse!(path, config)
                builder         = Stupidedi::Parser::BuilderDsl.new(nil)
                machine.__send__(:roots).each do |z|
                  builder.__send__(:critique, z.node.zipper, "", true)
                end
              end).to raise_error
            end
          end
        end

      else
        pending name.split("::").slice(2..-1).join("::") do
          raise NameError, "uninitialized constant #{name}"
        end
      end
    # end
  end

end
