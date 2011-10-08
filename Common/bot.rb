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
    thread = Thread.new{ calculateNextMove(boardState) }
    thread.join 
  end  
  
  def calculateNextMove(boardState)
    @logger.info "calculating move.."
    move = Move.new(Piece::WHITE_QUEEN_BEE, Piece::WHITE_BEETLE1, HexagonSide::UPPER_SIDE);  
    
  end
  
  
  
end
