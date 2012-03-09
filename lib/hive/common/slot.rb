require 'logger'
require 'hive_id'

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

def self.side_name(side)
  NAME[side]
end

def self.get_opposite(side)
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


class Hive::Slot

attr_reader :x
attr_reader :y
attr_reader :z
attr_reader :board_state
attr_accessor :state
attr_reader :logger

UNCONNECTED = -1
EMPTY_SLOT_WHITE = -2
EMPTY_SLOT_BLACK = -3
EMPTY_SLOT_MIXED = -4
    
def initialize(board_state, x=-1, y=-1, z=-1, state = UNCONNECTED)
  set_board_position(x, y, z)
  @state = state   
  
  raise "invalid board_state param" if board_state.kind_of? Fixnum
  @board_state = board_state
  @logger = Logger.new_for_object( self )
  yield self  if block_given? 
end

def set_board_position(x, y, z) 
  @x,@y,@z = x, y, z
end

def board_position
  return @x, @y, @z
end

def to_s
  return "x: #{@x},y: #{@y},z: #{@z},state: #{@state}"
end

def neighbour(side)
  raise "null side" if side.nil?
  x,y,z = Hive::Slot.neighbour_coordinates(@x, @y, @z, side)
  return @board_state.get_slot_at(x, y, z)
end

def neighbour_coords(side)
  raise "null side" if side.nil?
  return Hive::Slot.neighbour_coordinates(@x, @y, @z, side)
end

def neighbour_coordinates_array(side)
  raise "null side" if side.nil?
  x,y,z = Hive::Slot.neighbour_coordinates(@x, @y, @z, side)
  return [x, y, z]
end

def self.neighbour_coordinates(x, y, z, side)  
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

def for_each_neighbour_coordinate(params = {})  
    exlusions = params[:exclude] ||  [Hive::HexagonSide::UNDER_SIDE] 
    (0..Hive::HexagonSide::SIDES-1).each do |i|
      unless exlusions.include?(i)
        x,y,z = neighbour_coords(i) 
         if params[:side]   
            yield x,y,z, i               
          else
            yield x,y,z
          end
      end
    end   
end

def for_each_neighbouring_piece(params = {})
  for_each_neighbour_coordinate(params) do |x ,y ,z|
    if @board_state.has_piece_at(x, y, z)
      yield @board_state.get_piece_at( x, y, z ) 
    end 
  end 
end

def for_each_neighbouring_slot( params = {})
  params[:side] = true
  for_each_neighbour_coordinate(params) do |x,y,z, side| 
    if @board_state.has_connected_slot_at(x, y, z) and not @board_state.bottle_neck_to_side(self, side)
      yield @board_state.get_slot_at(x,y,z)       
    end
  end 
end

def for_each_multi_z_level_slot #overwrite to return slots of any z-index
  for_each_neighbour_coordinate( {:exclude => [Hive::HexagonSide::ONTOP_SIDE, Hive::HexagonSide::UNDER_SIDE]} ) do |x , y|
    z_level = @board_state.get_num_pieces_at(x,y)
    yield @board_state.get_slot_at( x, y, z_level ) 
  end
end 

def for_each_neighbouring_slot_or_piece( params = {})
  for_each_neighbour_coordinate(params) do |x,y,z,side|
    if not @board_state.has_piece_at(x, y, z) 
      if not @board_state.bottle_neck_to_side(self, side)
        yield @board_state.get_slot_at(x,y,z)
      end
    else
      yield @board_state.get_piece_at(x, y, z) 
    end 
  end 
end

def for_each_adjacent_piece()
  params = {:exclude => [Hive::HexagonSide::ONTOP_SIDE, Hive::HexagonSide::UNDER_SIDE], :side => true}
  for_each_neighbour_coordinate(params) do |x, y, z|
     if @board_state.has_piece_at(x, y, z) 
       yield @board_state.get_piece_at( x, y, z )
     end 
   end
end

def for_each_adjacent_slot( params = {} )
  params = {:exclude => [Hive::HexagonSide::ONTOP_SIDE, Hive::HexagonSide::UNDER_SIDE], :side => true}
  for_each_neighbour_coordinate(params) do |x,y,z, side| 
      if @board_state.has_connected_slot_at(x, y, z) 
        yield @board_state.get_slot_at(x, y, z)
      end     
  end
end

def for_each_adjacent_slot_or_piece()
  params = {:exclude => [Hive::HexagonSide::ONTOP_SIDE, Hive::HexagonSide::UNDER_SIDE], :side => true}
  for_each_neighbour_coordinate(params) do |x,y,z|
    if not @board_state.has_piece_at(x, y, z) 
      yield @board_state.get_slot_at(x,y,z)  
    else
       if @board_state.has_connected_slot_at(x, y, z)
         yield @board_state.get_piece_at(x, y, z) 
       end
    end 
  end
end

def neighbouring_pieces( amount = 7)
    pieces = Array.new()
    for_each_neighbour_coordinate do |x,y,z|
      piece =  @board_state.get_piece_at(x,y,z) 
      if piece 
        pieces << piece 
        return pieces  if pieces.length == amount
      end 
    end
    return pieces
end

def connections()
  count=0
  for_each_neighbour_coordinate do |x,y,z|
    count+=1 if @board_state.get_piece_at(x,y,z) 
  end
  return count 
end
 
 def self.slot_state(white, black) 
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

def empty?
  return value <= UNCONNECTED
end

#[09:39:55] INFO-Piece[BLACK_GRASSHOPPER3]: grashopper place moves: 0
#[09:39:55] FATAL-GameHandler: move failed: get_side error: side is NULL (input: x:-1,y:1)
#/Users/ruudopdenkelder/Projects/Hive-Boardgame-Framework/Common/slot.rb:280:in `getSide'

def get_side(other_slot)
  x_dif, y_dif, z_dif = other_slot.x - @x,  other_slot.y - @y, other_slot.z  - @z 

  raise "Error: x_difference: #{x_dif}- this function can only determine the side of immediate neightbours." if x_dif < -1 || x_dif > 1 
  raise "Error: y_difference: #{y_dif}- this function can only determine the side of immediate neightbours." if y_dif < -1 || y_dif > 1 

  return Hive::HexagonSide::RIGHT_SIDE if x_dif > 0 && y_dif == 0 
  return Hive::HexagonSide::LEFT_SIDE if x_dif < 0  && y_dif == 0
  return Hive::HexagonSide::BOTTOM_RIGHT_SIDE if x_dif >= (@y & 1) && y_dif > 0  
  return Hive::HexagonSide::BOTTOM_LEFT_SIDE if x_dif >= 1 - (@y & 1) && y_dif > 0  
  return Hive::HexagonSide::TOP_LEFT_SIDE if x_dif <= -1 + (@y & 1) && y_dif < 0  
  return Hive::HexagonSide::TOP_RIGHT_SIDE if x_dif >= (@y & 1) && y_dif < 0  
  return Hive::HexagonSide::NULL_SIDE
end 


#TODO! fix this
def get_direct_neighbour_sides(side)
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

def clone
	return Hive::Slot.new(@board_state,@x,@y,@z,@state)
end

  
  
end
