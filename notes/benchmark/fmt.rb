#!/usr/bin/env ruby

lines  = $stdin.read.lines
lines  = lines.with_index.select{|x,y| y%32==0 }
format = lambda do |(x,_),y|
  ptwo = (y&(y-1)).zero?
  segs = 1680*y
  secs = x[/[\d.]+/]
  rate = segs.to_f/secs.to_f
  "#{segs}\t#{'%0.2f'%rate}\t#{secs}\t#{ptwo ? '*' : ' '}"
# "#{ptwo ? '*' : ' '}#{segs}\t#{'%0.2f'%rate}/s\t#{secs}s"
end

puts lines.map.with_index(&format)
