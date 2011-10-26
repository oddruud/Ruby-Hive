require 'player'
require 'gamehandler'
require 'boardstate'
require 'LoggerCreator'

class Bot < Player  
    include DRbUndumped


  attr_reader :logger

  def initialize(name)
    super(name) 
    @logger = LoggerCreator.createLoggerForClassObject(Bot, name)
  end
    
  def makeMove(boardState)
    @logger.info "#{name} makemove called"
    #thread = Thread.new{ determineNextMove(boardState) }
    #thread.join 
     determineNextMove(boardState)
  end  
  
  def determineNextMove(boardState)
    @logger.info "you nee to override determineNextMove"
    #move = Move.new(Piece::WHITE_QUEEN_BEE, Piece::WHITE_BEETLE1, HexagonSide::UPPER_SIDE);  
  end
  
  
  
end
