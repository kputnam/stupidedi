class Object
  ##
  # Sends the arguments to self or yields self (when self is non-nil)
  def try(*args, &block)
    if args.empty?
      yield self
    else
      __send__(*args, &block)
    end
  end
end

class NilClass
  ##
  # Returns nil (when self is nil)
  def try(*args)
    self
  end
end
