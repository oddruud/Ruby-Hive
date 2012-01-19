require 'filters/Filter'

class QueenBeePriorityFilter < Filter
  
  def self.purify_moves(board_state, player, moves)
    return if moves.length == 0 
    
    queen = board_state.get_piece_with_color(player.color, Piece::Queen)
    if player.turns == 3 and not queen.used?
      moves.clear
      moves << PossibleMove.new(queen, board_state.start_slot)
    end 
        
  end
  
end