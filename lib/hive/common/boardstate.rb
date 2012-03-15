require "drb"
require 'move/move' 
require 'pieces/queenbee'  
require 'pieces/beetle'  
require 'pieces/ant'  
require 'pieces/grasshopper'  
require 'pieces/spider'  
require 'pieces/mosquito'  
require 'pieces/ladybug'  
require 'move_validators/move_validator'
require 'move_validators/queen_in_four_moves_validator'


class Hive::TurnState
  GAME_OVER = :gameover
  INVALID = :invalid_move
  VALID = :valid_move
end

class Hive::BoardState
 include DRbUndumped
 
attr_reader :pieces    #1D array [piece_id] -> Piece
attr_reader :board     #2D array [x][y][z] -> piece_id          
attr_reader :moves     #1D array [i] -> Move
attr_reader :current_piece  
attr_reader :logger   
attr_reader :winning_color   

BOARD_SIZE = 50
PIECES_PER_PLAYER = 12
START_POS_X = BOARD_SIZE/2 
START_POS_Y = BOARD_SIZE/2

@@validators = [ Hive::QueenInFourMovesValidator, 
                 #Hive::PlacedToSameColorValidator 
                ]  

def initialize(name = nil)
  @name = name
  @logger = Logger.new_for_object( self )
  @logger.info "initializing new boardstate: #{name}"
  reset
end

def reset
  @logger.info  "Creating pieces for Board State"
  @board = Array.new(BOARD_SIZE).map!{Array.new(BOARD_SIZE).map!{ |x| x = [-1] } }   #THE BOARD 
  @pieces =  Array.new()                                       #THE PIECES
  #WHITE PIECES
  @pieces[Hive::Piece::WHITE_QUEEN_BEE]=      Hive::QueenBee.new(self, Hive::Piece::WHITE_QUEEN_BEE)
  @pieces[Hive::Piece::WHITE_BEETLE1]=        Hive::Beetle.new(self, Hive::Piece::WHITE_BEETLE1)
  @pieces[Hive::Piece::WHITE_BEETLE2]=        Hive::Beetle.new(self,Hive::Piece::WHITE_BEETLE2)
  @pieces[Hive::Piece::WHITE_SPIDER1]=        Hive::Spider.new(self,Hive::Piece::WHITE_SPIDER1)
  @pieces[Hive::Piece::WHITE_SPIDER2]=        Hive::Spider.new(self,Hive::Piece::WHITE_SPIDER2)
  @pieces[Hive::Piece::WHITE_GRASSHOPPER1]=   Hive::GrassHopper.new(self,Hive::Piece::WHITE_GRASSHOPPER1)
  @pieces[Hive::Piece::WHITE_GRASSHOPPER2]=   Hive::GrassHopper.new(self,Hive::Piece::WHITE_GRASSHOPPER2)
  @pieces[Hive::Piece::WHITE_GRASSHOPPER3]=   Hive::GrassHopper.new(self,Hive::Piece::WHITE_GRASSHOPPER3)
  @pieces[Hive::Piece::WHITE_ANT1]=           Hive::Ant.new(self,Hive::Piece::WHITE_ANT1)
  @pieces[Hive::Piece::WHITE_ANT2]=           Hive::Ant.new(self,Hive::Piece::WHITE_ANT2)
  @pieces[Hive::Piece::WHITE_ANT3]=           Hive::Ant.new(self,Hive::Piece::WHITE_ANT3)
  @pieces[Hive::Piece::WHITE_MOSQUITO]=       Hive::Mosquito.new(self,Hive::Piece::WHITE_MOSQUITO)
  @pieces[Hive::Piece::WHITE_LADYBUG]=        Hive::LadyBug.new(self,Hive::Piece::WHITE_LADYBUG)
    
  #BLACK PIECES
  @pieces[Hive::Piece::BLACK_QUEEN_BEE]=      Hive::QueenBee.new(self,Hive::Piece::BLACK_QUEEN_BEE)
  @pieces[Hive::Piece::BLACK_BEETLE1]=        Hive::Beetle.new(self,Hive::Piece::BLACK_BEETLE1)
  @pieces[Hive::Piece::BLACK_BEETLE2]=        Hive::Beetle.new(self,Hive::Piece::BLACK_BEETLE2)
  @pieces[Hive::Piece::BLACK_SPIDER1]=        Hive::Spider.new(self,Hive::Piece::BLACK_SPIDER1)
  @pieces[Hive::Piece::BLACK_SPIDER2]=        Hive::Spider.new(self,Hive::Piece::BLACK_SPIDER2)
  @pieces[Hive::Piece::BLACK_GRASSHOPPER1]=   Hive::GrassHopper.new(self,Hive::Piece::BLACK_GRASSHOPPER1)
  @pieces[Hive::Piece::BLACK_GRASSHOPPER2]=   Hive::GrassHopper.new(self,Hive::Piece::BLACK_GRASSHOPPER2)
  @pieces[Hive::Piece::BLACK_GRASSHOPPER3]=   Hive::GrassHopper.new(self,Hive::Piece::BLACK_GRASSHOPPER3)
  @pieces[Hive::Piece::BLACK_ANT1]=           Hive::Ant.new(self,Hive::Piece::BLACK_ANT1)
  @pieces[Hive::Piece::BLACK_ANT2]=           Hive::Ant.new(self,Hive::Piece::BLACK_ANT2)
  @pieces[Hive::Piece::BLACK_ANT3]=           Hive::Ant.new(self,Hive::Piece::BLACK_ANT3) 
  @pieces[Hive::Piece::BLACK_MOSQUITO]=       Hive::Mosquito.new(self,Hive::Piece::BLACK_MOSQUITO)
  @pieces[Hive::Piece::BLACK_LADYBUG]=        Hive::LadyBug.new(self,Hive::Piece::BLACK_LADYBUG)
  
  @slots = Hash.new
  
  @winning_color = Hive::PieceColor::NONE
  @moves = Array.new()  #MOVE HISTORY
 
  #puts to_s                        
