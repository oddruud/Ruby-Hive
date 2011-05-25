require 'Insects/piece'
class Beetle< Piece

def initialize() 
end
  
def availablePositions(boardState)
  positions = Array.new()
  (1..6).each do |side|                                #iterate over all sides  
   x, y = Slot.neighbour(@x,@y,side)                   # get the x, y coordinates of the neighbour
    if boardState.board[x][y] > -1                    #if there is a piece attached to this side
      positions << walkTo(boardState.board[x][y], HexagonSide::getOpposite(side), boardState)     #add the position
    end 
  end
 return positions
end


def walkTo(piece_id, originSide, boardState)
  #from the perspective of the attached piece: 
  
    
  
end
  
  
end
