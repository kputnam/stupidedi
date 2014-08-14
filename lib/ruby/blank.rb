class String

  # True if the string is `empty?` or contains all whitespace
  #
  # @example
  #   "abc".blankness?    #=> false
  #   "   ".blankness?    #=> true
  #   "".blankness?       #=> true
  #
  def blankness?
    self !~ /\S/
  end

  def is_present?
    self =~ /\S/
  end
end

# module Enumerable
#
#   # True if the collection is `empty?`
#   #
#   # @example
#   #   [1,2].blankness?    #=> false
#   #   [].blankness?       #=> false
#   #
#   unless respond_to?(:blankness?)
#
#   def blankness?
#     empty?
#   end
#
#   def is_present?
#     not empty?
#   end
# end

class NilClass

  # Always `true`. Note this overrides {Object#blankness?} which returns false.
  #
  # @example
  #   nil.blankness?    #=> true
  #
  def blankness?
    true
  end

  def is_present?
    false
  end
end

class Object

  # Always `false`. Note that {NilClass#blankness?} is overridden to return `true`
  #
  # @example
  #   false.blankness?    #=> false
  #   100.blankness?      #=> false
  #
  def blankness?
    false
  end

  def is_present?
    true
  end
end
