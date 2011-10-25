require 'Insects/piece'
class Ant < Piece

def initialize() 
end
  
def availableMoves(boardState)
  moves = Array.new()
  moves += availablePlaceMoves( boardState ) unless @used 
  @logger.info "ant place moves: #{moves.length}"
  moves += Ant.availableBoardMoves(self, boardState)  if @used
  @logger.info "ant total moves: #{moves.length}"
 return moves
end
     
def self.availableBoardMoves(ant, boardState) 
 return Ant.traverseBoard(boardState,ant, ant, ant)
end
   
 #TODO
def self.traverseBoard(boardState, ant, currentSlot, endSlot, prevSlot = nil) #TODO only move one way, check prevslot
  moves = Array.new()
   currentSlot.forEachNeighbouringSlot(boardState, :exclude => [HexagonSide::ONTOP_SIDE, HexagonSide::BOTTOM_SIDE]) do |slot|
   unless endSlot == slot || prevSlot == slot
      moves << Move.new(ant.id, slot)
      moves += traverseBoard(boardState, ant, slot, currentSlot)
    break
   end
  end
  return moves
end  
   
end
