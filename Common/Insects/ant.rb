require 'Insects/piece'
class Ant < Piece

def initialize(board_state, id)
  super(board_state, id)  
end
  
def availableMoves
  moves = Array.new()
  moves += availablePlaceMoves unless used? 
  @logger.info "ant place moves: #{moves.length}"
  if used? and movable?
  	boardmoves = Ant.availableBoardMoves( self )
  	moves += boardmoves
  	@logger.info "#{self} board moves: #{boardmoves.length}"
  end
 return moves
end
     
def self.availableBoardMoves( ant ) 
    Ant.slide(ant, ant, ant)
end
   
 #TODO
def self.slide( ant, current_slot, end_slot, prev_slot = nil ) #TODO only move one way, check prevslot
  moves = Array.new()
   current_slot.forEachAdjacentSlot do |slot|
   unless end_slot == slot || prev_slot == slot #|| moves.each{|move| return move.dest_slot == slot}
      moves << Move.new(ant.id, slot)
      moves += slide(ant, slot, current_slot)
    break
   end
  end
  return moves
end  
   
end
