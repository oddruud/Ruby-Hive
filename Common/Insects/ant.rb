require 'Insects/piece'
class Ant < Piece

def initialize() 
end
  
def availableMoves(boardState)
  moves = Array.new()
  moves = moves + availablePlaceMoves(boardState)
 return moves
end
  
end
