class Symbol
  ##
  # Returns a proc that calls self on the proc's parameter
  def to_proc
    lambda{|receiver, *args| call(receiver, *args) }
  end

  ##
  # Calls self on the given receiver
  def call(receiver, *args)
    receiver.__send__(self, *args)
  end
end
