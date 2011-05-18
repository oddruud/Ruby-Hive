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

#properties
attr_accessor :sides
attr_reader :id
attr_accessor :boardState

def initialize(id, boardState)
  @id = id
  @sides= Hash.new()
  @sides[0]= nil #TOP SIDE 
  @sides[1]= nil #RIGHT TO TOP SIDE
  @sides[2]= nil
  @sides[3]= nil
  @sides[4]= nil
  @sides[5]= nil
  @sides[6]= nil #UPPER SIDE
  @boardState= boardState
end

def copy
  newPiece = self.dup 
  return newPiece
end


def detachAll()

end

def detachPiece(piece)

end

def availableMoves()
  
end

def isConnectedTo(piece)
  @sides.each do |s|
    if piece == s
      return true 
    end
  end
  return false
end

def attachPiece(piece, side)
  if @sides[side].nil? 
    @sides[side]= piece
    return true
  else
    return false
  end
end

end