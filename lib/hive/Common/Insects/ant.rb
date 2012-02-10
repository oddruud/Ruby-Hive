require 'Insects/piece'
class Hive::Ant < Hive::Piece

def initialize(board_state, id)
  super(board_state, id)  
end
  
def available_moves
  moves = Array.new()
  moves += available_place_moves unless used? 
  if used? and movable?
  	#boardmoves =  Hive::Ant.available_board_moves( self ) 
  	#moves += boardmoves
  	#@logger.info "#{self} board moves: #{boardmoves.length}"
  end
 return moves
end
     
def self.available_board_moves( ant ) 
  moves = Array.new()
  ant.touch do
    marked_slots = Set.new([ant])
    Ant.slide(ant, ant, marked_slots, moves)
  end
    return moves
end
   
 #TODO
def self.slide( ant, current_slot, marked_slots, moves) #TODO only move one way, check prevslot
   current_slot.for_each_adjacent_slot do |slot|
   unless marked_slots.include?(slot)
      moves << Hive::Move.new(ant , slot)
      slide(ant, slot, marked_slots, moves)
    break
   end
  end
end  
   
end
