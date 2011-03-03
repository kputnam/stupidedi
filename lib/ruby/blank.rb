class String
  def blank?
    self !~ /\S/
  end
end

module Enumerable
  def blank?
    empty?
  end
end

class NilClass
  def blank?
    true
  end
end

class Object
  def blank?
    false
  end
end
