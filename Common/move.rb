require 'Insects/piece'
require 'moveexception'
class Move
  include DRbUndumped
  attr_reader :moving_piece_id
  attr_reader :dest_piece_id
  attr_reader :side_id
  
  def initialize(moving_piece_id, dest_piece_id, side)
   @moving_piece_id = moving_piece
   @dest_piece_id = dest_piece
   @side_id = side 
  end
  
  def toString
    return "Queen bee connects to ant 3 at slot 3"
  end
  
end
