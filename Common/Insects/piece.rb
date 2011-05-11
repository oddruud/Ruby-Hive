class Piece

#PIECE CONSTANTS: CORRESPOND TO INDICES IN BOARDSTATE ARRAY
WHITE_QUEEN_BEE = 0
WHITE_BEETLE1 = 1
WHITE_BEETLE2 = 2
WHITE_SPIDER1 = 3
WHITE_SPIDER2 = 4
WHITE_GRASSHOPPER1 = 5
WHITE_GRASSHOPPER1 = 6
WHITE_GRASSHOPPER1 = 7
WHITE_ANT1 = 8
WHITE_ANT2 = 9
WHITE_ANT3 = 10
BLACK_QUEEN_BEE = 11
BLACK_BEETLE1 = 12
BLACK_BEETLE2 = 13
BLACK_SPIDER1 = 14
BLACK_SPIDER2 = 15
BLACK_GRASSHOPPER1 = 16
BLACK_GRASSHOPPER1 = 17
BLACK_GRASSHOPPER1 = 18
BLACK_ANT1 = 19
BLACK_ANT2 = 20
BLACK_ANT3 = 21

#properties
attr_reader: slots
attr_reader: id

def initialize(id)
  @id = id
end

def detachAll()

end

def detachPiece(piece)

end

def isConnectedTo(piece)
  slots.each do |s|
    if piece == s
      return true 
    end
  end
  return false
end

def attachPiece(piece, slot)
  if slot[slot].nil? 
    slots[slot]= piece
    return true
  else
    return false
  end
end
