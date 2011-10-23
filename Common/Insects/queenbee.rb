require 'Insects/piece'
require 'MoveValidators/QueenBeeMoveValidator'
class QueenBee < Piece

def initialize() 
  @validator = QueenBeeMoveValidator  
end
  
def availableMoves(boardState)
  moves = Array.new()
  moves += availablePlaceMoves(boardState) unless @used
  moves += QueenBee.availableBoardMoves(self, boardState) if @used and movable?(boardState) 
 return moves
end

def self.availableBoardMoves(queenbee, boardState)
  moves = Array.new()
   queenbee.forEachNeighbouringSlot(boardState,:exclude => [HexagonSide::ONTOP_SIDE, HexagonSide::BOTTOM_SIDE]) do |slot|    
      moves << Move.new(queenbee.id, -1,-1){|move| move.setDestinationSlot(slot)}
   end  
 return moves
end

    
end
