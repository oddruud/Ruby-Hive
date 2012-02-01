require "drb"
require 'Move/move' 
require 'Insects/queenbee'  
require 'Insects/beetle'  
require 'Insects/ant'  
require 'Insects/grasshopper'  
require 'Insects/spider'  
require 'Insects/mosquito'  
require 'Insects/ladybug'  
require 'MoveValidators/MoveValidator'
require 'MoveValidators/PlacedToSameColorValidator'
require 'MoveValidators/QueenInFourMovesValidator'
require 'LoggerCreator'

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
attr_reader :currentPiece  
attr_reader :logger   
attr_reader :winning_color   

BOARD_SIZE = 10
BOARD_HEIGHT = 2
PIECES_PER_PLAYER = 12
START_POS_X = BOARD_SIZE/2 
START_POS_Y = BOARD_SIZE/2

@@validators = [ Hive::QueenInFourMovesValidator, 
                 #PlacedToSameColorValidator 
                ]  

def initialize(name = nil)
  @logger = LoggerCreator.createLoggerForClassObject(Hive::BoardState,name,nil)
  @logger.info "initializing new boardstate: #{name}"
  reset
end

def reset
  @logger.info  "Creating pieces for Board State"
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
  
  @winning_color = Hive::PieceColor::NONE
  @moves = Array.new()  #MOVE HISTORY
  @board = Array.new(BOARD_SIZE).map!{Array.new(BOARD_SIZE).map!{ |x| x = [-1,-1] } }   #THE BOARD 
  @logger.info "#{BOARD_SIZE} * #{BOARD_SIZE} * #{BOARD_HEIGHT} board grid created:"
  #puts to_s                        
end
  
  #Works under the presumption that White always begins!!
 def get_turns(player_color)
   return (@moves.length / 2).floor + ( @moves.length & 1 ) if player_color == Hive::PieceColor::WHITE 
   return (@moves.length / 2).floor if player_color == Hive::PieceColor::BLACK 
 end   
  
 def setPieces(pieces) 
    @pieces = pieces
 end

  def setBoard(board) 
    @board = board 
  end
  
  def setMoves(moves) 
    @moves = moves
  end

def nextState(move)
   nextBoardState = self.clone
   nextBoardState.makeMove(move) 
   return nextBoardState
end

def clone
  c = Hive::BoardState.new()
  c.setPieces( piecesCopy() ) 
  c.setBoard( boardCopy() )
  c.setMoves( movesCopy() )    
  return c
end

def boardCopy()  
  copy = Array.new(BOARD_SIZE).map!{Array.new(BOARD_SIZE)}   #THE BOARD 
  @board.each_index do |xI| 
    @board[xI].each_index do |yI|
      copy[xI][yI] = Array.new(@board[xI][yI]) 
    end
  end
  return copy 
end

def piecesCopy()
  copy = Array.new()
  @pieces.each_index do |i|
    copy << @pieces[i].dup
  end  
end

def movesCopy()
  return Array.new(@moves)
