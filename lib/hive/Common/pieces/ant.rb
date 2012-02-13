require 'piece'
class Hive::Ant < Hive::Piece

def initialize(board_state, id)
  super(board_state, id)  
end
  
def available_moves
  moves = Array.new()
  moves += available_place_moves unless used?
  moves += Hive::Ant.available_board_moves( self )  if used? and movable?
 return moves
end
     
def self.available_board_moves( ant ) 
  moves = Array.new()
  ant.touch do
    slots = Set.new()
    Hive::Ant.slide(ant, ant, slots)
    slots.each {|s| moves << Hive::Move.new(ant , s)}
  end
    return moves
end
   
def self.slide( ant, current_slot, slots)
   current_slot.for_each_adjacent_slot do |slot|
   unless slots.include?(slot) || ant.board_position == slot.board_position
   		slots << slot
     	slide(ant, slot, slots)
    break
   end
  end
end  
   
end
