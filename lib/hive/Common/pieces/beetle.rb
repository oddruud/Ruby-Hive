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
 
#TODO fix! what if beetle is ontop? handle beetle stacking
def self.available_board_moves( beetle )
  moves = Array.new()
  beetle.touch do
    board_state = beetle.get_board
    beetle.for_each_neighbouring_slot_or_piece do |slot|
      num_pieces = board_state.get_num_pieces_at(slot.x, slot.y)          
      moves << Hive::Move.from_cords(beetle , slot.x, slot.y, num_pieces )
   end  
 end
 beetle.logger.info "board moves: #{moves.length}"
 return moves
end

def trapped?
  return false
end
  
end