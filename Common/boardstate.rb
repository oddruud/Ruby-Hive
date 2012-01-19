require "drb"
require 'Move/move' 
require 'Insects/queenbee'  
require 'Insects/beetle'  
require 'Insects/ant'  
require 'Insects/grasshopper'  
require 'Insects/spider'  
require 'Insects/mosquito'  
require 'MoveValidators/MoveValidator'
require 'MoveValidators/PlacedToSameColorValidator'
require 'MoveValidators/QueenInFourMovesValidator'
require 'LoggerCreator'

class TurnState
  GAME_OVER = :gameover
  INVALID = :invalid_move
  VALID = :valid_move
end

class BoardState
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

@@validators = [ QueenInFourMovesValidator, 
                  PlacedToSameColorValidator 
                ]  

def initialize(name = nil)
  @logger = LoggerCreator.createLoggerForClassObject(BoardState,name,nil)
  @logger.info "initializing new boardstate: #{name}"
  reset
  #yield self if block_given? 
end

def reset
puts "reset"
  @logger.info  "Creating pieces for Board State"
  @pieces =  Array.new()                                       #THE PIECES
  #WHITE PIECES
  @pieces[Piece::WHITE_QUEEN_BEE]=      QueenBee.new(self, Piece::WHITE_QUEEN_BEE)
  @pieces[Piece::WHITE_BEETLE1]=        Beetle.new(self, Piece::WHITE_BEETLE1)
  @pieces[Piece::WHITE_BEETLE2]=        Beetle.new(self,Piece::WHITE_BEETLE2)
  @pieces[Piece::WHITE_SPIDER1]=        Spider.new(self,Piece::WHITE_SPIDER1)
  @pieces[Piece::WHITE_SPIDER2]=        Spider.new(self,Piece::WHITE_SPIDER2)
  @pieces[Piece::WHITE_GRASSHOPPER1]=   GrassHopper.new(self,Piece::WHITE_GRASSHOPPER1)
  @pieces[Piece::WHITE_GRASSHOPPER2]=   GrassHopper.new(self,Piece::WHITE_GRASSHOPPER2)
  @pieces[Piece::WHITE_GRASSHOPPER3]=   GrassHopper.new(self,Piece::WHITE_GRASSHOPPER3)
  @pieces[Piece::WHITE_ANT1]=           Ant.new(self,Piece::WHITE_ANT1)
  @pieces[Piece::WHITE_ANT2]=           Ant.new(self,Piece::WHITE_ANT2)
  @pieces[Piece::WHITE_ANT3]=           Ant.new(self,Piece::WHITE_ANT3)
  @pieces[Piece::WHITE_MOSQUITO]=       Mosquito.new(self,Piece::WHITE_MOSQUITO)
    
  #BLACK PIECES
  @pieces[Piece::BLACK_QUEEN_BEE]=      QueenBee.new(self,Piece::BLACK_QUEEN_BEE)
  @pieces[Piece::BLACK_BEETLE1]=        Beetle.new(self,Piece::BLACK_BEETLE1)
  @pieces[Piece::BLACK_BEETLE2]=        Beetle.new(self,Piece::BLACK_BEETLE2)
  @pieces[Piece::BLACK_SPIDER1]=        Spider.new(self,Piece::BLACK_SPIDER1)
  @pieces[Piece::BLACK_SPIDER2]=        Spider.new(self,Piece::BLACK_SPIDER2)
  @pieces[Piece::BLACK_GRASSHOPPER1]=   GrassHopper.new(self,Piece::BLACK_GRASSHOPPER1)
  @pieces[Piece::BLACK_GRASSHOPPER2]=   GrassHopper.new(self,Piece::BLACK_GRASSHOPPER2)
  @pieces[Piece::BLACK_GRASSHOPPER3]=   GrassHopper.new(self,Piece::BLACK_GRASSHOPPER3)
  @pieces[Piece::BLACK_ANT1]=           Ant.new(self,Piece::BLACK_ANT1)
  @pieces[Piece::BLACK_ANT2]=           Ant.new(self,Piece::BLACK_ANT2)
  @pieces[Piece::BLACK_ANT3]=           Ant.new(self,Piece::BLACK_ANT3) 
  @pieces[Piece::BLACK_MOSQUITO]=       Mosquito.new(self,Piece::BLACK_MOSQUITO)
  
  @winning_color = PieceColor::NONE
  @moves = Array.new()  #MOVE HISTORY
  @board = Array.new(BOARD_SIZE).map!{Array.new(BOARD_SIZE).map!{ |x| x = [-1,-1] } }   #THE BOARD 
  @logger.info "#{BOARD_SIZE} * #{BOARD_SIZE} * #{BOARD_HEIGHT} board grid created:"
  #puts to_s                        
