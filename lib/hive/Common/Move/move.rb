require 'Insects/piece'
require 'Move/moveexception'
require 'LoggerCreator'

class Hive::Move
  include DRbUndumped
  
  attr_reader :dest_slot
  attr_reader :moving_piece_id
  attr_reader :logger
  attr_reader :piece
  
  #attr_reader :relative_id
  #attr_reader :side
    
  def initialize(piece, slot)
    @piece = piece
    @dest_slot = slot
    @logger = LoggerCreator.createLoggerForClass(Hive::Move)
    raise "piece_id is weird: #{piece.id}" unless Hive::Piece.valid_id?(piece.id)
    @relative_id = -1
    @side = -1 
    yield self if block_given?
  end
  
  def piece 
    return @piece
  end
  
  def moving_piece_id 
    return @piece.id
  end
  
  def self.fromCords(piece, x, y, z)
    return Hive::Move.new(piece, Slot.new(nil, x,y,z))
  end
  
  def self.fromRelativeCords(piece, neighbour, side)
     @relative_id = neighbour.id  
     @side = side
     puts "relative" + @relative_id.to_s
    x,y,z = neighbour.neighbour(side)
    return Hive::Move.fromCords(piece, x,y,z) do |mv| 
      mv.relative_id = neighbour.id 
      mv.side = side
    end  
  end 
   
  def color
    return Hive::Piece.colorById( moving_piece_id ) 
  end
  
  def setDestinationCoordinates( x, y, z ) 
      @dest_slot = Hive::Slot.new(nil, x, y, z)
  end
  
  def setDestinationSlot(slot) 
    @dest_slot = slot 
  end
  
  def destination 
    return @dest_slot.boardPosition
  end 
  
  def toString
    return "#{Hive::Piece::NAME[moving_piece_id]} (id: #{moving_piece_id}) to #{@dest_slot.to_s}"
  end

  def to_s
    toString
  end
 
  def toStringVerbose(boardState)
    
    if @relative_id < 0 
      puts "toStringVerbose id #{moving_piece_id}"
      piece = boardState.pieces[moving_piece_id]
      neighbour = piece.neighbouringPieces(boardState, 1).first
      
      if  neighbour.nil? 
        return "Relative Move #{Piece::NAME[moving_piece_id]} NOT connected to other pieces"
      end
  
        @relative_id = neighbour.id 
        puts "relative id: #{@relative_id}"
        side_id = neighbour.getSide(piece)
        sideName= HexagonSide::sideName(side_id) unless side_id.nil?
    else
      sideName= HexagonSide::sideName(side_id) + "(predefined)"
    end
    return "Relative Move #{Piece::NAME[moving_piece_id]} connected to #{Piece::NAME[@relative_id]} at side #{sideName}"
  end
  
  def to_message 
    return "MV.#{Piece::NAME[moving_piece_id]}.#{@dest_slot.x}.#{@dest_slot.y}.#{@dest_slot.y}"
  end
  
  def == ( move )
   return move.moving_piece_id == moving_piece_id && move.dest_slot == @dest_slot ? true:false
  end
  
end
