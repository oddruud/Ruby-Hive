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
    return "#{Piece::NAME[@moving_piece_id]}  moves to #{Piece::NAME[@dest_piece_id]} on side #{HexagonSide::NAME[@side_id]}"
  end
  
end