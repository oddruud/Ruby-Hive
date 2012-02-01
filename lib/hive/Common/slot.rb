require 'LoggerCreator'

class Hive::HexagonSide
  ONTOP_SIDE = 0
  UNDER_SIDE = 1 
  RIGHT_SIDE = 2
  BOTTOM_RIGHT_SIDE = 3
  BOTTOM_LEFT_SIDE = 4
  LEFT_SIDE = 5
  TOP_LEFT_SIDE = 6
  TOP_RIGHT_SIDE = 7

  NULL_SIDE = -1
  
  SIDES = 8

NAME = Array.new() 

NAME << "UNTOP"
NAME << "UNDER"
NAME << "RIGHT_SIDE"
NAME << "BOTTOM_RIGHT_SIDE"
NAME << "BOTTOM LEFT SIDE"
NAME << "TOP LEFT SIDE"
NAME << "LEFT SIDE"
NAME << "TOP RIGHT SIDE"

def self.sideName(side)
  NAME[side]
end

def self.getOpposite(side)
   case side 
      when HexagonSide::ONTOP_SIDE then 
        return HexagonSide::UNDER_SIDE
      when HexagonSide::UNDER_SIDE then 
        return HexagonSide::ONTOP_SIDE
      when HexagonSide::RIGHT_SIDE then 
        return HexagonSide::LEFT_SIDE
      when HexagonSide::BOTTOM_RIGHT_SIDE then 
         return HexagonSide::TOP_LEFT_SIDE
      when HexagonSide::BOTTOM_LEFT_SIDE then 
        return HexagonSide::TOP_RIGHT_SIDE
      when HexagonSide::LEFT_SIDE then 
        return HexagonSide::RIGHT_SIDE
      when HexagonSide::TOP_LEFT_SIDE then 
         return HexagonSide::BOTTOM_RIGHT_SIDE
      when HexagonSide::TOP_RIGHT_SIDE then 
         return HexagonSide::BOTTOM_LEFT_SIDE
      else
        return -1
 	end
end

end


###
# PROBLEEM: als een stuk 1 plaats beweegt, mag het niet naar een locatie bewegen waardoor het stuk de samenhang zou verbreken DUS bij 1 plaats 
# bewegen moet er meer dan 1 verbinding zijn met het slot waarnaar word bewogen. Met meerdere stappen werkt deze approach niet goed.
# TODO! FIXME!
###


class Hive::Slot

attr_reader :x
attr_reader :y
attr_reader :z
attr_reader :board
attr_accessor :state
attr_reader :logger

UNCONNECTED = -1
EMPTY_SLOT_WHITE = -2
EMPTY_SLOT_BLACK = -3
EMPTY_SLOT_MIXED = -4
    
def initialize(board_state, x=-1, y=-1, z=-1, state = UNCONNECTED)
  setBoardPosition(x, y, z)
  @state = state   
  
  raise "ivalid board_state param" if board_state.kind_of? Fixnum
  @board_state = board_state
  @logger = LoggerCreator.createLoggerForClassObject(Hive::Slot, @state) 
  yield self  if block_given? 
end

def getBoard
  return @board_state
end

def setBoardPosition(x, y, z) 
  @x,@y,@z = x, y, z
end

def boardPosition
  return @x, @y, @z
end

def to_s
  return "x: #{@x},y: #{@y},z: #{@z},state: #{@state}"
end

def neighbour(side)
  raise "null side" if side.nil?
  x,y,z = Hive::Slot.neighbourCoordinates(@x, @y, @z, side)
  return @board_state.getSlotAt(x, y, z)
end

def neighbourCoords(side)
  raise "null side" if side.nil?
  return Hive::Slot.neighbourCoordinates(@x, @y, @z, side)
end

def neighbourCoordinatesArray(side)
  raise "null side" if side.nil?
  x,y,z = Hive::Slot.neighbourCoordinates(@x, @y, @z, side)
  return [x, y, z]
end

def self.neighbourCoordinates(x, y, z, side)  
 xdif, ydif, zdif = 0,0,0

 case side 
      when Hive::HexagonSide::ONTOP_SIDE then 
        xdif, ydif, zdif = 0, 0, 1 
      when Hive::HexagonSide::UNDER_SIDE then
        xdif, ydif, zdif = 0, 0, -1
      when Hive::HexagonSide::RIGHT_SIDE then
        xdif, ydif = 1, 0 
      when Hive::HexagonSide::BOTTOM_RIGHT_SIDE then 
        xdif, ydif = (y & 1), 1  
      when Hive::HexagonSide::BOTTOM_LEFT_SIDE then 
        xdif, ydif = (-1 + (y & 1)), 1  
      when Hive::HexagonSide::LEFT_SIDE then 
        xdif, ydif = -1, 0 
      when Hive::HexagonSide::TOP_LEFT_SIDE then 
        xdif, ydif = (-1 + (y & 1)), -1  
      when Hive::HexagonSide::TOP_RIGHT_SIDE then 
        xdif, ydif = (y & 1), -1 
      when Hive::HexagonSide::NULL_SIDE then 
        return -1, -1, 0 # return null slot position  
      else
        raise "non existing hexagon side: #{side} (#{side.class})"
 end
  if x != nil
    return x + xdif, y + ydif, z + zdif  
  else
    return 0, 0, 0
  end
end

def forEachNeighbourCoordinate(params = {})  
    exlusions = params[:exclude] || {}
    (0..Hive::HexagonSide::SIDES-1).each do |i|
      unless exlusions.include?(i)
        x,y,z = neighbourCoords(i) 
         if params[:side]   
            yield x,y,z, i               
          else
            yield x,y,z
          end
      end
    end   
