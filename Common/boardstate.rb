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
  
  @board = Array.new(BOARD_SIZE, Array.new(BOARD_SIZE, -1))   #THE BOARD
  @moves = Array.new()                                        #WHITE
  
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
  
  def makeMove(move)
    if @moves.length == 0 #First move, place it in the center of the board:
       if move.moving_piece_id !=  Piece::QUEEN_BEE  
         @board[BOARD_SIZE/2][BOARD_SIZE/2] = move.moving_piece_id 
          @pieces[move.moving_piece_id].x = BOARD_SIZE/2
          @pieces[move.moving_piece_id].y = BOARD_SIZE/2
       else
         raise  MoveException, "invalid move: you can only add the QUEEN BEE in the Fourth Move"
       end
    elsif @moves.length == 6 || @moves.length == 7 #only the Queen Bee may be placed  
      if move.moving_piece_id !=  Piece::QUEEN_BEE  
         raise  MoveException, "invalid move: you must play the queen bee"
       else
          place(move)
       end
    else
      place(move)
    end
  end
  
  def print
    @board.each do |r|
      print "\n"
      r.each do |c|
        if c!=-1
          print c.to_s   
        else
          print " "
        end 
      end
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

 #return Boolean 
 def isValidMove(piece_id, destination_piece_id, destination_side) 
   return piece.isValidMove(destination_piece_id, destination_side)
 end

 def unusedPieces(color)
  
 end
 
 private
 
 def place(move)
    x,y = getBoardPos(move)
    #TODO is valid check:
    @board[x][y] = move.moving_piece_id 
 end

 def setPieceTo(piece_id, x ,y)
  
 end
 
 def getBoardPos(move)
    xdif = 0 
    ydif = 0 
    x = @pieces[move.destination_piece_id].x 
    y = @pieces[move.destination_piece_id].y    
    side = move.side_id
  
#SIDE ENUMS
=begin
    2
7     3
   1   
6     4
   5
   
  [2][3]
  [7][1][4]
    [6][5]
=end 
 case side 
      when UPPER_SIDE then 
        xdif, ydif= 0, 0 
      when TOP_SIDE then 
        xdif, ydif= -1, -1 
      when TOP_RIGHT_SIDE then 
        xdif, ydif= 0, -1  
      when BOTTOM_RIGHT_SIDE then 
        xdif, ydif= 1, 0  
      when BOTTOM_SIDE then 
        xdif, ydif= 1, 1  
      when BOTTOM_LEFT_SIDE then 
        xdif, ydif= 0, 1  
      when TOP_LEFT_SIDE then 
        xdif, ydif= -1, 0 
      else
        raise MoveException, "non excisting side #{side}"
 end
 
  return x+xdif,y+ydif
end

end