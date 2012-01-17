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

#properties
#attr_accessor :sides
attr_accessor :validator
attr_reader :used
attr_reader :logger
attr_reader :id

def initialize(board_state, id)
  super(board_state)
  @x, @y, @z= -1, -1, -1
  @used = false 
  @id = id
  @logger = LoggerCreator.createLoggerForClassObject(Piece, NAME[@id]) 
  yield self if block_given?
end

def setId(id)
  @id = id
  @logger.setName(Piece, NAME[@id]) 
end

def self.nameById(id)
  return NAME[id]
end

def name
  Piece.nameById(@id)
end 

def used?
	@used
end 

def self.colorById(id) 
  if id <  NAME.length/2
    return PieceColor::WHITE
  else
    return PieceColor::BLACK
  end
 end


def copy
  newPiece = self.dup 
  return newPiece
end

def pickup
  @board_state.pickUpPiece(self)
end

def drop
  @board_state.dropPiece(self)
end

def touch
  pickup()
  yield
  drop()
end 


def validMove?(move)
  if validator.nil?
    @logger.info "#{self} does not have a validator, FIX THIS!"
    return true
  end
  return validator.validate(@boardState, move)
end

def color
  return Piece.colorById(@id)
end

def toString
  return self.name[id]
end

def secondMoves
 openSlots = Array.new()
 if @board_state.moveCount == 1 #if this is the second move to be made, you can connect to the opposing color 
  
    opposingSlotType =  Piece.colorToSlotType(PieceColor.opposingColor(color))
    openSlots = openSlots +  @board_state.getSlotsWithTypeCode(opposingSlotType) 
     @logger.debug "collecting second moves...#{openSlots.length} slots"
    openSlots.each do |slot|
        @logger.info slot.to_s
     end
 end
 return openSlots
end

#the moves available if the piece is not yet on the board
def availablePlaceMoves
 moves = Array.new()
 openSlots = Array.new()
 #@logger.info "collecting moves..."
 openSlots << @board_state.startSlot if not @board_state.movesMade? #FIRST MOVE
 openSlots += secondMoves                           #2nd MOVE

 unless @used                                                   #Nth MOVE
    emptySlotType =  Piece.colorToSlotType(color)
    openSlots = openSlots +  @board_state.getSlotsWithTypeCode(emptySlotType)  
 end
 
 #@logger.info  "NUM open slots: #{openSlots.length}"
 
 openSlots.delete_if{|slot| slot.z == 1} #only allow slots on the lower level  
 openSlots.each do |slot|
  move = Move.new(id, slot)
  moves = moves + [move]
 end
 
 return moves
end

def self.colorToSlotType(color)
    whiteN = color == PieceColor::WHITE ? :Neighbour : :NotANeighbour
    blackN = color == PieceColor::BLACK ? :Neighbour : :NotANeighbour
    return Slot.slotState(whiteN, blackN) 
end 

#TODO lock check
def locked?
  return true if trapped?
  pickup()
  result = @board_state.valid?
  drop()
  return result
end

#TODO
def trapped?
  return false
end

def movable?
  return !locked? 
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

def ==(piece)
  return piece.x == @x && piece.y == @y && piece.z == @z && piece.id == @id
end

def ===(piece)
  return @object_id == piece.object_id
end

end