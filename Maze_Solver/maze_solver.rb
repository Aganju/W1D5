require_relative '00_tree_node.rb'
require 'byebug'
class MazeSolver
  attr_reader :move_tree
  DELTAS = [
   [-1,  0],
   [ 0,  1],
   [ 0, -1],
   [ 1,  0],
   ]
  def initialize(file)
    @maze = File.readlines(file).map { |line| line.chomp.split('')}
    @start_pos = find_start
    @visited_pos = [@start_pos]

    @move_tree = build_move_tree
    @end_pos = find_end
    build_path(find_path)
  end

  def build_path(path)
    path[1..-2].each { |(x, y)| @maze[x][y] = 'X' }

    @maze.each do |line|
      line.each { |chr| print chr }
      puts
    end
  end

  def find_start
    find_loc('S')
  end

  def find_end
    find_loc('E')
  end

  def find_loc(char)
    @maze.each_with_index do |row, index|
      loc = row.find_index(char)
      return [index, loc] if loc
    end
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

  def find_path
    trace_path_back(@move_tree.dfs(@end_pos))
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
    moves = self.class.valid_moves(@maze, pos).reject { |pos| @visited_pos.include?(pos) }
    @visited_pos += moves
    moves
  end

  private

  def self.valid_moves(maze, pos)
    DELTAS.map do |(dx, dy)|
      [pos[0] + dx, pos[1] + dy]
    end.select do |row, col|
      maze[row][col] != "*"
    end
  end


end
