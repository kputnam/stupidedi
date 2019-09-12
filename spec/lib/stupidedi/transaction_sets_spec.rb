describe "Stupidedi::TransactionSets" do
  fixtures = Hash[(Fixtures.passing +
                   Fixtures.failing +
                   Fixtures.skipping).group_by{|_, name, _| name }]

  def self.mk_fixture_spec(name, value, error, fixtures, checked = Set.new)
    describe name.split("::").slice(2..-1).join("::") do
      it "is well-defined", :schema do
        expect(Object.const_get(name)).to be_a(Stupidedi::Schema::TransactionSetDef)
      end

      version              = Stupidedi::Versions.const_get(name.split("::")[2])
      functional_group_def = version.const_get(:FunctionalGroupDef)
      transaction_set_def  = value

      it "is non-ambiguous", :schema do
        skip "#{name} is not well-defined" if Exception === error
        unless checked.include?(transaction_set_def.object_id)
          checked.add(transaction_set_def.object_id)

          expect(lambda do
            Stupidedi::TransactionSets::Validation::Ambiguity
              .build(transaction_set_def, functional_group_def)
              .audit
          end).not_to raise_error
        end
      end

      if fixtures.member?(name)
        fixtures[name].sort.each do |path, _, config|
          case path = path.to_s
          when %r{/pass/}
            it "can parse '#{path}'", :fixtures do
              skip "#{name} is not well defined" if Exception === error
              expect(lambda do
                machine, = Fixtures.parse!(path, config: config)
                builder  = Stupidedi::Parser::BuilderDsl.new(nil)
                machine.__send__(:roots).each do |z|
                  builder.__send__(:critique, z.node.zipper, "", true)
                end
              end).not_to raise_error
            end
          when %r{/skip/}
            skip "can parse '#{path}'", :fixtures do
              expect(lambda do
                machine, = Fixtures.parse!(path, config: config)
                builder  = Stupidedi::Parser::BuilderDsl.new(nil)
                machine.__send__(:roots).each do |z|
                  builder.__send__(:critique, z.node.zipper, "", true)
                end
              end).not_to raise_error
            end
          when %r{/fail/}
            it "cannot parse '#{path}'", :fixtures do
              skip "#{name} is not well defined" if Exception === error
              expect(lambda do
                machine, = Fixtures.parse!(path, config: config)
                builder  = Stupidedi::Parser::BuilderDsl.new(nil)
                machine.__send__(:roots).each do |z|
                  builder.__send__(:critique, z.node.zipper, "", true)
                end
              end).to raise_error(Stupidedi::Exceptions::ParseError)
            end
          end
        end

      else
        it "can parse examples", :fixtures do
          parts   = name.split("::").slice(2..-1)
          version = Fixtures.versions.invert.fetch(parts[0], parts[0])
          _name   = parts[2..3].join(" ")
          skip "No fixtures in 'spec/fixtures/#{version}/#{_name}/{pass,fail}'"
        end
      end
    end
  end

  Definitions.transaction_set_defs.each do |name, value, error|
    mk_fixture_spec(name.dup, value, error, fixtures)
  end

end
