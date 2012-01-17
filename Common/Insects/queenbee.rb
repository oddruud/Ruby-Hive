require 'Insects/piece'
#require 'MoveValidators/QueenBeeMoveValidator'
class QueenBee < Piece

def initialize(board_state, id)
  super(board_state, id) 
  #@validator = QueenBeeMoveValidator  
end
  
def availableMoves
  moves = Array.new()
  moves += availablePlaceMoves unless used?
  moves += QueenBee.availableBoardMoves( self ) if used? and movable?
 return moves
end

def self.availableBoardMoves(queenbee)
  moves = Array.new()
   queenbee.forEachAdjacentSlot do |slot|    
      moves << Move.new(queenbee.id, slot)
   end  
 return moves
end

    
end
