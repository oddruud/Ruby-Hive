require 'slot'

class PieceColor
  NONE= :none
  BLACK= :black
  WHITE= :white 
  COLORS = [WHITE, BLACK]
  
  def self.opposingColor color
    case color
      when BLACK then
        return WHITE
      when WHITE then
        return BLACK   
    end
  end
  
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
WHITE_MOSQUITO = 11 
BLACK_QUEEN_BEE = 12
BLACK_BEETLE1 = 13
BLACK_BEETLE2 = 14
BLACK_SPIDER1 = 15
BLACK_SPIDER2 = 16
BLACK_GRASSHOPPER1 = 17
BLACK_GRASSHOPPER2 = 18
BLACK_GRASSHOPPER3 = 19
BLACK_ANT1 = 20
BLACK_ANT2 = 21
BLACK_ANT3 = 22
BLACK_MOSQUITO = 23

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
NAME << "WHITE_MOSQUITO" 
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
NAME << "BLACK_MOSQUITO"

#SIDE ENUMS
=begin
  [2][3]
  [7][1][4]
    [6][5]
=end 


#properties
#attr_accessor :sides
attr_accessor :validator
attr_reader :used
attr_reader :logger
attr_reader :id

def initialize()
  super -1,-1,-1
  @used = false 
  if block_given?
    yield self
  end
end

def setId(id)
  @id = id
  @logger = LoggerCreator.createLoggerForClassObject(Piece, NAME[@id]) 
end

def name
  NAME[@id]
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

def validMove?(boardState, move)
  if validator.nil?
    @logger.info "#{self} does not have a validator, FIX THIS!"
    return true
  end
  return validator.validate(boardState, move)
end

def movable?(boardstate) 
  return true #!@used
  
  # a piece is not movable when
  #- removing the piece results in disconnecting the string of pieces. 
 
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

def secondMoves(boardState)
 openSlots = Array.new()
 if boardState.moveCount == 1 #if this is the second move to be made, you can connect to the opposing color 
  
    opposingSlotType =  Piece.colorToSlotType(PieceColor.opposingColor(color))
    openSlots = openSlots +  boardState.getSlotsWithTypeCode(opposingSlotType) 
     @logger.debug "collecting second moves...#{openSlots.length} slots"
    openSlots.each do |slot|
        @logger.info slot.to_s
     end
 end
 return openSlots
end

#the moves available if the piece is not yet on the board
def availablePlaceMoves(boardState)
 moves = Array.new()
 openSlots = Array.new()
 #@logger.info "collecting moves..."
 openSlots << boardState.startSlot if not boardState.movesMade? #FIRST MOVE
 openSlots += secondMoves(boardState)                           #2nd MOVE

 unless @used                                                   #Nth MOVE
    emptySlotType =  Piece.colorToSlotType(color)
    openSlots = openSlots +  boardState.getSlotsWithTypeCode(emptySlotType)  
 end
 
 #@logger.info  "NUM open slots: #{openSlots.length}"
 
 openSlots.delete_if{|slot| slot.z == 1} #only allow slots on the lower level  
 openSlots.each do |slot|
  move = Move.new(id, -1,-1){|move| move.setDestinationSlot(slot)}
  moves = moves + [move]
 end
 
 return moves
end

def self.colorToSlotType(color)
    whiteN = color == PieceColor::WHITE ? :Neighbour : :NotANeighbour
    blackN = color == PieceColor::BLACK ? :Neighbour : :NotANeighbour
    return Slot.slotState(whiteN, blackN) 
end 

def value 
  return @id
end 

def to_s
  unless @x.nil?
  if not @x < 0 
    return "<#{NAME[@id]} (x: #{@x},y: #{@y}, z: #{@z})}>"
  end
  end
  
  return "<#{NAME[@id]}>"
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