require 'Insects/queenbee'  
require 'Insects/beetle'  
require 'Insects/ant'  
require 'Insects/grasshopper'  
require 'Insects/spider'  
require 'MoveValidators/PlacedToSameColorValidator'
require 'MoveValidators/QueenInFourMovesValidator'
require 'move'  

class BoardState
 include DRbUndumped
 
attr_reader :pieces    #1D array [piece_id] -> Piece
attr_reader :board     #2D array [x][y] -> piece_id          
attr_reader :moves     #1D array [i] -> Move

BOARD_SIZE = 50

def initialize()
 puts "Creating new Board State"
end

def start
  puts "Creating pieces for Board State"
  @pieces =  Hash.new()                                       #THE PIECES
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
    @pieces[i].id = i 
  end
  
  @board = Array.new(BOARD_SIZE).map!{Array.new(BOARD_SIZE, -1)}   #THE BOARD
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
  
  def validMove?(move)
    piece = @piece[move.moving_piece_id]   
    @validators.each do |validator|                 #common board validation-rules 
      if not validator.validate(self, move) 
        return false 
      end
     end  
     return piece.validator.validate(self, move)    #piece specific validation    
  end

  def makeMove(move)
    begin 
      move.providePieceInstances(self)
      unless movesMade? 
        setPieceTo(move.moving_piece_id, startPosX , startPosY)   #FIRST MOVE 
      else 
        if validMove?(move) 
         place(move) 
        else
          puts "INVALID MOVE"  
        end
      end
    rescue MoveException => message
      puts "Move exception:#{message}"
    end
  end
 
  def print
    count=0
    @board.each do |y|
      line= ""
      y.each do |c|
          line= line + c.to_s   
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
  def availableMovesByPiece(piece_id)
  end
  
  #TODO
  def availableMovesByColor(color)
  end

  #TODO
  def getSide(origin, neighbour)
  end

 def unusedPieces(color)
  
 end
 
def position(piece_id, x ,y)
  @board[x][y]= piece_id 
  @pieces[piece_id].setBoardPosition(x, y) 
end

def moveMessage(move)
  originX, originY  = getOriginBoardPos(move)
  destX, destY  = getDestBoardPos(move)
   return "MV.#{originX}.#{originY}.#{destX}.#{destY}"
 end
 

 private
 

 def place(move)
    x,y = move.moving_piece.boardPosition 
    setPieceTo(move.moving_piece_id, x, y) 
    @moves << move
 end

 def setPieceTo(piece_id, x ,y)
  removePieceFromBoard(piece_id) 
  piece = @pieces[piece_id];
  @board[x][y]= piece_id 
  piece.setBoardPosition(x,y)
  resolveNeighbourStates(piece) 
 end
  
 def resolveNeighbourStates(piece)
  piece.forEachNeighbour do |x,y|
    case @board[x][y]
      when Slot::UNCONNECTED then 
        if piece.color == PieceColor::WHITE   
          @board[x][y] = Slot::EMPTY_SLOT_WHITE 
        elsif piece.color == PieceColor::BLACK   
          @board[x][y] = Slot::EMPTY_SLOT_BLACK 
        end  
      when Slot::EMPTY_SLOT_BLACK then
          @board[x][y] = Slot::EMPTY_SLOT_MIXED if piece.color == PieceColor::WHITE   
      when Slot::EMPTY_SLOT_WHITE then
          @board[x][y] = Slot::EMPTY_SLOT_MIXED  if piece.color == PieceColor::BLACK   
    end
  end  
 end 
  
 def removePieceFromBoard(piece_id)
  white = :NotANeighbour
  black = :NotANeighbour 
  piece = @pieces[piece_id]
  if piece.used == true
     piece.forEachNeighbour do |x,y|
        case @board[x][y]
          when Slot::UNCONNECTED then 
          when Slot::EMPTY_SLOT_BLACK then 
          when Slot::EMPTY_SLOT_WHITE then
          when Slot::EMPTY_SLOT_MIXED then   
              @board[x][y] = slotStateAfterRemoval(piece_id, nx,ny)       #changes the states of surrounding slots after the removal    
          else    
              white = :Neighbour if @pieces[@board[x][y]].color == PieceColor::WHITE      
              black = :Neighbour if @pieces[@board[x][y]].color == PieceColor::BLACK     
        end
     end    
     rx,ry= piece.boardPosition                                   #the slot's new state after removal of the piece 
     @board[rx][ry] = Slot::slotState?(white, black)
  end
 end 
  
 
 def slotStateAfterRemoval(removed_piece, slotx, sloty)
       white= :NotANeighbour
       black= :NotANeighbour
       rx,ry = @board[removed_piece] 
       slot = Slot.new(slotx,sloty)
       slot.forEachNeighbour do |x,y|
         case @board[x][y]
          when Slot::UNCONNECTED then 
          when Slot::EMPTY_SLOT_BLACK then 
          when Slot::EMPTY_SLOT_WHITE then
          when Slot::EMPTY_SLOT_MIXED then
          else
            white = :Neighbour if @pieces[@board[x][y]].color == PieceColor::WHITE
            black = :Neighbour if @pieces[@board[x][y]].color == PieceColor::BLACK    
        end      
       end   
     return Slot::slotState?(white, black) 
 end 
  
 def getDestBoardPos(move) 
   return move.dest_piece.neighbour(move.side_id);
 end
 
 def getOriginBoardPos(move) 
    return move.moving_piece.boardPosition;
 end

end