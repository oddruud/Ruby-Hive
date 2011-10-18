require 'Insects/piece'
class Ant < Piece

def initialize() 
end
  
def availableMoves(boardState)
  moves = Array.new()
  moves += availablePlaceMoves( boardState ) unless @used 
  moves += traverseBoard(boardState, self )  if @used
 return moves
end
   
def traverseBoard(boardState, currentSlot) #TODO keep some sort of history and let ant move one way only
  moves = Array.new()
  self.eachEmptyNeighbourSlot(boardState) do |slot|
   unless boardState.bottleNeckBetweenSlots(currentSlot, slot)
    unless slot.x == @x && slot.y == @y && slot.z == @z
      moves << Move.new(id,-1,-1){|move| move.setDestinationSlot(slot)}
      moves += traverseBoard(boardState, slot)
    end
    break #TODO only go one way..
   end
  end
  return moves
end  
   
end
