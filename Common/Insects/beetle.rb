require 'Insects/piece'
class Beetle < Piece

def initialize() 
end
 
def availableMoves(boardState)
  moves = Array.new()
  moves += availablePlaceMoves(boardState) unless @used
  moves += Beetle.availableBoardMoves(self,boardState) if @used and movable?(boardState) 
 return moves
end 
 
#TODO fix! what if beetle is ontop? handle beetle stacking
def self.availableBoardMoves(beetle, boardState)
  moves = Array.new()
   beetle.forEachNeighbour(:exclude => [HexagonSide::ONTOP_SIDE, HexagonSide::UNDER_SIDE]) do |x,y|
      numPieces = boardState.getNumPiecesAt(x, y)          
      moves << Move.fromCords(beetle.id, x,y, numPieces )
   end  
 return moves
end
  
end