end
  
  #TODO keep a repo of requested slots 
  
  #Works under the presumption that White always begins!!
 def get_turns(player_color)
   return (@moves.length / 2).floor + ( @moves.length & 1 ) if player_color == Hive::PieceColor::WHITE 
   return (@moves.length / 2).floor if player_color == Hive::PieceColor::BLACK 
 end   
  
 def set_pieces(pieces) 
    @pieces = pieces
 end

  def set_board(board) 
    @board = board 
  end
  
  def set_moves(moves) 
    @moves = moves
  end
  
  def set_slots(slots)
  	@slots = slots
  end

def next_state(move)
   next_board_state = self.clone
   next_board_state.make_move(move) 
   return next_board_state
end

def clone
  c = Hive::BoardState.new()
  c.set_slots( slots_copy() )
  c.set_pieces( pieces_copy() ) 
  c.set_board( board_copy() )
  c.set_moves( moves_copy() )    
  return c
end

def board_copy()  
  copy = Array.new(BOARD_SIZE).map!{Array.new(BOARD_SIZE)}   #THE BOARD 
  @board.each_index do |xI| 
    @board[xI].each_index do |yI|
      copy[xI][yI] = Array.new(@board[xI][yI]) 
    end
  end
  return copy 
end

def pieces_copy()
  copy = Array.new()
  @pieces.each_index do |i|
    copy << @pieces[i].dup
  end  
end

def slots_copy()
	copy = Hash.new()
	@slots.each {|key, slot| copy[key] = slot.clone}
	return copy	
end


def moves_copy()
  return Array.new(@moves)
end

def at(x,y,z)
    return @board[x][y][z] || Hive::Slot::UNCONNECTED  unless out_of_bounds(x,y,z) 
    return Hive::Slot::UNCONNECTED
