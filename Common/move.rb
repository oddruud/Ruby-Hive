require 'Insects/piece'
require 'moveexception'
class Move
  include DRbUndumped
  attr_reader :moving_piece_id
  attr_reader :dest_piece_id
  attr_reader :side_id
  
  def initialize(moving_piece_id, dest_piece_id, side)
   @moving_piece_id = moving_piece_id
   @dest_piece_id = dest_piece_id
   @side_id = side
  end
  
  def toString
    if @dest_piece_id !=-1
        return "#{Piece::NAME[@moving_piece_id]}  moves to #{Piece::NAME[@dest_piece_id]} on side #{HexagonSide::NAME[@side_id]}"
    else
       return "first piece #{Piece::NAME[@moving_piece_id]} placed on board"
     end
  end
  
  def toMessage  #TODO change to old boards coordinates to new coordinates
    return "MV.#{Piece::NAME[@moving_piece_id]}.#{Piece::NAME[@dest_piece_id]}.#{HexagonSide::NAME[@side_id]}"
  end
  
end
