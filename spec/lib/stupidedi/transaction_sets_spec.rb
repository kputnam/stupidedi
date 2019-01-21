describe "Stupidedi::TransactionSets" do
  FIXTURES = Hash[(Fixtures.passing +
                   Fixtures.failing +
                   Fixtures.skipping).group_by{|_, name, _| name }]

  Definitions.transaction_set_defs.each do |name, value, error|
    describe name.split("::").slice(2..-1).join("::") do
      it "is well-defined" do
        expect(Object.const_get(name)).to be_a(Stupidedi::Schema::TransactionSetDef)
      end

      case error
      when Exception
        pending "is non-ambiguous" do
          raise "#{name} is not well-defined (see other spec results)"
        end
      else
        version              = Stupidedi::Versions.const_get(name.split("::")[2])
        functional_group_def = version.const_get(:FunctionalGroupDef)
        transaction_set_def  = value

        it "is non-ambiguous", :schema do
          expect(lambda do
            Stupidedi::TransactionSets::Validation::Ambiguity
              .build(transaction_set_def, functional_group_def)
              .audit
          end).not_to raise_error
        end
      end

      if FIXTURES.member?(name)
        case error
        when Exception
          FIXTURES[name].sort.each do |path, _, _|
            pending "can parse '#{path}'", :fixtures do
              raise "#{name} is not well-defined (see other spec results)"
            end
          end
        else
          FIXTURES[name].sort.each do |path, _, config|
            case path = path.to_s
            when %r{/pass/}
              it "can parse '#{path}'", :fixtures do
                expect(lambda do
                  machine, result = Fixtures.parse!(path, config)
                  builder         = Stupidedi::Parser::BuilderDsl.new(nil)
                  machine.__send__(:roots).each do |z|
                    builder.__send__(:critique, z.node.zipper, "", true)
                  end
                end).not_to raise_error
              end
            when %r{/skip/}
              pending "can parse '#{path}'", :fixtures do
                expect(lambda do
                  machine, result = Fixtures.parse!(path, config)
                  builder         = Stupidedi::Parser::BuilderDsl.new(nil)
                  machine.__send__(:roots).each do |z|
                    builder.__send__(:critique, z.node.zipper, "", true)
                  end
                end).not_to raise_error
              end
            when %r{/fail/}
              it "cannot parse '#{path}'", :fixtures do
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
        end

      else
        pending "can parse examples", :fixtures do
          parts   = name.split("::").slice(2..-1)
          version = Fixtures.versions.invert.fetch(parts[0], parts[0])
          name    = parts[2..3].join(" ")

          raise "No fixtures were found in 'spec/fixtures/#{version}/#{name}/{pass,fail}'"
        end
      end
    end
  end

end
