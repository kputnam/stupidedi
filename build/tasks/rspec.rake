require "rspec/core/rake_task"

# rake spec
RSpec::Core::RakeTask.new(spec: "compile") do |t|
  t.verbose    = false
  t.rspec_opts = "-w -rspec_helper"

  if ENV.include?("CI") or ENV.include?("TRAVIS")
    t.rspec_opts += " --format progress"
  else
    t.rspec_opts += " --format documentation"
  end
end
