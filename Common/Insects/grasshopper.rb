require 'Insects/piece'
class GrassHopper < Piece

def initialize(board_state, id)
  super(board_state, id)  
  
end

def availableMoves
  @logger.debug "#{name} collecting moves"
  moves = Array.new()
  moves += availablePlaceMoves unless used?
  @logger.info "grashopper place moves: #{moves.length}"
  moves += GrassHopper.availableBoardMoves(self) if used? and movable?
  @logger.info "grashopper board moves: #{moves.length}"
 return moves
end

def self.availableBoardMoves(grasshopper)
  moves = Array.new() 
  grasshopper.touch do
    grasshopper.forEachAdjacentPiece do |neighbour_piece| 
      side = grasshopper.getSide(neighbour_piece)
      slot = GrassHopper.jumpOver(grasshopper, side)     #add the position
      moves << Move.new(grasshopper , slot)
    end
  end
  return moves
end

def self.jumpOver(current_slot, side)
  return current_slot  if current_slot.value <= Slot::UNCONNECTED
  next_slot = current_slot.neighbour(side)
  return jumpOver(next_slot, side)  
end

def trapped?
end

  
end