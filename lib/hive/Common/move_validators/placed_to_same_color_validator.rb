require 'move_validators/move_validator'  

class Hive::PlacedToSameColorValidator < Hive::MoveValidator

def self.validate(board_state, move)
  return true
  
  #TODO
  #x,y = moving_piece.board_position 
  #
  #  #checks to see whether you are placing a piece next to a opposing piece:
  #  if @board[x][y] == EMPTY_SLOT_MIXED &&  moving_piece.used==false
  #     raise  MoveException, "invalid move: cannot place new #{Piece::PIECE_NAME[move.moving_piece_id]} next to opposite side"
  #  end
  #  set_piece_to(move.moving_piece_id, x, y) 
  
end

end


#Todo
#def touches_opponent?(id)
  
#end