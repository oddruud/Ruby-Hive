require 'slot'

class Hive::PieceColor
  NONE= :none
  BLACK= :black
  WHITE= :white 
  COLORS = [WHITE, BLACK]
  
  def self.opposing_color color
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
  
#PIECE CONSTANTS: CORRESPOND TO VALUES IN 3D BOARDSTATE ARRAY
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

WHITE_PIECE_RANGE = WHITE_QUEEN_BEE..WHITE_LADYBUG
BLACK_PIECE_RANGE = BLACK_QUEEN_BEE..BLACK_LADYBUG
PIECE_RANGE = WHITE_QUEEN_BEE..BLACK_LADYBUG

NAME = Array.new() 
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
attr_reader :free_to_move

attr_accessor :pickup_count
attr_accessor :marked

def initialize(board_state, id)
  set_id(id)
  super(board_state)
  @x, @y, @z = -1, -1, -1
  @used = false 
  @pickup_count = 0 
  @free_to_move = true
  @reachable_neighbours = Array.new( 8, true)
  yield self if block_given?
end

def id 
  return @insect_id
end

def set_board_position(x, y, z) 
  @x,@y,@z = x, y, z
  
  unless @x == -1 #means initialization
    update_movability
    update_reachability #WORK IN PROGRESS
    for_each_adjacent_slot_or_piece {|s| s.update_reachability()}
  end
end

def self.num_play_pieces
	return Hive::Piece::WHITE_PIECE_RANGE.max + 1
end

def self.piece_id_range
  return Hive::Piece::PIECE_RANGE
end

def self.valid_id?(id)
  return Hive::Piece.piece_id_range.include?(id)
end

def set_id(insect_id)
  raise "invalid id: #{id}" unless Hive::Piece.valid_id?(insect_id)
  
  @insect_id = insect_id
  @name = NAME[@insect_id]
  if @logger.nil?
     @logger = Logger.new_for_object( self )
  else
     @logger.set_name( Hive::Piece , @name ) 
  end
end

def self.name_by_id(id)
  return NAME[id]
end

def name
  Hive::Piece.name_by_id(id)
end 

def used?
	@used
end 

def self.color_by_id(id) 
  if id <  NAME.length/2
    return Hive::PieceColor::WHITE
  else
    return Hive::PieceColor::BLACK
  end
 end


def copy
  new_piece = self.dup 
  return new_piece
end

def pickup
  @board_state.pickup_piece(self)
end

def drop
  @board_state.drop_piece(self)
end

def touch
  pickup
  yield
  drop
end 


def valid_move?(move)
  if validator.nil?
    @logger.info "#{self} does not have a validator, FIX THIS!"
    return true
  end
  return validator.validate(@board_state, move)
end

def color
  return Hive::Piece.color_by_id(id)
end

def to_string
  return self.name[id]
end

def second_moves
 open_slots = Array.new()
 if @board_state.move_count == 1 #if this is the second move to be made, you can connect to the opposing color 
    opposing_slot_type =  Hive::Piece.color_to_slot_type(Hive::PieceColor.opposing_color(color))
    open_slots = open_slots +  @board_state.get_slots_with_type_code(opposing_slot_type) 
     @logger.debug "collecting second moves...#{open_slots.length} slots"
    open_slots.each do |slot|
        @logger.info slot.to_s
     end
 end
 return open_slots
end

#the moves available if the piece is not yet on the board
def available_place_moves
 moves = Array.new()
 open_slots = Array.new()
 #@logger.info "collecting moves..."
 open_slots << @board_state.start_slot if not @board_state.moves_made? #FIRST MOVE
 open_slots += second_moves                           #2nd MOVE

 unless @used                                                   #Nth MOVE
    empty_slot_type =  Hive::Piece.color_to_slot_type(color)
    open_slots = open_slots +  @board_state.get_slots_with_type_code(empty_slot_type)  
 end
 
 #@logger.info  "NUM open slots: #{open_slots.length}"
 open_slots.delete_if{|slot| slot.z == 1} #only allow slots on the lower level  
 open_slots.each do |slot|
   raise "bla bla: #{@insect_id}" unless Hive::Piece.valid_id?(@insect_id)
  move = Hive::Move.new(self, slot)
  moves = moves + [move]
 end
 
 return moves
end

def self.color_to_slot_type(color)
    white_n = color == Hive::PieceColor::WHITE ? :Neighbour : :NotANeighbour
    black_n = color == Hive::PieceColor::BLACK ? :Neighbour : :NotANeighbour
    return Hive::Slot.slot_state(white_n, black_n) 
end 


#movable: is the piece movable?
def movable?
	return @free_to_move 
end

#direct opposite of movable
def locked?	
	return @free_to_move ? false : true 
end


def update_movability
	@free_to_move = trapped? #check whether the piece is directly trapped by neighbouring pieces 
	if @free_to_move
		touch{@free_to_move = @board_state.valid?} #check whether removing the piece would result in an inconsistent state
	end
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

private

#TODO: check whether piece is trapped by surrounding pieces 
def trapped?
  return false
end

end