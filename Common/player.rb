require 'boardstate'
require 'move'
require 'LoggerCreator'

class Player
  include DRbUndumped

  attr_accessor :name 
  attr_accessor :gameHandler
  attr_accessor :id 
  attr_reader :color
  attr_reader :logger
  attr_accessor :submitMoveTo
   
  def initialize(name)
   @name = name
   @logger = LoggerCreator.createLoggerForClass(Player)
  end

  def setID(id)
    @id= id
  end
  
  def setColor(color)
    @color = color
  end
    
  def gameStarts(message)
    @logger.info "GAME STARTS!"
    @logger.info "#{message}";  
  end
 
  def welcome(message)
    @logger.info "#{message}";  
  end    
   
  def makeMove(boardState)
    @logger.info "player's makemove called"
    submitMove(Move.new(0,0,0)) 
  end  
  
  def submitMove(move) 
      submitMoveTo.call(@id, move)
  end  
  
  def myPieces(boardState)
     return boardState.getPiecesByColor(@color)
  end

  def opponentPieces(boardState)
    pieces = []  
    PieceColor::COLORS.each do |color|
      unless color == @color 
        pieces = pieces + boardState.getPiecesByColor(color)
      end
    end
    return pieces
  end
end