end

  def at(x,y,z)
      return @board[x][y][z] unless outOfBounds(x,y,z) 
      return Hive::Slot::UNCONNECTED
  end
  
  def hasPieceAt(x,y,z)
    return at(x, y, z) > Hive::Slot::UNCONNECTED && !outOfBounds(x,y,z) 
  end
  
  def hasConnectedSlotAt(x,y,z)
    return !outOfBounds(x,y,z) && at(x,y,z) < Hive::Slot::UNCONNECTED
  end
  
  def outOfBounds(x, y, z)
    return x >= Hive::BoardState::BOARD_SIZE || y >= Hive::BoardState::BOARD_SIZE || z >= @board[x][y].length || x < 0 || y < 0 || z < 0 
  end
  
  def setId(x,y,z,id)
    @board[x][y][z] = id unless outOfBounds(x, y, z)
  end
   
  def locationString(x,y,z)
    return "(x:#{x},y:#{y},z:#{z})"
  end 
    
  def get_piece_by_id(id)
    raise "#{id} does not match with any piece in #{self}" unless Hive::Piece.valid_id?(id)
    @logger.debug "getPieceById:#{id}"
    return @pieces[id]
  end
  
  def get_piece_with_color(color, piece_type)
    id = piece_type
    id += Hive::Piece::BLACK_PIECE_RANGE.min + piece_type if color == Hive::PieceColor::BLACK 
    return get_piece_by_id(id)
  end

  def pickupPiece(piece)
    raise "you cannot pick up #{piece} already other piece in hand: #{@currentPiece}" unless @currentPiece.nil? || piece == @currentPiece
    @currentPiece = piece
    
    removePieceFromBoard(piece) unless @currentPiece == piece
    #piece.pickup_count += 1
  end
  
  #FIXMME!
  def dropPiece(piece)
    raise "the piece #{piece} can not be dropped sinced it hast been picked up" unless piece == @currentPiece
    #if piece.pickup_count == 0
      placePieceBack(piece) 
      @currentPiece = nil 
    #end
    #piece.pickup_count -= 1
  end

  def colorOfWinner
    return winning_color 
  end
  
  def movesMade?
    @moves.length != 0
  end
  
  def moveCount
     @moves.length
  end
  
  def start_slot
    return Hive::Slot.new(self, START_POS_X, START_POS_Y, 0)
  end
  
  def usedPieces
    pieces = Set.new()
    @pieces.each { |p| pieces << p if p.used? }
    return pieces
  end
  
  def collectConnectedPieces(piece, collection)
    piece.forEachNeighbouringPiece do |n|
      unless collection.include?(n)
        collection << n 
        collectConnectedPieces(n, collection)
      end 
    end
  end
  
  def all_pieces_connected?
      used = usedPieces()
      return true if used.size() == 0
      connected_pieces = Set.new() 
      collectConnectedPieces(used.first, connected_pieces)
      return used.size == connected_pieces.size
  end
  
  def valid?
    return all_pieces_connected?
  end 
  
  def validMove?(player, move)
    return true if not movesMade? #todo check if the piece in move is not corrupt  
    @@validators.each do |validator|                 #common board validation-rules 
      if not validator.validate(self, player, move) 
        @logger.debug  "validator #{validator.name} FAILED"
        raise "#{move} failed the #{validator}"
        return false 
      else
        @logger.debug  "validator #{validator.name} SUCCESS"
      end
     end  
     return true #piece.validMove?( move )    #piece specific validation    
  end

  def make_move(player, move)
    begin 
      @logger.info  "playing piece at #{move.piece.boardPosition}: #{move}"
      if validMove?(player, move ) 
        place(move) 
        result = Hive::TurnState::VALID
      else
        @logger.info  "INVALID MOVE: #{move}"  
        result = Hive::TurnState::INVALID
      end
      #end
    rescue Hive::MoveException => message
      @logger.info "Move exception:#{message}"
      result = Hive::TurnState::INVALID
    end
    return result 
  end
 
  def to_s
    output = "move #{self.moveCount}--------------------------------------\n"
    output += @board.map {|x| x.inspect }.join("\n")
    output += "\n---------------------------------------------------\n"
    return output
  end
  
  def to_message
    state = @board.map {|x| x.inspect }.join("")
    return "BS.#{state}."    
  end 
  
 def getPiecesByColor(color)
  pieces = []
  if color == Hive::PieceColor::WHITE
    pieces = @pieces[Hive::Piece::WHITE_PIECE_RANGE] 
  elsif color == Hive::PieceColor::BLACK
    pieces = @pieces[Hive::Piece::BLACK_PIECE_RANGE] 
  end
    return pieces
 end
 
def eachBoardPosition
  xI, yI, zI = -1, -1, -1     
    @board.each do |x|
      xI += 1
      yI = -1
      x.each do |y|
        yI += 1
        zI = -1
        y.each do |z|
          zI += 1
          yield xI, yI, zI, z
        end  
      end 
    end
end   

def getSlotsWithTypeCode(slotType)   
  slots = Array.new()
  raise "a slot with an id higher than -1 is not a slot but a piece, use getPieceById(piece_id)" if slotType > Hive::Slot::UNCONNECTED
  
  self.eachBoardPosition do |x, y, z, value|
    if value == slotType && value < 0  
      slots << getSlotAt(x,y,z)
    end    
  end
  return slots 
