require 'Insects/queenbee'  
require 'Insects/beetle'  
require 'Insects/ant'  
require 'Insects/grasshopper'  
require 'Insects/spider'  
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
  
  (0..21).each do |i|
    @pieces[i].id = i 
  end
  
  @board = Array.new(BOARD_SIZE).map!{Array.new(BOARD_SIZE, -1)}   #THE BOARD
  @moves = Array.new()                                        #MOVE HISTORY
  
=begin
  [2][3]
  [7][1][4]
    [6][5]
=end 
end

 #returns BoardState
  def tryMove(move)
    nextState = self.copy 
    nextState.makeMove(move) 
    return nextState
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
  
  def fourthPieceToBePlaced?  #RULE condition its a rule that the queen need to be placed within 4 moves
     @moves.length == 6 || @moves.length == 7 
  end
  
  def getQueenFromPieceId(id)
      if Piece.color(id) == PieceColor::WHITE
        queen = @pieces[WHITE_QUEEN_BEE]
      else
        queen = @pieces[BLACK_QUEEN_BEE]
      end
      return queen          
  end
  
  
  def makeMove(move)
    queen = getQueenFromPieceId(move.moving_piece_id)
    if not movesMade? 
      setPieceTo(move.moving_piece_id, startPosX , startPosY)   #FIRST MOVE 
    elsif fourthPieceToBePlaced?  && queen.used == false && move.moving_piece_id !=  Piece::QUEEN_BEE         
      raise  MoveException, "invalid move: you must play the queen bee within the first 4 moves"      
    else
      place(move)
    end 
    @moves << move
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

  def availableMovesByPiece(piece_id)

  end

  def availableMovesByColor(color)

  end

  def getSide(origin, neighbour)

  end
  
  

 #return Boolean 
 def isValidMove(piece_id, destination_piece_id, destination_side) 
   return piece.isValidMove(destination_piece_id, destination_side)
 end

 def unusedPieces(color)
  
 end
 
def position(piece_id, x ,y)
  @board[x][y]= piece_id 
end

def moveMessage(move)
  originX, originY  = getOriginBoardPos(move)
  destX, destY  = getDestBoardPos(move)
   return "MV.#{originX}.#{originY}.#{destX}.#{destY}"
 end
 

 private
 
 def place(move)
    x,y = getBoardPos(move)
    if @board[x][y] == EMPTY_SLOT_MIXED &&  @pieces[move.moving_piece_id].used==false
       raise  MoveException, "invalid move: cannot place new #{Piece::PIECE_NAME[move.moving_piece_id]} next to opposite side"
    end
    setPieceTo(move.moving_piece_id, x, y) 
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