end
  
  def has_piece_at(x,y,z)
    return at(x, y, z).is_hive_piece_id? && !out_of_bounds(x,y,z) 
  end
  
  def has_connected_slot_at(x,y,z)
    return !out_of_bounds(x,y,z) && at(x,y,z).is_hive_slot_id? 
  end
  
  def out_of_bounds(x, y, z)
    return x >= Hive::BoardState::BOARD_SIZE || y >= Hive::BoardState::BOARD_SIZE || z > @board[x][y].length || x < 0 || y < 0 || z < 0   
  end
   
  def location_string(x,y,z)
    return "(x:#{x},y:#{y},z:#{z})"
  end 
    
  def get_piece_by_id(id)
    raise "#{id} does not match with any piece in #{self}" unless id.is_hive_piece_id?
    @logger.debug "getPieceById:#{id}"
    return @pieces[id]
  end
  
  def get_piece_with_color(color, piece_type)
    id = piece_type
    id += Hive::Piece::BLACK_PIECE_RANGE.min + piece_type if color == Hive::PieceColor::BLACK 
    return get_piece_by_id(id)
  end

  def pickup_piece(piece)
    raise "you cannot pick up #{piece} already other piece in hand: #{@current_piece}" unless @current_piece.nil?
    remove_piece_from_board( piece ) unless @current_piece == piece
    @current_piece = piece
  end
  
  #FIXMME!
  def drop_piece(piece)
    raise "the piece #{piece} can not be dropped sinced it hast been picked up" unless piece == @current_piece
      place_piece_back(piece) 
      #@pieces.each {|p| p.marked = false}
      @current_piece = nil 
  end

  def color_of_winner
    return winning_color 
  end
  
  def moves_made?
    @moves.length != 0
  end
  
  def move_count
     @moves.length
  end
  
  def start_slot
    return  get_slot_at(START_POS_X, START_POS_Y, 0)
  end
  
  def used_pieces
    pieces = Set.new()
    @pieces.each { |p| pieces << p if p.used? }
    return pieces
  end
  
  def collect_connected_pieces(piece, collection)
    piece.for_each_neighbouring_piece do |n|
      unless collection.include?(n)
        collection << n 
        collect_connected_pieces(n, collection)
      end 
    end
  end
  
  def all_pieces_connected?
      used = used_pieces()
      return true if used.size() == 0
      connected_pieces = Set.new() 
      collect_connected_pieces(used.first, connected_pieces)
      return used.size == connected_pieces.size
  end
  
  def valid?
    return all_pieces_connected?
  end 
  
  def valid_move?(player, move)
    return true if not moves_made? #todo check if the piece in move is not corrupt  
    @@validators.each do |validator|                 #common board validation-rules 
      if not validator.validate(self, player, move) 
        @logger.debug  "validator #{validator.name} FAILED"
        raise "#{move} failed the #{validator}"
        return false 
      else
        @logger.debug  "validator #{validator.name} SUCCESS"
      end
     end  
     return true #piece.valid_move?( move )    #piece specific validation    
  end

  def make_move(player, move)
    begin 
      @logger.info  "playing piece at #{move.piece.board_position}: #{move}"
      if valid_move?(player, move ) 
        place(move) 
        result = Hive::TurnState::VALID
      else
        @logger.info  "INVALID MOVE: #{move}"  
        result = Hive::TurnState::INVALID
      end
    rescue Hive::MoveException => message
      @logger.info "Move exception:#{message}"
      result = Hive::TurnState::INVALID
    end
    return result 
  end
 
  def to_s
    output = "move #{self.move_count}--------------------------------------\n"
    output += @board.map {|x| x.inspect }.join("\n")
    output += "\n---------------------------------------------------\n"
    return output
  end
  
  def to_message
    state = @board.map {|x| x.inspect }.join("")
    return "BS.#{state}."    
  end 
  
 def get_pieces_by_color(color)
  pieces = []
  if color == Hive::PieceColor::WHITE
    pieces = @pieces[Hive::Piece::WHITE_PIECE_RANGE] 
  elsif color == Hive::PieceColor::BLACK
    pieces = @pieces[Hive::Piece::BLACK_PIECE_RANGE] 
  end
    return pieces
 end
 
def each_board_position
  x_i, y_i, z_i = -1, -1, -1     
    @board.each do |x|
      x_i += 1
      y_i = -1
      x.each do |y|
        y_i += 1
        z_i = -1
        y.each do |z|
          z_i += 1
          yield x_i, y_i, z_i, z
        end  
      end 
    end
end   

def get_slots_with_type_code(slot_type)   
  slots = Array.new()
  raise "a slot with an id higher than -1 is not a slot but a piece, use get_piece_by_id(piece_id)" if slot_type.is_hive_piece_id?
  
  self.each_board_position do |x, y, z, value|
    if value == slot_type && value.is_hive_slot_id?  
      slots << get_slot_at(x,y,z)
    end    
  end
  return slots 
