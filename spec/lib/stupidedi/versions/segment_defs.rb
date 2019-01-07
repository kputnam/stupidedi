Stupidedi::Versions.constants.each do |v|
  version = Stupidedi::Versions.const_get(v)

  if version.constants.include?(:SegmentDefs)
    segment_defs = version.const_get(:SegmentDefs)

    describe segment_defs do
      specify "constant name matches .id" do
        segment_defs.constants.each do |name|
          segment_def = segment_defs.const_get(name)
          expect(segment_def.id).should == name
        end
      end
    end
  end
end
