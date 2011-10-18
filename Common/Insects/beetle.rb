require 'Insects/piece'
class Beetle < Piece

def initialize() 
end
 
def availableMoves(boardState)
  moves = Array.new()
  moves += availablePlaceMoves(boardState) #unless @used
  #moves += availableBoardMoves(boardState) if @used and movable?(boardState) 
 return moves
end 
 
#TODO fix! what if beetle is ontop?
def availableBoardMoves(boardState)
  moves = Array.new()
   forEachNeighbour(:exclude => [HexagonSide::ONTOP_SIDE, HexagonSide::BOTTOM_SIDE]) do |x,y,z|
      if boardState[x][y][z] > -1 #neighbouring piece for the beetle to jump on top of
        unless x == @x && y == @y                      #not self
          moves << Move.new(@id, -1,-1){|move| move.setDestinationSlot( Slot.new(x,y, 1) ) }
        end
      elsif boardState[x][y][z] < -1
        moves << Move.new(@id, -1,-1){|move| move.setDestinationSlot( Slot.new(x,y,z) ) } 
      end
   end  
 return positions
end
  
end