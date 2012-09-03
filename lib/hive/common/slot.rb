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
attr_accessor :false_neighbours # array, holds for all sides whether these sides are reachable from this slot 
attr_reader :logger

UNCONNECTED = -1
EMPTY_SLOT_WHITE = -2
EMPTY_SLOT_BLACK = -3
EMPTY_SLOT_MIXED = -4

STATE_NAMES = ["UNCONNECTED", "EMPTY WHITE", "EMPTY BLACK", "EMPTY MIXED"] 

    
def initialize(board_state, x=-1, y=-1, z=-1)
  raise "invalid board_state" if board_state.nil? || board_state.class != Hive::BoardState
  @false_neighbours = Array.new( 8, false )
  @board_state = board_state
  set_board_position(x, y, z)  
  @logger = Logger.new_for_object( self )
end

def reset_false_neighbours
  @false_neighbours = Array.new( 8, false )
end

def set_false_neighbour(side, false_neighbour)
  @false_neighbours[ side ] = false_neighbour
end

def false_neighbour?( side_index ) 
  return @false_neighbours[ side_index ]
end

def update_false_neighbours
  for_each_adjacent_slot do |slot, side|
    set_false_neighbour(side, self.gap_between?( slot ) )
  end    
end

#TODO do reset and update in one go
def update_false_neighbours_area
  reset_false_neighbours_area
  update_false_neighbours #WORK IN PROGRESS
  for_each_adjacent_slot_or_piece do |slot, side|
    slot.update_false_neighbours 
  end
end

def reset_false_neighbours_area
  reset_false_neighbours
  for_each_adjacent_slot_or_piece do |slot, side| #ERROR: s is an array...
    if slot.kind_of? Array
      @logger.info "reset_false_neighbours_area block parameter s is array: " + slot[0].to_s   
    end  
    slot.reset_false_neighbours #HACK, the block parameter s returns the s
  end
end

def set_board_position(x, y, z) 
  @x,@y,@z = x, y, z
end

def board_position
  return @x, @y, @z
end

def self.state_name(state)
  return STATE_NAMES[state.abs-1]
end

def to_s
  return "x: #{@x},y: #{@y},z: #{@z},state: #{Hive::Slot.state_name( value )}"
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
        raise "NULL SIDE REQUESTED"
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
    (0..Hive::HexagonSide::SIDES-1).each do |side_index|
      unless exlusions.include?( side_index ) #|| false_neighbour?( side_index )  #FIXME false_neighbour under inspection
        x,y,z = neighbour_coords( side_index ) 
         if params[:side]   
            yield x,y,z, side_index               
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
      yield @board_state.get_slot_at(x,y,z), side       
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
        yield @board_state.get_slot_at(x,y,z), side
      end
    else
      yield @board_state.get_piece_at(x, y, z), side 
    end 
  end 
end

def for_each_adjacent_piece()
  params = {:exclude => [Hive::HexagonSide::ONTOP_SIDE, Hive::HexagonSide::UNDER_SIDE], :side => true}
  for_each_neighbour_coordinate(params) do |x, y, z, side|
     if @board_state.has_piece_at(x, y, z) 
       yield @board_state.get_piece_at( x, y, z ), side
     end 
   end
end

def for_each_adjacent_slot( params = {} )
  params = {:exclude => [Hive::HexagonSide::ONTOP_SIDE, Hive::HexagonSide::UNDER_SIDE], :side => true}
  for_each_neighbour_coordinate(params) do |x,y,z, side| 
      if @board_state.has_connected_slot_at(x, y, z) 
        yield @board_state.get_slot_at(x, y, z), side
      end     
  end
end

def for_each_adjacent_slot_or_piece()
  params = {:exclude => [Hive::HexagonSide::ONTOP_SIDE, Hive::HexagonSide::UNDER_SIDE], :side => true}
  for_each_neighbour_coordinate(params) do |x,y,z, side|
    if not @board_state.has_piece_at(x, y, z) 
      yield @board_state.get_slot_at(x,y,z), side  
    else
       if @board_state.has_connected_slot_at(x, y, z)
         yield @board_state.get_piece_at(x, y, z), side 
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

def enclosed?
  count = 0 
  for_each_adjacent_piece{|p, side| count += 1} 
  return count == 6
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
  return @board_state.at(@x, @y, @z)
end 

def empty?
  return value <= UNCONNECTED
end

def gap_between?( slot )
  for_each_adjacent_piece do |p, p_side|
    p.for_each_adjacent_slot do |s, s_side|
      if s == slot
        return false
      end
    end 
  end
  return true 
end

def get_side(other_slot)
  
  #FIX-ME
  #move failed: side between <BLACK_MOSQUITO ON BOARD: (x: 25,y: 24, z: 0)}> and <WHITE_GRASSHOPPER2 ON BOARD: (x: 24,y: 25, z: 0)}> not found
  #x_dif = 24-25 = -1
  #y_dif = 25-24 = 1
  #@y = 24  
  #(@y&1)= 0  
  #BOTTOM_LEFT_SIDE SHOULD BE TRIGGERED but wont with current code!!!
  
        # code from neighbour coordinates:  
        # when Hive::HexagonSide::BOTTOM_RIGHT_SIDE then 
        #   xdif, ydif = (y & 1), 1  
        # when Hive::HexagonSide::BOTTOM_LEFT_SIDE then 
        #   xdif, ydif = (-1 + (y & 1)), 1
  
  x_dif, y_dif, z_dif = other_slot.x - @x,  other_slot.y - @y, other_slot.z  - @z 

  raise "Error: x_difference: #{x_dif}- this function can only determine the side of immediate neightbours." if x_dif < -1 || x_dif > 1 
  raise "Error: y_difference: #{y_dif}- this function can only determine the side of immediate neightbours." if y_dif < -1 || y_dif > 1 

  return Hive::HexagonSide::RIGHT_SIDE if x_dif > 0 && y_dif == 0 
  return Hive::HexagonSide::LEFT_SIDE if x_dif < 0  && y_dif == 0
  return Hive::HexagonSide::BOTTOM_RIGHT_SIDE if x_dif >= (@y & 1) && y_dif > 0  
  return Hive::HexagonSide::BOTTOM_LEFT_SIDE if x_dif >= -1 + (@y & 1) && y_dif > 0  
  return Hive::HexagonSide::TOP_LEFT_SIDE if x_dif <= -1 + (@y & 1) && y_dif < 0  
  return Hive::HexagonSide::TOP_RIGHT_SIDE if x_dif >= (@y & 1) && y_dif < 0  
  raise "side between #{self} and #{other_slot} not found"

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
	return Hive::Slot.new(@board_state,@x,@y,@z)
end

  
  
end
