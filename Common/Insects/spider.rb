require 'Insects/piece'
require 'MoveValidators/SpiderMoveValidator'

class Spider < Piece

def initialize 
   @validator = SpiderMoveValidator  
end
  
  
def availableMoves(boardState)
 moves= Array.new()
 return moves
end

  
end
