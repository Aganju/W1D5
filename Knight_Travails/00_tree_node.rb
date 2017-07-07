class PolyTreeNode
  attr_accessor :parent, :children
  attr_reader :value

  def initialize(value, parent = nil)
    @value = value
    @parent = parent
    @children = []
  end

  def parent=(node)
    unless node == @parent
      @parent.children.delete(self) unless @parent == nil
      @parent = node
      @parent.children << self unless node == nil
    end
  end

  def add_child(child_node)
    child_node.parent = self
  end

  def remove_child(child_node)
    raise("not a child") unless children.include?(child_node)
    child_node.parent = nil
  end

  def dfs(target_val)
    return self if self.value == target_val
    # debugger
    self.children.each do |child|
      child_result = child.dfs(target_val)
      return child_result if child_result
    end

    nil
  end

  def bfs(target_val)
    queue = [self]
    until queue.empty?
      node = queue.shift
      return node if node.value == target_val
      queue += node.children
    end

  end

end
