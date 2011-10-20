require 'Insects/piece'
class Ant < Piece

def initialize() 
end
  
def availableMoves(boardState)
  moves = Array.new()
  moves += availablePlaceMoves( boardState ) unless @used 
  @logger.info "before traverse: #{self.to_s}"
  moves += traverseBoard(boardState, self )  if @used
 return moves
end
   
def traverseBoard(boardState, currentSlot) #TODO keep some sort of history and let ant move one way only
  moves = Array.new()
   @logger.info "current slots: #{currentSlot.x}, #{currentSlot.y}, #{currentSlot.z}: #{currentSlot.value}"
  self.forEachNeighbouringSlot(boardState, :exclude => [HexagonSide::ONTOP_SIDE, HexagonSide::BOTTOM_SIDE]) do |slot|
   unless boardState.bottleNeckBetweenSlots(currentSlot, slot) || slot.x == @x && slot.y == @y && slot.z == @z
     @logger.info "traverseBoard: #{slot.x}, #{slot.y}, #{slot.z}"
      moves << Move.new(id,-1,-1){|move| move.setDestinationSlot(slot)}
      moves += traverseBoard(boardState, slot)
    break #TODO only go one way..
   end
  end
  @logger.info "return #{moves.inspect}"
  return moves
end  
   
end
