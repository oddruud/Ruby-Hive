require 'Insects/piece'
class Ant < Piece

def initialize() 
end
  
def availableMoves(boardState)
  moves = Array.new()
  moves += availablePlaceMoves(boardState)
  antBoardMoves = Array.new()
  moves += traverseBoard(boardState, self , antBoardMoves)  
 return moves
end
   
def traverseBoard(boardState, currentSlot, moves) #todo keep some sort of history
  self.eachEmptyNeighbourSlot(boardState) do |slot|
   unless bottleNeckBetweenSlots(currentSlot, slot)
    unless slot.x == @x && slot.y == @y && slot.z == @z
      moves << Move.new(id,-1,-1){|move| move.setDestinationSlot(slot)}
      traverseBoard(boardState, slot, moves)
    end
   end
  end
  return moves
end  
   
end
