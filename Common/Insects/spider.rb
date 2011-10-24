require 'Insects/piece'
#require 'MoveValidators/SpiderMoveValidator'

class Spider < Piece

def initialize 
   #@validator = SpiderMoveValidator  
end
  
def availableMoves(boardState)
  moves = Array.new()
  moves += availablePlaceMoves(boardState)
  moves += Spider.availableBoardMoves(self, boardState)
 return moves
end

def self.availableBoardMoves(spider, boardState)
 return self.traverseBoard(boardState, spider, spider,nil,0)
end

 #TODO
def self.traverseBoard(boardState, spider, currentSlot, prevSlot, stepCount = 0) #TODO only move one way, check prevslot
  moves = Array.new()
   currentSlot.forEachNeighbouringSlot(boardState, :exclude => [HexagonSide::ONTOP_SIDE, HexagonSide::BOTTOM_SIDE]) do |slot|
    unless prevSlot == slot     
        moves << Move.new(spider.id,-1,-1){|move| move.setDestinationSlot(slot)}     if stepCount == 3  
        moves << traverseBoard(boardState,spider, slot, currentSlot, stepCount += 1)
        break
    end
  end
  return moves
end  

  
end
