require 'Insects/piece'
#require 'MoveValidators/SpiderMoveValidator'

class Hive::Spider < Hive::Piece

def initialize(board_state, id)
  super(board_state, id)  
   #@validator = SpiderMoveValidator  
end
  
def availableMoves
  moves = Array.new()
  moves += availablePlaceMoves unless used?
  moves += Hive::Spider.availableBoardMoves(self) if used? and movable?
 return moves
end

def self.availableBoardMoves( spider )
  moves = []
  spider.touch do
    self.traverseBoard(spider, spider,nil,0, moves)
  end 
  spider.logger.info "board moves: #{moves.length}"
  return moves
end

 #TODO
def self.traverseBoard( spider, currentSlot, prevSlot, stepCount, result_moves ) #TODO only move one way, check prevslot
   currentSlot.forEachAdjacentSlot do |neighbour_slot|
     unless prevSlot == neighbour_slot     
        if stepCount == 0
          puts "neighbour slot: #{neighbour_slot}" 
          result_moves << Hive::Move.new(spider , neighbour_slot)  
        else
          stepCount += 1
          traverseBoard(spider, neighbour_slot, currentSlot, stepCount, result_moves)
        end
    end
  end
end  

  
end
