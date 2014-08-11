class Object

  # @group Combinators
  #############################################################################

  # Sends the arguments to `self` or yields `self` (when `self` is non-`nil`).
  # This is overridden by {NilClass#try}, which always returns `nil`.
  #
  # @example
  #   "non-nil".attempt(&:length)       #=> 7
  #   nil.attempt(&:length)             #=> nil
  #
  #   "non-nil".attempt(:slice, 0, 3)   #=> "non"
  #   nil.attempt(:slice, 0, 3)         #=> nil
  #

  def attempt(*args, &block)
    if args.empty?
      yield self
    else
      __send__(*args, &block)
    end
  end unless method_defined?(:attempt)

end

class NilClass
  # @group Combinators
  #############################################################################

  # Returns `nil` (when `self` is `nil`). This overrides {Object#try}
  #
  # @example
  #   "non-nil".attempt(&:length) #=> 7
  #   nil.attempt(&:length)       #=> nil
  #
  #   "non-nil".attempt(:slice, 0, 3)   #=> "non"
  #   nil.attempt(:slice, 0, 3)         #=> nil
  #
  # @return nil

  def attempt(*args)
    self
  end
end
