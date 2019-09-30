using Stupidedi::Refinements

Definitions.element_defs
  .group_by{|name, _| name.split("::").take_until{|m| m == "ElementDefs" } }
  .each do |version, element_defs|
    describe [*version, "ElementDefs"].join("::"), :schema do
      describe "#id" do
        it "matches constant name" do
          element_defs.each do |constant_name, element_def|
            expect(element_def.id).to be == constant_name.split("::").last.to_sym
          end
        end
      end
    end
  end
