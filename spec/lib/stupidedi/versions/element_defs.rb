Stupidedi::Versions.constants.each do |v|
  version = Stupidedi::Versions.const_get(v)

  if version.constants.include?(:ElementDefs)
    element_defs = version.const_get(:ElementDefs)

    describe element_defs do
      specify "constant name matches .id" do
        element_defs.constants.each do |name|
          element_def = element_defs.const_get(name)
          expect(element_def.id).should == name
        end
      end
    end
  end
end
