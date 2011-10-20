require 'Insects/piece'
class Ant < Piece

def initialize() 
end
  
def availableMoves(boardState)
  moves = Array.new()
  moves += availablePlaceMoves( boardState ) unless @used 
  @logger.info "ant place moves: #{moves.length}"
  moves += traverseBoard(boardState, self )  if @used
  @logger.info "ant total moves: #{moves.length}"
 return moves
end
   
def traverseBoard(boardState, currentSlot, prevSlot = nil) #TODO only move one way, check prevslot
  moves = Array.new()
   #@logger.info "current slots: #{currentSlot.x}, #{currentSlot.y}, #{currentSlot.z}: #{currentSlot.value}"
   currentSlot.forEachNeighbouringSlot(boardState, :exclude => [HexagonSide::ONTOP_SIDE, HexagonSide::BOTTOM_SIDE]) do |slot|
   unless boardState.bottleNeckBetweenSlots(currentSlot, slot) || self == slot || prevSlot == slot
     #@logger.info "traverseBoard: #{slot.x}, #{slot.y}, #{slot.z}"
      moves << Move.new(id,-1,-1){|move| move.setDestinationSlot(slot)}
      moves += traverseBoard(boardState, slot, currentSlot)
    break #TODO only go one way..
   end
  end
  @logger.info "return #{moves.length} moves"
  return moves
end  
   
end
