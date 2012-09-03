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


# [13:20:17] FATAL-Hive::Game[70178027383040]: move failed: null slot x=-1,y=-1,z=-1
# /Users/ruudopdenkelder/Projects/Ruby-Hive/lib/hive/common/boardstate.rb:158:in `at'
# /Users/ruudopdenkelder/Projects/Ruby-Hive/lib/hive/common/boardstate.rb:393:in `get_slot_at'
# /Users/ruudopdenkelder/Projects/Ruby-Hive/lib/hive/common/slot.rb:137:in `neighbour'
# /Users/ruudopdenkelder/Projects/Ruby-Hive/lib/hive/common/pieces/grasshopper.rb:24:in `block (2 levels) in available_board_moves'
# /Users/ruudopdenkelder/Projects/Ruby-Hive/lib/hive/common/slot.rb:237:in `block in for_each_adjacent_piece'
# /Users/ruudopdenkelder/Projects/Ruby-Hive/lib/hive/common/slot.rb:189:in `block in for_each_neighbour_coordinate'
# [13:20:17] INFO-Hive::Game[70178027383040]: game stopped: invalid move

def self.available_board_moves(grasshopper)
  moves = Array.new() 
  grasshopper.touch do
    grasshopper.for_each_adjacent_piece do |neighbour, side| 
      side = grasshopper.get_side( neighbour )
      unless side == Hive::HexagonSide::NULL_SIDE 
        slot = Hive::GrassHopper.jump_over(grasshopper.neighbour(side), side)     #add the position
        moves << Hive::Move.new(grasshopper , slot)
      end   
    end
  end
  #grasshopper.logger.info "board moves: #{moves.length}"
  return moves
end

def self.jump_over(current_slot, side)
  if current_slot.empty?
    return current_slot 
  end
   
  next_slot = current_slot.neighbour( side )
  return jump_over(next_slot, side)  
end

def trapped?
end

  
end