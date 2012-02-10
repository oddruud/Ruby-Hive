require 'player'

class Hive::Bot < Hive::Player  
    include DRbUndumped


  attr_reader :logger

  def initialize(name)
    super(name) 
    @logger = LoggerCreator.create_logger_for_class_object(Hive::Bot, name)
  end
    
  def make_move(board_state)
    @logger.info "#{name} makemove called"
    #thread = Thread.new{ determine_next_move(board_state) }     #TODO switch back
    #thread.join 
    determine_next_move(board_state)
  end  
  
  def determine_next_move(board_state)
    puts "WRONG"
    @logger.info "FIXME: you need to override determine_next_move"
    #move = Move.new(Piece::WHITE_QUEEN_BEE, Piece::WHITE_BEETLE1, HexagonSide::UPPER_SIDE);  
  end
  
  
  
end
