require 'LoggerCreator'

class HexagonSide
  ONTOP_SIDE = 0
  UNDER_SIDE = 1 
  RIGHT_SIDE = 2
  BOTTOM_RIGHT_SIDE = 3
  BOTTOM_LEFT_SIDE = 4
  LEFT_SIDE = 5
  TOP_LEFT_SIDE = 6
  TOP_RIGHT_SIDE = 7
 
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

class Slot

attr_reader :x
attr_reader :y
attr_reader :z
attr_accessor :state
attr_reader :logger

UNCONNECTED = -1
EMPTY_SLOT_WHITE = -2
EMPTY_SLOT_BLACK = -3
EMPTY_SLOT_MIXED = -4
TRAPPED_SLOT = -5
 
#@@RelativeCoordinatesToSide = Hash.new()  
#@@RelativeCoordinatesToSide[[0,0,1]] 	= 	HexagonSide::ONTOP_SIDE
#@@RelativeCoordinatesToSide[[0,0,-1]] 	= 	HexagonSide::UNDER_SIDE
#@@RelativeCoordinatesToSide[[1,0,0]] 	= 	HexagonSide::RIGHT_SIDE
#@@RelativeCoordinatesToSide[[0,1,0]] 	= 	HexagonSide::BOTTOM_RIGHT_SIDE
#@@RelativeCoordinatesToSide[[-1,1,0]] 	= 	HexagonSide::BOTTOM_LEFT_SIDE
#@@RelativeCoordinatesToSide[[-1,0,0]] 	= 	HexagonSide::LEFT_SIDE
#@@RelativeCoordinatesToSide[[-1,-1,0]] 	= 	HexagonSide::TOP_LEFT_SIDE
#@@RelativeCoordinatesToSide[[0,-1, 0]] 	= 	HexagonSide::TOP_RIGHT_SIDE

    
def initialize(x,y,z)
  setBoardPosition(x, y, z)  
  @logger = LoggerCreator.createLoggerForClassObject(Slot, @state) 
  yield self  if block_given? 
end

def setBoardPosition(x, y, z) 
  @x,@y,@z, @used = x, y, z, true 
end

def boardPosition
  return @x, @y, @z
end

def to_s
  "x: #{@x},y: #{@y},z: #{@z},state: #{@state}"
end

def neighbour(side)
  raise "null side" if side.nil?
  return Slot.neighbourCoordinates(@x, @y, @z, side)
end

def neighbourCoordinatesArray(side)
  raise "null side" if side.nil?
  x,y,z = Slot.neighbourCoordinates(@x, @y, @z, side)
  return [x, y, z]
end

def self.neighbourCoordinates(x,y,z, side)  
 xdif, ydif, zdif = 0,0,0
 case side 
      when HexagonSide::ONTOP_SIDE then 
        xdif, ydif, zdif = 0, 0, 1 
      when HexagonSide::UNDER_SIDE then
        xdif, ydif, zdif = 0, 0, -1
      when HexagonSide::RIGHT_SIDE then
        xdif, ydif = 1, 0 
      when HexagonSide::BOTTOM_RIGHT_SIDE then 
        xdif, ydif = (y & 1), 1  
      when HexagonSide::BOTTOM_LEFT_SIDE then 
        xdif, ydif = (-1 + (y & 1)), 1  
      when HexagonSide::LEFT_SIDE then 
        xdif, ydif = -1, 0 
      when HexagonSide::TOP_LEFT_SIDE then 
        xdif, ydif = (-1 + (y & 1)), -1  
      when HexagonSide::TOP_RIGHT_SIDE then 
        xdif, ydif = (y & 1), -1 
      else
        raise "non existing hexagon side: #{side} (#{side.class})"
 end
  if x != nil
    return x + xdif, y + ydif, z + zdif  
  else
    return 0, 0, 0
  end
end


def forEachNeighbour(params = {})  
    exlusions = params[:exclude] || {}
    (0..HexagonSide::SIDES-1).each do |i|
      unless exlusions.include?(i)
       # @logger.info "NEIGHBOUR SIDE: #{i}"
        x, y, z = neighbour(i) 
        if z == 0 || z == 1   #the z index of a piece can only be 0 or 1   
         if params[:side]   
            yield x, y, z, i               
          else
            yield x, y, z
          end
        end
      end
    end   
end

def forEachNeighbouringPiece(boardState, params = {})
  forEachNeighbour(params) do |x, y, z|
    if boardState.hasPieceAt(x, y, z)
      yield boardState.getPieceAt( x, y, z ) 
    end 
  end 
end

def forEachNeighbouringSlot(boardState, params = {})
  params[:side] = true
  forEachNeighbour(params) do |x,y,z, side| 
    #if boardState.hasPieceAt(x,y,z) and not boardState.bottleNeckToSide(self, side)
      yield Slot.new(x, y, z){|slot| slot.state = boardState.at(x, y, z) }   
    #end 
  end 
end

def forEachNeighbouringSlotOrPiece(boardState, params = {})
  forEachNeighbour(params) do |x,y,z|
    if not boardState.hasPieceAt(x, y, z) 
      yield Slot.new(x,y,z){|slot| slot.state = boardState.at(x ,y ,z) }   
    else
      yield boardState.getPieceAt(x, y, z) 
    end 
  end 
