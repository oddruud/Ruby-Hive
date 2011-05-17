require 'Insects/piece'
class Move
  include DRbUndumped
  attr_accessor :moving_piece
  attr_accessor :dest_piece
  attr_accessor :side
  
  def initialize(moving_piece, dest_piece, side)
   @moving_piece = moving_piece
   @dest_piece = dest_piece
   @side = side 
  end
  
  def toString
    return "Queen bee connects to ant 3 at slot 3"
  end
  
end
