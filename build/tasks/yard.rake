require "yard"

# rake yard
YARD::Rake::YardocTask.new(yard: %w(build/generated/doc/images)) do |t|
  # NOTE: Options are loaded from .yardopts
  t.after = lambda { $stderr.puts "See build/generated/doc/index.html" }
end

task "build/generated/doc/images" do
  mkdir_p "build/generated/doc/images"
end

task "yard:clobber" do
  rm_rf "build/generated/doc"
  rm_rf "build/generated/.yardoc"
end

CLOBBER.include(*%w(build/generated/doc))
CLOBBER.include(*%w(build/generated/.yardoc))
