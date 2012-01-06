require 'Insects/piece'
class Ant < Piece

def initialize() 
end
  
def availableMoves(boardState)
  moves = Array.new()
  moves += availablePlaceMoves( boardState ) unless @used 
  @logger.info "ant place moves: #{moves.length}"
  if @used
  	boardmoves = Ant.availableBoardMoves(self, boardState)
  	moves += boardmoves
  	@logger.info "ant board moves: #{boardmoves.length}"
  end
 return moves
end
     
def self.availableBoardMoves(ant, boardState) 
    Ant.slide(boardState,ant, ant, ant)
end
   
 #TODO
def self.slide(boardState, ant, currentSlot, endSlot, prevSlot = nil) #TODO only move one way, check prevslot
  moves = Array.new()
   currentSlot.forEachAdjacentSlot(boardState) do |slot|
   unless endSlot == slot || prevSlot == slot #|| moves.each{|move| return move.dest_slot == slot}
      moves << Move.new(ant.id, slot)
      moves += slide(boardState, ant, slot, currentSlot)
    break
   end
  end
  return moves
end  
   
end
