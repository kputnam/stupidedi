class Object

  # @group Combinators

  # Sends the arguments to `self` or yields `self` (when `self` is non-`nil`).
  # This is overridden by {NilClass#try}, which always returns `nil`.
  #
  # @example
  #   "non-nil".try(&:length) #=> 7
  #   nil.try(&:length)       #=> nil
  #
  def try(*args, &block)
    if args.empty?
      yield self
    else
      __send__(*args, &block)
    end
  end
end

class NilClass

  # @group Combinators

  # Returns `nil` (when `self` is `nil`). This overrides {Object#try}
  #
  # @example
  #   "non-nil".try(&:length) #=> 7
  #   nil.try(&:length)       #=> nil
  #
  # @return nil
  def try(*args)
    self
  end
end
