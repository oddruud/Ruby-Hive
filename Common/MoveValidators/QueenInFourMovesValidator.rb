require 'MoveValidator'  

class PlacedInFourMovesValidator < MoveValidator

  def self.validate(boardState, move)
    queen =  getQueenFromPieceId(boardState.pieces,move.moving_piece_id)
    return true unless fourthPieceToBePlaced?(boardState.moves) && queen.used == false
    return false 
  end
  
def self.fourthPieceToBePlaced?(moves)  #RULE condition its a rule that the queen need to be placed within 4 moves
    moves.length == 6 || moves.length == 7 
end

def self.getQueenFromPieceId(pieces, id)
      if Piece.color(id) == PieceColor::WHITE
        queen = pieces[WHITE_QUEEN_BEE]
      else
        queen = pieces[BLACK_QUEEN_BEE]
      end
      return queen          
end
  
end