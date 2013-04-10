module Enumerable

  # Count the number of elements that satisfy the predicate
  #
  # @example
  #   ["abc", "de", "fg", "hi"].count{|s| s.length == 2 } #=> 3
  #   ["a", "b", "a", "c", "a"].count("a")                #=> 3
  #   [1, 3, 5, 9, 0].count                               #=> 5
  #
  # @return [Integer]
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
