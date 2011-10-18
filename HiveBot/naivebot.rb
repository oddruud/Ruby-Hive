require "Common/bot"
require "LoggerCreator"

class NaiveBot < Bot
      include DRbUndumped
  
  #attr_reader :logger
  
  def initialize(name)
    super("Naive Bot:#{name}") 
  end
 
  def determineNextMove(boardState)
    @logger.debug "calculating move for #{@color}.."
    
    pieces = boardState.getPiecesByColor(@color)
    possibleMoves = Array.new()
    pieces.each do |piece|
       possibleMoves += piece.availableMoves(boardState)  
    end
    
    @logger.info "NUM possible Moves #{possibleMoves.length}"  
    
    #pick a random move: 
    move = possibleMoves[rand(possibleMoves.length)]  
    submitMove(move) 
  end
  
end
