require 'Insects/queenbee'  
require 'Insects/beetle'  
require 'Insects/ant'  
require 'Insects/grasshopper'  
require 'Insects/spider'  
require 'MoveValidators/PlacedToSameColorValidator'
require 'MoveValidators/QueenInFourMovesValidator'
require 'move'  
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
attr_reader :logger   
attr_reader :winningColor   

BOARD_SIZE = 20
BOARD_HEIGHT = 2
PIECES_PER_PLAYER = 11

def initialize(name = nil)
  @logger = LoggerCreator.createLoggerForClassObject(BoardState,name,nil)
  @logger.info "initializing new boardstate: #{name}"
  reset
end

def reset
  @logger.info  "Creating pieces for Board State"
  @pieces =  Array.new()                                       #THE PIECES
  #WHITE PIECES
  @pieces[Piece::WHITE_QUEEN_BEE]= QueenBee.new()
  @pieces[Piece::WHITE_BEETLE1]= Beetle.new()
  @pieces[Piece::WHITE_BEETLE2]= Beetle.new()
  @pieces[Piece::WHITE_SPIDER1]= Spider.new()
  @pieces[Piece::WHITE_SPIDER2]= Spider.new()
  @pieces[Piece::WHITE_GRASSHOPPER1]= GrassHopper.new()
  @pieces[Piece::WHITE_GRASSHOPPER2]= GrassHopper.new()
  @pieces[Piece::WHITE_GRASSHOPPER3]= GrassHopper.new()
  @pieces[Piece::WHITE_ANT1]= Ant.new()
  @pieces[Piece::WHITE_ANT2]= Ant.new()
  @pieces[Piece::WHITE_ANT3]= Ant.new()
    
  #BLACK PIECES
  @pieces[Piece::BLACK_QUEEN_BEE]= QueenBee.new()
  @pieces[Piece::BLACK_BEETLE1]= Beetle.new()
  @pieces[Piece::BLACK_BEETLE2]= Beetle.new()
  @pieces[Piece::BLACK_SPIDER1]= Spider.new()
  @pieces[Piece::BLACK_SPIDER2]= Spider.new()
  @pieces[Piece::BLACK_GRASSHOPPER1]= GrassHopper.new()
  @pieces[Piece::BLACK_GRASSHOPPER2]= GrassHopper.new()
  @pieces[Piece::BLACK_GRASSHOPPER3]= GrassHopper.new()
  @pieces[Piece::BLACK_ANT1]= Ant.new()
  @pieces[Piece::BLACK_ANT2]= Ant.new()
  @pieces[Piece::BLACK_ANT3]= Ant.new() 
  
  (0..@pieces.length-1).each do |i|
    @pieces[i].setId(i) 
  end
  
  @winningColor = PieceColor::NONE
  @moves = Array.new()  #MOVE HISTORY
  @board = Array.new(BOARD_SIZE).map!{Array.new(BOARD_SIZE).map!{ |x| x = [-1,-1] } }   #THE BOARD 
  @logger.info "#{BOARD_SIZE} * #{BOARD_SIZE} * #{BOARD_HEIGHT} board grid created:"
  print
  
  @validators = [ QueenInFourMovesValidator, 
                  PlacedToSameColorValidator 
                ]                          
end

  def colorOfWinner
    return winningColor 
  end

 #returns BoardState
  def nextState(move)
    nextBoardState = self.copy 
    nextBoardState.makeMove(move) 
    return nextBoardState
  end
  
  def startPosX
     BOARD_SIZE/2
  end
  
  def startPosY
    BOARD_SIZE/2
  end
  
  def movesMade?
    @moves.length != 0
  end
  
  def moveCount
     @moves.length
  end
  
  def startSlot
    return Slot.new(startPosX, startPosY, 0)
  end
  
  def validMove?(move)
    
    return true if not movesMade?
    
    piece = @pieces[move.moving_piece_id]   
    @validators.each do |validator|                 #common board validation-rules 
      if not validator.validate(self, move) 
        @logger.debug  "validator #{validator.name} FAILED"
        return false 
      else
        @logger.debug  "validator #{validator.name} SUCCESS"
      end
     end  
     return piece.validMove?(self, move)    #piece specific validation    
  end

  def makeMove(move)
    
    begin 
      @logger.info  "playing #{move.toString}"
      move.providePieceInstances!(self) 
      if validMove?(move) 
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

  def copy
    newState= self.dup  # shallow copy
    newState.pieces= nil 
    newState.pieces= Hash.new()
    #copy all deeper objects
    @piece.each do |p|
      newPiece = p.copy
      newPiece.boardState = newState 
      newState.pieces << newPiece
    end  
    return newState
  end

  #TODO
  #def availableMovesByPiece(piece_id)
  #end
  
  #TODO
  #def availableMovesByColor(color)
  #end

  #TODO
  #def getSide(origin, neighbour)
  #end

 #def unusedPieces(color)
  
 #end
 
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
yI,cI, zI = -1,-1,-1     
    @board.each do |y|
      yI += 1
      cI = -1
      y.each do |c|
        cI += 1
        zI = -1
        c.each do |z|
          zI += 1
          yield yI, cI, zI, z
        end  
      end 
    end
