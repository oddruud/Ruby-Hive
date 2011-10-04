require "Common/bot"
require "LoggerCreator"

class NaiveBot < Bot
      include DRbUndumped
  
  #attr_reader :logger
  
  def initialize(name)
    super("Naive Bot:#{name}") 
  end
 
  def calculateNextMove(boardState)
    @logger.info "Naive calculating move.."
    move = Move.new(Piece::WHITE_QUEEN_BEE, Piece::WHITE_BEETLE1, HexagonSide::UPPER_SIDE);  
    submitMove(move) 
  end
  
end
