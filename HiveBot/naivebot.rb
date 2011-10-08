require "Common/bot"
require "LoggerCreator"

class NaiveBot < Bot
      include DRbUndumped
  
  #attr_reader :logger
  
  def initialize(name)
    super("Naive Bot:#{name}") 
  end
 
  def determineNextMove(boardState)
    @logger.info "calculating move for #{@color}.."
    
    pieces = boardState.getPiecesByColor(@color)
    possibleMoves = Array.new()
    
    pieces.each do |piece|
       possibleMoves = possibleMoves + piece.availableMoves(boardState)
    end
    
    #pick a random move: 
    move = possibleMoves[rand(possibleMoves.length)]  
    submitMove(move) 
  end
  
end
