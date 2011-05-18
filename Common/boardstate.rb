require 'Insects/queenbee'  
require 'Insects/beetle'  
require 'Insects/ant'  
require 'Insects/grasshopper'  
require 'Insects/spider'  

class BoardState
 include DRbUndumped
 
attr_reader :pieces

def initialize()
 puts "Creating new Board State"
end


def start
 puts "Creating pieces for Board State"
 @pieces =  Hash.new()
 
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
end

 #returns BoardState
  def moveVirtual(piece_id, destination_piece_id, destination_side)
    nextState = self.copy 
    nextState.move(piece, destination_piece_id, destination_side) 
    return nextState
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
 





end
