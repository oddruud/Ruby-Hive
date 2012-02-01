require 'slot'

class Hive::PieceColor
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



class Hive::Piece < Hive::Slot
  
QUEEN_BEE = 0
BEETLE1 = 1
BEETLE2 = 2
SPIDER1 = 3
SPIDER2 = 4
GRASSHOPPER1 = 5
GRASSHOPPER2 = 6
GRASSHOPPER3 = 7
ANT1 = 8
ANT2 = 9
ANT3 = 10
MOSQUITO = 11  
LADYBUG = 12  
  
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
WHITE_LADYBUG = 12 

BLACK_QUEEN_BEE = 13
BLACK_BEETLE1 = 14
BLACK_BEETLE2 = 15
BLACK_SPIDER1 = 16
BLACK_SPIDER2 = 17
BLACK_GRASSHOPPER1 = 18
BLACK_GRASSHOPPER2 = 19
BLACK_GRASSHOPPER3 = 20
BLACK_ANT1 = 21
BLACK_ANT2 = 22
BLACK_ANT3 = 23
BLACK_MOSQUITO = 24
BLACK_LADYBUG = 25
PIECE_RANGE = WHITE_QUEEN_BEE..BLACK_LADYBUG

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
NAME << "WHITE_LADYBUG" 
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
NAME << "BLACK_LADYBUG"

#properties
#attr_accessor :sides
attr_accessor :validator
attr_accessor :used
attr_reader :logger
attr_reader :insect_id

attr_accessor :pickup_count

def initialize(board_state, id)
  super(board_state)
  setId(id)
  @x, @y, @z = -1, -1, -1
  @used = false 
  @pickup_count = 0 
  yield self if block_given?
end

def id 
  return @insect_id
end

def setBoardPosition(x, y, z) 
  @x,@y,@z = x, y, z
end

def self.piece_id_range
  return Hive::Piece::PIECE_RANGE
end

def self.valid_id?(id)
  return Hive::Piece.piece_id_range.include?(id)
end

def setId(insect_id)
  raise "invalid id: #{id}" unless Hive::Piece.valid_id?(insect_id)
  
  @insect_id = insect_id
  
  if @logger.nil?
     @logger = LoggerCreator.createLoggerForClassObject(Hive::Piece, NAME[@insect_id] )
  else
     @logger.setName( Hive::Piece , NAME[@insect_id] ) 
  end
end

def self.nameById(id)
  return NAME[id]
end

def name
  Hive::Piece.nameById(id)
end 

def used?
	@used
end 

def self.colorById(id) 
  if id <  NAME.length/2
    return Hive::PieceColor::WHITE
  else
    return Hive::PieceColor::BLACK
  end
 end


def copy
  newPiece = self.dup 
  return newPiece
end

def pickup
  @board_state.pickupPiece(self)
end

def drop
  @board_state.dropPiece(self)
end

def touch
  pickup
  yield
  drop
end 


def validMove?(move)
  if validator.nil?
    @logger.info "#{self} does not have a validator, FIX THIS!"
    return true
  end
  return validator.validate(@boardState, move)
end

def color
  return Hive::Piece.colorById(id)
end

def toString
  return self.name[id]
end

def secondMoves
 openSlots = Array.new()
 if @board_state.moveCount == 1 #if this is the second move to be made, you can connect to the opposing color 
    opposingSlotType =  Hive::Piece.colorToSlotType(PieceColor.opposingColor(color))
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
 openSlots << @board_state.start_slot if not @board_state.movesMade? #FIRST MOVE
 openSlots += secondMoves                           #2nd MOVE

 unless @used                                                   #Nth MOVE
    emptySlotType =  Hive::Piece.colorToSlotType(color)
    openSlots = openSlots +  @board_state.getSlotsWithTypeCode(emptySlotType)  
 end
 
 #@logger.info  "NUM open slots: #{openSlots.length}"
 openSlots.delete_if{|slot| slot.z == 1} #only allow slots on the lower level  
 openSlots.each do |slot|
   raise "bla bla: #{@insect_id}" unless Hive::Piece.valid_id?(@insect_id)
  move = Hive::Move.new(self, slot)
  moves = moves + [move]
 end
 
 return moves
end

def self.colorToSlotType(color)
    whiteN = color == Hive::PieceColor::WHITE ? :Neighbour : :NotANeighbour
    blackN = color == Hive::PieceColor::BLACK ? :Neighbour : :NotANeighbour
    return Hive::Slot.slotState(whiteN, blackN) 
end 

#TODO lock check
def locked?
  return true if trapped?
  pickup
    result = @board_state.valid?
  drop
  return result
end

#TODO
def trapped?
  return false
end

def movable?
  return locked? ? false : true 
end

def value 
  return @insect_id
end 

def to_s
  return "<#{NAME[id]} ON BOARD: (x: #{@x},y: #{@y}, z: #{@z})}>" if used?
  return "<#{NAME[id]} IN STACK>"
end

def ==(piece)
  return piece.x == @x && piece.y == @y && piece.z == @z && piece.id == id
end

def ===(piece)
  return @object_id == piece.object_id
end

end