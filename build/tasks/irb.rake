# rake console
task(irb: "compile") do
  exec(*%w(bundle exec irb -Ilib -rstupidedi))
end
