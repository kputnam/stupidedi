module Enumerable

  ##
  # Count the number of elements that satisfy the predicate
  def count(*args)
    if block_given?
      inject(0){|n, e| yield(e) ? n + 1 : n }
    elsif args.empty?
      size
    else
      inject(0){|n, e| e == args.first ? n + 1 : n }
    end
  end
end
