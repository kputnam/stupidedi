class Hash
  def defined_at?(key)
    include?(key)
  end

  def at(key)
    self[key]
  end
end
