require 'Insects/piece'
class GrassHopper < Piece

def initialize() 
  
end

def availableMoves(boardState)
  @logger.debug "#{name} collecting moves"
  moves = Array.new()
  moves += availablePlaceMoves(boardState) #unless @used
  #moves += avaliableBoardMoves(boardState) if @used and movable?(boardState)
 return moves
end


def availableBoardMoves(boardState)
  moves = Array.new() 
  forEachNeighbour({:exclude => [HexagonSide::ONTOP_SIDE, HexagonSide::BOTTOM_SIDE], :side => true}) do |x, y, z, side| 
    x, y = jumpOver(x, y, side, boardState)     #add the position
    moves << Move.new(@id, -1,-1){|move| move.setDestinationCoordinates(x,y,0)}
  end
  return moves
end


def jumpOver(x, y, side, boardState)
  if boardState.board[x][y][0] > -1 
    x, y, z = neighbour(side)
    endX, endY = jumpOver(x,y, side,boardState)  
  end
     return endX, endY 
end

  
end