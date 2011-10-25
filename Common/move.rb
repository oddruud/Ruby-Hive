require 'Insects/piece'
require 'moveexception'
require 'LoggerCreator'

class Move
  include DRbUndumped
  
  attr_reader :dest_slot
  attr_reader :moving_piece_id
  attr_reader :logger
  
  def initialize(piece_id, slot)
    @moving_piece_id = piece_id
    @dest_slot = slot
    @logger = LoggerCreator.createLoggerForClass(Move)
    yield self if block_given?
  end
  
  def self.fromCords(piece_id, x, y, z)
    return Move.new(piece_id, Slot.new(x,y,z))
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
  
  def to_message 
    return "MV.#{Piece::NAME[@moving_piece_id]}.#{@dest_slot.x}.#{@dest_slot.y}.#{@dest_slot.y}"
  end
  
end
