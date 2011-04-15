class String

  # True if the string is `empty?` or contains all whitespace
  #
  # @example
  #   "abc".blank?    #=> false
  #   "   ".blank?    #=> true
  #   "".blank?       #=> true
  #
  def blank?
    self !~ /\S/
  end

  def present?
    self =~ /\S/
  end
end

module Enumerable

  # True if the collection is `empty?`
  #
  # @example
  #   [1,2].blank?    #=> false
  #   [].blank?       #=> false
  #
  def blank?
    empty?
  end

  def present?
    not empty?
  end
end

class NilClass

  # Always `true`. Note this overrides {Object#blank?} which returns false.
  #
  # @example
  #   nil.blank?    #=> true
  #
  def blank?
    true
  end

  def present?
    false
  end
end

class Object

  # Always `false`. Note that {NilClass#blank?} is overridden to return `true`
  #
  # @example
  #   false.blank?    #=> false
  #   100.blank?      #=> false
  #
  def blank?
    false
  end

  def present?
    true
  end
end
