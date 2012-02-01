require 'Insects/piece'
class Hive::GrassHopper < Hive::Piece

def initialize(board_state, id)
  super(board_state, id)  
  
end

def availableMoves
  @logger.debug "#{name} collecting moves"
  moves = Array.new()
  moves += availablePlaceMoves unless used?
  @logger.info "grashopper place moves: #{moves.length}"
  moves += Hive::GrassHopper.availableBoardMoves(self) if used? and movable?
  @logger.info "grashopper board moves: #{moves.length}"
 return moves
end

# BLACK_GRASSHOPPER1 moves....
# [08:46:21] INFO-Slot[-1]: grashopper place moves: 0
# [08:46:21] FATAL-GameHandler: move failed: stack level too deep
# /Users/ruudopdenkelder/Projects/Hive-Boardgame-Framework/Common/boardstate.rb:145:in `at'
# /Users/ruudopdenkelder/Projects/Hive-Boardgame-Framework/Common/boardstate.rb:380:in `getSlotAt'
# /Users/ruudopdenkelder/Projects/Hive-Boardgame-Framework/Common/slot.rb:108:in `neighbour'
# /Users/ruudopdenkelder/Projects/Hive-Boardgame-Framework/Common/Insects/grasshopper.rb:34:in `jumpOver'
# /Users/ruudopdenkelder/Projects/Hive-Boardgame-Framework/Common/Insects/grasshopper.rb:35:in `jumpOver'
# /Users/ruudopdenkelder/Projects/Hive-Boardgame-Framework/Common/Insects/grasshopper.rb:24:in `availableBoardMoves'
# [08:46:21] INFO-GameHandler: game stopped: invalid move

def self.availableBoardMoves(grasshopper)
  moves = Array.new() 
  grasshopper.touch do
    grasshopper.forEachAdjacentPiece do |neighbour_piece| 
      side = grasshopper.getSide(neighbour_piece)
      slot = Hive::GrassHopper.jumpOver(grasshopper, side)     #add the position
      moves << Hive::Move.new(grasshopper , slot)
    end
  end
  grasshopper.logger.info "board moves: #{moves.length}"
  return moves
end

def self.jumpOver(current_slot, side)
  return current_slot  if current_slot.value <= Slot::UNCONNECTED
  next_slot = current_slot.neighbour(side)
  puts "^"
  return jumpOver(next_slot, side)  
end

def trapped?
end

  
end