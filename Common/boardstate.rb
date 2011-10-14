require 'Insects/queenbee'  
require 'Insects/beetle'  
require 'Insects/ant'  
require 'Insects/grasshopper'  
require 'Insects/spider'  
require 'MoveValidators/PlacedToSameColorValidator'
require 'MoveValidators/QueenInFourMovesValidator'
require 'move'  
require 'LoggerCreator'

class BoardState
 include DRbUndumped
 
attr_reader :pieces    #1D array [piece_id] -> Piece
attr_reader :board     #2D array [x][y][z] -> piece_id          
attr_reader :moves     #1D array [i] -> Move
attr_reader :logger   

BOARD_SIZE = 10
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
  
  @board = Array.new(BOARD_SIZE).map!{Array.new(BOARD_SIZE, [-1,-1])}   #THE BOARD
  
  @logger.info "#{BOARD_SIZE}* #{BOARD_SIZE} board grid created:"
  print 
  
  @validators = [ QueenInFourMovesValidator, 
                  PlacedToSameColorValidator 
                ]
                
  @moves = Array.new()                                        #MOVE HISTORY
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
        @logger.info  "validator #{validator.name} FAILED"
        return false 
      else
        @logger.info  "validator #{validator.name} SUCCESS"
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
      else
        @logger.info  "INVALID MOVE: #{move}"  
      end
      #end
    rescue MoveException => message
      @logger.info "Move exception:#{message}"
    end
  end
 
  def print
    count=0
    @board.each do |y|
      line= ""
      y.each do |c|
          line= line + c[0].to_s   
      end
      puts line
    end
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
  @logger.info "getPiecesByColor: #{color}"
  
  if color == PieceColor::WHITE
    pieces = @pieces[0, 11] 
    @logger.info "white pieces: #{pieces}"
  elsif color == PieceColor::BLACK
    pieces = @pieces[11, 11] 
    @logger.info "black pieces: #{pieces}"
  end
  
    return pieces
 end
 
 #    emptySlotType =  Slot.colorsToEmptySlotType([color()])

def eachBoardPosition
yI,cI, zI = 0,0,0     
    @board.each do |y|
      yI+=1
      y.each do |c|
        zI+=1
        c.each do |z|
          zI+=1
          yield yI, cI, zI, z
        end  
      end 
    end
end   


def getSlotsWithTypeCode(slotType)   
  slots = []
  
  if slotType > -1
    raise "a slot with an id higher than -1 is not a slot but a piece, use getPiece(piece_id)"
  end 
  
  self.eachBoardPosition do |x,y,z, value|
    if value == slotType && value < 0  
      slots << Slot.new(x,y,z){|s| s.state = value} #add a slot 
    end    
  end
  return slots 
end

  
#def position(piece_id, x ,y)
#  @board[x][y]= piece_id 
#  @pieces[piece_id].setBoardPosition(x, y) 
#end

def moveMessage(move)
  originX, originY  = getOriginBoardPos(move)
  destX, destY  = getDestBoardPos(move)
   return "MV.#{originX}.#{originY}.#{destX}.#{destY}"
 end
 

 private
 
 def place(move) 
   move.setDestinationCoordinates(startPosX, startPosY, 0) unless movesMade?    
   x,y,z = move.destination
   setPieceTo(move.moving_piece_id, x, y,z) 
   @moves << move
   @logger.info  "PLACED: #{move.toString}" 
 end

 def setPieceTo(piece_id, x ,y,z)
  @logger.info "Placing #{@pieces[piece_id].class.name} at #{x},#{y},#{z}" 
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
  
 def resolveNeighbourStates(piece)
  piece.forEachNeighbour do |x,y,z|
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
  end  
 end 
  
 def removePieceFromBoard(piece_id)
  white = :NotANeighbour
  black = :NotANeighbour 
  piece = @pieces[piece_id]
  if piece.used == true
     piece.forEachNeighbour do |x,y,z|
        case @board[x][y][z]
          when Slot::UNCONNECTED then 
          when Slot::EMPTY_SLOT_BLACK then 
          when Slot::EMPTY_SLOT_WHITE then
          when Slot::EMPTY_SLOT_MIXED then   
              @board[x][y][z] = slotStateAfterRemoval(piece_id, nx,ny)       #changes the states of surrounding slots after the removal    
          else    
              white = :Neighbour if @pieces[@board[x][y][z]].color == PieceColor::WHITE      
              black = :Neighbour if @pieces[@board[x][y][z]].color == PieceColor::BLACK     
        end
     end    
     rx,ry= piece.boardPosition                                   #the slot's new state after removal of the piece 
     @board[rx][ry][0] = Slot::slotState?(white, black) #Todo
  end
 end 
  
 
 def slotStateAfterRemoval(removed_piece, slotx, sloty)
       white= :NotANeighbour
       black= :NotANeighbour
       rx,ry = @board[removed_piece] 
       slot = Slot.new(slotx,sloty)
       slot.forEachNeighbour do |x,y,z|
         case @board[x][y][z]
          when Slot::UNCONNECTED then 
          when Slot::EMPTY_SLOT_BLACK then 
          when Slot::EMPTY_SLOT_WHITE then
          when Slot::EMPTY_SLOT_MIXED then
          else
            white = :Neighbour if @pieces[@board[x][y][z]].color == PieceColor::WHITE
            black = :Neighbour if @pieces[@board[x][y][z]].color == PieceColor::BLACK    
        end      
       end   
     return Slot::slotState?(white, black) 
 end 
 
 def getOriginBoardPos(move) 
    return move.moving_piece.boardPosition;
 end

end