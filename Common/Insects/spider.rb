require 'Insects/piece'
require 'MoveValidators/SpiderMoveValidator'

class Spider < Piece

def initialize 
   @validator = SpiderMoveValidator  
end
  
def availableMoves(boardState)
  moves = Array.new()
  moves += availablePlaceMoves(boardState)
  moves += Spider.availableBoardMoves(self, boardState)
 return moves
end

def self.availableBoardMoves(spider, boardState)
 return self.traverseBoard(boardState, spider,nil,3)
end

 #TODO
def self.traverseBoard(boardState, currentSlot, prevSlot, stepCount) #TODO only move one way, check prevslot
  moves = Array.new()
   currentSlot.forEachNeighbouringSlot(boardState, :exclude => [HexagonSide::ONTOP_SIDE, HexagonSide::BOTTOM_SIDE]) do |slot|
   unless boardState.bottleNeckBetweenSlots(currentSlot, slot) || endSlot == slot || prevSlot == slot
      moves << Move.new(id,-1,-1){|move| move.setDestinationSlot(slot)}
      moves += traverseBoard(boardState, slot, currentSlot)
    break #TODO only go one way..
   end
  end
  return moves
end  

  
end
