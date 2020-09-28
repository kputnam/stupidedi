

def encode(counts, max)
  n = counts.size
  c = counts.sort_by{|k,v| v }

  symbol = c.map{|k,v| k }
  total  = c.sum{|k,v| v }.to_f
  weight = c.map{|k,v| v }
  length = weight.map{|w| (-Math.log2(w/total)).ceil - 1 }

  k = length.sum{|x| 2**(-x) }

  while k > 1
    value = n.times.map{|i| 2**(-length[i]-1) / weight[i] }
    best  = n.times.max_by{|i| value[i] }

    length[best] += 1
    k     = length.sum{|x| 2**(-x) }

    p([value, best ,k])
  end

  puts
  puts
  n.times do |i|
    x = (-Math.log2(weight[i] / total)).ceil
    puts "#{i}: #{x-1} <= #{length[i]} <= #{x}"
  end

  Hash[symbol.zip(length)]
end
