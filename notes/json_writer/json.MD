# An example of traversing a tree to hash

This folder contains an example of one of the possible ways to traverse stupidedit internal tree to a ruby hash (which eventually may be traversed to a json object)

It is a standalone implementation implying no changes to the internals of the library. You can see output format in `sample_output.rb`

It is possible to change the structure of the hash by applying corresponding changes to node reducers.

**NOTE:** This has been tested for a limited number of inputs so please make sure this writer works for your case before using.

Usage:

```ruby
io = File.open("spec/fixtures/X231-FA999/1-good.txt")
config = Stupidedi::Config.contrib(Stupidedi::Config.hipaa(Stupidedi::Config.default))
parser = Stupidedi::Parser.build(config)
parser, _result = parser.read(Stupidedi::Reader.build(io))

result = {}

parser.zipper.tap do |z|
  Stupidedi::Writer::Json.new(z.root.node).write(result)
end

result # => {...}
```
