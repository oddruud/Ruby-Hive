require 'MoveValidators/MoveValidator'  
require 'Insects/piece'

class QueenInFourMovesValidator < MoveValidator

  def self.validate(board_state, move)
    queen =  getQueenFromPieceId(board_state.pieces,move.moving_piece_id)
    return true unless fourthPieceToBePlaced?(board_state.moves) && queen.used == false
    return false 
  end
  
def self.fourthPieceToBePlaced?(moves)  #RULE condition its a rule that the queen need to be placed within 4 moves
    moves.length == 6 || moves.length == 7 
end

def self.getQueenFromPieceId(pieces, id)
      if pieces[id].color == PieceColor::WHITE
        queen = pieces[Piece::WHITE_QUEEN_BEE]
      else
        queen = pieces[Piece::BLACK_QUEEN_BEE]
      end
      return queen          
end
  
end