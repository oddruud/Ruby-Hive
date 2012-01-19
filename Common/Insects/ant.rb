require 'Insects/piece'
class Ant < Piece

def initialize(board_state, id)
  super(board_state, id)  
end
  
def availableMoves
  moves = Array.new()
  moves += availablePlaceMoves unless used? 
  if used? and movable?
  	#boardmoves =  Ant.availableBoardMoves( self ) 
  	#moves += boardmoves
  	#@logger.info "#{self} board moves: #{boardmoves.length}"
  end
 return moves
end
     
def self.availableBoardMoves( ant ) 
  moves = Array.new()
  ant.touch do
    marked_slots = Set.new([ant])
    Ant.slide(ant, ant, marked_slots, moves)
  end
    return moves
end
   
 #TODO
def self.slide( ant, current_slot, marked_slots, moves) #TODO only move one way, check prevslot
   current_slot.forEachAdjacentSlot do |slot|
   unless marked_slots.include?(slot)
      moves << Move.new(ant , slot)
      slide(ant, slot, marked_slots, moves)
    break
   end
  end
end  
   
end
