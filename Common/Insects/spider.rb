require 'Insects/piece'
#require 'MoveValidators/SpiderMoveValidator'

class Spider < Piece

def initialize(board_state, id)
  super(board_state, id)  
   #@validator = SpiderMoveValidator  
end
  
def availableMoves
  moves = Array.new()
  moves += availablePlaceMoves
  moves += Spider.availableBoardMoves(self)
 return moves
end

def self.availableBoardMoves( spider )
  result_moves = Array.new()
  #@board_state.pickUpPiece(spider)
  spider.touch { self.traverseBoard(spider, spider,nil,0, result_moves) }
  #@board_state.dropPiece(spider)
  return result_moves
end

 #TODO
def self.traverseBoard( spider, currentSlot, prevSlot, stepCount, result_moves ) #TODO only move one way, check prevslot
   currentSlot.forEachAdjacentSlot do |neighbour_slot|
     unless prevSlot == neighbour_slot     
        if stepCount == 0
          puts "neighbour slot: #{neighbour_slot}" 
          result_moves << Move.new(spider.id, neighbour_slot)  
        else
          stepCount += 1
          traverseBoard(spider, neighbour_slot, currentSlot, stepCount, result_moves)
        end
    end
  end
end  

  
end
