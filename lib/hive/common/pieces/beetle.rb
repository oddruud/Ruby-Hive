require 'piece'
class Hive::Beetle < Hive::Piece

def initialize(board_state, id)
  super(board_state, id)  
end
 
def available_moves
  moves = Array.new()
  moves += available_place_moves unless used?
  moves +=  Hive::Beetle.available_board_moves(self) if used? and movable?
 return moves
end 
 
def self.available_board_moves( beetle )
  moves = Array.new()
  beetle.touch do
      beetle.for_each_multi_z_level_slot do |slot|          
      moves << Hive::Move.new( beetle , slot )
   end  
 end
 #beetle.logger.info "board moves: #{moves.length}"
 return moves
end

def trapped?
  return false
end
  
end