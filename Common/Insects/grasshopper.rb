require 'Insects/piece'
class GrassHopper < Piece

def initialize() 
  
end

def availableMoves(boardState)
  @logger.debug "#{name} collecting moves"
  moves = Array.new()
  moves += availablePlaceMoves(boardState) unless @used
  @logger.info "grashopper place moves: #{moves.length}"
  moves += availableBoardMoves(boardState) if @used and movable?(boardState)
  @logger.info "grashopper board moves: #{moves.length}"
 return moves
end


def availableBoardMoves(boardState)
  moves = Array.new() 
   @logger.info "#{self.to_s}"
   forEachNeighbouringPiece(boardState,{:exclude => [HexagonSide::ONTOP_SIDE, HexagonSide::BOTTOM_SIDE], :side => true}) do |piece| 
   side = self.getSide(piece)
   @logger.info "SIDE #{side}"
   x, y = jumpOver(piece.x, piece.y, side, boardState)     #add the position
   moves << Move.new(@id, -1,-1){|move| move.setDestinationCoordinates(piece.x,piece.y,0)}
  end
  return moves
end

def jumpOver(x, y, side, boardState)
  if boardState.board[x][y][0] < 0 
    @logger.info "jump over returns: X: #{x}, Y:#{y}"
    return x, y  
  end
  
  x, y, z = neighbour(side)
  return jumpOver(x, y, side,boardState)  
end

  
end