class Symbol

  unless method_defined?(:to_proc)
    ##
    # Returns a proc that calls self on the proc's parameter
    def to_proc
      lambda{|receiver| call(receiver) }
    end
  end

  ##
  # Calls self on the given receiver
  def call(receiver, *args)
    receiver.__send__(self, *args)
  end
end