end
  
  #Works under the presumption that White always begins!!
 def get_turns(player_color)
   return (@moves.length / 2).floor + ( @moves.length & 1 ) if player_color == PieceColor::WHITE 
   return (@moves.length / 2).floor if player_color == PieceColor::BLACK 
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
  c = BoardState.new()
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
    if not outOfBounds(x,y,z) 
      return @board[x][y][z]
    else
      return Slot::UNCONNECTED
    end
  end
  
  def hasPieceAt(x,y,z)
    return at(x, y, z) > Slot::UNCONNECTED && !outOfBounds(x,y,z) 
  end
  
  # def coordinateDegree(x,y,z)
  #      count = 0
  #      Slot.new(x,y,z).forEachNeighbour do |x,y,z|
  #        count += 1 if not getPieceAt(x,y,z).nil?
  #      end
  #      return count
  #   end
  
  def hasConnectedSlotAt(x,y,z)
    return !outOfBounds(x,y,z) && at(x,y,z) < Slot::UNCONNECTED
  end
  
  def outOfBounds(x, y, z)
    return x >= BoardState::BOARD_SIZE || y >= BoardState::BOARD_SIZE || z >= @board[x][y].length || x < 0 || y < 0 || z < 0 
  end
  
  def setId(x,y,z,id)
    @board[x][y][z] = id unless outOfBounds(x, y, z)
  end
   
  def locationString(x,y,z)
    return "(x:#{x},y:#{y},z:#{z})"
  end 
    
  def getPieceById(id)
    raise "#{id} does not match with any piece in #{self}" if id < 0 or id > @pieces.length
    return @pieces[id]
  end
  
  def get_piece_with_color(color, piece_type)
    id = piece_type
    id += pieces.length / 2 if color == PieceColor::BLACK 
    return getPieceById(id)
  end

  def pickupPiece(piece)
    raise "you cannot pick up #{piece} already other piece in hand: #{@currentPiece}" unless @currentPiece.nil? 
    @currentPiece = piece
    
    removePieceFromBoard(piece) unless @currentPiece == piece
    piece.pickup_count += 1
  end
  
  #FIXMME!
  def dropPiece(piece)
    raise "the piece #{piece} can not be dropped sinced it hast been picked up" unless piece == @currentPiece
    if piece.pickup_count == 0
      placePieceBack(piece) 
      @currentPiece = nil 
    end
    piece.pickup_count -= 1
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
    return Slot.new(self, START_POS_X, START_POS_Y, 0)
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
  
  def allPiecesConnected?
      used = usedPieces()
      return true if used.size() == 0
      connected_pieces = Set.new() 
      collectConnectedPieces(used.first, connected_pieces)
      return used.size == connected_pieces.size
  end
  
  def valid?
    return allPiecesConnected?
  end 
  
  def validMove?(move)
    return true if not movesMade?
    piece = @pieces[move.moving_piece_id]   
    @@validators.each do |validator|                 #common board validation-rules 
      if not validator.validate(self, move) 
        @logger.debug  "validator #{validator.name} FAILED"
        raise MoveException, "#{move} failed the #{validator}"
        return false 
      else
        @logger.debug  "validator #{validator.name} SUCCESS"
      end
     end  
     return true #piece.validMove?( move )    #piece specific validation    
  end

  def makeMove(move)
    piece = getPieceById(move.moving_piece_id)
   
    begin 
      @logger.info  "playing piece at #{piece.boardPosition}: #{move.toString}"
      if validMove?( move ) 
        place(move) 
        result = TurnState::VALID
      else
        @logger.info  "INVALID MOVE: #{move}"  
        result = TurnState::INVALID
      end
      #end
    rescue MoveException => message
      @logger.info "Move exception:#{message}"
      result = TurnState::INVALID
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
  if color == PieceColor::WHITE
    pieces = @pieces[0, 11] 
  elsif color == PieceColor::BLACK
    pieces = @pieces[11, 11] 
  end
    return pieces
 end
 