end

 def move_message(move)
  origin_x, origin_y  = get_origin_board_pos(move)
  dest_x, dest_y  = get_dest_board_pos(move)
   return "MV.#{origin_x}.#{origin_y}.#{dest_x}.#{dest_y}"
 end
 
 def bottle_neck_between_slots(slot1, slot2)
    side = slot1.get_side(slot2) 
    return bottle_neck_to_side(slot1, side)
 end 
 
 def bottle_neck_to_side(slot, side)
   counter = 0
   bottle_neck_sides = slot.get_direct_neighbour_sides(side) 
   unless bottle_neck_sides.nil?
    bottle_neck_sides.each do |side|
      x,y,z =  slot.neighbour_coords(side)
      counter += 1 if at(x, y, z).is_hive_piece_id?
    end  
   end
   return counter == 2 ? true : false
 end
 
 def get_pieces_at(x,y)
   piece_ids = @board[x][y]
   pieces = Array.new()
   piece_ids.each do |id|
     pieces << @piece[id] if id > -1
   end
   return pieces
 end
 
 ##TODO: errorprone...
 def get_num_pieces_at(x,y) 
  count = 0
  @board[x][y].each{|id| count+=1 if id.is_hive_piece_id? } unless out_of_bounds(x,y,0)
  return count
 end
 
 def get_piece_at(x,y,z)
   raise "out of bounds " if out_of_bounds(x,y,z)
   return has_piece_at(x, y, z) ? @pieces[ at(x,y,z) ] : nil
 end
 
 #TODO keep a repo of requested slots 
 def get_slot_at(x,y,z)
   id = at(x, y, z)
   return @pieces[id] if id.is_hive_piece_id?
   @slots[[x,y,z]] = Hive::Slot.new(self, x,y,z, id) if @slots[[x,y,z]].nil? 
   return @slots[[x,y,z]]  
 end
 
 def remove_piece_from_board(piece)
  white = :NotANeighbour
  black = :NotANeighbour 
  if piece.used? 
     piece.for_each_neighbouring_slot_or_piece do |neighbour_slot|
         if neighbour_slot.kind_of? Hive::Piece
             white = :Neighbour if neighbour_slot.color == Hive::PieceColor::WHITE      
             black = :Neighbour if neighbour_slot.color == Hive::PieceColor::BLACK     
          else    
            set_id(neighbour_slot.x,neighbour_slot.y,neighbour_slot.z, slot_state_after_removal(piece, neighbour_slot) ) #changes the states of surrounding slots after the removal    
            neighbour_slot.update_reachability() #WORK IN PROGRESS
        end
     end    
     rx,ry,rz = piece.board_position   
     @logger.warn "removing #{piece}, replacing with #{Hive::Slot::slot_state(white, black)}"                            
     set_id(rx,ry,rz,  Hive::Slot::slot_state(white, black) ) #the slot's new state after removal of the piece 
  end
 end
 
 
 private
 
 def place(move)   
   x,y,z = move.destination
   piece = get_piece_by_id(move.moving_piece_id);
   set_piece_to(piece, x, y,z) 
   @moves << move
   @logger.debug  "PLACED: #{move}" 
 end

 def set_piece_to( piece, x , y, z )
  @logger.debug "Placing #{piece.name} at #{x},#{y},#{z}" 
  remove_piece_from_board(piece) 
  set_id( x, y, z, piece.id )
  piece.set_board_position(x, y, z)  
  piece.used = true
  resolve_neighbour_states( piece ) 
 end
 
 def set_id( x, y, z, id )
     raise "Invalid board change: x: #{x}, y:#{y}, z:#{z} -ID: #{id}" if out_of_bounds(x, y, z)   #TODO make out_of bounds smarter
     @board[x][y][z] = id
 end
 
 def set_piece( piece )
   set_id( piece.x, piece.y, piece.z, piece.id ) 
 end
 
 def place_piece_back(piece)
   set_piece(piece) #places a piece back on the board (writes its id in the @board array) 
   resolve_neighbour_states(piece) 
 end
   
    
 def resolve_neighbour_states(piece)
  count = 0 
  piece.for_each_neighbour_coordinate do |x,y,z|
    count += 1
    case at(x,y,z)
      when Hive::Slot::UNCONNECTED then 
        if piece.color == Hive::PieceColor::WHITE 
          set_id(x,y,z, Hive::Slot::EMPTY_SLOT_WHITE) 
        elsif piece.color == Hive::PieceColor::BLACK   
          set_id(x,y,z,Hive::Slot::EMPTY_SLOT_BLACK) 
        end  
      when Hive::Slot::EMPTY_SLOT_BLACK then
          set_id(x, y, z,Hive::Slot::EMPTY_SLOT_MIXED) if piece.color == Hive::PieceColor::WHITE   
      when Hive::Slot::EMPTY_SLOT_WHITE then
          set_id(x, y ,z ,Hive::Slot::EMPTY_SLOT_MIXED)  if piece.color == Hive::PieceColor::BLACK   
    end
  end  
 end 
 
 def slot_state_after_removal(removed_piece, slot)
       white= :NotANeighbour
       black= :NotANeighbour 
       slot.for_each_neighbouring_piece do |piece|
         unless piece == removed_piece
            white = :Neighbour if piece.color == Hive::PieceColor::WHITE
            black = :Neighbour if piece.color == Hive::PieceColor::BLACK    
         end
       end   
     return Hive::Slot::slot_state(white, black) 
 end 
 
 def get_origin_board_pos(move) 
    return @pieces[move.moving_piece_id].board_position;
 end

 

end