class Piece
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

PIECE_NAME= Array.new()
 
PIECE_NAME << "WHITE_QUEEN_BEE"
PIECE_NAME << "WHITE_BEETLE1"
PIECE_NAME << "WHITE_BEETLE2"
PIECE_NAME << "WHITE_SPIDER1" 
PIECE_NAME << "WHITE_SPIDER2"
PIECE_NAME << "WHITE_GRASSHOPPER1" 
PIECE_NAME << "WHITE_GRASSHOPPER2" 
PIECE_NAME << "WHITE_GRASSHOPPER3" 
PIECE_NAME << "WHITE_ANT1"  
PIECE_NAME << "WHITE_ANT2"  
PIECE_NAME << "WHITE_ANT3" 
PIECE_NAME << "BLACK_QUEEN_BEE"
PIECE_NAME << "BLACK_BEETLE1" 
PIECE_NAME << "BLACK_BEETLE2"
PIECE_NAME << "BLACK_SPIDER1"
PIECE_NAME << "BLACK_SPIDER2"
PIECE_NAME << "BLACK_GRASSHOPPER1" 
PIECE_NAME << "BLACK_GRASSHOPPER2"
PIECE_NAME << "BLACK_GRASSHOPPER3"
PIECE_NAME << "BLACK_ANT1"
PIECE_NAME << "BLACK_ANT2"
PIECE_NAME << "BLACK_ANT3"




#SIDE ENUMS
=begin
  [2][3]
  [7][1][4]
    [6][5]
=end 
UPPER_SIDE = 0
TOP_SIDE = 1
TOP_RIGHT_SIDE = 2
BOTTOM_RIGHT_SIDE = 3
BOTTOM_SIDE = 4
BOTTOM_LEFT_SIDE = 5
TOP_LEFT_SIDE = 6

PIECE_SIDE_NAME= Array.new() 
PIECE_SIDE_NAME << "UPPER SIDE"

#properties
attr_accessor :sides
attr_reader :id
attr_accessor :x
attr_accessor :y

def initialize(id)
  @id = id
  @sides= Array.new()
  @sides[UPPER_SIDE]= nil 
  @sides[TOP_SIDE]= nil 
  @sides[TOP_RIGHT_SIDE]= nil
  @sides[BOTTOM_RIGHT_SIDE]= nil
  @sides[BOTTOM_SIDE ]= nil
  @sides[BOTTOM_LEFT_SIDE ]= nil
  @sides[TOP_LEFT_SIDE ]= nil 
end

def copy
  newPiece = self.dup 
  return newPiece
end

def boardPosition
  return [x,y]
end

def detachAll()

end

def detachPiece(piece_id)

end

def availableMoves()
  
end

def isConnectedTo(piece_id)
  @sides.each do |s|
    if piece_id == s
      return true 
    end
  end
  return false
end

def attachPiece(piece_id, side_id)
  if @sides[side_id].nil? 
    @sides[side_id]= piece_id
    return true
  else
    return false
  end
end

end