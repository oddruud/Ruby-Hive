require 'Insects/piece'
class Mosquito < Piece

def initialize(board_state, id)
  super(board_state, id)  
end
  
def availableMoves
  moves = Array.new()
  moves += availablePlaceMoves unless used? 
  moves += Mosquito.availableBoardMoves(self)  if used?
 return moves
end
 
 
#WHITE_MOSQUITO moves....
#[21:45:05] FATAL-GameHandler: move failed: stack level too deep
#/Users/ruudopdenkelder/Projects/Hive-Boardgame-Framework/Common/slot.rb:87:in `setBoardPosition' 
     
def self.availableBoardMoves(mosquito)  
  moves = Array.new()
  mosquito.forEachAdjacentPiece do |piece|
    moves += piece.class.availableBoardMoves( mosquito ) unless piece.kind_of? Mosquito 
  end
 return moves
end
   

   
end
