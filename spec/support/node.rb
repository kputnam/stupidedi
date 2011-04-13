class Node

  # @return [String]
  attr_reader :label

  # @return [Array<Node>]
  attr_reader :children

  def initialize(label, children = [])
    @label, @children = label, children
  end

  # @return [Node]
  def copy(changes = {})
    Node.new \
      changes.fetch(:label, @label),
      changes.fetch(:children, @children)
  end

  def leaf?
    false
  end

  # @return [String]
  def inspect
    if @children.empty?
      @label.to_s
    else
      "#{@label}(#{@children.map(&:inspect).join(', ')})"
    end
  end
end

class Leaf < Node
  def initialize(label)
    @label, @children = label, []
  end

  def leaf?
    true
  end
end
