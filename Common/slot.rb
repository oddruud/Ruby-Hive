class HexagonSide
  ONTOP_SIDE = 0
  UNDER_SIDE = 1
  
  TOP_SIDE = 2
  TOP_RIGHT_SIDE = 3
  BOTTOM_RIGHT_SIDE = 4
  BOTTOM_LEFT_SIDE = 5
  TOP_LEFT_SIDE = 6
  BOTTOM_SIDE = 7
 
  SIDES = 8

NAME = Array.new() 
NAME << "UPPER SIDE"
NAME << "TOP SIDE"
NAME << "TOP RIGHT SIDE"
NAME << "BOTTOM RIGHT SIDE"
NAME << "BOTTOM SIDE"
NAME << "BOTTOM LEFT SIDE"
NAME << "TOP LEFT SIDE"
NAME << "BOTTOM SIDE"

def self.sideName(side)
  NAME[side]
end

def self.getOpposite(side)
   case side 
      when HexagonSide::ONTOP_SIDE then 
        return HexagonSide::UNDER_SIDE
      when HexagonSide::TOP_SIDE then 
        return HexagonSide::BOTTOM_SIDE
      when HexagonSide::TOP_RIGHT_SIDE then 
        return HexagonSide::BOTTOM_LEFT_SIDE
      when HexagonSide::BOTTOM_RIGHT_SIDE then 
         return HexagonSide::TOP_LEFT_SIDE
      when HexagonSide::BOTTOM_SIDE then 
        return HexagonSide::TOP_SIDE
      when HexagonSide::BOTTOM_LEFT_SIDE then 
        return HexagonSide::TOP_RIGHT_SIDE
      when HexagonSide::TOP_LEFT_SIDE then 
         return HexagonSide::BOTTOM_RIGHT_SIDE
      when HexagonSide::BOTTOM_SIDE then 
         return HexagonSide::UPPER_SIDE
      else
        return -1
 end
end


end

class Slot

attr_accessor :x
attr_accessor :y
attr_accessor :z
attr_accessor :state
attr_reader :logger

UNCONNECTED = -1
EMPTY_SLOT_WHITE = -2
EMPTY_SLOT_BLACK = -3
EMPTY_SLOT_MIXED = -4
TRAPPED_SLOT = -5
 
@@RelativeCoordinatesToSide = Hash.new()  
@@RelativeCoordinatesToSide[[0,0,1]] = HexagonSide::ONTOP_SIDE
@@RelativeCoordinatesToSide[[0,0,-1]] = HexagonSide::UNDER_SIDE
@@RelativeCoordinatesToSide[[-1,-1,0]] = HexagonSide::TOP_SIDE
@@RelativeCoordinatesToSide[[0,-1, 0]] = HexagonSide::TOP_RIGHT_SIDE
@@RelativeCoordinatesToSide[[1,0,0]] = HexagonSide::BOTTOM_RIGHT_SIDE
@@RelativeCoordinatesToSide[[1,1,0]] = HexagonSide::BOTTOM_SIDE
@@RelativeCoordinatesToSide[[0,1,0]] = HexagonSide::BOTTOM_LEFT_SIDE
@@RelativeCoordinatesToSide[[-1,0,0]] = HexagonSide::TOP_LEFT_SIDE
    
def initialize(x,y,z)
  @x,@y,@z = x, y, z  
  yield self   if block_given? 
  @logger = LoggerCreator.createLoggerForClassObject(Slot, @state) 
end

def setBoardPosition(x, y,z) 
  @used= true
  @x,@y,@z = x, y,z 
end


def boardPosition
  return @x, @y,@z
end

def to_s
  "x: #{@x},y: #{@y},z: #{@z},state: #{@state}"
end

def neighbour(side)
  return Slot.neighbourCoordinates(@x,@y,@z,side)
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
  forEachNeighbour(params) do |x,y,z|
    if boardState.at(x,y,z) > -1
      yield boardState.pieces[boardState.at(x,y,z)]
    end 
  end 
end

def forEachNeighbouringSlot(boardState, params = {})
  params[:side] = true
  forEachNeighbour(params) do |x,y,z, side| 
    if boardState.at(x,y,z) < -1 and not boardState.bottleNeckToSide(self, side)
      yield Slot.new(x,y,z){|slot| slot.state = boardState.at(x,y,z) }   
    end 
  end 
end

def forEachNeighbouringSlotOrPiece(boardState, params = {})
  forEachNeighbour(params) do |x,y,z|
    if boardState.at(x,y,z) < -1
      yield Slot.new(x,y,z){|slot| slot.state = boardState.at(x,y,z) }   
    elsif  boardState.at(x,y,z) > -1
      yield boardState.pieces[boardState.at(x,y,z)]
    end 
  end 
end


def neighbouringPieces(boardState, amount = 7)
    pieces = Array.new()
    forEachNeighbour do |x,y,z|
      id = boardState.at(x,y,z) 
      if id > -1
        piece = boardState.pieces[id]
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

   
=begin
  [2][3]
  [7][1][4]
    [6][5]
=end  

def value 
  return @state
end 

def getSide(otherSlot)
  xDif, yDif, zDif = @x - otherSlot.x, @y - otherSlot.y, @z - otherSlot.z
  side = @@RelativeCoordinatesToSide[[xDif,yDif, zDif]]
end 

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
def self.neighbourCoordinates(x,y,z, side)  
 xdif, ydif, zdif = 0,0,0
 case side 
      when HexagonSide::ONTOP_SIDE then 
        xdif, ydif, zdif = 0, 0, 1 
      when HexagonSide::UNDER_SIDE then 
        xdif, ydif, zdif = 0, 0, -1
      when HexagonSide::TOP_SIDE then 
        xdif, ydif = -1, -1 
      when HexagonSide::TOP_RIGHT_SIDE then 
        xdif, ydif = 0, -1  
      when HexagonSide::BOTTOM_RIGHT_SIDE then 
        xdif, ydif = 1, 0  
      when HexagonSide::BOTTOM_SIDE then 
        xdif, ydif = 1, 1  
      when HexagonSide::BOTTOM_LEFT_SIDE then 
        xdif, ydif = 0, 1  
      when HexagonSide::TOP_LEFT_SIDE then 
        xdif, ydif = -1, 0 
      else
        raise "non existing hexagon side #{side}"
 end
  if x != nil
    return x + xdif, y + ydif, z + zdif  
  else
    return 0, 0, 0
  end
end

def ==(slot)
  return slot.x == @x && slot.y == @y && slot.z == @z
end


  
  
end
