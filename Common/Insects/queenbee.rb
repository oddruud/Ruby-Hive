require 'Insects/piece'
class QueenBee < Piece

def initialize() 
  @validator = QueenBeeMoveValidator  
end
  
def availableMoves(boardState)
 moves= Array.new()
 return moves
end

    
end
