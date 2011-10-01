require 'Insects/piece'
require 'MoveValidators/QueenBeeMoveValidator'
class QueenBee < Piece

def initialize() 
  @validator = QueenBeeMoveValidator  
end
  
def availableMoves(boardState)
 moves= Array.new()
 return moves
end

    
end
