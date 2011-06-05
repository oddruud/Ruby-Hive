class HexagonSide
  UPPER_SIDE = 0
  TOP_SIDE = 1
  TOP_RIGHT_SIDE = 2
  BOTTOM_RIGHT_SIDE = 3
  BOTTOM_SIDE = 4
  BOTTOM_LEFT_SIDE = 5
  TOP_LEFT_SIDE = 6

NAME= Array.new() 
NAME << "UPPER SIDE"
NAME << "TOP SIDE"
NAME << "TOP RIGHT SIDE"
NAME << "BOTTOM RIGHT SIDE"
NAME << "BOTTOM SIDE"
NAME << "BOTTOM LEFT SIDE"
NAME << "TOP LEFT SIDE"

def self.getOpposite(side)
   case side 
      when HexagonSide::UPPER_SIDE then 
        return -1
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
      else
        return -1
 end
end


end

class Slot



def initialize() 
end
  
def self.neighbour(x,y,side)  
 xdif,ydif=0,0
 case side 
      when HexagonSide::UPPER_SIDE then 
        xdif, ydif= 0, 0 
      when HexagonSide::TOP_SIDE then 
        xdif, ydif= -1, -1 
      when HexagonSide::TOP_RIGHT_SIDE then 
        xdif, ydif= 0, -1  
      when HexagonSide::BOTTOM_RIGHT_SIDE then 
        xdif, ydif= 1, 0  
      when HexagonSide::BOTTOM_SIDE then 
        xdif, ydif= 1, 1  
      when HexagonSide::BOTTOM_LEFT_SIDE then 
        xdif, ydif= 0, 1  
      when HexagonSide::TOP_LEFT_SIDE then 
        xdif, ydif= -1, 0 
      else
        raise MoveException, "non excisting side #{side}"
 end
  if x != nil
    return x + xdif,y + ydif
  else
    return 0,0
  end
end
  
  
end
