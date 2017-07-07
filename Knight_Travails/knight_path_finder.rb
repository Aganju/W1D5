require_relative '00_tree_node.rb'
require 'byebug'
class KnightPathFinder
  attr_reader :move_tree
  DELTAS = [
   [ 1, -2],
   [ 1,  2],
   [-1, -2],
   [-2, -1],
   [ 2, -1],
   [ 2,  1],
   [-2,  1],
   [-1,  2]
 ]
  def initialize(pos = [0, 0])
    @start_pos = pos
    @visited_pos = [@start_pos]
    @move_tree = build_move_tree
  end

  def build_move_tree
    root = PolyTreeNode.new(@start_pos)
    queue = [root]
    until queue.empty?
      node = queue.shift
      node.children = new_move_positions(node.value).map { |child_pos| PolyTreeNode.new(child_pos, node) }
      queue += node.children
    end
    root
  end

  def find_path(end_pos)
    trace_path_back(@move_tree.dfs(end_pos))
  end

  def trace_path_back(node)
    # debugger
    ret = []
    until node.parent == nil
      ret << node.value
      node = node.parent
    end
    ret << node.value
    ret.reverse
  end

  def new_move_positions(pos)
    moves = self.class.valid_moves(pos).reject { |pos| @visited_pos.include?(pos) }
    @visited_pos += moves
    moves
  end

  private

  def self.valid_moves(pos)
    DELTAS.map do |(dx, dy)|
      [pos[0] + dx, pos[1] + dy]
    end.select do |row, col|
      row.between?(0, 7) && col.between?(0, 7)
    end
  end


end