end

def forEachAdjacentPiece(boardState)
  params = {:exclude => [HexagonSide::ONTOP_SIDE, HexagonSide::UNDER_SIDE], :side => true}
  forEachNeighbour(params) do |x, y, z|
     if boardState.hasPieceAt(x, y, z) 
       yield boardState.getPieceAt( x, y, z )
     end 
   end
end

def forEachAdjacentSlot(boardState)
  params = {:exclude => [HexagonSide::ONTOP_SIDE, HexagonSide::UNDER_SIDE], :side => true}
  forEachNeighbour(params) do |x,y,z, side| 
      yield Slot.new(x, y, z){|slot| slot.state = boardState.at(x, y, z) }   
  end
end

def forEachAdjacentSlotOrPiece(boardState)
  params = {:exclude => [HexagonSide::ONTOP_SIDE, HexagonSide::UNDER_SIDE], :side => true}
  forEachNeighbour(params) do |x,y,z|
    if not boardState.hasPieceAt(x, y, z) 
      yield Slot.new(x,y,z){|slot| slot.state = boardState.at(x ,y ,z) }   
    else
      yield boardState.getPieceAt(x, y, z) 
    end 
  end
end

def neighbouringPieces(boardState, amount = 7)
    pieces = Array.new()
    forEachNeighbour do |x,y,z|
      piece =  boardState.getPieceAt(x,y,z) 
      if piece 
        pieces << piece 
        return pieces  if pieces.length == amount
      end 
    end
    return pieces
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

#TODO: fix this
def getSide(otherSlot)
  xDif, yDif, zDif = otherSlot.x - @x,  otherSlot.y - @y, otherSlot.z  - @z 

  raise "Error: xDifference: #{xDif}- this function can only determine the side of immediate neightbours." if xDif < -1 || xDif > 1 
  raise "Error: yDifference: #{yDif}- this function can only determine the side of immediate neightbours." if yDif < -1 || yDif > 1 

    # side = HexagonSide::RIGHT_SIDE if xDif == 1 && yDif == 0 
    # side = HexagonSide::LEFT_SIDE if xDif == -1 && yDif == 0
    # side = HexagonSide::BOTTOM_RIGHT_SIDE if xDif == (@y & 1) && yDif == 1  
    # side = HexagonSide::BOTTOM_LEFT_SIDE if xDif == 1 - (@y & 1) && yDif == 1  
    # side = HexagonSide::TOP_LEFT_SIDE if xDif == -1 + (@y & 1) && yDif == -1  
    # side = HexagonSide::TOP_RIGHT_SIDE if xDif == (@y & 1) && yDif == -1  
        
    side = HexagonSide::RIGHT_SIDE if xDif > 0 && yDif == 0 
    side = HexagonSide::LEFT_SIDE if xDif < 0  && yDif == 0
    side = HexagonSide::BOTTOM_RIGHT_SIDE if xDif >= (@y & 1) && yDif > 0  
    side = HexagonSide::BOTTOM_LEFT_SIDE if xDif >= 1 - (@y & 1) && yDif > 0  
    side = HexagonSide::TOP_LEFT_SIDE if xDif <= -1 + (@y & 1) && yDif < 0  
    side = HexagonSide::TOP_RIGHT_SIDE if xDif >= (@y & 1) && yDif < 0  
    
  raise "getSide error: side is NULL (input: x:#{xDif},y:#{yDif})" if side.nil?
  
  return side
end 


#TODO! fix this
def getDirectNeighbourSides(side)
  case side 
    when HexagonSide::ONTOP_SIDE then
    when HexagonSide::UNDER_SIDE then
      return nil
   end 
   
   unless side.nil?
    left = side - 1 > 1 ? side - 1 : 7
    right = side + 1 < 8 ? side + 1 : 2
    return [left, right]
   end
   
   return nil
end

#TODO what if beetle is onTop of other pieces, what are its neighbours? 
#def self.neighbourCoordinates(x,y,z, side)  
# xdif, ydif, zdif = 0,0,0
# case side 
#      when HexagonSide::ONTOP_SIDE then 
#        xdif, ydif, zdif = 0, 0, 1 
#      when HexagonSide::UNDER_SIDE then 
#        xdif, ydif, zdif = 0, 0, -1
#      when HexagonSide::TOP_SIDE then 
#        xdif, ydif = -1, -1 
#      when HexagonSide::TOP_RIGHT_SIDE then 
#        xdif, ydif = 0, -1  
#      when HexagonSide::BOTTOM_RIGHT_SIDE then 
#        xdif, ydif = 1, 0  
#      when HexagonSide::BOTTOM_SIDE then 
#        xdif, ydif = 1, 1  
#      when HexagonSide::BOTTOM_LEFT_SIDE then 
#        xdif, ydif = 0, 1  
#      when HexagonSide::TOP_LEFT_SIDE then 
#        xdif, ydif = -1, 0 
#      else
#        raise "non existing hexagon side #{side}"
# end
#  if x != nil
#    return x + xdif, y + ydif, z + zdif  
#  else
#    return 0, 0, 0
#  end
#end


#FIXME!



def ==(slot)
  return slot.x == @x && slot.y == @y && slot.z == @z
end


  
  
end
