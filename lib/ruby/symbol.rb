class Symbol

  unless method_defined?(:to_proc)
    # Returns a proc that calls self on the proc's parameter
    #
    # @example
    #   [1, 2, 3].map(&:-@)       #=> [-1, -2, -3]
    #   [-1, -2, -3].map(&:abs)   #=> [1, 2, 3]
    #
    def to_proc
    # lambda{|receiver| call(receiver) }
      lambda{|receiver, *args| receiver.__send__(self, *args) }
    end
  end

  # Calls self on the given receiver
  #
  # @example
  #   :to_s.call(100)           #=> "100"
  #   :join.call([1,2,3], "-")  #=> "1-2-3"
  #
  def call(receiver, *args)
    receiver.__send__(self, *args)
  end
end