end

def forEachNeighbouringPiece(params = {})
  forEachNeighbourCoordinate(params) do |x ,y ,z|
    if @board_state.hasPieceAt(x, y, z)
      yield @board_state.getPieceAt( x, y, z ) 
    end 
  end 
end

def forEachNeighbouringSlot( params = {})
  params[:side] = true
  forEachNeighbourCoordinate(params) do |x,y,z, side| 
    if @board_state.hasConnectedSlotAt(x, y, z) and not @board_state.bottleNeckToSide(self, side)
      yield @board_state.getSlotAt(x,y,z)       
    end
  end 
end

def forEachNeighbouringSlotOrPiece( params = {})
  forEachNeighbourCoordinate(params) do |x,y,z,side|
    if not @board_state.hasPieceAt(x, y, z) 
      if not @board_state.bottleNeckToSide(self, side)
        yield @board_state.getSlotAt(x,y,z)
      end
    else
      yield @board_state.getPieceAt(x, y, z) 
    end 
  end 
end

def forEachAdjacentPiece()
  params = {:exclude => [Hive::HexagonSide::ONTOP_SIDE, Hive::HexagonSide::UNDER_SIDE], :side => true}
  forEachNeighbourCoordinate(params) do |x, y, z|
     if @board_state.hasPieceAt(x, y, z) 
       yield @board_state.getPieceAt( x, y, z )
     end 
   end
end

def forEachAdjacentSlot( params = {} )
  params = {:exclude => [Hive::HexagonSide::ONTOP_SIDE, Hive::HexagonSide::UNDER_SIDE], :side => true}
  forEachNeighbourCoordinate(params) do |x,y,z, side| 
      if @board_state.hasConnectedSlotAt(x, y, z) 
        yield @board_state.getSlotAt(x, y, z)
      end     
  end
end

def forEachAdjacentSlotOrPiece()
  params = {:exclude => [Hive::HexagonSide::ONTOP_SIDE, Hive::HexagonSide::UNDER_SIDE], :side => true}
  forEachNeighbourCoordinate(params) do |x,y,z|
    if not @board_state.hasPieceAt(x, y, z) 
      yield @board_state.getSlotAt(x,y,z)  
    else
       if @board_state.hasConnectedSlotAt(x, y, z)
         yield @board_state.getPieceAt(x, y, z) 
       end
    end 
  end
end

def neighbouringPieces( amount = 7)
    pieces = Array.new()
    forEachNeighbourCoordinate do |x,y,z|
      piece =  @board_state.getPieceAt(x,y,z) 
      if piece 
        pieces << piece 
        return pieces  if pieces.length == amount
      end 
    end
    return pieces
end

def connections()
  count=0
  forEachNeighbourCoordinate do |x,y,z|
    count+=1 if @board_state.getPieceAt(x,y,z) 
  end
  return count 
end
 
 def self.slotState(white, black) 
     if white == :Neighbour && black == :Neighbour 
       state = EMPTY_SLOT_MIXED
     elsif white == :Neighbour && black == :NotANeighbour 
      state = EMPTY_SLOT_WHITE
     elsif white == :NotANeighbour  && black == :Neighbour
      state = EMPTY_SLOT_BLACK
     elsif white == :NotANeighbour  && black == :NotANeighbour 
      state = UNCONNECTED
     end 
     return state
end  

def value 
  return @state
end 


#[09:39:55] INFO-Piece[BLACK_GRASSHOPPER3]: grashopper place moves: 0
#[09:39:55] FATAL-GameHandler: move failed: getSide error: side is NULL (input: x:-1,y:1)
#/Users/ruudopdenkelder/Projects/Hive-Boardgame-Framework/Common/slot.rb:280:in `getSide'

def getSide(otherSlot)
  xDif, yDif, zDif = otherSlot.x - @x,  otherSlot.y - @y, otherSlot.z  - @z 

  raise "Error: xDifference: #{xDif}- this function can only determine the side of immediate neightbours." if xDif < -1 || xDif > 1 
  raise "Error: yDifference: #{yDif}- this function can only determine the side of immediate neightbours." if yDif < -1 || yDif > 1 

  return Hive::HexagonSide::RIGHT_SIDE if xDif > 0 && yDif == 0 
  return Hive::HexagonSide::LEFT_SIDE if xDif < 0  && yDif == 0
  return Hive::HexagonSide::BOTTOM_RIGHT_SIDE if xDif >= (@y & 1) && yDif > 0  
  return Hive::HexagonSide::BOTTOM_LEFT_SIDE if xDif >= 1 - (@y & 1) && yDif > 0  
  return Hive::HexagonSide::TOP_LEFT_SIDE if xDif <= -1 + (@y & 1) && yDif < 0  
  return Hive::HexagonSide::TOP_RIGHT_SIDE if xDif >= (@y & 1) && yDif < 0  
  return Hive::HexagonSide::NULL_SIDE
end 


#TODO! fix this
def getDirectNeighbourSides(side)
  case side 
    when Hive::HexagonSide::ONTOP_SIDE then
    when Hive::HexagonSide::UNDER_SIDE then
    when Hive::HexagonSide::NULL_SIDE then 
      return nil
   end 
   
   unless side.nil? 
    left = side - 1 > 1 ? side - 1 : 7
    right = side + 1 < 8 ? side + 1 : 2
    return [left, right]
   end
   
   return nil
end

def ==(slot)
  return slot.x == @x && slot.y == @y && slot.z == @z
end


  
  
end
