require 'Insects/piece'
require 'moveexception'
require 'LoggerCreator'

class Move
  include DRbUndumped
  attr_reader :moving_piece
  attr_reader :dest_piece
  attr_reader :dest_slot
  attr_reader :moving_piece_id
  attr_reader :dest_piece_id
  attr_reader :side_id
  attr_reader :logger
  
  def initialize(moving_piece_id, dest_piece_id, side)
    @moving_piece_id = moving_piece_id
    @dest_piece_id = dest_piece_id
    @side_id = side
    @dest_slot = nil
    @logger = LoggerCreator.createLoggerForClass(Move)
  end
  
  def providePieceInstances!(boardState)
       
    @moving_piece = boardState.pieces[@moving_piece_id]
    @dest_piece = boardState.pieces[@dest_piece_id]
    
    if not @dest_piece_id == -1
      x,y = @dest_piece.neighbour(@side_id)  
      @dest_slot= Slot.new(x, y)
    end
    
    @logger.info "moving piece #{@moving_piece_id} #{@moving_piece}"
    @logger.info "destination piece #{@dest_piece_id} #{@dest_piece}" unless @dest_piece_id == -1
  end
  
  def overwriteDestination!(x,y)
      @dest_slot = Slot.new(x,y)
  end
  
  def destination 
    if @dest_slot.nil?
      raise Exception, "no valid destination slot"
    end
    return @dest_slot.boardPosition
  end 
   
  def toString
    if @dest_piece_id > 0
        return "#{Piece::NAME[@moving_piece_id]}  moves to #{Piece::NAME[@dest_piece_id]} on side #{HexagonSide::NAME[@side_id]}"
    else
       return "first piece #{Piece::NAME[@moving_piece_id]} placed on board"
     end
  end
  
  def toMessage 
    return "MV.#{Piece::NAME[@moving_piece_id]}.#{Piece::NAME[@dest_piece_id]}.#{HexagonSide::NAME[@side_id]}"
  end
  
end
