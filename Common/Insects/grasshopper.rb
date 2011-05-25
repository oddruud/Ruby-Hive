require 'Insects/piece'
class GrassHopper < Piece

def initialize() 
  
end

def availablePositions(boardState)
 positions = Array.new()
 (1..6).each do |side|                                #iterate over all sides  
   x,y = Slot.neighbour(@x,@y,side)                   # get the x, y coordinates of the neighbour
    if boardState.board[x][y] > -1                    #if there is a piece attached to this side
      positions << jumpOver(x,y,side, boardState)     #add the position
    end
 end
 return positions
end


def jumpOver(x,y,side, boardState)
     if boardState.board[x][y] > -1 
        x,y = Slot.neighbour(x,y,side)
        jumpOver(x,y, side,boardState)  
     else
       return {x, y} 
     end
end

  
end
