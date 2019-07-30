Bundler.setup(:default, :development)

Dir["build/tasks/*.rake"].sort.each{|r| load r }

task(default: "spec")
