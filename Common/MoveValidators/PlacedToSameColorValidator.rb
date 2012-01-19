require 'MoveValidators/MoveValidator'  

class PlacedToSameColorValidator < MoveValidator

def self.validate(board_state, move)
  return true
  
  #TODO
  #x,y = moving_piece.boardPosition 
  #
  #  #checks to see whether you are placing a piece next to a opposing piece:
  #  if @board[x][y] == EMPTY_SLOT_MIXED &&  moving_piece.used==false
  #     raise  MoveException, "invalid move: cannot place new #{Piece::PIECE_NAME[move.moving_piece_id]} next to opposite side"
  #  end
  #  setPieceTo(move.moving_piece_id, x, y) 
  
end

end


#Todo
#def touchesOpponent?(id)
  
#end