require 'player'

class Hive::Bot < Hive::Player  
    include DRbUndumped


  attr_reader :logger

  def initialize(name)
    super(name) 
    @logger = LoggerCreator.createLoggerForClassObject(Hive::Bot, name)
  end
    
  def makeMove(boardState)
    @logger.info "#{name} makemove called"
    #thread = Thread.new{ determineNextMove(boardState) }     #TODO switch back
    #thread.join 
    determineNextMove(boardState)
  end  
  
  def determineNextMove(boardState)
    puts "WRONG"
    @logger.info "FIXME: you need to override determineNextMove"
    #move = Move.new(Piece::WHITE_QUEEN_BEE, Piece::WHITE_BEETLE1, HexagonSide::UPPER_SIDE);  
  end
  
  
  
end