end

 def moveMessage(move)
  originX, originY  = getOriginBoardPos(move)
  destX, destY  = getDestBoardPos(move)
   return "MV.#{originX}.#{originY}.#{destX}.#{destY}"
 end
 
 def bottleNeckBetweenSlots(slot1, slot2)
    side = slot1.getSide(slot2) 
    return bottleNeckToSide(slot1, side)
 end 
 
 def bottleNeckToSide(slot, side)
   counter = 0
   bottleNeckSides = slot.getDirectNeighbourSides(side) 
   unless bottleNeckSides.nil?
    bottleNeckSides.each do |side|
      x,y,z =  slot.neighbourCoords(side)
      counter += 1 if at(x, y, z) > Hive::Slot::UNCONNECTED
    end  
   end
   return counter == 2 ? true : false
 end
 
 def getPiecesAt(x,y)
   piece_ids = @board[x][y]
   pieces = Array.new()
   piece_ids.each do |id|
     pieces << @piece[id] if id > -1
   end
   return pieces
 end
 
 
 ##TODO: errorprone...
 def getNumPiecesAt(x,y) 
  count = 0
  @board[x][y].each{|id| count+=1 if id > Hive::Slot::UNCONNECTED} unless outOfBounds(x,y,0)
  return count
 end
 
 def getPieceAt(x,y,z)
   raise "out of bounds " if outOfBounds(x,y,z)
   return hasPieceAt(x, y, z) ? @pieces[ at(x,y,z) ] : nil
 end
 
 def getSlotAt(x,y,z)
   id = at(x, y, z)
   return @pieces[id] if id > Hive::Slot::UNCONNECTED
   return Hive::Slot.new(self, x,y,z, id)  
 end
 
 def removePieceFromBoard(piece)
  white = :NotANeighbour
  black = :NotANeighbour 
  if piece.used? 
     piece.forEachNeighbouringSlotOrPiece do |neighbour_slot|
         if neighbour_slot.value > Hive::Slot::UNCONNECTED
             #raise "#{neighbour_slot} is a piece"
             white = :Neighbour if neighbour_slot.color == Hive::PieceColor::WHITE      
             black = :Neighbour if neighbour_slot.color == Hive::PieceColor::BLACK     
          else    
            setId(neighbour_slot.x,neighbour_slot.y,neighbour_slot.z, slotStateAfterRemoval(piece, neighbour_slot) ) #changes the states of surrounding slots after the removal    
        end
     end    
     rx,ry,rz = piece.boardPosition   
     @logger.warn "removing #{piece}, replacing with #{Hive::Slot::slotState(white, black)}"                            
     setId(rx,ry,rz,  Hive::Slot::slotState(white, black) ) #the slot's new state after removal of the piece 
  end
 end
 
 
 private
 
 def place(move) 
   move.setDestinationCoordinates(START_POS_X, START_POS_Y, 0) unless movesMade?    
   x,y,z = move.destination
   piece = get_piece_by_id(move.moving_piece_id);
   setPieceTo(piece, x, y,z) 
   @moves << move
   @logger.debug  "PLACED: #{move}" 
 end

 def setPieceTo(piece, x ,y, z)
  @logger.debug "Placing #{piece.name} at #{x},#{y},#{z}" 
  removePieceFromBoard(piece) 
  @board[x][y].delete_if{|id| id <= Hive::Slot::UNCONNECTED }
  emptySlotCode = piece.color == Hive::PieceColor::WHITE ? Hive::Slot::EMPTY_SLOT_WHITE : Hive::Slot::EMPTY_SLOT_BLACK
  @board[x][y] += [piece.id, emptySlotCode]  
  board_z = @board[x][y].length - 2
  piece.setBoardPosition(x, y, board_z)
  piece.used = true
  resolveNeighbourStates(piece) 
 end
 
 def placePieceBack(piece)
   @board[piece.x][piece.y][piece.z] = piece.id
   resolveNeighbourStates(piece) 
 end
   
    
 def resolveNeighbourStates(piece)
  count = 0 
  piece.forEachNeighbourCoordinate do |x,y,z|
    count += 1
    case at(x,y,z)
      when Hive::Slot::UNCONNECTED then 
        if piece.color == Hive::PieceColor::WHITE 
          setId(x,y,z, Hive::Slot::EMPTY_SLOT_WHITE) 
        elsif piece.color == Hive::PieceColor::BLACK   
          setId(x,y,z,Hive::Slot::EMPTY_SLOT_BLACK) 
        end  
      when Hive::Slot::EMPTY_SLOT_BLACK then
          setId(x, y, z,Hive::Slot::EMPTY_SLOT_MIXED) if piece.color == Hive::PieceColor::WHITE   
      when Hive::Slot::EMPTY_SLOT_WHITE then
          setId(x, y ,z ,Hive::Slot::EMPTY_SLOT_MIXED)  if piece.color == Hive::PieceColor::BLACK   
    end
  end  
 end 
  

   
 def slotStateAfterRemoval(removed_piece, slot)
       white= :NotANeighbour
       black= :NotANeighbour 
       slot.forEachNeighbouringPiece do |piece|
         unless piece == removed_piece
            white = :Neighbour if piece.color == Hive::PieceColor::WHITE
            black = :Neighbour if piece.color == Hive::PieceColor::BLACK    
         end
       end   
     return Hive::Slot::slotState(white, black) 
 end 
 
 def getOriginBoardPos(move) 
    return @pieces[move.moving_piece_id].boardPosition;
 end

end