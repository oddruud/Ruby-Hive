require 'piece'
class Hive::GrassHopper < Hive::Piece

def initialize(board_state, id)
  super(board_state, id)  
  
end

def available_moves
  #@logger.debug "#{name} collecting moves"
  moves = Array.new()
  moves += available_place_moves unless used?
  #@logger.info "grashopper place moves: #{moves.length}"
  moves += Hive::GrassHopper.available_board_moves(self) if used? and movable?
  #@logger.info "grashopper board moves: #{moves.length}"
 return moves
end

def self.available_board_moves(grasshopper)
  moves = Array.new() 
  grasshopper.touch do
    grasshopper.for_each_adjacent_piece do |neighbour_piece| 
      side = grasshopper.get_side(neighbour_piece)
      slot = Hive::GrassHopper.jump_over(grasshopper.neighbour(side), side)     #add the position
      moves << Hive::Move.new(grasshopper , slot)
    end
  end
  #grasshopper.logger.info "board moves: #{moves.length}"
  return moves
end

def self.jump_over(current_slot, side)
  if current_slot.empty?
    return current_slot 
  end
   
  next_slot = current_slot.neighbour(side)
  return jump_over(next_slot, side)  
end

def trapped?
end

  
end