def eachBoardPosition
  xI, yI, zI = -1,-1,-1     
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
  raise "a slot with an id higher than -1 is not a slot but a piece, use getPieceById(piece_id)" if slotType > Slot::UNCONNECTED
  
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
      counter += 1 if at(x, y, z) > Slot::UNCONNECTED
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
 
 def getNumPiecesAt(x,y) 
  count = 0
  @board[x][y].each{|id| count+=1 if id >-1} 
  return count
 end
 
 def getPieceAt(x,y,z)
   raise "out of bounds " if outOfBounds(x,y,z)
   return hasPieceAt(x, y, z) ? @pieces[at(x,y,z)] : nil
 end
 
 def getSlotAt(x,y,z)
   id = at(x, y, z)
   return @pieces[id] if id > Slot::UNCONNECTED
   return id <= Slot::UNCONNECTED ? Slot.new(self, x,y,z, id) : nil  
 end
 
 def removePieceFromBoard(piece)
  white = :NotANeighbour
  black = :NotANeighbour 
  if piece.used? 
     piece.forEachNeighbouringSlotOrPiece do |neighbour_slot|
         if neighbour_slot.value > Slot::UNCONNECTED
             #raise "#{neighbour_slot} is a piece"
             white = :Neighbour if neighbour_slot.color == PieceColor::WHITE      
             black = :Neighbour if neighbour_slot.color == PieceColor::BLACK     
          else    
            setId(neighbour_slot.x,neighbour_slot.y,neighbour_slot.z, slotStateAfterRemoval(piece, neighbour_slot) ) #changes the states of surrounding slots after the removal    
        end
     end    
     rx,ry,rz = piece.boardPosition   
     @logger.warn "removing #{piece}, replacing with #{Slot::slotState(white, black)}"                            
     setId(rx,ry,rz,  Slot::slotState(white, black) ) #the slot's new state after removal of the piece 
  end
 end
 
 
 private
 
 def place(move) 
   move.setDestinationCoordinates(START_POS_X, START_POS_Y, 0) unless movesMade?    
   x,y,z = move.destination
   piece = getPieceById(move.moving_piece_id);
   setPieceTo(piece, x, y,z) 
   @moves << move
   @logger.debug  "PLACED: #{move.toString}" 
 end

 def setPieceTo(piece, x ,y, z)
  @logger.debug "Placing #{piece.name} at #{x},#{y},#{z}" 
  removePieceFromBoard(piece) 
  @board[x][y].delete_if{|id| id <= Slot::UNCONNECTED }
  emptySlotCode = piece.color == PieceColor::WHITE ? Slot::EMPTY_SLOT_WHITE : Slot::EMPTY_SLOT_BLACK
  @board[x][y] += [piece.id, emptySlotCode]  
  board_z = @board[x][y].length - 2
  piece.setBoardPosition(x, y, board_z)
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
      when Slot::UNCONNECTED then 
        if piece.color == PieceColor::WHITE 
          setId(x,y,z,Slot::EMPTY_SLOT_WHITE) 
        elsif piece.color == PieceColor::BLACK   
          setId(x,y,z,Slot::EMPTY_SLOT_BLACK) 
        end  
      when Slot::EMPTY_SLOT_BLACK then
          setId(x, y, z,Slot::EMPTY_SLOT_MIXED) if piece.color == PieceColor::WHITE   
      when Slot::EMPTY_SLOT_WHITE then
          setId(x, y ,z ,Slot::EMPTY_SLOT_MIXED)  if piece.color == PieceColor::BLACK   
    end
  end  
 end 
  

   
 def slotStateAfterRemoval(removed_piece, slot)
       white= :NotANeighbour
       black= :NotANeighbour 
       slot.forEachNeighbouringPiece do |piece|
         unless piece == removed_piece
            white = :Neighbour if piece.color == PieceColor::WHITE
            black = :Neighbour if piece.color == PieceColor::BLACK    
         end
       end   
     return Slot::slotState(white, black) 
 end 
 
 def getOriginBoardPos(move) 
    return @pieces[move.moving_piece_id].boardPosition;
 end

end