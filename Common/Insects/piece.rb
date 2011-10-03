require 'slot'

class PieceColor
  BLACK=0
  WHITE=1
end



class Piece < Slot
#PIECE CONSTANTS: CORRESPOND TO INDICES IN BOARDSTATE ARRAY
WHITE_QUEEN_BEE = 0
WHITE_BEETLE1 = 1
WHITE_BEETLE2 = 2
WHITE_SPIDER1 = 3
WHITE_SPIDER2 = 4
WHITE_GRASSHOPPER1 = 5
WHITE_GRASSHOPPER2 = 6
WHITE_GRASSHOPPER3 = 7
WHITE_ANT1 = 8
WHITE_ANT2 = 9
WHITE_ANT3 = 10
BLACK_QUEEN_BEE = 11
BLACK_BEETLE1 = 12
BLACK_BEETLE2 = 13
BLACK_SPIDER1 = 14
BLACK_SPIDER2 = 15
BLACK_GRASSHOPPER1 = 16
BLACK_GRASSHOPPER2 = 17
BLACK_GRASSHOPPER3 = 18
BLACK_ANT1 = 19
BLACK_ANT2 = 20
BLACK_ANT3 = 21

NAME= Array.new() 
NAME << "WHITE_QUEEN_BEE"
NAME << "WHITE_BEETLE1"
NAME << "WHITE_BEETLE2"
NAME << "WHITE_SPIDER1" 
NAME << "WHITE_SPIDER2"
NAME << "WHITE_GRASSHOPPER1" 
NAME << "WHITE_GRASSHOPPER2" 
NAME << "WHITE_GRASSHOPPER3" 
NAME << "WHITE_ANT1"  
NAME << "WHITE_ANT2"  
NAME << "WHITE_ANT3" 
NAME << "BLACK_QUEEN_BEE"
NAME << "BLACK_BEETLE1" 
NAME << "BLACK_BEETLE2"
NAME << "BLACK_SPIDER1"
NAME << "BLACK_SPIDER2"
NAME << "BLACK_GRASSHOPPER1" 
NAME << "BLACK_GRASSHOPPER2"
NAME << "BLACK_GRASSHOPPER3"
NAME << "BLACK_ANT1"
NAME << "BLACK_ANT2"
NAME << "BLACK_ANT3"

#SIDE ENUMS
=begin
  [2][3]
  [7][1][4]
    [6][5]
=end 


#properties
#attr_accessor :sides
attr_accessor :id
attr_accessor :validator
attr_reader :used

def initialize()
  super -1,-1
  @used = false 
end

def self.colorById(id) 
  if id <  11
    return PieceColor::WHITE
  else
    return PieceColor::BLACK
  end
 end


def copy
  newPiece = self.dup 
  return newPiece
end



def color
  return Piece.colorById(@id)
end

def toString
  return self.name[id]
end
#SIDE ENUMS
=begin
    2
7     3
   1   
6     4
   5
   
  [2][3]
  [7][1][4]
    [6][5]
=end 

#def neighbour(side)
#  return Slot.neighbour(@x,@y,side)
#end

#def forEachNeighbour
#  Slot.forEachNeighbour @x,@y
#end

def availableMoves(boardState)
 return nil
end



=begin
def detachAll()

end

def detachPiece(piece_id)

end

=end

=begin
def isConnectedTo(piece_id)
  @sides.each do |s|
    if piece_id == s
      return true 
    end
  end
  return false
end
=end

=begin
def attachPiece(piece_id, side_id)
  if @sides[side_id].nil? 
    @sides[side_id]= piece_id
    return true
  else
    return false
  end
end
=end

end