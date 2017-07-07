require_relative 'tic_tac_toe'

class TicTacToeNode
  attr_reader :board, :next_mover_mark, :prev_move_pos
  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @next_mover_mark = next_mover_mark
    @board = board
    @prev_move_pos = prev_move_pos
  end

  def losing_node?(evaluator)
    if @board.over?
      other_person = evaluator == :x ? :o : :x
      return  @board.winner == other_person
    end

    if @next_mover_mark == evaluator
      return children.all? { |child| child.losing_node?(evaluator) == true }
    else
      return children.any? { |child| child.losing_node?(evaluator) == true }
    end
  end

  def winning_node?(evaluator)
    if @board.over?
      return  @board.winner == evaluator
    end

    if @next_mover_mark == evaluator
      return children.any? { |child| child.winning_node?(evaluator) == true }
    else
      return children.all? { |child| child.winning_node?(evaluator) == true }
    end
  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    poss_moves = []
    other_mark = @next_mover_mark == :x ? :o : :x

    3.times do |row|
      3.times do |col|

        if @board.empty?([row, col])
          curr_pos = [row, col]
          next_board = @board.dup
          next_board[curr_pos] = @next_mover_mark
          poss_moves << TicTacToeNode.new(next_board, other_mark, curr_pos)
        end

      end
    end

    poss_moves

  end
end
