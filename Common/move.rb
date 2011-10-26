require 'Insects/piece'
require 'moveexception'
require 'LoggerCreator'

class Move
  include DRbUndumped
  
  attr_reader :dest_slot
  attr_reader :moving_piece_id
  attr_reader :logger
  
  #attr_reader :relative_id
  #attr_reader :side
    
  def initialize(piece_id, slot)
    @moving_piece_id = piece_id
    @dest_slot = slot
    @logger = LoggerCreator.createLoggerForClass(Move)
    raise "piece_id is NILL" if piece_id.nil? 
    @relative_id = -1
    @side = -1 
    
    yield self if block_given?
  end
  
  def self.fromCords(piece_id, x, y, z)
    return Move.new(piece_id, Slot.new(x,y,z))
  end
  
  def self.fromRelativeCords(piece_id, neighbour, side)
     @relative_id = neighbour.id  
     @side = side
     puts "relative" + @relative_id.to_s
    x,y,z = neighbour.neighbour(side)
    return Move.fromCords(piece_id, x,y,z)do |mv| 
      mv.relative_id = neighbour.id 
      mv.side = side
    end  
  end 
   
  def setDestinationCoordinates(x, y, z) 
      @dest_slot = Slot.new(x,y,z)
  end
  
  def setDestinationSlot(slot) 
    @dest_slot = slot 
  end
  
  def destination 
    return @dest_slot.boardPosition
  end 
  
  def toString
    return "Absolute Move #{Piece::NAME[@moving_piece_id]} to #{@dest_slot.to_s}"
  end

  def to_s
    toString
  end
 
  def toStringVerbose(boardState)
    
    if @relative_id < 0 
      piece = boardState.pieces[@moving_piece_id]
      neighbour = piece.neighbouringPieces(boardState,1)[0]
      @relative_id = neighbour.id 
      side_id = neighbour.getSide(piece)
      sideName= HexagonSide::sideName(side_id)
    else
      sideName= HexagonSide::sideName(side_id) + "(predefined)"
    end
    return "Relative Move #{Piece::NAME[@moving_piece_id]} connected to #{Piece::NAME[@relative_id]} at side #{sideName}"
  end
  
  def to_message 
    return "MV.#{Piece::NAME[@moving_piece_id]}.#{@dest_slot.x}.#{@dest_slot.y}.#{@dest_slot.y}"
  end
  
  def ==( move )
   return move.moving_piece_id == @moving_piece_id && move.dest_slot == @dest_slot ? true:false
  end
  
end