end   


def getSlotsWithTypeCode(slotType)   
  slots = Array.new()
  
  if slotType > -1
    raise "a slot with an id higher than -1 is not a slot but a piece, use getPiece(piece_id)"
  end 
  
  self.eachBoardPosition do |x, y, z, value|
    if value == slotType && value < 0  
      slots << Slot.new(x, y, z) {|s| s.state = value} #add a slot 
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
      x,y,z =  slot.neighbour(side)
      counter += 1 if @board[x][y][z] > -1    
    end  
   end
   return counter == 2 ? true : false
 end
 
 def getPieceAt(x,y,z)
   @pieces[@board[x][y][z]]
 end
 
 def getSlotAt(x,y,z)
   return @pieces[@board[x][y][z]] if @board[x][y][z] > -1
   return Slot.new(x,y,z){|s| s.state = @board[x][y][z]} if @board[x][y][z] < -1
   return nil
 end
 
 private
 
 def place(move) 
   move.setDestinationCoordinates(startPosX, startPosY, 0) unless movesMade?    
   x,y,z = move.destination
   setPieceTo(move.moving_piece_id, x, y,z) 
   @moves << move
   @logger.debug  "PLACED: #{move.toString}" 
 end

 def setPieceTo(piece_id, x ,y,z)
  @logger.debug "Placing #{@pieces[piece_id].class.name} at #{x},#{y},#{z}" 
  removePieceFromBoard(piece_id) 
  piece = @pieces[piece_id];
  
  board_z = 0 
  if (@board[x][y][0] < 0)
    emptySlotCode = piece.color == PieceColor::WHITE ? Slot::EMPTY_SLOT_WHITE : Slot::EMPTY_SLOT_BLACK 
    @board[x][y]= [piece_id, emptySlotCode]   
  else
    board_z = 1
    @board[x][y]= [@board[x][y], piece_id] 
  end
    
  piece.setBoardPosition(x, y, board_z)
  resolveNeighbourStates(piece) 
 end
  
  def self.outOfBounds?(x, y)
    return x >= BoardState::BOARD_SIZE || y >= BoardState::BOARD_SIZE
  end
  
    
  
 def resolveNeighbourStates(piece)
   #@logger.info "resolving neighbour states"
  
  count = 0 
  piece.forEachNeighbour do |x,y,z|
    count += 1
    @logger.info "resolving for neighbour #{count} - #{x}, #{y}, #{z}"
    
    raise "Out of Boardbounds exception" if BoardState.outOfBounds?(x,y)
    
    case @board[x][y][z]
      when Slot::UNCONNECTED then 
        if piece.color == PieceColor::WHITE   
          @board[x][y][z] = Slot::EMPTY_SLOT_WHITE 
        elsif piece.color == PieceColor::BLACK   
          @board[x][y][z] = Slot::EMPTY_SLOT_BLACK 
        end  
      when Slot::EMPTY_SLOT_BLACK then
          @board[x][y][z] = Slot::EMPTY_SLOT_MIXED if piece.color == PieceColor::WHITE   
      when Slot::EMPTY_SLOT_WHITE then
          @board[x][y][z] = Slot::EMPTY_SLOT_MIXED  if piece.color == PieceColor::BLACK   
    end
    #@logger.info "resolved to #{ @board[x][y][z]}"
  end  
 end 
  
 def removePieceFromBoard(piece_id)
  white = :NotANeighbour
  black = :NotANeighbour 
  piece = @pieces[piece_id]
  if piece.used 
     piece.forEachNeighbouringSlotOrPiece(self) do |slot|
         if slot.class == Piece
             white = :Neighbour if @pieces[@board[x][y][z]].color == PieceColor::WHITE      
             black = :Neighbour if @pieces[@board[x][y][z]].color == PieceColor::BLACK     
          else    
             @board[slot.x][slot.y][slot.z] = slotStateAfterRemoval(piece, slot)       #changes the states of surrounding slots after the removal    
        end
     end    
     rx,ry,rz = piece.boardPosition                                
     @board[rx][ry][rz] = Slot::slotState(white, black)    #the slot's new state after removal of the piece 
  end
 end 
   
 def slotStateAfterRemoval(removed_piece, slot)
       white= :NotANeighbour
       black= :NotANeighbour 
       slot.forEachNeighbouringPiece(self) do |piece|
         unless piece == removed_piece
            white = :Neighbour if piece.color == PieceColor::WHITE
            black = :Neighbour if piece.color == PieceColor::BLACK    
         end
       end   
     return Slot::slotState(white, black) 
 end 
 
 def getOriginBoardPos(move) 
    return move.moving_piece.boardPosition;
 end

end