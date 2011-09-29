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
 
attr_reader :pieces   #1D array [piece_id] -> Piece
attr_reader :board     #2D array [x][y] -> piece_id          
attr_reader :moves     #1D array [i] -> Move

BOARD_SIZE = 50
UNCONNECTED = -1
EMPTY_SLOT_WHITE = -2
EMPTY_SLOT_BLACK = -3
EMPTY_SLOT_MIXED = -4


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
  
  (0..@pieces.length).each do |i|
    @pieces[i].id = i 
  end
  
  @board = Array.new(BOARD_SIZE).map!{Array.new(BOARD_SIZE, -1)}   #THE BOARD
  @validators = [ QueenInFourMovesValidator, 
                  PlacedToSameColorValidator 
                ]
  @moves = Array.new()                                        #MOVE HISTORY
  
=begin
  [2][3]
  [7][1][4]
    [6][5]
=end 
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
    queen = getQueenFromPieceId(move.moving_piece_id)
    if not movesMade? 
      setPieceTo(move.moving_piece_id, startPosX , startPosY)   #FIRST MOVE 
    else if validMove? move
      place(move)
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
    moving_piece = @pieces[move.moving_piece_id]
    x,y = moving_piece.boardPosition 
    setPieceTo(move.moving_piece_id, x, y) 
    @moves << move
 end

 def setPieceTo(piece_id, x ,y)
  removePieceFromBoard(piece_id) 
  @board[x][y]= piece_id 
  @pieces[piece_id].setBoardPosition(x,y)     
  (0..6).each do |i| 
    nx,ny = @pieces[piece_id].neighbour(i)
    case @board[nx][ny]
      when UNCONNECTED then 
        if Piece.color(piece_id)== PieceColor::WHITE   
          @board[nx][ny] = EMPTY_SLOT_WHITE 
        elsif Piece.color(piece_id)== PieceColor::BLACK   
          @board[nx][ny] = EMPTY_SLOT_BLACK 
        end  
      when EMPTY_SLOT_BLACK then
        if Piece.color(piece_id)== PieceColor::WHITE   
          @board[nx][ny] = EMPTY_SLOT_MIXED
        end 
      when EMPTY_SLOT_WHITE then
        if Piece.color(piece_id)== PieceColor::BLACK   
          @board[nx][ny] = EMPTY_SLOT_MIXED
        end  
    end
  end   
 end
  
 def removePieceFromBoard(piece_id)
  white = 0
  black = 0 
  if @pieces[piece_id].used==true
     (0..6).each do |i|                                               
        nx,ny = @pieces[piece_id].neighbour(i)                        #get the absolute position of the neighbour on the board
        case @board[nx][ny]
          when EMPTY_SLOT_BLACK then 
          when EMPTY_SLOT_WHITE then
          when EMPTY_SLOT_MIXED then   
              @board[nx][ny] = slotStateAfterRemoval(piece_id, nx,ny)       #changes the states of surrounding slots after the removal    
          else    
              if @pieces[@board[nx][ny]].color == PieceColor::WHITE       #WHITE PIECE NEIGHBOUR 
                white = 1
              end         
              if @pieces[@board[nx][ny]].color == PieceColor::BLACK       #BLACK PIECE NEIGHBOUR
                black = 1
              end       
        end
     end   
     
     rx,ry= @pieces[piece_id].boardPosition                                   #the slot's new state after removal of the piece 
     if white == 1 && black == 1 
       @board[rx][ry] = EMPTY_SLOT_MIXED
     elsif white == 1 && black == 0 
       @board[rx][ry] = EMPTY_SLOT_WHITE
     elsif white == 0 && black == 1
       @board[rx][ry] = EMPTY_SLOT_BLACK
     end
      
  end
 end 
  
 def slotStateAfterRemoval(removed_piece, slotx, sloty)
       state=-1
       white=0 
       black=0
       
       rx,ry = @board[removed_piece] 
       
       (0..6).each do |i| 
         nx, ny = Slot.neighbour(slotx,sloty,i)
         case @board[nx][ny]
          when UNCONNECTED then 
          when EMPTY_SLOT_BLACK then 
          when EMPTY_SLOT_WHITE then
          when EMPTY_SLOT_MIXED then
          
          else
            if @pieces[@board[nx][ny]].color == PieceColor::WHITE
                white = 1
            end         
            if @pieces[@board[nx][ny]].color == PieceColor::BLACK
                black = 1
            end         
        end      
       end  
       
     if white == 1 && black == 1 
      state = EMPTY_SLOT_MIXED
     elsif white == 1 && black == 0 
      state = EMPTY_SLOT_WHITE
     elsif white == 0 && black == 1
      state = EMPTY_SLOT_BLACK
     elsif white == 0 && black == 0
      state = UNCONNECTED
     end
     
     return state 
 end 

def getAttachedPieces(piece_id)
  attached = Array.new()
  (0..6).each do |i| 
    id = @piece[piece_id].neighbour(i) 
    if id > -1
      attached << id
    end
  end
  return attached
end
  
 def getDestBoardPos(move) 
   return @pieces[move.dest_piece_id].neighbour(move.side_id);
 end
 
 def getOriginBoardPos(move) 
   return @pieces[move.moving_piece_id].boardPosition;
 end


end