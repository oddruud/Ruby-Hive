require 'Insects/piece'
class Mosquito < Piece

def initialize() 
end
  
def availableMoves(boardState)
  moves = Array.new()
  moves += availablePlaceMoves( boardState ) unless @used 
  moves += Mosquito.availableBoardMoves(self, boardState)  if @used
 return moves
end
     
def self.availableBoardMoves(mosquito, boardState) 
 return []
end
   

   
end
