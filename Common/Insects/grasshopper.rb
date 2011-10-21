require 'Insects/piece'
class GrassHopper < Piece

def initialize() 
  
end

def availableMoves(boardState)
  @logger.debug "#{name} collecting moves"
  moves = Array.new()
  moves += availablePlaceMoves(boardState) unless @used
  @logger.info "grashopper place moves: #{moves.length}"
  moves += GrassHopper.availableBoardMoves(self, boardState) if @used and movable?(boardState)
  @logger.info "grashopper board moves: #{moves.length}"
 return moves
end

def self.availableBoardMoves(grassHopper, boardState)
  moves = Array.new() 
   grassHopper.forEachNeighbouringPiece(boardState,{:exclude => [HexagonSide::ONTOP_SIDE, HexagonSide::BOTTOM_SIDE], :side => true}) do |neighbour_piece| 
   side = grassHopper.getSide(neighbour_piece)
   slot = GrassHopper.jumpOver(grassHopper, side, boardState)     #add the position
   moves << Move.new(@id, -1,-1){|move| move.setDestinationSlot(slot)}
  end
  return moves
end

def self.jumpOver(currentSlot, side, boardState)
  return currentSlot  if currentSlot.value < 0
  x, y, z = currentSlot.neighbour(side)
  nextSlot = boardState.getSlotAt(x,y,z)
  return jumpOver(nextSlot, side, boardState)  
end

  
end